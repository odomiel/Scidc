#!/bin/bash
# Patch si3_codec.ipp um isFormat5 hinzuzufügen
IPP="scidb-code-r1531-trunk/src/db/si3/si3_codec.ipp"

if [ ! -f "$IPP" ]; then
    echo "FEHLER: $IPP nicht gefunden"
    echo "Bitte aus dem scidb-code-r1531-trunk Verzeichnis ausführen"
    exit 1
fi

# isFormat5 nach isFormat3 einfügen
python3 - "$IPP" << 'PYEOF'
import sys
fname = sys.argv[1]
with open(fname) as f:
    content = f.read()

# Füge isFormat5 hinzu
old = "inline bool Codec::isFormat3() const { return m_customFlags == 0; }"
new = ("inline bool Codec::isFormat3() const { return m_customFlags == 0; }\n"
       "inline bool Codec::isFormat5() const { return m_isVersion5; }")

if old in content:
    content = content.replace(old, new)
    print("isFormat5 in si3_codec.ipp eingefügt")
elif "isFormat5" in content:
    print("isFormat5 bereits vorhanden")
else:
    # Fallback: ans Ende anhängen
    content += "\ninline bool Codec::isFormat5() const { return m_isVersion5; }\n"
    print("isFormat5 am Ende von si3_codec.ipp eingefügt")

with open(fname, "w") as f:
    f.write(content)
PYEOF
