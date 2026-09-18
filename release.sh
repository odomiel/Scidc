#!/bin/bash
# release.sh - Veroeffentlicht ein gebautes AppImage als Release auf der
#              Forgejo-Instanz, auf die "git remote origin" zeigt.
#
# Die vier Schritte:
#   1. Tag setzen und pushen                (SSH, ueber origin)
#   2. Release anlegen                      (REST-API)
#   3. AppImage als Anhang hochladen        (REST-API)
#   4. Gegenprobe: zurueckladen, Pruefsumme vergleichen, Programm starten
#   5. dasselbe Release auf GitHub, falls ein Push-Mirror dorthin zeigt
#      (Mirror-Abgleich anstossen, Release anlegen, Anhang hoch, Gegenprobe)
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
#       --github           Schritt 5 erzwingen (Abbruch, wenn kein Token da ist)
#       --no-github        Schritt 5 auslassen
#       --dry-run          alle Pruefungen, aber kein Schreibzugriff
#   -h, --help             diese Hilfe
#
# Instanz:
#   Host, Eigentuemer und Repository kommen aus der URL von "git remote origin"
#   -- die steht in .git/config und ist damit nicht Teil des Repositorys. Der
#   Port der REST-API laesst sich daraus nicht ableiten (er ist ein anderer als
#   der des SSH-Zugangs); er steht in $FORGEJO_API_PORT, Vorgabe 3053. Alle
#   vier Werte lassen sich einzeln ueberschreiben: $FORGEJO_HOST,
#   $FORGEJO_API_PORT, $FORGEJO_OWNER, $FORGEJO_REPO.
#
# Anmeldung:
#   Schritt 1 laeuft ueber den SSH-Schluessel (git remote "origin").
#   Schritt 2-4 brauchen Benutzer und Geheimnis fuer die REST-API. Das Skript
#   nimmt $FORGEJO_CRED ("benutzer:geheim"), sonst die passende Zeile aus
#   ~/.git-credentials. Das Geheimnis wird nie ausgegeben und nie als
#   Befehlszeilenargument uebergeben (curl liest es ueber --config von einer
#   Pipe, damit es nicht in "ps" auftaucht).
#
#   Schritt 5 braucht einen GitHub-Token mit "Contents: Read and write" -- das
#   ist derselbe, den der Push-Mirror benutzt, ein zweiter ist nicht noetig.
#   Gesucht wird in dieser Reihenfolge: $GITHUB_TOKEN, die github.com-Zeile in
#   ~/.git-credentials, "gh auth token". Findet sich keiner, wird Schritt 5
#   uebersprungen und das ausdruecklich gemeldet -- das Forgejo-Release ist zu
#   dem Zeitpunkt bereits veroeffentlicht und bleibt es. Der Token wird curl
#   ebenfalls ueber --config gereicht, nie als Argument.
#
#   Wohin veroeffentlicht wird, steht nicht im Skript: es liest die Adresse aus
#   dem Push-Mirror des Forgejo-Repositorys ($GITHUB_REPO ueberschreibt sie).

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

# --- Konfiguration -----------------------------------------------------------
# Die Instanz steht nicht im Skript: sie wird aus "git remote origin" gelesen.
# Damit traegt das Repository selbst keinen Hostnamen -- wichtig, wenn es
# gespiegelt wird. Erkannt werden beide Schreibweisen von Forgejo/Gitea:
#   ssh://git@host:port/eigentuemer/repo.git   und   git@host:eigentuemer/repo.git
origin_url=$(git config --get remote.origin.url 2>/dev/null || true)
origin_rest=${origin_url#*://}                 # Schema abtrennen, falls vorhanden
origin_rest=${origin_rest#*@}                  # Benutzer abtrennen, falls vorhanden
origin_host=${origin_rest%%[:/]*}              # bis zum ersten ":" oder "/"
origin_path=${origin_rest#"$origin_host"}      # ":port/eig/repo", ":eig/repo" o. "/eig/repo"
origin_path=${origin_path#:}                   # Doppelpunkt weg (Port oder scp-Form)
case $origin_path in [0-9]*/*) origin_path=${origin_path#*/} ;; esac   # war ein Port
origin_path=${origin_path#/}
origin_path=${origin_path%.git}

FORGEJO_HOST="${FORGEJO_HOST:-$origin_host}"
FORGEJO_PORT="${FORGEJO_API_PORT:-3053}"
REPO_OWNER="${FORGEJO_OWNER:-${origin_path%%/*}}"
REPO_NAME="${FORGEJO_REPO:-${origin_path##*/}}"

[ -n "$FORGEJO_HOST" ] || { echo "release.sh: kein Host - \"git remote origin\" setzen oder \$FORGEJO_HOST angeben" >&2; exit 1; }
[ -n "$REPO_OWNER" ] && [ -n "$REPO_NAME" ] && [ "$REPO_OWNER" != "$REPO_NAME" ] || \
	{ echo "release.sh: Eigentuemer/Repository nicht aus origin ableitbar - \$FORGEJO_OWNER und \$FORGEJO_REPO setzen" >&2; exit 1; }

API="https://${FORGEJO_HOST}:${FORGEJO_PORT}/api/v1/repos/${REPO_OWNER}/${REPO_NAME}"
# Das Zertifikat der Instanz ist selbstsigniert -> curl braucht -k.
CURL_OPTS=(-sS -k)

# --- Argumente ---------------------------------------------------------------
VERSION=""; NOTES=""; NOTES_FILE=""
PRERELEASE=true; DRAFT=false; FORCE=false; RUN_CHECK=true; DRY_RUN=false
GITHUB=auto   # auto | yes | no

usage() { sed -n '2,/^set -euo/p' "$0" | sed 's/^# \{0,1\}//;$d'; }

while [ $# -gt 0 ]; do
	case "$1" in
		-m|--message)    NOTES="$2"; shift 2 ;;
		-n|--notes-file) NOTES_FILE="$2"; shift 2 ;;
		--stable)        PRERELEASE=false; shift ;;
		--draft)         DRAFT=true; shift ;;
		--force)         FORCE=true; shift ;;
		--no-run)        RUN_CHECK=false; shift ;;
		--github)        GITHUB=yes; shift ;;
		--no-github)     GITHUB=no; shift ;;
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
# Die zsync-Datei erzeugt build-appimage.sh zusammen mit dem AppImage (via
# "appimagetool -u"). Sie ist der Anker der Aktualisierungspruefung: der im
# AppImage eingebettete Suchausdruck endet auf ".zsync", und ein Verwalter wie
# Gear Lever sucht in den Anhaengen des Releases genau danach, streicht die
# Endung und laedt das so benannte AppImage. Fehlt sie im Release, findet er
# nichts -- auch wenn das AppImage selbst da ist. Optional: aeltere Staende
# haben sie nicht, und ohne sie soll das Skript trotzdem durchlaufen.
ZSYNC="${APPIMAGE}.zsync"
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
# URL-kodiert; gebraucht wird nur der Teil vor dem "@".
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

# --- GitHub: Token und Ziel ---------------------------------------------------
# Beides wird aufgeloest, bevor der erste Schreibzugriff passiert, damit ein
# fehlender Token nicht erst nach dem Forgejo-Release auffaellt.
GH_TOKEN=""; GH_SLUG=""

find_gh_token() {
	if [ -n "${GITHUB_TOKEN:-}" ]; then GH_TOKEN="$GITHUB_TOKEN"; return 0; fi
	if [ -f "$HOME/.git-credentials" ]; then
		local line cred
		line=$(grep -m1 -E '^[a-z]+://[^@]*@github\.com' "$HOME/.git-credentials" || true)
		if [ -n "$line" ]; then
			cred=$(sed -E 's#^[a-z]+://([^@]*)@.*#\1#' <<<"$line")
			GH_TOKEN="${cred#*:}"                      # Teil hinter dem Doppelpunkt
			[ -n "$GH_TOKEN" ] && return 0
		fi
	fi
	if command -v gh >/dev/null 2>&1; then
		GH_TOKEN=$(gh auth token 2>/dev/null || true)
		[ -n "$GH_TOKEN" ] && return 0
	fi
	return 1
}

# curl bekommt den Token ueber --config, damit er nicht in "ps" steht.
gh_api() {   # gh_api METHODE PFAD [weitere curl-Argumente]
	local method="$1" path="$2"; shift 2
	curl -sS --config <(printf 'header = "Authorization: Bearer %s"\n' "$GH_TOKEN") \
	     -H 'Accept: application/vnd.github+json' \
	     -H 'X-GitHub-Api-Version: 2022-11-28' \
	     -X "$method" -w '\n%{http_code}' "https://api.github.com${path}" "$@"
}

if [ "$GITHUB" != "no" ]; then
	if find_gh_token; then
		if [ -n "${GITHUB_REPO:-}" ]; then
			GH_SLUG="$GITHUB_REPO"
		else
			# Ziel aus dem Push-Mirror des Forgejo-Repositorys lesen.
			RESP=$(api GET "/push_mirrors")
			if [ "$(http_code "$RESP")" = "200" ]; then
				GH_SLUG=$(http_body "$RESP" \
					| jq -r '.[] | select(.remote_address // "" | test("github\\.com")) | .remote_address' \
					| head -1)
				GH_SLUG=${GH_SLUG#*github.com/}
				GH_SLUG=${GH_SLUG%.git}
			fi
		fi
		if [ -z "$GH_SLUG" ]; then
			[ "$GITHUB" = "yes" ] && fail "kein GitHub-Push-Mirror gefunden - \$GITHUB_REPO setzen"
			GITHUB=no; GH_REASON="kein Push-Mirror nach GitHub eingerichtet"
		else
			RESP=$(gh_api GET "/repos/$GH_SLUG")
			if [ "$(http_code "$RESP")" = "200" ]; then
				GITHUB=yes
			else
				[ "$GITHUB" = "yes" ] && fail "GitHub-Repo $GH_SLUG nicht erreichbar (HTTP $(http_code "$RESP"))"
				GITHUB=no; GH_REASON="GitHub antwortet mit HTTP $(http_code "$RESP")"
			fi
		fi
	else
		[ "$GITHUB" = "yes" ] && fail "kein GitHub-Token - \$GITHUB_TOKEN setzen, github.com in ~/.git-credentials eintragen oder \"gh auth login\" ausfuehren"
		GITHUB=no; GH_REASON="kein GitHub-Token gefunden"
	fi
fi

if [ "$GITHUB" = "yes" ]; then STEPS=5; else STEPS=4; fi
echo "GitHub:   $([ "$GITHUB" = "yes" ] && echo "$GH_SLUG" || echo "uebersprungen (${GH_REASON:-per --no-github})")"

if $DRY_RUN; then
	echo; echo "--dry-run: alle Pruefungen bestanden, nichts veroeffentlicht."
	exit 0
fi

# --- Schritt 1: Tag setzen und pushen ----------------------------------------
step "Schritt 1/$STEPS: Tag $TAG"

if git rev-parse -q --verify "refs/tags/$TAG" >/dev/null; then
	# rev-list statt rev-parse: bei einem annotierten Tag liefert rev-parse das
	# Tag-Objekt, nicht den Commit, auf den es zeigt.
	TAGGED=$(git rev-list -n1 --abbrev-commit "$TAG")
	echo "Tag existiert lokal bereits (Commit $TAGGED)."
	[ "$TAGGED" = "$(git rev-parse --short=${#TAGGED} HEAD)" ] \
		|| echo "HINWEIS: Tag zeigt nicht auf HEAD ($(git rev-parse --short HEAD)) - Release bekommt den Stand von $TAGGED."
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
step "Schritt 2/$STEPS: Release fuer $TAG"

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
step "Schritt 3/$STEPS: Anhang $APPIMAGE"

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

if [ -f "$ZSYNC" ]; then
	OLD_ID=$(api GET "/releases/$RELEASE_ID/assets" | http_body | \
	         jq -r --arg n "$ZSYNC" '.[] | select(.name==$n) | .id' | head -1)
	if [ -n "$OLD_ID" ] && $FORCE; then
		api DELETE "/releases/$RELEASE_ID/assets/$OLD_ID" >/dev/null
		OLD_ID=""
	fi
	if [ -n "$OLD_ID" ]; then
		fail "Anhang $ZSYNC existiert bereits (ID $OLD_ID) - mit --force ersetzen"
	fi
	RESP=$(api POST "/releases/$RELEASE_ID/assets?name=$ZSYNC" -F "attachment=@$ZSYNC")
	[ "$(http_code "$RESP")" = "201" ] \
		|| fail "Anhang $ZSYNC nicht hochgeladen (HTTP $(http_code "$RESP")): $(http_body "$RESP")"
	echo "Hochgeladen (Anhang-ID $(http_body "$RESP" | jq -r '.id'), $ZSYNC)."
else
	echo "HINWEIS: $ZSYNC fehlt - Aktualisierungspruefung der Verwalter greift nicht."
fi

# --- Schritt 4: Gegenprobe ---------------------------------------------------
# Ein Upload, der ankommt, sagt fuer sich genommen noch nicht, dass das
# Richtige angekommen ist. Also zurueckladen, Pruefsumme vergleichen und die
# heruntergeladene Datei starten.
step "Schritt 4/$STEPS: Gegenprobe"

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

# --- Schritt 5: dasselbe Release auf GitHub ------------------------------------
# Der Push-Mirror uebertraegt nur Refs, keine Releases -- die muessen von hier
# aus angelegt werden. Voraussetzung ist, dass der Tag drueben schon angekommen
# ist; darauf wird gewartet, statt es anzunehmen.
if [ "$GITHUB" = "yes" ]; then
	step "Schritt 5/$STEPS: GitHub-Release fuer $TAG ($GH_SLUG)"

	# Steht der Mirror auf "sync_on_commit", hat Schritt 1 den Tag bereits
	# mitgeschickt -- aber asynchron. Wer sofort nachsieht und ihn nicht
	# findet, stoesst einen zweiten Abgleich an; der versucht denselben Tag
	# erneut zu pushen, GitHub weist ihn ab ("reference already exists"), und
	# Forgejo vermerkt einen fehlgeschlagenen Abgleich. Der Eintrag wuerde
	# spaeter ein echtes Problem verdecken. Also erst eine Frist abwarten und
	# nur anstossen, wenn der Mirror sie verstreichen laesst.
	GH_TAG_OK=false
	echo -n "Warte auf den Mirror "
	for _ in $(seq 1 8); do
		if [ "$(http_code "$(gh_api GET "/repos/$GH_SLUG/git/ref/tags/$TAG")")" = "200" ]; then
			GH_TAG_OK=true; break
		fi
		echo -n "."; sleep 5
	done
	echo
	if $GH_TAG_OK; then
		echo "Tag ist auf GitHub - der Mirror hat ihn selbst uebertragen."
	else
		RESP=$(api POST "/push_mirrors-sync")
		case "$(http_code "$RESP")" in
			200|202|204) echo "Mirror-Abgleich angestossen." ;;
			*)           echo "Mirror-Abgleich nicht anstossbar (HTTP $(http_code "$RESP")) - warte auf den Zeitplan." ;;
		esac

		echo -n "Warte, bis der Tag auf GitHub ist "
		for _ in $(seq 1 52); do
			if [ "$(http_code "$(gh_api GET "/repos/$GH_SLUG/git/ref/tags/$TAG")")" = "200" ]; then
				GH_TAG_OK=true; break
			fi
			echo -n "."; sleep 5
		done
		echo
	fi
	$GH_TAG_OK || fail "Tag $TAG ist nach 5 Minuten nicht auf GitHub - Mirror-Protokoll in den Forgejo-Einstellungen pruefen"
	echo "Tag ist da."

	RESP=$(gh_api GET "/repos/$GH_SLUG/releases/tags/$TAG")
	if [ "$(http_code "$RESP")" = "200" ]; then
		GH_RELEASE_ID=$(http_body "$RESP" | jq -r '.id')
		echo "Release existiert bereits (ID $GH_RELEASE_ID) - Text bleibt unveraendert."
	else
		BODY=$(jq -n --arg tag "$TAG" --arg name "$RELEASE_NAME" --arg body "$NOTES" \
		             --argjson pre "$PRERELEASE" --argjson draft "$DRAFT" \
		       '{tag_name:$tag, name:$name, body:$body, prerelease:$pre, draft:$draft}')
		RESP=$(gh_api POST "/repos/$GH_SLUG/releases" -H 'Content-Type: application/json' -d "$BODY")
		[ "$(http_code "$RESP")" = "201" ] || fail "GitHub-Release nicht angelegt (HTTP $(http_code "$RESP")): $(http_body "$RESP")"
		GH_RELEASE_ID=$(http_body "$RESP" | jq -r '.id')
		echo "Release angelegt (ID $GH_RELEASE_ID, Vorabversion=$PRERELEASE, Entwurf=$DRAFT)."
	fi

	RESP=$(gh_api GET "/repos/$GH_SLUG/releases/$GH_RELEASE_ID/assets")
	GH_OLD_ID=$(http_body "$RESP" | jq -r --arg n "$APPIMAGE" '.[] | select(.name==$n) | .id' | head -1)
	if [ -n "$GH_OLD_ID" ]; then
		if $FORCE; then
			RESP=$(gh_api DELETE "/repos/$GH_SLUG/releases/assets/$GH_OLD_ID")
			echo "Vorhandenen Anhang $GH_OLD_ID entfernt (HTTP $(http_code "$RESP"))."
		else
			fail "Anhang $APPIMAGE existiert auf GitHub bereits (ID $GH_OLD_ID) - mit --force ersetzen"
		fi
	fi

	# Anhaenge gehen an uploads.github.com, nicht an api.github.com.
	RESP=$(curl -sS --config <(printf 'header = "Authorization: Bearer %s"\n' "$GH_TOKEN") \
	            -H 'Accept: application/vnd.github+json' \
	            -H 'Content-Type: application/octet-stream' \
	            -X POST -w '\n%{http_code}' --data-binary "@$APPIMAGE" \
	            "https://uploads.github.com/repos/$GH_SLUG/releases/$GH_RELEASE_ID/assets?name=$APPIMAGE")
	[ "$(http_code "$RESP")" = "201" ] || fail "Anhang nicht hochgeladen (HTTP $(http_code "$RESP")): $(http_body "$RESP")"
	GH_ASSET_ID=$(http_body "$RESP" | jq -r '.id')
	echo "Hochgeladen (Anhang-ID $GH_ASSET_ID)."

	if [ -f "$ZSYNC" ]; then
		GH_OLD_ID=$(gh_api GET "/repos/$GH_SLUG/releases/$GH_RELEASE_ID/assets" | http_body | \
		            jq -r --arg n "$ZSYNC" '.[] | select(.name==$n) | .id' | head -1)
		if [ -n "$GH_OLD_ID" ] && $FORCE; then
			gh_api DELETE "/repos/$GH_SLUG/releases/assets/$GH_OLD_ID" >/dev/null
			GH_OLD_ID=""
		fi
		if [ -n "$GH_OLD_ID" ]; then
			fail "Anhang $ZSYNC existiert auf GitHub bereits (ID $GH_OLD_ID) - mit --force ersetzen"
		fi
		RESP=$(curl -sS --config <(printf 'header = "Authorization: Bearer %s"\n' "$GH_TOKEN") \
		            -H 'Accept: application/vnd.github+json' \
		            -H 'Content-Type: application/octet-stream' \
		            -X POST -w '\n%{http_code}' --data-binary "@$ZSYNC" \
		            "https://uploads.github.com/repos/$GH_SLUG/releases/$GH_RELEASE_ID/assets?name=$ZSYNC")
		[ "$(http_code "$RESP")" = "201" ] \
			|| fail "Anhang $ZSYNC nicht hochgeladen (HTTP $(http_code "$RESP")): $(http_body "$RESP")"
		echo "Hochgeladen (Anhang-ID $(http_body "$RESP" | jq -r '.id'), $ZSYNC)."
	fi

	# Gegenprobe wie bei Forgejo: zurueckladen und die Pruefsumme vergleichen.
	# Der Programmstart aus Schritt 4 wird nicht wiederholt -- es ist dieselbe
	# Datei, und die Pruefsumme belegt das.
	#
	# Die API-URL leitet auf Amazons S3 um, das einen mitgeschickten
	# Authorization-Kopf mit HTTP 400 abweist. curl ab 7.76 entfernt den Kopf
	# beim Wirtswechsel von selbst; auf aelteren Fassungen muesste man
	# stattdessen ueber browser_download_url ohne Anmeldung laden.
	GH_DL="$TMPDIR_DL/github-$APPIMAGE"
	curl -sS -L --config <(printf 'header = "Authorization: Bearer %s"\n' "$GH_TOKEN") \
	     -H 'Accept: application/octet-stream' \
	     -o "$GH_DL" "https://api.github.com/repos/$GH_SLUG/releases/assets/$GH_ASSET_ID"
	GH_SHA=$(sha256sum "$GH_DL" | cut -d' ' -f1)
	echo "Zurueckgeladen: $(stat -c %s "$GH_DL") Bytes"
	echo "SHA-256:        $GH_SHA"
	[ "$GH_SHA" = "$SHA_LOCAL" ] || fail "Pruefsumme auf GitHub weicht ab"
	echo "Pruefsumme stimmt - byteweise identisch."
fi

echo
echo "Fertig: https://${FORGEJO_HOST}:${FORGEJO_PORT}/${REPO_OWNER}/${REPO_NAME}/releases/tag/${TAG}"
if [ "$GITHUB" = "yes" ]; then
	echo "        https://github.com/${GH_SLUG}/releases/tag/${TAG}"
fi
