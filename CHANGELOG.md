# Änderungsprotokoll – Scidc

Versionierte Änderungen, neueste zuerst. Versionsschema **`JJ.MM.TT bN`** (Jahr.Monat.Tag + Tages-Build-Zähler).

> **Pflegehinweis:** Bei jedem versionierten Code-Commit (der den Build-Zähler erhöht) hier einen Eintrag
> mit der neuen Versionsnummer ergänzen – analog zum Versions-Bump in den 4 Versionsdateien.
> Reine Housekeeping-Commits ohne `bN` müssen nicht eingetragen werden.

## 26.07.19

- **b1** – Fix: cmdVersion verwendet jetzt SCIDB_VERSION Makro + Phase 7 Rückbau von static_cast in C-Dateien

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
