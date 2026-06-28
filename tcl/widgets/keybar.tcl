# ======================================================================
# Author : $Author: gcramer $
# Version: $Revision: 1519 $
# Date   : $Date: 2018-09-11 11:41:52 +0000 (Tue, 11 Sep 2018) $
# Url    : $URL: file:///svn/p/scidb/code/trunk/tcl/widgets/keybar.tcl $
# ======================================================================

# ======================================================================
#    _/|            __
#   // o\         /    )           ,        /    /
#   || ._)    ----\---------__----------__-/----/__-
#   //__\          \      /   '  /    /   /    /   )
#   )___(     _(____/____(___ __/____(___/____(___/_
# ======================================================================

# ======================================================================
# Copyright: (C) 2018 Gregor Cramer
# ======================================================================

# ======================================================================
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# ======================================================================

::util::source key-bar

proc keybar {w {keys {}}} {
	return [keybar::Build $w $keys]
}

namespace eval keybar {

proc tr {text} { return $text }
proc defaultCSS {} { return "" }


# Die keybar-Tasten werden mit dem TTK-Theme gerendert (Widget-Hintergrund =
# [::theme::getColor background]) und muessen sich daher am tatsaechlichen Theme
# orientieren, nicht am unabhaengigen Color-Scheme. Sonst erscheinen bei
# Scheme=dark + hellem TTK-Theme dunkle Tasten auf hellem Dialog (und umgekehrt).
proc Variant {} {
	if {[catch { winfo rgb . [::theme::getColor background] } rgb]} {
		return [expr {$::colors::Scheme eq "lite" ? "lite" : "dark"}]
	}
	lassign $rgb r g b
	set lum [expr {(0.299*$r + 0.587*$g + 0.114*$b)/65535.0}]
	return [expr {$lum < 0.5 ? "dark" : "lite"}]
}


proc Color {key} {
	set variant [Variant]
	if {[info exists ::colors::Colors($variant:keybar,$key)]} {
		return $::colors::Colors($variant:keybar,$key)
	}
	return [::colors::lookup keybar,$key]
}


proc BuildCSS {} {
	set bg     [Color background]
	set fg     [Color foreground]
	set bl     [Color border-light]
	set bd     [Color border-dark]
	set hover  [Color hover]
	set css [defaultCSS]
	append css "
		kbd.key {
			font-size: smaller;
			border-width: 0.2em;
			border-style: solid;
			border-color: $bl $bd $bd $bl;
			padding: 0;
			background: $bg;
			color: $fg;
			white-space: nowrap;
		}
		body { padding: 0; border: 0; margin: 0; display: block; }
	"
	# TODO: background not working; why?
	append css ":hover { text-decoration: none; background: $hover; }"
	return $css
}


proc Build {w keys} {
	namespace eval [namespace current]::$w {}
	::html $w \
		-takefocus 0 \
		-width 0 \
		-background [::theme::getColor background] \
		-usehorzscroll no \
		-usevertscroll no \
		-fontsize [expr {abs([font configure TkTextFont -size])}] \
		-fittowidth yes \
		-fittoheight no \
		-css [BuildCSS] \
		;
	bind $w <<LanguageChanged>> [namespace code [list LanguageChanged $w]]
	bind $w <<ThemeChanged>> [namespace code [list ThemeChanged $w]]
	$w onmouseover [list [namespace current]::MouseEnter $w]
	$w onmouseout  [list [namespace current]::MouseLeave $w]
	$w onmousedown1 [list [namespace current]::MouseDown $w]
	catch { rename ::$w $w.__html__ }
	proc ::$w {command args} "[namespace current]::WidgetProc $w \$command {*}\$args"
	$w keys $keys
	return $w
}


proc WidgetProc {w command args} {
	if {$command ne "keys"} {
		return [$w.__html__ $command {*}$args]
	}
	if {[llength $args] != 1} {
		error "wrong # args: should be \"[namespace current] $command <list-of-key-tip-pairs>\""
	}
	variable ${w}::Keys
	set Keys [lindex $args 0]
	set content ""
	foreach {key tip} $Keys {
		append content "<kbd class='key' tip='$tip' key='$key'>[tr $key]</kbd>"
	}
	if {[string length $content] == 0} {
		$w.__html__ clear
	} else {
		$w.__html__ parse $content
	}
	return $w
}


proc LanguageChanged {w} {
	variable ${w}::Keys
	$w keys $Keys
}


proc ThemeChanged {w} {
	variable ${w}::Keys
	catch { $w.__html__ configure -background [::theme::getColor background] -css [BuildCSS] }
	$w keys $Keys
}


proc MouseDown {w nodes} {
	tooltip hide
	foreach node $nodes {
		if {[$node tag] eq "kbd"} {
			event generate $w <<KeybarPress>> -data [$node attribute key]
		}
	}
}


proc MouseEnter {w nodes} {
	foreach node $nodes {
		if {[$node tag] eq "kbd"} {
			$node dynamic set hover
			set tip [set [$node attribute tip]]
			if {[string length $tip]} {
				tooltip show $w $tip
			}
			return
		}
	}
}


proc MouseLeave {w nodes} {
	foreach node $nodes {
		if {[$node tag] eq "kbd"} {
			$node dynamic clear hover
		}
	}
	tooltip hide
}

} ;# namespace keybar

# vi:set ts=3 sw=3:
