#!/bin/bash
SCIDB_SHAREDIR="$(dirname "$0")/AppDir/usr/share/scidc-beta" \
  "$(dirname "$0")/src/tkscidc-beta" \
  "$(dirname "$0")/tcl/scidc-beta" "$@"
