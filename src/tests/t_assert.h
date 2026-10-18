// ======================================================================
// Minimale Pruefhilfe fuer die Tests der DB-Schicht.
//
// Kein Framework: die Tests binden gegen dieselben .a-Bibliotheken wie
// cbh2si4, und ein Fremdpaket haette hier nichts zu suchen. Ein Fall
// meldet sich selbst an, ein fehlgeschlagener Vergleich nennt Datei,
// Zeile, Erwartung und Befund; nach dem ersten Fehler laeuft der Fall
// weiter, damit ein Lauf alles zeigt.
// ======================================================================

#ifndef _T_ASSERT_H
#define _T_ASSERT_H

namespace mstl { class string; }

namespace test {

typedef void (*Function)();

/// Meldet einen Fall an (geschieht vor main() ueber Registrar).
void add(char const* group, char const* name, Function f);

/// Buchfuehrung; liefert immer false, damit CHECK() sich einsetzen laesst.
bool failed(char const* expr, char const* file, int line);
bool failed(char const* expr, char const* file, int line,
            long long got, long long want);
bool failed(char const* expr, char const* file, int line,
            char const* got, char const* want);
void passed();

/// Fuehrt alle Faelle aus; argv[1] filtert auf Gruppe oder Gruppe.Name.
int run(int argc, char const* const* argv);

bool equal(long long got, long long want, char const* expr,
           char const* file, int line);
bool equal(char const* got, char const* want, char const* expr,
           char const* file, int line);
bool equal(mstl::string const& got, char const* want, char const* expr,
           char const* file, int line);

/// Unterdrueckt die Diagnose, die M_THROW sonst mit Backtrace auf stderr
/// schreibt. Eine erwartete Ausnahme ist kein Vorfall, und ohne das
/// waere die Ausgabe eines Laufs nicht zu lesen.
struct Quiet
{
	Quiet();
	~Quiet();

private:

	bool m_before;
};


struct Registrar
{
	Registrar(char const* group, char const* name, Function f)
	{
		add(group, name, f);
	}
};

} // namespace test

#define TEST(group, name)                                                     \
	static void t_##group##_##name();                                          \
	static ::test::Registrar t_reg_##group##_##name(                           \
		#group, #name, t_##group##_##name);                                     \
	static void t_##group##_##name()

/// Wahrheitspruefung.
#define CHECK(expr)                                                           \
	((expr) ? (::test::passed(), true)                                         \
	        : ::test::failed(#expr, __FILE__, __LINE__))

/// Gleichheit; zeigt Befund und Erwartung. Fuer Zahlen und Zeichenketten.
#define CHECK_EQ(got, want)                                                   \
	::test::equal((got), (want), #got " == " #want, __FILE__, __LINE__)

/// Erwartet, dass der Ausdruck eine Ausnahme des Typs wirft.
#define CHECK_THROWS(expr, Type)                                              \
	do {                                                                       \
		bool caught = false;                                                    \
		::test::Quiet quiet;                                                    \
		try { (void)(expr); }                                                   \
		catch (Type const&) { caught = true; }                                  \
		catch (...) { caught = false; }                                         \
		if (caught)                                                             \
			::test::passed();                                                    \
		else                                                                    \
			::test::failed("wirft " #Type ": " #expr, __FILE__, __LINE__);       \
	} while (0)

/// Erwartet, dass der Ausdruck ueberhaupt keine Ausnahme wirft.
#define CHECK_NOTHROW(expr)                                                   \
	do {                                                                       \
		bool threw = false;                                                     \
		try { (void)(expr); }                                                   \
		catch (...) { threw = true; }                                           \
		if (threw)                                                              \
			::test::failed("wirft nicht: " #expr, __FILE__, __LINE__);           \
		else                                                                    \
			::test::passed();                                                    \
	} while (0)

#endif // _T_ASSERT_H

// vi:set ts=3 sw=3:
