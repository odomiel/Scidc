#!/usr/bin/env python3
# ======================================================================
# Prueft, ob es zu den gepinnten Versionen neuere gibt:
#
#   * die Engines aus tcl/engines/downloads.dat
#   * Tcl/Tk (Vorgabeversion in build-tcltk.sh)
#   * die aus dem Baum gebauten Bibliotheken: minizip-ng, libharu, zziplib,
#     expat
#   * zlib
#
# zlib liegt zwar auch im Baum (src/util/zlib), wird aber nicht gebaut:
# configure setzt ZLIB_LIB=-lz, und build-appimage.sh legt die so gefundene
# Systembibliothek ins Paket. Geprueft wird deshalb, was pkg-config meldet -
# genau das landet im AppImage. Eine veraltete Fassung ist dort nicht durch
# eine Aenderung im Baum zu beheben, sondern nur ueber das Bausystem.
#
# expat war bis 26.09.05-b4 ebenso ein Systemfund; seitdem wird die Kopie in
# src/util/expat gebaut und statisch gebunden, weil sie Kommentare aus fremden
# Datenbankdateien liest. Geprueft wird darum die Version im Baum.
#
# Wird von build-appimage.sh beim ersten Build des Tages aufgerufen. Der
# Aufruf ist rein informativ: das Skript endet immer mit 0, damit ein
# fehlender Netzzugang niemals einen Build verhindert.
#
# Direkter Aufruf (ohne Tagesbremse):  python3 tools/check-updates.py
# ======================================================================

import json
import os
import re
import subprocess
import sys
import urllib.error
import urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TIMEOUT = 20


def api(path):
    """Fragt die GitHub-API ab. Liefert None, wenn nichts zu holen ist."""
    req = urllib.request.Request(
        "https://api.github.com" + path,
        headers={"Accept": "application/vnd.github+json",
                 "User-Agent": "scidc-update-check"})
    try:
        with urllib.request.urlopen(req, timeout=TIMEOUT) as r:
            return json.load(r)
    except (urllib.error.URLError, TimeoutError, json.JSONDecodeError, OSError):
        return None


# --- Engines ----------------------------------------------------------

def engines():
    """Liest (Name, Repo, Tag) aus dem Downloadkatalog."""
    path = os.path.join(ROOT, "tcl", "engines", "downloads.dat")
    if not os.path.exists(path):
        return []
    text = open(path, encoding="utf-8").read()

    out, cur = [], {}
    for line in text.split("\n"):
        m = re.match(r'\s*(Name|Repo|Tag)\s+"?([^"\s]+)"?\s*$', line)
        if m:
            cur[m.group(1)] = m.group(2)
            if len(cur) == 3:
                out.append((cur["Name"], cur["Repo"], cur["Tag"]))
                cur = {}
    return out


def check_engines(report):
    for name, repo, tag in engines():
        d = api(f"/repos/{repo}/releases/latest")
        if d is None or "tag_name" not in d:
            report.append(("?", name, tag, "nicht erreichbar"))
            continue
        latest = d["tag_name"]
        report.append(("!" if latest != tag else " ", name, tag, latest))


# --- Abhaengigkeiten --------------------------------------------------

def tcltk_version():
    path = os.path.join(ROOT, "build-tcltk.sh")
    if not os.path.exists(path):
        return None
    m = re.search(r'^DEFAULT_VERSION="([^"]+)"', open(path, encoding="utf-8").read(), re.M)
    return m.group(1) if m else None


def check_tcltk(report):
    have = tcltk_version()
    if not have:
        return
    d = api("/repos/tcltk/tcl/releases?per_page=30")
    if not isinstance(d, list):
        report.append(("?", "Tcl/Tk", have, "nicht erreichbar"))
        return

    # Stabile Ausgaben heissen core-<maj>-<min>-<patch>; Vorabversionen
    # tragen im letzten Feld ein a oder b (core-9-1-a1) und zaehlen nicht.
    best = None
    major = have.split(".")[0]
    for rel in d:
        m = re.match(rf"^core-{major}-(\d+)-(\d+)$", rel.get("tag_name", ""))
        if m:
            v = (int(m.group(1)), int(m.group(2)))
            if best is None or v > best:
                best = v
    if best is None:
        return
    latest = f"{major}.{best[0]}.{best[1]}"
    report.append(("!" if latest != have else " ", "Tcl/Tk", have, latest))


def minizip_version():
    path = os.path.join(ROOT, "src", "util", "minizip", "mz.h")
    if not os.path.exists(path):
        return None
    m = re.search(r'#define\s+MZ_VERSION\s+\("([^"]+)"\)', open(path, encoding="utf-8").read())
    return m.group(1) if m else None


def check_minizip(report):
    have = minizip_version()
    if not have:
        return
    d = api("/repos/zlib-ng/minizip-ng/releases/latest")
    if d is None or "tag_name" not in d:
        report.append(("?", "minizip-ng", have, "nicht erreichbar"))
        return
    latest = d["tag_name"].lstrip("v")
    report.append(("!" if latest != have else " ", "minizip-ng", have, latest))


