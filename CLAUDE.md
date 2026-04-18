# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Scidb is a chess database application (~102k LOC C++, ~92k LOC Tcl/Tk). It supports multiple database formats (native SCI, Scid SI3/SI4/SI5, ChessBase CBH/CBF read-only) and uses a three-tier architecture: C++ database layer → C++ application layer → Tcl/Tk UI.

## Build

### Dependencies
Tcl/Tk 8.5+, Freetype dev, libSM, Xcursor, fontconfig, libgdbm

### Commands
```bash
./configure          # detect Tcl/Tk and system libraries
make -j$(nproc)      # build everything
make install         # install (requires prefix in configure)
make clean           # remove build artifacts
make depend          # regenerate dependencies
```

Key configure options: `--tcl-includes`, `--tk-includes`, `--tcl-libraries`, `--tk-libraries`, `--prefix`

### Build outputs
- `src/tkscidb-beta` – main GUI binary (links Tk)
- `src/tclscidb-beta` – CLI binary
- `src/cbh2si4`, `src/cdb2sci` – format converter tools
- `src/db/libdb.a`, `src/app/libapp.a`, `src/util/libutil.a`, `src/sys/libsys.a` – static libraries

## Architecture

### Three-tier structure

```
tcl/          Tcl/Tk UI (~92k LOC)
   ↓  Tcl commands (::scidb::*)
src/tcl/      C++ ↔ Tcl binding layer
src/app/      Application layer (Application, Cursor, View, Engine)
src/db/       Database layer (codecs, board, game data)
```

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
- `tcl/scidb-beta`: SI5 databases are no longer forced to `readonly=1` on open
- `src/db/si3/si3_codec.cpp` `updateIndex()`: skips header write for SI5 (SI5 has no file header)
- `src/db/db_common.ipp`: `format::isWritable()` already includes `Scid5`
- `src/db/db_database.cpp`: constructor `M_REQUIRE` already permits SI5 in read-write mode

### Key files

| File | Purpose |
|------|---------|
| `src/db/db_database_codec.h/.cpp` | Codec base class and factory |
| `src/db/db_database.h/.cpp` | Database container, open/save/update logic |
| `src/db/si3/si3_codec.cpp` | SI3/SI4/SI5 codec (2848 lines) |
| `src/db/db_common.h/.ipp` | Format enums, `format::isWritable()` |
| `src/app/app_application.h` | Top-level application class |
| `src/tcl/tcl_application.cpp` | Tcl command registration |
| `tcl/scidb-beta` | Main Tcl UI script (~150k lines, single file) |

## Local Git

All changes must be committed to the local git repository at `.git/` (inside this directory) after each modification.

```bash
git -C /home/thomas/KI/Claude/scidb/scidb-code-r1531-trunk add <files>
git -C /home/thomas/KI/Claude/scidb/scidb-code-r1531-trunk commit -m "..."
```
