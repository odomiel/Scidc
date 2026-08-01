# ======================================================================
# Bezug von Schach-Engines direkt von den Seiten der Originalprojekte.
#
# Der Katalog (engines/downloads.dat) nennt je Engine eine feste Version
# mit URL, Groesse und SHA-256. Die Pruefsummen stammen aus GitHubs
# digest-Feld bzw. wurden beim Erstellen des Katalogs berechnet; jede
# geladene Datei wird dagegen geprueft, bevor sie ausfuehrbar gemacht
# wird. Ueber "nach neueren Versionen suchen" laesst sich zusaetzlich
# die jeweils aktuelle Veroeffentlichung abfragen.
# ======================================================================

# ======================================================================
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# ======================================================================

namespace eval engine {
namespace eval download {
namespace eval mc {

set Title					"Download Engines"
set Engine					"Engine"
set Version					"Version"
set State					"State"
set Size						"Size"
set Processor				"Processor"

set Installed				"installed"
set NotInstalled			"not installed"
set Newer					"update available"

set Download				"Download"
set Remove					"Remove"
set CheckForUpdates		"Search for newer versions"
set ProjectPage			"Project page"

set Downloading			"Downloading %s (%s)..."
set Verifying				"Checking the checksum..."
set Extracting				"Extracting..."
set Registering			"Registering engine..."
set Succeeded				"%s has been installed."
set Failed					"Installation of %s failed: %s"
set Removed					"%s has been removed."

set NoDownloader			"Neither wget nor curl was found."
set NoChecksumTool		"No program for SHA-256 checksums was found."
set ChecksumMismatch		"The checksum of the downloaded file does not match. The file has been discarded."
set NoSuitableBuild		"The catalog contains no build suitable for this processor."
set CatalogMissing		"The engine catalog was not found: %s"
set NoNetwork				"The project page could not be reached."

set Checking				"Querying %s..."
set UpToDate				"All engines are up to date."
set FoundNewer				"%s %s is available (catalog: %s)."
set UpdateHint				"Newer versions cannot be installed automatically because no checksum exists for them yet. Please report the finding."

set ReallyRemove			"Really remove %s?"

} ;# namespace mc

variable Catalog {}
variable Priv

array set Priv {
	dlg			""
	busy			0
	status		""
	cpuflags		{}
	haveflags	0
}


# --- Katalog ----------------------------------------------------------

proc catalogFile {} {
	return [file join $::scidc::dir::share engines downloads.dat]
}


proc loadCatalog {} {
	variable Catalog

	if {[llength $Catalog]} { return 1 }
	set file [catalogFile]
	if {![file readable $file]} { return 0 }
	if {[catch { uplevel #0 [list source $file] }]} { return 0 }
	return [expr {[llength $Catalog] > 0}]
}


proc catalog {} {
	variable Catalog
	loadCatalog
	return $Catalog
}


proc lookup {id} {
	foreach entry [catalog] {
		array set e $entry
		if {$e(Id) eq $id} { return $entry }
		array unset e
	}
	return {}
}


# --- Prozessormerkmale ------------------------------------------------

proc cpuFlags {} {
	variable Priv

	if {$Priv(haveflags)} { return $Priv(cpuflags) }
	set Priv(haveflags) 1
	set flags {}

	# /proc/cpuinfo listet die Merkmale unter "flags" (x86) bzw. "Features" (ARM).
	if {[file readable /proc/cpuinfo]} {
		if {![catch { set fd [::open /proc/cpuinfo r] }]} {
			while {[gets $fd line] >= 0} {
				if {[string match "flags*" $line] || [string match "Features*" $line]} {
					set i [string first : $line]
					if {$i >= 0} {
						set flags [split [string trim [string range $line [expr {$i + 1}] end]]]
					}
					break
				}
			}
			::close $fd
		}
	}

	set Priv(cpuflags) $flags
	return $flags
}


# Waehlt die erste Variante, deren geforderte Merkmale der Prozessor alle
# bietet. Der Katalog fuehrt sie von der schnellsten zur genuegsamsten.
proc selectBuild {entry} {
	array set e $entry
	set have [cpuFlags]

	foreach build $e(Builds) {
		lassign $build id needed
		set ok 1
		foreach flag $needed {
			if {$flag ni $have} { set ok 0; break }
		}
		if {$ok} { return $build }
	}

	return {}
}


# --- Installationszustand ---------------------------------------------

proc engineDir {entry} {
	array set e $entry
	if {$e(Extract) eq "all"} {
		return [file join [file dirname $::scidc::dir::engines] $e(Name)]
	}
	return $::scidc::dir::engines
}


proc binaryPath {entry} {
	array set e $entry
	if {$e(Extract) eq "all"} {
		set build [selectBuild $entry]
		if {[llength $build] == 0} { return "" }
		return [file join [engineDir $entry] [lindex $build 5]]
	}
	return [file join $::scidc::dir::engines $e(Target)]
}


proc installed? {entry} {
	set path [binaryPath $entry]
	if {[string length $path] == 0} { return 0 }
	return [file executable $path]
}


# --- Hilfsmittel ------------------------------------------------------

proc Downloader {} {
	if {![catch { exec wget --version }]} { return wget }
	if {![catch { exec curl --version }]} { return curl }
	return ""
}


# Sobald eine Engine laeuft, faengt die Prozessverwaltung der Anwendung
# SIGCHLD ab; Tcls exec kann sein Kind dann nicht mehr einsammeln und meldet
# "child process lost", obwohl das Hilfsprogramm sauber durchgelaufen ist
# (nachgemessen an einem 30-MB-Download und beim Entpacken). Der Fehler wird
# deshalb geschluckt, wenn das erwartete Ergebnis vorliegt. Bei Downloads
# entscheidet ohnehin die SHA-256-Pruefung ueber die Unversehrtheit.
proc Run {expect args} {
	set rc [catch { exec {*}$args } err]
	if {!$rc} { return }
	if {[string match "*child process lost*" $err]
		&& [string length $expect]
		&& [file exists $expect]
		&& [file size $expect] > 0} {
		return
	}
	error $err
}


proc Fetch {url dest} {
	# Die Originalprojekte liegen auf Servern mit gueltigen Zertifikaten;
	# anders als beim frueheren Bezug aus dem lokalen Repository ist hier
	# kein Rueckfall ohne Zertifikatspruefung noetig.
	catch { file delete -force $dest }

	switch [Downloader] {
		wget		{ Run $dest wget -q -L -O $dest $url }
		curl		{ Run $dest curl -sS -L -o $dest $url }
		default	{ error $mc::NoDownloader }
	}

}


proc Sha256 {file} {
	if {![catch { exec sha256sum --version }]} {
		return [string tolower [lindex [exec sha256sum $file] 0]]
	}
	if {![catch { exec shasum -a 256 --version }]} {
		return [string tolower [lindex [exec shasum -a 256 $file] 0]]
	}
	error $mc::NoChecksumTool
}


# Zwischendateien landen unter ~/.scidc-beta/tmp - der AppImage-Mount ist
# schreibgeschuetzt, das Benutzerverzeichnis nicht.
proc TmpDir {} {
	set dir [file join $::scidc::dir::user tmp]
	file mkdir $dir
	return $dir
}


proc FormatSize {bytes} {
	if {$bytes >= 1048576} { return "[format %.1f [expr {$bytes/1048576.0}]] MB" }
	if {$bytes >= 1024}    { return "[format %.0f [expr {$bytes/1024.0}]] kB" }
	return "$bytes B"
}


# --- Installieren -----------------------------------------------------

proc install {parent id {statusCmd {}}} {
	set entry [lookup $id]
	if {[llength $entry] == 0} { return 0 }
	array set e $entry

	set build [selectBuild $entry]
	if {[llength $build] == 0} {
		Report $statusCmd [format $mc::Failed $e(Name) $mc::NoSuitableBuild]
		return 0
	}
	lassign $build bid needed asset sha size member

	set url "https://github.com/$e(Repo)/releases/download/$e(Tag)/$asset"
	set tmp [file join [TmpDir] "scidc-engine-[pid]-$asset"]
	file mkdir [file dirname $tmp]

	set rc [catch {
		Report $statusCmd [format $mc::Downloading $e(Name) [FormatSize $size]]
		Fetch $url $tmp

		Report $statusCmd $mc::Verifying
		if {[Sha256 $tmp] ne [string tolower $sha]} { error $mc::ChecksumMismatch }

		Report $statusCmd $mc::Extracting
		set path [Unpack $entry $build $tmp]

		Report $statusCmd $mc::Registering
		Register $parent $entry $path
	} err]

	catch { file delete -force $tmp }

	if {$rc} {
		Report $statusCmd [format $mc::Failed $e(Name) $err]
		return 0
	}

	Report $statusCmd [format $mc::Succeeded $e(Name)]
	return 1
}


proc Unpack {entry build file} {
	array set e $entry
	lassign $build bid needed asset sha size member

	set dir [engineDir $entry]
	file mkdir $dir

	switch $e(Archive) {
		plain {
			set path [file join $dir $e(Target)]
			file copy -force $file $path
		}

		tar - tar.gz {
			if {$e(Extract) eq "all"} {
				# Arasan & Co. brauchen neben dem Programm ihre Netzdatei.
				set path [file join $dir $member]
				Run $path tar xf $file -C $dir
			} else {
				set tmpdir [file join [TmpDir] "scidc-unpack-[pid]"]
				file delete -force $tmpdir
				file mkdir $tmpdir
				Run [file join $tmpdir $member] tar xf $file -C $tmpdir $member
				set path [file join $dir $e(Target)]
				file copy -force [file join $tmpdir $member] $path
				file delete -force $tmpdir
			}
		}

		zip {
			set tmpdir [file join [TmpDir] "scidc-unpack-[pid]"]
			file delete -force $tmpdir
			file mkdir $tmpdir
			# -j verwirft die Verzeichnisse aus dem Archiv
			Run [file join $tmpdir [file tail $member]] unzip -q -o -j $file $member -d $tmpdir
			set path [file join $dir $e(Target)]
			file copy -force [file join $tmpdir [file tail $member]] $path
			file delete -force $tmpdir
		}

		default { error "unknown archive type: $e(Archive)" }
	}

	UnpackExtra $entry $file [file dirname $path]
	file attributes $path -permissions 0755
	return $path
}


# Manche Engines laden ihre Netzdatei aus dem Verzeichnis des Programms
# (RubiChess sucht nn-*.nnue dort). Der Katalog nennt solche Beidateien im
# Feld Extra; sie werden flach neben das Programm gelegt.
proc UnpackExtra {entry file dir} {
	array set e $entry
	if {![info exists e(Extra)] || [llength $e(Extra)] == 0} { return }

	set tmpdir [file join [TmpDir] "scidc-extra-[pid]"]
	file delete -force $tmpdir
	file mkdir $tmpdir

	foreach pattern $e(Extra) {
		switch $e(Archive) {
			zip			{ catch { Run {} unzip -q -o -j $file $pattern -d $tmpdir } }
			tar - tar.gz	{ catch { Run {} tar xf $file -C $tmpdir --wildcards $pattern } }
		}
	}

	# tar erhaelt die Verzeichnisse; alles Gefundene flach herueberholen.
	foreach found [FindFiles $tmpdir] {
		catch { file copy -force $found [file join $dir [file tail $found]] }
	}
	file delete -force $tmpdir
}


proc FindFiles {dir} {
	set out {}
	foreach f [glob -nocomplain -directory $dir *] {
		if {[file isdirectory $f]} {
			set out [concat $out [FindFiles $f]]
		} else {
			lappend out $f
		}
	}
	return $out
}


# Traegt die Engine in die Konfiguration ein. ProbeNewEngine startet sie,
# liest Kennung und Optionen aus und legt bzw. aktualisiert den Eintrag.
proc Register {parent entry path} {
	array set e $entry

	set new [list Command $path Name $e(Name) Url $e(Homepage)]
	if {[string length $e(Author)]} { lappend new Author $e(Author) }

	if {![::engine::ProbeNewEngine $parent $new [list $e(Protocol)]]} {
		error "the engine did not answer"
	}

	# ProbeNewEngine leitet den Namen aus der UCI-Kennung ab und haengt bei
	# Namensgleichheit eine Nummer an -- aus "Stockfish" wird so "Stockfish (2)",
	# und Fairy-Stockfish landet als "Stockfish (3)". Fuer Eintraege aus dem
	# Katalog ist der Name aber bekannt; er wird deshalb nachtraeglich gesetzt.
	SetName $path $e(Name)
}


proc SetName {command name} {
	variable ::engine::Engines

	set index 0
	foreach entry $::engine::Engines {
		array set e $entry
		if {$e(Command) eq $command} {
			# Nur anpassen, wenn kein anderer Eintrag den Namen bereits fuehrt.
			set taken 0
			foreach other $::engine::Engines {
				array set o $other
				if {$o(Name) eq $name && $o(Command) ne $command} { set taken 1 }
				array unset o
			}
			if {!$taken} {
				set e(Name) $name
				lset ::engine::Engines $index [array get e]
			}
			return
		}
		array unset e
		incr index
	}
}


proc remove {parent id} {
	set entry [lookup $id]
	if {[llength $entry] == 0} { return 0 }
	array set e $entry

	if {$e(Extract) eq "all"} {
		catch { file delete -force [engineDir $entry] }
	} else {
		catch { file delete -force [binaryPath $entry] }
	}
	return 1
}


# --- Suche nach neueren Versionen -------------------------------------

# Fragt die Veroeffentlichungsdaten des Projekts ab. Liefert den Namen der
# neuesten Version oder eine leere Zeichenkette.
proc latestVersion {entry} {
	array set e $entry

	set url "https://api.github.com/repos/$e(Repo)/releases/latest"
	set tmp [file join [TmpDir] "scidc-rel-[pid].json"]
	file mkdir [file dirname $tmp]

	set tag ""
	if {![catch { Fetch $url $tmp }]} {
		if {![catch { set fd [::open $tmp r] }]} {
			set data [read $fd]
			::close $fd
			# Kein JSON-Parser noetig: der Tag steht als erstes "tag_name".
			if {[regexp {"tag_name"\s*:\s*"([^"]+)"} $data _ tag]} {}
		}
	}
	catch { file delete -force $tmp }
	return $tag
}


proc checkForUpdates {statusCmd} {
	set found {}

	foreach entry [catalog] {
		array set e $entry
		Report $statusCmd [format $mc::Checking $e(Name)]
		set tag [latestVersion $entry]
		if {[string length $tag] && $tag ne $e(Tag)} {
			lappend found [list $e(Name) $tag $e(Tag)]
		}
		array unset e
	}

	return $found
}


# --- Dialog -----------------------------------------------------------

proc open {parent} {
	variable Priv

	if {![loadCatalog]} {
		::dialog::error -parent $parent -message [format $mc::CatalogMissing [catalogFile]]
		return
	}

	set dlg $parent.engineDownload
	if {[winfo exists $dlg]} { return [::widget::dialogRaise $dlg] }

	tk::toplevel $dlg -class Scidc
	wm withdraw $dlg
	set Priv(dlg) $dlg
	set Priv(busy) 0

	set top [ttk::frame $dlg.top -takefocus 0]
	pack $top -fill both -expand yes -padx 8 -pady 8

	ttk::label $top.hname  -text $mc::Engine   -font TkHeadingFont
	ttk::label $top.hver   -text $mc::Version  -font TkHeadingFont
	ttk::label $top.hstate -text $mc::State    -font TkHeadingFont
	ttk::label $top.hsize  -text $mc::Size     -font TkHeadingFont
	grid $top.hname  -row 0 -column 0 -sticky w  -padx {0 12}
	grid $top.hver   -row 0 -column 1 -sticky w  -padx {0 12}
	grid $top.hstate -row 0 -column 2 -sticky w  -padx {0 12}
	grid $top.hsize  -row 0 -column 3 -sticky e  -padx {0 12}
	grid [ttk::separator $top.sep -orient horizontal] \
		-row 1 -column 0 -columnspan 6 -sticky ew -pady {2 6}

	set row 2
	foreach entry [catalog] {
		array set e $entry
		set id $e(Id)
		set build [selectBuild $entry]

		ttk::label $top.n$id -text $e(Name)
		ttk::label $top.v$id -text $e(Version)
		ttk::label $top.s$id -textvar [namespace current]::Priv(state:$id)
		ttk::label $top.z$id -text [expr {[llength $build] ? [FormatSize [lindex $build 4]] : "-"}] \
			-anchor e
		ttk::button $top.b$id -text $mc::Download -width 12 \
			-command [namespace code [list Action $dlg $id]]
		ttk::button $top.h$id -text $mc::ProjectPage \
			-command [list ::web::open $dlg $e(Homepage)]

		grid $top.n$id -row $row -column 0 -sticky w -padx {0 12} -pady 1
		grid $top.v$id -row $row -column 1 -sticky w -padx {0 12}
		grid $top.s$id -row $row -column 2 -sticky w -padx {0 12}
		grid $top.z$id -row $row -column 3 -sticky e -padx {0 12}
		grid $top.b$id -row $row -column 4 -sticky ew -padx {0 4}
		grid $top.h$id -row $row -column 5 -sticky ew

		incr row
		array unset e
	}

	grid [ttk::separator $top.sep2 -orient horizontal] \
		-row $row -column 0 -columnspan 6 -sticky ew -pady {8 4}
	incr row
	ttk::label $top.status -textvar [namespace current]::Priv(status) -anchor w
	grid $top.status -row $row -column 0 -columnspan 6 -sticky ew
	grid columnconfigure $top 0 -weight 1

	set Priv(status) ""
	UpdateStates

	::widget::dialogButtons $dlg {close} -default close
	$dlg.close configure -command [namespace code [list Close $dlg]]

	ttk::button $dlg.__buttons.check -text $mc::CheckForUpdates \
		-command [namespace code [list CheckUpdates $dlg]]
	pack $dlg.__buttons.check -side left -padx 8
	set Priv(button:check) $dlg.__buttons.check

	wm protocol $dlg WM_DELETE_WINDOW [namespace code [list Close $dlg]]
	wm title $dlg $mc::Title
	wm transient $dlg [winfo toplevel $parent]
	::util::place $dlg -parent $parent -position center
	wm deiconify $dlg
	::ttk::grabWindow $dlg
	tkwait window $dlg
	::ttk::releaseGrab $dlg
}


proc Close {dlg} {
	variable Priv
	if {$Priv(busy)} { return }
	set Priv(dlg) ""
	destroy $dlg
}


proc UpdateStates {} {
	variable Priv

	if {![winfo exists $Priv(dlg)]} { return }
	set top $Priv(dlg).top

	foreach entry [catalog] {
		array set e $entry
		set id $e(Id)
		if {[installed? $entry]} {
			set Priv(state:$id) $mc::Installed
			catch { $top.b$id configure -text $mc::Remove }
		} else {
			set Priv(state:$id) $mc::NotInstalled
			catch { $top.b$id configure -text $mc::Download }
		}
		array unset e
	}
}


proc Enable {dlg flag} {
	variable Priv

	set state [expr {$flag ? "normal" : "disabled"}]
	foreach entry [catalog] {
		array set e $entry
		catch { $dlg.top.b$e(Id) configure -state $state }
		array unset e
	}
	catch { $dlg.close configure -state $state }
	catch { $Priv(button:check) configure -state $state }
	update idletasks
}


proc Action {dlg id} {
	variable Priv

	if {$Priv(busy)} { return }
	set entry [lookup $id]
	if {[llength $entry] == 0} { return }
	array set e $entry

	if {[installed? $entry]} {
		set reply [::dialog::question -parent $dlg \
			-message [format $mc::ReallyRemove $e(Name)] -default no]
		if {$reply ne "yes"} { return }
		remove $dlg $id
		set Priv(status) [format $mc::Removed $e(Name)]
		UpdateStates
		return
	}

	set Priv(busy) 1
	Enable $dlg 0
	::widget::busyCursor on
	catch { install $dlg $id [namespace code SetStatus] }
	::widget::busyCursor off
	Enable $dlg 1
	set Priv(busy) 0
	UpdateStates
}


proc SetStatus {text} {
	variable Priv
	set Priv(status) $text
	update idletasks
}


proc CheckUpdates {dlg} {
	variable Priv

	if {$Priv(busy)} { return }
	set Priv(busy) 1
	Enable $dlg 0
	::widget::busyCursor on
	set found {}
	catch { set found [checkForUpdates [namespace code SetStatus]] }
	::widget::busyCursor off
	Enable $dlg 1
	set Priv(busy) 0

	if {[llength $found] == 0} {
		set Priv(status) $mc::UpToDate
		return
	}

	set lines {}
	foreach f $found {
		lassign $f name tag old
		lappend lines [format $mc::FoundNewer $name $tag $old]
	}
	set Priv(status) [format $mc::FoundNewer [lindex $found 0 0] [lindex $found 0 1] [lindex $found 0 2]]
	::dialog::info -parent $dlg -message [join $lines "\n"] -detail $mc::UpdateHint
}


proc Report {statusCmd text} {
	variable Priv
	set Priv(status) $text
	if {[llength $statusCmd]} { catch { uplevel #0 $statusCmd [list $text] } }
	update idletasks
}

} ;# namespace download
} ;# namespace engine

# vi:set ts=3 sw=3:
