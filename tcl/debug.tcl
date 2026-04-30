# ======================================================================
# Copyright: (C) 2026 Scidb contributors
# ======================================================================
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# ======================================================================

::util::source debug-menu

namespace eval debug {
namespace eval mc {

set Debugging         "De&bugging"
set BuildMode         "Build: %s"
set DebugBuild        "Debug"
set ReleaseBuild      "Release"
set StderrToFile      "Log stderr to file"
set StderrActive      "Active log: %s"
set EngineLog         "Open engine communication log..."
set OpenLogFolder     "Open log folder"

}


variable Options
array set Options {
	stderrToFile   0
}
variable LogFile ""


proc logDir {} {
	return [file join $::scidb::dir::user logs]
}


proc ensureLogDir {} {
	set dir [logDir]
	if {![file isdirectory $dir]} {
		file mkdir $dir
	}
	return $dir
}


proc toggleStderr {} {
	variable Options
	variable LogFile

	set Options(stderrToFile) [expr {!$Options(stderrToFile)}]
	if {$Options(stderrToFile)} {
		if {[lsearch -exact [info commands ::scidb::misc::*] ::scidb::misc::setLogFile] < 0} {
			set Options(stderrToFile) 0
			after idle [list tk_messageBox -type ok -icon warning \
				-title $::scidb::app \
				-message "::scidb::misc::setLogFile nicht verfügbar.\nBitte Programm neu bauen (make)."]
			return
		}
		set dir [ensureLogDir]
		set date [clock format [clock seconds] -format "%Y%m%d-%H%M%S"]
		set LogFile [file join $dir "stderr-$date.log"]
		if {[catch { ::scidb::misc::setLogFile $LogFile } err]} {
			set Options(stderrToFile) 0
			set LogFile ""
			after idle [list tk_messageBox -type ok -icon error \
				-title $::scidb::app \
				-message "Stderr-Protokollierung fehlgeschlagen:\n$err"]
		}
	} else {
		catch { ::scidb::misc::setLogFile "" }
		set LogFile ""
	}
}


proc openLogFolder {} {
	set dir [ensureLogDir]
	catch { exec xdg-open $dir & }
}


proc buildMenu {m} {
	variable Options

	# Build mode info (read-only status line)
	set mode [expr {[::scidb::misc::debug?] ? $mc::DebugBuild : $mc::ReleaseBuild}]
	$m add command \
		-label " [format $mc::BuildMode $mode]" \
		-state disabled \
		;

	$m add separator

	# Stderr → log file toggle
	set chkImg [expr {$Options(stderrToFile) \
		? $::theme::icon::14x14::checkYes \
		: $::theme::icon::14x14::checkNo}]
	$m add command \
		-label " $mc::StderrToFile" \
		-image $chkImg \
		-compound left \
		-command [namespace code toggleStderr] \
		;

	# Active log file info (shown only when active)
	variable LogFile
	if {$LogFile ne ""} {
		$m add command \
			-label " [format $mc::StderrActive [file tail $LogFile]]" \
			-state disabled \
			;
	}

	$m add separator

	# Engine communication log
	set engineState [expr {[::engine::logIsOpen? .application] ? "disabled" : "normal"}]
	$m add command \
		-label " $mc::EngineLog" \
		-state $engineState \
		-command { ::engine::openEngineLog .application } \
		;

	$m add separator

	# Open log folder in file manager
	$m add command \
		-label " $mc::OpenLogFolder" \
		-command [namespace code openLogFolder] \
		;
}


proc WriteOptions {chan} {
	::options::writeItem $chan [namespace current]::Options
}

::options::hookWriter [namespace current]::WriteOptions


proc init {} {
	variable Options
	if {$Options(stderrToFile)} {
		set Options(stderrToFile) 0
		toggleStderr
	}
}

} ;# namespace debug

# vi:set ts=3 sw=3:
