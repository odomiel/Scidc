# ======================================================================
# Bruecke zu Lage 2: die C++-Unittests der DB-Schicht.
#
# Lage 1 prueft Text und laeuft in einem frischen Klon. Lage 2 braucht
# ein gebautes src/dbtest -- fehlt es, wird hier uebersprungen, nicht
# gemeldet. Ist es da, laeuft es mit und ein roter Lauf laesst auch den
# Pre-Commit-Hook abbrechen.
#
# Zusaetzlich zwei Dinge, die nur von aussen zu sehen sind:
#   * jede Datei src/tests/t_*.cpp muss in TEST_SRC des Makefiles
#     stehen, sonst laeuft sie stillschweigend nie mit;
#   * keine Sondierungsdatei darf liegenbleiben (t_probe_tmp.cpp,
#     t_dbg_tmp.cpp und Verwandte sind beim Messen entstanden und
#     gehoeren nicht in den Baum).
# ======================================================================

import glob
import os
import re
import subprocess
import unittest

from . import WURZEL, lies, pfad


def dbtest():
    """Pfad des gebauten Pruefstands, oder None."""
    p = pfad("src", "dbtest")
    return p if os.access(p, os.X_OK) else None


def test_quellen():
    """Alle Pruefdateien im Verzeichnis, ohne Pruefstand-Rahmen."""
    namen = sorted(os.path.basename(p)
                   for p in glob.glob(pfad("src", "tests", "t_*.cpp")))
    return [n for n in namen if n != "t_main.cpp"]


class TestLage2(unittest.TestCase):

    def test_jede_pruefdatei_steht_im_makefile(self):
        makefile = lies("src/Makefile")
        block = re.search(r"^TEST_SRC\s*=(.*?)^\s*$", makefile, re.M | re.S)
        self.assertIsNotNone(block, "TEST_SRC fehlt in src/Makefile")

        aufgefuehrt = set(re.findall(r"tests/(t_\w+\.cpp)", block.group(1)))

        for name in test_quellen():
            self.assertIn(name, aufgefuehrt,
                          f"{name} steht nicht in TEST_SRC und laeuft daher nie mit")

    def test_keine_sondierungsdatei_liegt_herum(self):
        # Beim Messen entstehen Dateien wie t_probe_tmp.cpp. Sie sind
        # nicht gitignored und gingen bei "git add -A" mit ins
        # Repository, das bei jedem Push oeffentlich wird.
        uebrig = [n for n in test_quellen()
                  if "tmp" in n or "probe" in n or "dbg" in n or "DEBUG" in n]
        self.assertEqual(uebrig, [], f"Sondierungsdateien im Baum: {uebrig}")

    def test_pruefstand_hat_keine_debug_ausgaben(self):
        for name in test_quellen() + ["t_main.cpp"]:
            text = lies(f"src/tests/{name}")
            self.assertNotIn("DEBUG", text, f"{name} enthaelt eine DEBUG-Spur")

    def test_dbtest_laeuft_durch(self):
        programm = dbtest()

        if programm is None:
            raise unittest.SkipTest("src/dbtest nicht gebaut (make -C src check)")

        ergebnis = subprocess.run([programm], cwd=WURZEL,
                                  stdout=subprocess.PIPE,
                                  stderr=subprocess.STDOUT,
                                  timeout=300)
        ausgabe = ergebnis.stdout.decode("utf-8", "replace")

        self.assertEqual(ergebnis.returncode, 0, ausgabe)
        self.assertIn("OK", ausgabe, ausgabe)

        zahlen = re.search(r"(\d+) Faelle, (\d+) Pruefungen, (\d+) fehlgeschlagen",
                           ausgabe)
        self.assertIsNotNone(zahlen, ausgabe)
        self.assertEqual(int(zahlen.group(3)), 0, ausgabe)

        # Ein Lauf ohne Faelle waere gruen und wertlos.
        self.assertGreater(int(zahlen.group(1)), 0, ausgabe)
        self.assertGreater(int(zahlen.group(2)), int(zahlen.group(1)), ausgabe)

    def test_jede_gruppe_meldet_sich(self):
        programm = dbtest()

        if programm is None:
            raise unittest.SkipTest("src/dbtest nicht gebaut (make -C src check)")

        ausgabe = subprocess.run([programm], cwd=WURZEL,
                                 stdout=subprocess.PIPE,
                                 stderr=subprocess.STDOUT,
                                 timeout=300).stdout.decode("utf-8", "replace")

        # Die Gruppennamen stehen in den Quellen; jede muss im Lauf
        # auftauchen. Sonst ist eine Datei gebunden, aber ihre Faelle
        # melden sich nicht an.
        gruppen = set()

        for name in test_quellen():
            gruppen.update(re.findall(r"^TEST\((\w+),", lies(f"src/tests/{name}"), re.M))

        for gruppe in sorted(gruppen):
            self.assertIn(gruppe, ausgabe, f"Gruppe {gruppe} fehlt im Lauf")


if __name__ == "__main__":
    unittest.main()
