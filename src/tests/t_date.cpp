// ======================================================================
// db::Date -- Datumsangaben aus Partiedateien.
//
// Zwei Gruende, warum das hier steht und nicht als Nebensache gilt:
//
//   * Ein Datum aus einer Datei ist **unvollstaendig erlaubt** (nur Jahr,
//     Jahr und Monat). Vergleiche und Sortierungen muessen damit
//     zurechtkommen, ohne eine teilweise Angabe zu einer vollen zu
//     verdichten.
//   * Das Jahr wird im Index **auf 10 Bit** zusammengelegt
//     (encodeYearTo10Bits). Der Umweg ist Teil des Dateiformats: faellt
//     er auseinander, verschieben sich Jahreszahlen in jeder
//     gespeicherten Partie. Darum wird der Umlauf hier ueber den
//     gesamten erlaubten Bereich gefahren, nicht an einem Beispiel.
// ======================================================================

#include "t_assert.h"

#include "db_date.h"

#include "m_string.h"

using namespace db;


TEST(Date, full_date_from_pgn_string)
{
	Date d(mstl::string("1999.12.31"));

	CHECK_EQ(d.year(), 1999);
	CHECK_EQ(d.month(), 12);
	CHECK_EQ(d.day(), 31);
	CHECK(d.isFull());
	CHECK(!d.isEmpty());
	CHECK_EQ(d.asString(), "1999.12.31");
}


TEST(Date, partial_date_stays_partial)
{
	// Die haeufigste Form in alten Bestaenden: nur das Jahr ist bekannt.
	Date year(mstl::string("1999.??.??"));

	CHECK_EQ(year.year(), 1999);
	CHECK_EQ(year.month(), 0);
	CHECK_EQ(year.day(), 0);
	CHECK(!year.isFull());
	CHECK(!year.isEmpty());
	CHECK_EQ(year.asString(), "1999.??.??");

	Date month(mstl::string("1999.07.??"));

	CHECK_EQ(month.month(), 7);
	CHECK_EQ(month.day(), 0);
	CHECK(!month.isFull());
	CHECK_EQ(month.asString(), "1999.07.??");
}


TEST(Date, empty_date)
{
	Date d;

	CHECK(d.isEmpty());
	CHECK(!d.isFull());
	CHECK_EQ(d.year(), 0);
}


TEST(Date, invalid_dates_are_rejected)
{
	// Der 30. Februar steht in echten Dateien; er darf nicht durchgehen.
	CHECK(!Date::isValid(1999u, 2u, 30u));
	CHECK(!Date::isValid(1999u, 13u, 1u));
	CHECK(!Date::isValid(1999u, 0u, 1u));
	CHECK(!Date::isValid(1999u, 1u, 32u));
	CHECK(Date::isValid(1999u, 2u, 28u));
}


TEST(Date, year_range_is_the_one_the_index_can_hold)
{
	CHECK(!Date::isValidYear(Date::MinYear - 1));
	CHECK(Date::isValidYear(Date::MinYear));
	CHECK(Date::isValidYear(Date::MaxYear));
	CHECK(!Date::isValidYear(Date::MaxYear + 1));
}


TEST(Date, leap_years)
{
	CHECK_EQ(Date::lastDayInMonth(2000u, 2u), 29);	// durch 400 teilbar
	CHECK_EQ(Date::lastDayInMonth(1900u, 2u), 28);	// durch 100, nicht 400
	CHECK_EQ(Date::lastDayInMonth(2024u, 2u), 29);
	CHECK_EQ(Date::lastDayInMonth(2023u, 2u), 28);
	CHECK_EQ(Date::lastDayInMonth(2023u, 4u), 30);
	CHECK_EQ(Date::lastDayInMonth(2023u, 12u), 31);
}


TEST(Date, ten_bit_year_round_trip_over_the_whole_range)
{
	// Jedes erlaubte Jahr muss den Umweg ueber 10 Bit unveraendert
	// ueberstehen, und kein Jahr darf auf die Kennung "kein Jahr" fallen.
	unsigned const none = Date::encodeYearTo10Bits(0);

	CHECK_EQ(Date::decodeYearFrom10Bits(none), 0);

	unsigned clashes = 0;
	unsigned broken = 0;

	for (unsigned y = Date::MinYear; y <= Date::MaxYear; ++y)
	{
		unsigned bits = Date::encodeYearTo10Bits(y);

		if (bits > 0x3ff)
			++broken;
		if (bits == none)
			++clashes;
		if (Date::decodeYearFrom10Bits(bits) != y)
			++broken;
	}

	CHECK_EQ(broken, 0);
	CHECK_EQ(clashes, 0);
}


TEST(Date, comparison)
{
	Date a(1999u, 12u, 30u);
	Date b(1999u, 12u, 31u);
	Date c(2000u, 1u, 1u);

	CHECK(a < b);
	CHECK(b < c);
	CHECK(a < c);
	CHECK(b > a);
	CHECK(a == Date(1999u, 12u, 30u));
	CHECK(a != b);
	CHECK(a <= a);
	CHECK(a >= a);
}


TEST(Date, isBetween_and_isPartial)
{
	Date d(1999u, 6u, 15u);

	CHECK(d.isBetween(Date(1999u, 1u, 1u), Date(1999u, 12u, 31u)));
	CHECK(!d.isBetween(Date(2000u, 1u, 1u), Date(2000u, 12u, 31u)));

	// isPartial(x) fragt, ob x eine unscharfe Fassung von *this ist. Die
	// Funktion hat keinen einzigen Aufrufer, und ihre beiden Zweige sind
	// nicht symmetrisch: ein fehlender Tag gilt als Treffer, ein
	// fehlender Monat nicht. Festgehalten wird darum das gemessene
	// Verhalten -- wer das aendert, soll hier vorbeikommen und zuerst
	// einen Aufrufer haben.
	CHECK(d.isPartial(Date(1999u, 6u, 15u)));	// gleiche Angabe
	CHECK(d.isPartial(Date(1999u, 6u)));			// Tag offen  -> Treffer
	CHECK(!d.isPartial(Date(1999u)));				// Monat offen -> kein Treffer
	CHECK(d.isPartial(Date()));						// leer deckt alles ab
	CHECK(!d.isPartial(Date(1998u, 6u, 15u)));
}


TEST(Date, julian_day_and_adding_days)
{
	// Der Julianische Tag muss streng steigen; darauf beruht addDays.
	CHECK(Date::julianDay(1999u, 12u, 31u) + 1 == Date::julianDay(2000u, 1u, 1u));
	CHECK(Date::julianDay(2000u, 2u, 28u) + 1 == Date::julianDay(2000u, 2u, 29u));
	CHECK(Date::julianDay(1900u, 2u, 28u) + 1 == Date::julianDay(1900u, 3u, 1u));

	Date d(1999u, 12u, 31u);
	CHECK(d.addDays(1));
	CHECK_EQ(d.asString(), "2000.01.01");

	Date e(2000u, 2u, 28u);
	CHECK(e.addDays(1));
	CHECK_EQ(e.asString(), "2000.02.29");
}


TEST(Date, limits_are_valid_dates)
{
	CHECK(Date::minDate().isValid());
	CHECK(Date::maxDate().isValid());
	CHECK(Date::minDate() < Date::maxDate());
	CHECK_EQ(Date::minDate().year(), Date::MinYear);
	CHECK_EQ(Date::maxDate().year(), Date::MaxYear);
}

// vi:set ts=3 sw=3:
