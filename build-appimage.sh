#!/bin/bash
# =============================================================================
# build-appimage.sh - Erstellt ein AppImage für SciDC
#
# Workflow:
#   1. Einmalig: ./configure && make
#   2. Bei jeder Änderung:
#         make
#         bash build-appimage.sh
#
# Das Skript befüllt AppDir/usr/share/scidc-beta/ beim ersten Aufruf
# automatisch aus dem Source-Tree (kein 'sudo make install' nötig).
# =============================================================================

set -e

APPDIR="$(pwd)/AppDir"
TCLTKDIR="$(pwd)/deps/tcltk"
ARCH=$(uname -m)
SRCBIN="src/tkscidc-beta"
TCLSCRIPT="tcl/scidc-beta"
SHAREDIR="$APPDIR/usr/share/scidc-beta"

# Tcl/Tk 9: Tk traegt die Tcl-Hauptversion im Bibliotheksnamen, und die
# Skript-Library steckt als zipfs in der .so - es gibt also keine
# lib/tcl9.0/-Verzeichnisse mehr zu kopieren.
TCLTK_VERSION="9.0"
TCL_LIB="libtcl${TCLTK_VERSION}.so"
TK_LIB="libtcl${TCLTK_VERSION%%.*}tk${TCLTK_VERSION}.so"

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

if [ ! -f "$TCLTKDIR/lib/$TCL_LIB" ] || [ ! -f "$TCLTKDIR/lib/$TK_LIB" ]; then
    echo "FEHLER: Tcl/Tk $TCLTK_VERSION nicht gefunden in $TCLTKDIR"
    echo "Erwartet: lib/$TCL_LIB und lib/$TK_LIB"
    echo "Bitte zuerst ausführen: bash build-tcltk.sh"
    exit 1
fi

# --- Versionspruefung (einmal je Tag) ----------------------------------------
# Meldet neuere Engine-Versionen (Katalog tcl/engines/downloads.dat) sowie
# neuere Ausgaben der gepinnten Abhaengigkeiten Tcl/Tk und minizip-ng. Rein
# informativ - ein fehlender Netzzugang darf den Build nicht aufhalten.
UPDATE_STAMP="deps/.update-check"
UPDATE_TODAY=$(date +%Y-%m-%d)
if [ "$(cat "$UPDATE_STAMP" 2>/dev/null)" != "$UPDATE_TODAY" ] \
   && command -v python3 >/dev/null 2>&1 \
   && [ -f tools/check-updates.py ]; then
    python3 tools/check-updates.py || true
    mkdir -p "$(dirname "$UPDATE_STAMP")"
    echo "$UPDATE_TODAY" > "$UPDATE_STAMP"
fi

# --- Schritt 0: AppDir/usr/share/ beim ersten Mal aus Source-Tree befüllen --
if [ ! -d "$SHAREDIR" ]; then
    echo "Erstmaliger Build: befülle AppDir/usr/share/scidc-beta/ ..."
    mkdir -p "$SHAREDIR"
    make -C tcl install \
        SHAREDIR="$SHAREDIR" \
        BINDIR="$APPDIR/usr/bin"
    make -C src install-data install-scripts \
        SHAREDIR="$SHAREDIR"
    echo "AppDir/usr/share/scidc-beta/ angelegt."
fi

# --- Schritt 1: Nur bin/ und lib/ neu aufbauen; share/ bleibt erhalten -------
echo "Aktualisiere Programmdateien..."

