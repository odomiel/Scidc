#!/bin/bash
# update-version.sh - Synchronisiert die Versionsnummer in allen 5 relevanten Dateien
#
# Aufruf: ./scripts/update-version.sh <new_version> <new_revision>
#
# Beispiel: ./scripts/update-version.sh "26.07.12 b10 Beta" 1496
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
    echo "Example: $0 \"26.07.12 b10 Beta\" 1496"
    exit 1
fi

VERSION="$1"
REVISION="$2"

echo "Updating version to: $VERSION (revision: $REVISION)"
echo ""

# 1. Makefile.version
echo "[1/5] Updating Makefile.version..."
sed -i -E "s/(SCIDB_VERSION[[:space:]]*=.*\")([^"]*)(\\\")/\1$VERSION\3/" Makefile.version
sed -i -E "s/(SCIDB_REVISION[[:space:]]*=.*\")([0-9]+)(\\\")/\1$REVISION\3/" Makefile.version

# 2. src/tcl/tcl_misc.cpp
echo "[2/5] Updating src/tcl/tcl_misc.cpp..."
sed -i -E "s/(# define SCIDB_VERSION[[:space:]]+\")([^"]*)(\\\")/\1$VERSION\3/" src/tcl/tcl_misc.cpp
sed -i -E "s/(# define SCIDB_REVISION[[:space:]]+\")([0-9]+)(\\\")/\1$REVISION\3/" src/tcl/tcl_misc.cpp

# 3. tcl/exec.tcl
echo "[3/5] Updating tcl/exec.tcl..."
sed -i -E 's/(set version ")[^"]*(")/\1'$VERSION'\2/' tcl/exec.tcl

# 4. tcl/scidc-beta (mixed-encoding)
echo "[4/5] Updating tcl/scidc-beta..."
python3 -c "
import sys
import re
version = sys.argv[1]
with open('tcl/scidc-beta', 'rb') as f:
    data = f.read()
before = sum(b > 127 for b in data)
# Generisches Pattern: set version \"...\"
old = rb'set version \"[^\"]*\"'
new = b'set version \"' + version.encode('latin-1') + b'\"'
data = re.sub(old, new, data, count=1)
after = sum(b > 127 for b in data)
assert before == after, f'Non-ASCII bytes changed: {before} -> {after}'
with open('tcl/scidc-beta', 'wb') as f:
    f.write(data)
print(f'  Non-ASCII bytes preserved: {after}')
" "$VERSION"

# 5. tcl/end.tcl
# Ersetze alle numerischen Revision-Vergleiche
echo "[5/5] Updating tcl/end.tcl..."
sed -i -E "s/(\$::scidc::revision|scidc::revision) < [0-9]+/\1 < $REVISION/g" tcl/end.tcl

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
