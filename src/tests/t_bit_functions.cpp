// ======================================================================
// mstl::bf -- Bitdrehungen und Bitindizes.
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
//
// Die zweite Gruppe steht anders da: msb_index() war fuer Byte- und
// Kurzwort-Breite **falsch**, und zwar fuer jede Eingabe. Sie faellt am
// alten Stand durch.
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

TEST(BitFunctions, the_index_of_the_highest_bit_counts_over_the_whole_value)
{
	// msb(uint8_t) zog von 7 ab, msb(uint16_t) von 15 -- clz() zaehlt aber
	// in der Breite von unsigned, also 32 Bit. Damit war das Ergebnis fuer
	// *jede* Eingabe negativ: msb_index(uint8_t(1)) ergab -24, als unsigned
	// 0xffffffe8. Aufgefallen ist es ueber ein Schieben mit dem Ergebnis
	// (db_board_base.cpp:601, -fsanitize=undefined).
	CHECK_EQ(mstl::bf::msb_index(uint8_t(1)), 0u);
	CHECK_EQ(mstl::bf::msb_index(uint8_t(0x80)), 7u);
	CHECK_EQ(mstl::bf::msb_index(uint8_t(0xff)), 7u);

	CHECK_EQ(mstl::bf::msb_index(uint16_t(1)), 0u);
	CHECK_EQ(mstl::bf::msb_index(uint16_t(0x8000)), 15u);

	CHECK_EQ(mstl::bf::msb_index(uint32_t(1)), 0u);
	CHECK_EQ(mstl::bf::msb_index(uint32_t(0x80000000u)), 31u);
	CHECK_EQ(mstl::bf::msb_index(UINT64_C(1) << 63), 63u);

	// Die eigentliche Zusage: derselbe Wert ergibt in jeder Breite denselben
	// Index. Genau das war verletzt, und nur die 32- und 64-Bit-Fassungen
	// hatten Aufrufer -- darum fiel es nie auf.
	for (unsigned bit = 0; bit < 8; ++bit)
	{
		CHECK_EQ(mstl::bf::msb_index(uint8_t(1u << bit)), bit);
		CHECK_EQ(mstl::bf::msb_index(uint16_t(1u << bit)), bit);
		CHECK_EQ(mstl::bf::msb_index(uint32_t(1u << bit)), bit);
		CHECK_EQ(mstl::bf::msb_index(UINT64_C(1) << bit), bit);
	}
}


TEST(BitFunctions, the_index_of_the_lowest_bit_does_not_depend_on_the_width)
{
	// Die Gegenprobe: lsb zaehlt von unten, ctz() ist darum von der Breite
	// unabhaengig -- diese Haelfte war auch vorher richtig, und ohne sie
	// belegte die Gruppe oben nicht, wo der Fehler sass.
	for (unsigned bit = 0; bit < 8; ++bit)
	{
		CHECK_EQ(mstl::bf::lsb_index(uint8_t(1u << bit)), bit);
		CHECK_EQ(mstl::bf::lsb_index(uint16_t(1u << bit)), bit);
		CHECK_EQ(mstl::bf::lsb_index(uint32_t(1u << bit)), bit);
		CHECK_EQ(mstl::bf::lsb_index(UINT64_C(1) << bit), bit);
	}

	CHECK_EQ(mstl::bf::lsb_index(uint8_t(0xff)), 0u);
	CHECK_EQ(mstl::bf::lsb_index(uint8_t(0x80)), 7u);
}


// vi:set ts=3 sw=3:
