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
// Der zweite Teil der Datei prueft die andere Sicherheits-Zusicherung
// derselben Decoder: **die Grenzen des Datenbereichs-Versatzes**. Der
// uint24-Versatz kommt aus der Datei und wird zu einem Zeiger
// verrechnet; ohne Pruefung gegen capacity() liest ein praeparierter
// Satz ausserhalb des Datensatzes (sectionPtr in sci_decoder.cpp und
// sci_v93_decoder.cpp, in v92 als eigene Zeilen). Geprueft wird beides:
// dass ein Versatz genau am Satzende noch durchgeht und einer ein Byte
// dahinter nicht.
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


namespace {

unsigned const TextSection	= 1u << 15;         // flags::TextSection
unsigned const TagSect		= 1u << 14;         // flags::TagSection
unsigned const HeaderSize	= 7;                 // Flags(2) + Versatz(3) + Lauf(2)


/// Ein Satz, dessen Kopf von Hand gesetzt ist: Flags, Versatz des
/// Datenbereichs und -- bei gesetztem TextSection -- das Laengenfeld
/// des Textbereichs. Zuege stehen keine darin; der Decoder prueft den
/// Versatz, bevor er welche liest. Kommt er durch, geht ihm hinterher
/// der Strom aus, und das unterscheidet die beiden Faelle.
Buffer
makeOffsetRecord(unsigned flags, unsigned offset, unsigned textSize, bool withTextSize)
{
	Buffer data;

	data.push_back(Byte((flags >> 8) & 0xff));
	data.push_back(Byte(flags & 0xff));

	data.push_back(Byte((offset >> 16) & 0xff));
	data.push_back(Byte((offset >> 8) & 0xff));
	data.push_back(Byte(offset & 0xff));

	data.push_back(0);                                 // Lauflaenge 0
	data.push_back(0);

	if (withTextSize)
	{
		data.push_back(Byte((textSize >> 16) & 0xff));
		data.push_back(Byte((textSize >> 8) & 0xff));
		data.push_back(Byte(textSize & 0xff));
	}

	return data;
}


template <typename Decode>
void
checkOffsetBounds(Decode decode)
{
	unsigned const idn = unsigned(variant::Standard);

	// Genau am Satzende: zulaessig (offset == capacity, keine Bytes
	// gebraucht). Danach geht der Strom aus -- der Versatz war also
	// nicht der Grund.
	Buffer atEnd = makeOffsetRecord(idn, HeaderSize, 0, false);
	CHECK_EQ(run(atEnd, decode), EndOfStream);

	// Ein Byte dahinter: abgewiesen.
	Buffer past = makeOffsetRecord(idn, HeaderSize + 1, 0, false);
	CHECK_EQ(run(past, decode), Corrupted);

	// Was eine praeparierte Datei mitbringen wuerde: der groesste
	// uint24. Ohne Pruefung waere das base() + 16 MB.
	Buffer far = makeOffsetRecord(idn, 0xffffff, 0, false);
	CHECK_EQ(run(far, decode), Corrupted);

	// Mit Textbereich: das Laengenfeld selbst kommt aus der Datei.
	// Null ist zulaessig ...
	Buffer emptyText = makeOffsetRecord(idn | TextSection, HeaderSize, 0, true);
	CHECK_EQ(run(emptyText, decode), EndOfStream);

	// ... eine Laenge, die ueber den Satz hinausreicht, nicht.
	Buffer hugeText = makeOffsetRecord(idn | TextSection, HeaderSize, 0xffffff, true);
	CHECK_EQ(run(hugeText, decode), Corrupted);

	// Und der Textbereich braucht sein Laengenfeld: drei Bytes, die es
	// hinter dem Versatz nicht mehr gibt.
	Buffer noRoom = makeOffsetRecord(idn | TextSection, HeaderSize, 0, false);
	CHECK_EQ(run(noRoom, decode), Corrupted);
}

/// Ein Satz mit Tag-Bereich: Kopf, dann [Tag-Byte][Wert][0].
///
/// Gemessen wird der aktuelle Decoder und v93 -- beide lesen den
/// Tag-Bereich am Anfang des Datenbereichs, gesteuert ueber das Flag.
/// v91 legt ihn hinter den Textbereich, v92 kennt das Flag gar nicht und
/// liest *nach* der Variante, was vom Datenbereich uebrig ist (und holt
/// seine Zugbytes aus dem Satzstrom, nicht aus dem Datenbereich). Beide
/// haben denselben Waechter, aber ein Satz, der dort wirklich bis
/// decodeTags kommt, sieht anders aus -- hier steht nur, was auch
/// gemessen ist.
///
/// Das Tag-Byte wird zu tag::ID, und damit greift tag::toName() in
/// NameLookup[] und TagSet::set() in Felder der Groesse tag::ExtraTag
/// (127) -- ein Byte reicht aber bis 255. Der Wert darf nicht leer sein
/// (TagSet::set besteht darauf), und tag::Event ist 0 und beendet die
/// Schleife, taugt hier also nicht als gueltiges Beispiel.
Buffer
makeTagRecord(Byte tagByte)
{
	Buffer data = makeOffsetRecord(unsigned(variant::Standard) | TagSect,
	                               HeaderSize, 0, false);

	data.push_back(tagByte);
	data.push_back(Byte('x'));                         // Wert, nicht leer
	data.push_back(0);                                 //   Abschluss
	data.push_back(0);                                 // Ende des Tag-Bereichs

	return data;
}


template <typename Decode>
void
checkTagBounds(Decode decode)
{
	// Ein gueltiges Tag geht durch; danach geht der Strom aus, weil keine
	// Zuege folgen. Dieser Ausgang gehoert dazu: ein Waechter, der alles
	// abweist, waere genauso "gruen" wie einer, der richtig trennt.
	Buffer good = makeTagRecord(Byte(tag::Site));
	CHECK_EQ(run(good, decode), EndOfStream);

	// tag::ExtraTag ist selbst kein gueltiges Tag, sondern die Marke fuer
	// ein benanntes Zusatz-Tag -- auch das muss durchgehen (Name und Wert
	// folgen, hier "x" und der leere Rest).
	Buffer extra = makeTagRecord(Byte(tag::ExtraTag));
	CHECK_EQ(run(extra, decode), EndOfStream);

	// Jenseits von ExtraTag: abgewiesen. Ohne den Waechter schreibt
	// TagSet::set hinter m_values[] -- mit Zusicherungen eine
	// Zusicherungsverletzung, ohne sie ein Schreibzugriff im Halde.
	Buffer beyond = makeTagRecord(Byte(tag::ExtraTag + 1));
	CHECK_EQ(run(beyond, decode), Corrupted);

	Buffer highest = makeTagRecord(0xff);
	CHECK_EQ(run(highest, decode), Corrupted);

	// Und die Luecke *innerhalb* des Bereichs: zwischen LastTag und
	// BughouseTag liegen die RESERVED_*-Werte. Die sind im Feld noch
	// drin, aber kein Tag -- tag::isValid sagt das, und toName() haette
	// dort einen Nullzeiger geliefert.
	Buffer reserved = makeTagRecord(Byte(tag::LastTag + 1));
	CHECK_EQ(run(reserved, decode), Corrupted);
}

} // namespace


TEST(SciTags, the_current_decoder_bounds_the_tag_id)
{
	checkTagBounds(decodeCurrent);
}


TEST(SciTags, v93_bounds_the_tag_id)
{
	checkTagBounds(decodeV93);
}



TEST(SciSection, the_current_decoder_bounds_the_offset)
{
	checkOffsetBounds(decodeCurrent);
}


TEST(SciSection, v93_bounds_the_offset)
{
	checkOffsetBounds(decodeV93);
}


TEST(SciSection, v92_bounds_the_offset)
{
	checkOffsetBounds(decodeV92);
}


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
