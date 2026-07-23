// ======================================================================
// Tcl/Tk 9 Compatibility Shims
// ======================================================================
// This header provides compatibility shims for building with Tcl/Tk 9
// while maintaining compatibility with Tcl/Tk 8.6
// ======================================================================

#ifndef SYS_COMPAT_TCL9_H
#define SYS_COMPAT_TCL9_H

// Tcl 9 changed some length parameters from int* to Tcl_Size*
// Tcl_Size is typically ptrdiff_t in Tcl 9, int in earlier versions
#ifndef Tcl_Size
#define Tcl_Size int
#endif

#endif // SYS_COMPAT_TCL9_H
