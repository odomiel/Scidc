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


def make_line(fideid, name, title, federation, rating, games, birth, female, inactive):
    id_part   = f"{fideid:8d}  "
    name_part = f"{name:<33.33s}"
    title_part = f"{title:<4.4s}"
    fed_part  = f"{federation:<3.3s}"
    rat_part  = f"{rating:<5d}"
    gam_part  = f"{games:6d}"
    bir_part  = f"{birth:4d}" if birth else "    "
    sex_part  = "w" if female else " "
    flg_part  = "i" if inactive else " "
    return (id_part + name_part + " " + title_part + fed_part + "  "
            + rat_part + gam_part + bir_part + "  " + sex_part + flg_part)


def download_to_file(url, path):
    """Stream-download url in 1 MB chunks to path."""
    print("Downloading FIDE player list (XML, ~50 MB)...", flush=True)
    req = urllib.request.Request(
        url,
        headers={"User-Agent": "Scidb-chess-database/1.1 (player-list-update)"}
    )
    downloaded = 0
    with urllib.request.urlopen(req, timeout=180) as resp, \
         open(path, "wb") as f:
        while True:
            chunk = resp.read(1 << 20)  # 1 MB at a time
            if not chunk:
                break
            f.write(chunk)
            downloaded += len(chunk)
            print(f"\r  {downloaded // 1024:6d} KB", end="", flush=True)
    print(f"\r  {downloaded // 1024} KB downloaded.          ", flush=True)


def convert_streaming(xml_fobj, out_zip_path):
    """Parse XML with iterparse so only one <player> element lives in RAM at a time."""
    header   = "ID number Name                              TitlFed  Rating GamesBorn  Flag\n"
    month_tag = datetime.now().strftime("%b%y").lower()
    txt_name  = f"players_{month_tag}.txt"

    lines    = [header]
    root_elem = None
    count    = 0

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
            birthday = int(elem.findtext("birthday") or 0)
            flag     = (elem.findtext("flag") or "").strip().lower()

            lines.append(make_line(
                fideid, name, title, country, rating, games,
                birthday, sex == "F", "i" in flag
            ) + "\n")
            count += 1
        except (ValueError, TypeError, AttributeError):
            pass

        elem.clear()
        if root_elem is not None:
            del root_elem[:]  # drop completed children from root, keep root itself

    print(f"Converting {count} players...", flush=True)
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
