# Änderungsprotokoll – Scidc

Versionierte Änderungen, neueste zuerst. Versionsschema **`JJ.MM.TT bN`** (Jahr.Monat.Tag + Tages-Build-Zähler).

> **Pflegehinweis:** Bei jedem versionierten Code-Commit (der den Build-Zähler erhöht) hier einen Eintrag
> mit der neuen Versionsnummer ergänzen – analog zum Versions-Bump in den 4 Versionsdateien.
> Reine Housekeeping-Commits ohne `bN` müssen nicht eingetragen werden.

## 26.07.30

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