# Sprachdateien aus dem Source-Tree synchronisieren
cp tcl/lang/*.tcl "$SHAREDIR/lang/"

# Engines-Konfiguration synchronisieren
cp tcl/engines/engines.dat "$SHAREDIR/engines/engines.dat"
# Download-Katalog der Engines (gepinnte Versionen samt SHA-256)
cp tcl/engines/downloads.dat "$SHAREDIR/engines/downloads.dat"

# Spielerlexikon-Update-Skripte synchronisieren (SHAREDIR wird nur beim
# Erst-Build befuellt, daher hier bei jedem Build aktualisieren)
mkdir -p "$SHAREDIR/scripts"
cp tcl/update-fide-players.py tcl/update-dwz-players.py "$SHAREDIR/scripts/"
# plain.eXt ist die Makro-Basis der TeXt-Skripte (common.eXt zieht sie via
# "\input\plain"). Sie liegt in src/util/libTeXt/ und wird vom Make-Ziel
# install-scripts geliefert - fehlt sie, scheitern Spielerkarte,
# Kreuztabelle und alle Turniertabellen mit "I can't find file 'plain'".
cp src/util/libTeXt/plain.eXt "$SHAREDIR/scripts/"
chmod 755 "$SHAREDIR/scripts/update-fide-players.py" "$SHAREDIR/scripts/update-dwz-players.py"

# Hilfe-HTML-Dateien synchronisieren
find tcl/help -name "*.html" | while read f; do
    rel="${f#tcl/help/}"
    dest="$SHAREDIR/help/$rel"
    [ -f "$dest" ] && cp "$f" "$dest"
done

# Bilddaten synchronisieren. SHAREDIR wird nur beim Erstbau befuellt -- ohne
# diesen Abgleich behaelt ein bestehendes AppDir das alte Logo, waehrend das
# Desktop-Symbol schon das neue traegt.
mkdir -p "$SHAREDIR/images" "$SHAREDIR/help/images" "$SHAREDIR/flags"
cp -f tcl/images/*.png "$SHAREDIR/images/"
cp -f tcl/help/images/* "$SHAREDIR/help/images/" 2>/dev/null || true
cp -f tcl/flags/*.png "$SHAREDIR/flags/"

# Texturen abgleichen, und zwar mit Loeschen: ein blosses Kopieren laesst
# entfernte Dateien im Paket stehen, und der Texturbrowser listet alles, was
# im Verzeichnis liegt (board-texture.tcl, glob) -- sie waeren also weiter
# sichtbar.
if [ -d "$SHAREDIR/textures" ]; then
    rm -rf "$SHAREDIR/textures"
fi
mkdir -p "$SHAREDIR/textures"
cp -r tcl/textures/. "$SHAREDIR/textures/"

# ttk-Themes synchronisieren (wird zur Laufzeit aus share/ geladen, nicht aus dem Bundle)
mkdir -p "$SHAREDIR/themes/ttk"
cp -f tcl/themes/ttk/*.tcl "$SHAREDIR/themes/ttk/"

# Lizenztexte mitliefern. MIT, BSD, zlib, libpng und die FreeType-Lizenz
# verlangen, dass Copyright- und Erlaubnisvermerk der Binaerweitergabe
# beiliegen -- ein Link auf das Projekt genuegt dafuer nicht. licenses/ wird
# von tools/collect-licenses.py aus den copyright-Dateien des Bausystems
# erzeugt; COPYING und COPYRIGHT kommen fuer Scidc selbst dazu.
if ! python3 tools/collect-licenses.py --check >/dev/null 2>&1; then
    echo "  HINWEIS: licenses/ weicht vom Bausystem ab -- einmal"
    echo "           'python3 tools/collect-licenses.py' laufen lassen."
fi
mkdir -p "$SHAREDIR/licenses"
cp -f licenses/*.txt "$SHAREDIR/licenses/"
cp -f COPYING "$SHAREDIR/licenses/scidc-COPYING.txt"
cp -f COPYRIGHT "$SHAREDIR/licenses/scidc-COPYRIGHT.txt"

rm -rf "$APPDIR/usr/bin" "$APPDIR/usr/lib"
mkdir -p "$APPDIR/usr/bin" "$APPDIR/usr/lib"

cp "$SRCBIN"    "$APPDIR/usr/bin/tkscidc-beta"
strip           "$APPDIR/usr/bin/tkscidc-beta"
cp "$TCLSCRIPT" "$APPDIR/usr/bin/scidc-beta"

# Engines werden nicht ins AppImage gebündelt – das Programm bietet beim
# ersten Start an sie herunterzuladen.

# --- Schritt 3a: Tcl/Tk aus lokalem Build ------------------------------------
echo "Kopiere Tcl/Tk $TCLTK_VERSION..."
cp -L "$TCLTKDIR/lib/$TCL_LIB" "$APPDIR/usr/lib/"
cp -L "$TCLTKDIR/lib/$TK_LIB"  "$APPDIR/usr/lib/"

# Ab Tcl 9 sind die Skript-Libraries von Tcl und Tk als zipfs in den beiden
# .so-Dateien eingebettet (info library liefert //zipfs:/lib/tcl/tcl_library).
# Es bleiben nur noch die Tcl-Module und Tks pkgIndex.tcl.
if [ -d "$TCLTKDIR/lib/tcl${TCLTK_VERSION%%.*}" ]; then
    cp -rL "$TCLTKDIR/lib/tcl${TCLTK_VERSION%%.*}" "$APPDIR/usr/lib/"
fi
if [ -f "$TCLTKDIR/lib/tk${TCLTK_VERSION}/pkgIndex.tcl" ]; then
    mkdir -p "$APPDIR/usr/lib/tk${TCLTK_VERSION}"
    cp -L "$TCLTKDIR/lib/tk${TCLTK_VERSION}/pkgIndex.tcl" \
          "$APPDIR/usr/lib/tk${TCLTK_VERSION}/"
fi

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
            "$TCL_LIB"|"$TK_LIB")
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
# Ab Tcl 9 liegen die Skript-Libraries als zipfs in libtcl9.0.so bzw.
# libtcl9tk9.0.so - TCL_LIBRARY/TK_LIBRARY werden nicht mehr gesetzt, sonst
# wuerde Tcl an einem leeren Verzeichnis haengenbleiben.
export TCLLIBPATH="$HERE/usr/share/scidc-beta $HERE/usr/lib"
export TCL9_0_TM_PATH="$HERE/usr/lib/tcl9/9.0"
export SCIDB_SHAREDIR="$HERE/usr/share/scidc-beta"

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

# Versionsnummer aus Makefile.version lesen und in den Dateinamen einbauen
# (Schema: Scidc-<Version>-<arch>.AppImage; Leerzeichen -> '-')
VERSION=$(grep SCIDB_VERSION Makefile.version | sed 's/.*-DSCIDB_VERSION=\\"//;s/\\"$//')
if [ -n "$VERSION" ]; then
    VERSION_SAFE=$(echo "$VERSION" | tr ' ' '-')
    OUTNAME="Scidc-${VERSION_SAFE}-${ARCH}.AppImage"
else
    echo "WARNUNG: Version aus Makefile.version nicht lesbar – nutze unversionierten Namen."
    OUTNAME="Scidc-${ARCH}.AppImage"
fi

ARCH="$ARCH" "$TOOL" "$APPDIR" "$OUTNAME"

echo ""
echo "=== Fertig! ==="
echo "Starten mit: ./$OUTNAME"
