# ======================================================================
# Lage 3 -- das laufende Programm.
#
# Lage 1 prueft Text, Lage 2 die DB-Schicht ohne Oberflaeche. Hier wird
# das Programm wirklich gestartet und von aussen befragt: ueber Tk
# "send" an die Anwendungskennung Scidc. Nur so laesst sich pruefen, was
# erst zur Laufzeit entsteht -- dass C++, Tcl und Bundle dieselbe
# Version melden, dass Tcl 9 alle sechs Sprachdateien annimmt, dass die
# dokumentierten Widgetpfade stimmen und die Spalten ziehbar sind.
#
# Drei Vorsichtsmassnahmen:
#
#   * **Fremde Instanz wird nie angefasst.** Die Kennung Scidc ist pro
#     X-Anzeige eindeutig. Antwortet schon jemand, wird uebersprungen --
#     ein Test darf das laufende Programm des Benutzers nicht abschiessen
#     und auch nicht aus Versehen dessen Bestaende befragen.
#   * **Eigenes HOME.** start.tcl leitet das Benutzerverzeichnis aus
#     [file tildeexpand ~] ab, folgt also $HOME. Ein Verzeichnis im
#     Scratchpad genuegt, ohne eine Zeile Programmcode zu aendern.
#   * **Kein Erststart.** Bei fehlendem config/options.dat setzt
#     start.tcl setup=1, und Startup2 oeffnet Sprachwahl und
#     Engine-Download -- zwei Dialoge, die den Lauf anhalten wuerden.
#     Das Verzeichnisgerippe wird darum vorher angelegt.
#
# Uebersprungen wird ohne DISPLAY, ohne gebautes Binary/Bundle, ohne
# deps/tcltk und bei fremder Instanz. Die Reihe bleibt damit in einem
# frischen Klon lauffaehig.
# ======================================================================

import base64
import os
import select
import shutil
import signal
import subprocess
import tempfile
import time
import unittest

from . import pfad, python_kodierung, sprachen, sprachzeilen
from .test_version import version_aus_makefile, vergleichbar


WARTEZEIT = 90          # Sekunden bis die Kennung da sein muss
ANTWORTZEIT = 30        # Sekunden je Frage

UNTERVERZEICHNISSE = (
    "log", "photos", "backup", "layout", "config", "themes",
    os.path.join("engines", "bin"),
) + tuple(
    os.path.join("textures", a, b)
    for a in ("tile", "lite", "dark")
    for b in ("marble", "wood", "misc")
)

# Der Treiber haelt die Verbindung offen und schickt jede Frage weiter.
# base64 in beiden Richtungen, damit Zeilenumbrueche und Umlaute im
# Skript wie in der Antwort unversehrt bleiben.
TREIBER = r"""
package require Tk
wm withdraw .
fconfigure stdin -buffering line -translation lf
fconfigure stdout -buffering line -translation lf

while {[gets stdin line] >= 0} {
	if {$line eq "@@QUIT"} break
	set script [encoding convertfrom utf-8 [binary decode base64 $line]]
	if {[catch {send Scidc $script} antwort]} {
		puts "ERR [binary encode base64 [encoding convertto utf-8 $antwort]]"
	} else {
		puts "OK [binary encode base64 [encoding convertto utf-8 $antwort]]"
	}
}
exit
"""


