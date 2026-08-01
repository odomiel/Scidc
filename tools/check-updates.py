#!/usr/bin/env python3
# ======================================================================
# Prueft, ob es zu den gepinnten Versionen neuere gibt:
#
#   * die Engines aus tcl/engines/downloads.dat
#   * Tcl/Tk (Vorgabeversion in build-tcltk.sh)
#   * minizip-ng (MZ_VERSION in src/util/minizip/mz.h)
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


# --- Bericht ----------------------------------------------------------

def main():
    report = []
    check_engines(report)
    check_tcltk(report)
    check_minizip(report)

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
    elif outdated:
        print("")
        print("  Neuere Engine-Versionen erfordern einen gepflegten Katalog:")
        print("  tcl/engines/downloads.dat braucht Version, URL, Groesse und SHA-256.")
    print("")
    return 0


if __name__ == "__main__":
    sys.exit(main())
