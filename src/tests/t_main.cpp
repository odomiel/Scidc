// ======================================================================
// Laeufer fuer die Tests der DB-Schicht.
//
//     make -C src check          # bauen und laufen lassen
//     src/dbtest                 # alles
//     src/dbtest ByteStream      # eine Gruppe
//     src/dbtest Board.fen       # einen Fall
//
// Rueckgabe 0, wenn jede Pruefung haelt, sonst 1.
// ======================================================================

#include "t_assert.h"

#include "m_string.h"
#include "m_exception.h"

#include "db_board.h"
#include "db_home_pawns.h"
#include "db_signature.h"

#include <tcl.h>

#include <stdio.h>
#include <string.h>
#include <vector>

// sys::utf8::Codec greift ueber sys_base.ipp auf tcl::bits::interp zu.
// Dieselbe Loesung wie in cbh2si4.cpp: das Symbol hier bereitstellen und
// einen echten Interpreter anlegen -- die Kodierungstabellen von Tcl
// haengen daran.
namespace tcl { namespace bits { Tcl_Interp* interp; } }


namespace {

struct TclInterpreter
{
	TclInterpreter()	{ tcl::bits::interp = Tcl_CreateInterp(); }
	~TclInterpreter()	{ Tcl_DeleteInterp(tcl::bits::interp); }
};


struct Case
{
	char const* group;
	char const* name;
	test::Function f;
};

/// Die Liste wird vor main() gefuellt, also als Funktionsstatikum --
/// so steht sie sicher, bevor der erste Registrar sie anfasst.
std::vector<Case>& cases()
{
	static std::vector<Case> list;
	return list;
}

unsigned m_checks   = 0;
unsigned m_failures = 0;
char const* m_current = 0;

void header()
{
	if (m_current)
	{
		printf("\n  %s\n", m_current);
		m_current = 0;
	}
}

} // namespace


namespace test {

Quiet::Quiet()
	:m_before(!mstl::basic_exception::isEnabled())
{
	mstl::basic_exception::setDisabled(true);
}


Quiet::~Quiet()
{
	mstl::basic_exception::setDisabled(m_before);
}


void
add(char const* group, char const* name, Function f)
{
	Case c = { group, name, f };
	cases().push_back(c);
}


void
passed()
{
	++m_checks;
}


bool
failed(char const* expr, char const* file, int line)
{
	++m_checks;
	++m_failures;
	header();
	printf("    %s:%d: %s\n", file, line, expr);
	return false;
}


bool
failed(char const* expr, char const* file, int line, long long got, long long want)
{
	++m_checks;
	++m_failures;
	header();
	printf("    %s:%d: %s\n      Befund:   %lld\n      Erwartet: %lld\n",
			 file, line, expr, got, want);
	return false;
}


bool
failed(char const* expr, char const* file, int line, char const* got, char const* want)
{
	++m_checks;
	++m_failures;
	header();
	printf("    %s:%d: %s\n      Befund:   '%s'\n      Erwartet: '%s'\n",
			 file, line, expr, got ? got : "(null)", want ? want : "(null)");
	return false;
}


bool
equal(long long got, long long want, char const* expr, char const* file, int line)
{
	if (got == want)
	{
		++m_checks;
		return true;
	}

	return failed(expr, file, line, got, want);
}


bool
equal(char const* got, char const* want, char const* expr, char const* file, int line)
{
	if (got && want && ::strcmp(got, want) == 0)
	{
		++m_checks;
		return true;
	}

	return failed(expr, file, line, got, want);
}


bool
equal(mstl::string const& got, char const* want, char const* expr,
		char const* file, int line)
{
	return equal(got.c_str(), want, expr, file, line);
}


int
run(int argc, char const* const* argv)
{
	char const* filter = argc > 1 ? argv[1] : 0;
	unsigned ran = 0;
	unsigned skipped = 0;
	char const* group = 0;

	for (unsigned i = 0; i < cases().size(); ++i)
	{
		Case const& c = cases()[i];

		if (filter)
		{
			// "Gruppe" oder "Gruppe.Name"
			size_t len = ::strlen(c.group);

			if (::strncmp(filter, c.group, len) != 0
				|| (filter[len] != '\0' && (filter[len] != '.' || ::strcmp(filter + len + 1, c.name) != 0)))
			{
				++skipped;
				continue;
			}
		}

		if (!group || ::strcmp(group, c.group) != 0)
		{
			printf("%s%s", ran ? "\n" : "", c.group);
			group = c.group;
		}

		unsigned before = m_failures;
		char label[256];
		::snprintf(label, sizeof(label), "%s.%s", c.group, c.name);
		m_current = label;

		try
		{
			c.f();
		}
		catch (mstl::exception const& exc)
		{
			failed("unerwartete Ausnahme", c.name, 0);
			printf("      %s\n", exc.what());
		}
		catch (...)
		{
			failed("unerwartete fremde Ausnahme", c.name, 0);
		}

		m_current = 0;
		printf("%s", m_failures == before ? "." : "F");
		fflush(stdout);
		++ran;
	}

	printf("\n\n%u Faelle, %u Pruefungen, %u fehlgeschlagen",
			 ran, m_checks, m_failures);

	if (skipped)
		printf(" (%u Faelle uebergangen)", skipped);

	printf("\n%s\n", m_failures ? "FEHLGESCHLAGEN" : "OK");
	return m_failures ? 1 : 0;
}

} // namespace test


int
main(int argc, char const* const* argv)
{
	Tcl_FindExecutable(argv[0]);
	TclInterpreter interpreter;

	// Ohne diese Tabellen liefert Board::piece() ueberall piece::None, und
	// jeder Decoder-Test scheitert mit "error while decoding game data" --
	// ein Fehlerbild, das nichts mit dem Decoder zu tun hat. Im Programm
	// uebernimmt das die statische Initialisierung bzw. der Block
	// BROKEN_LINKER_HACK in tkscidc.cpp.
	db::tag::initialize();
	db::castling::initialize();
	db::Board::initialize();
	db::HomePawns::initialize();
	db::Signature::initialize();

	return test::run(argc, argv);
}

// vi:set ts=3 sw=3:
