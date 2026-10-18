# ======================================================================
# Waechter fuer den oeffentlichen Push-Spiegel.
#
# Das Repository wird nach GitHub gespiegelt, und der Spiegel steht auf
# sync_on_commit: jeder Push ist binnen Sekunden draussen, ohne
# Zwischenschritt und ohne Gelegenheit, etwas zurueckzuhalten. Ein
# spaeterer Force-Push holt nichts zuverlaessig zurueck.
#
# Darum darf in keinem getrackten Pfad stehen: der Hostname der
# Forgejo-Instanz, eine private IP-Adresse, eine Sitzungskennung. Der
# API-Port ist ausdruecklich ausgenommen -- er steht als Vorgabe in
# release.sh, weil er aus der Remote-URL nicht ableitbar ist.
#
# Die verbotenen Zeichenfolgen stehen **nicht** in dieser Datei: sie
# wird selbst mitveroeffentlicht. Der Hostname wird aus
# 'git remote get-url origin' abgeleitet -- die URL liegt in
# .git/config, und die ist nicht Teil des Repositorys.
# ======================================================================

import os
import re
import subprocess
import unittest

from . import WURZEL, getrackte_dateien, git

#: Fremdcode mit Beispiel-Adressen in Kommentaren. Tkhtml dokumentiert
#: dort die Zerlegung einer URL, das ist keine Anschrift von hier.
FREMDTREFFER_IP = {"src/tk/html/htmldecode.c"}

#: Dasselbe fuer die Suche nach Zugangsdaten: das mitgelieferte
#: http-Paket von Tcl fuehrt in einem Kommentar eine Beispiel-URL mit
#: Benutzer und Kennwort. Das Beispiel steht hier absichtlich nicht
#: ausgeschrieben -- diese Datei wird selbst durchsucht.
FREMDTREFFER_ZUGANG = {"tcl/contrib/http.tcl"}

#: Die gesuchte Zeichenfolge aus zwei Haelften: ausgeschrieben wuerde
#: der Waechter in seiner eigenen Quelle fuendig.
SITZUNG = "claude.ai/code/" + "session_"

#: Drei Commits vom 23.09.2026 tragen eine persoenliche Mailadresse
#: statt der noreply-Adresse -- sie entstanden auf einem anderen Rechner,
#: bevor die Identitaet global gesetzt war, und liegen seitdem im
#: oeffentlichen Spiegel. Zu aendern waere das nur durch Umschreiben der
#: Historie und einen Force-Push, und der holt aus dem Spiegel nichts
#: zuverlaessig zurueck. Hier stehen darum die Hashes, nicht die Adresse.
ALTLAST_FREMDE_ADRESSE = {
    "177cd41",   # Release-Tool: Forgejo-Release anlegen und AppImage hochladen
    "465b8d4",   # CBF: Header-Entschluesselung auf hdr statt buf
    "fc712df",   # CBF: Absturz bei der Zugvorschau in der Partienliste
}


def git_grep(*argumente):
    """Liefert die Trefferzeilen von 'git grep' -- oder [] bei keinem Treffer."""
    aufruf = ["git", "grep", "-I", "-n"] + list(argumente)
    ergebnis = subprocess.run(aufruf, cwd=WURZEL, capture_output=True)
    if ergebnis.returncode not in (0, 1):
        raise AssertionError("git grep misslungen: %s"
                             % ergebnis.stderr.decode("utf-8", "replace"))
    return [z for z in ergebnis.stdout.decode("utf-8", "replace").split("\n") if z]


def instanz_aus_remote():
    """Hostname der Instanz aus der Remote-URL. None, wenn keine da ist.

    Versteht beide Schreibweisen von Forgejo/Gitea:
        ssh://git@host:port/eigentuemer/repo.git
        git@host:eigentuemer/repo.git
    """
    url = git("remote", "get-url", "origin")
    if not url:
        return None
    treffer = re.match(r"^(?:ssh://)?(?:[^@/]+@)?([^:/]+)", url)
    if not treffer:
        return None
    host = treffer.group(1)
    if host in ("github.com", "localhost") or host.endswith(".github.com"):
        return None
    return host


class TestKeineInstanzdetails(unittest.TestCase):
    def setUp(self):
        self.host = instanz_aus_remote()
        if not self.host:
            self.skipTest("kein Remote auf eine eigene Instanz")

    def test_der_hostname_steht_in_keiner_getrackten_datei(self):
        treffer = git_grep("-i", "-F", "-e", self.host)
        self.assertEqual(treffer, [], "Hostname der Instanz in getrackten Dateien")

    def test_auch_der_kurze_name_steht_nirgends(self):
        """Der Rechnername allein genuegt zur Zuordnung."""
        kurz = self.host.split(".")[0]
        if len(kurz) < 5:
            self.skipTest("Kurzname zu kurz fuer eine sinnvolle Suche")
        treffer = git_grep("-i", "-F", "-e", kurz)
        self.assertEqual(treffer, [], "Rechnername der Instanz in getrackten Dateien")

    def test_die_domaene_steht_nirgends(self):
        teile = self.host.split(".")
        if len(teile) < 2:
            self.skipTest("Host ohne Domaene")
        domaene = ".".join(teile[1:])
        treffer = git_grep("-i", "-F", "-e", domaene)
        self.assertEqual(treffer, [], "Domaene der Instanz in getrackten Dateien")


class TestKeinePrivatadressen(unittest.TestCase):
    def test_keine_private_ip_adresse(self):
        treffer = git_grep(
            "-E", "-e",
            r"\b(10\.[0-9]{1,3}|192\.168|172\.(1[6-9]|2[0-9]|3[01]))\.[0-9]{1,3}\.[0-9]{1,3}\b")
        uebrig = [z for z in treffer if z.split(":", 1)[0] not in FREMDTREFFER_IP]
        self.assertEqual(uebrig, [], "private IP-Adresse in getrackten Dateien")

    def test_keine_zugangsdaten_in_einer_url(self):
        """Eine URL der Form schema://benutzer:geheim@host."""
        treffer = git_grep("-E", "-e", r"https?://[^/[:space:]\"']+:[^/[:space:]\"'@]+@")
        uebrig = [z for z in treffer if z.split(":", 1)[0] not in FREMDTREFFER_ZUGANG]
        self.assertEqual(uebrig, [], "URL mit Zugangsdaten in getrackten Dateien")


class TestKeineSitzungskennungen(unittest.TestCase):
    def test_keine_sitzungskennung_im_baum(self):
        treffer = git_grep("-F", "-e", SITZUNG)
        self.assertEqual(treffer, [], "Sitzungskennung in getrackten Dateien")

    def test_keine_sitzungskennung_in_den_commit_nachrichten(self):
        """Die Co-Authored-By-Zeilen bleiben, die Kennung nicht."""
        nachrichten = git("log", "--format=%B", "-n", "200")
        if nachrichten is None:
            self.skipTest("keine Git-Historie")
        self.assertNotIn(SITZUNG, nachrichten)


class TestIdentitaet(unittest.TestCase):
    """Was in einen Commit geschrieben wird, laesst sich nicht zuruecknehmen."""

    def test_die_mailadresse_ist_eine_noreply_adresse(self):
        adresse = git("config", "user.email")
        if adresse is None:
            self.skipTest("keine Git-Identitaet gesetzt")
        self.assertTrue(adresse.endswith("users.noreply.github.com"),
                        "user.email ist keine noreply-Adresse von GitHub")

    def test_der_autorenname_ist_das_pseudonym(self):
        name = git("config", "user.name")
        if name is None:
            self.skipTest("keine Git-Identitaet gesetzt")
        self.assertEqual(name, "Mirik")

    def test_jeder_commit_traegt_die_noreply_adresse(self):
        """Bis auf die drei bekannten Altlasten aus dem September.

        Geprueft wird die ganze Historie, nicht nur die letzten Commits:
        was einmal drin ist, bleibt im Spiegel.
        """
        zeilen = git("log", "--format=%h %ae")
        if zeilen is None:
            self.skipTest("keine Git-Historie")
        fremd = []
        for zeile in zeilen.split("\n"):
            kurz, _, adresse = zeile.partition(" ")
            if adresse.endswith("users.noreply.github.com"):
                continue
            if any(kurz.startswith(h) or h.startswith(kurz)
                   for h in ALTLAST_FREMDE_ADRESSE):
                continue
            fremd.append(kurz)
        self.assertEqual(fremd, [],
                         "Commit(s) mit fremder Adresse: %s" % " ".join(fremd))


class TestAnweisungsdatei(unittest.TestCase):
    def test_claude_md_ist_nicht_getrackt(self):
        """Dort stehen Host und Instanzdetails -- sie darf nicht mit."""
        self.assertNotIn("CLAUDE.md", getrackte_dateien())

    def test_claude_md_steht_in_der_ignoreliste(self):
        with open(os.path.join(WURZEL, ".gitignore"), "r", encoding="utf-8") as f:
            self.assertIn("CLAUDE.md", f.read().split())

    def test_die_notizen_zur_migration_sind_nicht_getrackt(self):
        getrackt = getrackte_dateien()
        for name in ("migration.txt", "Makefile.in"):
            with self.subTest(datei=name):
                self.assertNotIn(name, getrackt)
