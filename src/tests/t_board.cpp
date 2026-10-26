// ======================================================================
// db::Board -- Stellung, FEN und Zugausfuehrung.
//
// Das Brett ist die Stelle, an der Dateidaten zu einer Stellung werden.
// Drei Zusicherungen stehen hier:
//
//   * FEN ist der Austauschweg nach aussen (Export, Zwischenablage,
//     Stellungssuche). Was hineingeht, muss unveraendert herauskommen --
//     einschliesslich Rochaderechten, En-passant-Feld, Halbzugzaehler.
//   * validate() ist der Filter gegen unmoegliche Stellungen aus fremden
//     Dateien. Nimmt er sie an, rechnet der Zuggenerator darauf weiter.
//   * doMove/undoMove muessen sich genau aufheben. Der Decoder laeuft
//     Varianten mit push/undoMove ab; bleibt dabei etwas zurueck, wandert
//     der Fehler in jede folgende Variante.
//
// Die Faelle kommen ohne Datei aus: Board::initialize() im Pruefstand
// genuegt (siehe t_main.cpp).
// ======================================================================

#include "t_assert.h"

#include "db_board.h"
#include "db_move.h"

#include "m_string.h"

using namespace db;

namespace {

char const* StandardFen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";

Board fromFen(char const* fen)
{
	Board board;
	board.setup(fen, variant::Normal);
	return board;
}

mstl::string fen(Board const& board)
{
	return board.toFen(variant::Normal);
}

} // namespace


TEST(Board, standard_position)
{
	Board board;
	board.setStandardPosition();

	CHECK(board.isStandardPosition(variant::Normal));
	CHECK(board.whiteToMove());
	CHECK_EQ(fen(board), StandardFen);
	CHECK_EQ(board.computeIdn(variant::Normal), variant::Standard);
	CHECK_EQ(board.validate(variant::Normal), Board::Valid);
}


TEST(Board, fen_round_trip)
{
	// Jede Angabe muss erhalten bleiben: Seite am Zug, Rochaderechte,
	// En-passant-Feld, Halbzugzaehler, Zugnummer.
	char const* fens[] =
	{
		"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
		"rnbqkbnr/pp2pppp/8/2ppP3/8/8/PPPP1PPP/RNBQKBNR w KQkq d6 0 3",
		"r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 5 4",
		"8/8/8/4k3/8/8/4K3/8 w - - 0 1",
		"4k3/8/8/8/8/8/4P3/4K3 b - - 13 42",
	};

	for (unsigned i = 0; i < sizeof(fens)/sizeof(fens[0]); ++i)
		CHECK_EQ(fen(fromFen(fens[i])), fens[i]);
}


TEST(Board, xfen_drops_an_unusable_en_passant_square)
{
	// Hier steht kein weisser Bauer, der auf c6 nehmen koennte -- im
	// X-FEN entfaellt die Angabe dann. Das ist gewollt und kein
	// Datenverlust, aber wer FEN-Zeichenketten vergleicht, muss es
	// wissen.
	Board board = fromFen("rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2");

	CHECK_EQ(fen(board), "rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2");
}


TEST(Board, garbage_fen_is_rejected)
{
	CHECK(!Board::isValidFen("", variant::Normal));
	CHECK(!Board::isValidFen("nonsense", variant::Normal));
	CHECK(!Board::isValidFen("8/8/8/8/8/8/8/8 w - - 0 1", variant::Normal));

	// Bauern auf der ersten und achten Reihe faengt schon der Leser ab,
	// nicht erst validate(): setup() laesst das Brett dann leer.
	CHECK(!Board::isValidFen("4k3/8/8/8/8/8/8/p3K3 w - - 0 1", variant::Normal));
	CHECK(!Board::isValidFen("P3k3/8/8/8/8/8/8/4K3 w - - 0 1", variant::Normal));

	CHECK(Board::isValidFen(StandardFen, variant::Normal));
}


TEST(Board, validate_rejects_impossible_positions)
{
	// Genau die Faelle, die eine praeparierte oder kaputte Datei
	// mitbringt.
	CHECK_EQ(fromFen("8/8/8/4k3/8/8/8/8 w - - 0 1").validate(variant::Normal),
				Board::NoWhiteKing);
	CHECK_EQ(fromFen("8/8/8/8/8/8/4K3/8 w - - 0 1").validate(variant::Normal),
				Board::NoBlackKing);
	CHECK_EQ(fromFen("4k3/pppppppp/p7/8/8/8/4K3/8 w - - 0 1").validate(variant::Normal),
				Board::TooManyBlackPawns);
	CHECK_EQ(fromFen("4k3/PPPPPPPP/P7/8/8/8/4K3/8 w - - 0 1").validate(variant::Normal),
				Board::TooManyWhitePawns);
	CHECK_EQ(fromFen(StandardFen).validate(variant::Normal), Board::Valid);
}


TEST(Board, do_and_undo_restore_the_position)
{
	// Der Decoder laeuft jede Variante mit undoMove zurueck; bleibt dabei
	// etwas stehen, wird jede folgende Variante falsch dekodiert.
	Board board;
	board.setStandardPosition();

	mstl::string before = fen(board);
	Move move = board.parseMove("e4", variant::Normal);

	CHECK(move.isLegal());

	board.prepareUndo(move);
	board.doMove(move, variant::Normal);

	CHECK(!board.whiteToMove());
	CHECK(fen(board) != before);

	board.undoMove(move, variant::Normal);

	CHECK(board.whiteToMove());
	CHECK_EQ(fen(board), before);
}


TEST(Board, a_whole_opening_line_undoes_cleanly)
{
	char const* line[] = { "e4", "e5", "Nf3", "Nc6", "Bb5", "a6", "Ba4", "Nf6", "O-O" };
	unsigned const count = sizeof(line)/sizeof(line[0]);

	Board board;
	board.setStandardPosition();

	mstl::string start = fen(board);
	Move moves[count];

	for (unsigned i = 0; i < count; ++i)
	{
		moves[i] = board.parseMove(line[i], variant::Normal);

		if (!moves[i].isLegal())
		{
			::test::failed(line[i], __FILE__, __LINE__);
			return;
		}

		board.prepareUndo(moves[i]);
		board.doMove(moves[i], variant::Normal);
	}

	CHECK_EQ(board.validate(variant::Normal), Board::Valid);

	for (unsigned i = count; i > 0; --i)
		board.undoMove(moves[i - 1], variant::Normal);

	CHECK_EQ(fen(board), start);
}


TEST(Board, illegal_move_is_not_parsed)
{
	Board board;
	board.setStandardPosition();

	CHECK(!board.parseMove("e5", variant::Normal).isLegal());
	CHECK(!board.parseMove("Ke2", variant::Normal).isLegal());
	CHECK(!board.parseMove("Zz9", variant::Normal).isLegal());
}


TEST(Board, check_and_mate_are_recognised)
{
	Board quiet;
	quiet.setStandardPosition();

	CHECK_EQ(quiet.checkState(variant::Normal), Board::NoCheck);
	CHECK(!quiet.gameIsOver(variant::Normal));

	// Narrenmatt: 1.f3 e5 2.g4 Qh4#
	Board mate = fromFen("rnb1kbnr/pppp1ppp/8/4p3/6Pq/5P2/PPPPP2P/RNBQKBNR w KQkq - 1 3");
	unsigned state = mate.checkState(variant::Normal);

	CHECK(state & Board::Check);
	CHECK(state & Board::Checkmate);
	CHECK(mate.gameIsOver(variant::Normal));

	// Schach, aber kein Matt: dieselbe Dame einen Zug zuvor.
	Board check = fromFen("rnbqkbnr/pppp1ppp/8/4p3/7P/5P2/PPPPP1P1/RNBQKBNR b KQkq - 0 2");

	CHECK_EQ(check.checkState(variant::Normal) & Board::Checkmate, 0);
}


TEST(Board, stalemate_is_reported_at_all)
{
	// Rueckfall-Probe. checkState() konnte im Normalschach nie Stalemate
	// melden: die Kurzschlussauswertung in
	//    if (!(state & Check) || findAnyLegalMove(variant))
	// sprang ohne Schach ueber die Zugsuche hinweg, und der
	// Stalemate-Zweig darunter war damit toter Code. Betroffen waren die
	// Partie-Beendigung, der PGN-Leser, die CQL-Bedingung "stalemate",
	// die Engine-Anzeige und Probe::probe (dort galt ein Patt als
	// Illegal_Position).
	Board board = fromFen("7k/5Q2/6K1/8/8/8/8/8 b - - 0 1");
	unsigned state = board.checkState(variant::Normal);

	CHECK(state & Board::Stalemate);
	CHECK_EQ(state & Board::Check, 0);
	CHECK_EQ(state & Board::Checkmate, 0);
	CHECK(board.gameIsOver(variant::Normal));

	// Zweite Patt-Stellung, damit nicht eine Einzelheit der ersten traegt.
	Board second = fromFen("8/8/8/8/8/5k2/5p2/5K2 w - - 0 1");
	unsigned state2 = second.checkState(variant::Normal);

	CHECK(state2 & Board::Stalemate);
	CHECK_EQ(state2 & Board::Checkmate, 0);
}


TEST(Board, idn_setup_matches_the_standard_position)
{
	// Die Aufstellungsnummer ist Teil des Dateiformats (Chess 960).
	Board byIdn;
	byIdn.setup(variant::Standard, variant::Normal);

	Board standard;
	standard.setStandardPosition();

	CHECK_EQ(fen(byIdn), fen(standard));
	CHECK_EQ(byIdn.computeIdn(variant::Normal), variant::Standard);
}


TEST(Board, idn_round_trip_over_all_shuffle_positions)
{
	// Jede der 960 Aufstellungen muss ihre eigene Nummer zurueckgeben,
	// sonst oeffnet eine gespeicherte Partie mit falschem Brett.
	unsigned broken = 0;

	for (unsigned idn = 1; idn <= 960; ++idn)
	{
		Board board;
		board.setup(idn, variant::Normal);

		if (board.computeIdn(variant::Normal) != idn)
			++broken;
		if (board.validate(variant::Normal) != Board::Valid)
			++broken;
	}

	CHECK_EQ(broken, 0);
}

// vi:set ts=3 sw=3:
