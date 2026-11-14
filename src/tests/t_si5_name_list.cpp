// ======================================================================
// Die Namensliste unter SI5 -- eine Falle, die Daten verfaelscht hat.
//
// db::si3::NameList ist fuer SI3/SI4 entworfen, wo die Eintraege der
// Namensbasis **alphabetisch** gespeichert sind: dort ist die ID eines
// Eintrags gleich seiner Position in der sortierten Liste. Unter SI5
// sind die Eintraege in **Einfuege-Reihenfolge** abgelegt, die ID ist
// also eine Dateiposition -- und damit gilt die Gleichsetzung nicht
// mehr.
//
// Daraus folgen die drei Regeln, die in CLAUDE.md stehen und die hier
// gemessen werden, statt nur behauptet zu sein:
//
//   1. NameList::update() gehoert nicht in einen SI5-Schreibpfad.
//   2. Die Groesse des Namensvektors in writeNamebasesSi5 kommt von
//      NameList::size(), nicht von Namebase::size().
//   3. Ein nach dem Oeffnen angelegter Eintrag (ID >= size()) steht
//      nicht in m_lookup und muss aus der Namensbasis kommen.
//
// Nachgebildet wird der Aufbau aus readNamebasesSi5: erst in die
// Namensbasis einfuegen (die sortiert und gleiche Namen zusammenlegt),
// dann ueber die sortierte Basis append(), dann die zusammengelegten
// Dateipositionen mit aliasId() nachtragen.
// ======================================================================

#include "t_assert.h"

#include "si3_name_list.h"

#include "db_namebase.h"
#include "db_namebase_entry.h"

#include "sys_utf8_codec.h"

#include "m_string.h"

#include <vector>

using namespace db;

namespace {

unsigned const Limit = 100;

/// Namensbasis und Namensliste, aufgebaut wie in readNamebasesSi5.
///
/// Die Rundennamen sind der einfachste Fall: Namebase::insert(name, id,
/// limit) nimmt die Dateiposition als ID und liefert bei gleichem Namen
/// den **vorhandenen** Eintrag zurueck -- genau dort entstehen die
/// Alias-Positionen.
struct Bestand
{
	Bestand() :base(Namebase::Round), codec(::sys::utf8::Codec::utf8()) {}

	void aufbauen(std::vector<char const*> const& namen, bool nextIdNachziehen = true)
	{
		list.reserve(namen.size() + 1);

		std::vector<Namebase::Entry*> kanon(namen.size(), 0);

		for (unsigned i = 0; i < namen.size(); ++i)
		{
			kanon[i] = base.insert(mstl::string(namen[i]), i, Limit);
			// Nur benutzte Eintraege kommen in buildList; ohne Haeufigkeit
			// waere jeder Durchlauf von update() leer.
			kanon[i]->setFrequency(kanon[i]->frequency() + 1);
		}

		for (unsigned i = 0; i < base.size(); ++i)
			list.append(base.entryAt(i)->name(), base.entryAt(i)->id(), base.entryAt(i), codec);

		for (unsigned fp = 0; fp < namen.size(); ++fp)
			if (!list.hasId(fp) && kanon[fp])
				list.aliasId(fp, kanon[fp]->id());

		list.finish();

		// readNamebasesSi5 setzt nextId **nicht** -- der Wert bleibt auf 0,
		// waehrend die Eintraege Dateipositionen tragen. Fuer die Faelle, die
		// update() ueberhaupt bis in buildList kommen lassen wollen, wird er
		// hier nachgezogen; der erste Fall unten zeigt den Zustand ohne.
		if (nextIdNachziehen)
			base.setNextId(namen.size());
	}

	Namebase					base;
	si3::NameList			list;
	::sys::utf8::Codec	codec;
};

} // namespace


TEST(Si5NameList, the_id_is_the_file_position)
{
	Bestand b;
	std::vector<char const*> namen;
	namen.push_back("Vorrunde");			// Dateiposition 0, sortiert zuletzt
	namen.push_back("Endrunde");			// Dateiposition 1, sortiert zuerst
	namen.push_back("Halbfinale");		// Dateiposition 2

	b.aufbauen(namen);

	CHECK_EQ(b.base.size(), 3u);
	CHECK_EQ(b.list.size(), 3u);

	// Sortierung und Dateiposition laufen auseinander -- sonst wuerde
	// die Verwechslung aus Regel 1 ueberhaupt nicht auffallen.
	CHECK(b.base.entryAt(0)->id() != 0);

	for (unsigned fp = 0; fp < namen.size(); ++fp)
	{
		CHECK(b.list.hasId(fp));
		CHECK_EQ(b.list.lookup(fp)->entry->name(), mstl::string(namen[fp]));
	}
}


TEST(Si5NameList, a_duplicate_name_makes_the_list_longer_than_the_namebase)
{
	// Regel 2: zwei Dateipositionen mit demselben Namen legt die
	// Namensbasis zusammen. Die Liste fuehrt beide weiter, die Basis
	// nur eine -- ein Vektor nach Namebase::size() waere zu kurz, und
	// writeNamebasesSi5 schriebe an die Position hinter seinem Ende.
	Bestand b;
	std::vector<char const*> namen;
	namen.push_back("Endrunde");			// Dateiposition 0
	namen.push_back("Vorrunde");			// Dateiposition 1
	namen.push_back("Endrunde");			// Dateiposition 2 -- derselbe Name

	b.aufbauen(namen);

	CHECK_EQ(b.base.size(), 2u);
	CHECK_EQ(b.list.size(), 3u);
	CHECK(b.list.size() > b.base.size());

	// Die Alias-Position zeigt auf denselben Eintrag wie die kanonische.
	CHECK(b.list.hasId(2));
	CHECK(b.list.lookup(2)->entry == b.list.lookup(0)->entry);
	CHECK_EQ(b.list.lookup(2)->entry->name(), mstl::string("Endrunde"));
}


TEST(Si5NameList, a_new_entry_is_not_in_the_lookup)
{
	// Regel 3: was nach dem Oeffnen hinzukommt, steht nicht in
	// m_lookup. Die Liste bleibt stehen, die Basis waechst -- deshalb
	// nimmt writeNamebasesSi5 die neuen Namen aus der Basis und nicht
	// aus der Liste.
	Bestand b;
	std::vector<char const*> namen;
	namen.push_back("Endrunde");
	namen.push_back("Vorrunde");

	b.aufbauen(namen);

	unsigned const neu = b.list.size();
	Namebase::Entry* eintrag = b.base.insert(mstl::string("Zwischenrunde"), neu, Limit);

	CHECK(eintrag != 0);
	CHECK_EQ(eintrag->id(), neu);
	CHECK_EQ(b.base.size(), 3u);
	CHECK_EQ(b.list.size(), neu);			// die Liste weiss nichts davon
	CHECK(!b.list.hasId(neu));
}


TEST(Si5NameList, update_survives_a_si3_shaped_list)
{
	// Die Gegenprobe zu Regel 1: an einer SI3-artigen Liste ist
	// update() in Ordnung. Dort stehen die Eintraege alphabetisch in
	// der Datei, Dateiposition und sortierte Position sind dasselbe,
	// und es gibt keine Alias-Position. Ohne diesen Fall belegte der
	// naechste nur, dass update() irgendwo scheitert.
	Bestand b;
	std::vector<char const*> namen;
	namen.push_back("Endrunde");			// alphabetisch -- wie in einer SI3-Datei
	namen.push_back("Halbfinale");
	namen.push_back("Vorrunde");

	b.aufbauen(namen);

	CHECK_NOTHROW(b.list.update(b.base, b.codec));
	CHECK_EQ(b.list.size(), 3u);

	for (unsigned fp = 0; fp < namen.size(); ++fp)
	{
		CHECK(b.list.hasId(fp));
		CHECK_EQ(b.list.lookup(fp)->entry->name(), mstl::string(namen[fp]));
	}
}


TEST(Si5NameList, update_does_not_survive_an_alias)
{
	// Regel 1: eine Alias-Position hat keinen eigenen Eintrag in der
	// Namensbasis. update() baut die Liste **aus der Namensbasis** neu
	// auf, kennt die Position danach nicht mehr -- und bricht ab.
	//
	// Gemessen: assertion failed: m_list.size() == size(), aus
	// adjustListSize() heraus. Geprueft wird aber nur, *dass* es
	// nicht durchgeht: welche der Zusicherungen zuerst greift, haengt
	// an der Reihenfolge, und in einem Bau mit NREQ greift keine --
	// dann faellt der Fall nicht aus, sondern verfaelscht still. Genau
	// deshalb steht die Regel in CLAUDE.md und nicht nur hier.
	Bestand b;
	std::vector<char const*> namen;
	namen.push_back("Endrunde");			// Dateiposition 0
	namen.push_back("Vorrunde");			// Dateiposition 1
	namen.push_back("Endrunde");			// Dateiposition 2 -- Alias

	b.aufbauen(namen);

	CHECK_EQ(b.list.size(), 3u);
	CHECK_EQ(b.base.size(), 2u);
	CHECK_THROWS(b.list.update(b.base, b.codec), mstl::assertion_failure_exception);
}


TEST(Si5NameList, the_namebase_does_not_know_the_file_positions)
{
	// Woran update() als erstes scheitert, wenn niemand nextId
	// nachzieht: readNamebasesSi5 fuegt mit ausdruecklicher ID ein, und
	// Namebase::insert ruehrt m_nextId dabei nicht an. Die Namensbasis
	// haelt also Eintraege mit den IDs 0..2, waehrend nextId() 0
	// meldet -- buildList bricht mit
	// "entry->id() < base.nextId()" ab.
	//
	// Erreichbar ist das derzeit nur ueber update(): der Scid-Consumer
	// holt neue IDs aus NameList::nextId() und nie aus
	// Namebase::nextFreeId(). Gemessen am laufenden Programm: eine
	// wieder geoeffnete SI5-Datenbank nimmt zwei weitere Partien mit
	// neuen Namen auf, und nach dem Schliessen stehen alle vier
	// Spieler da.
	Bestand b;
	std::vector<char const*> namen;
	namen.push_back("Vorrunde");
	namen.push_back("Endrunde");
	namen.push_back("Halbfinale");

	b.aufbauen(namen, false);			// nextId NICHT nachziehen

	CHECK_EQ(b.base.size(), 3u);
	CHECK_EQ(b.base.nextId(), 0u);
	CHECK_THROWS(b.list.update(b.base, b.codec), mstl::assertion_failure_exception);
}
