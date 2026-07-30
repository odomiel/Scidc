// ======================================================================
// Author : $Author: gcramer $
// Version: $Revision: 1453 $
// Date   : $Date: 2017-12-11 14:27:52 +0000 (Mon, 11 Dec 2017) $
// Url    : $URL: file:///svn/p/scidb/code/trunk/src/tk/tk_panedwindow.cpp $
// ======================================================================

// ======================================================================
// Adaption by Gregor Cramer, 2017
// ======================================================================

// ======================================================================
// Diese Datei enthielt einen kompletten Fork des Tk-panedwindow-Widgets
// (rund 3200 Zeilen), weil Tk 8.6 ein schwerwiegendes Problem beim
// Groessenaendern hatte. Der Fork war schon immer nur fuer Tk 8.6 aktiv
// (#if TK_MAJOR_VERSION <= 8 && TK_MINOR_VERSION <= 6); ab Tk 8.7 und
// unter Tk 9 verwendet Scidc das panedwindow von Tk selbst.
//
// Mit dem Wegfall der Tk-8.6-Unterstuetzung ist der Fork ersatzlos
// entfallen. Die Init-Funktion bleibt erhalten, weil tk_init.cpp sie
// aufruft.
// ======================================================================

#include "tk_init.h"


void
tk::panedwindow_init(Tcl_Interp *interp)
{
    // Tk stellt das panedwindow-Widget selbst bereit.
}

// vi:set ts=8 sw=4:
