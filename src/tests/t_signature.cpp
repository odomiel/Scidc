// ======================================================================
// db::Signature und db::HomePawns -- der Vorfilter der Stellungssuche.
//
// Die Suche laeuft nicht jede Partie durch: sie vergleicht erst die
// Signatur (Material, Rochaderechte, Bauern auf ihren Ausgangsfeldern)
// und ueberspringt eine Partie, wenn die gesuchte Stellung daraus
// nicht mehr erreichbar ist. Daraus folgt eine unsymmetrische
// Anforderung:
//
//   * Ein **falsches Nein** verliert Partien stillschweigend. Das ist
//     der Fehler, den niemand bemerkt, und darum stehen hier vor allem
//     Faelle, die belegen, dass tatsaechlich Erreichbares auch als
//     erreichbar gilt -- entlang einer wirklich gespielten Zugfolge.
//   * Ein **falsches Ja** kostet nur Zeit: die Partie wird dann
//     vollstaendig geprueft und fliegt dort heraus.
//
// Der Bauern-Teil der Signatur wird nicht vom Brett abgeleitet, sondern
// von HomePawns mitgefuehrt und von den Codecs aus dem Index gesetzt
// (si3_codec.cpp, db_consumer.cpp). Beides wird hier getrennt geprueft.
// ======================================================================

#include "t_assert.h"

#include "db_board.h"
#include "db_home_pawns.h"
#include "db_move.h"
#include "db_signature.h"

#include "m_string.h"

#include <stdio.h>

using namespace db;

namespace {

Board fromFen(char const* fen)
{
	Board board;
	board.setup(fen, variant::Normal);
	return board;
}

/// Spielt die Zugfolge und prueft nach jedem Halbzug, dass die
/// erreichte Stellung von der Ausgangssignatur aus als erreichbar gilt.
/// Meldet den Halbzug, an dem es scheitert -- sonst sagt ein roter Fall
/// nur, dass irgendwo etwas war.
void playAndCheckReachable(char const* const* line, unsigned count)
{
	Board board;
	board.setStandardPosition();

	Signature start = board.signature();

	for (unsigned i = 0; i < count; ++i)
	{
		Move move = board.parseMove(line[i], variant::Normal);

		if (!move.isLegal())
		{
			// Unbedingt von "nicht erreichbar" unterscheiden: ein Tippfehler
			// in der Zugfolge sah sonst wie ein Fehler im Vorfilter aus --
			// genau darauf bin ich beim Schreiben hereingefallen.
			char msg[128];
			::snprintf(msg, sizeof(msg),
							"gueltiger Zug Nr. %u (%s)", i + 1, line[i]);
			::test::failed(msg, __FILE__, __LINE__);
			return;
		}

		board.prepareUndo(move);
		board.doMove(move, variant::Normal);

		if (Signature::isReachable(start, board.signature()))
		{
			::test::passed();
		}
		else
		{
			char msg[128];
			::snprintf(msg, sizeof(msg),
							"erreichbar nach Halbzug %u (%s)", i + 1, line[i]);
			::test::failed(msg, __FILE__, __LINE__);
		}
	}
}

} // namespace


TEST(Signature, a_position_reaches_itself)
{
	char const* fens[] =
	{
		"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
		"r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 5 4",
		"4k3/8/8/8/8/8/4P3/4K3 w - - 0 1",
		"8/8/8/4k3/8/8/4K3/8 w - - 0 1",
	};

	for (unsigned i = 0; i < sizeof(fens)/sizeof(fens[0]); ++i)
	{
		Board board = fromFen(fens[i]);
		CHECK(Signature::isReachable(board.signature(), board.signature()));
	}
}


TEST(Signature, every_position_of_a_played_line_stays_reachable)
{
	// Die eine Eigenschaft, an der die Vollstaendigkeit der Suche haengt.
	// 20 Halbzuege mit Schlagzuegen, Rochade auf beiden Seiten und einer
	// Linie, auf der zeitweise DREI schwarze Bauern stehen (c7, c6, c3
	// nach dxc6 und dxc3). Genau das ist der Fall, bei dem ein knapp
	// gefuehrter Bauern-Fortschritt (pawns::Side hat nur zwei Rangbits
	// je Farbe) ein falsches Nein liefern wuerde.
	char const* line[] =
	{
		"e4", "e5", "Nf3", "Nc6", "Bb5", "a6", "Bxc6", "dxc6",
		"O-O", "Bg4", "h3", "Bxf3", "Qxf3", "Qd7", "d4", "exd4",
		"c3", "dxc3", "Nxc3", "O-O-O"
	};

	playAndCheckReachable(line, sizeof(line)/sizeof(line[0]));
}


TEST(Signature, the_past_is_not_reachable)
{
	// Genau hier verdient der Filter seinen Platz: ein Bauernzug und ein
	// Schlagzug lassen sich nicht zuruecknehmen.
	Board start;
	start.setStandardPosition();

	Board afterPawnMove =
		fromFen("rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1");
	Board afterCapture =
		fromFen("r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 5 4");
	Board endgame = fromFen("4k3/8/8/8/8/8/4P3/4K3 w - - 0 1");

	CHECK(Signature::isReachable(start.signature(), afterPawnMove.signature()));
	CHECK(!Signature::isReachable(afterPawnMove.signature(), start.signature()));

	CHECK(Signature::isReachable(start.signature(), endgame.signature()));
	CHECK(!Signature::isReachable(endgame.signature(), start.signature()));
	CHECK(!Signature::isReachable(endgame.signature(), afterCapture.signature()));
}


TEST(Signature, material_that_is_gone_stays_gone)
{
	Board endgame = fromFen("4k3/8/8/8/8/8/4P3/4K3 w - - 0 1");
	Board full;
	full.setStandardPosition();

	CHECK(endgame.signature().isReachableFinalMaterial(endgame.signature()));
	CHECK(!endgame.signature().isReachableFinalMaterial(full.signature()));
	CHECK(full.signature().isReachableFinalMaterial(endgame.signature()));
}


TEST(HomePawns, a_fresh_record_is_empty)
{
	HomePawns hp;

	CHECK_EQ(hp.used(), 0);

	// Die Signatur eines Bretts fuehrt die Bauern nicht selbst mit; sie
	// wird von den Codecs bzw. vom Consumer gesetzt. Ein frisch
	// aufgebautes Brett hat darum hpCount 0 -- das ist keine Luecke,
	// sondern die Arbeitsteilung.
	Board board;
	board.setStandardPosition();

	CHECK_EQ(board.signature().hpCount(), 0);
}


TEST(HomePawns, leaving_the_home_square_is_recorded)
{
	Board board;
	board.setStandardPosition();

	HomePawns hp;
	uint16_t before = hp.signature();

	Move move = board.parseMove("e4", variant::Normal);
	CHECK(move.isLegal());
	hp.move(move);

	CHECK_EQ(hp.used(), 1);
	CHECK(hp.signature() != before);

	// Ein Figurenzug ruehrt die Bauern nicht an.
	board.prepareUndo(move);
	board.doMove(move, variant::Normal);
	Move knight = board.parseMove("Nf6", variant::Normal);
	CHECK(knight.isLegal());

	uint16_t afterPawn = hp.signature();
	hp.move(knight);

	CHECK_EQ(hp.used(), 1);
	CHECK_EQ(hp.signature(), afterPawn);
}


TEST(HomePawns, the_record_never_exceeds_sixteen)
{
	// Der Zaehler geht in den Index und wird beim Lesen auf 16 geklemmt
	// (decodeIndex/decodeIndexSi5), sonst schreibt der Decoder ueber
	// seinen Stapelpuffer hinaus. Hier die Gegenprobe von der
	// schreibenden Seite: auch wenn jeder Bauer zieht, bleibt es bei 16.
	char const* line[] =
	{
		"a4", "a5", "b4", "b5", "c4", "c5", "d4", "d5",
		"e4", "e5", "f4", "f5", "g4", "g5", "h4", "h5",
	};

	Board board;
	board.setStandardPosition();

	HomePawns hp;

	for (unsigned i = 0; i < sizeof(line)/sizeof(line[0]); ++i)
	{
		Move move = board.parseMove(line[i], variant::Normal);

		if (!move.isLegal())
		{
			::test::failed(line[i], __FILE__, __LINE__);
			return;
		}

		hp.move(move);
		board.prepareUndo(move);
		board.doMove(move, variant::Normal);

		CHECK(hp.used() <= 16);
	}

	CHECK_EQ(hp.used(), 16);
}


TEST(HomePawns, index_round_trip)
{
	// Den Weg nehmen die Codecs: Zaehler und Daten stehen im Index, und
	// daraus wird die Signatur wieder aufgebaut (si3_codec.cpp:1485).
	Board board;
	board.setStandardPosition();

	HomePawns hp;
	char const* line[] = { "e4", "e5", "d4", "d5" };

	for (unsigned i = 0; i < 4; ++i)
	{
		Move move = board.parseMove(line[i], variant::Normal);
		CHECK(move.isLegal());
		hp.move(move);
		board.prepareUndo(move);
		board.doMove(move, variant::Normal);
	}

	HomePawns restored(hp.used(), hp.data());

	CHECK_EQ(restored.used(), hp.used());
	CHECK_EQ(restored.signature(), hp.signature());

	// Und derselbe Weg in die Signatur hinein.
	Signature sig = board.signature();
	sig.setHomePawns(hp.used(), hp.data());

	CHECK_EQ(sig.hpCount(), hp.used());
}

// vi:set ts=3 sw=3:
