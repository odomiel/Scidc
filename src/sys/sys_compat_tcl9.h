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

// Helper for converting size_t to Tcl_Size for string lengths
// In Tcl 8.6: Tcl_Size is int, so this is a safe conversion for normal string lengths
// In Tcl 9: Tcl_Size is ptrdiff_t, and we need to ensure the value fits
// Note: String lengths should never exceed PTRDIFF_MAX in practice
static inline Tcl_Size
Tcl_SizeFromSizeT(size_t size)
{
	// In Tcl 9, Tcl_Size is ptrdiff_t (signed), size_t is unsigned
	// We assume size <= PTRDIFF_MAX for all valid strings
	return static_cast<Tcl_Size>(size);
}

#endif // SYS_COMPAT_TCL9_H
