#!/bin/bash
# =============================================================================
# build-tcltk.sh - Baut Tcl/Tk 8.6.18 lokal in deps/tcltk/
#
# Einmalig ausführen bevor build-appimage.sh:
#     bash build-tcltk.sh
#
# Voraussetzungen:
#     sudo apt install libx11-dev libxft-dev libxss-dev libxext-dev
# =============================================================================

set -e

VERSION="8.6.18"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PREFIX="${SCRIPT_DIR}/deps/tcltk"
BUILDDIR="/tmp/scidb-tcltk-${VERSION}-build"

TCL_URL="https://sourceforge.net/projects/tcl/files/Tcl/${VERSION}/tcl${VERSION}-src.tar.gz/download"
TK_URL="https://sourceforge.net/projects/tcl/files/Tcl/${VERSION}/tk${VERSION}-src.tar.gz/download"

echo "=== Baue Tcl/Tk ${VERSION} nach ${PREFIX} ==="

# Bereits vorhanden?
if [ -f "${PREFIX}/lib/libtcl8.6.so" ] && [ -f "${PREFIX}/lib/libtk8.6.so" ]; then
    BUILT_VER=$(strings "${PREFIX}/lib/libtcl8.6.so" 2>/dev/null | grep "^${VERSION}$" | head -1)
    if [ "${BUILT_VER}" = "${VERSION}" ]; then
        echo "Tcl/Tk ${VERSION} bereits gebaut — nichts zu tun."
        exit 0
    fi
fi

mkdir -p "${BUILDDIR}" "${PREFIX}"

# --- Tcl -----------------------------------------------------------------------
echo ""
echo "--- Lade Tcl ${VERSION} herunter ---"
wget -q --show-progress -O "${BUILDDIR}/tcl-src.tar.gz" "${TCL_URL}"

cd "${BUILDDIR}"
tar xzf tcl-src.tar.gz
cd "tcl${VERSION}/unix"

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
wget -q --show-progress -O "${BUILDDIR}/tk-src.tar.gz" "${TK_URL}"

tar xzf tk-src.tar.gz
cd "tk${VERSION}/unix"

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
echo "    Libs:    ${PREFIX}/lib/libtcl8.6.so"
echo "             ${PREFIX}/lib/libtk8.6.so"
echo "    Scripts: ${PREFIX}/lib/tcl${VERSION}/"
echo "             ${PREFIX}/lib/tk${VERSION}/"
echo ""
echo "Jetzt build-appimage.sh ausführen."
