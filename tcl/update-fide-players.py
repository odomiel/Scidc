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
import io
import zipfile
import urllib.request
import xml.etree.ElementTree as ET
from datetime import datetime

FIDE_XML_URL = "https://ratings.fide.com/download/players_list_xml.zip"

# Map FIDE XML title strings to the 2-char codes parseFideRating reads:
#   'g' -> GM,  'm' -> IM,  'f' -> FM,  'c' -> CM
#   'w'+'g' -> WGM,  'w'+'m' -> WIM,  'w'+'f' -> WFM,  'w'+'c' -> WCM
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
    id_part    = f"{fideid:8d}  "          # 10 chars  [0:10]
    name_part  = f"{name:<33.33s}"         # 33 chars  [10:43]
    sep1       = " "                       #  1 char   [43]
    title_part = f"{title:<4.4s}"          #  4 chars  [44:48]
    fed_part   = f"{federation:<3.3s}"     #  3 chars  [48:51]
    sep2       = "  "                      #  2 chars  [51:53]
    rat_part   = f"{rating:<5d}"           #  5 chars  [53:58]  digit must be at 53
    gam_part   = f"{games:6d}"             #  6 chars  [58:64]
    bir_part   = f"{birth:4d}" if birth else "    "   # 4 chars [64:68]
    sep3       = "  "                      #  2 chars  [68:70]
    sex_part   = "w" if female else " "    #  1 char   [70]
    flg_part   = "i" if inactive else " "  #  1 char   [71]
    return id_part + name_part + sep1 + title_part + fed_part + sep2 \
         + rat_part + gam_part + bir_part + sep3 + sex_part + flg_part


def convert(xml_bytes, out_zip_path):
    root = ET.fromstring(xml_bytes)
    players = root.findall("player")
    if not players:
        players = root.findall(".//player")
    print(f"Converting {len(players)} players...", flush=True)

    month_tag = datetime.now().strftime("%b%y").lower()
    txt_name  = f"players_{month_tag}.txt"
    header    = "ID number Name                              TitlFed  Rating GamesBorn  Flag\n"

    lines = [header]
    for p in players:
        try:
            fideid = int(p.findtext("fideid") or 0)
            name   = (p.findtext("name") or "").strip()
            country = (p.findtext("country") or "").strip().upper()
            if not fideid or not name or not country:
                continue

            sex      = (p.findtext("sex") or "").strip().upper()
            title    = best_title(p)
            rating   = int(p.findtext("rating") or 0)
            games    = int(p.findtext("games") or 0)
            birthday = int(p.findtext("birthday") or 0)
            flag     = (p.findtext("flag") or "").strip().lower()
            female   = (sex == "F")
            inactive = ("i" in flag)

            lines.append(make_line(fideid, name, title, country,
                                   rating, games, birthday, female, inactive) + "\n")
        except (ValueError, TypeError, AttributeError):
            continue

    txt_bytes = "".join(lines).encode("utf-8")
    tmp_path  = out_zip_path + ".tmp"
    with zipfile.ZipFile(tmp_path, "w", zipfile.ZIP_DEFLATED) as zf:
        zf.writestr(txt_name, txt_bytes)
    os.replace(tmp_path, out_zip_path)
    print(f"Saved {len(lines) - 1} players to {out_zip_path}", flush=True)


def download(url):
    print("Downloading FIDE player list (XML, ~50 MB)...", flush=True)
    req = urllib.request.Request(
        url,
        headers={"User-Agent": "Scidb-chess-database/1.1 (player-list-update)"}
    )
    with urllib.request.urlopen(req, timeout=180) as resp:
        data = resp.read()
    print(f"Downloaded {len(data) // 1024} KB.", flush=True)
    return data


def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <data_dir>", file=sys.stderr)
        sys.exit(1)

    data_dir = sys.argv[1]
    if not os.path.isdir(data_dir):
        print(f"Error: not a directory: {data_dir}", file=sys.stderr)
        sys.exit(1)

    zip_bytes = download(FIDE_XML_URL)

    print("Extracting XML...", flush=True)
    with zipfile.ZipFile(io.BytesIO(zip_bytes)) as zf:
        xml_names = [n for n in zf.namelist() if n.lower().endswith(".xml")]
        if not xml_names:
            print("Error: no XML file found in FIDE download.", file=sys.stderr)
            sys.exit(1)
        xml_bytes = zf.read(xml_names[0])

    out_path = os.path.join(data_dir, "players_list.zip")
    convert(xml_bytes, out_path)
    print("Done.", flush=True)


if __name__ == "__main__":
    main()
