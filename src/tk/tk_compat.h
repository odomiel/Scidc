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

// Setzt den Eltern-Window-Pointer
// In Tk 8.6: winPtr->parentPtr = parent
inline void setParentWinPtr(TkWindow* winPtr, TkWindow* parent);

// Gibt das nächste Fenster in der Geschwister-Liste zurück
// In Tk 8.6: winPtr->nextPtr
inline TkWindow* getNextWinPtr(TkWindow* winPtr);

// Gibt das erste Kind-Fenster zurück
// In Tk 8.6: winPtr->childList
inline TkWindow* getChildList(TkWindow* winPtr);

// Gibt das letzte Kind-Fenster zurück
// In Tk 8.6: winPtr->lastChildPtr
inline TkWindow** getLastChildPtrPtr(TkWindow* winPtr);

// Setzt das nächste Fenster in der Geschwister-Liste
// In Tk 8.6: winPtr->nextPtr = next
inline void setNextWinPtr(TkWindow* winPtr, TkWindow* next);

// Setzt das erste Kind-Fenster
// In Tk 8.6: winPtr->childList = child
inline void setChildList(TkWindow* winPtr, TkWindow* child);

// Setzt das letzte Kind-Fenster
// In Tk 8.6: winPtr->lastChildPtr = lastChild
inline void setLastChildPtr(TkWindow* winPtr, TkWindow* lastChild);

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

// Prüft ob das Fenster reparented ist
// In Tk 8.6: winPtr->flags & TK_REPARENTED
inline bool isWindowReparented(TkWindow* winPtr);

// Prüft ob das Fenster Konfigurationsbenachrichtigung benötigt
// In Tk 8.6: winPtr->flags & TK_NEED_CONFIG_NOTIFY
inline bool needsConfigNotify(TkWindow* winPtr);

// Prüft ob das Fenster bereits zerstört ist
// In Tk 8.6: winPtr->flags & TK_ALREADY_DEAD
inline bool isWindowAlreadyDead(TkWindow* winPtr);

// Setzt Fenster-Flags (Bitwise OR)
// In Tk 8.6: winPtr->flags |= flags
inline void setWindowFlags(TkWindow* winPtr, int flags);

// Entfernt Fenster-Flags (Bitwise AND NOT)
// In Tk 8.6: winPtr->flags &= ~flags
inline void clearWindowFlags(TkWindow* winPtr, int flags);

// Setzt dirtyChanges
// In Tk 8.6: winPtr->dirtyChanges = value
inline void setDirtyChanges(TkWindow* winPtr, unsigned int value);

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

// Gibt den X Display-Pointer von einem TkDisplay zurück
// In Tk 8.6: dispPtr->display
inline Display* getDisplayFromDisp(struct TkDisplay* dispPtr);

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

// ======================================================================
// Grab-Handling via TkDisplay
// ======================================================================

// Gibt das Grab-Fenster direkt aus TkDisplay zurück
// In Tk 8.6: dispPtr->grabWinPtr
inline TkWindow* getGrabWindowFromDisp(struct TkDisplay* dispPtr);

// Gibt die Grab-Flags direkt aus TkDisplay zurück
// In Tk 8.6: dispPtr->grabFlags
inline int getGrabFlagsFromDisp(struct TkDisplay* dispPtr);

// ======================================================================
// TkDisplay Zugriffe (für Grab- und Button-Handling)
// ======================================================================

// Gibt das buttonWinPtr des Displays zurück
// In Tk 8.6: dispPtr->buttonWinPtr
inline TkWindow* getButtonWinPtr(struct TkDisplay* dispPtr);
inline TkWindow*& getButtonWinPtrRef(struct TkDisplay* dispPtr);

// Gibt das serverWinPtr des Displays zurück
// In Tk 8.6: dispPtr->serverWinPtr
inline TkWindow* getServerWinPtr(struct TkDisplay* dispPtr);
inline TkWindow*& getServerWinPtrRef(struct TkDisplay* dispPtr);

// Setzt das buttonWinPtr des Displays
inline void setButtonWinPtr(struct TkDisplay* dispPtr, TkWindow* winPtr);

