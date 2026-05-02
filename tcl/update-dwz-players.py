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

DWZ_CSV_URL  = "https://dwz.svw.info/services/files/export/csv/LV-0-csv_v2.zip"
CSV_FILENAME = "spieler.csv"   # target file inside the ZIP
CSV_ENCODING = "latin-1"       # DWZ export uses Latin-1
MIN_RATING   = 1               # include all players with any DWZ > 0

REQUIRED_COLS = {"VKZ", "Mgl-Nr", "Spielername", "Geschlecht", "Geburtsjahr", "DWZ", "FIDE-ID"}


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
         open(tmp_path, "w", encoding=CSV_ENCODING, errors="replace", newline="\n") as out:

        reader = csv.DictReader(f, delimiter=",", quotechar='"')

        missing = REQUIRED_COLS - set(reader.fieldnames or [])
        if missing:
            raise ValueError(
                f"Missing CSV columns: {', '.join(sorted(missing))}\n"
                f"Actual columns: {reader.fieldnames}"
            )

        for row in reader:
            vkz    = (row.get("VKZ")         or "").strip()
            nr     = (row.get("Mgl-Nr")      or "").strip()
            name   = (row.get("Spielername") or "").strip()
            gender = (row.get("Geschlecht")  or "").strip().upper()
            birth  = (row.get("Geburtsjahr") or "").strip()
            dwz    = (row.get("DWZ")         or "").strip()
            fide   = (row.get("FIDE-ID")     or "").strip()

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
