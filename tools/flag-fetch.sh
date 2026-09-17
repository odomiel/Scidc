#!/bin/bash
# ======================================================================
# Laedt die von Wikimedia Commons gerenderten Flaggen-PNGs, die
# tools/make-flags.py als Vorlage braucht.
#
#   bash tools/flag-fetch.sh <zielverzeichnis>
#
# Zwei Dinge, die hier absichtlich so sind:
#   * "-4" erzwingt IPv4. Ohne das wartet jeder Abruf ~30 Sekunden auf
#     einen IPv6-Zeitablauf, bevor er zurueckfaellt -- 266 Dateien
#     brauchten so ueber zwei Stunden statt einer Sekunde.
#   * Die Adressen kommen ueber die API (iiurlwidth), nicht ueber
#     Special:FilePath: letzteres wird gedrosselt.
# ======================================================================
set -euo pipefail
OUT="${1:?Zielverzeichnis angeben}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UA="scidc-flag-tool/1.0 (license cleanup; Wikimedia Commons)"
mkdir -p "$OUT"

python3 - "$ROOT" "$OUT" <<'PY' > "$OUT/.curl.cfg"
import json, sys, urllib.request, urllib.parse, time, os
root, out = sys.argv[1], sys.argv[2]
UA = "scidc-flag-tool/1.0 (license cleanup)"
names = set()
for line in open(os.path.join(root, "tools/flag-mapping.tsv"), encoding="utf-8"):
    if line.startswith("#"):
        continue
    f = line.rstrip("\n").split("\t")
    if len(f) >= 6 and f[3] and f[5] in ("frei", "auflage"):
        names.add(f[3])
names = sorted(names)
for i in range(0, len(names), 50):
    q = urllib.parse.urlencode({"action": "query", "prop": "imageinfo",
        "iiprop": "url", "iiurlwidth": "240", "format": "json",
        "formatversion": "2",
        "titles": "|".join("File:" + t for t in names[i:i+50])})
    req = urllib.request.Request("https://commons.wikimedia.org/w/api.php?" + q,
                                 headers={"User-Agent": UA})
    with urllib.request.urlopen(req, timeout=60) as fh:
        pages = json.load(fh)["query"]["pages"]
    for p in pages:
        if p.get("missing"):
            continue
        ii = p["imageinfo"][0]
        url = ii.get("thumburl") or ii["url"]
        tgt = os.path.join(out, p["title"].replace("File:", "")
                                .replace(" ", "_").replace("/", "_") + ".png")
        print(f'url = "{url}"')
        print(f'output = "{tgt}"')
    time.sleep(0.8)
PY

curl -sS --parallel --parallel-max 8 -4 -L -A "$UA" --config "$OUT/.curl.cfg"
rm -f "$OUT/.curl.cfg"
echo "  geladen: $(ls "$OUT"/*.png 2>/dev/null | wc -l) Flaggen nach $OUT"
