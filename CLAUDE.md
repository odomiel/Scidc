# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Scidb is a chess database application (~102k LOC C++, ~92k LOC Tcl/Tk). It supports multiple database formats (native SCI, Scid SI3/SI4/SI5, ChessBase CBH/CBF read-only) and uses a three-tier architecture: C++ database layer → C++ application layer → Tcl/Tk UI.

## Build

**The user builds manually. Never issue `make` or build commands unless explicitly asked.**

### Dependencies
Tcl/Tk 8.5+, Freetype dev, libSM, Xcursor, fontconfig, libgdbm

### Commands
```bash
./configure          # detect Tcl/Tk and system libraries
make -j$(nproc)      # build everything (user runs this manually)
make clean           # remove build artifacts
make depend          # regenerate dependencies
```

Key configure options: `--tcl-includes`, `--tk-includes`, `--tcl-libraries`, `--tk-libraries`, `--prefix`

### Build outputs
- `src/tkscidb-beta` – main GUI binary (links Tk)
- `src/tclscidb-beta` – CLI binary
- `src/cbh2si4`, `src/cdb2sci` – format converter tools
- `src/db/libdb.a`, `src/app/libapp.a`, `src/util/libutil.a`, `src/sys/libsys.a` – static libraries
- `tcl/scidb-beta` – compiled Tcl script (assembled from individual `tcl/*.tcl` sources by `make`)

### Parallel build caveat
`make -j$(nproc)` may hit a race condition. If it fails with "no rule to make target app/libapp.a", run plain `make` (sequential) afterwards.

## Running the program

Do **not** run `src/tkscidb-beta` directly — it needs a script and resource path:

```bash
./run-scidb.sh
```

This script sets `SCIDB_SHAREDIR` to `AppDir/usr/share/scidb-beta` (contains ECO data, images, themes, etc.) and passes `tcl/scidb-beta` as the UI script. Equivalent manual invocation:

```bash
SCIDB_SHAREDIR=AppDir/usr/share/scidb-beta src/tkscidb-beta tcl/scidb-beta
```

## Architecture

### Three-tier structure

```
tcl/          Tcl/Tk UI source files (individual *.tcl, compiled to tcl/scidb-beta by make)
   ↓  Tcl commands (::scidb::*)
src/tcl/      C++ ↔ Tcl binding layer
src/app/      Application layer (Application, Cursor, View, Engine)
src/db/       Database layer (codecs, board, game data)
```

### Tcl UI — important detail

The UI is **not** one file. The `tcl/` directory contains many individual `.tcl` source files. The `tcl/Makefile` concatenates them (in a specific order defined by `SOURCES`) into the single script `tcl/scidb-beta`. **Always edit the individual `tcl/*.tcl` source files, never `tcl/scidb-beta` directly.** After editing, `make` regenerates `tcl/scidb-beta`.

### C++ → Tcl communication

Entry point: `src/tkscidb.cpp` → `tcl::init()` registers all `::scidb::*` Tcl commands. The binding layer lives in `src/tcl/` with one file per domain (`tcl_application.cpp`, `tcl_database.cpp`, `tcl_board.cpp`, `tcl_game.cpp`, etc.). The Tcl interpreter is stored globally in `tcl::bits::interp`.

### Database codec architecture

Abstract base: `src/db/db_database_codec.h` (`DatabaseCodec`)

| Codec | Files | Formats | Writable |
|-------|-------|---------|----------|
| `si3::Codec` | `src/db/si3/` | SI3 (v300), SI4 (v400), SI5 (v500) | yes |
| `sci::Codec` | `src/db/sci/` | SCI (native, v91–v93) | yes |
| `cbh::Codec` | `src/db/cbh/` | ChessBase CB9+ | read-only |
| `cbf::Codec` | `src/db/cbf/` | ChessBase DOS | read-only |

`DatabaseCodec::makeCodec(filename, mode)` in `src/db/db_database_codec.cpp` is the factory.

The `si3::Codec` handles all three Scid formats via a single `m_isVersion5` flag and format-specific branches. SI5 differences: no magic bytes, no index file header, 56-byte index entries (vs 46/47), varint-encoded namebase (`.sn5`).

### SI5 write support (added post-r1531)

SI5 was originally read-only. The following changes enable writing:

- `tcl/app-database.tcl` `openBase`: SI5 is excluded from forced `readonly=1` and always forced to `readonly=0` (because RecentFiles may have stale `readonly=1` from pre-write-support sessions)
- `src/db/si3/si3_codec.cpp` `updateIndex()`: skips header write for SI5 (line ~941: `if (m_isVersion5) return;`)
- `src/db/db_common.ipp`: `format::isScidFormat()` includes `Scid5` (needed for `saveGame` and round-entry logic)
- `src/db/db_common.ipp`: `format::isWritable()` includes `Scid5`
- `src/db/db_database.cpp`: constructor `M_REQUIRE` permits SI5 in read-write mode
- `tcl/end.tcl`: `keybar::tr` handles empty-string keys (`<= 1` instead of `== 1`) — the save dialog passes `{}` as a result key

### Key files

| File | Purpose |
|------|---------|
| `src/db/db_database_codec.h/.cpp` | Codec base class, factory, `saveGame` |
| `src/db/db_database.h/.cpp` | Database container, open/save/update logic |
| `src/db/si3/si3_codec.cpp` | SI3/SI4/SI5 codec (2848 lines) |
| `src/db/db_common.h/.ipp` | Format enums, `isScidFormat()`, `isWritable()` |
| `src/app/app_application.h/.cpp` | Top-level application class |
| `src/app/app_multi_cursor.cpp` | Multi-variant cursor, variant mapping |
| `src/tcl/tcl_application.cpp` | Tcl command registration |
| `tcl/app-database.tcl` | Database open/close/save UI logic, `openBase` proc |
| `tcl/app-board.tcl` | Board UI, game save/replace button state logic |
| `tcl/start.tcl` | Startup, `SCIDB_SHAREDIR` resolution, directory setup |
| `tcl/end.tcl` | Late-init procs (`keybar::tr`, etc.) |
| `tcl/load.tcl` | ECO/data file loading at startup |

### Save button state logic (app-board.tcl)

The "save new game" and "replace game" buttons are enabled by `UpdateSaveState`:
- **replace**: enabled when `actual` (source DB) is open, not readonly, and variant matches
- **save new**: enabled when `current` (selected DB) has matching variant and is not readonly

`readonly?` maps to `Database::m_readOnly`, set from the `permission` passed to `open()`. For SI5 this must be `ReadWrite` — see `app-database.tcl` `openBase`.

## Version management

The application version is defined in two places:

- `Makefile.version` line 5: `SCIDB_VERSION = -DSCIDB_VERSION="\"1.1.1 BETA\""` (used by the normal build)
- `src/tcl/tcl_misc.cpp` line 69: `# define SCIDB_VERSION "1.1.1 BETA"` (CodeBlocks IDE fallback only)
- `tcl/exec.tcl` line 41: `set version "1.1.1 BETA"` (Tcl-side version — **must match the binary**, otherwise startup fails with "version error")

**Rule:** Increment the third digit (e.g. `1.1.1` → `1.1.2`) with every code change committed. Update all three files together.

## Local Git

All changes must be committed after each modification.

```bash
git add <files>
git commit -m "..."
```
