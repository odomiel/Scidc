# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Projekt
- Chess-Datenbank-App: ~102k LOC C++, ~92k LOC Tcl/Tk
- 3-Tier-Architektur: C++ DB-Layer → C++ App-Layer → Tcl/Tk UI
- Keine Test-Suite – Testing ist manuell

---

## Build & Versionierung
- **CRITICAL: Jede Codeänderung sofort committen** – niemals mehrere Änderungen ohne Commit ansammeln
- **Niemals `make` aufrufen** – User baut manuell
- `./configure` überschreibt `Makefile.in` – persistente Änderungen müssen **auch in `configure`** gemacht werden
- **Versionsnummer** bei jedem Code-Commit in 3 Dateien synchron erhöhen:
  - `Makefile.version`
  - `src/tcl/tcl_misc.cpp` (CODEBLOCKS-Block, Zeile ~72)
  - `tcl/exec.tcl` (Zeile ~41)
- Standard: **C++14** (`-std=c++14`), keine C++17-Features

---

## Tcl UI – kritische Fallen

### Bundle-Synchronisation
- **Individuelle `.tcl`-Dateien** bearbeiten (Git-Quelle)
- Da `make` nicht aufgerufen wird, müssen beide Bundles **immer manuell mitgepflegt** werden:
  - `tcl/scidb-beta` – genutzt von `./run-scidb.sh`
  - `AppDir/usr/bin/scidb-beta` – genutzt vom AppImage
- Bundle-Zeilen entsprechen den Source-Zeilen (gleiche Zeilennummern, verifizieren vor Edit)
- Version in beiden Bundles (Zeile 41: `set version "..."`) ebenfalls anpassen

### Weitere Fallen
- `proc open` shadowing: In Namespaces mit eigenem `proc open` immer **`::open`** für Datei-Öffnungen nutzen
- **Alle 6 `tcl/lang/*.tcl` sind ISO-8859-1** – niemals direkt mit dem Edit-Tool bearbeiten, immer Python Binary-I/O verwenden
- Beim Entfernen eines Features alle 6 Sprachdateien bereinigen – sonst Startup-Crash

### TWM SetupTheme – Timing-Falle
`SetupTheme` wird beim TWM-Erstellen UND bei `<<ThemeChanged>>` aufgerufen. Das `after idle [$twm refresh]` darf **nur** bei echten Theme-Wechseln geplant werden. Korrekte Reihenfolge:
```tcl
if {[::scidb::tk::twm exists $twm]} {
    # ... Hintergründe setzen ...
    if {[info exists Vars(theme)] && $Vars(theme) ne $::ttk::currentTheme} {
        after idle [list $twm refresh]   ; # nur bei Theme-Wechsel
    }
}
set Vars(theme) $::ttk::currentTheme    ; # NACH dem Vergleich setzen
```
Bedingungslos geplantes `after idle` feuert während `perform()` via `update idletasks` in `database::build` → reentrant `perform()` → `M_ASSERT(!exists())` → Startup-Fehler „TWM load failed: 26".

---

## 3 Share-Verzeichnisse für Ressourcen – synchron halten
| Pfad | Zweck |
|------|-------|
| `AppDir/usr/share/scidb-beta/` | AppImage / `./run-scidb.sh` (via `SCIDB_SHAREDIR`) |
| `/usr/local/share/scidb-beta/` | System-Install (braucht `sudo`) |

`tcl/` ist die Git-Quelle für die Bundles, enthält aber keine installierten Ressourcen.

---

## C++ Module
| Verzeichnis | Zweck |
|-------------|-------|
| `src/db/` | Datenbank-Layer: Codecs, Boards, Spiele, ECO, Annotationen |
| `src/app/` | App-Layer: Engine-Verwaltung, Views, Datei-I/O |
| `src/tcl/` | C++/Tcl-Bridge: 38 `tcl_*.cpp`-Dateien, je Bereich ein File |
| `src/tk/` | Custom Tk-Widget-Bindings |
| `src/util/` | Utilities: Strings, HTML, zlib, CRC32 |
| `src/sys/` | System: UTF-8, VFS, File-I/O |
| `src/mstl/` | Math/STL-Erweiterungen |

Die Bridge (`src/tcl/`) ist kein Auto-Binding – jede exponierte Funktion ist explizit als C-Wrapper codiert. Tcl-Commands: `::scidb::db::*`, `::scidb::game::*`, `::scidb::misc::*` etc.

---

## Datenbank-Codecs
- SI3/SI4/SI5 via `si3::Codec`, SCI nativ, CBH/CBF read-only
- **SI5-Schreiben**: Nachträglich implementiert – mehrere kritische Stellen in Codec, `tcl_tree.cpp`, `db_common.ipp`, `app-database.tcl`, `export.tcl`

---

