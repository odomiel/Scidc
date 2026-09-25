#!/usr/bin/env python3
"""
Download the current DWZ rating list (CSV v2) and convert it to the
fixed-width TXT format that Scidb's parseDwzRating() expects.

Usage: python3 update-dwz-players.py <data_dir>

Fixed-width output format (0-indexed byte positions, Latin-1 encoded):
  [ 0: 5]  VKZ/ZPS (5-char club code)
  [ 5]     space
  [ 6:10]  Member number, right-justified in 4 chars
  [10]     space
  [11:20]  FIDE ID, right-justified in 9 chars ('0' = none; 9 chars supports up to 9-digit IDs)
  [20]     space
  [21]     Gender: 'M' = male, 'W' = female
  [22]     space
  [23:27]  Birth year, right-justified in 4 chars
  [27]     space
  [28:32]  DWZ rating, left-justified in 4 chars (pos 28 must be a digit)
  [32]     space
  [33:]    Player name (Last, First), Latin-1 encoded
"""

import sys
import os
import csv
import tempfile
import zipfile
import urllib.request

# Official source: the DSB download page at
#   https://www.schachbund.de/download-dwz-daten.html
# links this file directly. The previous address
# (dwz.svw.info/services/files/export/csv/LV-0-csv_v2.zip) has gone; that host
# still answers, but the export path returns 404, so the failure looked like a
# network glitch rather than a moved resource. The DSB file is regenerated
# daily at 04:15 and is the same data set (~74k players after filtering).
DWZ_CSV_URL  = "https://www.schachbund.de/files/wertungsportal/downloads/export/csv/LV-0-csv.zip"
CSV_FILENAME = "spieler.csv"   # target file inside the ZIP
# The ZIP's README states windows-1252, and the file really does use the
# cp1252-only range 0x80-0x9F (s-caron, typographic apostrophe). Reading it as
# Latin-1 would turn those into control characters inside player names.
CSV_ENCODING = "cp1252"
# ...but the OUTPUT must stay Latin-1: Player::parseDwzRating (db_player.cpp)
# hooks a sys::utf8::Codec::latin1() in front of it. See to_latin1() below.
OUT_ENCODING = "latin-1"
MIN_RATING   = 1               # include all players with any DWZ > 0

# The DSB export renamed three columns; the old names are kept as fallbacks so
# a switch back to another export does not break the script again.
#   VKZ         -> ZPS
#   Mgl-Nr      -> Mitgliedsnummer
#   Spielername -> "Name,Vorname"   (the header itself contains a comma)
COLUMN_ALIASES = {
    "vkz":    ("ZPS", "VKZ"),
    "nr":     ("Mitgliedsnummer", "Mgl-Nr"),
    "name":   ("Name,Vorname", "Spielername"),
    "gender": ("Geschlecht",),
    "birth":  ("Geburtsjahr",),
    "dwz":    ("DWZ",),
    "fide":   ("FIDE-ID",),
}

# cp1252 carries 32 characters in 0x80-0x9F that Latin-1 does not have.
# Without a mapping they would be lost to '?' in the middle of a name.
CP1252_ONLY = {
    "\u20ac": "EUR", "\u201a": ",",  "\u0192": "f",   "\u201e": '"',
    "\u2026": "...", "\u2020": "+",  "\u2021": "+",   "\u02c6": "^",
    "\u2030": "%",   "\u0160": "S",  "\u2039": "<",   "\u0152": "OE",
    "\u017d": "Z",   "\u2018": "'",  "\u2019": "'",   "\u201c": '"',
    "\u201d": '"',   "\u2022": "*",  "\u2013": "-",   "\u2014": "-",
    "\u02dc": "~",   "\u2122": "TM", "\u0161": "s",   "\u203a": ">",
    "\u0153": "oe",  "\u017e": "z",  "\u0178": "Y",
}


def to_latin1(text):
    """Replace the cp1252-only characters by Latin-1 equivalents."""
    if text.isascii():
        return text
    return "".join(CP1252_ONLY.get(ch, ch) for ch in text)


def resolve_columns(fieldnames):
    """Map our internal keys to the column names this export actually uses."""
    fields = set(fieldnames or [])
    found, missing = {}, []

    for key, candidates in COLUMN_ALIASES.items():
        for name in candidates:
            if name in fields:
                found[key] = name
                break
        else:
            missing.append(" / ".join(candidates))

    if missing:
        raise ValueError(
            "Missing CSV columns: " + ", ".join(missing) + "\n"
            "Actual columns: " + repr(fieldnames)
        )
    return found


def make_line(vkz, nr, fide_id, gender, birth, rating, name):
    vkz_part   = vkz[:5].ljust(5)
    nr_part    = (nr      or "0").rjust(4)
    fide_part  = (fide_id or "0").rjust(9)  # 9 chars to support 9-digit FIDE IDs
    gen_part   = gender[0:1] if gender and gender[0] in ("M", "W") else " "
    birth_part = (birth   or "0").rjust(4)
    rat_part   = rating[:4].ljust(4)  # left-justify so pos 28 is always a digit
    return f"{vkz_part} {nr_part} {fide_part} {gen_part} {birth_part} {rat_part} {name}"


