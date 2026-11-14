// ======================================================================
// Der Rekursionsdeckel des CBF-Decoders (ChessBase-Altformat, nur
// lesend).
//
// Dasselbe Anliegen wie in t_decoder.cpp und t_sci_decoder.cpp: eine
// praeparierte Datei darf den C-Stack nicht sprengen.
// cbf_decoder.cpp fuehrt MaxVariationLevel = 300, und decodeVariation
// steigt rekursiv ab -- geprueft war das bis hierher nicht.
//
// CBF kostet mehr Vorbereitung als die anderen Formate, weil der
// Decoder einen vollstaendigen Partiekopf erwartet. Gebaut wird der
// kleinste Satz, der durch prepareDecoding kommt:
//
//   [0..13]   Kopf (14 Bytes, fest)
//     [2..3]  Laenge des Zugbereichs, grossendig
//     [4]     Laenge der Spielernamen (0)
//     [5]     Laenge der Quellenangabe (0)
//     [6..7]  Laenge des Textbereichs (1 -> leer, s.u.)
//     [10]    Bit 0: Stellung liegt bei; Bit 1: Schwarz am Zug
//   [14..]    Zugbereich
//   danach    Stellung (33 Bytes)
//
// Drei Dinge, die der Quelltext nicht von selbst verraet:
//
//  * **Der Zugbereich ist verschleiert.** prepareDecoding faehrt
//    xorBuffer darueber (ein mit 7 multiplizierter Schluessel, von
//    hinten nach vorne). Der Test muss dieselbe Rechnung anwenden,
//    sonst liest der Decoder Zufall. Das ist Teil des Dateiformats,
//    nicht ein Innenleben des Decoders.
//  * **Die Stellung muss mitgegeben werden.** Ohne Bit 0 in Byte 10
//    laesst setup() das Brett, wie der Entry-Konstruktor es anlegt --
//    leer. doMove() findet dann keine Figur und meldet "corrupt data",
//    und zwar fuer *jedes* Zugbyte: es sieht nach einem kaputten
//    Deckel aus und ist bloss ein leeres Brett.
//  * **Die Figurkodierung ist nicht die uebliche**: 1 Koenig, 2 Dame,
//    3 Springer, 4 Laeufer, 5 Turm, 6 Bauer (Schwarz +8). Zwei Felder
//    je Byte, a1 im oberen Halbbyte.
//
// Anders als bei SI3/SCI endet ein zu kurzer Zugbereich hier **ohne**
// Ausnahme: decodeVariation laeuft solange moves.remaining(). Flach
// verschachtelt heisst darum Nothing, zu tief Corrupted -- der
// Unterschied belegt, dass wirklich der Deckel greift.
// ======================================================================

#include "t_assert.h"

#include "cbf/cbf_decoder.h"

#include "db_game_data.h"
#include "db_exception.h"

#include "sys_utf8_codec.h"

#include "u_byte_stream.h"

#include <vector>

using namespace db;

namespace {

typedef util::ByteStream::Byte Byte;
typedef std::vector<Byte> Buffer;

enum Outcome { Nothing, EndOfStream, Corrupted, Other };

enum { Start_Marker = 0xff, End_Marker = 0x80 };

unsigned const HeaderSize	= 14;
unsigned const BoardSize	= 33;


/// Die Standardstellung in CBF-Kodierung: 32 Bytes zu zwei Feldern,
/// dann die Zugnummer.
void
appendStandardBoard(Buffer& data)
{
	static Byte const rank1[8] = { 5, 3, 4, 2, 1, 4, 3, 5 };   // T S L D K L S T
	Byte square[64];

	for (unsigned sq = 0; sq < 64; ++sq)
		square[sq] = 0;

	for (unsigned f = 0; f < 8; ++f)
	{
		square[f]				= rank1[f];                      // 1. Reihe weiss
		square[8 + f]			= 6;                             // 2. Reihe weisse Bauern
		square[48 + f]			= 6 + 8;                         // 7. Reihe schwarze Bauern
		square[56 + f]			= Byte(rank1[f] + 8);            // 8. Reihe schwarz
	}

	for (unsigned sq = 0; sq < 64; sq += 2)
		data.push_back(Byte((square[sq] << 4) | square[sq + 1]));

	data.push_back(0);                                          // Zugnummer - 1
}


/// Verschleiert den Zugbereich genau so, wie prepareDecoding ihn
/// wieder aufdeckt (xor ist sich selbst invers).
void
obfuscate(Byte* moveArea, unsigned moveAreaLength)
{
	if (moveAreaLength < 2)
		return;

	Byte* buf = moveArea + 1;
	unsigned bufLen = moveAreaLength - 2;
	Byte xorMask = Byte(49*moveAreaLength);

	for (int i = int(bufLen) - 1; i >= 0; --i, xorMask *= 7)
		buf[i] ^= xorMask;
}


/// Ein Satz mit so vielen Ebenen wie verlangt. closeInstead schliesst
/// die Variante statt sie zu oeffnen -- damit wird das Zugbyte gesucht.
Buffer
makeRecord(unsigned depth, Byte moveByte, bool closeInstead = false)
{
	unsigned const moveAreaLength	= 2*depth + 1;   // reset() gibt nur Laenge-1 frei
	unsigned const textPos			= HeaderSize + moveAreaLength;
	unsigned const size				= textPos + BoardSize;

	Buffer data;
	data.reserve(size);

	for (unsigned i = 0; i < HeaderSize; ++i)
		data.push_back(0);

	data[2] = Byte((moveAreaLength >> 8) & 0xff);
	data[3] = Byte(moveAreaLength & 0xff);
	data[6] = 0;                                     // Textlaenge 1 -> boardPos == textPos
	data[7] = 1;
	data[10] = 0x01;                                 // Stellung liegt bei

	for (unsigned i = 0; i < depth; ++i)
	{
		data.push_back(moveByte);
		data.push_back(Byte(closeInstead ? End_Marker : Start_Marker));
	}

	data.push_back(0);                               // Fuellbyte (nicht freigegeben)

	appendStandardBoard(data);

	::obfuscate(&data[HeaderSize], moveAreaLength);

	return data;
}


Outcome
decode(Buffer& data)
{
	util::ByteStream strm(&data[0], unsigned(data.size()));
	sys::utf8::Codec codec(sys::utf8::Codec::utf8());
	cbf::Decoder decoder(strm, codec);
	GameData game;

	test::Quiet quiet;

	try
	{
		decoder.doDecoding(game);
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


/// Das erste Byte, das aus der Standardstellung einen gueltigen Zug
/// ergibt. Der Decoder liest es als Nummer in der Zugliste (b & 0x7f);
/// gesetztes oberes Bit hiesse "Anmerkung folgt", darum nur bis 0x7f.
unsigned
validMoveByte()
{
	for (unsigned b = 1; b < End_Marker; ++b)
	{
		Buffer data = makeRecord(1, Byte(b), true);

		if (decode(data) == Nothing)
			return b;
	}

	return 0;
}

} // namespace


TEST(CbfDecoder, the_cap_holds_the_recursion)
{
	unsigned moveByte = validMoveByte();

	CHECK(moveByte != 0);

	if (moveByte == 0)
		return;

	// Flach: der Zugbereich geht aus, und das ist hier kein Fehler.
	Buffer shallow = makeRecord(10, Byte(moveByte));
	CHECK_EQ(decode(shallow), Nothing);

	// Genau an der Grenze haelt der Deckel sich zurueck.
	Buffer atLimit = makeRecord(300, Byte(moveByte));
	CHECK_EQ(decode(atLimit), Nothing);

	// Darueber greift er: abgebrochen, nicht abgestuerzt.
	Buffer tooDeep = makeRecord(302, Byte(moveByte));
	CHECK_EQ(decode(tooDeep), Corrupted);

	// Was eine praeparierte Datei wirklich mitbringen wuerde -- hier
	// 30000 Ebenen und nicht mehr: die Laenge des Zugbereichs steht im
	// Kopf als **16-Bit-Zahl**. Mit 100000 Ebenen braeuchte er 200001
	// Bytes, davon bleiben in Byte 2..3 nur 3 uebrig, und der Satz ist
	// in sich widersprueechlich -- der Decoder bricht dann aus einem
	// anderen Grund ab, und der Fall wuerde den Deckel nicht mehr
	// messen.
	Buffer absurd = makeRecord(30000, Byte(moveByte));
	CHECK_EQ(decode(absurd), Corrupted);
}

// vi:set ts=3 sw=3:
