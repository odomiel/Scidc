#!/usr/bin/env python3
"""
Script zum Ersetzen von direkten Tk-Internal-Zugriffen durch Kompatibilitäts-Wrapper.

Verwendung:
    python3 scripts/replace_tk_internals.py <datei.cpp>

Beispiele:
    python3 scripts/replace_tk_internals.py src/tk/tk_fixes.cpp
    python3 scripts/replace_tk_internals.py src/tk/tk_base.cpp
"""

import sys
import re

# Ersetzungs-Regeln: (altes_pattern, neues_code)
REPLACEMENTS = [
    # Einfache winPtr-> Zugriffe
    (r'\bwinPtr->window\b', 'tkCompat::getWindowId(winPtr)'),
    (r'\bwinPtr->display\b', 'tkCompat::getDisplay(winPtr)'),
    (r'\bwinPtr->screenNum\b', 'tkCompat::getScreenNum(winPtr)'),
    (r'\bwinPtr->dispPtr\b', 'tkCompat::getDispPtr(winPtr)'),
    
    # Flag-Checks
    (r'\bwinPtr->flags & TK_MAPPED\b', 'tkCompat::isWindowMapped(winPtr)'),
    (r'\bwinPtr->flags & TK_TOP_LEVEL\b', 'tkCompat::isWindowTopLevel(winPtr)'),
    (r'\bwinPtr->flags & TK_TOP_HIERARCHY\b', 'tkCompat::isWindowTopHierarchy(winPtr)'),
    
    # Parent/Child Zugriffe
    (r'\bwinPtr->parentPtr\b', 'tkCompat::getParentWinPtr(winPtr)'),
    (r'\bwinPtr->nextPtr\b', 'tkCompat::getNextWinPtr(winPtr)'),
    (r'\bwinPtr->childList\b', 'tkCompat::getChildList(winPtr)'),
    (r'\bwinPtr->lastChildPtr\b', 'tkCompat::getLastChildPtrPtr(winPtr)'),
    
    # Geometry
    (r'\bwinPtr->reqWidth\b', 'tkCompat::getReqWidth(winPtr)'),
    (r'\bwinPtr->reqHeight\b', 'tkCompat::getReqHeight(winPtr)'),
    (r'\bwinPtr->atts\b', 'tkCompat::getWindowAtts(winPtr)'),
    (r'\bwinPtr->dirtyAtts\b', 'tkCompat::getDirtyAtts(winPtr)'),
    
    # Grab-Handling
    (r'\bwinPtr->dispPtr->grabWinPtr\b', 'tkCompat::getGrabWindow(winPtr)'),
    (r'\bwinPtr->dispPtr->grabFlags\b', 'tkCompat::getGrabFlags(winPtr)'),
    
    # TkDisplay Zugriffe (mit dispPtr Variable)
    (r'\bdispPtr->buttonWinPtr\b', 'tkCompat::getButtonWinPtr(dispPtr)'),
    (r'\bdispPtr->serverWinPtr\b', 'tkCompat::getServerWinPtr(dispPtr)'),
    (r'\bdispPtr->grabWinPtr\b', 'tkCompat::getGrabWindowFromDisp(dispPtr)'),
    (r'\bdispPtr->grabFlags\b', 'tkCompat::getGrabFlagsFromDisp(dispPtr)'),
]

# Ersetze Assignments (winPtr->field = value) - diese müssen anders behandelt werden
ASSIGNMENT_REPLACEMENTS = [
    # Wir können nicht einfach ersetzen, weil die Syntax anders ist
    # Diese müssen manuell behandelt werden
]

def replace_in_file(filename, dry_run=False):
    """Ersetzt Tk-Internal-Zugriffe in einer Datei."""
    with open(filename, 'r') as f:
        content = f.read()
    
    original_content = content
    replacements_made = 0
    
    # Temporäre Variable für Display cache
    # Wenn wir display = tkCompat::getDisplay(winPtr) einfügen, können wir
    # spätere dispPtr->display Zugriffe ersetzen
    
    for pattern, replacement in REPLACEMENTS:
        # Count matches before replacement
        matches = re.findall(pattern, content)
        count = len(matches)
        
        if count > 0:
            new_content = re.sub(pattern, replacement, content)
            if new_content != content:
                replacements_made += count
                content = new_content
                print(f"  {pattern:40s} -> {replacement:45s} ({count} Treffer)")
    
    if dry_run:
        print(f"\nDry run: {replacements_made} Ersetzungen in {filename}")
        return original_content
    
    if replacements_made > 0:
        with open(filename, 'w') as f:
            f.write(content)
        print(f"\n{replacements_made} Ersetzungen in {filename} durchgeführt.")
    else:
        print(f"Keine Ersetzungen in {filename} nötig.")
    
    return content


def main():
    if len(sys.argv) < 2:
        print("Verwendung: python3 replace_tk_internals.py <datei.cpp> [--dry-run]")
        print("\nBeispiele:")
        print("  python3 replace_tk_internals.py src/tk/tk_fixes.cpp")
        print("  python3 replace_tk_internals.py src/tk/tk_fixes.cpp --dry-run")
        return 1
    
    filename = sys.argv[1]
    dry_run = '--dry-run' in sys.argv
    
    print(f"Verarbeite {filename}...")
    replace_in_file(filename, dry_run=dry_run)
    
    return 0


if __name__ == '__main__':
    sys.exit(main())
