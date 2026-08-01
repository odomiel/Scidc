# Änderungsprotokoll – Scidc

Versionierte Änderungen, neueste zuerst. Versionsschema **`JJ.MM.TT bN`** (Jahr.Monat.Tag + Tages-Build-Zähler).

> **Pflegehinweis:** Bei jedem versionierten Code-Commit (der den Build-Zähler erhöht) hier einen Eintrag
> mit der neuen Versionsnummer ergänzen – analog zum Versions-Bump in den 4 Versionsdateien.
> Reine Housekeeping-Commits ohne `bN` müssen nicht eingetragen werden.

## 26.08.01

- **b3** – Fix: **Hauptmenü ließ sich nicht öffnen** – `can't set "tk::Priv(menu:window)": parent namespace doesn't exist`. Ursache ist dieselbe Tcl-9-Verhaltensänderung wie in b4 vom 26.07.30 (Tcl 9 löst teilqualifizierte Variablennamen nur noch relativ zum aktuellen Namensraum auf und fällt nicht mehr auf den globalen zurück); drei Stellen waren damals übersehen worden, weil ihr Name den **eigenen** Namensraum wiederholt und dadurch bei einer Textsuche nach `$::`-Kandidaten nicht auffällt. `tcl/contrib/tkmenu.tcl:1372` schrieb in `proc ::tk::PostOverPoint` nach `tk::Priv(…)`, was relativ zu `::tk::tk::Priv` aufgelöst wird – das Menü wurde zwar gepostet, brach danach aber mit einem Fehlerdialog ab. Ebenso: `tcl/contrib/filelist-bindings.tcl:111` (`set TreeCtrl::Priv(selectMode)` in `::TreeCtrl::FileListButton1` → jetzt schlicht `set Priv(…)`, die proc deklariert `variable Priv` bereits) und `tcl/widgets/entrybuttonbox.tcl:111` (`ttk::entrybuttonbox::${w}::Vars` innerhalb von `::ttk::entrybuttonbox`, betraf nur den `invoke`-Unterbefehl – die gleichlautenden Zeilen 216/222 stehen in `bind`-Skripten und laufen im globalen Namensraum, funktionierten also). Der gesamte Tcl-Baum wurde per Skript auf diese Fehlerklasse abgesucht (Namensraum-Kontext je Zeile verfolgen, teilqualifizierte Referenz gegen die Menge tatsächlich existierender Namensräume prüfen): es sind genau diese drei
- **b2** – Fix: **Tk 9 liefert für Menü-Indizes `""` statt `"none"`.** `[$menu index last|end|active|<n>]` gab in Tk 8.6 den Wert `none` zurück, wenn der Index auf keinen Eintrag zeigt – in Tk 9 ist es der leere String. Symptom war ein Fehlerdialog beim Öffnen des **Hauptmenüs**: `::toolbar::addToolbarMenu` prüfte `if {$i eq "none"} { set i -1 }`, die Prüfung griff nicht mehr, und das folgende `incr i` brach mit „expected integer but got """ ab. Der Fehler war nicht auf die Toolbar-Menüs beschränkt – betroffen waren neun weitere Stellen, darunter **sechs im geforkten Tk-Menü-Bindungscode `tcl/contrib/tkmenu.tcl`** (einer Kopie von Tks eigenem `menu.tcl` aus der 8.5-Ära, die Tk 9s Bindungen überschreibt): `MenuNextEntry` lief bei leerem Menü in denselben Arithmetikfehler, und `MenuFirstEntry` kehrte durch `[$menu index active] ne "none"` **immer sofort zurück**, aktivierte also nie den ersten Eintrag – die Tastaturnavigation in Menüs war damit stillschweigend kaputt. Ebenfalls korrigiert: `misc.tcl::menuItemHighlightSecond` (Arithmetik auf leerem Index), `gamebar.tcl`, `app-db-games.tcl` (leeres Menü bekam einen führenden Separator) und `scrolledtable.tcl` (öffnete ein leeres Kontextmenü). Alle Prüfungen akzeptieren jetzt beide Schreibweisen (`in {none {}}` / `ni {none {}}`). Nicht angefasst: gleichlautende `none`-Vergleiche in `gametable.tcl`, `eventtable.tcl` und `tlistbox.tcl` – das sind Zeilen-/Item-Indizes der eigenen Tabellenwidgets, kein Menü-API
- **b1** – Aufräumen: die letzten Tcl/Tk-8.6-Reste nach dem Umstieg auf 9.0 beseitigt. (1) **Echter Bug:** `tcl/help/make_html.tcl` forderte `package require Tk 8.6--` (doppelter Bindestrich = ungültige Versionsangabe, `expected versionMin-versionMax`) – der Help-HTML-Generator war damit schon unter 8.6 nicht lauffähig. Alle sechs Generator-/Hilfsskripte (`make_html`, `make_index`, `make_contents`, `make_template`, `make_cql`, `update-scidb-photo-files`) stehen jetzt auf `Tcl 9` bzw. `Tk 9`. (2) `toolbar.tcl`: der Aktivierungszweig für `icons:x11Hack` (`[info tclversion] <= "8.6"`) konnte ab Tcl 9 nie mehr zutreffen – entfernt. **Verhaltensänderung beachten:** der Umweg umging einen Zentrierungsfehler beim Bemalen von Buttons mit Icons (Tk Toolkit Bug #2433781) und war unter 8.6 aktiv, jetzt ist er aus; die Option bleibt erhalten und lässt sich wieder auf `true` setzen. (3) `configure`: `IgnorePatches` (nur 8.6-Betas) geleert, der Sonderfall für die instabile Tk-Bibliothek 8.5.10 samt Warnmeldung entfernt, tclsh-Suchschleife auf 9.0/8.6 verkürzt – das erzeugte `Makefile.in` ist byteweise identisch zum vorherigen. (4) `INSTALL`/`README` nannten noch Tcl/Tk 8.6 als Build-Voraussetzung; `INSTALL` listet jetzt bewusst **keine** Tcl/Tk-Distributionspakete mehr, weil Scidc gegen die *privaten* Header baut, die Distributionen üblicherweise nicht ausliefern – Schritt 1 (`build-tcltk.sh`) liefert sie. (5) Veralteter Kommentarverweis auf `tcl8.6/tkInt.h` in `tk_ogl.cpp` richtiggestellt

## 26.07.30

- **b6** – Modernisierung: **Tcl/Tk 8.6 wird nicht mehr unterstützt**, Mindestanforderung ist jetzt Tcl/Tk 9.0. Entfernt: die mitgelieferten Kopien interner Tcl/Tk-Header (`src/tk/tk8.6/`, `tk8.7/`, `tcl8.6/`, `tcl8.7/` – 33 Dateien, 23486 Zeilen) samt 216 makedepend-Abhängigkeitszeilen darauf; der 3206-zeilige Tk-8.6-Fork des panedwindow-Widgets in `tk_panedwindow.cpp` (er war schon immer nur für Tk 8.6 aktiv, unter Tk 9 wird Tks eigenes panedwindow benutzt – die Datei ist nur noch ein Stub); die Versions-Guards in unserer eigenen Kompatibilitätsschicht (`tk_compat.h`, `sys_compat_tcl9.h`). Angehoben: `TCL_PREREQ(8,6)` → `(9,0)`, alle `package require Tcl/Tk 8.6-` → `9` (23 Stellen), alle `Tcl_InitStubs`/`Tk_InitStubs`/`Tcl_PkgRequire`-Versionen auf `"9.0"`, `build-tcltk.sh`-Standardversion auf 9.0.4, `configure`-Versionsliste auf `{9.0}`. Die Guards **innerhalb** der drei geforkten Megawidgets bleiben erhalten – das sind Upstream-Guards aus Tk selbst, deren Entfernung spätere Abgleiche erschweren würde. Verifiziert: Vollneubau (487 Objekte) fehlerfrei, Anwendung startet, öffnet Datenbank, Sprach- und Theme-Wechsel ohne Fehler
- **b5** – Modernisierung: Phase 8 Teil 16 – Laufzeitfehler unter Tcl 9 behoben, die erst beim Benutzen auftraten. (1) **Tilde-Expansion**: Tcl 9 expandiert `~` in Dateinamen nicht mehr (TIP 602), `[file nativename ~]` lieferte den Literal `~`. Sämtliche Benutzerdaten landeten dadurch unter `<cwd>/~/.scidc-beta/` statt im Home-Verzeichnis; die Anwendung hielt jeden Start für einen Erststart, blieb im Sprachdialog hängen und öffnete keine übergebenen Dateien. Behoben in `start.tcl` (plus `menu.tcl`, `tools/board.tcl`) über `file tildeexpand` mit 8.6-Fallback. (2) **`cget -sliderlength`** liefert in Tk 9 eine skalierbare Bildschirmdistanz (`22.5p`) – in `scrolledtable.tcl` über `winfo pixels` umgerechnet. (3) **Sprachdateien**: `italiano.tcl`, `magyar.tcl` und `svenska.tcl` enthielten je eine in Latin-1 nachgetragene Zeile (`NightMode`), `lang/nag/espanol.tcl` war komplett **Mac Roman** kodiert – deklariert war jeweils UTF-8. Unter 8.6 gab das stillen Zeichensalat, unter Tcl 9 brach die gesamte Übersetzung ab. Daten auf UTF-8 korrigiert (`Modalità notte`, `Éjszakai mód (sötét)`, `Nattläge (mörkt)`, `Única jugada …`) und die drei Lesestellen in `i18n.tcl` mit `-profile replace` abgesichert, damit ein einzelnes falsches Byte nie wieder eine komplette Sprache kippt
- **b4** – Modernisierung: Phase 8 Teil 15 – **Scidc startet unter Tcl/Tk 9.0 mit vollständiger Oberfläche**. Vier Tcl-9-Verhaltensänderungen behoben: (1) Namensauflösung – Tcl 9 sucht unqualifizierte bzw. relativ qualifizierte Variablennamen nicht mehr zusätzlich im globalen Namensraum; 19 Stellen absolut qualifiziert (`$::tcl_platform`, `$::mc::input`, `$::tk::Priv`, `$::scidc::dir::*`, `$::ratingbox::ratings`, `$::country::icon::flag`, …). (2) Encoding – Kanäle nutzen in Tcl 9 das Profil `strict`; das Lesen der Theme-`.dat`-Dateien bricht bei Alt-Dateien mit Latin-1-Bytes ab (`fconfigure -profile replace`). (3) `ttk::combobox::LBMaster` heißt in Tk 9 `LBMain` – Kompatibilitäts-Alias in `tcombobox.tcl`. (4) ttk-Style-Paddings sind in Tk 9 skalierbare Bildschirmdistanzen (`1.5p`) und nicht mehr direkt rechenbar – in `theme.tcl`, `twm.tcl` und `tcombobox.tcl` über `winfo pixels` umgerechnet. Außerdem meldet der Startup-Fehlerpfad in `end.tcl` jetzt die eigentliche Fehlerursache statt nur „Start-up failed"
- **b3** – Modernisierung: Phase 8 Teil 14 – **Tcl/Tk-9-Build ist jetzt warnungsfrei**. 108 + 40 Stellen behoben, an denen `int*` an `Tcl_Size*`-Ausgabeparameter übergeben wurde (`Tcl_GetStringFromObj`, `Tcl_ListObjGetElements`, `Tcl_ListObjLength`) – auf 64 Bit schreibt Tcl dort 8 Byte in eine 4-Byte-Variable, also stiller Stack-Überschreiber. Betroffen: `treectrl` (tkTreeUtils/Column/Item/Ctrl/Elem/Style, qebind), `text` (tkText, tkTextBTree/Disp/Image/Mark/Tag/Wind/Priv), `html` (css, csssearch, htmldecode, htmltcl, htmlparse, swproc) und `tkdnd`. Zusätzlich: `Tk_CustomOptionSetProc/GetProc`-Offsets auf `Tcl_Size`, `Tk_SelectionProc` (`TextFetchSelection`) auf `Tcl_Size`, `Tcl_FreeProc` (`TreeDestroy`) auf `void*`, `TkSendVirtualEvent`/`TkNewWindowObj`/`TkpAlwaysShowSelection` auf die öffentliche Tk-9-API umgestellt (die Ersatzimplementierungen in `tkMisc.c` entfallen unter Tk 9), `TK_JUSTIFY_NULL` in den treectrl-`switch`-Anweisungen behandelt, `Tcl_Size`-Shim für Tcl 8.6 in `tk_compat.h`
- **b2** – Fix: Tcl 9 brach den Start mit „invalid or incomplete multibyte or wide character" ab – `board-square.tcl`, `board-piece.tcl` und `board-texture.tcl` enthielten je ein rohes Latin-1-`°` (0xB0) in `-text "$deg°"`, das kein gültiges UTF-8 ist. Ersetzt durch die ASCII-Escape `\u00b0`; das Bundle `tcl/scidc-beta` ist damit erstmals durchgehend gültiges UTF-8 (die Mixed-Encoding-Falle ist an dieser Stelle beseitigt)
- **b1** – Modernisierung: Phase 8 Teil 13 – **erster erfolgreicher Link gegen Tcl/Tk 9.0**. Korrupte Forward-Deklarationen in `tk_png.cpp` repariert (fehlgeschlagene `_ANSI_ARGS_`-Ersetzung); `tk_compat.h` um die in Tcl/Tk 9 umbenannte bzw. entfallene API erweitert (`TkpDrawHighlightBorder`→`Tk_DrawHighlightBorder`, `TkpGetSystemDefault`→`Tk_GetSystemDefault`, `Tk_BackgroundError`→`Tcl_BackgroundException`, `panic`→`Tcl_Panic`, `TclGetIntForIndex`→`Tcl_GetIntForIndex`-Wrapper); `stdarg.h` in `htmltcl.c` ergänzt; `Tk_CustomOptionSetProc`-Signatur in `tk_notebook.cpp` korrigiert (`flags` bleibt `int`); Versions-Makro in `src/Makefile` aus `Makefile.version` statt hartkodiert, `cmdVersion` leitet die Version aus `SCIDB_VERSION` ab

## 26.07.27

- **b1** – Modernisierung: Phase 8 Teil 3 – Tcl_Size-Anpassungen für Command-Funktionen (int objc → Tcl_Size objc) und lokale Variablen in allen C++-Dateien (tcl_application.cpp, tcl_board.cpp, tcl_compare.cpp, tcl_crosstable.cpp, tcl_database.cpp, tcl_engine.cpp, tcl_game.cpp, tcl_misc.cpp, tcl_player.cpp, tcl_position.cpp, tcl_progress.cpp, tcl_sort.cpp, tcl_tree.cpp, tcl_view.cpp, tcl_zlib.cpp, tk_busy.cpp, tk_image.cpp, tk_jpeg.cpp, tk_multiwindow.cpp, tk_notebook.cpp, tk_panedwindow.cpp, tk_png.cpp, tk_selection.cpp, tk_session_manager.cpp, tk_twm.cpp, tk_window_manager.cpp, tk_x11.cpp, sys_utf8_codec.cpp)

## 26.07.23

- **b1** – Modernisierung: Phase 8 Teil 2 – Tcl_Size-Anpassungen für Tcl API-Funktionen (Tcl_ListObjGetElements, Tcl_ListObjLength, Tcl_GetStringFromObj, Tcl_GetByteArrayFromObj) in tcl_base.cpp, tcl_board.cpp, tcl_compare.cpp, tcl_crosstable.cpp, tcl_engine.cpp, tcl_game.cpp, tcl_misc.cpp, tcl_player.cpp, tcl_sort.cpp, tcl_view.cpp, tcl_zlib.cpp, sys_utf8_codec.cpp

## 26.07.19

- **b1** – Fix: cmdVersion verwendet jetzt SCIDB_VERSION Makro + Phase 7 Rückbau von static_cast in C-Dateien + Versionsformat ohne Leerzeichen für C++-Kompatibilität + ckalloc/ckfree durch Tcl_Alloc/Tcl_Free ersetzt

## 26.07.13

- **b1** – Modernisierung: Phase 6 – Einfache tkCompat-Wrapper durch öffentliche Tk 8.6 Makros ersetzt

## 26.07.12

- **b12** – Modernisierung: Phase 5 – tk_compat.h in alle Dateien mit tkInt.h integriert
- **b11** – Modernisierung: Phase 3.1 – Alle direkten Tk-Strukturzugriffe in tk_busy.cpp durch Kompatibilitäts-Wrapper ersetzt
- **b11** – Modernisierung: Phase 3 – Direkte TkWindow-Strukturzugriffe in tk_base.cpp und tk_fixes.cpp durch tkCompat-Wrapper ersetzt
- **b10** – Modernisierung: Skript update-version.sh korrigiert (generische Patterns statt hardcoded Versionen)
- **b9** – Modernisierung: Skript update-version.sh zur automatischen Versionssynchronisation hinzugefügt
- **b8** – Modernisierung: Tcl C-API auf moderne Funktionen aktualisiert (Tcl_ResetResult/Tcl_AppendResult → Tcl_SetObjResult, Tcl_Eval → Tcl_EvalEx)
- **b7** – Hilfe: Kommentareditor-Seite ins Englische uebersetzt

## 26.06.28

- **b6** – Hilfe: Englischer Fallback fuer Nicht-Deutsch-Sprachen + 3 en-Seiten ergaenzt
- **b5** – DB: Entsprechungs-Suche als Token-Suche (Reihenfolge/Separator-frei) + ab 3 Zeichen
- **b4** – DB: Entsprechungs-Suche case-insensitive und als Teilstring-Suche
- **b3** – UI: Engine-Info-Felder (Hash/NPS/TB) am TTK-Theme ausrichten
- **b2** – UI: keybar-Tasten am TTK-Theme statt am Color-Scheme ausrichten
- **b1** – Build: GCC 15/C23-Kompatibilität in Tkhtml3 herstellen

## 26.06.15

- **b6** – DB: SI5-Kompaktieren-Crash beheben (fehlendes format::Scid5 in Preconditions)
- **b5** – UI: Kompaktieren-Menüeintrag auch für SI5 anzeigen
- **b4** – DB: Kompaktieren auch für SI5 ermöglichen (gelöschte Partien entfernen)
- **b3** – UI: Dark-Mode: keybar-Tasten (Datum/Ergebnis/Geschlecht) dunkel einfärben
- **b2** – UI: Neue-Datenbank-Dialog: SI5 statt SCI als Standard-Dateityp (Normalschach)
- **b1** – DB: SI5-Index-Decoder erhöht Site-Refcount (decrRef-precondition-Crash beim Ersetzen beheben)

## 26.06.14

- **b6** – UI: darkmode-Theme: TCombobox -padding definieren (stderr-Warnung beheben)
- **b5** – UI: Analyse-Infofelder (Hash/NPS/TB) dunkel + lesbare Schrift im Dark-Mode
- **b4** – UI: Toolbar-Separator: hellen Trennstrich im Dark-Mode beheben
- **b3** – UI: Toolbar-Buttons: grauen Hover-Effekt entfernen
- **b2** – UI: Struktur-/Toolbar-Radiobuttons: ausgewaehlter Button schwarz statt grau
- **b1** – UI: Brett-Toolbar: gedrueckte Checkbutton-Schalter behalten schwarzen Hintergrund

## 26.06.09

- **b26** – Security: CBH/CBF-Lesepfad: OOB-Reads in Annotations-Decodern beheben
- **b2** – Refactor: SCI/SCV-Decoder: Bounds-Guards entdoppeln + totes Feld entfernen
- **b1** – Security: SCI/SCV-Decoder: ungeprueften Data-Section-Offset gegen OOB-Read absichern

## 26.05.31

- **b25** – Security: SCI-Decoder: Varianten-Rekursion gegen Stack-Overflow begrenzen
- **b24** – Security: SI3/4/5- und CBF-Decoder: Varianten-Rekursion begrenzen
- **b23** – Security: CBH-Decoder: Varianten-Rekursion gegen Stack-Overflow begrenzen
- **b22** – Security: PGN-Reader: OOB-Read bei signed-char-Indizierung beheben
- **b21** – Security: SI3/4/5-Index: HomePawn-count gegen Stack-Overflow klemmen
- **b20** – Security: Browser-Fallback gegen Shell-Quoting-Ausbruch haerten
- **b19** – Security: Engine-Downloads per SHA-256 verifizieren
