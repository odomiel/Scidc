// ======================================================================
// Author : $Author$
// Version: $Revision: 1453 $
// Date   : $Date: 2017-12-11 14:27:52 +0000 (Mon, 11 Dec 2017) $
// Url    : $URL$
// ======================================================================

// ======================================================================
// Copyright: (C) 2009-2013 Gregor Cramer
// ======================================================================

// ======================================================================
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
// ======================================================================

#ifndef _mstl_auto_ptr_included
#define _mstl_auto_ptr_included

#include <memory>

namespace mstl {

template <typename T>
using auto_ptr = std::unique_ptr<T>;

template <typename T> void swap(auto_ptr<T>& lhs, auto_ptr<T>& rhs) { lhs.swap(rhs); }

} // namespace mstl

#endif // _mstl_auto_ptr_included

// vi:set ts=3 sw=3:
