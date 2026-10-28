# ======================================================================
# Die Sprachdateien tcl/lang/*.tcl.
#
# Sie werden nicht als Tcl gesourced, sondern zeilenweise gelesen:
#
#     while {[gets $f line] >= 0} {
#         if {[string length $line] > 0 && [string index $line 0] ne "#"} {
#             set [lindex $line 0] [lindex $line 1]
#         }
#     }
#
# Daraus folgt alles, was hier geprueft wird. Es gibt keine Fehlermeldung
# fuer eine schiefe Zeile: entweder sie setzt stillschweigend etwas
# anderes, oder sie bricht die ganze Uebersetzung ab.
# ======================================================================

import os
import re
import unittest

from . import (ist_utf8, lies_bytes, namensraeume, pfad, python_kodierung,
               sprachen, sprachzeilen)

#: Der Name ohne Feldindex. Bindestriche und Punkte sind erlaubt, ein
#: geklammerter Schluessel darf auch Leerzeichen tragen
#: ({::dialog::choosefont::mc::Bold Italic}).
NAME = re.compile(r"^::[\w:. -]+$")


def schluessel_verstossen(schluessel):
    """Nennt den Grund, warum der Schluessel keiner ist -- oder None.

    Der Leser setzt [lindex $line 0] als Variablennamen. Ein fehlendes
    ')' macht daraus stillschweigend einen anderen Namen: der gemeinte
    Eintrag bleibt unuebersetzt, und niemand merkt es.
    """
    if not schluessel.startswith("::"):
        return "beginnt nicht mit '::'"
    name, klammer, index = schluessel.partition("(")
    if klammer and not index.endswith(")"):
        return "Feldindex ohne schliessende Klammer"
    if klammer and "(" in index:
        return "mehr als eine oeffnende Klammer"
    if not NAME.match(name):
        return "kein gueltiger Variablenname"
    return None


class TestTabelle(unittest.TestCase):
    """localization.tcl ist die Vorschrift, nach der geladen wird."""

    def test_die_tabelle_laesst_sich_lesen(self):
        self.assertEqual(len(sprachen()), 6, "Es sind sechs Sprachen")

    def test_jede_eingetragene_datei_liegt_da(self):
        for _, _, _, datei in sprachen():
            with self.subTest(datei=datei):
                self.assertTrue(os.path.isfile(pfad("tcl/lang", datei)))

    def test_jede_datei_im_ordner_ist_eingetragen(self):
        """Eine nicht eingetragene Sprachdatei wird nie geladen."""
        eingetragen = {datei for _, _, _, datei in sprachen()}
        eingetragen.add("localization.tcl")
        vorhanden = {n for n in os.listdir(pfad("tcl/lang")) if n.endswith(".tcl")}
        self.assertEqual(vorhanden, eingetragen)

    def test_jede_kodierung_ist_eine_bekannte(self):
        for _, _, kodierung, datei in sprachen():
            with self.subTest(datei=datei):
                self.assertIsNotNone(python_kodierung(kodierung),
                                     "Unbekannte Kodierung '%s'" % kodierung)

    def test_die_tabelle_selbst_ist_utf8(self):
        self.assertTrue(ist_utf8(lies_bytes("tcl/lang/localization.tcl")))


class TestKodierung(unittest.TestCase):
    """Datei und Deklaration muessen zusammenpassen.

    Passen sie nicht, bricht Tcl 9 die komplette Uebersetzung ab -- unter
    8.6 gab es nur Zeichensalat. Das ist der Grund, warum diese Dateien
    nicht mit dem Edit-Werkzeug bearbeitet werden duerfen.
    """

    def test_jede_datei_laesst_sich_wie_deklariert_lesen(self):
        for _, _, kodierung, datei in sprachen():
            with self.subTest(datei=datei):
                lies_bytes(os.path.join("tcl/lang", datei)).decode(
                    python_kodierung(kodierung))

    def test_eine_als_latin1_deklarierte_datei_ist_kein_utf8(self):
        """Sonst ist sie in Wahrheit UTF-8 und wird falsch gelesen.

        Eine reine ASCII-Datei (english.tcl) ist beides und in Ordnung.
        """
        for _, _, kodierung, datei in sprachen():
            if kodierung != "iso8859-1":
                continue
            rohdaten = lies_bytes(os.path.join("tcl/lang", datei))
            if all(b < 128 for b in rohdaten):
                continue
            with self.subTest(datei=datei):
                self.assertFalse(ist_utf8(rohdaten),
                                 "%s ist als iso8859-1 deklariert, liest sich aber "
                                 "als UTF-8" % datei)

    def test_eine_als_utf8_deklarierte_datei_ist_utf8(self):
        for _, _, kodierung, datei in sprachen():
            if kodierung != "utf-8":
                continue
            with self.subTest(datei=datei):
                self.assertTrue(ist_utf8(lies_bytes(os.path.join("tcl/lang", datei))))


class TestZeilen(unittest.TestCase):
    def zeilen(self, datei, kodierung):
        return sprachzeilen(os.path.join("tcl/lang", datei), python_kodierung(kodierung))

    def test_jede_datenzeile_setzt_einen_schluessel_mit_wert(self):
        """Was der Leser nicht ueberspringt, muss eine Zuweisung sein.

        Zwei Fehlerbilder faellt das auf: eine Zeile, die mit 'set '
        beginnt (dann setzt der Leser eine Variable namens 'set' und die
        Uebersetzung kommt nie an), und eine eingerueckte
        Kommentarzeile (ihr erstes Zeichen ist kein '#', also wird sie
        nicht uebersprungen).
        """
        for _, _, kodierung, datei in sprachen():
            for nummer, schluessel, rest in self.zeilen(datei, kodierung):
                with self.subTest(datei=datei, zeile=nummer):
                    self.assertIsNone(schluessel_verstossen(schluessel),
                                      "%r: %s" % (schluessel,
                                                  schluessel_verstossen(schluessel)))
                    self.assertTrue(rest.strip(), "kein Wert hinter dem Schluessel")

    def test_kein_schluessel_steht_zweimal_in_einer_datei(self):
        """Der zweite ueberschreibt den ersten -- stillschweigend."""
        for _, _, kodierung, datei in sprachen():
            gesehen = {}
            for nummer, schluessel, _ in self.zeilen(datei, kodierung):
                gesehen.setdefault(schluessel, []).append(nummer)
            doppelt = {k: v for k, v in gesehen.items() if len(v) > 1}
            with self.subTest(datei=datei):
                self.assertEqual(doppelt, {},
                                 "doppelte Schluessel in %s" % datei)

    def test_jeder_namensraum_kommt_im_quelltext_vor(self):
        """Ein Schluessel in einem geloeschten Namensraum bricht den Start ab.

        Tcl: can't set "::x::mc::Key": parent namespace doesn't exist.
        Beim Entfernen eines Features muessen darum alle sechs
        Sprachdateien mitgeraeumt werden.
        """
        bekannt = namensraeume()
        for _, _, kodierung, datei in sprachen():
            for nummer, schluessel, _ in self.zeilen(datei, kodierung):
                raum = "::".join(schluessel.strip(":").split("::")[:-1])
                if not raum:
                    continue
                with self.subTest(datei=datei, zeile=nummer):
                    self.assertTrue(
                        all(glied in bekannt for glied in raum.split("::"))
                        or raum in bekannt,
                        "Namensraum '%s' gibt es im Quelltext nicht" % raum)


# ----------------------------------------------------------------------
# Schluessel, die eine Uebersetzung fuehrt, english.tcl aber nicht --
# und die auch keine eingebaute Vorgabe mehr haben: der Quelltext kennt
# sie nicht (umbenanntes oder entferntes Feature). Sie koennen nicht
# wirken, denn niemand liest sie; sie bleiben nur stehen, damit eine
# Wiederaufnahme des Features die Uebersetzung nicht sucht. Gemessen
# am laufenden Programm, 26.10.28: keiner dieser Namen existierte dort
# als Variable.
#
# Wer hier etwas eintraegt, muss vorher nachsehen, ob der Schluessel im
# Quelltext eine Vorgabe hat. Hat er eine, gehoert er nach english.tcl,
# nicht in diese Liste.
# ----------------------------------------------------------------------
VERWAISTE_SCHLUESSEL = {
    # Engine-Download beim Erststart, inzwischen "Welcome*" (application.tcl)
    "::application::mc::EngineChecksumMismatch",
    "::application::mc::EngineDesc(fairy-stockfish-scidc)",
    "::application::mc::EngineDesc(stockfish-scidc)",
    "::application::mc::EngineDownloadBtn",
    "::application::mc::EngineDownloadDone",
    "::application::mc::EngineDownloadFailed",
    "::application::mc::EngineDownloadMsg",
    "::application::mc::EngineDownloadRestart",
    "::application::mc::EngineDownloadTitle",
    "::application::mc::EngineDownloading",
    "::application::mc::EngineNoChecksumTool",
    "::application::mc::EngineSkipBtn",
    # umbenannt: ReallyCompactDetail(1|N) in app-database.tcl
    "::application::database::mc::CompactDetail",
    # Zugfolgen-Anzeige im Zugbaum: in app-tree.tcl auskommentiert
    "::application::tree::mc::ComputeSpread",
    "::application::tree::mc::MoveOrders",
    "::application::tree::mc::ShowAllMoveOrders",
    # kein Gegenstueck im Quelltext (mehr)
    "::export::mc::Significant",
    "::import::mc::Error(AbortedDueToInternalError)",
    "::import::mc::Error(AbortedDueToIoError)",
    "::import::mc::Error(UserHasInterrupted)",
    # umbenannt: State(UnsupportedVariant) in import.tcl
    "::import::mc::UnsupportedVariant",
    # umbenannt: AllOthers in info.tcl
    "::info::mc::AllOther",
    "::info::mc::Inspired",
    # steht in player-dict.tcl, aber als ::playerdict::mc::
    "::playertable::mc::HelpPatternMatching",
    "::setup::mc::Chess960Position",
    "::setup::mc::ShuffleChessPosition",
    "::setup::mc::SymmChess960Position",
    "::terminationbox::mc::State(Checkmate)",
    "::terminationbox::mc::State(Losing)",
    "::terminationbox::mc::State(Stalemate)",
    "::terminationbox::mc::State(ThreeChecks)",
}


class TestEnglischAlsRueckfall(unittest.TestCase):
    """english.tcl muss jeden uebersetzten Schluessel selbst fuehren.

    mc::selectLang setzt nur, was in der gewaehlten Datei steht -- die
    eingebauten Vorgaben stellt es nie wieder her (i18n.tcl, ~Zeile
    431). Fuehrt eine Uebersetzung einen Schluessel, den english.tcl
    nicht fuehrt, bleibt dieser Text beim Zurueckschalten auf Englisch
    in der alten Sprache stehen. Gemessen am laufenden Programm: nach
    de -> en standen 18 Texte weiter auf Deutsch.
    """

    def schluesselmengen(self):
        mengen = {}
        for _, kuerzel, kodierung, datei in sprachen():
            zeilen = sprachzeilen(os.path.join("tcl/lang", datei),
                                  python_kodierung(kodierung))
            mengen[kuerzel] = ({s for _, s, _ in zeilen}, datei)
        return mengen

    def test_english_fuehrt_jeden_uebersetzten_schluessel(self):
        mengen = self.schluesselmengen()
        englisch, _ = mengen["en"]
        for kuerzel, (menge, datei) in sorted(mengen.items()):
            if kuerzel == "en":
                continue
            fehlt = sorted(menge - englisch - VERWAISTE_SCHLUESSEL)
            with self.subTest(datei=datei):
                self.assertEqual(
                    fehlt, [],
                    "%s fuehrt diese Schluessel, english.tcl nicht -- sie "
                    "bleiben beim Zurueckschalten auf Englisch stehen" % datei)

    def test_die_ausnahmeliste_fuehrt_nichts_ueberfluessiges(self):
        """Keine toten Eintraege: jeder Name steht in einer Uebersetzung."""
        mengen = self.schluesselmengen()
        englisch, _ = mengen["en"]
        uebersetzt = set()
        for kuerzel, (menge, _) in mengen.items():
            if kuerzel != "en":
                uebersetzt |= menge
        self.assertEqual(sorted(VERWAISTE_SCHLUESSEL - uebersetzt), [])
        self.assertEqual(sorted(VERWAISTE_SCHLUESSEL & englisch), [],
                         "english.tcl fuehrt den Schluessel doch")
