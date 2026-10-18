# ======================================================================
# Was mitgeliefert wird und was dazu beiliegen muss.
#
# Zwei Dinge sichert diese Datei:
#
#  * Die Lizenztexte. MIT, BSD, zlib, libpng und FreeType verlangen, dass
#    Copyright- und Erlaubnisvermerk der Binaerweitergabe beiliegen -- ein
#    Verweis auf die Projektseite genuegt nicht. build-appimage.sh legt
#    licenses/ ins Abbild, also muss der Ordner gefuellt sein.
#  * Die Versionen der aus dem Baum gebauten Bibliotheken. Sie werden an
#    genau den Stellen gelesen, an denen tools/check-updates.py sie liest.
#    Verschiebt sich dort ein #define, meldet die taegliche Pruefung
#    stillschweigend nichts mehr -- und niemand merkt, dass eine CVE
#    offen steht.
# ======================================================================

import os
import re
import unittest

from . import lies, pfad

#: Dieselben Fundstellen wie in tools/check-updates.py.
BIBLIOTHEKEN = (
    ("expat", "src/util/expat/expat.h",
     (r"^#\s*define\s+XML_MAJOR_VERSION\s+(\d+)",
      r"^#\s*define\s+XML_MINOR_VERSION\s+(\d+)",
      r"^#\s*define\s+XML_MICRO_VERSION\s+(\d+)")),
    ("zlib", "src/util/zlib/zlib.h",
     (r'^#\s*define\s+ZLIB_VERSION\s+"([^"]+)"',)),
    ("minizip-ng", "src/util/minizip/mz.h",
     (r'#define\s+MZ_VERSION\s+\("([^"]+)"\)',)),
    ("libharu", "src/util/libharu/hpdf_version.h",
     (r"^#define\s+HPDF_MAJOR_VERSION\s+(\d+)",
      r"^#define\s+HPDF_MINOR_VERSION\s+(\d+)",
      r"^#define\s+HPDF_BUGFIX_VERSION\s+(\d+)")),
    ("zziplib", "src/util/zzip/_config.h",
     (r'^#define\s+ZZIP_VERSION\s+"([^"]+)"',)),
)


class TestLizenztexte(unittest.TestCase):
    def test_die_gpl_liegt_bei(self):
        text = lies("COPYING", "latin-1")
        self.assertIn("GNU GENERAL PUBLIC LICENSE", text)
        self.assertIn("Version 2", text)

    def test_der_copyright_vermerk_nennt_das_pseudonym(self):
        """Das Projekt firmiert durchgehend unter Mirik."""
        self.assertIn("Mirik", lies("COPYRIGHT", "latin-1"))

    def test_der_lizenzordner_ist_gefuellt(self):
        ordner = pfad("licenses")
        texte = [n for n in os.listdir(ordner) if n.endswith(".txt")]
        self.assertGreaterEqual(len(texte), 20,
                                "licenses/ sollte die Texte der gebuendelten "
                                "Bibliotheken fuehren")

    def test_kein_lizenztext_ist_leer(self):
        ordner = pfad("licenses")
        for name in sorted(os.listdir(ordner)):
            if not name.endswith(".txt"):
                continue
            with self.subTest(datei=name):
                self.assertGreater(os.path.getsize(os.path.join(ordner, name)), 200,
                                   "%s ist zu kurz fuer einen Lizenztext" % name)

    def test_die_texte_der_aus_dem_baum_gebauten_bibliotheken_liegen_bei(self):
        """expat, zlib und Tcl/Tk kommen aus dem Baum selbst."""
        vorhanden = set(os.listdir(pfad("licenses")))
        for name in ("expat.txt", "zlib.txt", "tcltk.txt"):
            with self.subTest(datei=name):
                self.assertIn(name, vorhanden)

    def test_der_ordner_erklaert_sich_selbst(self):
        text = lies("licenses/README")
        self.assertIn("collect-licenses.py", text)
        self.assertIn("build-appimage.sh", text)

    def test_das_abbild_bekommt_den_ordner(self):
        self.assertIn("licenses", lies("build-appimage.sh"))


class TestMitgelieferteBibliotheken(unittest.TestCase):
    def test_jede_version_laesst_sich_lesen(self):
        """Faellt eine Fundstelle aus, prueft check-updates.py sie nicht mehr."""
        for name, datei, ausdruecke in BIBLIOTHEKEN:
            with self.subTest(baustein=name):
                self.assertTrue(os.path.isfile(pfad(datei)), "%s fehlt" % datei)
                text = lies(datei, "latin-1")
                teile = []
                for ausdruck in ausdruecke:
                    treffer = re.search(ausdruck, text, re.M)
                    self.assertIsNotNone(
                        treffer, "%s: %s findet nichts mehr" % (datei, ausdruck))
                    teile.append(treffer.group(1))
                self.assertRegex(".".join(teile), r"^\d+(\.\d+)*$")

    def test_der_quellbaum_traegt_expat_vollstaendig(self):
        """Die fruehere Teilkopie war nicht uebersetzbar und fiel fuer die
        fehlenden Koepfe auf /usr/include durch -- Kopf und Bibliothek
        stammten aus verschiedenen Fassungen."""
        for name in ("expat.h", "expat_external.h", "internal.h", "siphash.h",
                     "xmlparse.c", "xmltok.c", "xmlrole.c", "xcs.c", "xcs.h",
                     "random_arc4random.c", "random_getentropy.c", "winconfig.h"):
            with self.subTest(datei=name):
                self.assertTrue(os.path.isfile(pfad("src/util/expat", name)),
                                "src/util/expat/%s fehlt" % name)

    def test_expat_waehlt_den_systemaufruf_getrandom(self):
        """arc4random_buf braucht glibc >= 2.36 und hob die Untergrenze
        des AppImage. Ohne eine Entropiequelle fiele expat auf Zeit und
        PID zurueck."""
        text = lies("src/util/expat/expat_config.h")
        self.assertIsNotNone(
            re.search(r"^#\s*define\s+HAVE_SYSCALL_GETRANDOM\b", text, re.M),
            "HAVE_SYSCALL_GETRANDOM ist nicht gesetzt")
        self.assertIsNone(
            re.search(r"^#\s*define\s+HAVE_ARC4RANDOM_BUF\b", text, re.M),
            "arc4random_buf hebt die glibc-Untergrenze des AppImage")
        self.assertIsNotNone(
            re.search(r"^#\s*define\s+XML_DEV_URANDOM\b", text, re.M),
            "ohne Rueckfallweg faellt expat auf Zeit und PID zurueck")

    def test_zlib_bekommt_seine_schalter_im_makefile(self):
        """Ohne zlibs configure fehlt das erzeugte zconf.h: ohne
        Z_HAVE_UNISTD_H ist lseek in gzlib.c nicht erklaert, ohne
        _LARGEFILE64_SOURCE fehlen gzopen64 und Co."""
        text = lies("src/util/zlib/Makefile")
        self.assertIn("Z_HAVE_UNISTD_H", text)
        self.assertIn("_LARGEFILE64_SOURCE", text)

    def test_minizip_wird_ohne_aes_gebaut(self):
        """Die AES-Verschluesselung ist nicht gebuendelt.

        Wer mz_strm_wzaes.h einbindet, muss das hinter #ifdef HAVE_WZAES
        tun -- die AES-Dateien selbst ausgenommen, die werden nicht
        uebersetzt.
        """
        eigene = ("mz_strm_wzaes.c", "mz_strm_wzaes.h")
        for name in sorted(os.listdir(pfad("src/util/minizip"))):
            if not name.endswith((".c", ".h")) or name in eigene:
                continue
            text = lies(os.path.join("src/util/minizip", name), "latin-1")
            if "mz_strm_wzaes.h" not in text:
                continue
            with self.subTest(datei=name):
                self.assertTrue("HAVE_WZAES" in text,
                                "%s bindet mz_strm_wzaes.h ohne #ifdef "
                                "HAVE_WZAES ein" % name)

    def test_das_minizip_makefile_uebersetzt_die_aes_dateien_nicht(self):
        text = lies("src/util/minizip/Makefile")
        self.assertIn("MZ_ZIP_NO_CRYPTO", text)
        self.assertNotIn("mz_strm_wzaes.o", text)