## Tcl Startup-Sequenz
1. **`exec.tcl`** – Prüft Version-Match C++ ↔ Tcl, startet Remote-Single-Process-Guard
2. **`start.tcl`** – Initialisiert `::scidb::dir::*` (share, user, config, layout), legt `~/.scidb-beta/` an
3. **`load.tcl`** – Splash-Screen, lazy-lädt ECO, Themes, Engines
4. **`end.tcl`** – Finalisiert UI, registriert Options-Write-Callbacks, aktiviert Event-Handler

Options werden vor der UI gelesen (`::options::sourceFile`) und nach Programmende via Callbacks geschrieben:
```tcl
proc WriteOptions {chan} { ::options::writeItem $chan MyVar }
::options::hookWriter WriteOptions
```

---

## Dark Mode / Theming

### Architektur
- 2 unabhängige Layer: **Color Scheme** (`lite`/`dark`/`night`) + **TTK Theme**
- `night` ↔ `darkmode`-Theme sind gekoppelt; `darkmode` aktiviert `strongTtk` → alle classic-Tk-Widgets bekommen dunklen Hintergrund via Option-Datenbank
- `*Menu.background` muss im `strongTtk`-Block gesetzt sein (classic Tk, nicht TTK)

### `::colors::lookup` – der zentrale Mechanismus
```tcl
# colors.tcl:
proc lookup {color} {
    if {[info exists Colors($Scheme:$color)]} { return $Colors($Scheme:$color) }
    if {[info exists Colors(lite:$color)]}    { return $Colors(lite:$color) }
    return $color   # ← gibt unbekannte Farben UNVERÄNDERT zurück!
}
```
- X11-Farbnamen wie `darkblue`, `black` werden bei unbekanntem Scheme 1:1 zurückgegeben
- Für Night-Mode-Sichtbarkeit müssen `night:darkblue`, `night:black` etc. in `colors.tcl` eingetragen werden
- **Hardcoded `-foreground black`** in Tag-/Widget-Konfigurationen → auf dunklem Hintergrund unsichtbar; durch `[::colors::lookup ...]` ersetzen

### `end.tcl` überschreibt `table::lookupColor`
```tcl
# end.tcl Zeile ~126:
proc table::lookupColor {color} { return [::colors::lookup $color] }
```
Alle früheren `UpdateColorLookup`/`ColumnForeground`-Mechanismen in `table.tcl` sind dadurch wirkungslos. Fix: Farben direkt in `colors.tcl` Colors-Array eintragen.

### PGN-Widget Tag-Farben
- `pgn-setup.tcl::configureText` setzt alle Tag-Farben – wird bei Theme-Wechsel via `refresh` erneut aufgerufen
- Tag-Farb-Keys: `pgn,foreground:main`, `pgn,foreground:comment` etc. (in `colors.tcl` als `night:pgn,...`)
- Browser-Kontext: `main`-Tag erhält keine explizite Vordergrundfarbe → fällt auf Widget-Default zurück

### `strongTtk`-Block in `theme.tcl` – was fehlt schmerzt
Der Block in `SetupTheme` überschreibt globale Defaults. Globale Defaults (außerhalb des Blocks) setzen `*Entry.background white`, `*TEntry.background white` etc. hartkodiert. Fehlende Überschreibungen im `strongTtk`-Block → Eingabefelder bleiben weiß im Night-Mode. Der Block muss abdecken:
- `*Entry.*`, `*Spinbox.*` (classic Tk)
- `*TEntry.*`, `*TSpinbox.*`, `*TCombobox.*` (TTK)

### TkTreeCtrl – Item-Textfarbe (Default-State)
`-fill`-Listen für `text`-Elemente enthalten nur State-spezifische Einträge (selected, hilite). Ohne expliziten Default-Eintrag verwendet TkTreeCtrl intern schwarz → unsichtbar im Night-Mode. **Immer** am Ende der Fill-Liste anfügen:
```tcl
-fill [list \
    [lookupColor key:selected] {selected focus} \
    ... \
    [lookupColor widget,foreground] {}  ;# ← Default für Normalzustand
]
```
Spaltenköpfe brauchen zusätzlich `-textcolor [lookupColor widget,foreground]` beim `column create` und in `ThemeChanged` mit `$t column configure $id -textcolor $fg`.

### `html::Build` – Hintergrund-CSS-Reihenfolge
Der Default-Background-Fallback muss **vor** dem CSS-Preamble-Block stehen, damit `html { background: #2b2b2b; }` in den User-Stylesheet injiziert wird. Ist er danach, bekommt der Tkhtml-Widget keine CSS-Background-Regel – der Tk-Frame ist dunkel, aber die HTML-Renderingfläche bleibt weiß.

`html::SetupCSS` fügt `body { color: #bbbbbb; }` im Night-Mode ein – gilt für alle html-Widgets ohne explizites Color-CSS (About-Dialog, Tip-of-the-Day etc.).

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
- `run-scidb.sh` läuft direkt aus dem Source-Tree (kein FUSE): `src/tkscidb-beta tcl/scidb-beta`
