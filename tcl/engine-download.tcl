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

	file attributes $path -permissions 0755
	return $path
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


proc Report {statusCmd text} {
	variable Priv
	set Priv(status) $text
	if {[llength $statusCmd]} { catch { uplevel #0 $statusCmd [list $text] } }
	update idletasks
}

} ;# namespace download
} ;# namespace engine

# vi:set ts=3 sw=3:
