#!/usr/bin/env python3
"""Legt ein Forgejo-Release fuer Scidc an und laedt das AppImage als Asset hoch.

Stdlib-only. Zugangsdaten (Nutzer + Token) werden aus ~/.git-credentials fuer
den Forgejo-Host gelesen (wie beim Kamerakonfigurationsmanager). Der Server
nutzt ein selbstsigniertes Zertifikat: entweder dessen Zertifikat per
SCIDC_FORGEJO_CAFILE=<pem> als vertrauenswuerdig angeben (empfohlen) oder die
TLS-Pruefung mit --insecure bewusst abschalten.

Aufruf (aus dem Repo-Wurzelverzeichnis):
    tools/forgejo_release.py [--version V] [--notes TEXT] [--draft] [--dry-run] [--insecure]

Version: aus Makefile.version (z.B. 26.09.23-b2-Beta -> Tag v26.09.23-b2,
Asset Scidc-26.09.23-b2-Beta-x86_64.AppImage). Der Tag muss bereits gepusht
sein. Release-Notes: Commit-Betreffe seit dem vorherigen Tag.

Idempotent: ein existierendes Release zum Tag wird wiederverwendet, ein
gleichnamiges Asset vor dem Upload ersetzt.
"""

import argparse
import base64
import json
import os
import re
import ssl
import subprocess
import sys
import urllib.error
import urllib.request
import uuid

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
API_HOST = os.environ.get("SCIDC_FORGEJO_HOST", "erebor.mittelerde.de:3053")
OWNER = os.environ.get("SCIDC_FORGEJO_OWNER", "forgejouser")
REPO = os.environ.get("SCIDC_FORGEJO_REPO", "Scidc")
API_BASE = "https://%s/api/v1" % API_HOST

_SSL = ssl.create_default_context(cafile=os.environ.get("SCIDC_FORGEJO_CAFILE") or None)


def git(*args):
    return subprocess.run(["git"] + list(args), cwd=ROOT, capture_output=True,
                          text=True, check=True).stdout.strip()


def read_version():
    src = open(os.path.join(ROOT, "Makefile.version"), encoding="utf-8").read()
    m = re.search(r'SCIDB_VERSION=\\"([^\\"]+)\\"', src)
    if not m:
        raise SystemExit("Version in Makefile.version nicht gefunden")
    return m.group(1)                                   # z.B. 26.09.23-b2-Beta


def tag_for(version):
    return "v" + re.sub(r"-Beta$", "", version)         # v26.09.23-b2


def default_notes(tag):
    prev = ""
    try:
        prev = git("describe", "--tags", "--abbrev=0", tag + "^")
    except subprocess.CalledProcessError:
        pass
    rng = "%s..%s" % (prev, tag) if prev else tag
    lines = [l for l in git("log", rng, "--format=- %s").splitlines()
             if not re.match(r"^- (version|bump)", l, re.I)]
    head = "Aenderungen seit %s:\n\n" % prev if prev else ""
    return head + "\n".join(lines)


def read_credentials():
    path = os.path.expanduser("~/.git-credentials")
    host_key = API_HOST.replace(":", "%3a")
    for raw in open(path, encoding="utf-8"):
        line = raw.strip()
        if host_key.lower() not in line.lower() and API_HOST.lower() not in line.lower():
            continue
        m = re.match(r"^https?://([^:]+):([^@]+)@", line)
        if m:
            return m.group(1), m.group(2)
    raise SystemExit("Keine Zugangsdaten fuer %s in ~/.git-credentials gefunden" % API_HOST)


def auth_header(user, token):
    raw = base64.b64encode(("%s:%s" % (user, token)).encode()).decode()
    return {"Authorization": "Basic " + raw}


def request(method, url, headers, data=None):
    req = urllib.request.Request(url, data=data, method=method, headers=headers)
    try:
        with urllib.request.urlopen(req, context=_SSL) as resp:
            return resp.status, resp.read()
    except urllib.error.HTTPError as e:
        return e.code, e.read()


def repo_url(path):
    return "%s/repos/%s/%s/%s" % (API_BASE, OWNER, REPO, path)


def main():
    ap = argparse.ArgumentParser(description="Forgejo-Release anlegen + AppImage hochladen")
    ap.add_argument("--version", help="Version (Vorgabe: aus Makefile.version)")
    ap.add_argument("--notes", help="Release-Text (Vorgabe: Commits seit vorherigem Tag)")
    ap.add_argument("--draft", action="store_true")
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--insecure", action="store_true",
                    help="TLS-Zertifikat nicht pruefen (selbstsignierter Server)")
    args = ap.parse_args()
    if args.insecure:
        _SSL.check_hostname = False
        _SSL.verify_mode = ssl.CERT_NONE

    version = args.version or read_version()
    tag = tag_for(version)
    asset = os.path.join(ROOT, "Scidc-%s-x86_64.AppImage" % version)
    if not os.path.exists(asset):
        raise SystemExit("AppImage nicht gefunden: " + asset)
    try:
        git("rev-parse", "--verify", "refs/tags/" + tag)
    except subprocess.CalledProcessError:
        raise SystemExit("Tag %s existiert nicht (erst taggen und pushen)" % tag)

    notes = args.notes if args.notes is not None else default_notes(tag)
    name = "Scidc " + version.replace("-", " ")         # Scidc 26.09.23 b2 Beta
    print("Release %s (%s)%s" % (tag, name, "  [Entwurf]" if args.draft else ""))
    print("Asset: %s (%d Bytes)" % (os.path.basename(asset), os.path.getsize(asset)))
    print("Notes:\n" + notes)
    if args.dry_run:
        print("--dry-run: nichts gesendet.")
        return 0

    auth = auth_header(*read_credentials())

    status, body = request("GET", repo_url("releases/tags/" + tag), auth)
    if status == 200:
        release = json.loads(body)
        print("Release existiert bereits (id %d) - wird wiederverwendet." % release["id"])
    else:
        payload = json.dumps({"tag_name": tag, "name": name, "body": notes,
                              "draft": args.draft, "prerelease": True}).encode()
        status, body = request("POST", repo_url("releases"),
                               dict(auth, **{"Content-Type": "application/json"}), payload)
        if status not in (200, 201):
            raise SystemExit("Release anlegen fehlgeschlagen (HTTP %d): %s"
                             % (status, body[:400].decode(errors="replace")))
        release = json.loads(body)
        print("Release angelegt: id %d" % release["id"])

    fname = os.path.basename(asset)
    for a in release.get("assets") or []:
        if a.get("name") == fname:
            request("DELETE", repo_url("releases/%d/assets/%d" % (release["id"], a["id"])), auth)

    boundary = uuid.uuid4().hex
    with open(asset, "rb") as fh:
        content = fh.read()
    data = b"".join([
        ("--%s\r\n" % boundary).encode(),
        ('Content-Disposition: form-data; name="attachment"; filename="%s"\r\n' % fname).encode(),
        b"Content-Type: application/octet-stream\r\n\r\n",
        content,
        ("\r\n--%s--\r\n" % boundary).encode(),
    ])
    hdr = dict(auth, **{"Content-Type": "multipart/form-data; boundary=" + boundary})
    status, body = request("POST", repo_url("releases/%d/assets?name=%s" % (release["id"], fname)),
                           hdr, data)
    if status not in (200, 201):
        raise SystemExit("Asset-Upload fehlgeschlagen (HTTP %d): %s"
                         % (status, body[:400].decode(errors="replace")))
    print("Asset hochgeladen: %s" % json.loads(body).get("name"))
    print("Fertig: https://%s/%s/%s/releases/tag/%s" % (API_HOST, OWNER, REPO, tag))
    return 0


if __name__ == "__main__":
    sys.exit(main())
