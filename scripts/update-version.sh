#!/bin/bash
# update-version.sh - Synchronisiert die Versionsnummer in allen 5 relevanten Dateien
#
# Aufruf: ./scripts/update-version.sh <new_version> <new_revision>
#
# Beispiel: ./scripts/update-version.sh "26.07.12 b9 Beta" 1495
#
# Diese 5 Dateien werden aktualisiert:
# 1. Makefile.version
# 2. src/tcl/tcl_misc.cpp
# 3. tcl/exec.tcl
# 4. tcl/scidc-beta (mixed-encoding, via Python)
# 5. tcl/end.tcl

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

if [ $# -ne 2 ]; then
    echo "Usage: $0 <version> <revision>"
    echo "Example: $0 \"26.07.12 b9 Beta\" 1495"
    exit 1
fi

VERSION="$1"
REVISION="$2"

echo "Updating version to: $VERSION (revision: $REVISION)"
echo ""

# 1. Makefile.version
echo "[1/5] Updating Makefile.version..."
sed -i "s/26\.07\.12 b8 Beta/$VERSION/g" Makefile.version
sed -i "s/"1494"/"$REVISION"/g" Makefile.version

# 2. src/tcl/tcl_misc.cpp
echo "[2/5] Updating src/tcl/tcl_misc.cpp..."
sed -i "s/26\.07\.12 b8 Beta/$VERSION/g" src/tcl/tcl_misc.cpp
sed -i "s/"1494"/"$REVISION"/g" src/tcl/tcl_misc.cpp

# 3. tcl/exec.tcl
echo "[3/5] Updating tcl/exec.tcl..."
sed -i "s/26\.07\.12 b8 Beta/$VERSION/g" tcl/exec.tcl

# 4. tcl/scidc-beta (mixed-encoding)
echo "[4/5] Updating tcl/scidc-beta..."
python3 -c "
import sys
version = sys.argv[1]
with open('tcl/scidc-beta', 'rb') as f:
    data = f.read()
before = sum(b > 127 for b in data)
old = b'set version \"26.07.12 b8 Beta\"'
new = b'set version \"' + version.encode('latin-1') + b'\"'
data = data.replace(old, new, 1)
after = sum(b > 127 for b in data)
assert before == after, f'Non-ASCII bytes changed: {before} -> {after}'
with open('tcl/scidc-beta', 'wb') as f:
    f.write(data)
print(f'  Non-ASCII bytes preserved: {after}')
" "$VERSION"

# 5. tcl/end.tcl
echo "[5/5] Updating tcl/end.tcl..."
# Ersetze alle numerischen Revision-Vergleiche (außer den dynamischen mit [::scidc::misc::revision])
sed -i -E "s/(\$::scidc::revision|scidc::revision) < ([0-9]+)/\1 < $REVISION/g" tcl/end.tcl

echo ""
echo "=== All 5 files updated successfully! ==="
echo ""
echo "Modified files:"
echo "  - Makefile.version"
echo "  - src/tcl/tcl_misc.cpp"
echo "  - tcl/exec.tcl"
echo "  - tcl/scidc-beta"
echo "  - tcl/end.tcl"
echo ""
echo "Next steps:"
echo "  1. Verify changes: git diff"
echo "  2. Update CHANGELOG.md if this is a versioned commit"
echo "  3. Commit and push"