def download_to_file(url, path):
    """Stream-download url in 1 MB chunks to path (atomic via .part temp file)."""
    print("Downloading DWZ player list...", flush=True)
    req = urllib.request.Request(
        url,
        headers={"User-Agent": "Scidb-chess-database/1.1 (player-list-update)"}
    )
    tmp = path + ".part"
    downloaded = 0
    try:
        with urllib.request.urlopen(req, timeout=120) as resp, \
             open(tmp, "wb") as f:
            while True:
                chunk = resp.read(1 << 20)
                if not chunk:
                    break
                f.write(chunk)
                downloaded += len(chunk)
                print(f"\r  {downloaded // 1024:6d} KB", end="", flush=True)
        os.replace(tmp, path)
    except Exception:
        try:
            os.unlink(tmp)
        except OSError:
            pass
        raise
    print(f"\r  {downloaded // 1024} KB downloaded.          ", flush=True)


def convert_csv(csv_path, out_path):
    count    = 0
    skipped  = 0
    tmp_path = out_path + ".tmp"

    with open(csv_path, encoding=CSV_ENCODING, newline="", errors="replace") as f, \
         open(tmp_path, "w", encoding=OUT_ENCODING, errors="replace", newline="\n") as out:

        reader = csv.DictReader(f, delimiter=",", quotechar='"')
        col    = resolve_columns(reader.fieldnames)

        for row in reader:
            vkz    = (row.get(col["vkz"])    or "").strip()
            nr     = (row.get(col["nr"])     or "").strip()
            name   = (row.get(col["name"])   or "").strip()
            gender = (row.get(col["gender"]) or "").strip().upper()
            birth  = (row.get(col["birth"])  or "").strip()
            dwz    = (row.get(col["dwz"])    or "").strip()
            fide   = (row.get(col["fide"])   or "").strip()

            # match filter from original conv-dwz.tcl
            if len(vkz) != 5:
                skipped += 1
                continue
            if not (vkz[0].isdigit() or "A" <= vkz[0] <= "L"):
                skipped += 1
                continue
            if not nr or not nr.isdigit() or int(nr) == 0 or len(nr) >= 5:
                skipped += 1
                continue
            if len(name) <= 4:
                skipped += 1
                continue
            if not dwz.isdigit() or not (1 <= len(dwz) <= 4):
                skipped += 1
                continue
            if int(dwz) < MIN_RATING:
                skipped += 1
                continue

            # "Nachname,Vorname" -> "Nachname, Vorname"
            name = name.replace(",Dr.", " Dr").replace(",", ", ")
            name = to_latin1(name)

            fide_str = fide if fide.isdigit() else "0"

            out.write(make_line(vkz, nr, fide_str, gender[0:1] if gender else " ",
                                birth, dwz, name) + "\n")
            count += 1

    os.replace(tmp_path, out_path)
    print(f"Saved {count} players to {out_path} ({skipped} skipped).", flush=True)
    return count


def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <data_dir>", file=sys.stderr)
        sys.exit(1)

    data_dir = sys.argv[1]
    if not os.path.isdir(data_dir):
        print(f"Error: not a directory: {data_dir}", file=sys.stderr)
        sys.exit(1)

    tmpzip     = None
    tmpcsvpath = None
    out_path   = os.path.join(data_dir, "dwz-ratings.txt")
    count      = 0

    try:
        fd, tmpzip = tempfile.mkstemp(suffix=".zip", dir=data_dir)
        os.close(fd)
        download_to_file(DWZ_CSV_URL, tmpzip)

        print("Extracting CSV...", flush=True)
        with zipfile.ZipFile(tmpzip) as zf:
            all_names = zf.namelist()
            if CSV_FILENAME in all_names:
                chosen = CSV_FILENAME
            else:
                csv_names = [n for n in all_names if n.lower().endswith(".csv")]
                if not csv_names:
                    print(f"Error: no CSV file in ZIP. Contents: {all_names}",
                          file=sys.stderr)
                    sys.exit(1)
                chosen = csv_names[0]
                print(f"Note: '{CSV_FILENAME}' not found, using '{chosen}'", flush=True)

            fd2, tmpcsvpath = tempfile.mkstemp(suffix=".csv", dir=data_dir)
            os.close(fd2)
            with zf.open(chosen) as src, open(tmpcsvpath, "wb") as dst:
                dst.write(src.read())

        print(f"Converting {chosen}...", flush=True)
        count = convert_csv(tmpcsvpath, out_path)

        if not os.path.exists(out_path):
            print(f"Error: output file was not created: {out_path}", file=sys.stderr)
            sys.exit(1)

    finally:
        for p in (tmpzip, tmpcsvpath):
            if p and os.path.exists(p):
                os.unlink(p)

    print(f"Done. {count} players saved.", flush=True)


if __name__ == "__main__":
    main()
