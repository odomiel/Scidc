// ======================================================================
// Der Rekursionsdeckel der SCI-Decoder -- vier Stueck, nicht einer.
//
// t_decoder.cpp prueft si3_decoder.cpp (SI3/4/5). Das native Format hat
// vier eigene Decoder: den aktuellen und die drei Lesefassungen fuer
// aeltere Dateien (v91, v92, v93). Jeder hat seinen eigenen
// MaxVariationLevel = 300 und seine eigene decodeVariation -- ein
// versehentlich entferntes "depth + 1" faellt nur dort auf, wo auch
// geprueft wird. Bis hierher war genau einer von sechs Decodern
// gedeckt.
//
// Der Satzaufbau wird von Hand gebaut, denn genau das kann ein
// Angreifer auch:
//
//   aktuell / v92 / v93:  [Flags+IDN:2][Versatz Datenbereich:3][Lauf:2] Zuege...
//   v91:                  [IDN:2][Versatz:3 (uebersprungen)][Lauf:2]    Zuege...
//
// Ein Zugbyte >= token::Special_Move (5) ist ein Zug, 3 oeffnet eine
// Variante, 4 schliesst sie. Vor jeder Marke muss ein Zug stehen (sonst
// bricht der Decoder mit "corrupt data" ab, bevor der Deckel in Frage
// kommt); weil decodeVariation den Zug zurueckzieht, ist dasselbe Byte
// auf jeder Ebene wieder gueltig -- zwei Bytes je Ebene genuegen fuer
// beliebige Tiefe.
//
// Welches Byte ein gueltiger Zug ist, wird **gemessen statt geraten**:
// die Figurnummer steckt in den oberen vier Bit und haengt an der
// Figurliste der Startstellung. Ein falsch geratenes Byte sieht wie ein
// Fehler im Prueflichen aus (M_ASSERT in decodeMove wirft) -- darum
// sucht validMoveByte() es und der Fall belegt, dass eines gefunden
// wurde.
// ======================================================================

#include "t_assert.h"

#include "sci_decoder.h"
#include "sci_common.h"

#include "v91/sci_v91_decoder.h"
#include "v92/sci_v92_decoder.h"
#include "v93/sci_v93_decoder.h"

#include "db_game_data.h"
#include "db_exception.h"

#include "u_byte_stream.h"

#include <vector>

using namespace db;

