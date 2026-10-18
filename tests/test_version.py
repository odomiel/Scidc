# ======================================================================
# Die Version steht an drei Stellen und muss an allen dieselbe sein.
#
# Der Pre-Commit-Hook prueft das auch, aber nur lokal und nur beim
# Commit: ein frischer Klon hat ihn nicht (.git/hooks ist nicht Teil des
# Repositorys). Hier steht derselbe Vertrag nachvollziehbar im Baum.
# ======================================================================

import datetime
import os
import re
import unittest

from . import lies, pfad

#: "26.10.05 b1 Beta" -- Jahr.Monat.Tag, Tages-Build-Zaehler, Beta.
SCHEMA = re.compile(r"^(\d{2})\.(\d{2})\.(\d{2}) b(\d+) Beta$")


def version_aus_makefile():
    """SCIDB_VERSION aus Makefile.version. Dort mit Bindestrichen."""
    text = lies("Makefile.version")
    treffer = re.search(r'SCIDB_VERSION\s*=\s*-DSCIDB_VERSION=\\"([^"\\]+)\\"', text)
    return treffer.group(1) if treffer else None


def version_aus_cpp():
    """SCIDB_VERSION aus dem CODEBLOCKS-Block von tcl_misc.cpp."""
    text = lies("src/tcl/tcl_misc.cpp", "latin-1")
    treffer = re.search(r'#\s*define\s+SCIDB_VERSION\s+"([^"]+)"', text)
    return treffer.group(1) if treffer else None


def version_aus_tcl():
    """$::scidc::version aus exec.tcl -- das Mass, nach dem sich das Bundle richtet."""
    text = lies("tcl/exec.tcl")
    treffer = re.search(r'^\s*set version "([^"]+)"', text, re.M)
    return treffer.group(1) if treffer else None


def vergleichbar(version):
    """Leerzeichen, Bindestriche und 'Beta' weg -- wie im Pre-Commit-Hook."""
    return version.replace(" ", "").replace("-", "").replace("Beta", "")


class TestVersionsdateien(unittest.TestCase):
    def setUp(self):
        self.makefile = version_aus_makefile()
        self.cpp = version_aus_cpp()
        self.tcl = version_aus_tcl()

    def test_jede_der_drei_stellen_laesst_sich_lesen(self):
        """Ein verschobener Ausdruck faellt hier auf, nicht erst im Bau."""
        self.assertIsNotNone(self.makefile, "Makefile.version: SCIDB_VERSION nicht gefunden")
        self.assertIsNotNone(self.cpp, "src/tcl/tcl_misc.cpp: SCIDB_VERSION nicht gefunden")
        self.assertIsNotNone(self.tcl, "tcl/exec.tcl: set version nicht gefunden")

    def test_die_drei_stellen_nennen_dieselbe_version(self):
        self.assertEqual(vergleichbar(self.makefile), vergleichbar(self.cpp),
                         "Makefile.version und tcl_misc.cpp laufen auseinander")
        self.assertEqual(vergleichbar(self.makefile), vergleichbar(self.tcl),
                         "Makefile.version und exec.tcl laufen auseinander")

    def test_das_schema_wird_eingehalten(self):
        """exec.tcl und tcl_misc.cpp tragen die Fassung mit Leerzeichen."""
        for name, wert in (("tcl/exec.tcl", self.tcl),
                           ("src/tcl/tcl_misc.cpp", self.cpp)):
            with self.subTest(datei=name):
                self.assertRegex(wert, SCHEMA)

    def test_makefile_version_traegt_bindestriche(self):
        """Dort steht sie im Dateinamen des AppImage, also ohne Leerzeichen."""
        self.assertRegex(self.makefile, r"^\d{2}\.\d{2}\.\d{2}-b\d+-Beta$")

    def test_das_datum_gibt_es(self):
        jahr, monat, tag, zaehler = SCHEMA.match(self.tcl).groups()
        datetime.date(2000 + int(jahr), int(monat), int(tag))
        self.assertGreaterEqual(int(zaehler), 1, "Der Build-Zaehler beginnt bei b1")

    def test_das_datum_liegt_nicht_in_der_zukunft(self):
        jahr, monat, tag, _ = SCHEMA.match(self.tcl).groups()
        stand = datetime.date(2000 + int(jahr), int(monat), int(tag))
        self.assertLessEqual(stand, datetime.date.today(),
                             "Das JJ.MM.TT der Version ist das Commit-Datum")


class TestBundle(unittest.TestCase):
    """tcl/scidc-beta wird von make erzeugt, ist aber getrackt.

    Laeuft es der Quelle hinterher, meldet exec.tcl beim Start einen
    Versionskonflikt zwischen C++ und Tcl. Fehlt es (nach make clean),
    wird uebersprungen.
    """

    def setUp(self):
        self.bundle = pfad("tcl/scidc-beta")
        if not os.path.isfile(self.bundle) or os.path.getsize(self.bundle) == 0:
            self.skipTest("tcl/scidc-beta ist nicht gebaut")

    def test_das_bundle_traegt_die_version_der_quelle(self):
        with open(self.bundle, "rb") as f:
            text = f.read().decode("utf-8")
        treffer = re.search(r'^\s*set version "([^"]+)"', text, re.M)
        self.assertIsNotNone(treffer, "Im Bundle steht keine Version")
        self.assertEqual(treffer.group(1), version_aus_tcl(),
                         "Bundle nicht neu gebaut -- 'make' laufen lassen")


class TestChangelog(unittest.TestCase):
    """Zu jeder Version gehoert ein Eintrag, und release.sh sucht ihn dort.

    Die Suche ist auf den Abschnitt des Datums begrenzt, denn der Zaehler
    beginnt an jedem Tag wieder bei b1 -- ein blosses Suchen nach
    '- **b1**' fand sonst den Eintrag eines frueheren Tages.
    """

    def setUp(self):
        self.version = version_aus_tcl()
        self.text = lies("CHANGELOG.md")

    def test_der_abschnitt_zum_datum_steht_da(self):
        jahr, monat, tag, _ = SCHEMA.match(self.version).groups()
        self.assertIn("## %s.%s.%s" % (jahr, monat, tag), self.text)

    def test_der_eintrag_zum_zaehler_steht_in_diesem_abschnitt(self):
        jahr, monat, tag, zaehler = SCHEMA.match(self.version).groups()
        marke = "## %s.%s.%s" % (jahr, monat, tag)
        anfang = self.text.index(marke) + len(marke)
        naechster = self.text.find("\n## ", anfang)
        abschnitt = self.text[anfang:naechster if naechster > 0 else len(self.text)]
        self.assertIn("- **b%s**" % zaehler, abschnitt,
                      "Kein CHANGELOG-Eintrag fuer b%s unter %s" % (zaehler, marke))

    def test_die_abschnitte_stehen_neueste_zuerst(self):
        daten = re.findall(r"^## (\d{2}\.\d{2}\.\d{2})$", self.text, re.M)
        self.assertEqual(daten, sorted(daten, reverse=True),
                         "Die Abschnitte sind nicht nach Datum absteigend")
