# ======================================================================
# Das Hilfesystem tcl/help/.
#
# Zwei Dinge sind hier leicht zu verwechseln:
#
#  * Quelle (.txt) und Erzeugnis (.html) haben **verschiedene**
#    Kodierungen. Alle 58 deutschen .txt sind Latin-1, sieben weitere
#    ebenfalls; jedes .html und jede Contents.dat ist UTF-8.
#  * Eine Seite, die es in ihrer Sprache nicht gibt, ist kein Fehler:
#    help.tcl faellt auf en, dann de zurueck. Geprueft wird darum, dass
#    jeder Eintrag **nach dem Rueckfall** auf eine Datei trifft.
# ======================================================================

import os
import re
import unittest

from . import ist_utf8, lies_bytes, pfad

SPRACHEN = ("de", "en", "es", "it", "hu", "sv")

#: Rueckfallkette aus tcl/dialogs/help.tcl (~Zeile 367).
RUECKFALL = ("en", "de")

#: Die .txt, die trotz anderer Sprache Latin-1 sind -- und darum nicht
#: mit dem Edit-Werkzeug angefasst werden duerfen.
LATIN1_AUSNAHMEN = {
    "en/CQL-Examples.txt",
    "en/CQL-File-Format.txt",
    "en/ECO-Code.txt",
    "en/Tip-of-the-Day.txt",
    "es/File-Selection-Dialog.txt",
    "es/Overview.txt",
    "it/Clipbase.txt",
}


def hilfepfad(*teile):
    return pfad("tcl", "help", *teile)


def seiten_des_verzeichnisses(sprache):
    """Die in Contents.dat genannten HTML-Dateien."""
    datei = hilfepfad(sprache, "Contents.dat")
    if not os.path.isfile(datei):
        return []
    text = lies_bytes(os.path.join("tcl/help", sprache, "Contents.dat")).decode("utf-8")
    return sorted(set(re.findall(r"[A-Za-z0-9._-]+\.html", text)))


def txt_dateien():
    """Alle Hilfequellen als Pfad relativ zu tcl/help/."""
    ergebnis = []
    for sprache in SPRACHEN:
        ordner = hilfepfad(sprache)
        if not os.path.isdir(ordner):
            continue
        for name in sorted(os.listdir(ordner)):
            if name.endswith(".txt"):
                ergebnis.append("%s/%s" % (sprache, name))
    return ergebnis


class TestInhaltsverzeichnis(unittest.TestCase):
    def test_jede_sprache_hat_ein_verzeichnis_oder_keines(self):
        """sv hat keines -- das ist bekannt und kein Fehler."""
        mit = [s for s in SPRACHEN if os.path.isfile(hilfepfad(s, "Contents.dat"))]
        self.assertIn("de", mit)
        self.assertIn("en", mit)

    def test_jedes_verzeichnis_ist_utf8(self):
        for sprache in SPRACHEN:
            datei = os.path.join("tcl/help", sprache, "Contents.dat")
            if not os.path.isfile(pfad(datei)):
                continue
            with self.subTest(sprache=sprache):
                self.assertTrue(ist_utf8(lies_bytes(datei)))

    def test_die_klammern_sind_ausgeglichen(self):
        """Das Format ist eine Tcl-Liste: {{{Titel} {Datei.html}}}."""
        for sprache in SPRACHEN:
            datei = os.path.join("tcl/help", sprache, "Contents.dat")
            if not os.path.isfile(pfad(datei)):
                continue
            text = lies_bytes(datei).decode("utf-8")
            with self.subTest(sprache=sprache):
                self.assertEqual(text.count("{"), text.count("}"))

    def test_jeder_eintrag_trifft_nach_dem_rueckfall_auf_eine_datei(self):
        """Fehlt die Seite auch in en und de, zeigt die Hilfe nichts."""
        for sprache in SPRACHEN:
            for seite in seiten_des_verzeichnisses(sprache):
                orte = [sprache] + [s for s in RUECKFALL if s != sprache]
                with self.subTest(sprache=sprache, seite=seite):
                    self.assertTrue(
                        any(os.path.isfile(hilfepfad(ort, seite)) for ort in orte),
                        "weder in %s noch im Rueckfall %s vorhanden"
                        % (sprache, list(RUECKFALL)))

    def test_deutsch_und_englisch_sind_vollstaendig(self):
        """Die beiden gepflegten Sprachen tragen jede genannte Seite selbst."""
        for sprache in ("de", "en"):
            for seite in seiten_des_verzeichnisses(sprache):
                with self.subTest(sprache=sprache, seite=seite):
                    self.assertTrue(os.path.isfile(hilfepfad(sprache, seite)))


class TestKodierungen(unittest.TestCase):
    def test_jede_html_datei_ist_utf8(self):
        for sprache in SPRACHEN:
            ordner = hilfepfad(sprache)
            if not os.path.isdir(ordner):
                continue
            for name in sorted(os.listdir(ordner)):
                if not name.endswith(".html"):
                    continue
                with self.subTest(datei="%s/%s" % (sprache, name)):
                    self.assertTrue(
                        ist_utf8(lies_bytes(os.path.join("tcl/help", sprache, name))))

    def test_die_deutschen_quellen_sind_latin1(self):
        """Alle de/*.txt sind Latin-1 -- Python-Binary-I/O statt Edit-Werkzeug."""
        for name in txt_dateien():
            if not name.startswith("de/"):
                continue
            rohdaten = lies_bytes(os.path.join("tcl/help", name))
            if all(b < 128 for b in rohdaten):
                continue
            with self.subTest(datei=name):
                self.assertFalse(ist_utf8(rohdaten),
                                 "%s liest sich als UTF-8, die Dokumentation "
                                 "fuehrt de/ als Latin-1" % name)

    def test_die_dokumentierten_ausnahmen_sind_noch_latin1(self):
        """Steht eine Datei nicht mehr auf der Liste, ist die Doku veraltet."""
        for name in sorted(LATIN1_AUSNAHMEN):
            datei = os.path.join("tcl/help", name)
            if not os.path.isfile(pfad(datei)):
                continue
            with self.subTest(datei=name):
                self.assertFalse(ist_utf8(lies_bytes(datei)),
                                 "%s ist inzwischen UTF-8 -- Liste in CLAUDE.md "
                                 "nachziehen" % name)

    def test_die_uebrigen_quellen_sind_utf8(self):
        """Eine neue Latin-1-Datei muss in die Liste, sonst wird sie zerlegt."""
        for name in txt_dateien():
            if name.startswith("de/") or name in LATIN1_AUSNAHMEN:
                continue
            with self.subTest(datei=name):
                self.assertTrue(ist_utf8(lies_bytes(os.path.join("tcl/help", name))),
                                "%s ist kein UTF-8 -- in LATIN1_AUSNAHMEN "
                                "aufnehmen und nur mit Binary-I/O bearbeiten" % name)


class TestPaare(unittest.TestCase):
    def test_zu_jeder_quelle_gehoert_ein_erzeugnis(self):
        """make_html.tcl wird nicht aufgerufen -- .txt und .html werden
        von Hand synchron gehalten. Eine Quelle ohne HTML sieht niemand."""
        for name in txt_dateien():
            html = pfad("tcl/help", name[:-4] + ".html")
            with self.subTest(datei=name):
                self.assertTrue(os.path.isfile(html),
                                "%s hat kein .html" % name)
