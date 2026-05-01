#!/usr/bin/env python3
"""
Download the current DWZ rating list (CSV v2) and convert it to the
fixed-width TXT format that Scidb's parseDwzRating() expects.

Usage: python3 update-dwz-players.py <data_dir>

Fixed-width output format (0-indexed byte positions, Latin-1 encoded):
  [ 0: 5]  ZPS (5-char club/federation code)
  [ 5]     space
  [ 6:10]  Member number, right-justified in 4 chars
  [10]     space
  [11:19]  FIDE ID, right-justified in 8 chars ('0' = none)
  [19]     space
  [20]     Gender: 'M' = male, 'W' = female
  [21]     space
  [22:26]  Birth year, right-justified in 4 chars
  [26]     space
  [27:31]  DWZ rating, right-justified in 4 chars
  [31]     space
  [32:]    Player name (Last, First), Latin-1 encoded
"""

import sys
import os
import csv
import tempfile
import zipfile
import urllib.request

DWZ_CSV_URL = "https://dwz.svw.info/services/files/export/csv/LV-0-csv_v2.zip"
MIN_RATING  = 1000  # parseDwzRating applies its own minimum (default 1800)

REQUIRED_COLS = {"ZPS", "Mgl-Nr", "Spielername", "Geschlecht", "Geburtsjahr", "DWZ", "FIDE-ID"}


def detect_encoding(path):
    with open(path, "rb") as f:
        raw = f.read(512)
    if raw.startswith(b"\xef\xbb\xbf"):
        return "utf-8-sig"
    try:
        raw.decode("utf-8")
        return "utf-8"
    except UnicodeDecodeError:
        return "latin-1"


def make_line(zps, nr, fide_id, gender, birth, rating, name):
    zps_part   = zps[:5].ljust(5)
    nr_part    = (nr or "0").rjust(4)
    fide_part  = (fide_id or "0").rjust(8)
    gen_part   = (gender[0:1] if gender else " ")
    birth_part = (birth or "0").rjust(4)
    rat_part   = rating.rjust(4)
    return f"{zps_part} {nr_part} {fide_part} {gen_part} {birth_part} {rat_part} {name}"


def download_to_file(url, path):
    print("Downloading DWZ player list...", flush=True)
    req = urllib.request.Request(
        url,
        headers={"User-Agent": "Scidb-chess-database/1.1 (player-list-update)"}
    )
    downloaded = 0
    with urllib.request.urlopen(req, timeout=120) as resp, \
         open(path, "wb") as f:
        while True:
            chunk = resp.read(1 << 20)
            if not chunk:
                break
            f.write(chunk)
            downloaded += len(chunk)
            print(f"\r  {downloaded // 1024:6d} KB", end="", flush=True)
    print(f"\r  {downloaded // 1024} KB downloaded.          ", flush=True)


def convert_csv(csv_path, out_path):
    enc = detect_encoding(csv_path)
    count   = 0
    skipped = 0
    tmp_path = out_path + ".tmp"

    with open(csv_path, encoding=enc, newline="", errors="replace") as f, \
         open(tmp_path, "w", encoding="latin-1", errors="replace", newline="\n") as out:

        reader = csv.DictReader(f, delimiter=",", quotechar='"')

        missing = REQUIRED_COLS - set(reader.fieldnames or [])
        if missing:
            raise ValueError(f"Missing CSV columns: {', '.join(sorted(missing))}")

        for row in reader:
            zps    = (row.get("ZPS")         or "").strip()
            nr     = (row.get("Mgl-Nr")      or "").strip()
            name   = (row.get("Spielername") or "").strip()
            gender = (row.get("Geschlecht")  or "").strip().upper()
            birth  = (row.get("Geburtsjahr") or "").strip()
            dwz    = (row.get("DWZ")         or "").strip()
            fide   = (row.get("FIDE-ID")     or "").strip()

            # validation matches conv-dwz.tcl filter
            if len(zps) != 5:
                skipped += 1
                continue
            if not (zps[0].isdigit() or "A" <= zps[0] <= "L"):
                skipped += 1
                continue
            if not nr or len(nr) >= 5:
                skipped += 1
                continue
            if len(name) <= 4:
                skipped += 1
                continue
            if not dwz.isdigit() or not (4 <= len(dwz) <= 4):
                skipped += 1
                continue
            if int(dwz) < MIN_RATING:
                skipped += 1
                continue

            # normalise name: ",Dr." and commas
            name = name.replace(",Dr.", " Dr").replace(",", ", ")

            g = gender[0:1] if gender and gender[0] in ("M", "W") else " "
            fide_str = fide if fide.isdigit() else "0"

            out.write(make_line(zps, nr, fide_str, g, birth, dwz, name) + "\n")
            count += 1

    os.replace(tmp_path, out_path)
    print(f"Saved {count} players to {out_path} ({skipped} skipped).", flush=True)


def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <data_dir>", file=sys.stderr)
        sys.exit(1)

    data_dir = sys.argv[1]
    if not os.path.isdir(data_dir):
        print(f"Error: not a directory: {data_dir}", file=sys.stderr)
        sys.exit(1)

    tmpzip   = None
    tmpcsvpath = None
    try:
        fd, tmpzip = tempfile.mkstemp(suffix=".zip", dir=data_dir)
        os.close(fd)
        download_to_file(DWZ_CSV_URL, tmpzip)

        print("Extracting CSV...", flush=True)
        with zipfile.ZipFile(tmpzip) as zf:
            csv_names = [n for n in zf.namelist() if n.lower().endswith(".csv")]
            if not csv_names:
                print("Error: no CSV file found in DWZ download.", file=sys.stderr)
                sys.exit(1)
            fd2, tmpcsvpath = tempfile.mkstemp(suffix=".csv", dir=data_dir)
            os.close(fd2)
            with zf.open(csv_names[0]) as src, open(tmpcsvpath, "wb") as dst:
                dst.write(src.read())

        out_path = os.path.join(data_dir, "dwz-ratings.txt")
        print(f"Converting {csv_names[0]}...", flush=True)
        convert_csv(tmpcsvpath, out_path)

    finally:
        for p in (tmpzip, tmpcsvpath):
            if p and os.path.exists(p):
                os.unlink(p)

    print("Done.", flush=True)


if __name__ == "__main__":
    main()
