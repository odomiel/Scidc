# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Projekt
- Chess-Datenbank-App: ~102k LOC C++, ~92k LOC Tcl/Tk
- 3-Tier-Architektur: C++ DB-Layer → C++ App-Layer → Tcl/Tk UI

---

## Build & Versionierung
- **Niemals `make` aufrufen** – User baut manuell
- `./configure` überschreibt `Makefile.in` – persistente Änderungen müssen **auch in `configure`** gemacht werden
- **Versionsnummer** bei jedem Code-Commit in 3 Dateien synchron erhöhen:
  - `Makefile.version`
  - `src/tcl/tcl_misc.cpp`
  - `tcl/exec.tcl`
- Standard: **C++14** (`-std=c++14`), keine C++17-Features

---

## Tcl UI – kritische Fallen
- **Individuelle `.tcl`-Dateien** bearbeiten, niemals `tcl/scidb-beta` (generiert)
- `proc open` shadowing: In Namespaces mit eigenem `proc open` immer **`::open`** für Datei-Öffnungen nutzen
- **`tcl/lang/*.tcl` sind ISO-8859-1** – niemals direkt mit Edit-Tool bearbeiten, sondern mit Python Binary-I/O
- Beim Entfernen eines Features alle 6 Sprachdateien bereinigen – sonst Startup-Crash

---

## 3 Share-Verzeichnisse – alle synchron halten
| Pfad | Zweck |
|------|-------|
| `tcl/` | Git-Quelle |
| `AppDir/usr/share/scidb-beta/` | AppImage / `./run-scidb.sh` |
| `/usr/local/share/scidb-beta/` | System-Install (braucht `sudo`) |

---

## Datenbank-Codecs
- SI3/SI4/SI5 via `si3::Codec`, SCI nativ, CBH/CBF read-only
- **SI5-Schreiben**: Nachträglich implementiert – mehrere kritische Stellen in Codec, `tcl_tree.cpp`, `db_common.ipp`, `app-database.tcl`, `export.tcl`

---

## Dark Mode / Theming
- 2 unabhängige Layer: **Color Scheme** (`lite`/`dark`/`night`) + **TTK Theme**
- `night` ↔ `darkmode` sind gekoppelt
- `*Menu.background` muss im `strongTtk`-Block gesetzt sein (classic Tk, nicht TTK)
- `table::ColorLookup` wird **nicht** automatisch aktualisiert – `ThemeChanged` muss `-textcolor` explizit setzen

---

## Engines
- Binaries in `~/.scidb-beta/engines/bin/`, Daten in `~/.scidb-beta/engines/<name>/`
- UCI-Variantnamen müssen gemappt werden (z.B. `"Three-Check"` → `"3check"`)
- `SaveEngine`: `lset Engines $sel ...` **innerhalb** des `if {$sel >= 0}` Blocks

---

## `::util::catchException` Rückgabewerte
| Wert | Bedeutung |
|------|-----------|
| `0` | Erfolg |
| `-1` | User abgebrochen |
| `2` | IOException |
- Bei Nicht-Null: `resultVar` wird **nie** gesetzt → vor Arithmetik auf `{}` prüfen

---

## AppImage
- FUSE-Mount ist **read-only** – Schreibzugriffe nur auf `~/.scidb-beta/`
- `build-appimage.sh` preserviert `AppDir/usr/share/` – **nicht** aus `/usr/local/` regenerieren
- Engines werden via `AppRun` nach `~/.scidb-beta/engines/bin/` deployt
