#!/bin/bash
# ======================================================================
# Lage 2 unter -fsanitize=undefined
# ======================================================================
#
# Warum ueberhaupt: einige Zusagen der Bit-Funktionen und der
# Aufzaehlungen lassen sich am Ergebnis *nicht* pruefen. Ein Schieben um
# die volle Typweite ist undefiniert, der x86-Befehl maskiert die Weite
# aber selbst -- src/tests/t_bit_functions.cpp ist deshalb am alten Stand
# gruen. Erst der Sanitizer zeigt den Verstoss.
#
# Warum ein eigener Objektbaum: dieselben .o-Pfade wie der normale Bau.
# Wuerde hier in src/ uebersetzt, truege der naechste `make` instrumentierte
# Objekte in tkscidc-beta -- und ohne -fsanitize am Binder bliebe der Lauf
# an fehlenden Symbolen haengen. Darum ein Schattenbaum aus Verweisen
# (build-ubsan/, gitignored): Verzeichnisse echt, Dateien verlinkt, die
# Objekte landen dort.
#
# Instrumentiert wird nur eigener Code (mstl, sys, util, db, app). Die
# Fremdbibliotheken (libTeXt, libharu, libhyphenate, minizip, expat, zlib,
# zziplib) kommen gebaut aus dem echten Baum: der Sanitizer wirkt je
# Uebersetzungseinheit, und ihre Treffer waeren hier nicht zu verantworten.
#
# Aufruf: bash tools/check-ubsan.sh [Gruppe ...]
#         make -C src check-ubsan

set -euo pipefail

cd "$(dirname "$0")/.."
WURZEL=$PWD
SCHATTEN=build-ubsan

if [ ! -f Makefile.in ]; then
	echo "Makefile.in fehlt -- zuerst ./configure aufrufen." >&2
	exit 1
fi

# -fno-sanitize=vptr: der Zeigerpruefer verlangt Typinformation zu jeder
# polymorphen Klasse. db::BpgnReader hat keine Schluesselfunktion in
# einer eigenen Uebersetzungseinheit, also bleibt "typeinfo for
# db::BpgnReader" ungebunden und es wird gar nicht erst gebunden. Die
# hier gesuchten Verstoesse (Schieben, Aufzaehlung, Grenzen, Ausrichtung)
# haengen nicht daran.
UB="-fsanitize=undefined -fno-sanitize=vptr -fno-omit-frame-pointer"
SYSLD=$(sed -n 's/^SYS_LDFLAGS *= *//p' Makefile.in)

# EXTRA_CXXFLAGS wird hier *ergaenzt*, nicht ersetzt: in Makefile.in stehen
# -std=c++14, -DBROKEN_LINKER_HACK=1, -DDONT_USE_GDB und die dreizehn
# -Werror=-Kategorien. Eine Zuweisung auf der Kommandozeile gewinnt gegen
# die Datei -- ohne den Vorrat baut der Schatten ohne den Linker-Hack, und
# Board::initialize() stolpert schon beim Start in eine Zusicherung.
BASIS=$(sed -n 's/^EXTRA_CXXFLAGS *= *//p' Makefile.in)

# Die Fremdbibliotheken muessen im echten Baum liegen; sie werden hier
# nur verlinkt, nicht uebersetzt.
FREMD=""
for lib in util/libTeXt/libTeXt.a util/libharu/libharu.a \
           util/libhyphenate/libhyphenate.a util/minizip/libminizip.a; do
	if [ ! -f "src/$lib" ]; then
		echo "src/$lib fehlt -- zuerst einmal make im echten Baum laufen lassen." >&2
		exit 1
	fi
	FREMD="$FREMD $WURZEL/src/$lib"
done

# ---------------------------------------------------------------- Schatten
# ln -sfn je Datei; vorhandene Objekte bleiben also zwischen zwei Laeufen
# liegen und der Bau ist inkrementell.
echo "Schattenbaum $SCHATTEN/ auffrischen"
mkdir -p "$SCHATTEN"
for f in Makefile.in Makefile.version; do
	ln -sfn "$WURZEL/$f" "$SCHATTEN/$f"
done
find src -type d -not -path '*/.*' -printf '%p\n' | while read -r d; do
	mkdir -p "$SCHATTEN/$d"
done
find src -type f -not -path '*/.*' \
     -not -name '*.o' -not -name '*.a' -not -name '*.d' -printf '%p\n' | while read -r f; do
	ln -sfn "$WURZEL/$f" "$SCHATTEN/$f"
done

# ------------------------------------------------------------------- Bauen
# make kennt die Uebersetzungsschalter nicht: aendert sich $UB, bleiben die
# Objekte des vorigen Laufs liegen und das Ergebnis ist gemischt. Darum ein
# Stempel -- weicht er ab, wird der Objektbestand des Schattens verworfen.
STEMPEL=$SCHATTEN/.ubsan-flags
if [ "$(cat "$STEMPEL" 2>/dev/null || true)" != "$BASIS $UB" ]; then
	echo "Schalter haben sich geaendert -- Objektbestand des Schattens verwerfen"
	find "$SCHATTEN" -name '*.o' -delete
	find "$SCHATTEN" -name '*.a' -delete
	find "$SCHATTEN" -name '*.d' -delete
	printf '%s' "$BASIS $UB" > "$STEMPEL"
fi

EIGEN="mstl sys util util/universalchardet db app"
for d in $EIGEN; do
	echo "Uebersetze $d mit $UB"
	make -C "$SCHATTEN/src/$d" EXTRA_CXXFLAGS="$BASIS $UB" >/dev/null
done

LIBS="app/libapp.a db/libdb.a mstl/libmstl.a util/libutil.a sys/libsys.a"
LIBS="$LIBS util/universalchardet/libchardet.a$FREMD mstl/libmstl.a"

make -C "$SCHATTEN/src" dbtest \
	EXTRA_CXXFLAGS="$BASIS $UB" \
	LDFLAGS="$UB $SYSLD" \
	LIBS="$LIBS" \
	MINIZIP_LIB=""

# ------------------------------------------------------------------ Laufen
# Uebersetzt wird *mit* Fortsetzung (kein -fno-sanitize-recover), der Abbruch
# kommt aus halt_on_error -- so laesst sich derselbe Bau mit
#   UBSAN_OPTIONS=halt_on_error=0 build-ubsan/src/dbtest
# auch vollstaendig ausfragen, statt am ersten Fund zu enden. Vorgabe ist der
# Abbruch, damit der Rueckgabewert als Tor taugt.
export UBSAN_OPTIONS="${UBSAN_OPTIONS:-print_stacktrace=1:halt_on_error=1}"
echo
exec "$SCHATTEN/src/dbtest" "$@"
