# ======================================================================
# Author : $Author: gcramer $
# Version: $Revision: 1517 $
# Date   : $Date: 2018-09-06 08:47:10 +0000 (Thu, 06 Sep 2018) $
# Url    : $URL: file:///svn/p/scidb/code/trunk/tcl/colors.tcl $
# ======================================================================

# ======================================================================
#    _/|            __
#   // o\         /    )           ,        /    /
#   || ._)    ----\---------__----------__-/----/__-
#   //__\          \      /   '  /    /   /    /   )
#   )___(     _(____/____(___ __/____(___/____(___/_
# ======================================================================

# ======================================================================
# Copyright: (C) 2014-2018 Gregor Cramer
# ======================================================================

# ======================================================================
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# ======================================================================

namespace eval colors {

array set Colors {
	lite:pgn,background						#ffffff
	lite:pgn,foreground:main				#000000
	lite:pgn,foreground:variation			#0000ee
	lite:pgn,foreground:bracket			#0000ee
	lite:pgn,foreground:numbering			#aa0acd
	lite:pgn,foreground:nag					#ee0000
	lite:pgn,foreground:nagtext			#912a2a
	lite:pgn,foreground:comment			#006300
	lite:pgn,foreground:info				#8b4513
	lite:pgn,foreground:result				#000000
	lite:pgn,foreground:illegal			#ee0000
	lite:pgn,foreground:marks				#6300c6
	lite:pgn,foreground:empty				#666666
	lite:pgn,foreground:opening			#000000
	lite:pgn,foreground:result				#000000
	lite:pgn,background:current			#ffdd76
	lite:pgn,background:nextmove			#eeff00
	lite:pgn,background:merge				#f0f0f0
	lite:pgn,hilite:comment					#7a5807
	lite:pgn,hilite:info						#b22222
	lite:pgn,hilite:move						#dce4e5

	lite:analysis,background				#ffffee
	lite:analysis,info:background			#f5f5e4
	lite:analysis,info:foreground			darkgreen
	lite:analysis,best:foreground			darkgreen
	lite:analysis,error:foreground		darkred
	lite:analysis,active:background		#f5f5e4
	lite:analysis,layout:background		#ffee75

	lite:layout,background					#0170cc

	lite:database,selected					#ffdd76

	lite:information,html:hover			#ebf4f5
	lite:information,html:color			white
	lite:information,html:header			yellow
	lite:information,html:link				yellow
	lite:information,html:visited			#ffb432
	lite:information,html:menu				#ffdd76
	lite:information,html:bases			black
	lite:information,background:news		orange
	lite:information,background:html		#014b72

	lite:tree,background						white
	lite:tree,emphasize						linen
	lite:tree,stripes							#ebf4f5
	lite:tree,ratio:color					darkgreen
	lite:tree,score:color					darkred
	lite:tree,draws:color					darkgreen
	lite:tree,progress:color				darkred
	lite:tree,progress:finished			forestgreen
	lite:tree,result:mono:white			white
	lite:tree,result:mono:black			black
	lite:tree,result:mono:remis			#808080
	lite:tree,result:color:white			darkred
	lite:tree,result:color:black			darkgreen
	lite:tree,result:color:remis			white

	lite:variation,background				white
	lite:variation,emphasize				linen
	lite:variation,stripes					#ebf4f5

	lite:board,modifiedForeground			white
	lite:board,modifiedBackground			brown
	lite:board,fixedBackground				#fff5d6

	lite:browser,background:header		#ebf4f5
	lite:browser,background:hilite		cornflowerblue
	lite:browser,background:modified		linen
	lite:browser,foreground:header		black
	lite:browser,foreground:hilite		white

	lite:overview,background:normal		#ebf4f5
	lite:overview,background:modified	linen

	lite:crosstable,background				#ffffff
	lite:crosstable,highlighted			#ebf4f5
	lite:crosstable,mark						#ffdd76

	lite:export,shadow						#999999
	lite:export,text							#c0c0c0

	lite:import,background					#ebf4f5
	lite:import,background:select			#ffdd76
	lite:import,background:hilite			linen

	lite:switcher,background				#ebf4f5
	lite:switcher,selected:background	#ffdd76
	lite:switcher,modified:foreground	darkred
	lite:switcher,normal:background		LemonChiffon
	lite:switcher,normal:foreground		black
	lite:switcher,hidden:background		#ebf4f5
	lite:switcher,hidden:foreground		black
	lite:switcher,emph:foreground			darkgreen
	lite:switcher,drop:background			#98c187
	lite:switcher,prop:background			#aee239

	lite:fsbox,menu:headerbackground		#ffdd76
	lite:fsbox,menu:headerforeground		black
	lite:fsbox,foreground					black
	lite:fsbox,drop:background				LemonChiffon
	lite:fsbox,selectionbackground		#ebf4f5
	lite:fsbox,selectionforeground		black
	lite:fsbox,inactivebackground			#f2f2f2
	lite:fsbox,inactiveforeground			black
	lite:fsbox,activebackground			#ebf4f5
	lite:fsbox,activeforeground			black

	lite:gamebar,background:normal		#d9d9d9
	lite:gamebar,foreground:normal		black
	lite:gamebar,background:selected		#dce4e5
	lite:gamebar,background:emphasize	linen
	lite:gamebar,background:active		#efefef
	lite:gamebar,background:darker		#828282
	lite:gamebar,background:shadow		#e6e6e6
	lite:gamebar,background:lighter		white
	lite:gamebar,background:hilite		cornflowerblue
	lite:gamebar,foreground:hilite		white
	lite:gamebar,background:hilite2		cornflowerblue
	lite:gamebar,foreground:hilite2		white
	lite:gamebar,foreground:elo			darkblue

	lite:scrolledtable,background			white
	lite:scrolledtable,stripes				#ebf4f5
	lite:scrolledtable,highlight			#f4f4f4
	lite:scrolledtable,separatorcolor	darkgrey

	lite:tlistbox,background				white
	lite:tlistbox,foreground				black
	lite:tlistbox,selectbackground		#ffdd76
	lite:tlistbox,selectforeground		black
	lite:tlistbox,disabledbackground		#ebf4f5
	lite:tlistbox,disabledforeground		black
	lite:tlistbox,highlightbackground	darkblue
	lite:tlistbox,highlightforeground	white
	lite:tlistbox,dropbackground			#dce4e5
	lite:tlistbox,dropforeground			black

	lite:treetable,background				white
	lite:treetable,foreground				black
	lite:treetable,disabledforeground	#999999

	lite:help,foreground:gray				#999999
	lite:help,foreground:litegray			#696969
	lite:help,background:gray				#f5f5f5
	lite:help,background:emphasize		LightGoldenrod

	lite:table,background					white
	lite:table,foreground					black
	lite:table,selectionbackground		#ffdd76
	lite:table,selectionforeground		black
	lite:table,disabledforeground			#555555
	lite:table,activebackground			#e5e5e5
	lite:table,labelforeground				black
	lite:table,labelbackground				#d9d9d9

	lite:fsbox,emphasizebackground		BlanchedAlmond

	lite:save,number							darkred
	lite:save,frequency						darkgreen
	lite:save,title							darkgreen
	lite:save,federation						darkblue
	lite:save,score							darkgreen
	lite:save,ratingType						darkblue
	lite:save,date								darkblue
	lite:save,eventDate						darkblue
	lite:save,eventCountry					darkblue
	lite:save,taglistOutline				gray
	lite:save,taglistBackground			LightYellow
	lite:save,taglistHighlighting			#ebf4f5
	lite:save,taglistCurrent				blue
	lite:save,matchlistBackground			#ebf4f5
	lite:save,matchlistHeaderForeground	#727272
	lite:save,matchlistHeaderBackground	#dfe7e8

	lite:encoding,selection					#ffdd76
	lite:encoding,active						#ebf4f5
	lite:encoding,normal						linen
	lite:encoding,description				#efefef

	lite:engine,selectbackground:setup	lightgray
	lite:engine,selectforeground:setup	black
	lite:engine,stripes						linen

	lite:default,disabledbackground		#ebf4f5
	lite:default,disabledforeground		black
	lite:default,foreground:gray			#999999

	lite:treetable,selected:focus			#ffdd76
	lite:treetable,selected!focus			#ffdd76
	lite:treetable,active:focus			#ebf4f5
	lite:treetable,hilite!selected		#ebf4f5

	lite:gamehistory,selected:focus		#ebf4f5
	lite:gamehistory,selected:hilite		#ebf4f5
	lite:gamehistory,selected!focus		#f2f2f2
	lite:gamehistory,hilite					#ebf4f5

	lite:playerdict,stripes					linen

	lite:varslider,background				#ffdd76
	lite:varslider,hilite					#ffc618

	lite:comment,label:altered				#555555
	lite:comment,label:foreground			white

	lite:eco,stripes							linen

	lite:layout-manager:normal				black
	lite:layout-manager:current			darkgreen
	lite:layout-manager:changed			darkred
}
# mapped from #ebf4f5
array set Colors {
	dark:tree,stripes							#dce4e5
	dark:variation,stripes					#dce4e5
	dark:import,background					#dce4e5
	dark:browser,background:header		#dce4e5
	dark:information,hover					#dce4e5
	dark:overview,background:normal		#dce4e5
	dark:crosstable,highlighted			#dce4e5
	dark:fsbox,selectionbackground		#dce4e5
	dark:scrolledtable,stripes				#dce4e5
	dark:tlistbox,disabledbackground		#dce4e5
	dark:tlistbox,dropbackground			#dce4e5
	dark:save,taglistHighlighting			#dce4e5
	dark:save,matchlistBackground			#dce4e5
	dark:encoding,active						#dce4e5
	dark:default,disabledbackground		#dce4e5
	dark:treetable,active:focus			#dce4e5
	dark:treetable,hilite!selected		#dce4e5
	dark:gamehistory,selected:focus		#dce4e5
	dark:gamehistory,selected:hilite		#dce4e5
	dark:gamehistory,hilite					#dce4e5
	dark:fsbox,activebackground			#dce4e5
	dark:switcher,background				#dce4e5
	dark:switcher,hidden:background		#dce4e5
}
# mapped from #dce4e5
array set Colors {
	dark:pgn,hilite:move						#cddddf
}
# mapped from #f0f0f0
array set Colors {
	dark:pgn,background:merge				#e9e9e9
}
# mapped from #efefef
array set Colors {
	dark:gamebar,background:active		#e4e4e4
	dark:encoding,description				#e4e4e4
}
# mapped from linen
array set Colors {
	dark:tree,emphasize						#ecded0
	dark:variation,emphasize				#ecded0
	dark:browser,background:modified		#ecded0
	dark:overview,background:modified	#ecded0
	dark:import,background:hilite			#ecded0
	dark:gamebar,background:emphasize	#ecded0
	dark:encoding,normal						#ecded0
	dark:playerdict,stripes					#ecded0
	dark:engine,stripes						#ecded0
	dark:eco,stripes							#ecded0
}
# mapped from #f5f5e4
array set Colors {
	dark:analysis,info:background			#d9d9ca
	dark:analysis,active:background		#d9d9ca
}
# mapped from #dfe7e8
array set Colors {
	dark:save,matchlistHeaderBackground	#d1d8d9
}
# mapped from #999999
array set Colors {
	dark:default,foreground:gray			#777777
}

# night scheme — true dark mode (dark backgrounds, light text)
array set Colors {
	night:pgn,background					#2b2b2b
	night:pgn,foreground:main				#bbbbbb
	night:pgn,foreground:variation			#7b9cd6
	night:pgn,foreground:bracket			#7b9cd6
	night:pgn,foreground:numbering			#c792ea
	night:pgn,foreground:nag				#f07178
	night:pgn,foreground:nagtext			#e06c75
	night:pgn,foreground:comment			#98c379
	night:pgn,foreground:info				#d19a66
	night:pgn,foreground:result				#bbbbbb
	night:pgn,foreground:illegal			#f07178
	night:pgn,foreground:marks				#c792ea
	night:pgn,foreground:empty				#666666
	night:pgn,foreground:opening			#bbbbbb
	night:pgn,background:current			#3a3a2a
	night:pgn,background:nextmove			#2a3a2a
	night:pgn,background:merge				#3c3f41
	night:pgn,hilite:comment				#d19a66
	night:pgn,hilite:info					#f07178
	night:pgn,hilite:move					#3c3f41

	night:analysis,background				#2b2b2b
	night:analysis,info:background			#313438
	night:analysis,info:foreground			#98c379
	night:analysis,best:foreground			#98c379
	night:analysis,error:foreground			#f07178
	night:analysis,active:background		#313438
	night:analysis,layout:background		#2a3a2a

	night:layout,background					#1e4980

	night:database,selected					#2a3a2a

	night:information,html:hover			#3c3f41
	night:information,html:color			#cccccc
	night:information,html:header			#e5c07b
	night:information,html:link				#7eb8f7
	night:information,html:visited			#c678dd
	night:information,html:menu				#2a3a2a
	night:information,html:bases			#cccccc
	night:information,background:news		#8b2020
	night:information,background:html		#252526

	night:tree,background					#2b2b2b
	night:tree,emphasize					#3a3c3a
	night:tree,stripes						#313438
	night:tree,ratio:color					#98c379
	night:tree,score:color					#f07178
	night:tree,draws:color					#98c379
	night:tree,progress:color				#f07178
	night:tree,progress:finished			#4caf50
	night:tree,result:mono:white			#eeeeee
	night:tree,result:mono:black			#888888
	night:tree,result:mono:remis			#666666
	night:tree,result:color:white			#e06c75
	night:tree,result:color:black			#98c379
	night:tree,result:color:remis			#888888

	night:variation,background				#2b2b2b
	night:variation,emphasize				#3a3c3a
	night:variation,stripes					#313438

	night:board,modifiedForeground			#eeeeee
	night:board,modifiedBackground			#6b3020
	night:board,fixedBackground				#3a3830

	night:browser,background:header		#313438
	night:browser,background:hilite		#214283
	night:browser,background:modified		#3a3c3a
	night:browser,foreground:header		#cccccc
	night:browser,foreground:hilite		#eeeeee

	night:overview,background:normal		#313438
	night:overview,background:modified		#3a3c3a

	night:crosstable,background				#2b2b2b
	night:crosstable,highlighted			#313438
	night:crosstable,mark					#2a3a2a

	night:export,shadow						#555555
	night:export,text						#666666

	night:import,background					#313438
	night:import,background:select			#2a3a2a
	night:import,background:hilite			#3a3c3a

	night:switcher,background				#313438
	night:switcher,selected:background		#2a3a2a
	night:switcher,modified:foreground		#f07178
	night:switcher,normal:background		#3c3f41
	night:switcher,normal:foreground		#bbbbbb
	night:switcher,hidden:background		#313438
	night:switcher,hidden:foreground		#bbbbbb
	night:switcher,emph:foreground			#98c379
	night:switcher,drop:background			#2d4a3e
	night:switcher,prop:background			#3d5a26

	night:fsbox,menu:headerbackground		#2a3a2a
	night:fsbox,menu:headerforeground		#bbbbbb
	night:fsbox,foreground					#bbbbbb
	night:fsbox,drop:background				#3c3f41
	night:fsbox,selectionbackground		#313438
	night:fsbox,selectionforeground		#bbbbbb
	night:fsbox,inactivebackground			#2b2b2b
	night:fsbox,inactiveforeground			#888888
	night:fsbox,activebackground			#313438
	night:fsbox,activeforeground			#bbbbbb
	night:fsbox,emphasizebackground		#333333

	night:gamebar,background:normal		#3c3f41
	night:gamebar,foreground:normal		#bbbbbb
	night:gamebar,background:selected		#313438
	night:gamebar,background:emphasize		#3a3c3a
	night:gamebar,background:active		#4c5052
	night:gamebar,background:darker		#222222
	night:gamebar,background:shadow		#232325
	night:gamebar,background:lighter		#4c5052
	night:gamebar,background:hilite		#214283
	night:gamebar,foreground:hilite		#eeeeee
	night:gamebar,background:hilite2		#214283
	night:gamebar,foreground:hilite2		#eeeeee
	night:gamebar,foreground:elo			#7b9cd6

	night:scrolledtable,background			#2b2b2b
	night:scrolledtable,stripes				#313438
	night:scrolledtable,highlight			#3c3f41
	night:scrolledtable,separatorcolor		#555555

	night:tlistbox,background				#2b2b2b
	night:tlistbox,foreground				#bbbbbb
	night:tlistbox,selectbackground		#214283
	night:tlistbox,selectforeground		#eeeeee
	night:tlistbox,disabledbackground		#313438
	night:tlistbox,disabledforeground		#888888
	night:tlistbox,highlightbackground		#214283
	night:tlistbox,highlightforeground		#eeeeee
	night:tlistbox,dropbackground			#313438
	night:tlistbox,dropforeground			#bbbbbb

	night:treetable,background				#2b2b2b
	night:treetable,foreground				#bbbbbb
	night:treetable,disabledforeground		#666666

	night:help,foreground:gray				#666666
	night:help,foreground:litegray			#555555
	night:help,background:gray				#313438
	night:help,background:emphasize		#3a3a2a

	night:table,background					#2b2b2b
	night:table,foreground					#bbbbbb
	night:table,selectionbackground		#214283
	night:table,selectionforeground		#eeeeee
	night:table,disabledforeground			#666666
	night:table,activebackground			#3c3f41
	night:table,labelforeground				#bbbbbb
	night:table,labelbackground				#3c3f41

	night:save,number						#f07178
	night:save,frequency					#98c379
	night:save,title						#98c379
	night:save,federation					#7b9cd6
	night:save,score						#98c379
	night:save,ratingType					#7b9cd6
	night:save,date							#7b9cd6
	night:save,eventDate					#7b9cd6
	night:save,eventCountry					#7b9cd6
	night:save,taglistOutline				#555555
	night:save,taglistBackground			#2b2b2b
	night:save,taglistHighlighting			#313438
	night:save,taglistCurrent				#7b9cd6
	night:save,matchlistBackground			#313438
	night:save,matchlistHeaderForeground	#888888
	night:save,matchlistHeaderBackground	#3c3f41

	night:encoding,selection				#2a3a2a
	night:encoding,active					#313438
	night:encoding,normal					#3a3c3a
	night:encoding,description				#313438

	night:engine,selectbackground:setup	#4c5052
	night:engine,selectforeground:setup	#bbbbbb
	night:engine,stripes					#3a3c3a

	night:default,disabledbackground		#313438
	night:default,disabledforeground		#888888
	night:default,foreground:gray			#555555

	night:treetable,selected:focus			#214283
	night:treetable,selected!focus			#313438
	night:treetable,active:focus			#313438
	night:treetable,hilite!selected		#313438

	night:gamehistory,selected:focus		#313438
	night:gamehistory,selected:hilite		#313438
	night:gamehistory,selected!focus		#2b2b2b
	night:gamehistory,hilite				#313438

	night:playerdict,stripes				#3a3c3a

	night:varslider,background				#2a3a2a
	night:varslider,hilite					#223a22

	night:comment,label:altered				#888888
	night:comment,label:foreground			#eeeeee

	night:eco,stripes						#3a3c3a

	night:layout-manager:normal				#bbbbbb
	night:layout-manager:current			#98c379
	night:layout-manager:changed			#f07178

	night:darkblue							#6fa8dc
	night:steelblue4						#6fa8dc
	night:blue								#88b4e7
	night:darkred							#e06c75
	night:red								#ff7878
	night:darkgreen							#98c379
	night:black								#cccccc
	night:magenta4							#c678dd
	night:#68480a							#d4aa70
	night:#dce4e5							#313438
}

set Scheme dark

proc lookup {color} {
	variable Colors
	variable Scheme

	if {[string match theme,* $color]} {
		return [::theme::getColor [string range $color 6 end]]
	}

	if {[info exists Colors($Scheme:$color)]} { return $Colors($Scheme:$color) }
	if {[info exists Colors(lite:$color)]} { return $Colors(lite:$color) }

	return $color
}


proc hsv2rgb {h s v} { return [::dialog::choosecolor::hsv2rgb $h $s $v] }
proc rgb2hsv {r g b} { return [::dialog::choosecolor::rgb2hsv $r $g $b] }
proc getActualColor {color} { return [::dialog::choosecolor::getActualColor $color] }


proc makeActiveColor {color} {
	scan [getActualColor $color] "\#%2x%2x%2x" r g b
	lassign [rgb2hsv $r $g $b] h s v
	return [format "#%02x%02x%02x" {*}[hsv2rgb $h $s [expr {min(1.0, $v + 0.1)}]]]
}


proc makeHiliteColor {color} {
	scan [getActualColor $color] "\#%2x%2x%2x" r g b
	lassign [rgb2hsv $r $g $b] h s v
	return [format "#%02x%02x%02x" {*}[hsv2rgb $h 1.0 1.0]]
}

} ;# namespace colors

# vi:set ts=3 sw=3:
