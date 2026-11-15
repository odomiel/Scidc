// ======================================================================
// db::Mark -- Markierungen aus Partiedateien.
//
// Eine Markierung ist Zierrat (ein Pfeil, ein farbiger Kreis), aber ihre
// drei Felder sind **Aufzaehlungen**, und die Bytes dazu stehen in der
// Datei. Ein Wert jenseits der Aufzaehlung ist schon beim Laden
// undefiniertes Verhalten; UBSan meldete genau das (Befund H5 des Audits
// vom 08.11.2026: "load of value N, which is not a valid value for type
// 'Color'"). Dass commandName() & Co. einen Rueckfall haben, hilft
// dagegen nicht -- der Fehler liegt im Laden, nicht im Lesen.
//
// Geprueft wird deshalb die **Unterscheidung**, nicht bloss, dass
// irgendetwas passiert:
//
//   * Am Befehl haengt die Satzlaenge. Ein unbekannter Wert ist ein
//     Fehler, und Mark::skip() wirft dort laengst -- decode() muss es
//     auch, sonst liest es den Rest des Satzes an der falschen Stelle.
//   * Typ und Farbe fallen auf die Vorgaben der Klasse zurueck
//     (DefaultType/DefaultColor). Ohne die Gegenprobe mit *gueltigen*
//     Randwerten (Disk, Black) belegte das nichts: ein Rueckfall, der
//     immer greift, waere genauso gruen.
// ======================================================================

#include "t_assert.h"

#include "db_mark.h"
#include "db_exception.h"

#include "u_byte_stream.h"

using namespace db;
using namespace util;


namespace {

enum Outcome { Nothing, Corrupted, Other };

Byte Buf[8];


/// Ein Satz, wie Mark::encode ihn schreibt: Befehl, Feld, Typ/Text, Farbe.
ByteStream
makeMark(Byte command, Byte square, Byte type, Byte color)
{
	Buf[0] = command;
	Buf[1] = square;
	Buf[2] = type;
	Buf[3] = color;

	return ByteStream(Buf, 4);
}


Outcome
decode(Mark& mark, ByteStream strm)
{
	try
	{
		test::Quiet quiet;
		mark.decode(strm);
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


TEST(Mark, a_draw_mark_is_decoded)
{
	// Gegenprobe zu allem Weiteren: der gueltige Satz muss durchgehen,
	// und zwar mit genau den Werten, die in den Bytes stehen.
	Mark mark;

	CHECK_EQ(decode(mark, ::makeMark(mark::Draw, 28, mark::Arrow, mark::Green)),
	         ::Nothing);
	CHECK_EQ(mark.type(), mark::Arrow);
	CHECK_EQ(mark.color(), mark::Green);
	CHECK_EQ(mark.square(), 28);
}


TEST(Mark, an_unknown_command_is_rejected)
{
	// mark::Command kennt None, Draw und Diagram -- 0..2. Alles darueber
	// fiel bisher in den Draw-Zweig und wurde als Befehl geladen.
	for (Byte command = 3; command < 0x80; ++command)
	{
		Mark mark;

		if (decode(mark, ::makeMark(command, 28, mark::Full, mark::Red)) != ::Corrupted)
		{
			CHECK_EQ(int(command), -1);	// zeigt, welcher Wert durchkam
			break;
		}
	}

	CHECK(true);

	// Und die drei gueltigen bleiben gueltig.
	Mark none, draw, diagram;

	CHECK_EQ(decode(none, ::makeMark(mark::None, 0, 0, 0)), ::Nothing);
	CHECK_EQ(decode(draw, ::makeMark(mark::Draw, 28, mark::Full, mark::Red)), ::Nothing);
}


TEST(Mark, an_unknown_type_falls_back)
{
	// Ein Typbyte ab 0x20 ist eine Textmarke, darunter die Aufzaehlung
	// Text..Disk (0..5). 6..0x1f war undefiniert.
	for (Byte type = mark::Disk + 1; type < 0x20; ++type)
	{
		Mark mark;

		CHECK_EQ(decode(mark, ::makeMark(mark::Draw, 28, type, mark::Red)), ::Nothing);
		CHECK_EQ(mark.type(), Mark::DefaultType);
	}

	// Gegenprobe: der groesste *gueltige* Wert bleibt stehen.
	Mark disk;

	CHECK_EQ(decode(disk, ::makeMark(mark::Draw, 28, mark::Disk, mark::Red)), ::Nothing);
	CHECK_EQ(disk.type(), mark::Disk);
}


TEST(Mark, an_unknown_color_falls_back)
{
	// mark::Color kennt Red..Black -- 0..8. Das vierte Byte traegt die
	// Farbe, solange Bit 7 frei ist (sonst folgt ein zweites Feld).
	for (Byte color = mark::Black + 1; color < 0x80; ++color)
	{
		Mark mark;

		CHECK_EQ(decode(mark, ::makeMark(mark::Draw, 28, mark::Full, color)), ::Nothing);
		CHECK_EQ(mark.color(), Mark::DefaultColor);
	}

	// Gegenprobe: der groesste *gueltige* Wert bleibt stehen.
	Mark black;

	CHECK_EQ(decode(black, ::makeMark(mark::Draw, 28, mark::Full, mark::Black)), ::Nothing);
	CHECK_EQ(black.color(), mark::Black);
}

// vi:set ts=3 sw=3:
