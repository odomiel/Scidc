# ======================================================================
# Die Git-Haken.
#
# .git/hooks ist nicht versioniert: ein frischer Klon hat den
# pre-commit-Haken **nicht**, und damit faellt die Pruefung weg, die
# einen Commit mit auseinanderlaufenden Versionen oder roter Pruefreihe
# abweist. Die Vorlage liegt darum in tools/hooks/, installiert wird sie
# mit tools/install-hooks.sh.
#
# Daraus folgt eine Doppelpflege wie bei AppDir: wer den Haken in
# .git/hooks aendert und die Vorlage stehen laesst, verliert die
# Aenderung beim naechsten Klon -- und umgekehrt greift eine geaenderte
# Vorlage lokal nicht. Der Vergleich unten faellt darum auf, solange
# beide da sind.
# ======================================================================

import os
import subprocess
import unittest

from . import WURZEL, lies, pfad

VORLAGE = "tools/hooks/pre-commit"
INSTALLIERER = "tools/install-hooks.sh"

#: Was der Haken fahren muss. Ein Haken, der nur noch die Version
#: prueft, meldet gruen, ohne zu messen -- genau das soll auffallen.
SCHRITTE = (
    ("Versionsgleichheit", "Makefile.version"),
    ("Bundle-Version", "tcl/scidc-beta"),
    ("Lage 2 (C++)", "make -C src check"),
    ("Lage 1+3 (Pruefreihe)", "python3 -m unittest discover -s tests -t ."),
)


def haken_verzeichnis():
    """Das Hakenverzeichnis des Arbeitsbaums, oder None."""
    try:
        ergebnis = subprocess.run(
            ["git", "rev-parse", "--git-path", "hooks"],
            cwd=WURZEL, capture_output=True, text=True, timeout=10)
    except (OSError, subprocess.SubprocessError):
        return None

    if ergebnis.returncode != 0:
        return None

    weg = ergebnis.stdout.strip()

    if not weg:
        return None

    if not os.path.isabs(weg):
        weg = os.path.join(WURZEL, weg)

    return weg if os.path.isdir(weg) else None


class TestVorlage(unittest.TestCase):

    def test_die_vorlage_ist_da_und_ausfuehrbar(self):
        datei = pfad(VORLAGE)

        self.assertTrue(os.path.isfile(datei), VORLAGE + " fehlt")
        self.assertTrue(os.access(datei, os.X_OK),
                        VORLAGE + " ist nicht ausfuehrbar")

    def test_der_installierer_ist_da_und_ausfuehrbar(self):
        datei = pfad(INSTALLIERER)

        self.assertTrue(os.path.isfile(datei), INSTALLIERER + " fehlt")
        self.assertTrue(os.access(datei, os.X_OK),
                        INSTALLIERER + " ist nicht ausfuehrbar")

    def test_die_vorlage_fahrt_alle_schritte(self):
        text = lies(VORLAGE)

        for name, marke in SCHRITTE:
            with self.subTest(schritt=name):
                self.assertIn(marke, text,
                              "Der Haken fahrt '%s' nicht mehr" % name)

    def test_der_installierer_nennt_die_vorlage(self):
        text = lies(INSTALLIERER)

        self.assertIn("tools/hooks", text)
        self.assertIn("--force", text)


class TestDoppelpflege(unittest.TestCase):
    """Vorlage und installierter Haken muessen uebereinstimmen.

    Uebersprungen wird, wo es kein Hakenverzeichnis gibt (kein
    Arbeitsbaum) und wo der Haken nicht installiert ist -- ein frischer
    Klon meldet keinen Fehler, sondern bekommt den Hinweis aus
    tests/README.
    """

    def setUp(self):
        self.ordner = haken_verzeichnis()

        if self.ordner is None:
            raise unittest.SkipTest("kein Git-Hakenverzeichnis")

        self.installiert = os.path.join(self.ordner, "pre-commit")

        if not os.path.isfile(self.installiert):
            raise unittest.SkipTest(
                "pre-commit nicht installiert (bash %s)" % INSTALLIERER)

    def test_der_installierte_haken_ist_die_vorlage(self):
        with open(self.installiert, "rb") as f:
            hier = f.read()

        with open(pfad(VORLAGE), "rb") as f:
            vorlage = f.read()

        self.assertEqual(
            hier, vorlage,
            "Der installierte Haken weicht von %s ab.\n"
            "  Unterschied: diff %s %s\n"
            "  Vorlage uebernehmen: bash %s --force"
            % (VORLAGE, self.installiert, pfad(VORLAGE), INSTALLIERER))

    def test_der_installierte_haken_ist_ausfuehrbar(self):
        self.assertTrue(os.access(self.installiert, os.X_OK),
                        "der installierte Haken ist nicht ausfuehrbar")
