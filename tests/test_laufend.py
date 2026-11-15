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
        self.startausgabe = None

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
        self.startausgabe = self.ausgabe()

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

    def startprotokoll(self):
        """Das Protokoll, wie es **nach dem Hochfahren** aussah.

        Spaetere Faelle schreiben selbst hinein -- der
        Datenbankbetrieb etwa provoziert absichtlich Fehler. Der
        Startlauf ist aber nur das, was bis zur ersten Antwort
        aufgelaufen ist, und genau darauf prueft
        test_startlauf_ohne_ausnahme.
        """
        if self.startausgabe is None:
            self.startausgabe = self.ausgabe()

        return self.startausgabe


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
        text = INSTANZ.startprotokoll()

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


# ----------------------------------------------------------------------
# Datenbankbetrieb. Bis hierher fragte Lage 3 nur Zustaende ab -- keine
# Datenbank wurde angelegt, befuellt, geschlossen und wieder geoeffnet.
# Genau dort lagen aber die letzten echten Fehler: die falsche Meldung
# beim Aendern einer Scid-Partie (26.09.14-b2), die vier Importfehler
# samt appendResult (26.09.14-b3) und die vergessenen
# format::Scid5-Zweige.
#
# Alles laeuft im eigenen HOME der Instanz und wird mit ihr geloescht;
# die Bestaende des Benutzers werden nicht angefasst.
#
# Der Weg ist der, den die Oberflaeche geht (app-database.tcl):
#
#   anlegen   ::scidc::db::new <datei> <variante> <typ>
#             ::scidc::db::attach <datei> <datei>     <- ohne das wird
#                                                        nichts auf die
#                                                        Platte geschrieben
#   fuellen   ::scidc::db::import <db> <pgn> <log> {} <fortschritt> {}
#   zaehlen   ::scidc::db::count games <db> <variante>
#   schliessen ::scidc::db::close <db>
#   oeffnen   ::scidc::db::load <datei> <fortschritt> {} -readonly <flag>
#
# ::scidc::db::open ist **nicht** der Weg, eine Datenbank zu oeffnen:
# es nimmt nur pgn/gz/zip und meldet fuer alles andere "unsupported
# extension" -- das kostete beim ersten Anlauf Zeit.
# ----------------------------------------------------------------------

#: Endung, beim Wiederoeffnen beschreibbar, die drei Dateien des Formats.
#: SI3/SI4 oeffnet das Programm absichtlich nur lesend (app-database.tcl),
#: SCI und SI5 lesend und schreibend.
FORMATE = (
    ("sci", True,  ("sci", "scg", "scn")),
    ("si3", False, ("si3", "sg3", "sn3")),
    ("si4", False, ("si4", "sg4", "sn4")),
    ("si5", True,  ("si5", "sg5", "sn5")),
)

PROBE_PGN = """[Event "Probe"]
[Site "Nirgendwo"]
[Date "2026.11.14"]
[Round "1"]
[White "Weiss, W"]
[Black "Schwarz, S"]
[Result "1-0"]

1. e4 e5 2. Nf3 Nc6 3. Bb5 a6 1-0

[Event "Probe"]
[Site "Nirgendwo"]
[Date "2026.11.14"]
[Round "2"]
[White "Schwarz, S"]
[Black "Weiss, W"]
[Result "1/2-1/2"]

1. d4 d5 2. c4 e6 1/2-1/2
"""


class TestDatenbank(unittest.TestCase):
    """Anlegen, importieren, schliessen, wieder oeffnen -- je Format."""

    def setUp(self):
        if INSTANZ is None:
            raise unittest.SkipTest(GRUND or "keine Instanz")

        self.pgn = os.path.join(INSTANZ.heim, "probe.pgn")

        with open(self.pgn, "w", encoding="utf-8") as f:
            f.write(PROBE_PGN)

        # Rueckrufe muessen echte Prozeduren sein: ::scidc::db::import
        # ruft seinen Protokoll- und Fortschrittsrueckruf auf, *bevor*
        # es die Argumente prueft. "puts" als Platzhalter erzeugt dort
        # irrefuehrende Fehler.
        INSTANZ.frage("proc ::probeLog {args} { return 0 }")
        INSTANZ.frage("proc ::probeProgress {args} { return 0 }")

    def datei(self, name, endung):
        return os.path.join(INSTANZ.heim, "%s.%s" % (name, endung))

    def anlegen(self, ziel):
        INSTANZ.frage("::scidc::db::new {%s} Normal 0" % ziel)
        INSTANZ.frage("::scidc::db::attach {%s} {%s}" % (ziel, ziel))

    def importieren(self, ziel):
        return INSTANZ.frage(
            "::scidc::db::import {%s} {%s} ::probeLog {} ::probeProgress {}"
            % (ziel, self.pgn))

    def partien(self, ziel):
        return INSTANZ.frage("::scidc::db::count games {%s} Normal" % ziel)

    def test_jedes_format_nimmt_den_import_auf(self):
        """Hier ist das Format das *Ziel* -- also der Schreibpfad.

        Fuer SI5 ist das der nachtraeglich eingezogene: er geht durch
        dieselben Format-Gates, die beim Nachruesten reihenweise
        vergessen wurden (`format::Scid5`). Die Quelle ist stets PGN;
        das Gegenstueck -- eine Datenbank *als Quelle* -- steht in
        `test_jedes_format_taugt_auch_als_quelle`.

        Der Rueckgabewert von import ist
        {angenommen abgewiesen {...} {...} {}} -- die beiden Zahlen
        kamen aus demselben Fehlerbild wie appendResult.
        """
        for endung, _, dateien in FORMATE:
            ziel = self.datei("import", endung)

            with self.subTest(format=endung):
                try:
                    self.anlegen(ziel)
                    antwort = self.importieren(ziel)
                    felder = antwort.split(None, 2)

                    self.assertEqual(felder[0], "2", "angenommene Partien: " + antwort)
                    self.assertEqual(felder[1], "0", "abgewiesene Partien: " + antwort)
                    self.assertEqual(self.partien(ziel), "2")
                finally:
                    INSTANZ.roh("::scidc::db::close {%s}" % ziel)

                for teil in dateien:
                    name = self.datei("import", teil)
                    self.assertTrue(os.path.isfile(name), name)
                    self.assertGreater(os.path.getsize(name), 0, name)

    def test_eine_geschriebene_datenbank_laesst_sich_wieder_oeffnen(self):
        """Erst das belegt, dass der Import auf der Platte gelandet ist."""
        for endung, beschreibbar, _ in FORMATE:
            ziel = self.datei("umlauf", endung)

            with self.subTest(format=endung):
                try:
                    self.anlegen(ziel)
                    self.importieren(ziel)
                finally:
                    INSTANZ.frage("::scidc::db::close {%s}" % ziel)

                lesemodus = 0 if beschreibbar else 1

                try:
                    INSTANZ.frage(
                        "::scidc::db::load {%s} ::probeProgress {} -readonly %d"
                        % (ziel, lesemodus))
                    self.assertEqual(self.partien(ziel), "2")
                finally:
                    INSTANZ.roh("::scidc::db::close {%s}" % ziel)

    def test_der_lesemodus_je_format_steht_noch_so_da(self):
        """SCI und SI5 schreibend, SI3 und SI4 nur lesend.

        Nachgefragt wird der Rumpf von openBase in der laufenden
        Instanz, nicht der Quelltext auf der Platte -- so faellt auch
        ein Bundle auf, das nicht neu erzeugt wurde.

        Nicht gemessen wird das, indem SI3 schreibend geoeffnet wird:
        die DB-Schicht antwortet darauf mit einer
        **Zusicherungsverletzung** (db_database.cpp:252), nicht mit
        einem geordneten Fehler. Das schreibt einen Backtrace ins
        Protokoll, und in einem Bau mit NREQ gaebe es die Meldung gar
        nicht -- der Fall haenge dann an der Bauart statt am Verhalten.
        """
        rumpf = INSTANZ.frage("info body ::application::database::openBase")

        self.assertIn("sci - si3 - si4 - si5 - cbh - cbf", rumpf,
                      "der Format-Zweig von openBase sieht anders aus")
        self.assertIn('$ext ne "sci" && $ext ne "si5"', rumpf,
                      "die Unterscheidung schreibbar/nur lesend fehlt")

    def test_jedes_format_taugt_auch_als_quelle(self):
        """Das Gegenstueck: die Datenbank ist die *Quelle*, Ziel ist SCI.

        Darauf sieht `cmdImport` die Endung der Quelle an
        (tcl_database.cpp), und genau dort fehlte `si5` bis 26.09.14-b3
        -- eine .si5-Quelle fiel bis in den Zweig "unsupported
        extension" durch. Gegengeprobt: mit entferntem `|| ext ==
        "si5"` meldet dieser Fall fuer si5 "unsupported extension
        'si5'", die uebrigen drei bleiben gruen.

        Die Quelle wird vorher geschlossen -- dann nimmt cmdImport den
        anderen der beiden Wege (`scidb->contains(src)` ist falsch, es
        oeffnet die Datei selbst als ::db::Database).
        """
        for endung, _, _ in FORMATE:
            quelle = self.datei("quelle", endung)
            ziel = self.datei("ziel-%s" % endung, "sci")

            with self.subTest(format=endung):
                try:
                    self.anlegen(quelle)
                    self.importieren(quelle)
                finally:
                    INSTANZ.frage("::scidc::db::close {%s}" % quelle)

                try:
                    self.anlegen(ziel)
                    antwort = INSTANZ.frage(
                        "::scidc::db::import {%s} {%s} ::probeLog {} "
                        "::probeProgress {}" % (ziel, quelle))

                    self.assertEqual(antwort.split(None, 2)[0], "2",
                                     "%s als Quelle: %s" % (endung, antwort))
                    self.assertEqual(self.partien(ziel), "2")
                finally:
                    INSTANZ.roh("::scidc::db::close {%s}" % ziel)


class TestBeschaedigteDatenbank(unittest.TestCase):
    """Eine praeparierte Datei muss einen geordneten Fehler ergeben.

    Hintergrund ist Befund H1 des Audits vom 08.11.2026: in den vier
    Namensbasis-Lesern von `sci_codec.cpp` wurde der Index des
    **ersten** Eintrags nicht geprueft, waehrend die Folgeschleife es
    tat. Ein Index jenseits von `nextId` schrieb damit hinter den
    Vektor (`lookup[index] = 0`).

    Die Probe wird hier **erzeugt**, nicht als Datei mitgefuehrt: eine
    frische SCI-Datenbank, dann ein Feld der `.scn` verfaelscht. Der
    erste Spielereintrag steht unverkuerzt in der Datei -- drei Bytes
    Index (uint24), ein Laengenbyte, dann der Name. Gesucht wird
    deshalb nach Laenge+Name, und die drei Bytes davor sind der Index.

    Geprueft werden drei Dinge, denn der blosse Fehlschlag belegt
    wenig: die Meldung muss die **des Codecs** sein (ohne den Fix
    scheiterte es mit dem leeren Tcl-Ergebnis "0"), es darf **keine
    Zusicherungsverletzung** ins Protokoll laufen (ohne den Fix stand
    dort `(what) precondition violation: n < size()` samt Backtrace,
    und in einem Bau mit -DNREQ waere es ein Heap-Overflow gewesen),
    und die Instanz muss hinterher **weiterlaufen**.
    """

    NAME = b"Schwarz, S"

    def setUp(self):
        if INSTANZ is None:
            raise unittest.SkipTest(GRUND or "keine Instanz")

        self.pgn = os.path.join(INSTANZ.heim, "kaputt.pgn")

        with open(self.pgn, "w", encoding="utf-8") as f:
            f.write(PROBE_PGN)

        INSTANZ.frage("proc ::probeLog {args} { return 0 }")
        INSTANZ.frage("proc ::probeProgress {args} { return 0 }")

    def anlegen(self, ziel):
        INSTANZ.frage("::scidc::db::new {%s} Normal 0" % ziel)
        INSTANZ.frage("::scidc::db::attach {%s} {%s}" % (ziel, ziel))
        INSTANZ.frage(
            "::scidc::db::import {%s} {%s} ::probeLog {} ::probeProgress {}"
            % (ziel, self.pgn))
        INSTANZ.frage("::scidc::db::close {%s}" % ziel)

    def verfaelsche_ersten_spielerindex(self, datei, wert=0x004000):
        with open(datei, "rb") as f:
            rohdaten = f.read()

        marke = bytes([len(self.NAME)]) + self.NAME
        stelle = rohdaten.find(marke)

        self.assertGreater(stelle, 3,
                           "der erste Spielereintrag steht nicht wie erwartet "
                           "in %s" % datei)
        self.assertEqual(rohdaten.count(marke), 1,
                         "die Marke kommt mehrfach vor")

        index = stelle - 3
        neu = (rohdaten[:index]
               + bytes(((wert >> 16) & 0xff, (wert >> 8) & 0xff, wert & 0xff))
               + rohdaten[stelle:])

        self.assertEqual(len(neu), len(rohdaten))
        self.assertNotEqual(neu, rohdaten, "die Datei ist unveraendert")

        with open(datei, "wb") as f:
            f.write(neu)

    def test_ein_zu_grosser_namensindex_wird_abgewiesen(self):
        ziel = os.path.join(INSTANZ.heim, "kaputt.sci")
        self.anlegen(ziel)
        self.verfaelsche_ersten_spielerindex(
            os.path.join(INSTANZ.heim, "kaputt.scn"))

        vorher = len(INSTANZ.ausgabe())

        ok, text = INSTANZ.roh(
            "::scidc::db::load {%s} ::probeProgress {} -readonly 1" % ziel)

        if ok:
            # Nur schliessen, was wirklich geoeffnet wurde: ein close auf
            # eine nicht geoeffnete Datenbank ist selbst eine
            # Zusicherungsverletzung (app_application.cpp:806) und
            # verfaelschte die Protokollpruefung unten.
            INSTANZ.roh("::scidc::db::close {%s}" % ziel)

        self.assertFalse(ok, "die praeparierte Datei wurde geoeffnet: " + text)
        self.assertIn("Namebase", text, "nicht die Meldung des Codecs: " + text)
        self.assertIn("Corrupted", text, "nicht die Meldung des Codecs: " + text)

        # Die Ausnahme druckt ihre M_THROW-Diagnose auf stderr -- erwartet
        # ist die des Codecs, nicht die einer Zusicherung. Ohne den Fix
        # stand hier "(func) operator[] ... precondition violation:
        # n < size()", also der Griff hinter den Vektor.
        neu = INSTANZ.ausgabe()[vorher:]

        self.assertIn("namebase file is broken", neu,
                      "die Diagnose des Codecs fehlt:\n" + neu[-1500:])
        self.assertIn("db::IOException", neu,
                      "kein geordneter Codec-Fehler:\n" + neu[-1500:])
        self.assertNotIn("precondition violation", neu,
                         "Zusicherungsverletzung statt Fehlerpruefung:\n"
                         + neu[-1500:])

        # Die Instanz muss den Fall ueberlebt haben.
        self.assertEqual(vergleichbar(INSTANZ.frage("set ::scidc::version")),
                         vergleichbar(version_aus_makefile()))

    def test_eine_zu_grosse_spieler_id_im_si4_index_wird_abgewiesen(self):
        """Derselbe Griff im SI3/SI4-Lesepfad -- dort ohne jedes Klemmen.

        `decodeIndex` liest die Spieler-ID als 20-Bit-Zahl aus der
        Indexdatei und gibt sie unverandert an `lookup()`. Die
        Namensliste ist aus den Kopfzahlen dimensioniert; eine ID
        jenseits davon las mit -DNREQ hinter den Vektor und folgte dann
        einem Zufallszeiger -- schlimmer als die Null in SI5.

        Verfaelscht wird **ein** Byte: der Kopf ist 174 Bytes plus 8
        Bytes Magic, der Satz 47 Bytes, und im Satz steht an Versatz 9
        das Byte mit den oberen vier Bits beider Spieler-IDs
        (`whiteId |= (whiteBlackHigh >> 4) << 16`). 0xf0 setzt sie alle.
        """
        ziel = os.path.join(INSTANZ.heim, "indexid.si4")
        self.anlegen(ziel)

        stelle = 174 + 8 + 9
        with open(ziel, "r+b") as f:
            f.seek(stelle)
            self.assertEqual(len(f.read(1)), 1, "der Index ist zu kurz")
            f.seek(stelle)
            f.write(b"\xf0")

        vorher = len(INSTANZ.ausgabe())

        ok, text = INSTANZ.roh(
            "::scidc::db::load {%s} ::probeProgress {} -readonly 1" % ziel)

        if ok:
            INSTANZ.roh("::scidc::db::close {%s}" % ziel)

        self.assertFalse(ok, "die praeparierte Datei wurde geoeffnet: " + text)
        self.assertIn("Corrupted", text, "nicht die Meldung des Codecs: " + text)

        neu = INSTANZ.ausgabe()[vorher:]

        self.assertIn("name id is out of range", neu,
                      "die Diagnose des Codecs fehlt:\n" + neu[-1500:])
        self.assertNotIn("assertion failed", neu,
                         "Zusicherung statt Fehlerpruefung:\n" + neu[-1500:])

        self.assertEqual(vergleichbar(INSTANZ.frage("set ::scidc::version")),
                         vergleichbar(version_aus_makefile()))

    def test_eine_leere_si5_namensbasis_wird_abgewiesen(self):
        """Befund H2: `decodeIndexSi5` greift auf einen Null-Knoten zu.

        Der Lesepfad klemmt die aus der Datei gelesenen Namens-IDs nur
        nach **oben** (`if (whiteID > maxPlayerID) whiteID = 0`). Ist die
        Namensliste leer, ist `maxPlayerID` aber 0 und nicht "keine" --
        die Null geht durch, und `lookup(0)->entry` greift auf einen
        Null-Knoten zu. `::check()` kommt zu spaet: es prueft den
        Eintrag, dereferenziert ist der Knoten schon.

        Verfaelscht wird die **Namensdatei**, nicht der Index: eine
        .sn5, die nur noch ein Nullbyte enthaelt, laesst den Leser mit
        vier leeren Listen zuruecklaufen (`len == 0` wird
        uebersprungen), waehrend der Index weiter auf Spieler 0 zeigt.
        """
        ziel = os.path.join(INSTANZ.heim, "leer.si5")
        self.anlegen(ziel)

        with open(os.path.join(INSTANZ.heim, "leer.sn5"), "wb") as f:
            f.write(b"\x00")

        vorher = len(INSTANZ.ausgabe())

        ok, text = INSTANZ.roh(
            "::scidc::db::load {%s} ::probeProgress {} -readonly 1" % ziel)

        if ok:
            INSTANZ.roh("::scidc::db::close {%s}" % ziel)

        self.assertFalse(ok, "die praeparierte Datei wurde geoeffnet: " + text)
        self.assertIn("Index", text, "nicht die Meldung des Codecs: " + text)
        self.assertIn("Corrupted", text, "nicht die Meldung des Codecs: " + text)

        neu = INSTANZ.ausgabe()[vorher:]

        self.assertIn("name id is out of range", neu,
                      "die Diagnose des Codecs fehlt:\n" + neu[-1500:])
        self.assertIn("db::IOException", neu,
                      "kein geordneter Codec-Fehler:\n" + neu[-1500:])
        self.assertNotIn("assertion failed", neu,
                         "Zusicherung statt Fehlerpruefung:\n" + neu[-1500:])

        self.assertEqual(vergleichbar(INSTANZ.frage("set ::scidc::version")),
                         vergleichbar(version_aus_makefile()))