class Instanz:
    """Gestartetes Programm samt Treiber fuer "send"."""

    def __init__(self):
        self.heim = tempfile.mkdtemp(prefix="scidc-lage3-")
        self.programm = None
        self.treiber = None
        self.treiberdatei = None
        self.protokoll = os.path.join(self.heim, "lauf.log")

    # --- Aufbau ----------------------------------------------------

    def gerippe(self):
        """Legt ~/.scidc-beta an, damit start.tcl setup=0 sieht."""
        wurzel = os.path.join(self.heim, ".scidc-beta")

        for teil in UNTERVERZEICHNISSE:
            os.makedirs(os.path.join(wurzel, teil), exist_ok=True)

        open(os.path.join(wurzel, "config", "options.dat"), "w").close()

    def starten(self):
        self.gerippe()

        umgebung = dict(os.environ)
        umgebung["HOME"] = self.heim
        umgebung["SCIDB_SHAREDIR"] = pfad("AppDir", "usr", "share", "scidc-beta")

        with open(self.protokoll, "wb") as log:
            self.programm = subprocess.Popen(
                [pfad("src", "tkscidc-beta"), pfad("tcl", "scidc-beta")],
                cwd=pfad(), env=umgebung,
                stdin=subprocess.DEVNULL, stdout=log, stderr=log,
                start_new_session=True)

        # Der Treiber MUSS als Datei laufen. Ein wish ohne Skriptargument
        # liest stdin interaktiv; dann mischen sich Eingabeaufforderung und
        # Ergebniszeilen, und das Lesen haengt - daran hing der erste Anlauf.
        self.treiberdatei = os.path.join(self.heim, "treiber.tcl")

        with open(self.treiberdatei, "w", encoding="utf-8") as f:
            f.write(TREIBER)

        self.treiber = subprocess.Popen(
            [pfad("deps", "tcltk", "bin", "wish9.0"), self.treiberdatei],
            cwd=pfad(),
            env=dict(os.environ, LD_LIBRARY_PATH=pfad("deps", "tcltk", "lib")),
            stdin=subprocess.PIPE, stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL)

        self.warten()

    def warten(self):
        """Wartet auf die Kennung -- nicht blind schlafen."""
        ende = time.time() + WARTEZEIT

        while time.time() < ende:
            if self.programm.poll() is not None:
                raise AssertionError(
                    "Programm beendet sich beim Start:\n" + self.ausgabe())

            gut, antwort = self.roh("set ::scidc::version")

            if gut:
                return antwort

            time.sleep(0.5)

        raise AssertionError("Kennung Scidc antwortet nicht:\n" + self.ausgabe())

    # --- Abbau -----------------------------------------------------

    def beenden(self):
        if self.treiber is not None:
            try:
                self.roh("after 50 exit")           # freundlich
                self.treiber.stdin.write(b"@@QUIT\n")
                self.treiber.stdin.flush()
                self.treiber.wait(timeout=10)
            except Exception:
                self.treiber.kill()

            # Ohne das meldet Python beim Abbau ResourceWarning fuer die
            # beiden Rohre des Treibers.
            for rohr in (self.treiber.stdin, self.treiber.stdout):
                if rohr is not None:
                    try:
                        rohr.close()
                    except Exception:
                        pass

        if self.programm is not None and self.programm.poll() is None:
            try:
                self.programm.wait(timeout=10)
            except subprocess.TimeoutExpired:
                os.killpg(os.getpgid(self.programm.pid), signal.SIGKILL)

        shutil.rmtree(self.heim, ignore_errors=True)

    # --- Fragen ----------------------------------------------------

    def roh(self, skript):
        """(gelungen, Antwort) -- ohne Ausnahme bei einem Tcl-Fehler."""
        zeile = base64.b64encode(skript.encode("utf-8")) + b"\n"
        self.treiber.stdin.write(zeile)
        self.treiber.stdin.flush()

        # Zeitgrenze statt endlosem Blockieren: ein haengender Treiber
        # soll den Lauf nicht anhalten, sondern den Fall roetten.
        bereit, _, _ = select.select([self.treiber.stdout], [], [], ANTWORTZEIT)

        if not bereit:
            raise AssertionError(
                f"keine Antwort binnen {ANTWORTZEIT}s auf:\n{skript}")

        antwort = self.treiber.stdout.readline().decode("utf-8").strip()

        if not antwort:
            raise AssertionError("Treiber antwortet nicht mehr")

        marke, _, rest = antwort.partition(" ")
        text = base64.b64decode(rest).decode("utf-8") if rest else ""
        return marke == "OK", text

    def frage(self, skript):
        gut, text = self.roh(skript)

        if not gut:
            raise AssertionError(f"{skript}\n -> {text}")

        return text

    def ausgabe(self):
        try:
            with open(self.protokoll, "rb") as f:
                return f.read().decode("utf-8", "replace")
        except OSError:
            return "(kein Protokoll)"


INSTANZ = None
GRUND = None


def setUpModule():
    global INSTANZ, GRUND

    if not os.environ.get("DISPLAY"):
        GRUND = "keine X-Anzeige (DISPLAY leer)"
        return

    for teil in (("src", "tkscidc-beta"), ("tcl", "scidc-beta"),
                 ("deps", "tcltk", "bin", "wish9.0"),
                 ("AppDir", "usr", "share", "scidc-beta")):
        if not os.path.exists(pfad(*teil)):
            GRUND = f"{os.path.join(*teil)} fehlt (nicht gebaut)"
            return

    # Fremde Instanz? Dann Finger weg.
    fremd = subprocess.run(
        [pfad("deps", "tcltk", "bin", "wish9.0")],
        input=b"package require Tk\nwm withdraw .\nputs [winfo interps]\nexit\n",
        cwd=pfad(),
        env=dict(os.environ, LD_LIBRARY_PATH=pfad("deps", "tcltk", "lib")),
        stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, timeout=60)

    if b"Scidc" in fremd.stdout:
        GRUND = "eine Instanz laeuft schon (wird nicht angefasst)"
        return

    INSTANZ = Instanz()

    try:
        INSTANZ.starten()
    except Exception as fehler:
        INSTANZ.beenden()
        INSTANZ = None
        raise AssertionError(f"Start fuer Lage 3 misslungen: {fehler}")


def tearDownModule():
    global INSTANZ

    if INSTANZ is not None:
        INSTANZ.beenden()
        INSTANZ = None


class TestLaufend(unittest.TestCase):

    def setUp(self):
        if INSTANZ is None:
            raise unittest.SkipTest(GRUND or "keine Instanz")

    def test_version_stimmt_zur_laufzeit(self):
        # Lage 1 vergleicht die drei Dateien. Erst hier zeigt sich, ob
        # C++ und das gebaute Bundle wirklich dasselbe melden -- genau
        # dieser Konflikt bricht sonst den Start ab.
        self.assertEqual(vergleichbar(INSTANZ.frage("set ::scidc::version")),
                         vergleichbar(version_aus_makefile()))

    def test_lauf_ist_vom_benutzer_getrennt(self):
        benutzer = INSTANZ.frage("set ::scidc::dir::user")

        self.assertTrue(benutzer.startswith(INSTANZ.heim),
                        f"{benutzer} liegt nicht unter {INSTANZ.heim}")
        self.assertEqual(INSTANZ.frage("set ::scidc::dir::setup"), "0",
                         "Erststart erkannt -- die Dialoge haetten den Lauf angehalten")

    def test_startlauf_ohne_ausnahme(self):
        text = INSTANZ.ausgabe()

        for marke in ("(what)", "(func)", "assertion failed",
                      "precondition violation", "TWM load failed"):
            self.assertNotIn(marke, text, f"{marke} im Startprotokoll:\n{text[-2000:]}")

    def test_alle_sprachen_werden_angenommen(self):
        # Passen Datei und Deklaration in localization.tcl nicht
        # zusammen, bricht Tcl 9 die komplette Uebersetzung ab. Das zeigt
        # sich nur hier.
        tabelle = sprachen()
        self.assertGreaterEqual(len(tabelle), 6)

        try:
            for name, kuerzel, _, datei in tabelle:
                gut, text = INSTANZ.roh(f"::mc::setLang {kuerzel}")
                self.assertTrue(gut, f"{name} ({datei}): {text}")
                self.assertEqual(INSTANZ.frage("set ::mc::langID"), kuerzel, name)
        finally:
            INSTANZ.frage("::mc::setLang en")

    def test_umschalten_aendert_die_texte_wirklich(self):
        """Hin und zurueck: beide Richtungen muessen ankommen.

        Der Rueckweg ist der heikle: mc::selectLang setzt nur, was in
        der Datei steht, und stellt die eingebauten Vorgaben nie wieder
        her. Fehlt ein Schluessel in english.tcl, bleibt der Text beim
        Zurueckschalten in der alten Sprache stehen -- 26.10.28 traf
        das 18 Texte (siehe TestEnglischAlsRueckfall in
        test_sprachen.py). Die Erwartung kommt aus den Dateien, nicht
        aus der Erinnerung.
        """
        probe = "::playerdict::mc::WebSource"
        soll = {}

        for _, kuerzel, kodierung, datei in sprachen():
            for _, schluessel, rest in sprachzeilen(
                    os.path.join("tcl/lang", datei), python_kodierung(kodierung)):
                if schluessel == probe:
                    soll[kuerzel] = rest.strip().strip('"')

        self.assertIn("en", soll, "english.tcl fuehrt %s nicht" % probe)
        self.assertIn("de", soll, "deutsch.tcl fuehrt %s nicht" % probe)
        self.assertNotEqual(soll["en"], soll["de"])

        try:
            INSTANZ.frage("::mc::setLang en")
            englisch = INSTANZ.frage("set " + probe)
            INSTANZ.frage("::mc::setLang de")
            deutsch = INSTANZ.frage("set " + probe)
            INSTANZ.frage("::mc::setLang en")
            zurueck = INSTANZ.frage("set " + probe)
        finally:
            INSTANZ.frage("::mc::setLang en")

        self.assertEqual(englisch, soll["en"])
        self.assertEqual(deutsch, soll["de"])
        self.assertEqual(zurueck, soll["en"],
                         "der Text bleibt beim Zurueckschalten deutsch")

    def test_dokumentierte_widgetpfade_stimmen(self):
        # Diese Pfade stehen in CLAUDE.md; ein Umbau soll sie nicht
        # stillschweigend entwerten.
        for pfadname, klasse in (
                (".application.nb.database.contents.games.twm.games.table.top.table.t",
                 "TreeCtrl"),):
            self.assertEqual(INSTANZ.frage(f"winfo exists {pfadname}"), "1", pfadname)
            self.assertEqual(INSTANZ.frage(f"winfo class {pfadname}"), klasse, pfadname)

        for tab in ("database", "board", "information"):
            self.assertEqual(
                INSTANZ.frage(f"winfo exists .application.nb.{tab}"), "1", tab)

    def test_elo_spalten_bleiben_ziehbar(self):
        # Rueckfall-Probe zu 26.09.18-b5: aus (0, 0) wurde faelschlich
        # "feste Breite" gelesen, womit sich beide Elo-Spalten, Titel,
        # IDN und Stellung nicht mehr ziehen liessen. Nur zur Laufzeit
        # messbar.
        ziehbar = ("whiteRating1", "blackRating1", "whiteTitle", "idn", "position")

        for spalte in ziehbar:
            self.assertEqual(
                INSTANZ.frage(
                    "set t .application.nb.database.contents.games.twm.games"
                    ".table.top.table.t\n"
                    f"$t column cget {spalte} -resize"),
                "1", f"Spalte {spalte} ist eingefroren")

        # Gegenprobe: eine echte Festbreite bleibt fest (min == max == 5).
        self.assertEqual(
            INSTANZ.frage(
                "set t .application.nb.database.contents.games.twm.games"
                ".table.top.table.t\n"
                "$t column cget result -resize"),
            "0", "die feste Spalte result ist unerwartet ziehbar")

    def test_nachtmodus_loest_die_farben_auf(self):
        # ::colors::lookup gibt Unbekanntes unveraendert zurueck. Fuer
        # den Nachtmodus muessen die X11-Namen eingetragen sein, sonst
        # bleibt dunkelblauer Text auf dunklem Grund unsichtbar.
        antwort = INSTANZ.frage(
            "set vorher $::colors::Scheme\n"
            "set ::colors::Scheme night\n"
            # Zeilenweise, nicht als Tcl-Liste: ein Wert, der mit '#'
            # beginnt, wird dort geklammert ({#6fa8dc}), und eine
            # Zerlegung nach Leerzeichen liest ihn falsch.
            "set ergebnis [join [list [::colors::lookup darkblue]"
            " [::colors::lookup blue]] \\n]\n"
            "set ::colors::Scheme $vorher\n"
            "set ergebnis")

        dunkelblau, blau = antwort.split("\n")

        self.assertTrue(dunkelblau.startswith("#"), antwort)
        self.assertTrue(blau.startswith("#"), antwort)
        self.assertNotEqual(dunkelblau, "darkblue")

    def test_scv_archiv_fuehrt_si5_nicht(self):
        # Rueckfall-Probe zu 26.10.26-b1: das SCV-Archiv ist ein
        # Scidb-Format und darf SI5 nicht aufnehmen.
        self.assertEqual(INSTANZ.frage("::menu::archive::GetCount /x/y.si5"), "0")
        self.assertNotEqual(INSTANZ.frage("::menu::archive::GetCount /x/y.si4"), "0")
        self.assertIn(
            '.si5',
            INSTANZ.frage("info body ::menu::dbCreateArchive"),
            "der Riegel gegen SI5 fehlt in dbCreateArchive")

    def test_die_bruecke_antwortet(self):
        # Stichproben in die C++-Bruecke: sie ist kein Auto-Binding,
        # jeder Befehl ist von Hand registriert.
        self.assertNotEqual(INSTANZ.frage("::scidc::misc::julianDay"), "")
        self.assertEqual(INSTANZ.frage("llength [info commands ::scidc::db::*]") != "0",
                         True)
        self.assertEqual(INSTANZ.frage("::scidc::misc::suffixes x.si5"), "si5 sg5 sn5")


if __name__ == "__main__":
    unittest.main()
