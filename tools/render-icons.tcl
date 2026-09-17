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

puts "  $count Dateien erzeugt."
exit
