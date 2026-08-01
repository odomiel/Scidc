#!/usr/bin/env python3
# ======================================================================
# Erzeugt tcl/engines/downloads.dat aus den Release-Daten der
# Originalprojekte.
#
# Der Katalog pinnt je Engine eine feste Version mit URL, Groesse und
# SHA-256. Die Pruefsummen liefert die GitHub-API im digest-Feld der
# Release-Anhaenge mit; fehlt sie (aeltere Anhaenge), wird die Datei
# einmal geladen und die Summe berechnet.
#
#   python3 tools/make-engine-catalog.py                # alles neu
#   python3 tools/make-engine-catalog.py --dry-run      # nur anzeigen
#   python3 tools/make-engine-catalog.py -e stockfish   # nur eine Engine
#
# Die untenstehende Tabelle ist der von Hand gepflegte Teil: welche
# Engine, welche Dateien je Prozessorvariante, wo im Archiv das Programm
# liegt. Ueblicherweise aendert sich daran nichts - nur wenn ein Projekt
# seine Dateinamen umstellt.
#
# Platzhalter in Dateinamen und Pfaden:
#   %TAG%  der Release-Tag        (sf_18, v8.0.0, 20240817)
#   %VER%  Tag ohne fuehrendes v  (8.0.0)
#   %MAJ%  erstes Feld von %VER%  (8)
# ======================================================================

import argparse
import hashlib
import json
import os
import re
import sys
import urllib.error
import urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TARGET = os.path.join(ROOT, "tcl", "engines", "downloads.dat")

# Archive : plain | tar | tar.gz | zip
# Extra   : weitere Dateien aus dem Archiv, die neben das Programm gehoeren
#           (z.B. Netzdateien). Muster duerfen Platzhalter enthalten.
# Extract : binary (nur das Programm) | all (ganzes Archiv, z.B. wegen Netzdatei)
# Builds  : (Kennung, benoetigte /proc/cpuinfo-Merkmale, Anhang, Pfad im Archiv)
#           von der schnellsten zur genuegsamsten Variante
SPECS = [
    dict(
        id="stockfish", name="Stockfish", author="The Stockfish developers",
        home="https://stockfishchess.org", repo="official-stockfish/Stockfish",
        archive="tar", extract="binary", target="stockfish",
        builds=[
            ("avx512icl",    "avx512vbmi avx512vnni", "stockfish-ubuntu-x86-64-avx512icl.tar",    "stockfish/stockfish-ubuntu-x86-64-avx512icl"),
            ("avx512",       "avx512f",               "stockfish-ubuntu-x86-64-avx512.tar",       "stockfish/stockfish-ubuntu-x86-64-avx512"),
            ("bmi2",         "avx2 bmi2",             "stockfish-ubuntu-x86-64-bmi2.tar",         "stockfish/stockfish-ubuntu-x86-64-bmi2"),
            ("avx2",         "avx2",                  "stockfish-ubuntu-x86-64-avx2.tar",         "stockfish/stockfish-ubuntu-x86-64-avx2"),
            ("sse41-popcnt", "sse4_1 popcnt",         "stockfish-ubuntu-x86-64-sse41-popcnt.tar", "stockfish/stockfish-ubuntu-x86-64-sse41-popcnt"),
            ("generic",      "",                      "stockfish-ubuntu-x86-64.tar",              "stockfish/stockfish-ubuntu-x86-64"),
        ]),
    dict(
        id="fairy-stockfish", name="Fairy-Stockfish", author="Fabian Fichter",
        home="https://fairy-stockfish.github.io", repo="fairy-stockfish/Fairy-Stockfish",
        archive="plain", extract="binary", target="fairy-stockfish",
        builds=[
            ("bmi2",    "avx2 bmi2",     "fairy-stockfish-largeboard_x86-64-bmi2",   ""),
            ("modern",  "sse4_1 popcnt", "fairy-stockfish-largeboard_x86-64-modern", ""),
            ("generic", "",              "fairy-stockfish-largeboard_x86-64",        ""),
        ]),
    dict(
        id="rubichess", name="RubiChess", author="Andreas Matthies",
        home="https://github.com/Matthies/RubiChess", repo="Matthies/RubiChess",
        archive="zip", extract="binary", target="rubichess",
        # RubiChess laedt sein Netz aus dem Verzeichnis des Programms.
        extra=["RubiChess-%TAG%/*.nnue"],
        builds=[
            ("avx512",  "avx512f",       "RubiChess-%TAG%.zip", "RubiChess-%TAG%/linux/RubiChess-%TAG%_x86-64-avx512"),
            ("bmi2",    "avx2 bmi2",     "RubiChess-%TAG%.zip", "RubiChess-%TAG%/linux/RubiChess-%TAG%_x86-64-bmi2"),
            ("avx2",    "avx2",          "RubiChess-%TAG%.zip", "RubiChess-%TAG%/linux/RubiChess-%TAG%_x86-64-avx2"),
            ("modern",  "sse4_1 popcnt", "RubiChess-%TAG%.zip", "RubiChess-%TAG%/linux/RubiChess-%TAG%_x86-64-modern"),
            ("generic", "",              "RubiChess-%TAG%.zip", "RubiChess-%TAG%/linux/RubiChess-%TAG%_x86-64"),
        ]),
    dict(
        id="stormphrax", name="Stormphrax", author="Ciekce",
        home="https://github.com/Ciekce/Stormphrax", repo="Ciekce/Stormphrax",
        archive="plain", extract="binary", target="stormphrax",
        builds=[
            ("avx512",    "avx512f",   "stormphrax-%VER%-avx512",    ""),
            ("zen2",      "avx2 bmi2", "stormphrax-%VER%-zen2",      ""),
            ("avx2-bmi2", "avx2 bmi2", "stormphrax-%VER%-avx2-bmi2", ""),
        ]),
    dict(
        id="viridithas", name="Viridithas", author="Cosmo Bobak",
        home="https://github.com/cosmobobak/viridithas", repo="cosmobobak/viridithas",
        archive="plain", extract="binary", target="viridithas",
        builds=[
            ("x86-64-v4", "avx512f",   "viridithas-%MAJ%-linux-x86-64-v4", ""),
            ("x86-64-v3", "avx2 bmi2", "viridithas-%MAJ%-linux-x86-64-v3", ""),
        ]),
    dict(
        id="arasan", name="Arasan", author="Jon Dart",
        home="https://www.arasanchess.org", repo="jdart1/arasan-chess",
        # Arasan braucht seine Netzdatei neben dem Programm, deshalb "all".
        archive="tar.gz", extract="all", target="arasanx-64",
        builds=[
            ("avx512",    "avx512f",       "arasan-linux-binaries-%VER%.tar.gz", "arasanx-64-avx512"),
            ("avx2-bmi2", "avx2 bmi2",     "arasan-linux-binaries-%VER%.tar.gz", "arasanx-64-avx2-bmi2"),
            ("avx2",      "avx2",          "arasan-linux-binaries-%VER%.tar.gz", "arasanx-64-avx2"),
            ("modern",    "sse4_1 popcnt", "arasan-linux-binaries-%VER%.tar.gz", "arasanx-64-modern"),
            ("generic",   "",              "arasan-linux-binaries-%VER%.tar.gz", "arasanx-64"),
        ]),
]

# Nur zur Anzeige: aus dem Tag eine lesbare Version machen.
VERSION_PREFIXES = ("sf_", "fairy_sf_", "v")


def readable(tag):
    for p in VERSION_PREFIXES:
        if tag.startswith(p):
            return tag[len(p):]
    return tag


def api(path):
    req = urllib.request.Request(
        "https://api.github.com" + path,
        headers={"Accept": "application/vnd.github+json",
                 "User-Agent": "scidc-catalog-generator"})
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.load(r)


def sha256_of(url, size):
    print(f"      lade {size/1e6:.1f} MB zum Berechnen der Pruefsumme ...", file=sys.stderr)
    h = hashlib.sha256()
    with urllib.request.urlopen(url, timeout=600) as r:
        while True:
            chunk = r.read(1 << 20)
            if not chunk:
                break
            h.update(chunk)
    return h.hexdigest()


def collect(spec):
    """Liefert (tag, version, builds, fehlende Anhaenge, Beidateien)."""
    rel = api(f"/repos/{spec['repo']}/releases/latest")
    tag = rel["tag_name"]
    ver = readable(tag)
    maj = ver.split(".")[0]

    def sub(s):
        return s.replace("%TAG%", tag).replace("%VER%", ver).replace("%MAJ%", maj)

    by_name = {a["name"]: a for a in rel.get("assets", [])}
    cache, builds, missing = {}, [], []

    for bid, flags, asset, member in spec["builds"]:
        asset, member = sub(asset), sub(member)
        a = by_name.get(asset)
        if a is None:
            missing.append(asset)
            continue
        digest = a.get("digest") or ""
        if digest.startswith("sha256:"):
            sha = digest.split(":", 1)[1]
        elif asset in cache:
            sha = cache[asset]
        else:
            sha = cache[asset] = sha256_of(a["browser_download_url"], a["size"])
        builds.append((bid, flags, asset, sha, a["size"], member))

    extra = [sub(x) for x in spec.get("extra", [])]
    return tag, ver, builds, missing, extra


