# ======================================================================
# Eigenschaften des Quellbaums, die sich still verlieren.
#
# Vier wiederkehrende Fallen, jede schon einmal eingetreten:
#
#   * **SI5 in den Format-Gates.** format::Scid5 wurde nachtraeglich
#     eingefuehrt; unzaehlige Gates zaehlen nur Scidb/Scid3/Scid4 auf.
#     Geprueft wird darum jede Stelle, die Scid4 nennt, ohne Scid5 im
#     Umfeld -- mit benannten Ausnahmen samt Grund.
#   * **Mixed-Encoding-Quellen.** Einzelne C++-Dateien tragen Latin-1-
#     Bytes in Kommentaren. Das Edit-Werkzeug schreibt sie als
#     UTF-8-Ersatzzeichen zurueck und beschaedigt die Datei auch dann,
#     wenn die betroffene Zeile gar nicht angefasst wurde. Die Liste
#     muss stimmen, sonst greift die Vorsichtsmassnahme am falschen Ort.
#   * **SOURCES in tcl/Makefile.** Was dort fehlt, landet nicht im
#     Bundle und ist zur Laufzeit einfach nicht da.
#   * **Der Engine-Katalog.** Jede geladene Datei wird gegen ihre
#     SHA-256 geprueft, bevor sie ausfuehrbar gemacht wird. Fehlt die
#     Pruefsumme, faellt diese Sicherung lautlos weg.
# ======================================================================

import glob
import os
import re
import unittest

from . import lies, lies_bytes, pfad


# Fremdcode: eigene Kodierungs- und Formatregeln, nicht unsere Sache.
FREMDBAEUME = (
    "src/tk/text/", "src/tk/treectrl/", "src/tk/html/",
    "src/util/expat/", "src/util/zlib/", "src/util/minizip/",
    "src/util/libharu/", "src/util/zzip/", "src/util/lzo/",
)

# Stellen, die Scid4 ohne Scid5 nennen duerfen -- mit Grund:
SCID4_OHNE_SCID5 = {
    # CustomFlags gibt es nur fuer SI4: makeCodec legt sie allein im
    # Scid4-Zweig an, SI5 bekommt ausdruecklich nullptr.
    ("src/db/db_database_codec.ipp", "customFlags"),
    # Nur ein Kommentar; der else-Zweig behandelt SI5 mit (si3::Consumer).
    ("src/db/db_database.cpp", "comment"),
    # Absicht: fuer ein SI5-Ziel bleibt useConsumer true. Der direkte
    # Scid->Scid-Weg setzt gleiche Satzstruktur voraus, und SI5 hat eine
    # andere Index- und Namensbasis. Nachgeprueft 26.10.28.
    ("src/db/db_database.cpp", "useConsumer"),
}

# Diese C++-Quellen sind NICHT gueltiges UTF-8 (Latin-1-Bytes in
# Kommentaren). Sie duerfen nur ueber Python-Binary-I/O bearbeitet
# werden, niemals mit dem Edit-Werkzeug.
LATIN1_QUELLEN = {
    "src/db/cbh/cbh_codec.cpp",     # "Dgernesy" im Kommentar
    "src/db/db_site.cpp",           # Ortsname
    "src/sys/sys_utf8_codec.cpp",   # Beispielbytes im Kommentar
    "src/util/u_emoticons.cpp",     # Zeichentabelle
}

# tcl-Dateien, die absichtlich nicht im Bundle stehen:
NICHT_IM_BUNDLE_MUSTER = ("pieces/", "dnd/tkdnd_macosx.tcl", "dnd/tkdnd_windows.tcl")
NICHT_IM_BUNDLE = {
    "contrib/tktext.tcl",       # Fremdwidget, nicht eingebunden
    "contrib/try.tcl",          # von Tcl 9 selbst mitgebracht
    "tools/board.tcl",          # Hilfsprogramm, laeuft eigenstaendig
    "widgets/progressbar.tcl",  # ungenutzt; vgl. dialogs/progressbar.tcl
}


def eigene_cpp_quellen():
    """Alle C++-Quellen des Projekts, ohne Fremdbaeume."""
    for p in sorted(glob.glob(pfad("src", "**", "*.*"), recursive=True)):
        rel = os.path.relpath(p, pfad()).replace(os.sep, "/")
        if rel.endswith((".cpp", ".h", ".ipp")) \
                and not rel.startswith(FREMDBAEUME):
            yield rel


class TestFormatGates(unittest.TestCase):

    def test_si5_wird_nicht_vergessen(self):
        offen = []

        for rel in eigene_cpp_quellen():
            if not rel.startswith("src/db/"):
                continue

            zeilen = lies(rel, "latin-1").split("\n")

            for i, zeile in enumerate(zeilen):
                if "format::Scid4" not in zeile or "Scid5" in zeile:
                    continue

                umfeld = "\n".join(zeilen[max(0, i - 8):i + 9])

                if "Scid5" in umfeld:
                    continue

                marke = ("comment" if zeile.lstrip().startswith(("//", "else //"))
                         else "customFlags" if "customFlags" in umfeld
                         else "useConsumer" if "useConsumer" in umfeld
                         else "?")

                if (rel, marke) not in SCID4_OHNE_SCID5:
                    offen.append(f"{rel}:{i + 1}: {zeile.strip()}")

        self.assertEqual(offen, [], "Format-Gate ohne Scid5:\n" + "\n".join(offen))


class TestKodierungen(unittest.TestCase):

    def test_die_latin1_liste_stimmt(self):
        gemessen = set()

        for rel in eigene_cpp_quellen():
            roh = lies_bytes(rel)

            if not any(b > 127 for b in roh):
                continue

            try:
                roh.decode("utf-8")
            except UnicodeDecodeError:
                gemessen.add(rel)

        self.assertEqual(gemessen, LATIN1_QUELLEN)

    def test_die_gelisteten_dateien_sind_vorhanden(self):
        for rel in sorted(LATIN1_QUELLEN):
            self.assertTrue(os.path.exists(pfad(rel)), rel)


class TestBundleQuellen(unittest.TestCase):

    def sources(self):
        mk = lies("tcl/Makefile")
        block = re.search(r"^SOURCES\s*=(.*?)(?=^\w|\Z)", mk, re.M | re.S)
        self.assertIsNotNone(block, "SOURCES fehlt in tcl/Makefile")
        return set(re.findall(r"([\w./-]+\.tcl)", block.group(1)))

    def test_jeder_eintrag_existiert(self):
        # Ein Eintrag ohne Datei laesst cat im Makefile scheitern und das
        # Bundle halb entstehen.
        for name in sorted(self.sources()):
            self.assertTrue(os.path.exists(pfad("tcl", name)),
                            f"SOURCES nennt tcl/{name}, die Datei fehlt")

    def test_jede_tcl_datei_ist_eingeordnet(self):
        aufgefuehrt = self.sources()
        vergessen = []

        for p in glob.glob(pfad("tcl", "**", "*.tcl"), recursive=True):
            rel = os.path.relpath(p, pfad("tcl")).replace(os.sep, "/")

            if rel.startswith(("lang/", "themes/", "help/")):
                continue    # werden zur Laufzeit von der Platte geladen
            if rel.startswith(NICHT_IM_BUNDLE_MUSTER) or rel in NICHT_IM_BUNDLE:
                continue
            if rel not in aufgefuehrt:
                vergessen.append(rel)

        self.assertEqual(vergessen, [],
                         "weder in SOURCES noch als Ausnahme benannt: "
                         + ", ".join(vergessen))


class TestEngineKatalog(unittest.TestCase):

    def katalog(self):
        text = lies("tcl/engines/downloads.dat")
        # Je Engine ein Block, erkennbar am Id-Feld.
        bloecke = re.split(r"^\t\{$", text, flags=re.M)[1:]
        self.assertTrue(bloecke, "kein Engine-Block gefunden")
        return bloecke

    def test_jede_engine_fuehrt_die_pflichtfelder(self):
        for block in self.katalog():
            for feld in ("Id", "Name", "Repo", "Version", "Tag", "Protocol",
                         "Archive", "Target", "Builds"):
                # re.M ist Pflicht: ohne das greift ^ nur am Blockanfang.
                self.assertIsNotNone(
                    re.search(r"^\s*" + feld + r"\s", block, re.M),
                    f"Feld {feld} fehlt:\n{block[:200]}")

    def test_jeder_build_tragt_pruefsumme_und_groesse(self):
        # Die geladene Datei wird gegen die SHA-256 geprueft, bevor sie
        # ausfuehrbar gemacht wird; ohne sie faellt das lautlos weg.
        gefunden = 0

        for block in self.katalog():
            builds = re.search(r"Builds\s*\{(.*?)\n\t\t\}", block, re.S)
            self.assertIsNotNone(builds, block[:200])

            for zeile in builds.group(1).strip().split("\n"):
                zeile = zeile.strip()

                if not zeile.startswith("{"):
                    continue

                self.assertRegex(zeile, r"\b[0-9a-f]{64}\b",
                                 f"keine SHA-256: {zeile}")
                self.assertRegex(zeile, r"\b[0-9a-f]{64}\s+(\d+)\b",
                                 f"keine Groesse: {zeile}")
                groesse = int(re.search(r"\b[0-9a-f]{64}\s+(\d+)\b", zeile).group(1))
                self.assertGreater(groesse, 1000, zeile)
                gefunden += 1

        self.assertGreaterEqual(gefunden, 6, "zu wenige Builds im Katalog")


if __name__ == "__main__":
    unittest.main()
