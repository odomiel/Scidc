#!/bin/bash
# =============================================================================
# build-appimage.sh - Erstellt ein AppImage für SciDB
# Ausführen NACH "sudo make install":
#   cd ~/Downloads/scidb/scidb-code-r1531-trunk
#   bash build-appimage.sh
# =============================================================================

set -e

APPDIR="$(pwd)/AppDir"
ARCH=$(uname -m)

echo "=== SciDB AppImage Builder ==="

# --- Schritt 1: Prüfen ob Installation vorhanden --------------------------
if [ ! -f /usr/local/bin/tkscidb-beta ]; then
    echo "FEHLER: /usr/local/bin/tkscidb-beta nicht gefunden!"
    echo "Bitte zuerst 'sudo make install' ausführen."
    exit 1
fi

# --- Schritt 2: AppDir-Struktur anlegen ------------------------------------
rm -rf "$APPDIR"
mkdir -p "$APPDIR/usr/bin"
mkdir -p "$APPDIR/usr/lib"
mkdir -p "$APPDIR/usr/share"

echo "Kopiere Programmdateien..."
cp /usr/local/bin/tkscidb-beta "$APPDIR/usr/bin/"
cp /usr/local/bin/scidb-beta   "$APPDIR/usr/bin/"
cp -r /usr/local/share/scidb-beta "$APPDIR/usr/share/scidb-beta"
[ -d /usr/local/lib/scidb-beta ] && \
    cp -r /usr/local/lib/scidb-beta "$APPDIR/usr/lib/scidb-beta"

# --- Schritt 3: Shared Libraries kopieren ----------------------------------
echo "Kopiere Bibliotheken..."

ldd /usr/local/bin/tkscidb-beta | grep "=>" | awk '{print $3}' | while read lib; do
    [ -z "$lib" ] || [ ! -f "$lib" ] && continue
    name=$(basename "$lib")
    case "$name" in
        libc.so*|libm.so*|libpthread.so*|libdl.so*|librt.so*|libutil.so*|ld-linux*.so*|libgcc_s.so*)
            ;;
        *)
            cp -L "$lib" "$APPDIR/usr/lib/" 2>/dev/null && echo "  $name" || true
            ;;
    esac
done

# Tcl/Tk Skript-Bibliotheken
for tcldir in /usr/lib/tcl8.6 /usr/lib/tk8.6 \
              /usr/share/tcl8.6 /usr/share/tk8.6; do
    [ -d "$tcldir" ] && cp -rL "$tcldir" "$APPDIR/usr/lib/" 2>/dev/null || true
done

# --- Schritt 4: AppRun erstellen -------------------------------------------
cat > "$APPDIR/AppRun" << 'EOF'
#!/bin/bash
SELF=$(readlink -f "$0")
HERE=$(dirname "$SELF")

export PATH="$HERE/usr/bin:$PATH"
export LD_LIBRARY_PATH="$HERE/usr/lib:$LD_LIBRARY_PATH"
export TCL_LIBRARY="$HERE/usr/lib/tcl8.6"
export TK_LIBRARY="$HERE/usr/lib/tk8.6"
export TCLLIBPATH="$HERE/usr/share/scidb-beta $HERE/usr/lib/tcl8.6 $HERE/usr/lib/tk8.6"

exec "$HERE/usr/bin/tkscidb-beta" "$HERE/usr/bin/scidb-beta" "$@"
EOF
chmod +x "$APPDIR/AppRun"

# --- Schritt 5: Icon (aus freedesktop.org) ---------------------------------
echo "Kopiere Icon..."
if [ -f "freedesktop.org/scidb-128.png" ]; then
    cp "freedesktop.org/scidb-128.png" "$APPDIR/scidb-beta.png"
    echo "  Icon: freedesktop.org/scidb-128.png"
elif [ -f "freedesktop.org/scidb-64.png" ]; then
    cp "freedesktop.org/scidb-64.png" "$APPDIR/scidb-beta.png"
else
    # Fallback: Scidb-Logo aus den Programmbildern
    find /usr/local/share/scidb-beta -name "Scidb-Logo-128.png" | \
        head -1 | xargs -I{} cp {} "$APPDIR/scidb-beta.png" 2>/dev/null || true
fi

# --- Schritt 6: Desktop-Datei ---------------------------------------------
cat > "$APPDIR/scidb-beta.desktop" << 'EOF'
[Desktop Entry]
Name=Scidb
Comment=Chess Database
Exec=scidb-beta
Icon=scidb-beta
Type=Application
Categories=Game;BoardGame;
MimeType=application/x-pgn;
EOF

# --- Schritt 7: appimagetool -------------------------------------------------
APPIMAGETOOL_FILE="appimagetool-${ARCH}.AppImage"

if command -v appimagetool &>/dev/null; then
    TOOL="appimagetool"
elif [ -f "./$APPIMAGETOOL_FILE" ]; then
    TOOL="./$APPIMAGETOOL_FILE"
else
    echo "Lade appimagetool herunter..."
    wget -q --show-progress \
        "https://github.com/AppImage/AppImageKit/releases/download/continuous/${APPIMAGETOOL_FILE}" \
        -O "$APPIMAGETOOL_FILE"
    chmod +x "$APPIMAGETOOL_FILE"
    TOOL="./$APPIMAGETOOL_FILE"
fi

ARCH="$ARCH" "$TOOL" "$APPDIR" "Scidb-${ARCH}.AppImage"

echo ""
echo "=== Fertig! ==="
echo "Starten mit: ./Scidb-${ARCH}.AppImage"
