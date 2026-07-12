#!/usr/bin/env python3
"""
update_version.py - Synchronisiert die Versionsnummer in allen relevanten Dateien

Aufruf:
    python3 scripts/update_version.py [version [revision]]

Ohne Argumente: Liest die aktuelle Version aus Makefile.version

Mit 1 Argument: Version setzen, Revision wird automatisch inkrementiert
    python3 scripts/update_version.py "26.07.12 b10 Beta"

Mit 2 Argumenten: Version und Revision explizit setzen
    python3 scripts/update_version.py "26.07.12 b10 Beta" 1496

Diese 5 Dateien werden aktualisiert:
1. Makefile.version (SCIDB_VERSION + SCIDB_REVISION)
2. src/tcl/tcl_misc.cpp (CODEBLOCKS-Block)
3. tcl/exec.tcl (namespace eval scidc)
4. tcl/scidc-beta (Bundle, Zeile 41, mixed-encoding)
5. tcl/end.tcl (revision Vergleich)
"""

import sys
import os
import re

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
os.chdir(PROJECT_DIR)


def get_current_revision():
    """Liest die aktuelle Revision aus Makefile.version"""
    if not os.path.exists('Makefile.version'):
        return None
    with open('Makefile.version') as f:
        for line in f:
            if 'SCIDB_REVISION' in line:
                match = re.search(r'"([0-9]+)"', line)
                if match:
                    return match.group(1)
    return None


def update_file_text(filepath, old_text, new_text):
    """Ersetzt Text in einer Datei"""
    if not os.path.exists(filepath):
        print(f"  WARNING: {filepath} not found")
        return False
    
    with open(filepath, 'r') as f:
        content = f.read()
    
    if old_text in content:
        content = content.replace(old_text, new_text)
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"  OK {filepath}")
        return True
    else:
        print(f"  - {filepath} (pattern not found)")
        return False


def update_bundle(filepath, version):
    """Aktualisiert die Bundle-Datei mit Binary-I/O (mixed-encoding)"""
    if not os.path.exists(filepath):
        print(f"  WARNING: {filepath} not found")
        return False
    
    # Berechtigungen temporär ändern
    old_mode = os.stat(filepath).st_mode
    try:
        os.chmod(filepath, 0o644)
        
        with open(filepath, 'rb') as f:
            data = f.read()
        
        before = sum(b > 127 for b in data)
        
        # Ersetze die Version - generisches Pattern
        old = rb'set version "[^"]*"'
        new = b'set version "' + version.encode('latin-1') + b'"'
        data = re.sub(old, new, data, count=1)
        
        after = sum(b > 127 for b in data)
        assert before == after, f'Non-ASCII bytes changed: {before} -> {after}'
        
        with open(filepath, 'wb') as f:
            f.write(data)
        
        print(f"  OK {filepath} (Non-ASCII bytes: {after})")
        return True
    finally:
        os.chmod(filepath, old_mode)


def main():
    # Argument parsing
    if len(sys.argv) == 1:
        # Aktuelle Version anzeigen
        current_rev = get_current_revision()
        print(f"Current revision: {current_rev or 'NOT SET'}")
        print(f"Usage: {sys.argv[0]} [version [revision]]")
        return 0
    
    version = sys.argv[1]
    
    if len(sys.argv) == 2:
        # Revision automatisch inkrementieren
        current_rev = get_current_revision()
        try:
            revision = str(int(current_rev) + 1) if current_rev else "1"
        except ValueError:
            revision = "1"
    else:
        revision = sys.argv[2]
    
    print(f"Updating version to: {version} (revision: {revision})")
    print()
    
    all_ok = True
    
    # 1. Makefile.version
    print("[1/5] Updating Makefile.version...")
    if not update_file_text('Makefile.version',
                          'SCIDB_VERSION.*',
                          f'SCIDB_VERSION\t= -DSCIDB_VERSION="\"{version}\""'):
        all_ok = False
    
    if not update_file_text('Makefile.version',
                          'SCIDB_REVISION.*',
                          f'SCIDB_REVISION\t= -DSCIDB_REVISION="\"{revision}\""'):
        all_ok = False
    
    # 2. src/tcl/tcl_misc.cpp
    print("[2/5] Updating src/tcl/tcl_misc.cpp...")
    if not update_file_text('src/tcl/tcl_misc.cpp',
                          '# define SCIDB_VERSION.*',
                          f'# define SCIDB_VERSION\t"{version}"'):
        all_ok = False
    
    if not update_file_text('src/tcl/tcl_misc.cpp',
                          '# define SCIDB_REVISION.*',
                          f'# define SCIDB_REVISION\t"{revision}"'):
        all_ok = False
    
    # 3. tcl/exec.tcl
    print("[3/5] Updating tcl/exec.tcl...")
    if not update_file_text('tcl/exec.tcl',
                          'set version ".*"',
                          f'set version "{version}"'):
        all_ok = False
    
    # 4. tcl/scidc-beta (mixed-encoding)
    print("[4/5] Updating tcl/scidc-beta...")
    if not update_bundle('tcl/scidc-beta', version):
        all_ok = False
    
    # 5. tcl/end.tcl
    print("[5/5] Updating tcl/end.tcl...")
    # Ersetze alle $::scidc::revision < NUMBER
    with open('tcl/end.tcl', 'r') as f:
        content = f.read()
    
    content = re.sub(r'\$::scidc::revision < \d+', f'$::scidc::revision < {revision}', content)
    content = re.sub(r'scidc::revision < \d+', f'scidc::revision < {revision}', content)
    
    with open('tcl/end.tcl', 'w') as f:
        f.write(content)
    print(f"  OK tcl/end.tcl")
    
    print()
    if all_ok:
        print("OK All files updated successfully!")
        print()
        print("Next steps:")
        print("  1. Verify changes: git diff")
        print("  2. Update CHANGELOG.md if this is a versioned commit")
        print("  3. Commit and push")
        return 0
    else:
        print("ERROR Some files could not be updated")
        return 1


if __name__ == '__main__':
    sys.exit(main())