def define_version(relpath, *patterns):
    """Setzt eine Version aus #define-Zeilen einer Headerdatei zusammen."""
    path = os.path.join(ROOT, *relpath)
    if not os.path.exists(path):
        return None
    text = open(path, encoding="utf-8", errors="replace").read()
    parts = []
    for pattern in patterns:
        m = re.search(pattern, text, re.M)
        if not m:
            return None
        parts.append(m.group(1))
    return ".".join(parts)


def latest_release(repo, strip="v"):
    d = api(f"/repos/{repo}/releases/latest")
    if d is None or "tag_name" not in d:
        return None
    return d["tag_name"].lstrip(strip)


def latest_tag(repo, pattern):
    """Fuer Projekte ohne Releases: hoechster Tag, der zum Muster passt.

    Die Fundstelle darf mit Punkt oder Unterstrich getrennt sein (0.13.80,
    2_8_4); geliefert wird immer die Punktschreibweise.
    """
    d = api(f"/repos/{repo}/tags?per_page=50")
    if not isinstance(d, list):
        return None
    best = None
    for t in d:
        m = re.match(pattern, t.get("name", ""))
        if not m:
            continue
        dotted = m.group(1).replace("_", ".")
        try:
            v = tuple(int(x) for x in dotted.split("."))
        except ValueError:
            continue
        if best is None or v > best[0]:
            best = (v, dotted)
    return best[1] if best else None


def compare(report, name, have, latest):
    if not have:
        return
    if not latest:
        report.append(("?", name, have, "nicht erreichbar"))
    else:
        report.append(("!" if latest != have else " ", name, have, latest))


def check_libharu(report):
    have = define_version(
        ("src", "util", "libharu", "hpdf_version.h"),
        r"^#define\s+HPDF_MAJOR_VERSION\s+(\d+)",
        r"^#define\s+HPDF_MINOR_VERSION\s+(\d+)",
        r"^#define\s+HPDF_BUGFIX_VERSION\s+(\d+)")
    compare(report, "libharu", have, latest_release("libharu/libharu"))


def check_zziplib(report):
    have = define_version(
        ("src", "util", "zzip", "_config.h"),
        r'^#define\s+ZZIP_VERSION\s+"([^"]+)"')
    # zziplib veroeffentlicht keine Releases, nur Tags.
    compare(report, "zziplib", have,
            latest_tag("gdraheim/zziplib", r"^v(\d+\.\d+\.\d+)$"))


def pkgconfig_version(name):
    try:
        r = subprocess.run(["pkg-config", "--modversion", name],
                           capture_output=True, text=True, timeout=10)
    except (OSError, subprocess.SubprocessError):
        return None
    return r.stdout.strip() if r.returncode == 0 and r.stdout.strip() else None


def check_expat(report):
    have = define_version(
        ("src", "util", "expat", "expat.h"),
        r"^#\s*define\s+XML_MAJOR_VERSION\s+(\d+)",
        r"^#\s*define\s+XML_MINOR_VERSION\s+(\d+)",
        r"^#\s*define\s+XML_MICRO_VERSION\s+(\d+)")
    # expat kennzeichnet seine Ausgaben als Tag R_2_8_4.
    compare(report, "expat", have,
            latest_tag("libexpat/libexpat", r"^R_(\d+_\d+_\d+)$"))


def check_system_libs(report):
    compare(report, "zlib (System)", pkgconfig_version("zlib"),
            latest_release("madler/zlib"))


# --- Bericht ----------------------------------------------------------

def main():
    report = []
    check_engines(report)
    check_tcltk(report)
    check_minizip(report)
    check_libharu(report)
    check_zziplib(report)
    check_expat(report)
    check_system_libs(report)

    if not report:
        return 0

    outdated = [r for r in report if r[0] == "!"]
    unreachable = [r for r in report if r[0] == "?"]

    print("--- Versionspruefung ---")
    for mark, name, have, latest in report:
        if mark == "!":
            print(f"  NEUER    {name}: {have} -> {latest}")
        elif mark == "?":
            print(f"  ?        {name}: {have} ({latest})")

    if not outdated and not unreachable:
        print(f"  Alles aktuell ({len(report)} Eintraege geprueft).")
        print("")
        return 0

    engine_names = {name for name, _, _ in engines()}
    if any(r[1] in engine_names for r in outdated):
        print("")
        print("  Neuere Engine-Versionen erfordern einen gepflegten Katalog:")
        print("  tcl/engines/downloads.dat braucht Version, URL, Groesse und SHA-256.")
        print("  Erzeugen mit: python3 tools/make-engine-catalog.py")

    if any(r[1].endswith("(System)") for r in outdated):
        print("")
        print("  Die mit (System) sind nicht im Baum, sondern werden vom Bausystem")
        print("  gelinkt und von build-appimage.sh ins Paket gelegt. Eine neuere")
        print("  Fassung gibt es nur ueber die Pakete des Bausystems.")

    print("")
    return 0


if __name__ == "__main__":
    sys.exit(main())
