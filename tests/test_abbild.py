# ======================================================================
# Bau und Veroeffentlichung des AppImage.
#
# Die Pruefungen hier sichern drei Dinge, die sich still verlieren
# koennen:
#
#  * Die Update-Information. Ohne den ELF-Abschnitt .upd_info und die
#    zsync-Datei daneben findet kein Verwalter ein Update, auch wenn das
#    Abbild veroeffentlicht ist. "latest-pre" statt "latest" ist dabei
#    Absicht: jedes Release hier ist eine Vorabversion, und
#    .../releases/latest laesst Vorabversionen aus.
#  * Die drei Stellen, die bei jedem Bau abgeglichen werden muessen
#    (lang, engines.dat, Hilfe) und die beiden Wertungsskripte, die an
#    drei Stellen eingetragen sein muessen.
#  * Dass AppRun TCL_LIBRARY/TK_LIBRARY nicht setzt -- Tcl 9 legt seine
#    Skript-Library als zipfs in die .so, ein gesetzter Pfad zeigt auf
#    ein leeres Verzeichnis.
#
# Was ein gebautes Abbild braucht, wird uebersprungen, wenn keines da ist.
# ======================================================================

import glob
import os
import re
import subprocess
import unittest

from . import WURZEL, lies, pfad


def abbild():
    """Das Abbild zur **aktuellen** Version, oder None.

    Ein Abbild aus einem frueheren Bau ist kein Fehler: zwischen
    Versionsbump und Bau liegt immer ein Stueck Arbeit. Geprueft wird
    darum nur, was zum heutigen Stand gehoert.
    """
    from .test_version import version_aus_makefile
    version = version_aus_makefile()
    treffer = [n for n in os.listdir(WURZEL)
               if n.startswith("Scidc-") and n.endswith(".AppImage")
               and version and version in n]
    return sorted(treffer)[-1] if treffer else None


class TestBauskript(unittest.TestCase):
    def setUp(self):
        self.text = lies("build-appimage.sh")

    def test_die_update_information_wird_eingebettet(self):
        self.assertIn("gh-releases-zsync|", self.text)
        self.assertIn("latest-pre", self.text,
                      "latest laesst Vorabversionen aus -- latest-pre ist noetig")
        self.assertRegex(self.text, r"\.AppImage\.zsync")

    def test_der_suchausdruck_passt_auf_den_dateinamen(self):
        """Der eingebettete Ausdruck muss das erzeugte Abbild treffen."""
        treffer = re.search(r"gh-releases-zsync\|[^|]+\|[^|]+\|[^|]+\|([^\"'}\s]+)",
                            self.text)
        self.assertIsNotNone(treffer, "kein Suchausdruck gefunden")
        muster = treffer.group(1)
        self.assertTrue(muster.endswith(".zsync"))
        name = abbild()
        if name:
            import fnmatch
            self.assertTrue(fnmatch.fnmatch(name + ".zsync", muster),
                            "%s passt nicht auf %s" % (muster, name))

    def test_die_sprachdateien_werden_abgeglichen(self):
        self.assertIn("tcl/lang", self.text)

    def test_die_engine_konfiguration_wird_abgeglichen(self):
        self.assertIn("engines.dat", self.text)

    def test_die_hilfe_wird_abgeglichen(self):
        self.assertIn("tcl/help", self.text)

    def test_die_wertungsskripte_werden_abgeglichen(self):
        """Sonst fehlt eines, und dann bricht der gesamte Abgleich im
        Spielerlexikon ab -- auch der von FIDE."""
        for name in ("update-fide-players.py", "update-dwz-players.py"):
            with self.subTest(skript=name):
                self.assertIn(name, self.text)

    def test_das_binary_wird_verkleinert(self):
        self.assertIn("strip", self.text)

    def test_die_versionspruefung_wird_angestossen(self):
        self.assertIn("tools/check-updates.py", self.text)


class TestInstallationsregeln(unittest.TestCase):
    """Die Wertungsskripte muessen an drei Stellen stehen."""

    def test_install_text_scripts_nimmt_beide_skripte_mit(self):
        text = lies("tcl/Makefile")
        regel = text[text.index("install-text-scripts:"):]
        regel = regel[:regel.index("uninstall-text-scripts:")]
        for name in ("update-fide-players.py", "update-dwz-players.py"):
            with self.subTest(skript=name):
                self.assertIn(name, regel)

    def test_uninstall_raeumt_beide_wieder_weg(self):
        text = lies("tcl/Makefile")
        regel = text[text.index("uninstall-text-scripts:"):]
        regel = regel[:regel.index("install-images:")]
        for name in ("update-fide-players.py", "update-dwz-players.py"):
            with self.subTest(skript=name):
                self.assertIn(name, regel)

    def test_die_skripte_liegen_lose_in_tcl(self):
        """Nicht in tcl/scripts -- dort stehen nur .eXt und .css."""
        for name in ("update-fide-players.py", "update-dwz-players.py"):
            with self.subTest(skript=name):
                self.assertTrue(os.path.isfile(pfad("tcl", name)))


class TestAppRun(unittest.TestCase):
    def setUp(self):
        if not os.path.isfile(pfad("AppDir/AppRun")):
            self.skipTest("AppDir ist nicht gebaut")
        self.text = lies("AppDir/AppRun")

    def test_apprun_setzt_die_tcl_pfade_nicht(self):
        for zeile in self.text.split("\n"):
            if zeile.lstrip().startswith("#"):
                continue
            with self.subTest(zeile=zeile.strip()[:60]):
                self.assertNotRegex(zeile, r"\bexport\s+TCL_LIBRARY=")
                self.assertNotRegex(zeile, r"\bexport\s+TK_LIBRARY=")

    def test_apprun_stellt_die_gebuendelten_bibliotheken_voran(self):
        self.assertIn("usr/lib", self.text)


class TestGebautesAbbild(unittest.TestCase):
    def setUp(self):
        self.name = abbild()
        if not self.name:
            self.skipTest("kein gebautes AppImage im Wurzelverzeichnis")

    def test_es_gibt_nur_ein_abbild_zur_aktuellen_version(self):
        """Zwei Abbilder gleichen Namens kann es nicht geben, zwei zur
        gleichen Version schon -- dann weiss release.sh nicht, welches."""
        from .test_version import version_aus_makefile
        version = version_aus_makefile()
        treffer = [n for n in os.listdir(WURZEL)
                   if n.startswith("Scidc-") and n.endswith(".AppImage")
                   and version in n]
        self.assertEqual(len(treffer), 1, "mehrdeutig: %s" % treffer)

    def test_die_zsync_datei_liegt_daneben(self):
        """Fehlt sie im Release, findet ein Verwalter nichts."""
        self.assertTrue(os.path.isfile(pfad(self.name + ".zsync")),
                        "%s.zsync fehlt" % self.name)

    def test_die_zsync_datei_nennt_das_abbild(self):
        with open(pfad(self.name + ".zsync"), "rb") as f:
            kopf = f.read(4096).decode("latin-1")
        self.assertIn(self.name, kopf)

    def test_das_abbild_traegt_die_update_information(self):
        """Der ELF-Abschnitt .upd_info -- ohne ihn sucht niemand."""
        ergebnis = subprocess.run(["readelf", "-p", ".upd_info", pfad(self.name)],
                                  capture_output=True)
        if ergebnis.returncode != 0:
            self.skipTest("readelf kann den Abschnitt nicht lesen")
        text = ergebnis.stdout.decode("utf-8", "replace")
        self.assertIn("gh-releases-zsync|", text)
        self.assertIn("latest-pre", text)


class TestReleaseskript(unittest.TestCase):
    def setUp(self):
        self.text = lies("release.sh")

    def test_die_instanz_kommt_aus_dem_remote(self):
        """Host, Eigentuemer und Repository stehen nicht im Skript."""
        self.assertIn("remote.origin.url", self.text)

    def test_beide_url_formen_werden_verstanden(self):
        """ssh://git@host:port/eig/repo.git und git@host:eig/repo.git."""
        self.assertIn("ssh://", self.text)

    def test_die_zsync_datei_wird_mitveroeffentlicht(self):
        self.assertIn(".zsync", self.text)

    def test_der_anhang_wird_zurueckgeladen_und_geprueft(self):
        self.assertIn("sha256sum", self.text)

    def test_das_zertifikat_wird_geprueft_statt_umgangen(self):
        """Seit 25.09.2026 kein pauschales curl -k mehr."""
        self.assertIn("forgejo-ca.pem", self.text)
        self.assertIn("--insecure", self.text)

    def test_der_spiegel_wird_angestossen_und_abgewartet(self):
        self.assertIn("push_mirrors-sync", self.text)


# ----------------------------------------------------------------------
# Doppelpflege: AppDir gegen den Quellbaum.
#
# AppDir/usr/share/scidc-beta ist das, was ./run-scidb.sh laedt und was
# ins Abbild wandert. Ein Teil wird von build-appimage.sh abgeglichen
# (lang, engines.dat, die Wertungsskripte, vorhandene Hilfedateien), ein
# Teil **nicht**: die ttk-Themes sind von Hand in beiden Baeumen zu
# pflegen, und eine **neue** Hilfedatei kopiert das Skript nicht ("[ -f
# $dest ] && cp"), die muss einmal selbst hinueber.
#
# Die Pruefungen oben lesen nur den Text des Bauskripts -- dass die
# Pfade dort stehen. Hier wird verglichen, was wirklich liegt: ein in
# tcl/ eingebauter Fix, der in AppDir fehlt, greift beim Start nicht,
# und man sucht ihn im Quelltext.
# ----------------------------------------------------------------------
SHARE = os.path.join("AppDir", "usr", "share", "scidc-beta")


def gleich(a, b):
    with open(a, "rb") as f:
        eins = f.read()
    with open(b, "rb") as g:
        zwei = g.read()
    return eins == zwei


class TestDoppelpflege(unittest.TestCase):

    def setUp(self):
        if not os.path.isdir(pfad(SHARE)):
            self.skipTest("AppDir ist nicht gebaut")

    def paare(self, quellmuster, zielordner):
        """(Quelle, Ziel) je Datei, beide Pfade absolut."""
        ergebnis = []
        for quelle in sorted(glob.glob(pfad(*quellmuster))):
            ziel = pfad(SHARE, zielordner, os.path.basename(quelle))
            ergebnis.append((quelle, ziel))
        return ergebnis

    def vergleiche(self, paare, hinweis):
        fehlt, abweichend = [], []

        for quelle, ziel in paare:
            name = os.path.relpath(quelle, WURZEL)
            if not os.path.isfile(ziel):
                fehlt.append(name)
            elif not gleich(quelle, ziel):
                abweichend.append(name)

        self.assertNotEqual(paare, [], "nichts zu vergleichen")
        self.assertEqual(fehlt, [], "in AppDir nicht vorhanden (%s)" % hinweis)
        self.assertEqual(abweichend, [],
                         "weicht von der AppDir-Kopie ab (%s)" % hinweis)

    def test_die_sprachdateien_stimmen_ueberein(self):
        self.vergleiche(self.paare(("tcl", "lang", "*.tcl"), "lang"),
                        "build-appimage.sh gleicht sie ab")

    def test_die_ttk_themes_stimmen_ueberein(self):
        """Die einzige Stelle, die von Hand in beiden Baeumen liegt.

        load.tcl sourct die Themes zur Laufzeit aus
        $share/themes/ttk/*.tcl -- build-appimage.sh gleicht sie
        **nicht** ab. Eine nur in tcl/ geaenderte Themedatei wirkt
        darum nicht, und der Fix sieht folgenlos aus.
        """
        self.vergleiche(self.paare(("tcl", "themes", "ttk", "*.tcl"), "themes/ttk"),
                        "von Hand zu pflegen, kein Abgleich im Bauskript")

    def test_keine_themedatei_liegt_nur_in_appdir(self):
        quellen = {os.path.basename(p)
                   for p in glob.glob(pfad("tcl", "themes", "ttk", "*.tcl"))}
        kopien = {os.path.basename(p)
                  for p in glob.glob(pfad(SHARE, "themes", "ttk", "*.tcl"))}
        self.assertEqual(sorted(kopien - quellen), [],
                         "liegt nur in AppDir und ist nicht in Git")

    def test_die_engine_konfiguration_stimmt_ueberein(self):
        self.vergleiche(self.paare(("tcl", "engines", "engines.dat"), "engines"),
                        "build-appimage.sh gleicht sie ab")

    def test_die_wertungsskripte_stimmen_ueberein(self):
        self.vergleiche(self.paare(("tcl", "update-*-players.py"), "scripts"),
                        "build-appimage.sh gleicht sie ab")

    def test_jede_hilfedatei_liegt_auch_in_appdir(self):
        """Eine neue Hilfedatei kopiert das Bauskript nicht von selbst.

        Es kopiert nur, was im Ziel schon existiert ("[ -f $dest ] &&
        cp"). Der erste Kopiervorgang ist Handarbeit -- bleibt er aus,
        zeigt die Hilfe im Abbild die Seite nie.
        """
        fehlt, abweichend = [], []

        for quelle in sorted(glob.glob(pfad("tcl", "help", "*", "*.html"))):
            name = os.path.relpath(quelle, pfad("tcl", "help"))
            ziel = pfad(SHARE, "help", name)
            if not os.path.isfile(ziel):
                fehlt.append(name)
            elif not gleich(quelle, ziel):
                abweichend.append(name)

        self.assertEqual(fehlt, [],
                         "in AppDir fehlt die Hilfeseite -- einmal von Hand "
                         "kopieren, siehe CLAUDE.md")
        self.assertEqual(abweichend, [], "Hilfeseite weicht von der Kopie ab")

    def test_jedes_inhaltsverzeichnis_stimmt_ueberein(self):
        paare = []

        for quelle in sorted(glob.glob(pfad("tcl", "help", "*", "Contents.dat"))):
            sprache = os.path.basename(os.path.dirname(quelle))
            paare.append((quelle, pfad(SHARE, "help", sprache, "Contents.dat")))

        self.vergleiche(paare, "build-appimage.sh gleicht die Hilfe ab")
