#!/bin/bash
# =============================================================================
# build-appimage.sh - Erstellt ein AppImage für SciDB
#
# Voraussetzungen:
#   1. Einmalig (nur beim ersten Mal oder nach make install-Änderungen):
#         make && sudo make install
#      Danach ist AppDir/usr/share/scidb-beta/ befüllt und bleibt erhalten.
#   2. Bei jeder Änderung nur noch:
#         make
#         bash build-appimage.sh
#
# Für die normale Systeminstallation gilt weiterhin:
#         make && sudo make install
# =============================================================================

set -e

APPDIR="$(pwd)/AppDir"
ARCH=$(uname -m)
SRCBIN="src/tkscidb-beta"
TCLSCRIPT="tcl/scidb-beta"
SHAREDIR="$APPDIR/usr/share/scidb-beta"

echo "=== SciDB AppImage Builder ==="

# --- Voraussetzungen prüfen --------------------------------------------------
if [ ! -f "$SRCBIN" ]; then
    echo "FEHLER: $SRCBIN nicht gefunden!"
    echo "Bitte zuerst 'make' ausführen."
    exit 1
fi

if [ ! -f "$TCLSCRIPT" ]; then
    echo "FEHLER: $TCLSCRIPT nicht gefunden!"
    echo "Bitte zuerst 'make' ausführen."
    exit 1
fi

if [ ! -d "$SHAREDIR" ]; then
    echo "FEHLER: $SHAREDIR nicht gefunden!"
    echo "Beim ersten Mal bitte einmalig ausführen:"
    echo "  make && sudo make install"
    echo "Danach ist AppDir/usr/share/scidb-beta/ befüllt und wird bei"
    echo "zukünftigen Builds nicht mehr angefasst."
    exit 1
fi

# --- Schritt 1: Nur bin/ und lib/ neu aufbauen; share/ bleibt erhalten -------
echo "Aktualisiere Programmdateien..."

# Engines retten, bevor bin/ geleert wird
mkdir -p /tmp/_scidb_engine_backup
for engine in stockfish-scidb fairy-stockfish-scidb; do
    [ -f "$APPDIR/usr/bin/$engine" ] && \
        cp "$APPDIR/usr/bin/$engine" /tmp/_scidb_engine_backup/ || true
done

rm -rf "$APPDIR/usr/bin" "$APPDIR/usr/lib"
mkdir -p "$APPDIR/usr/bin" "$APPDIR/usr/lib"

cp "$SRCBIN"   "$APPDIR/usr/bin/tkscidb-beta"
cp "$TCLSCRIPT" "$APPDIR/usr/bin/scidb-beta"

# --- Schritt 2: Engines wiederherstellen / aktualisieren ---------------------
echo "Kopiere Schach-Engines..."
for engine in stockfish-scidb fairy-stockfish-scidb; do
    # Bevorzuge aktuelle Version aus /usr/local/games, sonst gesicherter Stand
    if [ -f "/usr/local/games/$engine" ]; then
        cp "/usr/local/games/$engine" "$APPDIR/usr/bin/"
        echo "  $engine (aktualisiert aus /usr/local/games)"
    elif [ -f "/tmp/_scidb_engine_backup/$engine" ]; then
        cp "/tmp/_scidb_engine_backup/$engine" "$APPDIR/usr/bin/"
        echo "  $engine (aus vorherigem Build übernommen)"
    else
        echo "  WARNUNG: $engine nicht gefunden — Engine fehlt im AppImage"
    fi
done
rm -rf /tmp/_scidb_engine_backup

# --- Schritt 3: Shared Libraries kopieren ------------------------------------
echo "Kopiere Bibliotheken..."

for binary in "$APPDIR/usr/bin/tkscidb-beta" \
              "$APPDIR/usr/bin/stockfish-scidb" \
              "$APPDIR/usr/bin/fairy-stockfish-scidb"; do
    [ -f "$binary" ] || continue
    ldd "$binary" | grep "=>" | awk '{print $3}' | while read lib; do
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
done

# Tcl/Tk Skript-Bibliotheken
for tcldir in /usr/share/tcltk/tcl8.6 /usr/share/tcltk/tk8.6 \
              /usr/lib/tcl8.6 /usr/lib/tk8.6 \
              /usr/share/tcl8.6 /usr/share/tk8.6; do
    [ -d "$tcldir" ] && cp -rL "$tcldir" "$APPDIR/usr/lib/" 2>/dev/null || true
done

# --- Schritt 4: AppRun erstellen ---------------------------------------------
cat > "$APPDIR/AppRun" << 'APPRUN'
#!/bin/bash
SELF=$(readlink -f "$0")
HERE=$(dirname "$SELF")

export PATH="$HERE/usr/bin:$PATH"
export APPIMAGE_ORIG_LD="${LD_LIBRARY_PATH:-}"
export LD_LIBRARY_PATH="$HERE/usr/lib:$LD_LIBRARY_PATH"
export TCL_LIBRARY="$HERE/usr/lib/tcl8.6"
export TK_LIBRARY="$HERE/usr/lib/tk8.6"
export TCLLIBPATH="$HERE/usr/share/scidb-beta $HERE/usr/lib/tcl8.6 $HERE/usr/lib/tk8.6"
export TCL8_6_TM_PATH="$HERE/usr/lib/tcl8.6/tcl8"
export SCIDB_SHAREDIR="$HERE/usr/share/scidb-beta"

# Engine-Binaries bei Bedarf ins User-Verzeichnis deployen.
# Das Programm sucht Engines in ~/.scidb-beta/engines/ (start.tcl default).
ENGINES_USER="$HOME/.scidb-beta/engines"
mkdir -p "$ENGINES_USER"
for engine in stockfish-scidb fairy-stockfish-scidb; do
    src="$HERE/usr/bin/$engine"
    dst="$ENGINES_USER/$engine"
    # Kopieren wenn das gebündelte Binary neuer ist oder das Ziel fehlt
    if [ -f "$src" ] && { [ ! -f "$dst" ] || [ "$src" -nt "$dst" ]; }; then
        rm -rf "$dst"   # entfernt ggf. ein Verzeichnis gleichen Namens
        cp -p "$src" "$dst"
        chmod +x "$dst"
    fi
done

exec "$HERE/usr/bin/tkscidb-beta" "$HERE/usr/bin/scidb-beta" "$@"
APPRUN
chmod +x "$APPDIR/AppRun"

# --- Schritt 5: Icon ---------------------------------------------------------
echo "Kopiere Icon..."
if [ -f "freedesktop.org/scidb-128.png" ]; then
    cp "freedesktop.org/scidb-128.png" "$APPDIR/scidb-beta.png"
elif [ -f "freedesktop.org/scidb-64.png" ]; then
    cp "freedesktop.org/scidb-64.png" "$APPDIR/scidb-beta.png"
else
    find "$SHAREDIR" -name "Scidb-Logo-128.png" | \
        head -1 | xargs -I{} cp {} "$APPDIR/scidb-beta.png" 2>/dev/null || true
fi

# --- Schritt 6: Desktop-Datei ------------------------------------------------
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
