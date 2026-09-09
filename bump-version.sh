#!/bin/bash
# bump-version.sh - Erhöht die Scidc-Version und synchronisiert alle Dateien
#
# Verwendung:
#   bash bump-version.sh     # Erhöht bN → bN+1 (z. B. b7 → b8)
#   bash bump-version.sh 25  # Setzt bN auf 25 (z. B. b7 → b25)
#
# Das Skript:
#   1. Liest die aktuelle Version aus Makefile.version
#   2. Erhöht den Build-Zähler (oder setzt ihn auf den gegebenen Wert)
#   3. Aktualisiert die drei Versionsdateien:
#      - Makefile.version
#      - src/tcl/tcl_misc.cpp
#      - tcl/exec.tcl
#      (tcl/scidc-beta traegt die Version ebenfalls, wird aber in Schritt 4
#       von make neu erzeugt -- keine vierte zu bearbeitende Datei)
#   4. Baut Binary und Bundle neu (make)
#   5. Baut das AppImage neu (build-appimage.sh)

set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

# --- 1. Aktuelle Version lesen -----------------------------------------------
OLD_VERSION=$(grep SCIDB_VERSION Makefile.version | sed 's/.*="\(.*\)"/\1/')
if [ -z "$OLD_VERSION" ]; then
    echo "❌ FEHLER: Konnte Version aus Makefile.version nicht lesen"
    exit 1
fi

# --- 2. Neue Version berechnen -----------------------------------------------
if [ -n "$1" ]; then
    # Benutzerdefinierter Build-Zähler (z. B. "bash bump-version.sh 25")
    NEW_B=$1
else
    # Automatisch erhöhen (bN → bN+1)
    if [[ "$OLD_VERSION" =~ (.*-b)([0-9]+)(.*) ]]; then
        NEW_B=$(( ${BASH_REMATCH[2]} + 1 ))
        NEW_VERSION="${BASH_REMATCH[1]}${NEW_B}${BASH_REMATCH[3]}"
    else
        echo "❌ FEHLER: Version hat nicht das Format JJ.MM.TT-bN-Beta: $OLD_VERSION"
        exit 1
    fi
fi

# Falls NEW_VERSION noch nicht gesetzt ist (bei manueller Eingabe)
if [ -z "$NEW_VERSION" ]; then
    if [[ "$OLD_VERSION" =~ (.*-b)[0-9]+(.*) ]]; then
        NEW_VERSION="${BASH_REMATCH[1]}${NEW_B}${BASH_REMATCH[2]}"
    else
        echo "❌ FEHLER: Konnte neue Version nicht berechnen"
        exit 1
    fi
fi

echo "🔄 Versionsbump: $OLD_VERSION → $NEW_VERSION"

# --- 3. Alle 4 Dateien aktualisieren -----------------------------------------
# Makefile.version (mit Bindestrichen: 26.08.02-b8-Beta)
sed -i "s/"$OLD_VERSION"/"$NEW_VERSION"/g" Makefile.version

# src/tcl/tcl_misc.cpp (mit Leerzeichen: "26.08.02 b8 Beta")
NEW_VERSION_CPP=$(echo "$NEW_VERSION" | sed 's/-b\([0-9]\+\)-Beta/ b\1 Beta/')
sed -i "s/"$(echo "$OLD_VERSION" | sed 's/-b\([0-9]\+\)-Beta/ b\1 Beta/')"/"$NEW_VERSION_CPP"/g" src/tcl/tcl_misc.cpp

# tcl/exec.tcl (mit Leerzeichen: "26.08.02 b8 Beta")
sed -i "s/"$(echo "$OLD_VERSION" | sed 's/-b\([0-9]\+\)-Beta/ b\1 Beta/')"/"$NEW_VERSION_CPP"/g" tcl/exec.tcl

# --- 4. Bundle und Binary neu bauen ------------------------------------------
echo "🔨 Baue Bundle und Binary neu..."
make -C tcl clean >/dev/null 2>&1
make -C tcl >/dev/null 2>&1
make >/dev/null 2>&1

# --- 5. AppImage neu bauen ----------------------------------------------------
echo "📦 Baue AppImage neu..."
bash build-appimage.sh >/dev/null 2>&1

# --- 6. Erfolgsmeldung --------------------------------------------------------
echo "✅ Version auf $NEW_VERSION erhöht und alles synchronisiert!"
echo "   - Makefile.version: $NEW_VERSION"
echo "   - src/tcl/tcl_misc.cpp: $NEW_VERSION_CPP"
echo "   - tcl/exec.tcl: $NEW_VERSION_CPP"
echo "   - tcl/scidc-beta: $NEW_VERSION_CPP (generiert)"
echo "   - AppImage: Scidc-$NEW_VERSION-x86_64.AppImage"
