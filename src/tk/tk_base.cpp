// ======================================================================
// Author : $Author: gcramer $
// Version: $Revision: 1295 $
// Date   : $Date: 2017-07-24 19:35:37 +0000 (Mon, 24 Jul 2017) $
// Url    : $URL: file:///svn/p/scidb/code/trunk/src/tk/tk_base.cpp $
// ======================================================================

// ======================================================================
//    _/|            __
//   // o\         /    )           ,        /    /
//   || ._)    ----\---------__----------__-/----/__-
//   //__\          \      /   '  /    /   /    /   )
//   )___(     _(____/____(___ __/____(___/____(___/_
// ======================================================================

// ======================================================================
// Copyright: (C) 2010-2017 Gregor Cramer
// ======================================================================

// ======================================================================
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
// ======================================================================

#include "tk_base.h"

#include "tcl_exception.h"

#include <tkInt.h>
#include "tk_compat.h"


extern "C" { void TkpWmSetState(TkWindow* winPtr, int state); }


static void
reparent(TkWindow* childPtr, TkWindow* newParentPtr = nullptr)
{
	M_ASSERT(childPtr);
	M_ASSERT(Tk_WindowId(childPtr) != None);
	M_ASSERT(!newParentPtr || Tk_WindowId(newParentPtr) != None);

#if defined(__WIN32__) || defined(__WIN64__)

	// Reparent to nullptr so UpdateWrapper won't delete our original parent window
	HWND handle = newParentPtr ? TkWinGetHWND(Tk_WindowId(newParentPtr)) : None;
	SetParent(TkWinGetHWND(Tk_WindowId(childPtr)), hwnd);

#elif defined(__MacOSX__)

# error "not yet implemented"

#else // if defined(__unix__)

	Window parent = newParentPtr ?
		Tk_WindowId(newParentPtr) : XRootWindow(tkCompat::getDisplay(childPtr), tkCompat::getScreenNum(childPtr));
	XReparentWindow(tkCompat::getDisplay(childPtr), Tk_WindowId(childPtr), parent, 0, 0);

#endif
}


static void
unlinkWindow(TkWindow* winPtr)
{
	M_ASSERT(winPtr);

	TkWindow* parent = tkCompat::getParentWinPtr(winPtr);
	if (!parent)
		return;

	TkWindow* prevPtr = tkCompat::getChildList(parent);

	if (prevPtr == winPtr)
	{
		TkWindow* next = tkCompat::getNextWinPtr(winPtr);
		tkCompat::setChildList(parent, next);
		if (!next)
			tkCompat::setLastChildPtr(parent, nullptr);
	}
	else
	{
		for ( ; tkCompat::getNextWinPtr(prevPtr) != winPtr; prevPtr = tkCompat::getNextWinPtr(prevPtr))
			M_ASSERT(prevPtr);

		TkWindow* nextNext = tkCompat::getNextWinPtr(tkCompat::getNextWinPtr(prevPtr));
		tkCompat::setNextWinPtr(prevPtr, nextNext);
		if (!nextNext)
			tkCompat::setLastChildPtr(parent, prevPtr);
	}

	tkCompat::setNextWinPtr(winPtr, nullptr);
}


static void
linkWindow(TkWindow* winPtr)
{
	M_ASSERT(winPtr);

	TkWindow* parent = tkCompat::getParentWinPtr(winPtr);
	if (!parent)
		return;

	if (TkWindow* prevPtr = tkCompat::getChildList(parent))
	{
		while (tkCompat::getNextWinPtr(prevPtr))
			prevPtr = tkCompat::getNextWinPtr(prevPtr);

		tkCompat::setNextWinPtr(prevPtr, winPtr);
	}
	else
	{
		tkCompat::setChildList(parent, winPtr);
	}

	tkCompat::setNextWinPtr(winPtr, nullptr);
	tkCompat::setLastChildPtr(parent, winPtr);
}


static void
relink(TkWindow* childPtr, TkWindow* newParentPtr)
{
	M_ASSERT(childPtr);
	M_ASSERT(newParentPtr);
	M_ASSERT(tkCompat::getParentWinPtr(childPtr) != newParentPtr);

	unlinkWindow(childPtr);
	tkCompat::setParentWinPtr(childPtr, newParentPtr);
	linkWindow(childPtr);
}


bool
tk::isAlreadyDead(Tcl_Obj* obj)
{
	M_ASSERT(obj);
	TkWindow* winPtr = reinterpret_cast<TkWindow*>(window(obj));
	return exists(obj) && tkCompat::isWindowAlreadyDead(winPtr);
}


Tk_Window
tk::mainWindow()
{
	Tk_Window w = Tk_MainWindow(::tcl::interp());

	if (!w)
		M_THROW(tcl::Exception("no main window exists"));
	
	return w;
}


Tk_Window
tk::window(char const* path)
{
	M_REQUIRE(path);

	Tk_Window w = Tk_NameToWindow(::tcl::interp(), path, mainWindow());

	if (!w)
		M_THROW(tcl::Exception("invalid window '%s'", path));
	
	return w;
}


Tk_Window
tk::toplevel(Tk_Window window)
{
	M_ASSERT(window);

	while (!isToplevel(window))
		window = parent(window);

	return window;
}


void
tk::raise(Tk_Window window, Tk_Window aboveThis)
{
	M_REQUIRE(window);
	M_REQUIRE(aboveThis);

	if (Tk_RestackWindow(window, Above, aboveThis) != TCL_OK)
	{
		M_THROW(tcl::Exception(
			"can't raise \"%s\" above \"%s\"",
			Tk_PathName(window),
			Tk_PathName(aboveThis)));
	}
}


void
tk::reparent(Tk_Window child, Tk_Window newParent)
{
	M_REQUIRE(child);
	M_REQUIRE(newParent);

	if (parent(child) == newParent)
		return;

	TkWindow* childPtr	= reinterpret_cast<TkWindow*>(child);
	TkWindow* parentPtr	= reinterpret_cast<TkWindow*>(newParent);

	if (!isToplevel(child) && Tk_WindowId(parentPtr) == None)
		unmap(child);
	
	::relink(childPtr, parentPtr);

	if (!isToplevel(child) && Tk_WindowId(childPtr) != None && Tk_WindowId(parentPtr) != None)
		::reparent(childPtr, parentPtr);
}


bool
tk::release(Tk_Window window)
{
	M_REQUIRE(window);

	if (isToplevel(window))
		return false;

	// detach the window from its gemoetry manager, if any
	unmanage(window);

	TkWindow* winPtr = reinterpret_cast<TkWindow*>(window);

	// TkFocusSplit(winPtr); // has hidden scope
	// We hope that this toplevel don't has a focus record.

	if (Tk_WindowId(winPtr) == None)
	{
		// The window is not created yet, we still have time
		// to make it an legitimate toplevel window.
		tkCompat::setDirtyAtts(winPtr, tkCompat::getDirtyAtts(winPtr) | CWBorderPixel);
	}
	else
	{
		if (Tk_IsMapped(winPtr))
			unmap(window);

		::reparent(winPtr);
	}

	// Set window flags
	tkCompat::setWindowFlags(winPtr, TK_TOP_HIERARCHY | TK_TOP_LEVEL | TK_HAS_WRAPPER | TK_WIN_MANAGED);

	TkWmNewWindow(winPtr);
	TkpWmSetState(winPtr, WithdrawnState);

	// Size was set - force a call to Geometry Manager
	tkCompat::setReqWidth(winPtr, tkCompat::getReqWidth(winPtr) + 1);
	tkCompat::setReqHeight(winPtr, tkCompat::getReqHeight(winPtr) + 1);
	Tk_GeometryRequest(window, tkCompat::getReqWidth(winPtr) - 1, tkCompat::getReqHeight(winPtr) - 1);
	//Tk_GeometryRequest(mainWindow(), tkCompat::getReqWidth(winPtr) - 1, tkCompat::getReqHeight(winPtr) - 1);

	TkWmMapWindow(winPtr);

	return true;
}


bool
tk::capture(Tk_Window tkwin, Tk_Window tkparent)
{
	TkWindow* winPtr = reinterpret_cast<TkWindow*>(tkwin);

	if (!tkCompat::getParentWinPtr(winPtr))
		return false;

	if (!Tk_IsTopLevel(winPtr))
		return true; // window is already captured

	// withdraw the window
	TkpWmSetState(winPtr, WithdrawnState);

	if (tkparent && tkparent != reinterpret_cast<Tk_Window>(tkCompat::getParentWinPtr(winPtr)))
		::relink(winPtr, reinterpret_cast<TkWindow*>(tkparent));

	if (Tk_WindowId(winPtr) == None)
	{
		// cause this and parent window to exist
		XSetWindowAttributes atts = *tkCompat::getWindowAtts(winPtr);
		atts.event_mask &= ~StructureNotifyMask;
		// Clear window flag
		tkCompat::clearWindowFlags(winPtr, TK_TOP_LEVEL);
	}
	else
	{
		XSetWindowAttributes atts;

#ifdef __WIN32__

		// SetParent must be done before TkWmDeadWindow or it's DestroyWindow on the
		// parent Hwnd will also destroy the child
		makeExists(reinterpret_cast<Tk_Window>(tkCompat::getParentWinPtr(winPtr)));
		::reparent(winPtr, tkCompat::getParentWinPtr(winPtr));
		// Dis-associate from wm
		TkWmDeadWindow(winPtr);

#elif defined(__MacOSX__)

# error "not yet implemented"

#else // if defined(__unix__)

		TkWmDeadWindow(winPtr);
		XUnmapWindow(tkCompat::getDisplay(winPtr), Tk_WindowId(winPtr));
		makeExists(reinterpret_cast<Tk_Window>(tkCompat::getParentWinPtr(winPtr)));
		::reparent(winPtr, tkCompat::getParentWinPtr(winPtr));

#endif

		// clear those attributes that non-toplevel windows don't possess
		tkCompat::clearWindowFlags(winPtr, TK_TOP_HIERARCHY | TK_TOP_LEVEL | TK_HAS_WRAPPER | TK_WIN_MANAGED);
		atts.event_mask = tkCompat::getWindowAtts(winPtr)->event_mask;
		atts.event_mask &= ~StructureNotifyMask;
		Tk_ChangeWindowAttributes(tkwin, CWEventMask, &atts);
	}

	unmanage(tkwin);

	// Can't delete the TopLevelEventProc, because this definition only exists
	// in tkWinWm.c or tkUnixWm.c. Is having this event handler around really cause
	// a problem?
//	Tk_DeleteEventHandler(tkwin, StructureNotifyMask, TopLevelEventProc, winPtr);

	return true;
}

// vi:set ts=3 sw=3:
