# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Projekt
- **Scidc** – Chess-Datenbank-App, geforkt von Scidb r1531: ~102k LOC C++, ~92k LOC Tcl/Tk
- 3-Tier-Architektur: C++ DB-Layer → C++ App-Layer → Tcl/Tk UI
- Mindestanforderung: **Tcl/Tk 8.6** (8.5-Kompatibilitätscode entfernt)
- Keine Test-Suite – Testing ist manuell

---

## Build & Versionierung
- **CRITICAL: Jede Codeänderung sofort committen** – niemals mehrere Änderungen ohne Commit ansammeln
- **Niemals `make` aufrufen** – User baut manuell
- `./configure` überschreibt `Makefile.in` – persistente Änderungen müssen **auch in `configure`** gemacht werden
- **Versionsnummer** bei jedem Code-Commit in 3 Dateien synchron erhöhen:
  - `Makefile.version` (Zeile `SCIDB_VERSION`)
  - `src/tcl/tcl_misc.cpp` (CODEBLOCKS-Block, Zeile ~72: `# define SCIDB_VERSION`)
  - `tcl/exec.tcl` (Zeile ~41: `set version "..."` im `namespace eval scidc` Block)
- Standard: **C++14** (`-std=c++14`), keine C++17-Features

---

## Tcl UI – kritische Fallen

### Bundle-Synchronisation
- **Individuelle `.tcl`-Dateien** bearbeiten (Git-Quelle)
- Da `make` nicht aufgerufen wird, muss das Bundle **immer manuell mitgepflegt** werden:
  - `tcl/scidc-beta` – genutzt von `./run-scidb.sh` **und** Quelle für AppImage
  - `AppDir/usr/bin/scidc-beta` wird automatisch von `build-appimage.sh` aus `tcl/scidc-beta` kopiert – **nicht** separat bearbeiten
- Bundle-Zeilen entsprechen den Source-Zeilen (gleiche Zeilennummern, verifizieren vor Edit)
- Version in `tcl/scidc-beta` (Zeile ~41: `set version "..."`) ebenfalls anpassen

### Weitere Fallen
- `proc open` shadowing: In Namespaces mit eigenem `proc open` immer **`::open`** für Datei-Öffnungen nutzen
- **Alle 6 `tcl/lang/*.tcl` sind ISO-8859-1** – niemals direkt mit dem Edit-Tool bearbeiten, immer Python Binary-I/O verwenden
- Beim Entfernen eines Features alle 6 Sprachdateien bereinigen – sonst Startup-Crash
- `package require msgcat` muss explizit aufgerufen werden, bevor `::msgcat::mc` genutzt wird – `messagebox.tcl` lädt es lazy; andere Widgets (`fsbox.tcl`) müssen es selbst requiren

### Namespace `::scidc::` (ehemals `::scidb::`)
Die C++/Tcl-Bridge registriert Befehle als `::scidc::db::*`, `::scidc::game::*`, `::scidc::misc::*`, `::scidc::tk::twm` etc. Beim Schreiben von Tcl-Code drei Muster beachten:
- `"::scidc::..."` – in C++-Stringliteralen (tcl_*.cpp, tk_*.cpp)
- `$scidc::var` – Tcl-Variablenzugriff ohne `::` prefix
- `scidc::command` – Bare Command-Aufruf in Tcl

### TWM SetupTheme – Timing-Falle
`SetupTheme` wird beim TWM-Erstellen UND bei `<<ThemeChanged>>` aufgerufen. Das `after idle [$twm refresh]` darf **nur** bei echten Theme-Wechseln geplant werden. Korrekte Reihenfolge:
```tcl
if {[::scidc::tk::twm exists $twm]} {
    # ... Hintergründe setzen ...
    if {[info exists Vars(theme)] && $Vars(theme) ne $::ttk::currentTheme} {
        after idle [list $twm refresh]   ; # nur bei Theme-Wechsel
    }
}
set Vars(theme) $::ttk::currentTheme    ; # NACH dem Vergleich setzen
```
Bedingungslos geplantes `after idle` feuert während `perform()` via `update idletasks` in `database::build` → reentrant `perform()` → `M_ASSERT(!exists())` → Startup-Fehler „TWM load failed: 26".

---

## Verzeichnisstruktur – synchron halten
| Pfad | Zweck |
|------|-------|
| `AppDir/usr/share/scidc-beta/` | AppImage / `./run-scidb.sh` (via `SCIDB_SHAREDIR`) |
| `/usr/local/share/scidc-beta/` | System-Install (braucht `sudo`) |

`tcl/` ist die Git-Quelle für die Bundles, enthält aber keine installierten Ressourcen.

`build-appimage.sh` synchronisiert bei jedem Build automatisch:
- `tcl/lang/*.tcl` → `AppDir/usr/share/scidc-beta/lang/`
- `tcl/engines/engines.dat` → `AppDir/usr/share/scidc-beta/engines/engines.dat`
- `tcl/help/**/*.html` → `AppDir/usr/share/scidc-beta/help/` (nur existierende Dateien)

Benutzerdaten liegen in `~/.scidc-beta/` (abgeleitet aus dem Executable-Namen `tkscidc-beta`).

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

Die Bridge (`src/tcl/`) ist kein Auto-Binding – jede exponierte Funktion ist explizit als C-Wrapper codiert.

---

## Datenbank-Codecs
- SI3/SI4/SI5 via `si3::Codec`, SCI nativ, CBH/CBF read-only
- **SCI/SCV sind Scidb-Formate** – Formatbeschreibungen in UI und Dokumentation bleiben „Scidb" (nicht umbenennen)
- **SI5-Schreiben**: Nachträglich implementiert – mehrere kritische Stellen in Codec, `tcl_tree.cpp`, `db_common.ipp`, `app-database.tcl`, `export.tcl`

### SI5 vs. SI3/SI4 – NameList/Namebase ID-Falle (kritisch)

`NameList` (`src/db/si3/si3_name_list.*`) ist für SI3/SI4 entworfen, wo Namebase-Einträge **alphabetisch sortiert** gespeichert sind. Für SI5 sind Einträge in **Einfüge-Reihenfolge** (file positions), daher gilt:

| | SI3/SI4 | SI5 |
|---|---|---|
| Namebase-ID | = sorted list position | = Dateiposition (Einfüge-Reihenfolge) |
| Namebase-ID == NameList-ID? | **Ja** | **Nein** |

Daraus folgen drei konkrete Regeln für SI5-Write-Pfade:

1. **`NameList::update()` niemals aus SI5-Write-Pfaden aufrufen.** `update()` setzt `m_usedIdSet`-Bits mit Namebase-Entry-IDs zurück, trackt aber sorted-list IDs → Datenverfälschung → Assertion-Fehler in `adjustListSize()`.

2. **Vektorgröße in `writeNamebasesSi5` von `NameList::size()` ableiten, nicht von `namebase.size()`.** `NameList::size()` = `m_maxId` = max. Dateiposition + 1 und deckt auch Alias-Positionen (duplizierte Namen) ab. `namebase.size()` = Anzahl unique Einträge; wenn deren IDs > unique count sind (durch Aliases), gibt es Out-of-Bounds.

3. **Neue Einträge (IDs ≥ `NameList::size()`)** werden nicht in `m_lookup` aufgenommen; sie müssen direkt aus der Namebase geholt werden. Alias-Positionen (< `NameList::size()`) via `NameList::lookup(fp)` auflösen.

---

## Tcl Startup-Sequenz
1. **`exec.tcl`** – Prüft Version-Match C++ ↔ Tcl (`::scidc::misc::version`), startet Remote-Single-Process-Guard
2. **`start.tcl`** – Initialisiert `::scidc::dir::*` (share, user, config, layout), legt `~/.scidc-beta/` an
3. **`load.tcl`** – Splash-Screen, lazy-lädt ECO, Themes, Engines
4. **`end.tcl`** – Finalisiert UI, registriert Options-Write-Callbacks, aktiviert Event-Handler

Options werden vor der UI gelesen (`::options::sourceFile`) und nach Programmende via Callbacks geschrieben:
```tcl
proc WriteOptions {chan} { ::options::writeItem $chan MyVar }
::options::hookWriter WriteOptions
```

---

## Engines
- Konfiguration: `tcl/engines/engines.dat` (Git-Quelle), synchronisiert nach `AppDir/usr/share/scidc-beta/engines/engines.dat` via `build-appimage.sh`
- Binaries in `~/.scidc-beta/engines/bin/`, Daten in `~/.scidc-beta/engines/<name>/`
- `AppRun` deployt Engines aus `usr/bin/` → `~/.scidc-beta/engines/bin/` beim AppImage-Start
- Engine-Namen in `engines.dat`: `Command` enthält nur den Dateinamen (kein Pfad); `LoadSharedConfiguration` setzt den vollen Pfad
- UCI-Variantnamen müssen gemappt werden (z.B. `"Three-Check"` → `"3check"`)
- `SaveEngine`: `lset Engines $sel ...` **innerhalb** des `if {$sel >= 0}` Blocks

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
- X11-Farbnamen wie `darkblue`, `black`, `blue`, `gray`, `red` werden bei unbekanntem Scheme 1:1 zurückgegeben
- Für Night-Mode-Sichtbarkeit müssen `night:darkblue`, `night:black`, `night:blue` etc. in `colors.tcl` eingetragen werden (bereits vorhanden: `night:blue #88b4e7`, `night:darkblue #6fa8dc`)
- **Jede hardcodierte Farbe** in `-foreground`/`-background`-Optionen → durch `[::colors::lookup <farbe>]` ersetzen

### `end.tcl` überschreibt `table::lookupColor` und `tlistbox::lookupColor`
```tcl
# end.tcl:
proc table::lookupColor   {color} { return [::colors::lookup $color] }
proc tlistbox::lookupColor {color} { return [::colors::lookup $color] }
```
Alle früheren `UpdateColorLookup`/`ColumnForeground`-Mechanismen in `table.tcl` sind dadurch wirkungslos. Fix: Farben direkt in `colors.tcl` Colors-Array eintragen.

Für `tlistbox`-basierte Dropdowns (z.B. `countrybox`, `languagebox`) gilt:
- Default-Background-Schlüssel ist `tlistbox,background` (in `colors.tcl` als `night:tlistbox,background #2b2b2b`)
- Hardcodierte `-foreground darkgreen`/`darkred` in `addcol`-Aufrufen: `night:darkgreen`/`night:darkred` in `colors.tcl` eintragen, dann löst `tlistbox::lookupColor` sie korrekt auf

### tcombobox – `-background` darf nicht an `::ttk::combobox` übergeben werden
`ttk::tcombobox` (`tcl/widgets/tcombobox.tcl`) erzeugt intern einen `::ttk::combobox` und ein `tlistbox`-Popup. Der `-background`-Wert (`tlistbox,background`) ist ein Farbschlüssel – er darf **nicht** in `cbopts` an `::ttk::combobox` übergeben werden (TTK akzeptiert keine Schlüsselnamen). Er fließt ausschließlich über `listopts(-background)` ins Popup. Canvas-Hintergründe immer über `::tlistbox::lookupColor` auflösen.

### `dialogButtons __buttons`-Frame – immer explizit einfärben
`widget::dialogButtons` (`tcl/widgets/misc.tcl`) erzeugt intern:
```tcl
tk::frame $dlg.__buttons -class Dialog   # ← kein Option-DB-Dark-Background!
```
Dieser Frame erbt **nicht** den dunklen Hintergrund aus dem `strongTtk`-Block (der `Dialog`-Class greift im Option-DB-Pfad nicht). Daher muss **jede** `ConfigureColors`-Prozedur die `$dlg.__buttons` abdeckt:
```tcl
if {[winfo exists $dlg.__buttons]} {
    $dlg.__buttons configure -background $bg
    foreach w [winfo children $dlg.__buttons] {
        if {[winfo class $w] eq "Frame"} { $w configure -background $bg }
    }
}
```
Gilt unabhängig davon ob der Dialog vor oder nach `SetupTheme` erstellt wird.

### Dialoge die vor `SetupTheme` erzeugt werden
`SetupTheme` läuft in `load.tcl`. Dialoge die beim ersten Log-Eintrag (noch während des Theme-Ladens) lazy erzeugt werden, erhalten **keine** Option-DB-Hintergründe:
- `tk::toplevel` und `tk::frame` → `configure -background [::colors::lookup ...]` explizit setzen
- `ttk::frame` akzeptiert kein `-background` direkt → stattdessen `tk::frame` verwenden
- Eine `ConfigureColors`-Prozedur anlegen, die in `Open` **und** via `bind $dlg <<ThemeChanged>>` aufgerufen wird

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

## `::util::catchException` Rückgabewerte
| Wert | Bedeutung |
|------|-----------|
| `0` | Erfolg |
| `-1` | User abgebrochen |
| `2` | IOException |
- Bei Nicht-Null: `resultVar` wird **nie** gesetzt → vor Arithmetik auf `{}` prüfen

---

## Minizip-ng 4.2.1 (`src/util/minizip/`)
Ersetzt den klassischen minizip 1.01e – API ist **vollständig verschieden**.
- Build-Flags: `-DHAVE_ZLIB -DZLIB_COMPAT -DMZ_ZIP_NO_CRYPTO`
  - `ZLIB_COMPAT`: ohne dieses Flag inkludiert `mz_crypt.c` `zlib-ng.h` statt `zlib.h`
  - `MZ_ZIP_NO_CRYPTO`: schließt SHA-Hash in `mz_zip_rw.c` aus
- AES-Verschlüsselung nicht gebündelt – alle `#include "mz_strm_wzaes.h"` mit `#ifdef HAVE_WZAES` schützen
- Include-Reihenfolge in Konsumenten: `mz.h` → `mz_strm.h` → `mz_zip.h` → `mz_zip_rw.h`
- Schreib-API: `mz_zip_writer_create → open_file → entry_open → entry_write (gibt bytes zurück, nicht MZ_OK) → entry_close → close → delete`

---

## Hilfe-System (`tcl/help/`)

- Hilfetexte als `.txt`-Quellen → per `make_html.tcl` zu `.html` konvertiert
- Inhaltsverzeichnis: `tcl/help/de/Contents.dat` (und je Sprache analog)
- Sprachen: `de/` (vollständigste), `en/`, `es/`, `it/`, `hu/`, `sv/`
- SCI/SCV-Formatbeschreibungen bleiben „Scidb" (das ist der Formatinhaber)

**Stand der Dokumentation** (analysiert 2026-05-21):
- **13 Einträge in `Contents.dat` ohne .txt-Quelldatei** (geplant aber nie geschrieben): Listenfenster (Partienliste, Spielerliste, Orteliste, Veranstaltungsliste, Kommentatorenliste), Fenster (Partietext, Partienhistorie, Schachbrett, Zugbaum, Zugbaumpartienliste, Kreuztabelle), Dialoge (Partienimport, Datenbankenexport)
- **Features komplett ohne Hilfeeintrag**: Spielerlexikon (`player-dict.tcl`), Engine-Verwaltung (`engine.tcl`), PGN-Export-Einstellungen (`pgn-setup.tcl`), Datenbank-Zusammenführen (`merge.tcl`), Spieler-Steckbrief (`player-card.tcl`)

---

## AppImage

### Build-Workflow (einmalig / nach Bedarf)
```bash
# 1. Tcl/Tk 8.6.18 lokal bauen (einmalig; überspringt sich selbst wenn aktuell):
bash build-tcltk.sh        # → deps/tcltk/

# 2. AppDir/usr/share/ befüllen (einmalig; bleibt bei späteren Builds erhalten):
make && sudo make install   # installiert nach AppDir/usr/share/scidc-beta/

# 3. Normale Entwicklungsiteration:
make
bash build-appimage.sh     # → Scidc-x86_64.AppImage
```

### Wichtige Details
- `build-appimage.sh` kopiert `tcl/scidc-beta` → `AppDir/usr/bin/scidc-beta` (nicht separate Pflege nötig)
- `build-appimage.sh` synchronisiert auch lang/ und engines.dat – preserviert `AppDir/usr/share/` ansonsten
- Tcl/Tk-Module (msgcat etc.) liegen im Source-Build unter `deps/tcltk/lib/tcl8/{ver}/` (nicht `lib/tcl8.6/tcl8/` wie bei Ubuntu-Paketen); `AppRun` setzt `TCL8_6_TM_PATH` entsprechend
- FUSE-Mount ist **read-only** – Schreibzugriffe nur auf `~/.scidc-beta/`
- Engines werden via `AppRun` nach `~/.scidc-beta/engines/bin/` deployt
- `run-scidb.sh` läuft direkt aus dem Source-Tree (kein FUSE): `src/tkscidc-beta tcl/scidc-beta`
- Nach Änderungen an `~/.scidc-beta/config/engines.dat` (z.B. leere Datei durch fehlgeschlagenen Start): Datei löschen, damit die App beim nächsten Start `engines.dat` aus Share neu lädt
