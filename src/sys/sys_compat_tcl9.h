// ======================================================================
// Tcl/Tk 9 Compatibility Shims
// ======================================================================
// This header provides compatibility shims for building with Tcl/Tk 9
// while maintaining compatibility with Tcl/Tk 8.6
// ======================================================================

#ifndef SYS_COMPAT_TCL9_H
#define SYS_COMPAT_TCL9_H

#include <tcl.h>

// Tcl 9 changed some length parameters from int* to Tcl_Size*
// Tcl_Size is typically ptrdiff_t in Tcl 9, int in earlier versions
#ifndef Tcl_Size
#define Tcl_Size int
#endif

// Tcl 9: Tcl_GetString returns const char* (was char* in Tcl 8.6)
// This macro helps with const-correctness for variables that were previously char*
#define TCL_GET_STRINGconst(obj) Tcl_GetString(obj)

#endif // SYS_COMPAT_TCL9_H
