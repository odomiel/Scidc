// ======================================================================
// mstl::bf -- Bitdrehungen.
//
// rotate_left/rotate_right schoben um "sizeof(T)*8 - shift". Bei
// shift == 0 ist das eine Verschiebung um die ganze Breite des Typs und
// damit undefiniert -- gemessen mit -fsanitize=undefined:
// "m_bit_functions.ipp:307: shift exponent 64 is too large for 64-bit
// type" (Befund H5 des Audits vom 08.11.2026).
//
// Der Fall ist nicht entlegen, sondern der haeufigste: die Aufrufer
// uebergeben "count - 1" (db_board.cpp:505 ff., app_polyglot_book.cpp),
// und count == 1 heisst eine Figur im Bestand.
//
// Hier steht, was dabei herauskommen muss. Das ist kein
// Geschmacksurteil: diese Werte gehen als Stellungsschluessel in
// Datenbanken und Eroeffnungsbuecher, eine Drehung um 0 muss also der
// Bezeichner bleiben -- genau der Wert, den der x86-Befehl schon vorher
// lieferte.
//
// Zur Ehrlichkeit gehoert: dieser Fall **faellt am alten Stand nicht
// durch**. Der x86-Befehl maskiert die Weite, "x >> 64" ergab dort
// schon x -- gemessen, und genau deshalb aendern sich keine
// gespeicherten Schluessel. Was der Fall festhaelt, ist die Zusage;
// der Nachweis des Fehlers kommt aus -fsanitize=undefined, nicht aus
// der Reihe.
// ======================================================================

#include "t_assert.h"

#include "m_bit_functions.h"


TEST(BitFunctions, a_rotation_by_zero_is_the_identity)
{
	uint64_t const x = UINT64_C(0x0123456789abcdef);

	CHECK_EQ(mstl::bf::rotate_left(x, 0), x);
	CHECK_EQ(mstl::bf::rotate_right(x, 0), x);

	uint32_t const y = 0x01234567u;

	CHECK_EQ(mstl::bf::rotate_left(y, 0), y);
	CHECK_EQ(mstl::bf::rotate_right(y, 0), y);
}


TEST(BitFunctions, a_rotation_by_the_whole_width_is_the_identity)
{
	uint64_t const x = UINT64_C(0x0123456789abcdef);

	CHECK_EQ(mstl::bf::rotate_left(x, 64), x);
	CHECK_EQ(mstl::bf::rotate_right(x, 64), x);
	CHECK_EQ(mstl::bf::rotate_left(x, 65), mstl::bf::rotate_left(x, 1));
	CHECK_EQ(mstl::bf::rotate_right(x, 65), mstl::bf::rotate_right(x, 1));
}


TEST(BitFunctions, a_rotation_moves_the_bits_around)
{
	// Die eigentliche Zusage: nichts geht verloren, und die Richtungen
	// heben sich auf.
	uint64_t const x = UINT64_C(0x8000000000000001);

	CHECK_EQ(mstl::bf::rotate_left(x, 1), UINT64_C(0x0000000000000003));
	CHECK_EQ(mstl::bf::rotate_right(x, 1), UINT64_C(0xc000000000000000));

	for (unsigned shift = 1; shift < 64; ++shift)
	{
		CHECK_EQ(mstl::bf::rotate_right(mstl::bf::rotate_left(x, shift), shift), x);
		CHECK_EQ(mstl::bf::count_bits(mstl::bf::rotate_left(x, shift)), 2u);
	}
}

// vi:set ts=3 sw=3:
