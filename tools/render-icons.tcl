# ======================================================================
# Rastert icons/scidc-logo.svg in alle Groessen, die der Baum braucht.
#
# Aufruf (Tk wird zum Rastern gebraucht, die Systemschale reicht nicht):
#   LD_LIBRARY_PATH=deps/tcltk/lib deps/tcltk/bin/wish9.0 tools/render-icons.tcl
#
# Tk 9 liest SVG selbst (nanosvg) und schreibt PNG -- deshalb kommt der Baum
# ohne ImageMagick, Inkscape oder Pillow aus.
#
# Die Zieldateien behalten ihre alten Namen ("Scidb-Logo-...", "scidb-...").
# Umbenennen haette Verweise in build-appimage.sh, freedesktop.org/Makefile,
# den Hilfeseiten und im Tcl-Code nach sich gezogen; der Name ist hier
# Schnittstelle, nicht Aussage.
#
# Zwei Vorlagen: mit Rand fuer die grossen Groessen, randlos fuer die
# kleinen, wo die zwei Randpixel spuerbar fehlen.
# ======================================================================

package require Tk
wm withdraw .

set root [file normalize [file join [file dirname [info script]] ..]]
cd $root

set padded  icons/scidc-logo.svg
set cropped icons/scidc-logo-cropped.svg

# {Zieldatei Vorlage Kantenlaenge}
set targets {
    icons/Scidb-Logo-16x16.png                padded   16
    icons/Scidb-Logo-24x24.png                padded   24
    icons/Scidb-Logo-32x32.png                padded   32
    icons/Scidb-Logo-48x48.png                padded   48
    icons/Scidb-Logo-64x64.png                padded   64
    icons/Scidb-Logo-128x128.png              padded  128
    icons/Scidb-Logo-cropped-16x16.png        cropped  16
    icons/Scidb-Logo-cropped-32x32.png        cropped  32
    icons/Scidb-Logo-cropped-104x104.png      cropped 104
    freedesktop.org/scidb-16.png              cropped  16
    freedesktop.org/scidb-22.png              cropped  22
    freedesktop.org/scidb-32.png              padded   32
    freedesktop.org/scidb-48.png              padded   48
    freedesktop.org/scidb-64.png              padded   64
    freedesktop.org/scidb-128.png             padded  128
    tcl/images/Scidb-Logo-128.png             padded  128
    tcl/help/images/scidb-logo.png            padded  128
}

# --- Startbild ---------------------------------------------------------
# tcl/splash.tcl traegt das Bild base64-eingebettet. Frueher war das ein
# JPEG; stock-wish kann JPEG nicht lesen (der Decoder steckt im geforkten
# Tk des Programms), PNG dagegen schon -- deshalb hier PNG.
proc renderSplash {} {
    set svg icons/scidc-splash.svg
    set tcl tcl/splash.tcl
    if {![file readable $svg] || ![file readable $tcl]} {
        puts stderr "  FEHLT: $svg oder $tcl"; exit 1
    }
    set img [image create photo -file $svg -format {svg -scale 1.0}]
    set tmp [file join [file dirname $tcl] .splash-tmp.png]
    $img write $tmp -format png
    image delete $img

    set f [open $tmp rb]; set png [read $f]; close $f
    file delete $tmp
    set b64 [binary encode base64 -maxlen 66 $png]

    set f [open $tcl r]; set text [read $f]; close $f
    set marker "set Picture \[image create photo -data \{"
    set i [string first $marker $text]
    if {$i < 0} { puts stderr "  Startbild-Block in $tcl nicht gefunden"; exit 1 }
    set open [expr {$i + [string length $marker]}]
    set close [string first "\n\}\]" $text $open]
    if {$close < 0} { puts stderr "  Ende des Startbild-Blocks nicht gefunden"; exit 1 }

    set body ""
    foreach line [split $b64 \n] { append body "\t$line\n" }
    set text [string replace $text $open [expr {$close}] "\n$body"]

    set f [open $tcl w]; puts -nonewline $f $text; close $f
    puts [format "  %-42s %3dx%-3d %s" $tcl 570 428 "Startbild eingebettet"]
}

set count 0
foreach {target which size} $targets {
    set svg [expr {$which eq "cropped" ? $cropped : $padded}]
    if {![file readable $svg]} { puts stderr "  FEHLT: $svg"; exit 1 }

    set img [image create photo -file $svg -format [list svg -scale [expr {$size/128.0}]]]
    if {[image width $img] != $size || [image height $img] != $size} {
        puts stderr "  $target: [image width $img]x[image height $img] statt ${size}x${size}"
        exit 1
    }
    $img write $target -format png
    image delete $img
    puts [format "  %-42s %3dx%-3d %s" $target $size $size $which]
    incr count
}

renderSplash
puts "  $count Dateien erzeugt, dazu das Startbild."
exit
