#!/bin/bash
# =============================================================================
# build-appimage.sh - Erstellt ein AppImage für SciDC
#
# Voraussetzungen:
#   1. Einmalig (nur beim ersten Mal oder nach make install-Änderungen):
#         make && sudo make install
#      Danach ist AppDir/usr/share/scidc-beta/ befüllt und bleibt erhalten.
#   2. Bei jeder Änderung nur noch:
#         make
#         bash build-appimage.sh
#
# Für die normale Systeminstallation gilt weiterhin:
#         make && sudo make install
# =============================================================================

set -e

APPDIR="$(pwd)/AppDir"
TCLTKDIR="$(pwd)/deps/tcltk"
ARCH=$(uname -m)
SRCBIN="src/tkscidc-beta"
TCLSCRIPT="tcl/scidc-beta"
SHAREDIR="$APPDIR/usr/share/scidc-beta"

echo "=== Scidc AppImage Builder ==="

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
    echo "Danach ist AppDir/usr/share/scidc-beta/ befüllt und wird bei"
    echo "zukünftigen Builds nicht mehr angefasst."
    exit 1
fi

if [ ! -f "$TCLTKDIR/lib/libtcl8.6.so" ] || [ ! -f "$TCLTKDIR/lib/libtk8.6.so" ]; then
    echo "FEHLER: Tcl/Tk 8.6.18 nicht gefunden in $TCLTKDIR"
    echo "Bitte zuerst ausführen: bash build-tcltk.sh"
    exit 1
fi

# --- Schritt 1: Nur bin/ und lib/ neu aufbauen; share/ bleibt erhalten -------
echo "Aktualisiere Programmdateien..."

# Engines retten, bevor bin/ geleert wird
mkdir -p /tmp/_scidc_engine_backup
for engine in stockfish-scidc fairy-stockfish-scidc; do
    [ -f "$APPDIR/usr/bin/$engine" ] && \
        cp "$APPDIR/usr/bin/$engine" /tmp/_scidc_engine_backup/ || true
done

rm -rf "$APPDIR/usr/bin" "$APPDIR/usr/lib"
mkdir -p "$APPDIR/usr/bin" "$APPDIR/usr/lib"

cp "$SRCBIN"   "$APPDIR/usr/bin/tkscidc-beta"
cp "$TCLSCRIPT" "$APPDIR/usr/bin/scidc-beta"

# --- Schritt 2: Engines wiederherstellen / aktualisieren ---------------------
echo "Kopiere Schach-Engines..."
for engine in stockfish-scidc fairy-stockfish-scidc; do
    # Bevorzuge aktuelle Version aus /usr/local/games, sonst gesicherter Stand
    if [ -f "/usr/local/games/$engine" ]; then
        cp "/usr/local/games/$engine" "$APPDIR/usr/bin/"
        echo "  $engine (aktualisiert aus /usr/local/games)"
    elif [ -f "/tmp/_scidc_engine_backup/$engine" ]; then
        cp "/tmp/_scidc_engine_backup/$engine" "$APPDIR/usr/bin/"
        echo "  $engine (aus vorherigem Build übernommen)"
    else
        echo "  WARNUNG: $engine nicht gefunden — Engine fehlt im AppImage"
    fi
done
rm -rf /tmp/_scidc_engine_backup

# --- Schritt 3a: Tcl/Tk 8.6.18 aus lokalem Build ----------------------------
echo "Kopiere Tcl/Tk 8.6.18..."
cp -L  "$TCLTKDIR/lib/libtcl8.6.so" "$APPDIR/usr/lib/"
cp -L  "$TCLTKDIR/lib/libtk8.6.so"  "$APPDIR/usr/lib/"
cp -rL "$TCLTKDIR/lib/tcl8.6"       "$APPDIR/usr/lib/"
cp -rL "$TCLTKDIR/lib/tk8.6"        "$APPDIR/usr/lib/"
# Tcl-Module (msgcat, http, …): Source-Build legt diese unter lib/tcl8/{ver}/
cp -rL "$TCLTKDIR/lib/tcl8"         "$APPDIR/usr/lib/"

# --- Schritt 3b: Weitere Shared Libraries via ldd ----------------------------
echo "Kopiere weitere Bibliotheken..."

for binary in "$APPDIR/usr/bin/tkscidc-beta" \
              "$APPDIR/usr/bin/stockfish-scidc" \
              "$APPDIR/usr/bin/fairy-stockfish-scidc"; do
    [ -f "$binary" ] || continue
    ldd "$binary" | grep "=>" | awk '{print $3}' | while read lib; do
        [ -z "$lib" ] || [ ! -f "$lib" ] && continue
        name=$(basename "$lib")
        case "$name" in
            libc.so*|libm.so*|libpthread.so*|libdl.so*|librt.so*|libutil.so*|ld-linux*.so*|libgcc_s.so*|\
            libtcl8.6.so|libtk8.6.so)
                ;;
            *)
                cp -L "$lib" "$APPDIR/usr/lib/" 2>/dev/null && echo "  $name" || true
                ;;
        esac
    done
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
export TCLLIBPATH="$HERE/usr/share/scidc-beta $HERE/usr/lib/tcl8.6 $HERE/usr/lib/tk8.6"
export TCL8_6_TM_PATH="$HERE/usr/lib/tcl8"
export SCIDB_SHAREDIR="$HERE/usr/share/scidc-beta"

# Engine-Binaries bei Bedarf ins User-Verzeichnis deployen.
# Das Programm sucht Engines in ~/.scidc-beta/engines/ (start.tcl default).
ENGINES_USER="$HOME/.scidc-beta/engines/bin"
mkdir -p "$ENGINES_USER"
for engine in stockfish-scidc fairy-stockfish-scidc; do
    src="$HERE/usr/bin/$engine"
    dst="$ENGINES_USER/$engine"
    # Kopieren wenn das gebündelte Binary neuer ist oder das Ziel fehlt
    if [ -f "$src" ] && { [ ! -f "$dst" ] || [ "$src" -nt "$dst" ]; }; then
        rm -rf "$dst"   # entfernt ggf. ein Verzeichnis gleichen Namens
        cp -p "$src" "$dst"
        chmod +x "$dst"
    fi
done

exec "$HERE/usr/bin/tkscidc-beta" "$HERE/usr/bin/scidc-beta" "$@"
APPRUN
chmod +x "$APPDIR/AppRun"

# --- Schritt 5: Icon ---------------------------------------------------------
echo "Kopiere Icon..."
if [ -f "freedesktop.org/scidb-128.png" ]; then
    cp "freedesktop.org/scidb-128.png" "$APPDIR/scidc-beta.png"
elif [ -f "freedesktop.org/scidb-64.png" ]; then
    cp "freedesktop.org/scidb-64.png" "$APPDIR/scidc-beta.png"
else
    find "$SHAREDIR" -name "Scidb-Logo-128.png" | \
        head -1 | xargs -I{} cp {} "$APPDIR/scidc-beta.png" 2>/dev/null || true
fi

# --- Schritt 6: Desktop-Datei ------------------------------------------------
cat > "$APPDIR/scidc-beta.desktop" << 'EOF'
[Desktop Entry]
Name=Scidc
Comment=Chess Database
Exec=scidc-beta
Icon=scidc-beta
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

ARCH="$ARCH" "$TOOL" "$APPDIR" "Scidc-${ARCH}.AppImage"

echo ""
echo "=== Fertig! ==="
echo "Starten mit: ./Scidc-${ARCH}.AppImage"
