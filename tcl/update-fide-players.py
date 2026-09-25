#!/usr/bin/env python3
"""
Download the current FIDE rating list (XML) and convert it to the
fixed-width TXT format that Scidb's parseFideRating() expects.

Usage: python3 update-fide-players.py <data_dir>

Column layout of each output line (0-indexed, C++ parser positions):
  [0:10]   FIDE ID, right-justified in 8 digits + 2 spaces
  [10:43]  Name, left-justified, padded to 33 chars
  [43]     separator space
  [44:48]  Title code, left-justified, padded to 4 chars
  [48:51]  Federation (3-char country code)
  [51:53]  two spaces
  [53:58]  Rating, left-justified in 5 chars (digit at pos 53 required)
  [58:64]  Games, right-justified in 6 chars (not read by parser, filler)
  [64:68]  Birth year, 4 chars, or "    " if unknown
  [68:70]  two spaces
  [70]     Sex: 'w' = female, ' ' = male
  [71]     Activity: 'i' = inactive, ' ' = active
  [72]     separator space
  [73:78]  Rapid rating, left-justified in 5 chars (blank if none)
  [78:84]  Rapid games, right-justified in 6 chars (filler, not read)

The rapid columns are APPENDED behind the historical layout on purpose: the
first 72 columns keep their meaning, so a list written by an older version
still parses, and parseFideRating() only looks at 73+ when the line is long
enough. FIDE's XML also carries blitz_rating, which is deliberately not
written here -- db_common.h has no rating type for blitz, and its enum's first
seven values coincide with Scid's numbering, so adding one is a format change
rather than a one-liner.
"""

import sys
import os
import tempfile
import zipfile
import urllib.request
import xml.etree.ElementTree as ET
from datetime import datetime

FIDE_XML_URL = "https://ratings.fide.com/download/players_list_xml.zip"

TITLE_MAP = {
    "GM":  "gm",
    "IM":  "im",
    "FM":  "fm",
    "CM":  "cm",
    "WGM": "wg",
    "WIM": "wm",
    "WFM": "wf",
    "WCM": "wc",
}


def best_title(elem):
    for field in ("title", "w_title", "o_title", "foa_title"):
        val = (elem.findtext(field) or "").strip().upper()
        if val in TITLE_MAP:
            return TITLE_MAP[val]
    return ""


def make_line(fideid, name, title, federation, rating, games, birth, female,
              inactive, rapid=0, rapid_games=0):
    # Das Feld ist 10 Zeichen breit, nicht "8 Ziffern + 2 Leerzeichen": FIDE
    # vergibt inzwischen 9-stellige IDs (5xxxxxxxx), und mit "{:8d}  " lief
    # die ID ueber und schob jede folgende Spalte um eins nach rechts. Der
    # Parser las die Wertung dann an der falschen Stelle, sah dort ein
    # Leerzeichen und verwarf den Spieler ueber die Mindestwertung -- zuletzt
    # 104962 von 743045 Eintraegen. Links buendig aufgefuellt bleibt der Name
    # bei Spalte 10, egal wie lang die ID ist; strtoul() liest sie ohnehin ab
    # Position 0 bis zur ersten Nicht-Ziffer.
    id_part   = f"{fideid:8d}".ljust(10)[:10]
    name_part = f"{name:<33.33s}"
    title_part = f"{title:<4.4s}"
    fed_part  = f"{federation:<3.3s}"
    # A missing rating must be blanks, not "0": the parser decides by
    # isdigit() at the first column of the field. Since players without a
    # standard rating are kept now (for their rapid rating), this case is
    # reachable -- before it was not.
    rat_part  = f"{rating:<5d}" if rating else "     "
    gam_part  = f"{games:6d}"
    bir_part  = f"{birth:4d}" if birth else "    "
    sex_part  = "w" if female else " "
    flg_part  = "i" if inactive else " "
    rap_part  = f"{rapid:<5d}" if rapid else "     "
    rgm_part  = f"{rapid_games:6d}"
    return (id_part + name_part + " " + title_part + fed_part + "  "
            + rat_part + gam_part + bir_part + "  " + sex_part + flg_part
            + " " + rap_part + rgm_part)


def download_to_file(url, path):
    """Stream-download url in 1 MB chunks to path (atomic via .part temp file)."""
    print("Downloading FIDE player list (XML, ~50 MB)...", flush=True)
    req = urllib.request.Request(
        url,
        headers={"User-Agent": "Scidb-chess-database/1.1 (player-list-update)"}
    )
    tmp = path + ".part"
    downloaded = 0
    try:
        with urllib.request.urlopen(req, timeout=180) as resp, \
             open(tmp, "wb") as f:
            while True:
                chunk = resp.read(1 << 20)  # 1 MB at a time
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


def convert_streaming(xml_fobj, out_zip_path):
    """Parse XML with iterparse so only one <player> element lives in RAM at a time."""
    header   = ("ID number Name                              TitlFed  Rating GamesBorn  Flag"
                " Rapid RGames\n")
    month_tag = datetime.now().strftime("%b%y").lower()
    txt_name  = f"players_{month_tag}.txt"

    lines    = [header]
    root_elem = None
    count    = 0
    rapid_count = 0

    for event, elem in ET.iterparse(xml_fobj, events=("start", "end")):
        if event == "start" and root_elem is None:
            root_elem = elem  # capture document root on first start
            continue

        if event != "end" or elem.tag != "player":
            continue

        try:
            fideid  = int(elem.findtext("fideid") or 0)
            name    = (elem.findtext("name") or "").strip()
            country = (elem.findtext("country") or "").strip().upper()
            if not fideid or not name or not country:
                elem.clear()
                if root_elem is not None:
                    del root_elem[:]
                continue

            sex      = (elem.findtext("sex") or "").strip().upper()
            title    = best_title(elem)
            rating   = int(elem.findtext("rating") or 0)
            games    = int(elem.findtext("games") or 0)
            rapid    = int(elem.findtext("rapid_rating") or 0)
            rapid_g  = int(elem.findtext("rapid_games") or 0)
            birthday = int(elem.findtext("birthday") or 0)
            flag     = (elem.findtext("flag") or "").strip().lower()

            # Previously this dropped everyone without a standard rating,
            # which cost ~219k players who do hold a rapid rating.
            if rating <= 0 and rapid <= 0:
                elem.clear()
                continue
            lines.append(make_line(
                fideid, name, title, country, rating, games,
                birthday, sex == "F", "i" in flag, rapid, rapid_g
            ) + "\n")
            count += 1
            if rapid > 0:
                rapid_count += 1
        except (ValueError, TypeError, AttributeError):
            pass

        elem.clear()
        if root_elem is not None:
            del root_elem[:]  # drop completed children from root, keep root itself

    print(f"Converting {count} players ({rapid_count} with a rapid rating)...",
          flush=True)
    txt_bytes = "".join(lines).encode("utf-8")
    tmp_path  = out_zip_path + ".tmp"
    with zipfile.ZipFile(tmp_path, "w", zipfile.ZIP_DEFLATED) as zf:
        zf.writestr(txt_name, txt_bytes)
    os.replace(tmp_path, out_zip_path)
    print(f"Saved {count} players to {out_zip_path}", flush=True)


def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <data_dir>", file=sys.stderr)
        sys.exit(1)

    data_dir = sys.argv[1]
    if not os.path.isdir(data_dir):
        print(f"Error: not a directory: {data_dir}", file=sys.stderr)
        sys.exit(1)

    tmpzip = None
    try:
        fd, tmpzip = tempfile.mkstemp(suffix=".zip", dir=data_dir)
        os.close(fd)
        download_to_file(FIDE_XML_URL, tmpzip)

        print("Extracting XML...", flush=True)
        with zipfile.ZipFile(tmpzip) as zf:
            xml_names = [n for n in zf.namelist() if n.lower().endswith(".xml")]
            if not xml_names:
                print("Error: no XML file found in FIDE download.", file=sys.stderr)
                sys.exit(1)
            out_path = os.path.join(data_dir, "players_list.zip")
            with zf.open(xml_names[0]) as xml_fobj:
                convert_streaming(xml_fobj, out_path)
    finally:
        if tmpzip and os.path.exists(tmpzip):
            os.unlink(tmpzip)

    print("Done.", flush=True)


if __name__ == "__main__":
    main()
