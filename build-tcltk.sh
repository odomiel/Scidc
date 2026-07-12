#!/bin/bash
# =============================================================================
# build-tcltk.sh - Baut Tcl/Tk lokal in deps/tcltk/
#
# Einmalig ausführen bevor build-appimage.sh:
#     bash build-tcltk.sh [version]
#
# unterstützte Versionen:
#     8.6.18 (Standard, stabil)
#     9.0.4 (experimentell, für Tk 9.0 Portierung)
#
# Beispiele:
#     bash build-tcltk.sh               # baut Tcl/Tk 8.6.18
#     bash build-tcltk.sh 9.0.4         # baut Tcl/Tk 9.0.4
#
# Voraussetzungen:
#     sudo apt install libx11-dev libxft-dev libxss-dev libxext-dev wget
# =============================================================================

set -e

# --- Konfiguration -------------------------------------------------------------

# Standardversion
DEFAULT_VERSION="8.6.18"

# Versions-spezifische URLs und Optionen
declare -A TCL_URLS=(
    ["8.6.18"]="https://sourceforge.net/projects/tcl/files/Tcl/8.6.18/tcl8.6.18-src.tar.gz/download"
    ["9.0.4"]="https://sourceforge.net/projects/tcl/files/Tcl/9.0.4/tcl9.0.4-src.tar.gz/download"
)

declare -A TK_URLS=(
    ["8.6.18"]="https://sourceforge.net/projects/tcl/files/Tcl/8.6.18/tk8.6.18-src.tar.gz/download"
    ["9.0.4"]="https://sourceforge.net/projects/tcl/files/Tcl/9.0.4/tk9.0.4-src.tar.gz/download"
)

# Tcl Version aus Tcl URL extrahieren (für Header-Pfad)
declare -A TCL_SHORT_VERSION=(
    ["8.6.18"]="8.6"
    ["9.0.4"]="9.0"
)

# --- Argument parsing ----------------------------------------------------------

VERSION="${1:-$DEFAULT_VERSION}"

# Prüfe ob die Version unterstützt wird
if [ -z "${TCL_URLS[$VERSION]}" ] || [ -z "${TK_URLS[$VERSION]}" ]; then
    echo "Fehler: Ununterstützte Version '${VERSION}'"
    echo "Unterstützte Versionen: ${!TCL_URLS[*]}"
    exit 1
fi

TCL_URL="${TCL_URLS[$VERSION]}"
TK_URL="${TK_URLS[$VERSION]}"
TCL_SHORT="${TCL_SHORT_VERSION[$VERSION]}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PREFIX="${SCRIPT_DIR}/deps/tcltk"
BUILDDIR="/tmp/scidb-tcltk-${VERSION}-build"

# Für Tk 9.0: andere Bibliothek names (libtcl9.0.so, libtk9.0.so)
TCL_LIB_NAME="libtcl${TCL_SHORT}.so"
TK_LIB_NAME="libtk${TCL_SHORT}.so"

echo "=== Baue Tcl/Tk ${VERSION} nach ${PREFIX} ==="

# --- Prüfe ob bereits gebaut ---------------------------------------------------

if [ -f "${PREFIX}/lib/${TCL_LIB_NAME}" ] && [ -f "${PREFIX}/lib/${TK_LIB_NAME}" ]; then
    BUILT_VER=$(strings "${PREFIX}/lib/${TCL_LIB_NAME}" 2>/dev/null | grep -E "^${VERSION}$|^${TCL_SHORT}" | head -1)
    if [ "${BUILT_VER}" = "${VERSION}" ] || [ "${BUILT_VER}" = "${TCL_SHORT}" ]; then
        echo "Tcl/Tk ${VERSION} bereits gebaut — nichts zu tun."
        exit 0
    fi
fi

mkdir -p "${BUILDDIR}" "${PREFIX}"

# --- Tcl -----------------------------------------------------------------------
echo ""
echo "--- Lade Tcl ${VERSION} herunter ---"

TCL_ARCHIVE="${BUILDDIR}/tcl-${VERSION}-src.tar.gz"
wget -q --show-progress -O "${TCL_ARCHIVE}" "${TCL_URL}"

cd "${BUILDDIR}"
tar xzf "${TCL_ARCHIVE}"
TCL_SRC_DIR="tcl${VERSION}/unix"

# Für Tcl 9.0: anderer Source-Verzeichnisname
if [ ! -d "${TCL_SRC_DIR}" ]; then
    # Versuche alternative Verzeichnisnamen
    TCL_SRC_DIR="tcl${VERSION}/unix"  
    if [ ! -d "${TCL_SRC_DIR}" ]; then
        # Tcl 9.0 hat möglicherweise ein anderes Struktur
        TCL_BASE_DIR=$(tar tzf "${TCL_ARCHIVE}" | head -1 | cut -d'/' -f1)
        TCL_SRC_DIR="${TCL_BASE_DIR}/unix"
        if [ ! -d "${BUILDDIR}/${TCL_SRC_DIR}" ]; then
            echo "Fehler: Kann Tcl Source-Verzeichnis nicht finden in ${BUILDDIR}"
            ls -la "${BUILDDIR}"
            exit 1
        fi
    fi
fi

cd "${TCL_SRC_DIR}"

echo "--- Konfiguriere und baue Tcl ---"
./configure \
    --prefix="${PREFIX}" \
    --enable-shared \
    --enable-threads \
    --disable-rpath \
    --mandir="${PREFIX}/man"

make -j"$(nproc)"
make install
make install-headers

# --- Tk ------------------------------------------------------------------------
echo ""
echo "--- Lade Tk ${VERSION} herunter ---"

cd "${BUILDDIR}"
TK_ARCHIVE="${BUILDDIR}/tk-${VERSION}-src.tar.gz"
wget -q --show-progress -O "${TK_ARCHIVE}" "${TK_URL}"

tar xzf "${TK_ARCHIVE}"
TK_SRC_DIR="tk${VERSION}/unix"

# Für Tk 9.0: anderer Source-Verzeichnisname
if [ ! -d "${TK_SRC_DIR}" ]; then
    TK_BASE_DIR=$(tar tzf "${TK_ARCHIVE}" | head -1 | cut -d'/' -f1)
    TK_SRC_DIR="${TK_BASE_DIR}/unix"
    if [ ! -d "${BUILDDIR}/${TK_SRC_DIR}" ]; then
        echo "Fehler: Kann Tk Source-Verzeichnis nicht finden in ${BUILDDIR}"
        ls -la "${BUILDDIR}"
        exit 1
    fi
fi

cd "${TK_SRC_DIR}"

echo "--- Konfiguriere und baue Tk ---"
./configure \
    --prefix="${PREFIX}" \
    --with-tcl="${PREFIX}/lib" \
    --enable-shared \
    --enable-threads \
    --disable-rpath \
    --mandir="${PREFIX}/man"

make -j"$(nproc)"
make install
make install-headers

# --- Aufräumen -----------------------------------------------------------------
rm -rf "${BUILDDIR}"

echo ""
echo "=== Tcl/Tk ${VERSION} erfolgreich gebaut ==="
echo "    Libs:    ${PREFIX}/lib/${TCL_LIB_NAME}"
echo "             ${PREFIX}/lib/${TK_LIB_NAME}"
echo "    Scripts: ${PREFIX}/lib/tcl${TCL_SHORT}/"
echo "             ${PREFIX}/lib/tk${TCL_SHORT}/"
echo ""
echo "Nächste Schritte:"
echo "  1. make"
echo "  2. bash build-appimage.sh"
