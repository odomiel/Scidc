# ======================================================================
# Gemeinsames fuer die Pruefreihe.
#
# Lage 1 prueft nur Text: Versionen, Sprachdateien, Hilfe, Spiegel,
# Bestand, Abbild. Nichts davon braucht einen Bildschirm, ein gebautes
# Binary oder deps/tcltk -- die Reihe laeuft in einem frischen Klon.
# Was ein gebautes Erzeugnis braucht (AppImage, Bundle), wird
# uebersprungen statt zu scheitern.
#
# Aufruf aus dem Wurzelverzeichnis:
#     python3 -m unittest discover -s tests -t .
# ======================================================================

import os
import re
import subprocess

WURZEL = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def pfad(*teile):
    """Pfad im Quellbaum."""
    return os.path.join(WURZEL, *teile)


def lies(name, kodierung="utf-8"):
    """Liest eine Datei des Baums mit ausdruecklicher Kodierung."""
    with open(pfad(name), "rb") as f:
        return f.read().decode(kodierung)


def lies_bytes(name):
    with open(pfad(name), "rb") as f:
        return f.read()


def ist_utf8(rohdaten):
    try:
        rohdaten.decode("utf-8")
        return True
    except UnicodeDecodeError:
        return False


def getrackte_dateien():
    """Die von Git verwalteten Dateien. Leere Liste ohne Git."""
    try:
        aus = subprocess.run(["git", "ls-files", "-z"], cwd=WURZEL,
                             capture_output=True, check=True)
    except (OSError, subprocess.CalledProcessError):
        return []
    return [n for n in aus.stdout.decode("utf-8", "replace").split("\0") if n]


def git(*argumente):
    """Ein Git-Aufruf. Liefert None, wenn er nicht gelingt."""
    try:
        aus = subprocess.run(("git",) + argumente, cwd=WURZEL,
                             capture_output=True, check=True)
    except (OSError, subprocess.CalledProcessError):
        return None
    return aus.stdout.decode("utf-8", "replace").strip()


# ----------------------------------------------------------------------
# Sprachdateien
# ----------------------------------------------------------------------

#: Spalten aus tcl/lang/localization.tcl: Name, Kuerzel, Kodierung, Datei.
_SPRACHZEILE = re.compile(r"^\s*\{\s*(\S+)\s+(\S+)\s+(\S+)\s+(\S+\.tcl)\s*\}\s*$")

#: Kodierungsnamen von Tcl auf die von Python.
_KODIERUNG = {"iso8859-1": "latin-1", "utf-8": "utf-8"}


def sprachen():
    """Die Tabelle aus localization.tcl -- sie ist die Vorschrift.

    Datei und Deklaration muessen zusammenpassen, sonst bricht Tcl 9 die
    komplette Uebersetzung ab. Darum liest die Reihe die Tabelle und
    nicht eine eigene Liste.
    """
    tabelle = []
    for zeile in lies("tcl/lang/localization.tcl", "utf-8").split("\n"):
        treffer = _SPRACHZEILE.match(zeile)
        if treffer:
            name, kuerzel, kodierung, datei = treffer.groups()
            tabelle.append((name, kuerzel, kodierung, datei))
    return tabelle


def python_kodierung(tcl_name):
    return _KODIERUNG.get(tcl_name)


def ersten_eintrag(zeile):
    """Bildet [lindex $line 0] und den Rest nach -- so liest es mc::selectLang.

    Ein Schluessel darf in Klammern stehen und dann Leerzeichen tragen
    (``{::dialog::choosefont::mc::Bold Italic}``), darum die Klammerfassung.
    """
    text = zeile.rstrip("\r")
    if text.lstrip().startswith("{"):
        rest = text.lstrip()
        tiefe = 0
        for i, zeichen in enumerate(rest):
            if zeichen == "{":
                tiefe += 1
            elif zeichen == "}":
                tiefe -= 1
                if tiefe == 0:
                    return rest[1:i], rest[i + 1:]
    teile = text.split(None, 1)
    return (teile[0] if teile else ""), (teile[1] if len(teile) > 1 else "")


def sprachzeilen(datei, kodierung):
    """Die Datenzeilen einer Sprachdatei als (Nummer, Schluessel, Rest).

    Uebersprungen wird genau, was auch mc::selectLang ueberspringt: leere
    Zeilen und solche, deren **erstes Zeichen** ein ``#`` ist. Eine
    eingerueckte Kommentarzeile wird dort nicht uebersprungen -- sie
    landet als Zuweisung im Interpreter, und genau das soll auffallen.
    """
    ergebnis = []
    for nummer, zeile in enumerate(lies(datei, kodierung).split("\n"), 1):
        if len(zeile) == 0 or zeile[0] == "#":
            continue
        schluessel, rest = ersten_eintrag(zeile)
        if not schluessel:
            continue
        ergebnis.append((nummer, schluessel, rest))
    return ergebnis


def namensraeume():
    """Jeden Namen, der im Tcl-Quelltext als Namensraum angelegt wird.

    Gesammelt werden die Namen wie geschrieben, nicht ihre Pfade: die
    Verschachtelung ist zeilenweise nicht sicher zu erkennen. Geprueft
    wird darum, dass **jedes Glied** eines Schluessel-Namensraums
    irgendwo als Namensraum vorkommt. Faellt ein Feature weg, fehlt sein
    Glied, und die verwaisten Sprachzeilen fallen auf -- genau die, die
    beim Start ``parent namespace doesn't exist`` werfen.
    """
    muster = re.compile(r"namespace\s+eval\s+(::)?([\w:]+)")
    gefunden = set()
    for wurzel, _, dateien in os.walk(pfad("tcl")):
        if os.path.basename(wurzel) == "lang":
            continue
        for name in dateien:
            if not name.endswith(".tcl"):
                continue
            with open(os.path.join(wurzel, name), "rb") as f:
                rohdaten = f.read()
            try:
                text = rohdaten.decode("utf-8")
            except UnicodeDecodeError:
                text = rohdaten.decode("latin-1")
            for treffer in muster.finditer(text):
                gefunden.add(treffer.group(2))
    return gefunden
