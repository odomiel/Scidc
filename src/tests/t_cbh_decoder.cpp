// ======================================================================
// Der Rekursionsdeckel des CBH-Decoders (ChessBase, nur lesend) -- der
// letzte der sechs.
//
// cbh_game_decoder.cpp fuehrt MaxVariationDepth = 300; decodeMoves
// steigt bei jedem Token_Push eine C-Stack-Ebene ab. Geprueft war das
// bis hierher nicht.
//
// Zwei Eigenheiten des Formats bestimmen den Aufbau:
//
//  * **Jedes Byte ist gegen den Zugzaehler verschoben.** decodeMove
//    liest MoveNumberLookup[Byte(gStrm.get() - count)], und count
//    waechst mit jedem Zug (nicht mit einer Marke). Ein Rohbyte ist
//    also nur an *einer* Stelle des Stroms dasselbe Zeichen -- wer eine
//    feste Bytefolge wiederholt, liest ab dem zweiten Zug Zufall.
//  * **Push nimmt den Zug nicht zurueck** (Position::push() ist
//    m_stack.dup()). Die Stellung wandert also mit jeder Ebene weiter,
//    und ein fester Zug waere ab der zweiten Ebene ungueltig. Darum
//    **Nullzuege**: sie sind in jeder Stellung zulaessig und beliebig
//    oft wiederholbar.
//
// Die drei gebrauchten Tabellenplaetze stehen unten als Konstanten; sie
// sind aus MoveNumberLookup in cbh_decoder.cpp abgelesen
// (Wert 0x00 = Nullzug, 0xfe = Push, 0xff = Pop). Aendert die Tabelle,
// faellt das hier auf: der flache Fall kaeme dann nicht mehr ohne
// Ausnahme durch.
//
// Wie bei CBF endet ein ausgehender Strom **ohne** Ausnahme
// (remaining() == 0 liefert Token_Pop). Flach heisst darum Nothing, zu
// tief Corrupted -- der Unterschied belegt, dass der Deckel greift und
// nicht bloss irgendetwas schiefgeht.
// ======================================================================

#include "t_assert.h"

#include "cbh/cbh_game_decoder.h"

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

/// Plaetze in MoveNumberLookup (cbh_decoder.cpp).
unsigned const NullMoveIndex	= 170;
unsigned const PushIndex		= 220;
unsigned const PopIndex			= 12;


Byte
token(unsigned index, unsigned count)
{
	return Byte((index + count) & 0xff);         // decodeMove rechnet count ab
}


/// Ein Partiestrom mit so vielen Ebenen wie verlangt. closeInstead
/// schliesst statt zu oeffnen -- damit laesst sich belegen, dass der
/// Aufbau ueberhaupt gelesen wird.
Buffer
makeGame(unsigned depth, bool closeInstead = false)
{
	Buffer data;

	for (unsigned i = 0; i < 4; ++i)
		data.push_back(0);                        // uint32: keine Startstellung

	for (unsigned i = 0; i < depth; ++i)
	{
		data.push_back(::token(NullMoveIndex, i));         // Zug: count == i
		data.push_back(::token(closeInstead ? PopIndex : PushIndex, i + 1));
	}

	return data;
}


Outcome
decode(Buffer& data)
{
	util::ByteStream gStrm(&data[0], unsigned(data.size()));
	util::ByteStream aStrm;                       // keine Anmerkungen
	sys::utf8::Codec codec(sys::utf8::Codec::utf8());
	cbh::GameDecoder decoder(gStrm, aStrm, codec, false);
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

} // namespace


TEST(CbhDecoder, the_stream_is_read_at_all)
{
	// Gegenprobe zum Aufbau: ein Zug und eine schliessende Marke muessen
	// ohne Ausnahme durchlaufen. Scheitert das, stimmen die
	// Tabellenplaetze oben nicht mehr, und die Faelle unten wuerden
	// nichts messen.
	Buffer one = makeGame(1, true);
	CHECK_EQ(decode(one), Nothing);
}


TEST(CbhDecoder, the_cap_holds_the_recursion)
{
	// Flach: der Strom geht aus, und das ist hier kein Fehler.
	Buffer shallow = makeGame(10);
	CHECK_EQ(decode(shallow), Nothing);

	// Genau an der Grenze haelt der Deckel sich zurueck.
	Buffer atLimit = makeGame(300);
	CHECK_EQ(decode(atLimit), Nothing);

	// Darueber greift er: abgebrochen, nicht abgestuerzt.
	Buffer tooDeep = makeGame(302);
	CHECK_EQ(decode(tooDeep), Corrupted);

	// Was eine praeparierte Datei wirklich mitbringen wuerde.
	Buffer absurd = makeGame(100000);
	CHECK_EQ(decode(absurd), Corrupted);
}

// vi:set ts=3 sw=3:
