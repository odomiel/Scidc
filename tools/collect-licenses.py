#!/usr/bin/env python3
# ======================================================================
# Sammelt die Lizenztexte der Bibliotheken, die build-appimage.sh per ldd
# ins Paket legt, und schreibt sie nach licenses/.
#
# Warum ueberhaupt: MIT, BSD, zlib, libpng und die FreeType-Lizenz (FTL)
# verlangen alle, dass Copyright- und Erlaubnisvermerk der *Binaer*weitergabe
# beiliegen. Ein Link auf das Projekt erfuellt das nicht. Die Texte muessen
# also mit ins AppImage, und build-appimage.sh kopiert licenses/ dorthin.
#
# Quelle ist /usr/share/doc/<paket>/copyright des Bausystems -- die Fassung,
# die zu genau der ausgelieferten Bibliothek gehoert. Das Format ist DEP-5:
# eigenstaendige Lizenzabsaetze bestehen aus "License: <name>" und darauf
# folgenden, um ein Leerzeichen eingerueckten Zeilen; ein einzelner Punkt in
# dieser Einrueckung steht fuer eine Leerzeile.
#
# Aufruf:  python3 tools/collect-licenses.py [--check]
#   --check  schreibt nichts, meldet nur Abweichungen (Rueckgabewert 1)
# ======================================================================

import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUTDIR = os.path.join(ROOT, "licenses")
DOCDIR = "/usr/share/doc"

# Welche Bibliothek im AppImage kommt aus welchem Paket, und welcher
# Lizenzabsatz gilt fuer sie. Mehrere Bibliotheken teilen sich teils einen
# Text (die X11-Familie), der wird dann einmal abgelegt.
COMPONENTS = [
    # (Zieldatei,        Paket,              Lizenzname in DEP-5, Bibliotheken)
    ("freetype.txt",     "libfreetype6",     "FTL",          ["libfreetype.so.6"]),
    ("libpng.txt",       "libpng16-16t64",   "libpng",       ["libpng16.so.16"]),
    ("fontconfig.txt",   "libfontconfig1",   None,           ["libfontconfig.so.1"]),
    ("brotli.txt",       "libbrotli1",       "MIT",          ["libbrotlicommon.so.1",
                                                              "libbrotlidec.so.1"]),
    ("bzip2.txt",        "libbz2-1.0",       "BSD-variant",  ["libbz2.so.1.0"]),
    ("libuuid.txt",      "libuuid1",         "BSD-3-clause", ["libuuid.so.1"]),
    ("libx11.txt",       "libx11-6",         None,           ["libX11.so.6"]),
    ("libxcb.txt",       "libxcb1",          None,           ["libxcb.so.1"]),
    ("libxau.txt",       "libxau6",          None,           ["libXau.so.6"]),
    ("libxdmcp.txt",     "libxdmcp6",        None,           ["libXdmcp.so.6"]),
    ("libxext.txt",      "libxext6",         None,           ["libXext.so.6"]),
    ("libxrender.txt",   "libxrender1",      None,           ["libXrender.so.1"]),
    ("libxfixes.txt",    "libxfixes3",       None,           ["libXfixes.so.3"]),
    ("libxcursor.txt",   "libxcursor1",      None,           ["libXcursor.so.1"]),
    ("libxft.txt",       "libxft2",          None,           ["libXft.so.2"]),
    ("libxss.txt",       "libxss1",          None,           ["libXss.so.1"]),
    ("libsm.txt",        "libsm6",           None,           ["libSM.so.6"]),
    ("libice.txt",       "libice6",          None,           ["libICE.so.6"]),
    ("libstdc++.txt",    "libstdc++6",       None,           ["libstdc++.so.6"]),
]

# expat und zlib kommen nicht mehr vom Bausystem, sondern aus dem Baum --
# ihre Lizenz steht dort und ist die massgebliche.
FROM_TREE = [
    ("expat.txt", "src/util/expat/COPYING", ["libexpat.so.1 (fontconfig) und die "
                                             "statisch gebundene Kopie im Programm"]),
    ("tcltk.txt", "src/tk/license.terms",   ["libtcl9.0.so", "libtcl9tk9.0.so"]),
]

# zlib fuehrt seine Lizenz nur im Kopf von zlib.h -- dort steht der
# massgebliche Text, und er gilt sowohl fuer die statisch gebundene Kopie
# als auch fuer das mitgelieferte libz.so.1.
FROM_HEADER = [
    ("zlib.txt", "src/util/zlib/zlib.h",
     ["libz.so.1 und die statisch gebundene Kopie im Programm"]),
]


def undep5(block):
    """Macht aus einem DEP-5-Absatz wieder gewoehnlichen Text."""
    out = []
    for line in block.split("\n"):
        line = line[1:] if line.startswith(" ") else line
        out.append("" if line.strip() == "." else line)
    return "\n".join(out).strip("\n")


def license_body(pkg, name):
    """Liefert den laengsten eigenstaendigen Lizenzabsatz eines Pakets.

    Nicht jedes Paket benutzt DEP-5 -- die X.Org-Bibliotheken und libstdc++
    fuehren ihre copyright-Datei frei formuliert. Dann wird sie vollstaendig
    uebernommen: sie *ist* der Vermerk, den das Bausystem mit der Bibliothek
    ausliefert, und genau der muss weitergereicht werden.
    """
    path = os.path.join(DOCDIR, pkg, "copyright")
    if not os.path.exists(path):
        return None, f"{path} fehlt"
    text = open(path, encoding="utf-8", errors="replace").read()

    best = None
    for m in re.finditer(r"^License: (\S+)\s*\n((?: .*\n|\n(?= ))+)", text, re.M):
        got, body = m.group(1), m.group(2)
        if name and got != name:
            continue
        body = undep5(body)
        if len(body) < 200:        # blosse Verweise, kein Volltext
            continue
        if best is None or len(body) > len(best[1]):
            best = (got, body)
    if best is not None:
        return best, None

    if name:                       # ein Name war gefordert und fehlt -- Fehler
        return None, f"kein Volltext fuer License: {name} in {pkg}"
    return ("vollstaendige copyright-Datei", text.strip("\n")), None


def build():
    files, problems = {}, []

    for fname, pkg, name, libs in COMPONENTS:
        got, err = license_body(pkg, name)
        if err:
            problems.append(err)
            continue
        lic, body = got
        head = (f"Lizenz von: {', '.join(libs)}\n"
                f"Paket:      {pkg}\n"
                f"Lizenz:     {lic}\n")
        files[fname] = head + "=" * 70 + "\n\n" + body + "\n"

    for fname, relpath, libs in FROM_HEADER:
        path = os.path.join(ROOT, relpath)
        if not os.path.exists(path):
            problems.append(f"{relpath} fehlt")
            continue
        text = open(path, encoding="utf-8", errors="replace").read()
        m = re.search(r"This software is provided 'as-is'.*?"
                      r"^\s*\S+@\S+\s+\S+@\S+\s*$", text, re.S | re.M)
        if not m:
            problems.append(f"Lizenzblock in {relpath} nicht gefunden")
            continue
        body = "\n".join(l[2:] if l.startswith("  ") else l
                         for l in m.group(0).split("\n")).strip("\n")
        head = (f"Lizenz von: {', '.join(libs)}\n"
                f"Quelle:     {relpath} (Kopf)\n"
                f"Lizenz:     zlib\n")
        files[fname] = head + "=" * 70 + "\n\n" + body + "\n"

    for fname, relpath, libs in FROM_TREE:
        path = os.path.join(ROOT, relpath)
        if not os.path.exists(path):
            problems.append(f"{relpath} fehlt")
            continue
        body = open(path, encoding="utf-8", errors="replace").read().strip("\n")
        head = (f"Lizenz von: {', '.join(libs)}\n"
                f"Quelle:     {relpath}\n")
        files[fname] = head + "=" * 70 + "\n\n" + body + "\n"

    return files, problems


def main():
    check = "--check" in sys.argv
    files, problems = build()

    for p in problems:
        print(f"  FEHLT: {p}", file=sys.stderr)

    changed = []
    for fname, content in sorted(files.items()):
        target = os.path.join(OUTDIR, fname)
        old = open(target, encoding="utf-8").read() if os.path.exists(target) else None
        if old != content:
            changed.append(fname)
            if not check:
                os.makedirs(OUTDIR, exist_ok=True)
                open(target, "w", encoding="utf-8").write(content)

    verb = "abweichend" if check else "geschrieben"
    print(f"  {len(files)} Lizenzdateien, {len(changed)} {verb}"
          + (f": {', '.join(changed)}" if changed else ""))

    if check and (changed or problems):
        return 1
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
