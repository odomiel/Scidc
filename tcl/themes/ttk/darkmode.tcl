# Scidc dark mode TTK theme — derived from clam (image-free, geometric)
namespace eval ttk::theme::darkmode {

package provide ttk::theme::darkmode 0.1

variable colors
array set colors {
	-bg          "#2b2b2b"
	-bg2         "#3c3f41"
	-bg3         "#313438"
	-bg_dark     "#1e1f22"
	-fg          "#bbbbbb"
	-fg_disabled "#606060"
	-selectbg    "#214283"
	-selectfg    "#eeeeee"
	-border      "#555555"
	-entrybg     "#45494a"
	-trough      "#1e1f22"
	-activebg    "#4c5052"
	-activefg    "#dddddd"
	-insertcolor "#bbbbbb"
}

ttk::style theme create darkmode -parent clam -settings {
	ttk::style configure . \
		-background      #2b2b2b \
		-foreground      #bbbbbb \
		-bordercolor     #555555 \
		-darkcolor       #1e1f22 \
		-lightcolor      #3c3f41 \
		-troughcolor     #1e1f22 \
		-selectbackground #214283 \
		-selectforeground #eeeeee \
		-fieldbackground  #45494a \
		-insertcolor      #bbbbbb \
		-relief           flat \
		;

	ttk::style map . \
		-background  [list disabled #2b2b2b active #4c5052] \
		-foreground  [list disabled #606060] \
		-bordercolor [list focus #7b9cd6] \
		;

	# Button
	ttk::style configure TButton \
		-background  #3c3f41 \
		-bordercolor #555555 \
		-padding     {4 2} \
		-relief      raised \
		;
	ttk::style map TButton \
		-background  [list active #4c5052 disabled #2b2b2b pressed #313438] \
		-foreground  [list disabled #606060] \
		-bordercolor [list focus #7b9cd6] \
		-relief      [list pressed sunken] \
		;

	ttk::style configure aligned.TButton -anchor w -width -9
	ttk::style configure icon.TButton -padding 0

	# Checkbutton / Radiobutton
	foreach w {TCheckbutton TRadiobutton} {
		ttk::style configure $w \
			-background  #2b2b2b \
			-indicatorbackground #45494a \
			-indicatorcolor      #45494a \
			;
		ttk::style map $w \
			-background        [list active #2b2b2b] \
			-foreground        [list disabled #606060] \
			-indicatorbackground [list selected #214283 active #4c5052] \
			;
	}

	# Entry / Combobox / Spinbox
	foreach w {TEntry TCombobox TSpinbox} {
		ttk::style configure $w \
			-fieldbackground #45494a \
			-foreground      #bbbbbb \
			-bordercolor     #555555 \
			-insertcolor     #bbbbbb \
			;
		ttk::style map $w \
			-fieldbackground [list disabled #2b2b2b readonly #2b2b2b \
			                       {readonly focus} #313438] \
			-foreground      [list disabled #606060] \
			-bordercolor     [list focus #7b9cd6] \
			;
	}
	ttk::style configure TCombobox -arrowcolor #bbbbbb
	ttk::style configure TSpinbox  -arrowcolor #bbbbbb -padding {2 0 2 0}

	# Frame / Label / LabelFrame
	ttk::style configure TFrame      -background #2b2b2b
	ttk::style configure TLabel      -background #2b2b2b -foreground #bbbbbb
	ttk::style configure TSeparator  -background #555555

	ttk::style configure TLabelframe       -background #2b2b2b -bordercolor #555555
	ttk::style configure TLabelframe.Label -background #2b2b2b -foreground #bbbbbb
	ttk::style map TLabelframe -bordercolor [list focus #7b9cd6]

	# Notebook
	ttk::style configure TNotebook      -background #1e1f22 -borderwidth 1
	ttk::style configure TNotebook.Tab  \
		-background #313438 \
		-foreground #bbbbbb \
		-padding    {6 2} \
		;
	ttk::style map TNotebook.Tab \
		-background [list selected #2b2b2b active #3c3f41] \
		-foreground [list selected #eeeeee disabled #606060] \
		;

	# Scrollbar
	ttk::style configure TScrollbar \
		-background  #3c3f41 \
		-bordercolor #555555 \
		-troughcolor #1e1f22 \
		-arrowcolor  #888888 \
		-arrowsize   12 \
		-gripcount   0 \
		;
	ttk::style map TScrollbar \
		-background  [list active #4c5052 disabled #2b2b2b] \
		-arrowcolor  [list disabled #555555] \
		;

	# Scale
	ttk::style configure TScale \
		-background  #2b2b2b \
		-troughcolor #1e1f22 \
		-bordercolor #555555 \
		;
	ttk::style configure active.Horizontal.TScale -troughcolor #313438
	ttk::style configure active.Vertical.TScale   -troughcolor #313438

	# Progressbar
	ttk::style configure TProgressbar \
		-background  #214283 \
		-troughcolor #1e1f22 \
		-bordercolor #555555 \
		;

	# Treeview
	ttk::style configure Treeview \
		-background      #2b2b2b \
		-foreground      #bbbbbb \
		-fieldbackground #2b2b2b \
		-bordercolor     #555555 \
		;
	ttk::style map Treeview \
		-background [list selected #214283] \
		-foreground [list selected #eeeeee disabled #606060] \
		;
	ttk::style configure Treeview.Heading \
		-background  #3c3f41 \
		-foreground  #bbbbbb \
		-bordercolor #555555 \
		-relief      raised \
		;
	ttk::style map Treeview.Heading \
		-background [list active #4c5052] \
		;

	# PanedWindow sash
	ttk::style configure TPanedwindow -background #2b2b2b
	ttk::style configure Sash -sashthickness 5 -gripcount 10
}

} ;# namespace ttk::theme::darkmode
