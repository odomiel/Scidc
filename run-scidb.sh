#!/bin/bash
SCIDB_SHAREDIR="$(dirname "$0")/AppDir/usr/share/scidb-beta" \
  "$(dirname "$0")/src/tkscidb-beta" \
  "$(dirname "$0")/tcl/scidb-beta" "$@"
