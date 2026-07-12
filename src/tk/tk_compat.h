// ======================================================================
// Copyright: (C) 2026 Mirik
// ======================================================================
//
// tk_compat.h - Tcl/Tk Kompatibilitäts-Schicht für Tk 8.6 und Tk 9.0
//
// Ziel: Abstrahierung von Tk-internen Strukturzugriffen, die sich zwischen
// Tk 8.6 und Tk 9.0 unterscheiden.
//
// In Tk 9.0 wurde die TkWindow-Struktur komplett überarbeitet, und viele
// direkte Strukturzugriffe (winPtr->field) funktionieren nicht mehr.
//
// Diese Header-Datei stellt Wrapper-Funktionen bereit, die in beiden
// Versionen funktionieren.
//
// Verwendung:
//   #include "tk_compat.h"
//   
//   // Statt: winPtr->parentPtr
//   TkWindow* parent = tkCompat::getParentWinPtr(winPtr);
//
//   // Statt: winPtr->flags & TK_MAPPED
//   bool mapped = tkCompat::isWindowMapped(winPtr);
// ======================================================================

#ifndef _tk_compat_included
#define _tk_compat_included

#include <tk.h>

// Forward-Deklaration für Tk-interne Typen
// In Tk 8.6: typedef struct TkWindow TkWindow;
// In Tk 9.0: andere Struktur
struct TkWindow;

namespace tkCompat {

// ======================================================================
// Window Hierarchie
// ======================================================================

// Gibt den Eltern-Window-Pointer zurück
// In Tk 8.6: winPtr->parentPtr
// In Tk 9.0: Neu implementieren mit öffentlicher API
inline TkWindow* getParentWinPtr(TkWindow* winPtr);

// Gibt das nächste Fenster in der Geschwister-Liste zurück
// In Tk 8.6: winPtr->nextPtr
inline TkWindow* getNextWinPtr(TkWindow* winPtr);

// Gibt das erste Kind-Fenster zurück
// In Tk 8.6: winPtr->childList
inline TkWindow* getChildList(TkWindow* winPtr);

// Gibt das letzte Kind-Fenster zurück
// In Tk 8.6: winPtr->lastChildPtr
inline TkWindow** getLastChildPtrPtr(TkWindow* winPtr);

// ======================================================================
// Window Status
// ======================================================================

// Prüft ob das Fenster sichtbar (gemapped) ist
// In Tk 8.6: winPtr->flags & TK_MAPPED
// In Tk 9.0: Tk_IsMapped(winPtr) (wenn verfügbar) oder andere API
inline bool isWindowMapped(TkWindow* winPtr);

// Prüft ob das Fenster ein Top-Level-Fenster ist
// In Tk 8.6: winPtr->flags & TK_TOP_LEVEL
// In Tk 9.0: Tk_IsTopLevel(winPtr) (wenn verfügbar)
inline bool isWindowTopLevel(TkWindow* winPtr);

// Prüft ob das Fenster Top-Hierarchie hat
// In Tk 8.6: winPtr->flags & TK_TOP_HIERARCHY
inline bool isWindowTopHierarchy(TkWindow* winPtr);

// ======================================================================
// Window Eigenschaften
// ======================================================================

// Gibt das X11 Window (Window ID) zurück
// In Tk 8.6: winPtr->window
// In Tk 9.0: Tk_WindowId(winPtr) (Makro)
inline Window getWindowId(TkWindow* winPtr);

// Gibt den Display-Pointer zurück
// In Tk 8.6: winPtr->display
inline Display* getDisplay(TkWindow* winPtr);

// Gibt die Screen-Nummer zurück
// In Tk 8.6: winPtr->screenNum
inline int getScreenNum(TkWindow* winPtr);

// Gibt den TkDisplay-Pointer zurück
// In Tk 8.6: winPtr->dispPtr
inline struct TkDisplay* getDispPtr(TkWindow* winPtr);

// ======================================================================
// Geometry
// ======================================================================

// Gibt die angeforderte Breite zurück
// In Tk 8.6: winPtr->reqWidth
inline int getReqWidth(TkWindow* winPtr);

// Gibt die angeforderte Höhe zurück
// In Tk 8.6: winPtr->reqHeight
inline int getReqHeight(TkWindow* winPtr);

// Setzt die angeforderte Breite
inline void setReqWidth(TkWindow* winPtr, int width);

// Setzt die angeforderte Höhe
inline void setReqHeight(TkWindow* winPtr, int height);

// ======================================================================
// Attributes
// ======================================================================

// Gibt die Window Attributes zurück
inline XSetWindowAttributes* getWindowAtts(TkWindow* winPtr);

// Gibt die dirtyAtts zurück
inline unsigned int getDirtyAtts(TkWindow* winPtr);

// Setzt dirtyAtts
inline void setDirtyAtts(TkWindow* winPtr, unsigned int mask);

// ======================================================================
// Grab-Handling
// ======================================================================

// Gibt das Grab-Fenster des Displays zurück
// In Tk 8.6: winPtr->dispPtr->grabWinPtr
inline TkWindow* getGrabWindow(TkWindow* winPtr);

// Gibt die Grab-Flags des Displays zurück
// In Tk 8.6: winPtr->dispPtr->grabFlags
inline int getGrabFlags(TkWindow* winPtr);

} // namespace tkCompat

// ======================================================================
// Implementierung - Tk 8.6 spezifisch (Standard)
// ======================================================================

#if !defined(TK_9_0_COMPAT) && !defined(TK_9_0)
// Tk 8.6 Implementation

#include <tkInt.h> // Für TkWindow-Struktur in Tk 8.6

namespace tkCompat {

inline TkWindow* getParentWinPtr(TkWindow* winPtr) {
    return winPtr ? winPtr->parentPtr : nullptr;
}

inline TkWindow* getNextWinPtr(TkWindow* winPtr) {
    return winPtr ? winPtr->nextPtr : nullptr;
}

inline TkWindow* getChildList(TkWindow* winPtr) {
    return winPtr ? winPtr->childList : nullptr;
}

inline TkWindow** getLastChildPtrPtr(TkWindow* winPtr) {
    return winPtr ? &winPtr->lastChildPtr : nullptr;
}

inline bool isWindowMapped(TkWindow* winPtr) {
    return winPtr && (winPtr->flags & TK_MAPPED);
}

inline bool isWindowTopLevel(TkWindow* winPtr) {
    return winPtr && (winPtr->flags & TK_TOP_LEVEL);
}

inline bool isWindowTopHierarchy(TkWindow* winPtr) {
    return winPtr && (winPtr->flags & TK_TOP_HIERARCHY);
}

inline Window getWindowId(TkWindow* winPtr) {
    return winPtr ? winPtr->window : None;
}

inline Display* getDisplay(TkWindow* winPtr) {
    return winPtr ? winPtr->display : nullptr;
}

inline int getScreenNum(TkWindow* winPtr) {
    return winPtr ? winPtr->screenNum : 0;
}

inline struct TkDisplay* getDispPtr(TkWindow* winPtr) {
    return winPtr ? winPtr->dispPtr : nullptr;
}

inline int getReqWidth(TkWindow* winPtr) {
    return winPtr ? winPtr->reqWidth : 0;
}

inline int getReqHeight(TkWindow* winPtr) {
    return winPtr ? winPtr->reqHeight : 0;
}

inline void setReqWidth(TkWindow* winPtr, int width) {
    if (winPtr) winPtr->reqWidth = width;
}

inline void setReqHeight(TkWindow* winPtr, int height) {
    if (winPtr) winPtr->reqHeight = height;
}

inline XSetWindowAttributes* getWindowAtts(TkWindow* winPtr) {
    return winPtr ? &winPtr->atts : nullptr;
}

inline unsigned int getDirtyAtts(TkWindow* winPtr) {
    return winPtr ? winPtr->dirtyAtts : 0;
}

inline void setDirtyAtts(TkWindow* winPtr, unsigned int mask) {
    if (winPtr) winPtr->dirtyAtts = mask;
}

inline TkWindow* getGrabWindow(TkWindow* winPtr) {
    return (winPtr && winPtr->dispPtr) ? winPtr->dispPtr->grabWinPtr : nullptr;
}

inline int getGrabFlags(TkWindow* winPtr) {
    return (winPtr && winPtr->dispPtr) ? winPtr->dispPtr->grabFlags : 0;
}

} // namespace tkCompat

#endif // TK_8_6

// ======================================================================
// Tk 9.0 Implementation (wenn verfügbar)
// ======================================================================

#ifdef TK_9_0_COMPAT

// In Tk 9.0 müssen wir öffentliche APIs verwenden
// Diese Implementation ist ein Platzhalter und muss angepasst werden,
// wenn Tk 9.0 verfügbar ist

namespace tkCompat {

// In Tk 9.0 gibt es keine direkte Strukturzugriffe mehr
// Wir müssen öffentliche APIs verwenden

inline TkWindow* getParentWinPtr(TkWindow* winPtr) {
    // In Tk 9.0: Tk_GetParent(winPtr) oder ähnliche Funktion
    // TODO: Implementieren wenn Tk 9.0 verfügbar ist
    return nullptr;
}

// ... (andere Funktionen ähnlich implementieren)

} // namespace tkCompat

#endif // TK_9_0_COMPAT

#endif // _tk_compat_included
