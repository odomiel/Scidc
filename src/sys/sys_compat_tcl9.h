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
// Note: In Tcl 9, Tcl_Size is already defined as ptrdiff_t in tcl.h, so we don't redefine it
// In Tcl 8.6 and earlier, Tcl_Size is int

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

// Tcl 9 removed some DString functions
// Tcl_DStringTrunc was removed in Tcl 9 - in Tcl 9, DString is a simple struct
// so we can directly set the length
#ifndef Tcl_DStringTrunc
#define Tcl_DStringTrunc(dsPtr, newLen) ((dsPtr)->length = (newLen))
#endif

// Tcl 9 also removed Tcl_DStringResult - we need to handle this
// In Tcl 9, we should use Tcl_Obj for results instead of DString
// But for compatibility, we provide a stub
#ifndef Tcl_DStringResult
#define Tcl_DStringResult(interp, dsPtr) (Tcl_SetObjResult((interp), Tcl_NewStringObj(Tcl_DStringValue(dsPtr), Tcl_DStringLength(dsPtr))), Tcl_DStringFree(dsPtr))
#endif

// Tcl 9 changed Tcl_ObjCmdProc to use Tcl_Size for objc parameter
// but our callback functions now use int objc for compatibility with both Tcl 8.6 and Tcl 9
// So we continue to use Tcl_CreateObjCommand with int objc

// Compatibility for older Tcl/Tk code
#ifndef CONST
#define CONST const
#endif

// Tcl 9 removed Tcl_SaveResult / Tcl_RestoreResult API
// These were used to save and restore the interp result
// In Tcl 9, the result is always an object, so these are no-ops for the result
// but we need to provide compatibility for code that uses them
#if TCL_MAJOR_VERSION > 8
#include <tclPlatDecls.h>
#endif

// For compatibility with code using the old Tcl_SaveResult API
// In Tcl 8.6: Tcl_SaveResult(Tcl_Interp *, Tcl_SavedResult *) - macro
// In Tcl 9: Tcl_SaveInterpState(Tcl_Interp *, int) - returns Tcl_InterpState
// We need to provide macros that work with both
#ifndef Tcl_SavedResult
#define Tcl_SavedResult Tcl_InterpState
#endif
#ifndef Tcl_SaveResult
#define Tcl_SaveResult(interp, statePtr) (*(statePtr) = Tcl_SaveInterpState((interp), 0))
#endif
#ifndef Tcl_RestoreResult
#define Tcl_RestoreResult(interp, statePtr) Tcl_RestoreInterpState((interp), *(statePtr))
#endif

// Tk_Offset was removed in Tk 9 - it was a macro to calculate field offset in structs
// In Tk 8.6: #define Tk_Offset(type, field) ((long) &((type *) NULL)->field)
#ifndef Tk_Offset
#define Tk_Offset(type, field) ((ptrdiff_t) &((type *) NULL)->field)
#endif

#endif // SYS_COMPAT_TCL9_H
