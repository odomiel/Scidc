# Tk-Internals Zugriffe - Analyse für Tk 9.0 Portierung

**Datum:** 13.07.2026  
**Ziel:** Alle direkten Zugriffe auf TkWindow-Struktur identifizieren und durch Kompatibilitäts-Wrapper ersetzen

## 📊 Zusammenfassung

| Datei | winPtr-> Zugriffe | Kritikalität | Status |
|-------|-------------------|--------------|--------|
| tk_base.cpp | 0 | ⭐⭐⭐⭐⭐ | ✅ Abgeschlossen (Phase 1-2) |
| tk_fixes.cpp | 0 | ⭐⭐⭐⭐ | ✅ Abgeschlossen (Phase 1-2) |
| tk_busy.cpp | 0 | ⭐⭐⭐⭐ | ✅ Abgeschlossen (Phase 3.1) |
| tk_multiwindow.cpp | 0 | ⭐⭐⭐ | ✅ Keine direkten TkWindow-> Zugriffe |
| tk_window_manager.cpp | 0 | ⭐⭐⭐ | ✅ Keine direkten TkWindow-> Zugriffe |
| tk_init.cpp | 0 | ⭐⭐⭐ | ✅ Keine direkten TkWindow-> Zugriffe |
| tk_notebook.cpp | 0 | ⭐⭐⭐ | ✅ Keine direkten TkWindow-> Zugriffe |
| tk_panedwindow.cpp | 0 | ⭐⭐⭐ | ✅ Keine direkten TkWindow-> Zugriffe |
| **treectrl/** | ~0 | ⭐⭐⭐ | ✅ Abgeschlossen (Phase 3.3-3.5: alle Dateien mit Makros) |
| **tkdnd/** | ~0 | ⭐⭐⭐ | ✅ Abgeschlossen (Phase 3.5: TkDND_XDND.c mit Makros) |

**Gesamt:** ~0 direkte TkWindow-Strukturzugriffe in allen C/C++-Dateien
**Phase 1-3: ABGESCHLOSSEN für eigene Dateien**
**Phase 3.3-3.5: ALLE BIBLIOTHEKEN ABGESCHLOSSEN (C-Code mit lokalen Makros)**
**Phase 4: TK 9.0 PLATZHALTER-IMPLEMENTIERUNGEN HINZUGEFÜGT**
**Phase 5: TK_COMPAT.H IN ALLE DATEIEN MIT TKINT.H INTEGRIERT (tk_init.cpp, tk_multiwindow.cpp, tk_notebook.cpp, tk_panedwindow.cpp)**
**Phase 6: EINFACHE WRAPPER DURCH ÖFFENTLICHE TK 8.6 MAKROS ERSETZT**
- `tkCompat::getWindowId()` → `Tk_WindowId()`
- `tkCompat::getDisplay()` → `Tk_Display()`
- `tkCompat::getScreenNum()` → `Tk_ScreenNumber()`

---

## 🎯 Priorisierte Ersetzungen

### 1. Einfache Ersetzungen (Makros bereits verfügbar in Tk 8.6)

| Aktuell | Ersatz | Betroffene Dateien |
|---------|--------|-------------------|
| `winPtr->window` | `Tk_WindowId(winPtr)` | Alle |
| `winPtr->flags & TK_MAPPED` | `Tk_IsMapped(winPtr)` | tk_base.cpp, tk_busy.cpp, tk_fixes.cpp |
| `winPtr->flags & TK_TOP_LEVEL` | `Tk_IsTopLevel(winPtr)` | tk_base.cpp, tk_fixes.cpp |
| `winPtr->pathName` | `Tk_PathName(winPtr)` | Alle |
| `winPtr->nameUid` | `Tk_Name(winPtr)` | Alle |

**Status:** Diese Makros sind bereits in Tk 8.6 verfügbar und sollten sofort ersetzt werden.

---

### 2. Mittelschwere Ersetzungen (Wrapper-Funktionen erstellen)

| Aktuell | Ersatz | Notiz |
|---------|--------|------|
| `winPtr->parentPtr` | `tkCompat::getParentWinPtr(winPtr)` | Benötigt Compat-Layer |
| `winPtr->dispPtr` | `tkCompat::getDispPtr(winPtr)` | Benötigt Compat-Layer |
| `winPtr->display` | `tkCompat::getDisplay(winPtr)` | Benötigt Compat-Layer |
| `winPtr->screenNum` | `tkCompat::getScreenNum(winPtr)` | Benötigt Compat-Layer |
| `winPtr->reqWidth/reqHeight` | `tkCompat::getReqWidth/Height(winPtr)` | Benötigt Compat-Layer |
| `winPtr->atts` | `tkCompat::getWindowAtts(winPtr)` | Benötigt Compat-Layer |
| `winPtr->dirtyAtts` | `tkCompat::getDirtyAtts(winPtr)` | Benötigt Compat-Layer |

**Status:** tk_compat.h erstellt. Funktionen müssen noch in allen Dateien verwendet werden.

---

### 3. Komplexe Ersetzungen (Linked-List-Manipulation)

| Aktuell | Ersatz | Notiz |
|---------|--------|------|
| `winPtr->nextPtr` | `tkCompat::getNextWinPtr(winPtr)` | Interne Linked-List |
| `winPtr->childList` | `tkCompat::getChildList(winPtr)` | Interne Linked-List |
| `winPtr->lastChildPtr` | `tkCompat::getLastChildPtrPtr(winPtr)` | Pointer auf Pointer |

**Problem:** Diese Zugriffe manipulieren die **interne Window-Hierarchie** von Tk. In Tk 9.0 gibt es dafür möglicherweise **keine öffentliche API**!

**Lösung:** 
- Die Funktionen `unlinkWindow`, `linkWindow`, `relink` in tk_base.cpp müssen **komplett neu implementiert** werden
- Oder: Diese Funktionen **vermeiden** und durch Tk-APIs ersetzen

---

### 4. Grab-Handling

| Aktuell | Ersatz | Notiz |
|---------|--------|------|
| `winPtr->dispPtr->grabWinPtr` | `tkCompat::getGrabWindow(winPtr)` | Grabbing |
| `winPtr->dispPtr->grabFlags` | `tkCompat::getGrabFlags(winPtr)` | Grabbing |

**Status:** Benötigt Compat-Layer

---

## 📁 Datei-spezifische Analyse

### tk_base.cpp (329 Zeilen)

**Direkte Zugriffe:**
```cpp
// Zeile 41-42: winPtr->window (in Asserts)
M_ASSERT(childPtr->window);
M_ASSERT(!newParentPtr || newParentPtr->window);

// Zeile 48: winPtr->window (Windows)
HWND handle = newParentPtr ? TkWinGetHWND(newParentPtr->window) : None;
SetParent(TkWinGetHWND(winPtr->window), hwnd);

// Zeile 57-58: winPtr->display, winPtr->screenNum (Unix)
Window parent = newParentPtr ?
    newParentPtr->window : XRootWindow(childPtr->display, childPtr->screenNum);
XReparentWindow(childPtr->display, childPtr->window, parent, 0, 0);

// Zeile 69-88: winPtr->parentPtr, winPtr->nextPtr, winPtr->childList, winPtr->lastChildPtr
// (Funktionen unlinkWindow, linkWindow)

// Zeile 97-116: winPtr->parentPtr, winPtr->nextPtr, winPtr->childList, winPtr->lastChildPtr
// (Funktion linkWindow)

// Zeile 127: winPtr->parentPtr
childPtr->parentPtr = newParentPtr;

// Zeile 136: winPtr->flags & TK_ALREADY_DEAD
return exists(obj) && bool(reinterpret_cast<TkWindow*>(window(obj))->flags & TK_ALREADY_DEAD);

// Zeile 206: parentPtr->window
if (!isToplevel(child) && parentPtr->window == None)

// Zeile 207: childPtr->window
unmap(child);

// Zeile 211: childPtr->window, parentPtr->window
if (!isToplevel(child) && childPtr->window != None && parentPtr->window != None)

// Zeile 232: winPtr->window
if (winPtr->window == None)

// Zeile 236: winPtr->dirtyAtts
winPtr->dirtyAtts |= CWBorderPixel;

// Zeile 240: winPtr->flags & TK_MAPPED
if (winPtr->flags & TK_MAPPED)

// Zeile 246: winPtr->flags
winPtr->flags |= TK_TOP_HIERARCHY | TK_TOP_LEVEL | TK_HAS_WRAPPER | TK_WIN_MANAGED;

// Zeile 252-253: winPtr->reqWidth, winPtr->reqHeight
winPtr->reqWidth++;
winPtr->reqHeight++;

// Zeile 254: winPtr->reqWidth, winPtr->reqHeight
Tk_GeometryRequest(window, winPtr->reqWidth - 1, winPtr->reqHeight - 1);

// Zeile 268: winPtr->parentPtr
if (!winPtr->parentPtr)

// Zeile 271: winPtr->flags & TK_TOP_LEVEL
if (!(winPtr->flags & TK_TOP_LEVEL))

// Zeile 277-278: winPtr->parentPtr
if (tkparent && tkparent != reinterpret_cast<Tk_Window>(winPtr->parentPtr))
    ::relink(winPtr, reinterpret_cast<TkWindow*>(tkparent));

// Zeile 280: winPtr->window
if (winPtr->window == None)

// Zeile 283-284: winPtr->atts, winPtr->flags
winPtr->atts.event_mask &= ~StructureNotifyMask;
winPtr->flags &= ~TK_TOP_LEVEL;

// Zeile 294-295: winPtr->parentPtr
makeExists(reinterpret_cast<Tk_Window>(winPtr->parentPtr));
::reparent(winPtr, winPtr->parentPtr);

// Zeile 306-308: winPtr->display, winPtr->window, winPtr->parentPtr
XUnmapWindow(winPtr->display, winPtr->window);
makeExists(reinterpret_cast<Tk_Window>(winPtr->parentPtr));
::reparent(winPtr, winPtr->parentPtr);

// Zeile 313: winPtr->flags, winPtr->atts
winPtr->flags &= ~(TK_TOP_HIERARCHY | TK_TOP_LEVEL | TK_HAS_WRAPPER | TK_WIN_MANAGED);
atts.event_mask = winPtr->atts.event_mask;
```

---

### tk_fixes.cpp

**Wichtige Zugriffe:**
```cpp
// Zeile 181, 183: winPtr->window
if ((winPtr == NULL) || (winPtr->window == None)) {

// Zeile 188-193: winPtr->display, winPtr->screenNum, winPtr->dispPtr
.event.xcrossing.serial = LastKnownRequestProcessed(winPtr->display);
.event.xcrossing.display = winPtr->display;
.event.xcrossing.root = RootWindow(winPtr->display, winPtr->screenNum);
.event.xcrossing.time = TkCurrentTime(winPtr->dispPtr);
XQueryPointer(winPtr->display, winPtr->window, &dummy1, &dummy2,

// Zeile 235: winPtr->dispPtr
TkDisplay *dispPtr = winPtr->dispPtr;

// Zeile 272: winPtr->flags & TK_TOP_HIERARCHY
if ((winPtr->flags & TK_TOP_HIERARCHY)) {

// Zeile 407: dispPtr->display, winPtr->window
if (XGrabKeyboard(dispPtr->display, winPtr->window,

// Zeile 463: winPtr->flags & TK_TOP_HIERARCHY
if (winPtr->flags & TK_TOP_HIERARCHY) {

// Zeile 466: winPtr->parentPtr
winPtr = winPtr->parentPtr;

// Zeile 505: winPtr->dispPtr->grabWinPtr
TkWindow *grabWinPtr = winPtr->dispPtr->grabWinPtr;

// Zeile 510: winPtr->dispPtr->grabFlags
if (!(winPtr->dispPtr->grabFlags & GRAB_GLOBAL) &&
```

---

## 🎯 Nächste Schritte

### 1. Sofort umsetzbar (einfache Makro-Ersetzungen)
- [ ] `winPtr->window` → `Tk_WindowId(winPtr)` in allen Dateien
- [ ] `winPtr->flags & TK_MAPPED` → `Tk_IsMapped(winPtr)` in allen Dateien
- [ ] `winPtr->flags & TK_TOP_LEVEL` → `Tk_IsTopLevel(winPtr)` in allen Dateien
- [ ] `winPtr->pathName` → `Tk_PathName(winPtr)` in allen Dateien

### 2. Mittelfristig (Wrapper-Funktionen)
- [ ] `tk_compat.h` in alle betroffenen Dateien inkludieren
- [ ] Einfache Zugriffe durch Wrapper ersetzen

### 3. Langfristig (Neuimplementierung)
- [ ] `unlinkWindow`, `linkWindow`, `relink` für Tk 9.0 neu implementieren
- [ ] Grab-Handling für Tk 9.0 anpassen

---

## 📝 Notizen

1. **tkInt.h** wird in vielen Dateien inkludiert - das ist der Hauptindikator für direkte Strukturzugriffe
2. **Tk 9.0** hat eine komplett überarbeitete Window-Struktur - direkte Zugriffe werden dort nicht funktionieren
3. **Makros** wie `Tk_IsMapped`, `Tk_WindowId` sind bereits in Tk 8.6 verfügbar und sollten sofort verwendet werden
4. **Wrapper-Funktionen** in `tk_compat.h` ermöglichen schrittweise Migration

---

**Erstellt von:** Mistral Vibe  
**Generiert am:** 2026-07-12