def render(entries):
    out = [
        "# Scidc engine download catalog",
        "#",
        "# Erzeugt von tools/make-engine-catalog.py aus den Release-Daten der",
        "# Originalprojekte. Nicht von Hand bearbeiten - die Engine-Tabelle steht",
        "# im Skript.",
        "#",
        "# Je Engine eine feste Version; die SHA-256 stammen aus GitHubs",
        "# digest-Feld bzw. wurden beim Erzeugen berechnet. Jede geladene Datei",
        "# wird dagegen geprueft, bevor sie ausfuehrbar gemacht wird.",
        "#",
        "# Syntax: Tcl language format",
        "",
        "set ::engine::download::Catalog {",
    ]
    for spec, tag, ver, builds, extra in entries:
        out += [
            "\t{",
            f"\t\tId\t\t\t{spec['id']}",
            f"\t\tName\t\t\"{spec['name']}\"",
            f"\t\tAuthor\t\t\"{spec['author']}\"",
            f"\t\tHomepage\t{spec['home']}",
            f"\t\tRepo\t\t{spec['repo']}",
            f"\t\tVersion\t\t\"{ver}\"",
            f"\t\tTag\t\t\t{tag}",
            "\t\tProtocol\tUCI",
            f"\t\tArchive\t\t{spec['archive']}",
            f"\t\tExtract\t\t{spec['extract']}",
            f"\t\tTarget\t\t{spec['target']}",
            "\t\tExtra\t\t{" + " ".join(extra) + "}",
            "\t\tBuilds {",
        ]
        for bid, flags, asset, sha, size, member in builds:
            out.append(f"\t\t\t{{{bid} {{{flags}}} {asset} {sha} {size} {{{member}}}}}")
        out += ["\t\t}", "\t}"]
    out += ["}", "", "# vi:set ts=3 sw=3:"]
    return "\n".join(out) + "\n"


def main():
    ap = argparse.ArgumentParser(description="Erzeugt den Engine-Downloadkatalog.")
    ap.add_argument("-e", "--engine", action="append",
                    help="nur diese Engine (mehrfach moeglich); sonst alle")
    ap.add_argument("-n", "--dry-run", action="store_true",
                    help="nur anzeigen, nichts schreiben")
    args = ap.parse_args()

    wanted = set(args.engine or [])
    specs = [s for s in SPECS if not wanted or s["id"] in wanted]
    if wanted:
        unknown = wanted - {s["id"] for s in SPECS}
        if unknown:
            print(f"Unbekannte Engine(s): {', '.join(sorted(unknown))}", file=sys.stderr)
            return 2
        # Beim Teillauf die uebrigen Engines aus dem vorhandenen Katalog uebernehmen
        # waere aufwendig; deshalb erzeugt -e nur einen Bericht.
        args.dry_run = True
        print("Hinweis: -e erzeugt nur einen Bericht, keine Datei.\n", file=sys.stderr)

    entries, problems = [], []
    for spec in specs:
        print(f"  {spec['name']} ...", file=sys.stderr)
        try:
            tag, ver, builds, missing, extra = collect(spec)
        except (urllib.error.URLError, TimeoutError, KeyError, OSError) as e:
            problems.append(f"{spec['name']}: nicht abrufbar ({e})")
            continue
        if not builds:
            problems.append(f"{spec['name']}: kein einziger erwarteter Anhang gefunden "
                            f"- hat das Projekt die Dateinamen geaendert?")
            continue
        if missing:
            problems.append(f"{spec['name']}: Anhang fehlt: {', '.join(missing)}")
        print(f"      {tag}  ({len(builds)} Varianten)", file=sys.stderr)
        entries.append((spec, tag, ver, builds, extra))

    if problems:
        print("", file=sys.stderr)
        for p in problems:
            print(f"  ACHTUNG  {p}", file=sys.stderr)
        print("", file=sys.stderr)

    if not entries:
        print("Nichts erzeugt.", file=sys.stderr)
        return 1

    text = render(entries)

    if args.dry_run:
        sys.stdout.write(text)
        return 0

    if len(entries) != len(SPECS):
        print("Es fehlen Engines - der Katalog wird nicht ueberschrieben.", file=sys.stderr)
        print("Mit --dry-run laesst sich das Ergebnis ansehen.", file=sys.stderr)
        return 1

    old = open(TARGET, encoding="utf-8").read() if os.path.exists(TARGET) else ""
    if old == text:
        print(f"{TARGET} ist bereits aktuell.", file=sys.stderr)
        return 0

    open(TARGET, "w", encoding="utf-8").write(text)
    print(f"{TARGET} geschrieben.", file=sys.stderr)
    print("Nicht vergessen: nach AppDir/usr/share/scidc-beta/engines/ kopieren"
          " (macht build-appimage.sh bei jedem Build).", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
