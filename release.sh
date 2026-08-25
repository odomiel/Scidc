#!/bin/bash
# release.sh - Veroeffentlicht ein gebautes AppImage als Release auf der
#              Forgejo-Instanz forgejo.example.invalid.
#
# Die vier Schritte:
#   1. Tag setzen und pushen                (SSH, Port 2222)
#   2. Release anlegen                      (REST-API, Port 3053)
#   3. AppImage als Anhang hochladen        (REST-API)
#   4. Gegenprobe: zurueckladen, Pruefsumme vergleichen, Programm starten
#
# Verwendung:
#   bash release.sh                    # Version aus Makefile.version
#   bash release.sh 26.08.02-b8        # Version ausdruecklich
#   bash release.sh --dry-run          # nur pruefen, nichts veroeffentlichen
#
# Optionen:
#   -m, --message TEXT     Release-Text ausdruecklich setzen
#   -n, --notes-file DATEI Release-Text aus DATEI lesen
#                          (Vorgabe: der Eintrag "- **bN** - ..." aus CHANGELOG.md)
#       --stable           ohne Vorabversion-Kennzeichen (Vorgabe: Vorabversion)
#       --draft            als Entwurf anlegen
#       --force            vorhandenen Anhang gleichen Namens ersetzen
#       --no-run           Schritt 4 ohne Programmstart (nur Pruefsumme)
#       --dry-run          alle Pruefungen, aber kein Schreibzugriff
#   -h, --help             diese Hilfe
#
# Anmeldung:
#   Schritt 1 laeuft ueber den SSH-Schluessel (git remote "origin").
#   Schritt 2-4 brauchen Benutzer und Geheimnis fuer die REST-API. Das Skript
#   nimmt $FORGEJO_CRED ("benutzer:geheim"), sonst die passende Zeile aus
#   ~/.git-credentials. Das Geheimnis wird nie ausgegeben und nie als
#   Befehlszeilenargument uebergeben (curl liest es ueber --config von einer
#   Pipe, damit es nicht in "ps" auftaucht).

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

# --- Konfiguration -----------------------------------------------------------
FORGEJO_HOST="forgejo.example.invalid"
FORGEJO_PORT="3053"
REPO_OWNER="forgejouser"
REPO_NAME="Scidc"
API="https://${FORGEJO_HOST}:${FORGEJO_PORT}/api/v1/repos/${REPO_OWNER}/${REPO_NAME}"
# Das Zertifikat der Instanz ist selbstsigniert -> curl braucht -k.
CURL_OPTS=(-sS -k)

# --- Argumente ---------------------------------------------------------------
VERSION=""; NOTES=""; NOTES_FILE=""
PRERELEASE=true; DRAFT=false; FORCE=false; RUN_CHECK=true; DRY_RUN=false

usage() { sed -n '2,/^set -euo/p' "$0" | sed 's/^# \{0,1\}//;$d'; }

while [ $# -gt 0 ]; do
	case "$1" in
		-m|--message)    NOTES="$2"; shift 2 ;;
		-n|--notes-file) NOTES_FILE="$2"; shift 2 ;;
		--stable)        PRERELEASE=false; shift ;;
		--draft)         DRAFT=true; shift ;;
		--force)         FORCE=true; shift ;;
		--no-run)        RUN_CHECK=false; shift ;;
		--dry-run)       DRY_RUN=true; shift ;;
		-h|--help)       usage; exit 0 ;;
		-*)              echo "Unbekannte Option: $1" >&2; exit 2 ;;
		*)               VERSION="$1"; shift ;;
	esac
done

fail() { echo "FEHLER: $*" >&2; exit 1; }
step() { echo; echo "=== $* ==="; }

# --- Version bestimmen und gegenpruefen --------------------------------------
# Makefile.version schreibt die Version mit Bindestrichen (26.08.02-b8-Beta),
# tcl_misc.cpp und exec.tcl mit Leerzeichen (26.08.02 b8 Beta).
if [ -z "$VERSION" ]; then
	VERSION=$(sed -n 's/.*-DSCIDB_VERSION=\\"\(.*\)\\".*/\1/p' Makefile.version)
	[ -n "$VERSION" ] || fail "Version nicht aus Makefile.version lesbar"
fi

FULL="$VERSION"                     # 26.08.02-b8-Beta
BASE="${FULL%-Beta}"                # 26.08.02-b8
TAG="v$BASE"                        # v26.08.02-b8
SPACED="${FULL//-/ }"               # 26.08.02 b8 Beta
BUILD="${BASE##*-}"                 # b8
DATE="${BASE%-*}"                   # 26.08.02
APPIMAGE="Scidc-${FULL}-x86_64.AppImage"
if [ "$FULL" = "$BASE" ]; then RELEASE_NAME="Scidc $TAG"; else RELEASE_NAME="Scidc $TAG Beta"; fi

echo "Version:  $FULL"
echo "Tag:      $TAG"
echo "AppImage: $APPIMAGE"

# Die drei Versionsdateien muessen uebereinstimmen - ein Release aus einem
# Baum mit auseinanderlaufenden Versionen meldet beim Start einen Konflikt
# zwischen C++ und Tcl.
V_CPP=$(sed -n 's/^# *define *SCIDB_VERSION[ \t]*"\(.*\)".*/\1/p' src/tcl/tcl_misc.cpp | head -1)
V_TCL=$(sed -n 's/^[ \t]*set version "\(.*\)".*/\1/p' tcl/exec.tcl | head -1)
[ "$V_CPP" = "$SPACED" ] || fail "src/tcl/tcl_misc.cpp sagt \"$V_CPP\", erwartet \"$SPACED\""
[ "$V_TCL" = "$SPACED" ] || fail "tcl/exec.tcl sagt \"$V_TCL\", erwartet \"$SPACED\""
echo "Versionsdateien stimmen ueberein."

[ -f "$APPIMAGE" ] || fail "AppImage fehlt: $APPIMAGE (erst 'bash build-appimage.sh')"
SHA_LOCAL=$(sha256sum "$APPIMAGE" | cut -d' ' -f1)
SIZE_LOCAL=$(stat -c %s "$APPIMAGE")
echo "Groesse:  $SIZE_LOCAL Bytes"
echo "SHA-256:  $SHA_LOCAL"

# --- Release-Text ------------------------------------------------------------
if [ -n "$NOTES_FILE" ]; then
	[ -f "$NOTES_FILE" ] || fail "Notizdatei fehlt: $NOTES_FILE"
	NOTES=$(cat "$NOTES_FILE")
elif [ -z "$NOTES" ]; then
	# Vorgabe: der Eintrag zu diesem Build aus CHANGELOG.md (eine Zeile).
	# Der Zaehler bN faengt an jedem Tag wieder bei b1 an - die Suche muss
	# deshalb auf den Abschnitt "## JJ.MM.TT" dieser Version begrenzt sein,
	# sonst findet sie das b8 eines frueheren Tages.
	NOTES=$(awk -v head="## $DATE" -v build="$BUILD" '
	           $0 == head            { inside = 1; next }
	           /^## /                { inside = 0 }
	           inside && index($0, "- **" build "** ") == 1 { print; exit }
	        ' CHANGELOG.md)
	[ -n "$NOTES" ] || fail "kein CHANGELOG-Eintrag fuer $BUILD unter \"## $DATE\" - Text mit -m/-n angeben"
	NOTES="${NOTES#- }"
fi
echo "Text:     ${#NOTES} Zeichen"

# --- Zugangsdaten ------------------------------------------------------------
# Die Zeile in ~/.git-credentials beginnt mit "http://" und traegt den Port
# URL-kodiert (%3a3053); gebraucht wird nur der Teil vor dem "@".
if [ -n "${FORGEJO_CRED:-}" ]; then
	CRED="$FORGEJO_CRED"
elif [ -f "$HOME/.git-credentials" ]; then
	CRED=$(grep -m1 "$FORGEJO_HOST" "$HOME/.git-credentials" | sed -E 's#^[a-z]+://([^@]*)@.*#\1#')
	[ -n "$CRED" ] || fail "keine Zeile fuer $FORGEJO_HOST in ~/.git-credentials"
else
	fail "keine Zugangsdaten - \$FORGEJO_CRED setzen oder ~/.git-credentials anlegen"
fi

# curl liest Benutzer/Geheimnis ueber --config von einer Pipe, damit es nicht
# in der Prozessliste steht. Ausgabe: Rumpf, letzte Zeile der HTTP-Status.
api() {   # api METHODE PFAD [weitere curl-Argumente]
	local method="$1" path="$2"; shift 2
	curl "${CURL_OPTS[@]}" --config <(printf 'user = "%s"\n' "$CRED") \
	     -X "$method" -w '\n%{http_code}' "${API}${path}" "$@"
}
http_code() { tail -n1 <<<"$1"; }
http_body() { sed '$d' <<<"$1"; }

# Zugang einmal pruefen, bevor irgendetwas geschrieben wird.
RESP=$(api GET "")
[ "$(http_code "$RESP")" = "200" ] || fail "API nicht erreichbar oder Anmeldung abgelehnt (HTTP $(http_code "$RESP"))"

if $DRY_RUN; then
	echo; echo "--dry-run: alle Pruefungen bestanden, nichts veroeffentlicht."
	exit 0
fi

# --- Schritt 1: Tag setzen und pushen ----------------------------------------
step "Schritt 1/4: Tag $TAG"

if git rev-parse -q --verify "refs/tags/$TAG" >/dev/null; then
	echo "Tag existiert lokal bereits ($(git rev-parse --short "$TAG"))."
else
	# Tag-Namen duerfen keine Leerzeichen enthalten - daher $TAG, nicht $SPACED.
	git tag -a "$TAG" -m "Scidc $SPACED"
	echo "Tag angelegt auf $(git rev-parse --short HEAD)."
fi

if git ls-remote --exit-code --tags origin "$TAG" >/dev/null 2>&1; then
	echo "Tag ist bereits auf origin."
else
	# Git wiederholt die URL samt Geheimnis in Meldungen -> Ausgabe maskieren.
	git push origin "$TAG" 2>&1 | sed 's#://[^:/]*:[^@]*@#://<benutzer>:<geheim>@#'
	echo "Tag gepusht."
fi

# --- Schritt 2: Release anlegen ----------------------------------------------
step "Schritt 2/4: Release fuer $TAG"

RESP=$(api GET "/releases/tags/$TAG")
if [ "$(http_code "$RESP")" = "200" ]; then
	RELEASE_ID=$(http_body "$RESP" | jq -r '.id')
	echo "Release existiert bereits (ID $RELEASE_ID) - Text bleibt unveraendert."
else
	BODY=$(jq -n --arg tag "$TAG" --arg name "$RELEASE_NAME" --arg body "$NOTES" \
	             --argjson pre "$PRERELEASE" --argjson draft "$DRAFT" \
	       '{tag_name:$tag, name:$name, body:$body, prerelease:$pre, draft:$draft}')
	RESP=$(api POST "/releases" -H 'Content-Type: application/json' -d "$BODY")
	[ "$(http_code "$RESP")" = "201" ] || fail "Release nicht angelegt (HTTP $(http_code "$RESP")): $(http_body "$RESP")"
	RELEASE_ID=$(http_body "$RESP" | jq -r '.id')
	echo "Release angelegt (ID $RELEASE_ID, Vorabversion=$PRERELEASE, Entwurf=$DRAFT)."
fi

# --- Schritt 3: AppImage anhaengen -------------------------------------------
step "Schritt 3/4: Anhang $APPIMAGE"

RESP=$(api GET "/releases/$RELEASE_ID/assets")
OLD_ID=$(http_body "$RESP" | jq -r --arg n "$APPIMAGE" '.[] | select(.name==$n) | .id' | head -1)
if [ -n "$OLD_ID" ]; then
	if $FORCE; then
		RESP=$(api DELETE "/releases/$RELEASE_ID/assets/$OLD_ID")
		echo "Vorhandenen Anhang $OLD_ID entfernt (HTTP $(http_code "$RESP"))."
	else
		fail "Anhang $APPIMAGE existiert bereits (ID $OLD_ID) - mit --force ersetzen"
	fi
fi

RESP=$(api POST "/releases/$RELEASE_ID/assets?name=$APPIMAGE" -F "attachment=@$APPIMAGE")
[ "$(http_code "$RESP")" = "201" ] || fail "Anhang nicht hochgeladen (HTTP $(http_code "$RESP")): $(http_body "$RESP")"
ASSET_ID=$(http_body "$RESP" | jq -r '.id')
ASSET_URL=$(http_body "$RESP" | jq -r '.browser_download_url')
echo "Hochgeladen (Anhang-ID $ASSET_ID)."

# --- Schritt 4: Gegenprobe ---------------------------------------------------
# Ein Upload, der ankommt, sagt fuer sich genommen noch nicht, dass das
# Richtige angekommen ist. Also zurueckladen, Pruefsumme vergleichen und die
# heruntergeladene Datei starten.
step "Schritt 4/4: Gegenprobe"

TMPDIR_DL=$(mktemp -d)
trap 'rm -rf "$TMPDIR_DL"' EXIT
DL="$TMPDIR_DL/$APPIMAGE"

curl "${CURL_OPTS[@]}" --config <(printf 'user = "%s"\n' "$CRED") \
     -L -o "$DL" "$ASSET_URL"

SHA_REMOTE=$(sha256sum "$DL" | cut -d' ' -f1)
SIZE_REMOTE=$(stat -c %s "$DL")
echo "Zurueckgeladen: $SIZE_REMOTE Bytes"
echo "SHA-256:        $SHA_REMOTE"
[ "$SHA_REMOTE" = "$SHA_LOCAL" ] || fail "Pruefsumme weicht ab - Anhang ist nicht die gebaute Datei"
echo "Pruefsumme stimmt - byteweise identisch."

if $RUN_CHECK; then
	# "--version" beendet sich in exec.tcl, bevor die Oberflaeche startet:
	# es braucht keine laufende Sitzung und schreibt options.dat nicht an.
	chmod +x "$DL"
	OUT=$(timeout 120 "$DL" --version 2>&1) || fail "Start der zurueckgeladenen Datei fehlgeschlagen: $OUT"
	echo "$OUT" | head -1
	grep -qF "$SPACED" <<<"$OUT" || fail "gestartete Datei meldet nicht \"$SPACED\""
	echo "Gestartete Datei meldet die erwartete Version."
else
	echo "Programmstart uebersprungen (--no-run)."
fi

echo
echo "Fertig: https://${FORGEJO_HOST}:${FORGEJO_PORT}/${REPO_OWNER}/${REPO_NAME}/releases/tag/${TAG}"