namespace {

typedef util::ByteStream::Byte Byte;
typedef std::vector<Byte> Buffer;

enum Outcome { Nothing, EndOfStream, Corrupted, Other };

/// Satzkopf: Flags mit der IDN der Standardstellung, Versatz auf das
/// Satzende (also ein leerer Datenbereich -- die Faelle hier lesen
/// keinen Nag und keinen Kommentar), Laufzaehler 0.
void
appendHeader(Buffer& data, unsigned recordSize)
{
	// ByteStream liest **grossendig** (u_byte_stream.ipp: data[0] << 8 |
	// data[1]). Kleinendig geschrieben wird aus 518 die Zahl 1538, und
	// aus einem Versatz von 9 die Zahl 589824 -- sectionPtr bricht dann
	// mit "corrupt data" ab, noch bevor ein Zug gelesen ist. Genau das
	// hat der erste Anlauf getan.
	data.push_back(Byte(variant::Standard >> 8));
	data.push_back(Byte(variant::Standard & 0xff));

	data.push_back(Byte((recordSize >> 16) & 0xff));   // uint24, grossendig
	data.push_back(Byte((recordSize >> 8) & 0xff));
	data.push_back(Byte(recordSize & 0xff));

	data.push_back(0);                                 // Lauflaenge 0
	data.push_back(0);
}


Buffer
makeRecord(unsigned depth, Byte moveByte, bool closeInstead = false)
{
	// Kopfgroesse 7 + zwei Bytes je Ebene: der Versatz muss auf das
	// **tatsaechliche** Ende zeigen, sonst liegt der Datenbereich mitten
	// in den Zuegen -- und bleibt dort ein Byte uebrig, liest v92 es nach
	// der Variante noch als Tag-Bereich (decodeTags) und bricht ab. Der
	// erste Anlauf liess den Schlussmarker aus der Rechnung und fand
	// darum fuer v92 kein einziges gueltiges Zugbyte.
	unsigned const size = 7 + 2*depth + (closeInstead ? 1 : 0);
	Buffer data;

	appendHeader(data, size);

	for (unsigned i = 0; i < depth; ++i)
	{
		data.push_back(moveByte);
		data.push_back(closeInstead ? sci::token::End_Marker : sci::token::Start_Marker);
	}

	if (closeInstead)
		data.push_back(sci::token::End_Marker);        // der zweite Token nach End_Marker

	return data;
}


template <typename Decode>
Outcome
run(Buffer& data, Decode decode)
{
	util::ByteStream strm(&data[0], unsigned(data.size()));
	GameData game;

	test::Quiet quiet;

	try
	{
		decode(strm, game);
	}
	catch (util::ByteStream::UnexpectedEndOfStreamException const&)
	{
		return EndOfStream;
	}
	catch (IOException const& exc)
	{
		return exc.errorType() == IOException::Corrupted ? Corrupted : Other;
	}
	catch (...)
	{
		return Other;
	}

	return Nothing;
}


void decodeCurrent(util::ByteStream& strm, GameData& game)
{
	sci::Decoder(strm, variant::Normal).doDecoding(game);
}

void decodeV91(util::ByteStream& strm, GameData& game)
{
	sci::v91::Decoder(strm).doDecoding(game);
}

void decodeV92(util::ByteStream& strm, GameData& game)
{
	sci::v92::Decoder(strm).doDecoding(game);
}

void decodeV93(util::ByteStream& strm, GameData& game)
{
	sci::v93::Decoder(strm, variant::Normal).doDecoding(game);
}


/// Das erste Byte, das aus der Standardstellung einen gueltigen Zug
/// ergibt -- ueber eine Partie mit genau einem Zug gemessen.
template <typename Decode>
unsigned
validMoveByte(Decode decode)
{
	for (unsigned b = sci::token::Special_Move + 1; b < 256; ++b)
	{
		Buffer data = makeRecord(1, Byte(b), true);

		if (run(data, decode) == Nothing)
			return b;
	}

	return 0;
}


/// Der Pruefgang je Decoder. Welcher gerade laeuft, nennt der Laeufer
/// ueber den Fallnamen -- darum braucht es hier keinen Namen.
template <typename Decode>
void
checkCap(Decode decode)
{
	unsigned moveByte = validMoveByte(decode);

	CHECK(moveByte != 0);

	if (moveByte == 0)
		return;                                        // sonst messen die Faelle nichts

	// Flach: der Strom geht aus, der Deckel kommt nicht in Frage.
	Buffer shallow = makeRecord(10, Byte(moveByte));
	CHECK_EQ(run(shallow, decode), EndOfStream);

	// Genau an der Grenze haelt er sich zurueck (level > 300 bricht ab).
	Buffer atLimit = makeRecord(300, Byte(moveByte));
	CHECK_EQ(run(atLimit, decode), EndOfStream);

	// Darueber greift er: abgebrochen, nicht abgestuerzt.
	Buffer tooDeep = makeRecord(302, Byte(moveByte));
	CHECK_EQ(run(tooDeep, decode), Corrupted);

	// Was eine praeparierte Datei wirklich mitbringen wuerde.
	Buffer absurd = makeRecord(100000, Byte(moveByte));
	CHECK_EQ(run(absurd, decode), Corrupted);
}

} // namespace


TEST(SciDecoder, the_current_decoder_caps_the_recursion)
{
	checkCap(decodeCurrent);
}


TEST(SciDecoder, v93_caps_the_recursion)
{
	checkCap(decodeV93);
}


TEST(SciDecoder, v92_caps_the_recursion)
{
	checkCap(decodeV92);
}


TEST(SciDecoder, v91_caps_the_recursion)
{
	checkCap(decodeV91);
}

// vi:set ts=3 sw=3:
