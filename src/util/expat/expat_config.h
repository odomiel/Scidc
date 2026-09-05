/* ======================================================================
 * expat_config.h -- von Hand gepflegt, NICHT von expats configure erzeugt.
 *
 * Alle uebrigen Dateien in diesem Verzeichnis sind eine unveraenderte
 * Kopie von lib/ aus expat 2.8.4. Beim Nachziehen einer neuen Fassung
 * wird lib/ neu kopiert und nur diese Datei behalten.
 *
 * Die Auswahl weicht bewusst von dem ab, was expats configure auf dem
 * Bausystem erzeugen wuerde:
 *
 *   * Entropie ueber den Systemaufruf getrandom (HAVE_SYSCALL_GETRANDOM),
 *     nicht ueber arc4random_buf/getentropy. Die Bibliotheksfunktionen
 *     verlangen glibc >= 2.36 bzw. >= 2.25; der Systemaufruf laeuft auf
 *     jedem Linux ab 3.17 und bindet damit kein neueres glibc-Symbol in
 *     das AppImage ein, als der uebrige Baum ohnehin braucht.
 *   * XML_DEV_URANDOM als Rueckfallweg, falls getrandom scheitert --
 *     ohne ihn faellt expat auf Zeit und Prozessnummer zurueck, was den
 *     Hashschutz gegen praeparierte Eingaben entwertet.
 *
 * XML_DTD/XML_NS/XML_GE/XML_CONTEXT_BYTES entsprechen den Vorgaben von
 * expat und dem, was die Distributionen ausliefern.
 * ====================================================================== */

#ifndef EXPAT_CONFIG_H
#define EXPAT_CONFIG_H 1

/* --- Bytereihenfolge: vom Uebersetzer erfragen, nicht raten ---------- */

#if defined(__BYTE_ORDER__) && defined(__ORDER_BIG_ENDIAN__)
#  if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
#    define BYTEORDER 4321
#    define WORDS_BIGENDIAN 1
#  else
#    define BYTEORDER 1234
#  endif
#else
#  error "Bytereihenfolge unbekannt -- BYTEORDER von Hand setzen."
#endif

/* --- Entropiequelle -------------------------------------------------- */

#define HAVE_SYSCALL_GETRANDOM 1
#define XML_DEV_URANDOM 1

/* --- Funktionsumfang ------------------------------------------------- */

#define XML_DTD 1
#define XML_NS 1
#define XML_GE 1
#define XML_CONTEXT_BYTES 1024

#endif /* ndef EXPAT_CONFIG_H */
