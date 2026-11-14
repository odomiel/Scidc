#!/bin/bash
# ======================================================================
# Installiert die Git-Haken dieses Projekts nach .git/hooks/.
#
# Die Haken liegen nicht im Repository -- .git/hooks ist nicht
# versioniert. Ein frischer Klon hat sie also nicht, und damit faellt
# die Pruefung weg, die einen Commit mit auseinanderlaufenden Versionen
# oder roter Pruefreihe abweist. Dieses Skript holt sie aus
# tools/hooks/ nach.
#
#   bash tools/install-hooks.sh            # installieren
#   bash tools/install-hooks.sh --force    # vorhandenen Haken ersetzen
#   bash tools/install-hooks.sh --diff     # Unterschied zeigen
# ======================================================================

set -euo pipefail

cd "$(dirname "$0")/.."

QUELLE=tools/hooks
ZIEL=$(git rev-parse --git-path hooks 2>/dev/null || echo .git/hooks)

if [ ! -d "$QUELLE" ]; then
	echo "FEHLER: $QUELLE gibt es nicht -- falsches Verzeichnis?" >&2
	exit 1
fi

if [ ! -d "$ZIEL" ]; then
	echo "FEHLER: $ZIEL gibt es nicht -- kein Git-Arbeitsbaum?" >&2
	exit 1
fi

MODUS=install
case "${1:-}" in
	--force) MODUS=force ;;
	--diff)  MODUS=diff ;;
	"")      ;;
	*)       echo "unbekannte Option: $1" >&2; exit 1 ;;
esac

ersetzt=0
gleich=0
abweichend=0

for pfad in "$QUELLE"/*; do
	name=$(basename "$pfad")
	ziel="$ZIEL/$name"

	if [ -f "$ziel" ] && cmp -s "$pfad" "$ziel"; then
		gleich=$((gleich + 1))
		continue
	fi

	if [ -f "$ziel" ] && [ "$MODUS" = install ]; then
		abweichend=$((abweichend + 1))
		echo "$name steht schon in $ZIEL und weicht ab."
		echo "  Unterschied:  diff $ziel $pfad"
		echo "  Ersetzen:     bash tools/install-hooks.sh --force"
		continue
	fi

	if [ "$MODUS" = diff ]; then
		abweichend=$((abweichend + 1))
		diff "$ziel" "$pfad" || true
		continue
	fi

	cp "$pfad" "$ziel"
	chmod 0755 "$ziel"
	ersetzt=$((ersetzt + 1))
	echo "$name installiert nach $ZIEL"
done

echo "Haken: $ersetzt installiert, $gleich unveraendert, $abweichend abweichend"

# Ein abweichender Haken ist kein Fehlschlag des Skripts, sondern eine
# Entscheidung des Benutzers -- gemeldet wird es, abgebrochen nicht.
exit 0
