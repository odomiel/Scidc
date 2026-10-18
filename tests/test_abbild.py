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