// Setzt das serverWinPtr des Displays
inline void setServerWinPtr(struct TkDisplay* dispPtr, TkWindow* winPtr);

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

inline void setParentWinPtr(TkWindow* winPtr, TkWindow* parent) {
    if (winPtr) winPtr->parentPtr = parent;
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

inline bool isWindowReparented(TkWindow* winPtr) {
    return winPtr && (winPtr->flags & TK_REPARENTED);
}

inline bool needsConfigNotify(TkWindow* winPtr) {
    return winPtr && (winPtr->flags & TK_NEED_CONFIG_NOTIFY);
}

inline bool isWindowAlreadyDead(TkWindow* winPtr) {
    return winPtr && (winPtr->flags & TK_ALREADY_DEAD);
}

inline void setWindowFlags(TkWindow* winPtr, int flags) {
    if (winPtr) winPtr->flags |= flags;
}

inline void clearWindowFlags(TkWindow* winPtr, int flags) {
    if (winPtr) winPtr->flags &= ~flags;
}

inline void setDirtyChanges(TkWindow* winPtr, unsigned int value) {
    if (winPtr) winPtr->dirtyChanges = value;
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

inline Display* getDisplayFromDisp(struct TkDisplay* dispPtr) {
    return dispPtr ? dispPtr->display : nullptr;
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

// Setter für Linked-List-Manipulation
inline void setNextWinPtr(TkWindow* winPtr, TkWindow* next) {
    if (winPtr) winPtr->nextPtr = next;
}

inline void setChildList(TkWindow* winPtr, TkWindow* child) {
    if (winPtr) winPtr->childList = child;
}

inline void setLastChildPtr(TkWindow* winPtr, TkWindow* lastChild) {
    if (winPtr) winPtr->lastChildPtr = lastChild;
}

inline TkWindow* getGrabWindow(TkWindow* winPtr) {
    return (winPtr && winPtr->dispPtr) ? winPtr->dispPtr->grabWinPtr : nullptr;
}

inline int getGrabFlags(TkWindow* winPtr) {
    return (winPtr && winPtr->dispPtr) ? winPtr->dispPtr->grabFlags : 0;
}

// TkDisplay Zugriffe
inline TkWindow* getButtonWinPtr(struct TkDisplay* dispPtr) {
    return dispPtr ? dispPtr->buttonWinPtr : nullptr;
}

inline TkWindow* getServerWinPtr(struct TkDisplay* dispPtr) {
    return dispPtr ? dispPtr->serverWinPtr : nullptr;
}

inline void setButtonWinPtr(struct TkDisplay* dispPtr, TkWindow* winPtr) {
    if (dispPtr) dispPtr->buttonWinPtr = winPtr;
}

inline void setServerWinPtr(struct TkDisplay* dispPtr, TkWindow* winPtr) {
    if (dispPtr) dispPtr->serverWinPtr = winPtr;
}

// Reference-Varianten für direkte Zuweisungen
inline TkWindow*& getButtonWinPtrRef(struct TkDisplay* dispPtr) {
    static TkWindow* dummy = nullptr;
    return dispPtr ? dispPtr->buttonWinPtr : dummy;
}

inline TkWindow*& getServerWinPtrRef(struct TkDisplay* dispPtr) {
    static TkWindow* dummy = nullptr;
    return dispPtr ? dispPtr->serverWinPtr : dummy;
}

// Grab-Handling via TkDisplay
inline TkWindow* getGrabWindowFromDisp(struct TkDisplay* dispPtr) {
    return dispPtr ? dispPtr->grabWinPtr : nullptr;
}

inline int getGrabFlagsFromDisp(struct TkDisplay* dispPtr) {
    return dispPtr ? dispPtr->grabFlags : 0;
}

// Reference-Varianten für Grab
inline TkWindow*& getGrabWinPtrRef(struct TkDisplay* dispPtr) {
    static TkWindow* dummy = nullptr;
    return dispPtr ? dispPtr->grabWinPtr : dummy;
}

inline int& getGrabFlagsRef(struct TkDisplay* dispPtr) {
    static int dummy = 0;
    return dispPtr ? dispPtr->grabFlags : dummy;
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
