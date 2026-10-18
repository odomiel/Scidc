// ======================================================================
// Der Rekursionsdeckel der Zug-Decoder -- die wichtigste
// Sicherheitszusicherung der DB-Schicht.
//
// Alle Decoder lesen verschachtelte Varianten **rekursiv** aus
// Dateidaten. Eine praeparierte Datei mit tief verschachtelten
// Varianten wuerde den C-Stack sprengen. In jedem Decoder ist darum
// MaxVariationLevel = 300 eingezogen; bei Ueberschreitung wird
// abgebrochen (IOException mit Corrupted), nicht weiter abgestiegen.
//
// Geprueft wird hier an si3_decoder.cpp, das SI3, SI4 und SI5 abdeckt.
// Der Strom wird von Hand gebaut, denn genau das kann ein Angreifer
// auch: ein Byte 13 (token::Start_Marker) oeffnet eine Variante.
//
// Der Fall unterscheidet ausdruecklich **zwei** Ausnahmen:
//
//   * flach verschachtelt  -> der Strom geht aus (UnexpectedEndOfStream)
//   * tief verschachtelt   -> der Deckel greift  (IOException/Corrupted)
//
// Nur so belegt der Test, dass der Deckel feuert, und nicht bloss,
// dass irgendetwas geworfen wird.
// ======================================================================

#include "t_assert.h"

#include "si3_decoder.h"
#include "si3_common.h"

#include "db_game_data.h"
#include "db_exception.h"

#include "sys_utf8_codec.h"

#include "u_byte_stream.h"

#include <vector>

using namespace db;

namespace {

/// Ein Zugbyte, das aus der Standard-Startstellung gueltig ist (Figurnummer
/// in den oberen vier Bit, Richtung in den unteren -- gemessen, nicht
/// hergeleitet: ein Durchlauf ueber alle Bytes 16..255 liefert 53 gueltige).
unsigned const ValidMove = 0x27;

/// Baut einen SI3-Partiestrom: leerer Tag-Bereich, Standard-Startstellung,
/// dann so viele Ebenen wie verlangt.
///
/// token::Start_Marker allein genuegt nicht: der Decoder bricht mit
/// "corrupt data" ab, wenn eine Variante vor dem ersten Zug aufgeht
/// (si3_decoder.cpp, case token::Start_Marker). Vor jede Marke gehoert
/// also ein Zug. Da decodeVariation den Zug zurueckzieht
/// (push + undoMove), ist dasselbe Byte auf jeder Ebene wieder gueltig --
/// zwei Bytes je Ebene reichen fuer beliebige Tiefe. Genau so billig
/// kommt ein Angreifer an die Rekursion.
std::vector<util::ByteStream::Byte>
nestedVariations(unsigned depth)
{
	std::vector<util::ByteStream::Byte> data;

	data.push_back(0);                         // Ende des Tag-Bereichs
	data.push_back(0);                         // Flags: Standard-Startstellung

	for (unsigned i = 0; i < depth; ++i)
	{
		data.push_back(util::ByteStream::Byte(ValidMove));
		data.push_back(si3::token::Start_Marker);
	}

	return data;
}


/// Dekodiert den Strom. Liefert, welche Ausnahme kam.
enum Outcome { Nothing, EndOfStream, Corrupted, Other };

Outcome
decode(std::vector<util::ByteStream::Byte>& data)
{
	util::ByteStream strm(&data[0], unsigned(data.size()));
	sys::utf8::Codec codec(sys::utf8::Codec::utf8());
	si3::Decoder decoder(strm, codec);
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


TEST(Decoder, shallow_nesting_runs_out_of_stream)
{
	// Zehn Ebenen sind erlaubt; der Strom endet danach, also meldet der
	// Stromwaechter und nicht der Deckel.
	std::vector<util::ByteStream::Byte> data = nestedVariations(10);
	CHECK_EQ(decode(data), EndOfStream);
}


TEST(Decoder, at_the_limit_the_cap_holds_off)
{
	// 300 Ebenen sind noch zulaessig (level > MaxVariationLevel bricht ab).
	std::vector<util::ByteStream::Byte> data = nestedVariations(300);
	CHECK_EQ(decode(data), EndOfStream);
}


TEST(Decoder, deep_nesting_is_rejected)
{
	// Darueber greift der Deckel: abgebrochen, nicht abgestuerzt.
	std::vector<util::ByteStream::Byte> data = nestedVariations(302);
	CHECK_EQ(decode(data), Corrupted);
}


TEST(Decoder, absurd_nesting_is_rejected_too)
{
	// Was eine praeparierte Datei wirklich mitbringen wuerde.
	std::vector<util::ByteStream::Byte> data = nestedVariations(100000);
	CHECK_EQ(decode(data), Corrupted);
}


TEST(Decoder, the_cap_is_still_in_place)
{
	// Haelt den Wert fest: wer ihn hochsetzt, soll hier vorbeikommen.
	// 300 Ebenen kosten gemessen wenige Kilobyte Stack je Ebene.
	std::vector<util::ByteStream::Byte> ok = nestedVariations(300);
	std::vector<util::ByteStream::Byte> tooDeep = nestedVariations(301 + 1);
	CHECK_EQ(decode(ok), EndOfStream);
	CHECK_EQ(decode(tooDeep), Corrupted);
}

// vi:set ts=3 sw=3:
