#!/bin/sh
#! ======================================================================
#! $RCSfile: tk_init.h,v $
#! $Revision: 1507 $
#! $Date: 2018-08-13 12:17:53 +0000 (Mon, 13 Aug 2018) $
#! $Author: gregor $
#! ======================================================================

#! ======================================================================
#!    _/|            __
#!   // o\         /    )           ,        /    /
#!   || ._)    ----\---------__----------__-/----/__-
#!   //__\          \      /   '  /    /   /    /   )
#!   )___(     _(____/____(___ __/____(___/____(___/_
#! ======================================================================

#! ======================================================================
#! Copyright: (C) 2009-2013 Gregor Cramer
#! ======================================================================

#! ======================================================================
#! This program is free software; you can redistribute it and/or modify
#! it under the terms of the GNU General Public License as published by
#! the Free Software Foundation; either version 2 of the License, or
#! (at your option) any later version.
#! ======================================================================

#! The "\" at the end of the comment line below is necessary! It means
#! that the "exec" line is a comment to Tcl/Tk, but not to /bin/sh.
#! The next line restarts using tkscidc: \
exec "`dirname "$0"`"/tk`basename $0` "$0" ${1+"$@"}

package require Tcl 8.6
package require Tk  8.6
package require Ttk
package require tkscidc


namespace eval scidc {
	set app		Scidc
	set version "26.05.30 b8 Beta"
}


wm withdraw .


set nameofexecutable [info nameofexecutable]
if {[llength $nameofexecutable] == 0} {
	if {$tcl_platform(platform) eq "unix"} {
		catch { set nameofexecutable [exec readlink /proc/[pid]/exe] }
	}
	if {[llength $nameofexecutable] == 0} {
		append msg "You've installed a broken Tcl/Tk library (version [info patchlevel])."
		tk_messageBox -type ok -icon error -title "$scidc::app: broken library" -message $msg
		exit 1
	}
}
set nameofexecutable [file normalize $nameofexecutable]


if {[::scidc::misc::version] ne $scidc::version} {
	wm withdraw .
	if {$tcl_platform(platform) eq "windows"} {
		append msg "This is $scidc::app version [::scidc::misc::version], but the scidb.gui "
		append msg "data file has the version number $scidc::version."
	} else {
		append msg "This is $scidc::app version '$scidc::version', but the "
		append msg "[file tail $nameofexecutable] program it uses is "
		append msg "version '[::scidc::misc::version]'."
	}
	tk_messageBox -type ok -icon error -title "$scidc::app: version error" -message $msg
	exit 1
}



namespace eval process {

set ProgramOptions [list                                                                     \
	[list "--"                      "Only file names after this"]                             \
	[list "--help"                  "Print help (this message) and exit"]                     \
	[list "--version"               "Print version information and exit"]                     \
	[list "--full-screen"           "Start program with full-screen modus"]                   \
	[list "--initial-layout"        "Start program with intitial layout"]                     \
	[list "--reset-fonts"           "Reset all fonts to default size"]                        \
	[list "--show-board"            "Switch to board tab immediately after startup"]          \
	[list "--re-open"               "Re-open databases from last session"]                    \
	[list "--fast-load"             "Do only load the mandatory files at startup"]            \
	[list "--first-time"            "Delete option file and recovery files at startup"        \
	                                "(starting $::scidc::app as it would be the first time)"] \
	[list "--recover-options"       "Recover option files deleted with last '--first-time'"]  \
	[list "--elo-only"              "Do not load rating files except ELO rating"]             \
	[list "--print-recovery-files"  "Print recovery files from last session and exit"]        \
	[list "--delete-recovery-files" "Delete recovery files and exit"]                         \
	[list "--dont-recover-files"    "Do not recover unsaved games from last session"]         \
	[list "--recover-old-files"     "Recover games from older sessions"                       \
	                                "(will skip games from last session)"]                    \
	[list "--single-process"        "Forcing a single process of $::scidc::app"               \
	                                "(you shouldn't use this option; only for testing)"]      \
	[list "--update-themes"         "Update themes (from shared directory)"]                  \
	[list "--force-grab"            "Do not suppress grabs in debug mode"                     \
	                                "(only for debugging)"]                                   \
]

array set Options {}
variable Arguments {}


proc arguments {} { return [set [namespace current]::Arguments] }


proc testOption {arg} {
	set rc 0
	catch { set rc [set [namespace current]::Options($arg)] }
	return $rc
}


proc setOption {arg {value 1}} {
	set [namespace current]::Options($arg) $value
}


proc ParseArgs {} {
	global argc argv
	variable Options
	variable Arguments
	variable ProgramOptions

	for {set i 0} {$i < $argc} {incr i} {
		set arg [lindex $argv $i]
		if {$arg eq "--"} {
			incr i
			break
		}
		if {$arg eq "--session-id"} {
			incr i
			continue
		}
		if {[string range $arg 0 1] ne "--"} {
			break
		}

		set option [string range $arg 2 end]
		set Options($option) 1

		if {[lsearch -exact -index 0 $ProgramOptions $arg] == -1} {
			puts stderr "Unrecognized option: $arg"
		}
	}

	if {[::scidc::misc::debug?]} {
		set Options(single-process) 1
	}

	set Arguments [lrange $argv $i end]
}

ParseArgs


if {[testOption help]} {
	puts "$::scidc::app version $::scidc::version"
	puts ""
	puts "Usage: $::argv0 \[options ...] \[database ...]"
	puts ""
	puts "Options:"

	set maxlen 0
	foreach opts $ProgramOptions {
		set maxlen [expr {max($maxlen, [string length [lindex $opts 0]])}]
	}
	foreach opts $ProgramOptions {
		set i 0
		foreach s $opts {
			if {$i == 0} {
				puts -nonewline "  "
				puts -nonewline $s
				set spaces [expr {$maxlen + 1 - [string length $s]}]
			} else {
				puts -nonewline [string repeat " " $spaces]
				puts $s
				set spaces [expr {$maxlen + 3}]
			}
			incr i
		}
	}

	puts ""
	puts "Options recognised by GUI (Tk) library:"
	puts "  -geometry GEOMETRY      Use GEOMETRY for initial geometry"
	puts "  -display DISPLAY        Run $::scidc::app on DISPLAY"
	puts "  -sync                   Use synchronous mode for display server"
	exit 0
}

unset ProgramOptions

} ;# namespace process


namespace eval remote {
namespace eval mc {

set PostponedMessage "Opening of database \"%s\" is postponed until current operation will be finished."

}


array set Vars {
	after		{}
	pending	{}
	busy		0
}


proc blocked? {} {
	return $::scidc::intern::blocked
}


proc pending? {} {
	variable Vars
	return [expr {!$::scidc::intern::blocked && !$Vars(busy) && $::scidc::intern::postponed}]
}


proc busyOperation {cmd} {
	variable Vars

	incr Vars(busy)
	set code [catch {uplevel 1 $cmd} result options]
	incr Vars(busy) -1
	if {$::scidc::intern::postponed} {
		after idle [namespace code update]
	}
	if {$code == 0} {
		return $result
	}
	array set opts $options
	return \
		-code $opts(-code) \
		-errorcode $opts(-errorcode) \
		-errorinfo $opts(-errorinfo) \
		-rethrow 1 \
		$result \
	;
}


proc update {} {
	variable Vars

	if {[pending?]} {
		after cancel $Vars(after)
		set Vars(after) [after idle [namespace code Update]]
	}
}


proc cleanup {} {
	set [namespace current]::Vars(pending) {}
}


proc requestOpenBases {pathList} {
	variable Vars

	if {[llength $pathList]} {
		if {$::scidc::intern::blocked} {
			foreach path $pathList {
				if {![info exists Vars(infoBox:$path)]} {
					set ::scidc::intern::postponed 1
					lappend Vars(pending) $path
					set msg [format $mc::PostponedMessage $path]
					set Vars(infoBox:$path) \
						[::dialog::info -buttons {} -title $::scidc::app -message $msg -topmost yes]
				}
			}
		} else {
			openBases $pathList
		}
	}
}


proc Update {} {
	variable Vars

	if {[llength $Vars(pending)] == 0} { return }

	foreach path $Vars(pending) {
		if {[info exists Vars(infoBox:$path)]} {
			if {[winfo exists $Vars(infoBox:$path)]} {
				destroy $Vars(infoBox:$path)
			}
			unset Vars(infoBox:$path)
		}
	}

	set files $Vars(pending)
	set Vars(pending) {}
	set ::scidc::intern::postponed 0
	openBases $files
}


proc SendPath {port} {
	global argc
	global argv

	set args {}

	for {set i 0} {$i < $argc} {incr i} {
		set arg [lindex $argv $i]

		if {[string index $arg 0] ne "-"} {
			lappend args $arg
		}
	}
	
	set chan [socket 127.0.0.1 $port]
	puts $chan $args
	flush $chan
	close $chan
}


proc Incoming {chan addr port} {
#	fconfigure $chan -blocking 0
	fileevent $chan readable [namespace code [list IncomingOffered $chan]]
}


proc IncomingOffered {chan} {
	if {[gets $chan pathList] >= 0} {
		fileevent $chan readable {}
#		fconfigure $chan -blocking 1
		after idle [namespace code [list requestOpenBases $pathList]]
	}
}


#proc Vwait {varname} {
#	set ::scidc::intern::blocked 1
#	set code [catch {uplevel 1 [list ::remote::VwaitOrig $varname]} res]
#	set ::scidc::intern::blocked 0
#
#	after idle ::remote::update
#	return -code $code $res
#}
#
#rename ::vwait ::remote::VwaitOrig
#rename ::remote::Vwait ::vwait


if {	![::process::testOption single-process]
	&& ![::process::testOption version]
	&& ![::process::testOption print-recovery-files]} {

	# Pick a port number based on the name of the main script executing
	set port [expr {1024 + [::scidc::misc::crc32 [file normalize $::argv0]] % 30000}]

	if {[catch {socket -server [namespace code Incoming] -myaddr localhost $port} err]} {
		lassign $::errorCode cls name
		if {$cls eq "POSIX" && $name eq "EADDRINUSE"} {
			SendPath $port
			exit 1
		}
	}
	unset -nocomplain err
}

} ;# namespace remote

# vi:set ts=3 sw=3:
