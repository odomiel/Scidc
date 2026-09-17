# ======================================================================
# Author : $Author$
# Version: $Revision: 1391 $
# Date   : $Date: 2017-08-07 11:53:58 +0000 (Mon, 07 Aug 2017) $
# Url    : $URL$
# ======================================================================

# ======================================================================
# Copyright: (C) 2009-2013 Gregor Cramer
# ======================================================================

# ======================================================================
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# ======================================================================

::util::source counties

namespace eval country {
namespace eval mc {

set Aaland_Islands									"Aaland Islands"
set Aboard_Aircraft									"Aboard Aircraft"
set Aboard_Spacecraft								"Aboard Spacecraft"
set Afghanistan										"Afghanistan"
set Albania												"Albania"
set Algeria												"Algeria"
set American_Samoa									"American Samoa"
set Andorra												"Andorra"
set Angola												"Angola"
set Anguilla											"Anguilla"
set Antarctica											"Antarctica"
set Antigua												"Antigua"
set Argentina											"Argentina"
set Armenia												"Armenia"
set Aruba												"Aruba"
set At_Sea												"At Sea"
set Australasia										"Australasia"
set Australia											"Australia"
set Austria												"Austria"
set Azerbaijan											"Azerbaijan"
set Bahamas												"Bahamas"
set Bahrain												"Bahrain"
set Bangladesh											"Bangladesh"
set Barbados											"Barbados"
set Basque												"Basque"
set Belarus												"Belarus"
set Belgium												"Belgium"
set Belize												"Belize"
set Benin												"Benin"
set Bermuda												"Bermuda"
set Bhutan												"Bhutan"
set Bolivia												"Bolivia"
set Bonaire_and_Sint_Eustatius_and_Saba		"Bonaire, Sint Eustatius and Saba"
set Bosnia_and_Herzegovina							"Bosnia and Herzegovina"
set Botswana											"Botswana"
set Bouvet_Islands									"Bouvet Islands"
set Brazil												"Brazil"
set British_Indian_Ocean_Territory				"British Indian Ocean Territory"
set British_Virgin_Islands							"British Virgin Islands"
set Brunei												"Brunei"
set Bulgaria											"Bulgaria"
set Burkina_Faso										"Burkina Faso"
set Burundi												"Burundi"
set Cambodia											"Cambodia"
set Cameroon											"Cameroon"
set Canada												"Canada"
set Cape_Verde											"Cape Verde"
set Canary_Islands									"Canary Islands"
set Catalonia											"Catalonia"
set Cayman_Islands									"Cayman Islands"
set Central_African_Republic						"Central African Republic"
set Chad													"Chad"
set Chile												"Chile"
set China												"China"
set Chinese_Taipei									"Chinese Taipei"
set Christmas_Island									"Christmas Island"
set Cocos_Islands										"Cocos Islands"
set Colombia											"Colombia"
set Comoros												"Comoros"
set Congo												"Congo"
set Cook_Islands										"Cook Islands"
set Costa_Rica											"Costa Rica"
set Croatia												"Croatia"
set Cuba													"Cuba"
set Curacao												"Curacao"
set Cyprus												"Cyprus"
set Czech_Republic									"Czech Republic"
set Czechoslovakia									"Czechoslovakia"
set DR_Congo											"DR Congo"
set Denmark												"Denmark"
set Djibouti											"Djibouti"
set Dominica											"Dominica"
set Dominican_Republic								"Dominican Republic"
set East_Germany										"East Germany"
set Ecuador												"Ecuador"
set Egypt												"Egypt"
set El_Salvador										"El Salvador"
set England												"England"
set Equatorial_Guinea								"Equatorial Guinea"
set Eritrea												"Eritrea"
set Estonia												"Estonia"
set Ethiopia											"Ethiopia"
set Macedonia											"Macedonia"
set Falkland_Islands									"Falkland Islands"
set Faroe_Islands										"Faroe Islands"
set Fiji													"Fiji"
set Finland												"Finland"
set France												"France"
set French_Guiana										"French Guiana"
set French_Polynesia									"French Polynesia"
set French_Southern_Territories					"French Southern Territories"
set Gabon												"Gabon"
set Gambia												"Gambia"
set Georgia												"Georgia"
set Germany												"Germany"
set Ghana												"Ghana"
set Gibraltar											"Gibraltar"
set Great_Britain										"Great Britain"
set Greece												"Greece"
set Greenland											"Greenland"
set Grenada												"Grenada"
set Guadeloupe											"Guadeloupe"
set Guam													"Guam"
set Guatemala											"Guatemala"
set Guernsey											"Guernsey"
set Guinea												"Guinea"
set Guinea_Bissau										"Guinea Bissau"
set Guyana												"Guyana"
set Haiti												"Haiti"
set Heard_Island_and_McDonald_Islands			"Heard Island and McDonald Islands"
set Honduras											"Honduras"
set Hong_Kong											"Hong Kong"
set Hungary												"Hungary"
set Iceland												"Iceland"
set India												"India"
set Indonesia											"Indonesia"
set Iran													"Iran"
set Iraq													"Iraq"
set Ireland												"Ireland"
set Isle_of_Man										"Isle of Man"
set Israel												"Israel"
set Italy												"Italy"
set Ivory_Coast										"Ivory Coast"
set Jamaica												"Jamaica"
set Jan_Mayen											"Jan Mayen"
set Jan_Mayen_and_Svalbard							"Jan Mayen and Svalbard"
set Japan												"Japan"
set Jersey												"Jersey"
set Jordan												"Jordan"
set Kazakhstan											"Kazakhstan"
set Kenya												"Kenya"
set Kosovo												"Kosovo"
set Kiribati											"Kiribati"
set Kuwait												"Kuwait"
set Kyrgyzstan											"Kyrgyzstan"
set Laos													"Laos"
set Latvia												"Latvia"
set Lebanon												"Lebanon"
set Lesotho												"Lesotho"
set Liberia												"Liberia"
set Libya												"Libya"
set Liechtenstein										"Liechtenstein"
set Lithuania											"Lithuania"
set Luxembourg											"Luxembourg"
set Macao												"Macao"
set Madagascar											"Madagascar"
set Malawi												"Malawi"
set Malaysia											"Malaysia"
set Maldives											"Maldives"
set Mali													"Mali"
set Malta												"Malta"
set Marshall_Islands									"Marshall Islands"
set Martinique											"Martinique"
set Mauritania											"Mauritania"
set Mauritius											"Mauritius"
set Mayotte												"Mayotte"
set Mexico												"Mexico"
set Micronesia											"Micronesia"
set Mixed_Team											"Mixed Team"
set Moldova												"Moldova"
set Monaco												"Monaco"
set Mongolia											"Mongolia"
set Montenegro											"Montenegro"
set Montserrat											"Montserrat"
set Morocco												"Morocco"
set Mozambique											"Mozambique"
set Myanmar												"Myanmar"
set Namibia												"Namibia"
set Nauru												"Nauru"
set Nepal												"Nepal"
set Netherlands										"Netherlands"
set Netherlands_Antilles							"Netherlands Antilles"
set New_Caledonia										"New Caledonia"
set New_Zealand										"New Zealand"
set Nicaragua											"Nicaragua"
set Niger												"Niger"
set Nigeria												"Nigeria"
set Niue													"Niue"
set Nordic_Team										"Nordic Team"
set Norfolk_Island									"Norfolk Island"
set North_Korea										"North Korea"
set Northern_Ireland									"Northern Ireland"
set Northern_Mariana_Islands						"Northern Mariana Islands"
set Norway												"Norway"
set Oman													"Oman"
set Pakistan											"Pakistan"
set Palau												"Palau"
set Palestine											"Palestine"
set Panama												"Panama"
set Papua_New_Guinea									"Papua New Guinea"
set Paraguay											"Paraguay"
set Peru													"Peru"
set Philippines										"Philippines"
set Pitcairn_Islands									"Pitcairn Islands"
set Poland												"Poland"
set Portugal											"Portugal"
set Puerto_Rico										"Puerto Rico"
set Qatar												"Qatar"
set Reunion												"Reunion"
set Romania												"Romania"
set Russia												"Russia"
set Rwanda												"Rwanda"
set Saint_Barthelemy									"Saint Barthélemy"
set Saint_Helena										"Saint Helena"
set Saint_Kitts_and_Nevis							"Saint Kitts and Nevis"
set Saint_Lucia										"Saint Lucia"
set Saint_Martin										"Saint Martin"
set Saint_Pierre_and_Miquelon						"Saint Pierre and Miquelon"
set Saint_Vincent_and_the_Grenadines			"Saint Vincent and the Grenadines"
set Samoa												"Samoa"
set San_Marino											"San Marino"
set Sao_Tome_and_Principe							"Sao Tome and Principe"
set Saudi_Arabia										"Saudi Arabia"
set Scotland											"Scotland"
set Senegal												"Senegal"
set Serbia												"Serbia"
set Serbia_and_Montenegro							"Serbia and Montenegro"
set Seychelles											"Seychelles"
set Sierra_Leone										"Sierra Leone"
set Singapore											"Singapore"
set Sint_Maarten										"Sint Maarten"
set Slovakia											"Slovakia"
set Slovenia											"Slovenia"
set Solomon_Islands									"Solomon Islands"
set Somalia												"Somalia"
set South_Africa										"South Africa"
set South_Georgia_and_South_Sandwich_Islands	"South Georgia and South Sandwich Islands"
set South_Korea										"South Korea"
set South_Sudan										"South Sudan"
set Soviet_Union										"Soviet Union"
set Spain												"Spain"
set Sri_Lanka											"Sri Lanka"
set Sudan												"Sudan"
set Suriname											"Suriname"
set Svalbard											"Svalbard"
set Swaziland											"Swaziland"
set Sweden												"Sweden"
set Switzerland										"Switzerland"
set Syria												"Syria"
set Tajikistan											"Tajikistan"
set Tanzania											"Tanzania"
set Thailand											"Thailand"
set The_Internet										"The Internet"
set Tibet												"Tibet"
set Timor_Leste										"Timor Leste"
set Togo													"Togo"
set Tokelau												"Tokelau"
set Tonga												"Tonga"
set Trinidad_and_Tobago								"Trinidad and Tobago"
set Tunisia												"Tunisia"
set Turkey												"Turkey"
set Turkmenistan										"Turkmenistan"
set Turks_and_Caicos_Islands						"Turks and Caicos Islands"
set Tuvalu												"Tuvalu"
set US_Virgin_Islands								"US Virgin Islands"
set Uganda												"Uganda"
set Ukraine												"Ukraine"
set United_Arab_Emirates							"United Arab Emirates"
set United_States_Minor_Outlying_Islands		"United States Minor Outlying Islands"
set United_States_of_America						"United States of America"
set Unknown												"Unknown"
set Uruguay												"Uruguay"
set Uzbekistan											"Uzbekistan"
set Vanuatu												"Vanuatu"
set Vatican												"Vatican"
set Venezuela											"Venezuela"
set Vietnam												"Vietnam"
set Wales												"Wales"
set Wallis_and_Futuna								"Wallis and Futuna"
set West_Germany										"West Germany"
set West_Indies_Federation							"West Indies Federation"
set Western_Sahara									"Western Sahara"
set Yemen												"Yemen"
set Yugoslavia											"Yugoslavia"
set Zambia												"Zambia"
set Zanzibar											"Zanzibar"
set Zimbabwe											"Zimbabwe"

set German_Empire										"German Empire"
set Russian_Empire									"Russian Empire"

set World												"World"
set Africa_North										"Africa, North"
set Africa_Sub_Saharan								"Africa, Sub-Saharan"
set America_Caribbean								"America, Caribbean"
set America_Central									"America, Central"
set America_North										"America, North"
set America_South										"America, South"
set Antarctic											"Antarctic"
set Asia_East											"Asia, East"
set Asia_South_South_East							"Asia, South-South-East"
set Asia_West_Central								"Asia, West-Central"
set Europe												"Europe"
set Europe_East										"Europa, East"
set Oceania												"Oceania"
set Stateless											"Stateless"
set Teams												"Teams"
set AnyRegion											"Any region"

;# don't need translation
set ASEAN "ASEAN (Fide)"
set FIDE  "FIDE"

} ;# namespace mc

set region(--) {
	{ UNK -- -- 0 1 Unknown }
	{ ZZX -- -- 0 1 Mixed_Team }
	{ NET -- -- 0 1 The_Internet }
}

set region(Stateless) {
	{ SEA -- -- 0 1 At_Sea }
	{ AIR -- -- 0 1 Aboard_Aircraft }
	{ SPC -- -- 0 1 Aboard_Spacecraft }
}

set region(Europe) {
	{ ALA ax ax 1 1 Aaland_Islands }
	{ ALB al al 2 1 Albania }
	{ AND ad ad 1 1 Andorra }
	{ AUT at at 1 1 Austria }
	{ BAS -- es 1 1 Basque }
	{ BEL be be 1 1 Belgium }
	{ BIH ba ba 2 1 Bosnia_and_Herzegovina }
	{ BUL bg bg 2 1 Bulgaria }
	{ CAT -- es 1 1 Catalonia }
	{ CRO hr hr 2 1 Croatia }
	{ CZE cz cz 2 1 Czech_Republic }
	{ DEN dk dk 1 1 Denmark }
	{ ENG -- gb 1 1 England }
	{ ESP es es 1 1 Spain }
	{ EST ee ee 2 1 Estonia }
	{ FAI fo fo 1 1 Faroe_Islands }
	{ FIN fi fi 1 1 Finland }
	{ FRA fr fr 1 1 France }
	{ FRG -- de 1 0 West_Germany }
	{ GBR gb gb 1 1 Great_Britain }
	{ GBZ gi gi 1 1 Gibraltar }
	{ GGY gg gg 1 1 Guernsey }
	{ GDR -- de 1 0 East_Germany }
	{ GER de de 1 1 Germany }
	{ GRE gr gr 2 1 Greece }
	{ GRL gl gl 1 1 Greenland }
	{ HUN hu hu 2 1 Hungary }
	{ IMN im im 1 1 Isle_of_Man }
	{ IRL ie ie 1 1 Ireland }
	{ ISL is is 1 1 Iceland }
	{ ITA it it 1 1 Italy }
	{ JEY je je 1 1 Jersey }
	{ KOS -- rs 2 1 Kosovo }
	{ LAT lv lv 2 1 Latvia }
	{ LIE li li 1 1 Liechtenstein }
	{ LTU lt lt 2 1 Lithuania }
	{ LUX lu lu 1 1 Luxembourg }
	{ MKD mk mk 2 1 Macedonia }
	{ MLT mt mt 3 1 Malta }
	{ MNE me me 2 1 Montenegro }
	{ MNC mc mc 1 1 Monaco }
	{ NED nl nl 1 1 Netherlands }
	{ NIR -- gb 1 1 Northern_Ireland }
	{ NOR no no 1 1 Norway }
	{ POL pl pl 2 1 Poland }
	{ POR pt pt 1 1 Portugal }
	{ ROU ro ro 2 1 Romania }
	{ SCG cs cs 2 0 Serbia_and_Montenegro }
	{ SCO -- gb 1 1 Scotland }
	{ SJM sj sj 1 1 Jan_Mayen_and_Svalbard }
	{ SLO si si 2 1 Slovenia }
	{ SMR sm sm 1 1 San_Marino }
	{ SRB rs rs 2 1 Serbia }
	{ SUI ch ch 1 1 Switzerland }
	{ SVK sk sk 2 1 Slovakia }
	{ SWE se se 1 1 Sweden }
	{ TCH -- cz 2 0 Czechoslovakia }
	{ VAT va va 1 1 Vatican }
	{ WLS -- gb 1 1 Wales }
	{ YUG yu yu 2 0 Yugoslavia }
}

set region(Europe_East) {
	{ BLR by by 2 1 Belarus }
	{ MDA md md 2 1 Moldova }
	{ RUS ru ru 4 1 Russia }
	{ UKR ua ua 2 1 Ukraine }
	{ URS su su 4 0 Soviet_Union }
}

set region(America_North) {
	{ CAN ca ca 1 1 Canada }
	{ SPM pm pm 1 1 Saint_Pierre_and_Miquelon }
	{ USA us us 1 1 United_States_of_America }
}

set region(America_South) {
	{ ARG ar ar 1 1 Argentina }
	{ BOL bo bo 1 1 Bolivia }
	{ BRA br br 1 1 Brazil }
	{ CHI cl cl 1 1 Chile }
	{ COL co co 1 1 Colombia }
	{ ECU ec ec 1 1 Ecuador }
	{ FLK fk fk 1 1 Falkland_Islands }
	{ GUF gf gf 1 1 French_Guiana }
	{ GUY gy gy 1 1 Guyana }
	{ PAR py py 1 1 Paraguay }
	{ PER pe pe 1 1 Peru }
	{ SUR sr sr 1 1 Suriname }
	{ URU uy uy 1 1 Uruguay }
	{ VEN ve ve 1 1 Venezuela }
}

set region(America_Central) {
	{ BIZ bz bz 1 1 Belize }
	{ CRC cr cr 1 1 Costa_Rica }
	{ ESA sv sv 1 1 El_Salvador }
	{ GUA gt gt 1 1 Guatemala }
	{ HON hn hn 1 1 Honduras }
	{ MEX mx mx 1 1 Mexico }
	{ NCA ni ni 1 1 Nicaragua }
	{ PAN pa pa 1 1 Panama }
}

set region(America_Caribbean) {
	{ AHO an an 1 1 Netherlands_Antilles }
	{ AIA ai ai 1 1 Anguilla }
	{ ANT ag ag 1 1 Antigua }
	{ ARU aw aw 1 1 Aruba }
	{ BAH bs bs 1 1 Bahamas }
	{ BAR bb bb 1 1 Barbados }
	{ BER bm bm 1 1 Bermuda }
	{ CAY ky ky 1 1 Cayman_Islands }
	{ CUB cu cu 1 1 Cuba }
	{ DMA dm dm 1 1 Dominica }
	{ DOM do do 1 1 Dominican_Republic }
	{ GLP gp gp 1 1 Guadeloupe }
	{ GRN gd gd 1 1 Grenada }
	{ HAI ht ht 1 1 Haiti }
	{ IVB vg vg 1 1 British_Virgin_Islands }
	{ JAM jm jm 1 1 Jamaica }
	{ LCA lc lc 1 1 Saint_Lucia }
	{ MSR ms ms 1 1 Montserrat }
	{ MTQ mq mq 1 1 Martinique }
	{ PUR pr pr 1 1 Puerto_Rico }
	{ SKN kn kn 1 1 Saint_Kitts_and_Nevis }
	{ TCA tc tc 1 1 Turks_and_Caicos_Islands }
	{ TRI tt tt 1 1 Trinidad_and_Tobago }
	{ VIN vc vc 1 1 Saint_Vincent_and_the_Grenadines }
	{ VUS vi vi 1 1 US_Virgin_Islands }
}

set region(Asia_West_Central) {
	{ AFG af af 4 1 Afghanistan }
	{ ARM am am 2 1 Armenia }
	{ AZE az az 4 1 Azerbaijan }
	{ BRN bh bh 3 1 Bahrain }
	{ CYP cy cy 2 1 Cyprus }
	{ GEO ge ge 2 1 Georgia }
	{ IRI ir ir 4 1 Iran }
	{ IRQ iq iq 3 1 Iraq }
	{ ISR il il 3 1 Israel }
	{ JOR jo jo 3 1 Jordan }
	{ KAZ kz kz 2 2 Kazakhstan }
	{ KGZ kg kg 2 1 Kyrgyzstan }
	{ KSA sa sa 3 1 Saudi_Arabia }
	{ KUW kw kw 3 1 Kuwait }
	{ LIB lb lb 3 1 Lebanon }
	{ OMN om om 3 1 Oman }
	{ PAK pk pk 5 1 Pakistan }
	{ PLE ps ps 3 1 Palestine }
	{ QAT qa qa 3 1 Qatar }
	{ SYR sy sy 3 1 Syria }
	{ TJK tj tj 2 1 Tajikistan }
	{ TKM tm tm 2 1 Turkmenistan }
	{ TUR tr tr 4 1 Turkey }
	{ UAE ae ae 3 1 United_Arab_Emirates }
	{ UZB uz uz 2 1 Uzbekistan }
	{ YEM ye ye 3 1 Yemen }
}

set region(Asia_East) {
	{ CHN cn cn 5 1 China }
	{ HKG hk hk 5 1 Hong_Kong }
	{ JPN jp jp 5 1 Japan }
	{ KOR kr kr 5 1 South_Korea }
	{ MAC mo mo 1 1 Macao }
	{ MGL mn mn 5 1 Mongolia }
	{ PRK kp kp 5 1 North_Korea }
	{ TIB cn cn 5 1 Tibet }
	{ TPE tw tw 5 1 Chinese_Taipei }
}

set region(Asia_South_South_East) {
	{ BAN bd bd 5 1 Bangladesh }
	{ BHU bt bt 5 1 Bhutan }
	{ BRU bn bn 3 1 Brunei }
	{ CAM kh kh 5 1 Cambodia }
	{ INA id id 5 1 Indonesia }
	{ IND in in 5 1 India }
	{ IOT io io 1 1 British_Indian_Ocean_Territory }
	{ LAO la la 5 1 Laos }
	{ MAS my my 5 1 Malaysia }
	{ MDV mv mv 5 1 Maldives }
	{ MYA mm mm 5 1 Myanmar }
	{ NEP np np 5 1 Nepal }
	{ PHI ph ph 5 1 Philippines }
	{ SIN sg sg 5 1 Singapore }
	{ SRI lk lk 5 1 Sri_Lanka }
	{ THA th th 5 1 Thailand }
	{ TLS tl tl 5 1 Timor_Leste }
	{ VIE vn vn 6 1 Vietnam }
}

set region(Africa_North) {
	{ ALG dz dz 3 1 Algeria }
	{ EGY eg eg 3 1 Egypt }
	{ ESH eh eh 3 1 Western_Sahara }
	{ LBA ly ly 3 1 Libya }
	{ MAR ma ma 3 1 Morocco }
	{ TUN tn tn 3 1 Tunisia }
}

set region(Africa_Sub_Saharan) {
	{ ANG ao ao 3 1 Angola }
	{ BDI bi bi 3 1 Burundi }
	{ BEN bj bj 3 1 Benin }
	{ BOT bw bw 3 1 Botswana }
	{ BUR bf bf 3 3 Burkina_Faso }
	{ CAF cf cf 3 1 Central_African_Republic }
	{ CGO cg cg 3 1 Congo }
	{ CHA td td 3 1 Chad }
	{ CIV ci ci 3 1 Ivory_Coast }
	{ CMR cm cm 3 1 Cameroon }
	{ COD cd cd 3 1 DR_Congo }
	{ COM km km 1 1 Comoros }
	{ CPV cv cv 1 1 Cape_Verde }
	{ DJI dj dj 3 1 Djibouti }
	{ ERI er er 3 1 Eritrea }
	{ ETH et et 3 1 Ethiopia }
	{ GAB ga ga 3 1 Gabon }
	{ GAM gm gm 3 1 Gambia }
	{ GBS gw gw 3 1 Guinea_Bissau }
	{ GEQ gq gq 3 1 Equatorial_Guinea }
	{ GHA gh gh 3 1 Ghana }
	{ GUI gn gn 3 1 Guinea }
	{ KEN ke ke 3 1 Kenya }
	{ LBR lr lr 3 1 Liberia }
	{ LES ls ls 3 1 Lesotho }
	{ MAD mg mg 3 1 Madagascar }
	{ MAW mw mw 3 1 Malawi }
	{ MLI ml ml 3 1 Mali }
	{ MOZ mz mz 3 1 Mozambique }
	{ MRI mu mu 1 1 Mauritius }
	{ MTN mr mr 3 1 Mauritania }
	{ MYT yt yt 3 1 Mayotte }
	{ NAM na na 3 1 Namibia }
	{ NGR ng ng 3 1 Nigeria }
	{ NIG ne ne 3 1 Niger }
	{ REU re re 1 1 Reunion }
	{ RSA za za 3 1 South_Africa }
	{ RWA rw rw 3 1 Rwanda }
	{ SEN sn sn 3 1 Senegal }
	{ SEY sc sc 1 1 Seychelles }
	{ SHN sh sh 1 1 Saint_Helena }
	{ SLE sl sl 3 1 Sierra_Leone }
	{ SOM so so 3 1 Somalia }
	{ STP st st 1 1 Sao_Tome_and_Principe }
	{ SUD sd sd 3 1 Sudan }
	{ SWZ sz sz 3 1 Swaziland }
	{ TAN tz tz 3 1 Tanzania }
	{ TOG tg tg 3 1 Togo }
	{ UGA ug ug 3 1 Uganda }
	{ ZAM zm zm 3 1 Zambia }
	{ EAZ -- tz 3 1 Zanzibar }
	{ ZIM zw zw 3 1 Zimbabwe }
}

set region(Oceania) {
	{ ANZ -- -- 1 0 Australasia }
	{ ASA as as 1 1 American_Samoa }
	{ AUS au au 1 1 Australia }
	{ CCK cc cc 1 1 Cocos_Islands }
	{ COK ck ck 1 1 Cook_Islands }
	{ CXR cx cx 1 1 Christmas_Island }
	{ FIJ fj fj 1 1 Fiji }
	{ FSM fm fm 5 1 Micronesia }
	{ GUM gu gu 1 1 Guam }
	{ KIR ki ki 5 1 Kiribati }
	{ MHL mh mh 5 1 Marshall_Islands }
	{ MNP mp mp 1 1 Northern_Mariana_Islands }
	{ NCL nc nc 1 1 New_Caledonia }
	{ NFK nf nf 1 1 Norfolk_Island }
	{ NIU nu nu 1 1 Niue }
	{ NRU nr nr 5 1 Nauru }
	{ NZL nz nz 1 1 New_Zealand }
	{ PCN pn pn 1 1 Pitcairn_Islands }
	{ PLW pw pw 5 1 Palau }
	{ PNG pg pg 5 1 Papua_New_Guinea }
	{ PYF pf pf 1 1 French_Polynesia }
	{ SAM ws ws 5 1 Samoa }
	{ SOL sb sb 5 1 Solomon_Islands }
	{ TGA to to 5 1 Tonga }
	{ TKL tk tk 1 1 Tokelau }
	{ TUV tv tv 5 1 Tuvalu }
	{ UMI um um 1 1 United_States_Minor_Outlying_Islands }
	{ VAN vu vu 5 1 Vanuatu }
	{ WLF wf wf 1 1 Wallis_and_Futuna }
}

set region(Antarctic) {
	{ ATA aq aq 1 1 Antarctica }
	{ ATF tf tf 1 1 French_Southern_Territories }
	{ BVT bv bv 1 1 Bouvet_Islands }
	{ HMD hm hm 1 1 Heard_Island_and_McDonald_Islands }
	{ SGS gs gs 1 1 South_Georgia_and_South_Sandwich_Islands }
}

set regions {
	--
	Europe
	Europe_East
	America_North
	America_South
	America_Central
	America_Caribbean
	Oceania
	Asia_West_Central
	Asia_East
	Asia_South_South_East
	Africa_North
	Africa_Sub_Saharan
	Antarctic
	Stateless
}

foreach rgn $regions {
	foreach entry $region($rgn) {
		lassign $entry code iso1 iso2 lang active country
		set info($code) [list $iso1 $iso2 $lang $active $country]
	}
}
unset rgn


proc name {code} {
	variable info

	if {[llength $code] == 0} { return "" }
	return [set [namespace current]::mc::[lindex $info($code) 4]]
}


proc iso {code} {
	variable info

	set iso [lindex $info($code) 1]
	if {$iso eq "--"} { return $code }
	return $iso
}


proc countryFlag {code} {
	variable _Flags

	if {[llength $code] == 0} { return {} }
	if {[info exists _Flags($code)]} { return [set _Flags($code)] }
	set file [file join $::scidc::dir::share flags $code.png]
	if {[catch {set _Flags($code) [image create photo -file $file]}]} { return {} }
	return [set _Flags($code)]
}


proc makeCountryList {{languages {}}} {
	variable Vars

	if {[llength $languages] == 0} {
		set languages $::mc::countries
	}

	set result {}
	foreach lang $languages {
		if {$lang ne "xx"} {
			set country $::mc::langToCountry($lang)
			set flag $icon::flag($country)
			set name [::encoding::languageName $lang]
			lappend result [list $flag $name $lang]
		}
	}

	return [lsort -index 1 -dictionary $result]
}


proc makeToolbarIcon {countryCode} {
	variable Icons

	if {![info exists Icons($countryCode)]} {
		set Icons($countryCode) [list \
				[::icon::makeStateSpecificIcons $icon::22x22::flag($countryCode)] \
				[::icon::makeStateSpecificIcons $icon::16x16::flag($countryCode)] \
				[::icon::makeStateSpecificIcons $icon::32x32::flag($countryCode)] \
			 ]
	}

	return $Icons($countryCode)
}

namespace eval icon { ;# 16x11

set flag(AIR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAAqElEQVQoz72RMW4CQRAEe5cT
	ZA7JeQOv8QMc8jxSQvMQJAJLdmAf6LQ3U02w5DYErqiCGk3Q5fXoMdRBNEQopBYETEGD1iVY
	Vg3fobdNr20XLCRwuiSLVE0MTjvt3fs4TKEZHU6jfmPzMqhR9SD/c/Az51/Sz8v81IfztT2Q
	f1yHCkV1u16lnSjt5C6BcR9BiS1JlO3+8tXuQ07BFEpQoIZA3QMJhbTUDUFElORS65rAAAAA
	AElFTkSuQmCC
}]

set flag(ANZ) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABr0lEQVQoz2M4Xt7cXr+cwXxq
	r7rzRFVHBuX2UtvM7YXtDNzFDAzJDAzxDAzRDAyBYGTPwGDJ4O3b++rYyad3n91ds/nOklV3
	D595e+POyq1X8pu3ZdRuiitZE5y91Dt5gVvcXOeY2QwM1gxnOTmf9fW/rKp8kpP9KDXleWH+
	g/yCa2lZmm79aAiswZyh3zT0xc59H5cseljf8Kip5ePypbd7Jm5umgFUYWbWfv/eiw2Tip49
	eeHnNxWsQZehvnP7izMXFy46dKJ7+qn2KfN33r63Y9+SCWuAGm7fellXtyk7pb6wcOWL5x/B
	GlQZsl1Lp0zdHVW1radiXlfJbJ+cNQVtO2Z1rgRq+P//f2jITDW1Wlubrl+//kA1AIOivG8v
	pouB6M7tVwL8+QICBYyM6deuPgNrkAdqiC/v2o1Vg41NV37eCqAloaEzg4KmgzVIAzVEFrbt
	wKqBgSGNnT1LS6uemzsXyAZrEAdqCM5v2RZdtAqOogpXBmctC8hc4pO6GA0xMPADNfgyMHgy
	MDiCIoXBlIFBn4FBE+w5oHMlGRiEGRh4VR2bGRhYGRiYgQgAU+bSwhDN3zcAAAAASUVORK5C
	YII=
}]

set flag(ASE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAMAAABBPP0LAAAAllBMVEUAEGUAEWUAEWcAE2kA
	G6YAHKYAIKoAIqoOK6kPK6oRLaoSLqoULqr/AAAmMab/BAApNKb/BgD/BxT/CBT/Ein/FCn/
	FCoyR7cySLepMXSqMXKsMXKtMXIyUbsyUbzTK1zUK1zXK1syU7v/QAD/QgCBXKiDXKiEXKi+
	V4zCV4n/agD/bQD/eAD/fAD/rgD/sAD/uAD/6gA9cbfdAAAAe0lEQVQI112OxxLCMBBDnWQN
	KSxg0kxPJb39/89hj5cLOmneaCQxS4vZjmMzYy0pZVo0Xfd5pspqwMHPUSnzgBuwf4hhmgZx
	2xkAhwiXbZsxCcCAc4jVupZ4ORIIYkr4QB130Y9jf7pSBwcv0ytvl1bUj1fdtvXvx9/TLzI9
	C29KHAOhAAAAAElFTkSuQmCC
}]

set flag(ATA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAMAAABBPP0LAAAAhFBMVEUDLpgDLpoDL50DMaID
	MqcDNKwDNa8EL5kFN7M6fc48fs5GhdFJh9JLiNJNidNQi9NSjdRaktZ3pd2Emc6Gr+GOpN2U
	ueSXu+Wcvuadvueev+elw+moxemuyeuwy+u2z+250e7B1vDE2PDQ4PPj7fjs8/rt8/vx9vz0
	+Pz6/P77/P7////Ro2IBAAAAaElEQVQIHQXBQQ6CQBAAsLIMggQ0ejL+/4MYTEBxx7YZoGZm
	ZuoJM4jTCtbgnVzupu+2fEaF9lZM6OYewVGfJUCHgrUN4HqmIBpAUyjYV0D9EbDkqUbPto2C
	iX1XH47XSDOAmpmZ2fMHbKUnlq5kVCEAAAAASUVORK5CYII=
}]

set flag(BAS) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAMAAABBPP0LAAAAbFBMVEUAYS0AezoDYC0QdTkV
	czgdbzckbTclUipDRihOo3ZVoHVYqH5YqX5im3RvNCN2nXt4TC+BSC6XJR+XQCyYhm+mHh2n
	Hh2wfG2yWFjHx8fRKSbTKCbWJybXd3LcbGnfamjjaWjkcXHsnJz///9eOqVfAAAAZklEQVQI
	12WOyRZAMBAEJ3YSO02sE/P//+jAhfS5XldRkHUAAAsA6DJK82I4mFmY+RgKonGKVdSum2xr
	G6myIvDShCrppU9U2Jyg+XJur7UWrevdXTNZ+cy+hDFizEN4H57F6/iX3kAiDl/ncaakAAAA
	AElFTkSuQmCC
}]

set flag(BES) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABcElEQVQoz32QTyiDcRyHP7/3
	j/3WZrysFTk5vt7WMOXosGiuju5OShQ1F1eUlHJQchAjZakp1OywHVZEbP409SIr01vTsu01
	M+/rYDGbPOfn+fTtS/zLJpTQoangW9iGUVIjogpN01e2oxyAPpcD0AAwph5GGCOstdq+TaRn
	liPbe1ccAOh5vRA/iHsVRbHb75zORkJIub3oPfHMBlubLIRnGWg5xtwbTuwIgjDYJqmqGgqF
	vtVE8qV/aGvYs5tRC8TIA2BY61SGm0ilUo4nJeFydzwpyWQynU4DWPdfdg2s7O1fE7OB8OzX
	BEeM3ZRSAKzVSp2drCDUa8XMKzMys7u6cQqeJRYD9J/zOACUUkmSArLcPDd9m81GYoaxhc3r
	2CNqKSEot0sBAFEUbTZbIBBYDTKHYbnwViR1tEL9FQCIyrl5X/7o+AGUJ0b+T7sU5N+KS1tn
	a77z98KHo70F/8Ld3D+PuycvYo8w8hXv/5NPYZyIU3Q193sAAAAASUVORK5CYII=
}]

set flag(BLM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAMAAABBPP0LAAAABGdBTUEAALGPC/xhBQAAAAFz
	UkdCAK7OHOkAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAA
	AWtQTFRFxsbGw8PDv7+/wsLCwMDCwMDA/f394+PkrKum8vL59vLkzL+IxrZ7xrh90caV/v37
	1dfbsbGu8PDx////1NTUV1dfb25f9fS49OzEsYwTzKwuxqQivJ0////ayciNWVlfcnJ07u7u
	urq6SkpKjo6Vwr6lx83DjZiomaSfkpuVk56rys6/tbCafH2DUVFQ3t7e6urqdHRzgoKAiYKK
	eZCqVZj6WorpNm/YMnDDc4CfkYmFd3d0jY2N+fn5q6usTExOnLSauG9q2S5Xu1ZvqCRJowAn
	qIVzjaGUU1NX2NjY9vb2m5udiYqO9f/i0aqnjiw4iFZ9gz1Vgig47tq+4uzWdnZ9tra2/v7+
	/PrT+/PP8v//OYHoE1GuAEe0aaf79Oy6/fzj9PT0+vjd8e/I///70trQVGl/cYOX7fPl7uu/
	///58vDsxa1a5NF+6Oam7uij2cNp0cB4/P3/tLGqqZmKvrvCu7SzqZyGvLu6UwixhgAAAAFi
	S0dEEwy7XJYAAAAJcEhZcwAAAEgAAABIAEbJaz4AAABqSURBVAgdVcG9EQFBGIDh9z3fzRhr
	NlGDSCU6uEZ0oQkhVYgVoAH5Biv0c2ZcYD2PCI50b5i9YLT3T43nylYJsi2CbIvgtvHngm5t
	nTrudTk5p5QguLL2i4VHsM8wODlAjUeBue7ZaYHxAwpOFf+g5ouDAAAAAElFTkSuQmCC
}]

set flag(BWI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAACCUlEQVQoz0WRW0iTcQBHf//v
	+5a7ubnVWEvYzA2bLpCwsmBDS1uFhNASEosoerAizSCCeqiEoCYrmmEPgyZFdHsIA4mizY2I
	wiDsgrUuzsGMdbNdXG77Lv8eojyPB87TIbB0gQIACAEBAFD6zwCEAAAFKP1rOHu1Yeh8by5f
	uvXg7XyuCFEyVuo87lpQej/yMZn4AYbR6JUd7jqVQtZ97CI567sqKK3xmfSJ/c7QeLxCLW9c
	aej3j0iU9O7bHEtks3PF9fWV3uCzGoteLU6T3Ye9e3d1JFKZiXepTL5Uju/t7KkWaxIE4amq
	e/zpPNUt0SkdNoPZpA1eu8MKKkf8J+cbfu5sMA/0tbYph6w0CgpQLNek3S67e8eBh08/nbkS
	TWcLE68nmclYShSlEi96L4U1a/sj4TH8h0Vo9La64dxg4EmxJEqUxj58ZTY6bSgIAL1+uTM5
	drypuWkhkNC8tTMR6gkMeMCLKPAtLhu3qtbUd3Cbd54fvPnipD9cpa8LukxLF6UAfJ4zH7qg
	/ZIbbt+wYurxEUUZ5/X/4hRlXHh8euZbbtO6auNiJcvKMo2el6+iEqXWNc427awgCPU1xhuj
	byzLKvQaBTGt7g74js5mCiORmMiLoJDJuZ1bHAzB3Ufvf+eLIOBk7PZWe7lKvqfHS2DugiiB
	ACy7cFqQAIBjFk6LIijAMn8AaOzZCY1EIrEAAAAASUVORK5CYII=
}]

set flag(CUW) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABgElEQVQoz3WOy0ocQRSG/+qu
	abwEw1xwoYgjJChG4l58BUEE9z6BD6NvILgUfIMsRXChIYEhZi4wcZxba3d1V1V3182F0YwB
	v9UP5zv/OWT+654QBACZqhAaEH8OgBfMAQCgCuODA7BKwApKDBWCfDs/GoS80RzxrHhgWZxk
	cZqnvIgSqZUV+Ue88OvmggIYhLzRGjU74z8hDyORppoxGWdZygtl7Ku9Wq8B8ABc3XR/3A4P
	D7bWV2q9XtIdPo4Zf2TZpA3AhwZAnTfdj2R3wI5PL68b/THjuTL/qS+2BkA9G/T6abP18P3q
	Pi2M1BbOe748gTJQhksAdHk5rZbFfOUWFVgQvEMWjepLC0YrcnZS3d354vTPf0OH10UpHUtc
	xFwUOZ6vJew3+bS9/3l9s90dAgABHP4GwGrtTOHyWBliiqy+WO3chbTZKfmzZaD8ptsBzhDk
	xEhQUD9GgNEwvht8oBurtVb7ItcBSrPwpx0peX4w+b01BXE+jISyMzPeE0sE32qMmJ5qAAAA
	AElFTkSuQmCC
}]

set flag(EAR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABjElEQVQYGTXBQW8SQRQH8P97
	M7OzLJQtFjA2ldaYFKMnG2/Giwe/iAe/p148aDStRg5q05VGRWuj0MLuzrwnUvn9aLf7NEn8
	Yl6axDNriKVIlWU+hmDExkDMLqoAQkQArDUm1rWzDNayusg3W8M7d5mpWizeH40S36jKAMIV
	VTWd7D5AACKqvJM9fvJof7jX2WpV9bzX7/6YTEBQIQBEBIBFBFeo3hn0B4N+3k23d7cCXTRz
	t3PrehkvlQLW2BiLFedMeyP7eDwSLT8dfzgZf3777jV7TlseIKwxw2IlhpC1MmtNMT5p523j
	zGbn2tn52aIqAQWgqkRkVRiEpcW8ksjD4T2TyI3t/vmvmTMbh4ejr+PfBv+pKjMbrBjbePPq
	aDat9wb7ve7NBwcPQ02nxcRRAjJYM+30gMkB0fnGdDYrvhTeZ9M/l6fF9xfPX34b/4w1GTIE
	AkBLt3vPQKwaAESGaCArTFARFZA4axOIQKGqvESsIsGnGf6x3jdjxdakGrmZ5gRmZQItMTOA
	v+EIrinMoYzzAAAAAElFTkSuQmCC
}]

set flag(EUR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAMAAABBPP0LAAABJlBMVEUeTrAlU7IvW7YbS68q
	V7QnVbM0X7c1YLhJb79keo0tWbVHbb4kUrI3YbgiUbE8Zbo5Y7kxXbYZSq4oVrMSRKsyXbcz
	XrchULEeTao4Yrloen04W5QgT7AmU7JIbbVCZqk/ZKx2hYOHjGZMcsBEZJQuWrVFZpqFi2QY
	Sa0dTa8XSK1Oc8AOQaoMP6kxXLZGaKZQdcEPQqoTRaw6X5osWLQWR61KbrZ2g3wuWrBKcL8m
	VLJLcb8URqwfTrBDa71BabyMk3SpoE09Y6cQQ6sgTaVEa70wW7YrWLQ2XaStpEwvVZsnVLKK
	kXcoVbNieYsjUrEjUbGhn19zgoGbml6+slQRQ6tNcsA8X5YkUrE+ZrssWbUxW6yGjWxFbL0i
	ULElUacVR6wAMJQwjQZIAAAAmUlEQVQI113ONRaDABREUTRoBALE3d3d3d097H8T+Wl55S3m
	DKJqQtT31UUSrCet05uMtw7ANpWT5j2//WBAzZM2AJo8OSJWHJlWHgT7AlgM8sMLjlj4dfWO
	cQAr6Tv7xJybOtPFBBqAaMbFYAsGfBlBqQEUS2LhGebJ/tKrUAGAUBQGdnvmiMmULQEwlv8P
	3OURRzfOWQBNPzG5JkGp1EazAAAAAElFTkSuQmCC
}]

set flag(FID) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAMAAABBPP0LAAABv1BMVEUAGj4AGz4AGz8AHkEA
	Hk4BIEMBIUECIUMBIkEBIkMCIkICIkMCIkQEI0YAJFIAJVQFJUYGJkgHJkcHJkgAJ1QIJkgH
	J0gHJ0kIJ0gIJ0kIJlQJJ0kIKEkAKVcJKEkJKUkAK1cBK1YBLFYBLFgCLFgDLFcDLFgELFkD
	LVgFLVoGMFwHMFsHMF0GMVwKMF4OL10IMV0JMV0SMFIJMl0LM18LM2AXMlMLNWANNWEcPnAd
	QGwiR3InSnkoSngpS3grTXwtTXkrT3UuToMvT4EwUHgyT4AuUXgzT4MyT4YyU3g3U4o4VnxD
	W5VEYYRMZo9RaaBbdZ1gdqFkda5vfrxqg59ziaJ+iMh+iciAict4j6mMktaPldqKmrmTl9yQ
	mdOWmt+TnNeXndmVoNGaodOboducoduXp7uepNaepN2eptigpeCgptigqNOdqdOcq8WiqNqk
	p+OdrcCjqduhrsWhr9GnrN+ls8WlstSpsdqrs9yss92ttdWutd2utd6utd+zu9y1uuS4uey5
	uuy1vd+3vt+4wty5wt66xdS9xdW+x9nAxt/BxubR1OvS1PLS1PPT1uzW3Ore3/Xg4fXn6PPz
	8/03sry0AAAAw0lEQVQI12OQlJSRZ2dgZGZiYGCVk5OUZBAzV+d3DEkray8M9RRRMxdmkFFw
	y+uc0uEbOWFyZ7G3rAwDj3XbxP4YKT4Wq9aeSV0unAy8Jb31LX4BDloW5d3NfdUCDEa5VbVV
	DYHGynZ1NZUVOWYMgkmNRaXJ+gY6tpnZ+U3p0gzcNgkFGSlBzvb+calZia6cDDJKzuHR8RGW
	usGxUWHuijIMwiYaKk4+etqGml4eKqqmwgySwjIyXGxCkqISXBySMuKSAJfiLpEKKkx3AAAA
	AElFTkSuQmCC
}]

set flag(GDR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABtElEQVQYGQXBS0uUYRiA4ft7
	v3dmJBtGyzQwSURDxFHSNgoWWEGEUMuIXBUtbBUG7d21CfoF/YDAbdiiTRQJUTgtIuiggoXB
	6FDO4T09T9eVLS1dJrURIbc+CgAAgHNNoFTqBpxrAoANob26+hgQEQBwruOcc67tnIsxiiQA
	CCGsr7+wxhjg/WYthrC2tmZzZkbzf06Bcin7+C3FBHBxYeHGzUXADkGPyFAIMcalqYF9f3B+
	tPjra1BhcKygmR8onrCdyinXOR0DYG8FN5vSbAjq/Uah3lPSK29b6a41ZOZ568eI6ZL6k9p+
	b7VaCNGC1eA1JbxXH8b7zcm9NHOo735rhs7V9fogB4MGkHZHg1cwCqSo3qvrvNqWPeXDhClD
	Lryez/eUjW0BxDtNIYEN83BONRdNMvmJRptju9rdR0U4qsnmsJk8DiD3VC9knTdYnULPiPYm
	kbSyOPZy5/vupaL5opqhy4XhQ7l2dqT/Tl/x9nKr+VmuYvFoDBRmDL76aG7n2f0/P22rqEC5
	mU2Mx+qDh0CrsYWKaZKtP53uSohHc7IEABQqW5KRGtMAAAD1I/56/gOYa/dxUWXvxgAAAABJ
	RU5ErkJggg==
}]

set flag(GGY) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABEAAAALCAMAAACu/pY1AAAANlBMVEXKDyfMIDfNKT/e3t7o
	ES3oFi/qKD7rL0jrM0vsQkbuTWLvVVj0nT/0pBz0pRz4zBj53Bb///8fYWaAAAAASElEQVQI
	12NghgBGBkYoi4FZEAy4ebghDLgIGz8bbhEmLnZ2TnZ2Vn5WMM3FxMDAwcLCy8/PLwDEfCws
	HAxY1BBjMhb3oLsZAO0tB5BB+ddWAAAAAElFTkSuQmCC
}]

set flag(IMN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAYAAAB24g05AAABTklEQVQoz5WSPUjCURTFf08U
	S+xLhSSJCKGQhmotidagraklg7agta2pMZf2FmnJpoZa2oLAtsiiMmiIiEDK/Oiv+ey916Bp
	ikHd5cLl3HPuuRxx04mhpSoapIEPDVatSwMaMID4gbUD+LeiTQRaKYxWGClRpSLaslClIkZK
	jFZgDEIIEjt7VQKA8kasqi4EYHAYuA16GV+ep7wdo2D7pEfX4ciFscYFTeo2we7UED5PgEx3
	BefDO8NAIhzkKVtg8eoNl264trUSOJVmJHXN3MEpk6k05+4Xcn1dZHyDLCVfm5bbEgDMpF3I
	Xjf9a6tYzxkeo+vIjiyOpvfR3sJ3XUz4uTuKE4knKe9fMmBvq9X+AoDwyT3TGQeHsyHyLomn
	ov9HADB6fEY6n8NrOX7F1C04NyP1oarIegZWLAsVCiBrGWj9gmhNotLVxP01iV/CDJs36+aO
	zgAAAABJRU5ErkJggg==
}]

set flag(JEY) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABIAAAALCAMAAABFyS02AAABPlBMVEW4CCy4CS28DDC+Fjno
	yM/py9Ht3eHDMlDENVLpydDpy9Hi4tjl5drh4dnn5+Dh4d3q6uerRBetQBmzRS21Uzq8fDG+
	ACe+fC2/Aim/Ayq/BCrACS/BCi/BDDLCDjPCDzTCGTzDFTjEGT3FGj3FJkfGIUPHIUPIKEnK
	L0/LMVHLTWfMNlTNOljNUmvOPVvPz8/RSWXSTmnS0tLTUm3VWHLVW3TV1dXYZHzYZXzYZ3/a
	bYTab4Xa2trde4/e3t7fg5bg4ODid3fjkKHjkqLj4+Plp7Tmn63op7TpqLXqucPrsr7stcDu
	vcfv7/Hwxc7w3+Lxx9DyzdTz0Nf01Nr03eL08uH23eL29PT33+T45en55+r67O/6+vX6+vr7
	8PP78fP99ff99vf9+Pn++/z+/Pz+/f3+/v7//f7//v7////wAihgAAAAEXRSTlPk5O3t7e3t
	9vb29vv7/Pz9/cfpEOoAAACvSURBVAjXY2Bk5/T19RXg4+Hm5XdxceHiYGBgdXR0TMzMDBUX
	jcnMTLB1dGRh8M30UFLzjvUXFAqP9VJVds/UBwqlxVlJGocIi0QYSlnHx0KE0jIDtWW1dGV0
	gjIzYUJpmammYmKW6UARuKpIEwkLUwnzaLiqZCc5zYDYWB91RbcMiJCfhrxzSiwQJNlL6wUD
	hdiA7orKhIIwA0dHfQYmFU+gox3sbMyM9IHAVYEZAGNGNFMaWlNJAAAAAElFTkSuQmCC
}]

set flag(JMY) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAMAAABBPP0LAAAAOVBMVEUAAAATRRA/Pz8caBhU
	jVEnpiMoqiQvqit7qnmqqqo7+TU8/zZG/0Br+mds/2d0/2+4/7XJ/8f///+y74xgAAAAPUlE
	QVQI123JSRKAIBTFwCCzCoj3Pyzl7n21lwl8bMYTzAUXvAiO2HbRIqkfoifyOMXIlHmJWai3
	UX/CywJqtAXx/L9fOQAAAABJRU5ErkJggg==
}]

set flag(KOS) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAMAAABBPP0LAAAARVBMVEUCPX0DSqcDT6MFQa0Q
	Pu0RPu4XSu8aUvA2gfVAbJ1FlveFw/qZflqt1/y3k03Jn0PesjTitzDwxybyySX0zSL51Rz8
	3RcD5sLNAAAASElEQVQI12NgwACcKAAkwMTNzsvBws3FxsHNBBGAAVYmJAFRITAFE+ARERMT
	RBbgFwMCPiQBRgExMWFmJmQz+JkQZqC7Aw0AAFA3A54vLhP/AAAAAElFTkSuQmCC
}]

set flag(MAF) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAMAAABBPP0LAAAAsVBMVEUAAEkAAEoAAEsAAHsA
	AHwAAH0AAH4AAIABAX0CAn4DBoIEB4MFBU4FBYIFDIYGDYcNFI4NFY8nJ5AnJ5InJ5MuLpdJ
	SXBLS3GCgoyDg42MjMaPj8eSksmVlcuWlpaYmMyYmc2ams2bm86ekcOhksKkj72mi7fc4PLe
	4/Pi4vHk5PHm1uPn0t3/FSD/FSH/Mi//Pjv/XVj/ZF7/3l3/6dL/72//73H///j///z///3/
	///Ai0IvAAAAeUlEQVQIHQXBQUrEQBQFwHq/GxkYRVeCuPD+pxJ1IZPMQjABNWliVR5PAOA3
	Xp4B8PnaUssDgLflp5LpnbFvg49L0iXX/jQOR6ZrolNjavdb2tdlLzpqm+t8rPNfoaDWeRvz
	UtBBG3v2Bjp3HFU53QRScJxv870G/gFLHyzwYZIvxwAAAABJRU5ErkJggg==
}]

set flag(NET) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAAAsAAAALCAYAAACprHcmAAABxElEQVQYGQXB7UsTcQDA8e/v
	7ryt7bzbk6sGQwSFYiEIk2iVBT28Kd/5wugP6I2vfWHYqwRfRO97tQgCKehFCBEVhURQYlLR
	41hOpwxvyp6v7R52fT4CAMD3fXHr8ZPhsxn9+iDG8dXP2q4f3H6evzm9BwAgAPJrO9Kz3tJi
	IqouZMNn1JCSY6No47bNbpcPiw9n5u8ByAD7WXt+YGTz7qXIaTmXyrAeGKXa9OkWLGUwUriq
	DV2plD692VBOnFuO1fqv7kiOBXqScmAS4Un0HA/HhtqfNKem1pZcfe6R4jq9C97PaMixZljl
	MolkD7dj0zAtaDhowTrh0WIiYMezit1tx/iWpKv2OVgvc2hEUFwfdd/CKVm04jUqPypUSiKm
	SLJc8A6ieL/71EIrGOYEwhym3bDpmG3YTsHuNJL/ryhH4uf3ND18g0g1XtbzNGJv6Tt1RNVA
	Eh5qyCEg6x+bW71luW6+74+NX9sMo80eOeoMOH4HO14heLLOMXWSWNpou3Z99uuL23sCAGA8
	N3cxOKQ+kKaKY2FtROjNnO8j//r+cuV+4fXTd8BfAQAACBBGIj2R0RLpVKteqh1ufdkBTKAF
	eP8BZke/giBcrugAAAAASUVORK5CYII=
}]

set flag(NIR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABS0lEQVQoz11RO0pDURA9E64J
	RnzRR4pgRIMgtuIGIojrsEkVsMk6XIB70NI6hQsQsTQpJEKKSIJPRXz33jljkRifnmpmzvzO
	jGRZhgJI8PPjrtkkcDgYIEn4Fw5AkiQAzGxRs1o56PUYY7q1hXLZChiPx5JlWZIky2wzY567
	1SoA//6GSmWZLSKj0cgVe8+NX1cEhfYASLqnTmfn7ExfX6lqJFSZ542uAXi5vDCAqlS1GF2a
	3p+fu9nV1ebenn9+thAtBobAEBrdLoDZ9TVDoPeM0byvtFpjwFXb7bWjo/LuLqmISlXm+Xyl
	9ZOTxYQYTXWlXt/o92U6ndZqteX2Zsavr8fTU3q/3+8vrwRARIbDoSNZlDsn6T29p6oUFAOI
	MTqS/44jQHl7myFIqSQiP7EF60hOJpPiL/1sdntz44HjhwekKUmQkZwXfANubSp9r4RvxgAA
	AABJRU5ErkJggg==
}]

# set flag(NRD) [image create photo -data {
# 	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAMAAABBPP0LAAAABGdBTUEAALGPC/xhBQAAAAFz
# 	UkdCAK7OHOkAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAA
# 	AMBQTFRF9xIV9w4R+lteko6ciIBArJKn/DM09xAT+RET+Q0P+1pd/jIz+Q8SikBsiD1prnua
# 	kI+diYBAn5iynFuAiT9qXIzJWorIjq/bj5CfiX8/mqC9dJ3SW4vIkJSrlJeubm58kIY+c3WQ
# 	lJetjYI7jYM7jII7mY46w7MvkIY8kpWslZiudHWQY43HYIvGk7DamqG9ep7RYozHqzFRqS5O
# 	xXGHkY6do5avuU5pqjBP+hAS+g0O/FpcrZKn/zEy+g8Q////t97mdQAAAAFiS0dEPz5jMHUA
# 	AAAJcEhZcwAAAEgAAABIAEbJaz4AAABUSURBVAjXY2RgYISAnwxgwMLBAGazMjJCBViBAmzo
# 	KiAALgAR+c0BFWCD8tn/wwUYGL8ycjNB+QwszCBbGPmBapC0yJ6XRRjKDhQ4AbYYIsCI7lIA
# 	qMkNaroWIoEAAAAldEVYdGRhdGU6Y3JlYXRlADIwMTUtMDMtMTlUMjA6MzU6NTMrMDE6MDCX
# 	avFPAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDE1LTAzLTE5VDIwOjM1OjUzKzAxOjAw5jdJ8wAA
# 	AABJRU5ErkJggg==
# }]

set flag(NRD) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAMAAABBPP0LAAAAPFBMVEWyBxSyCxSyCxWzDRTw
	ARrwARvxChvxDxvxDxzxEBvxEBzyEhvyExz1S1j1T1j1T1n1UVi8nR//1Cr/32M45k/uAAAA
	S0lEQVQI123OWw6AIAxE0VFqfRSElv3vVRGJET2fN2kz0GIYtYHm0x7zrQQzmxerWli3JyAw
	MxFXAXBJxE/k5ZLc9+T/6Tv0O7qlB7+xCmUuIEAcAAAAAElFTkSuQmCC
}]

set flag(SCG) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAA+klEQVQoz21RMU5DUQxzPq+w
	sCCxduEunIGRnSv0AFyFHoENiaOUjkioQqi8xDbDp/+3CCtKrMhWZCWMGTrl/1YYwGoFwBIA
	DINlsUxFdmS6yof+uV43AID9tgUJ0pm52eAU7t2ZsVwKaAAsz2ryWFrwWc/RgEwBTWREALAN
	w9ntOZeqhtZs20YEdrv2e3Rcjbbj6J6BCEnDpPY0j3C+WMwGW1Lg7vXx/mb78Z10UUn9Sbx9
	/yqp6OXVxdPDS0OvkpKaDFkmnVRSRWWp7KIpA2roKvn6clEUqRRIFU0qZVK0i5ZdMqDA7TNK
	2Bd6oQu9sD+QXqhCFzg9Gj8niyw3z8pGbgAAAABJRU5ErkJggg==
}]

set flag(SEA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALAgMAAAALjOWqAAAACVBMVEUAAFc/iMZWm8wq205A
	AAAAGklEQVQI12NgAAGtVatWMKiGhkYQIMDqQAAAULIMXjvoYGkAAAAASUVORK5CYII=
}]

set flag(SPC) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALBAMAAACEzBAKAAAAJ1BMVEUAAABYWVlhYWJmZmZq
	ampvb29ycnN2dnZ3d3d5eXl7e3p7e3v//wAn9j75AAAAOElEQVQI12NggAHunZ0zgWACA5cg
	GExg4ASSB0EMdhAlA2SwwaRYQXwQgwUmxQyTYpo5E2IODAAAXcsRgeHrX14AAAAASUVORK5C
	YII=
}]

set flag(SSD) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAAaElEQVQoz2PgtZnCQBIAaggr
	3+JLHEBoUAuYL0UIoGsAov9EAJCG7O5ddRPKHbOWAfU8kJLChZ77+t6B2DBrxbT//6WAeiD2
	ENZAsg0k+wEaShPt8SPfVVkMrZqweFiVRQyCagBRRCMAsnbPlkT+YCUAAAAASUVORK5CYII=
}]

set flag(SVB) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAMAAABBPP0LAAAAM1BMVEUAAAABAQECAgIDAwME
	BAQFCQkHDAwKEBBZAAB9AAB8fHx+fn5/f39/goK8fHy2trb///+6wUgRAAAATklEQVQI12XO
	2w6AMAgD0Lp5garA/3+taJa4ZeexDaFAchFHQUMyzIInX0sGQKgG6tfiD4493Rs8UgaNQ0w7
	JnMwnRSu45fKa9xRsuqXPg1yBcQ7q1JTAAAAAElFTkSuQmCC
}]

set flag(SXM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAAAXNSR0IArs4c6QAAAAlwSFlz
	AAALEwAACxMBAJqcGAAAAAd0SU1FB9wKFRQUMw4OdBcAAAGNSURBVCjPZZHPK0RRFMfPmbn3
	TfODJmUyb2EQfwBRysZKlGxmZcfCxj9gbUGhLC1QNhQ1UkosrJQwDaZMs3hKTSGN8sYMg3d/
	ufPeqCm3T98+i3Nu596DnxtjcuZYAnjAn/zHO1go3JvBZ7WTVVcXwIXiTDEGjCnOlZcaIcDl
	NZcj0WgThofU7CDETdhch5INjlMr9dITzvRd2N3tA/BR2qzYe/Fy9as/Bovz2NuHhlEjEKiL
	hmoo+v16JB9BONvdPjp5P9i/+4mauLyE05NuEW1MIAQJIQBEsZdyJBEb6XuwZeXNCnUNP41P
	nH8Hb/ZsjoIjZzqBa4nR1hVIEy5FRzX7fN05EPRFephdYmtrL+m06dA2BsIBUU8UCdIMMEBI
	sL1nNGGW85T8FCpzWwu3llUxDD/qH8Q64Dql+s0GkbIUjk0ZLerk+DGVylerjp4ZUb9P1wr8
	+3196g3FYjkSKR4eBizLjsfDQoS4nlJIdwGSM8m4cFMyJmoNmcxpMlkF+GjYMnfR4rjiNIjx
	C5yW5kl6qGEDAAAAAElFTkSuQmCC
}]

set flag(TIB) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAACE0lEQVQozwXBX0gTcQAH8O/v
	PL12OzbnpjuqTV02UVtsOmShD2Wm+SBhBBazGkTiU1BEQU8SVBBFBUEgRaMHLSrUfNqyZikx
	+sMscRbMmC+5mo3bmnN/7u7X50MmH9iNc+la/AYgQTuG/iQMLJRTCDRhDUAQ7tdwU5ByyB1k
	iQ1+dZs1w/34sBerFqiH0DGNTgZUhNWKWAJVaxjgIRog9eCz6H+KyyNHzvqWeQSGceEnxL8Q
	enGTQWiG7Cug7CSusAgdxdUIdqk+XwQC68UsA5eAP2/QNojR83h+iZlImXS8kH+WOBjZarhH
	7/bi0w9YltBzAy2sHptWxG/DL0H4iKYFOGgz/KPXdzRtrI8ZvQ9no5t19zEQg8UL6wo4dp44
	tOhcJAAACgYq06jYuvkK3uPpi6+PV5o2pUESAuAknQYSYBeoM4/9ftpYCakNK33aaFtr90bU
	9j0crz/QXti9WJ1830UjDfhVTomLvmB1yNgQu4VHXfhi36On586suluzBVmqLuQ1213XxKmJ
	w3cmYo3/li9CKOIt+TaitedPcC/H6dDQTHtzylSVTUs7DWYCNZ3LKSzN5gpK2vPkcZmzhZv2
	z7N6Zours+DdAhwOZzKhKgoI2cpm85mMTqxhGVaWS2aT+fRxTTCYmnpVQ+KTIozHSG09pYqq
	qrIil0pFjqsAhaJSWS5qtvGEMAxDSiUaDqf/A+2/18ejZTvlAAAAAElFTkSuQmCC
}]

set flag(UNK) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAAY0lEQVQoz7WRMQrAMAwDVZHM
	+f8LM4ZAMCUY0aWlXjp46G0aTgbrmHMiIIF842kmQIECoNaKD2prMfbeiQzunhMk5QSSOQHA
	z4KZce+d+5Kk1JEiaYwRt3T3e+a1AIiE5E/vBahURsmY1zfVAAAAAElFTkSuQmCC
}]

set flag(ANY) $flag(UNK)

set flag(URS) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABGElEQVQoz3WRPy9DYRSHn3v7
	RhFDkzZCsJRIfAMfwNLRYKzBJrk+C5I7iIFPUEOtJDaC2WaQ6CCRphRtnXPe19A2ueL6Tc85
	J+d/dM9YMYUZ7H1kReBBAdAMO2BpL5leT79uEn4rqPlez6sGkaAaRB6aTTe1SmUnHTzxfJQG
	obKFtulc8lflWk0h7j/yepK0DqjuE03QblLeJFdeRCEOBvB2Rfuc5UOA4mJ+QhDR4Q7A/C4v
	p0RF1hp0b//poKrgZusUFtJOg5VjXAn7oFglnsT3c0by4OwTayXdu7S7PQqUNvI7oKoQv54R
	Bt9Zf+cipzwQzACn4EXn6vUgEtSCihfx48MHVa+KmTcLZgrRdeaRWRiyz4AHBz+vtqQBSKCz
	mgAAAABJRU5ErkJggg==
}]

set flag(YUG) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAYAAAB24g05AAABE0lEQVQoz5WSvUpDQRCFvw0X
	NBAliJ0Igq2FhZ1FIEh8EZ8hja02weQdBCt/GrHOY9gKAcFOicQiOzPH4t6EGFDMwMecZdnD
	md1N7yAWKhb6sl7Eql4A1C/PAZACPCAcmYMbckNmyDIyA8tELtdvN4+lAYjnq3tWqb3Ofpmg
	2e+jVovD4w5IKAIiUARyRx5Ila6SKYLUaLD1VZAmk4nq9Xo1gkAghPQ3KSVGoxFFRMwPS/qh
	/4KUiIjSYL5BleAfBkkqDQaDF9hY771+1LqrXOJOczrk09sJrtW9OKL3NFzpFdq7Bwzvbilg
	k3Fe4+zklGyBeZBzkE2YBdkDM+EubKZDjF3ANgkeBNPqb/1GLOkZNb4BG3gUWyZ6258AAAAA
	SUVORK5CYII=
}]

set flag(EAZ) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAYAAAB24g05AAABAklEQVQoz6XQvUrDYBTG8f/7
	5pU2WhPbWvygVq2iCCIFKQ5JHQUL4iy4OHgF3oAX4cW4CS6hpaKCuyAOWYpYhQppctwca6I/
	OOPzHM5R81cNQUFpFOEGIa+3A97bFwzW9iFJGEcrMBNGOFreIboJGeZX2Lo85KV2wJApfhPc
	P2IWeyEfnVme3r74bJ/z7Owx6gNEY8NeJQfaQhXyyPHZCdfWBn0qIAlpePUFgt4dAOK3WoLS
	glKpx/N90doSAyBJknrzDxFA0PyTcU9rOM0qpeZ6pqCzWsWtL2Em/TJ2o0hhcy5TgT1TxM6V
	MRInSCzsTm9ne0EsEAtGo+k8dP90v1aKb3QAV+lWe35dAAAAAElFTkSuQmCC
}]

set flag(ZZX) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAMAAABBPP0LAAABMlBMVEUAAAAAAAAAAAAAAAAA
	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABJapdLbJtRcqFYe6lag71ahL1bhL1bhL5dhb9d
	hr9fh79ggrFgiMBhicBiicBjisFki8FljMFoirlojsNqj8RqkMRuk8Vxk8B0l8d0l8h4msd5
	msl7nMp8nct9nst9n8t+n8t+oMyCoc2Coc6Cos2Doc2Eo86FpM6Gpc+KqdGMqdGPq9KQrNOR
	rdOSrtSTr9WUsNSWsNaXsNaXstaZs9aZs9eas9abtNabtdectdiettmguNmhuNmhudmiudmi
	udqiutqjutqjutukutqku9ulvNupv9yqwN2swd6vw9+0yOK3yeK4yeK6y+O9zuW/0OXA0ObB
	0ebF0+jH1unK2OrM2evR3u3a5PHn7fXDVDuUAAAAnElEQVQIHVXBvQrCMBgF0Jvmp4spLYIg
	iI4Krr7/6izuRQdBraLWpm2S5ovQzXPYDqMIhpEIKyB4JeC9FBFnMXzRiPlDpVbf3QQDL7g3
	67RyNJP5Bd6I4BBUKReqPW1ChyD8G11b5Ndl9elqAUoskX1ll1t0W2ditElPlJRSmb3Ojoyo
	52mK2DynJPWhkhyWZRkATyoOTAKomca/HybOTi1PgxnhAAAAAElFTkSuQmCC
}]

### ----------------------------------------------------------------------------
### the following flags are taken from http://www.famfamfam.com/lab/icons/flags/
### ----------------------------------------------------------------------------

set flag(AFG) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABa0lEQVQYGVXB
	PU5VURQF4HXxgoA/hQSBkoowAUpqS3sanIblm4G1JSOgM0aNlYmVFkZMjDF2
	AgkmL+Hdvdba52yRzu8b9vf35/M5bkn6fXnZl5e7DSDxz/NNvDgGAhBujFdX
	V7PZDEDrrbcOe8h2xyp7xe7S093y3rWa2Hjy8mS8AeD84iLtzCy7pKJKLLKT
	f+7W9+05HdvrOxDG3ntrLW1nWiq7gP7suFrW2/f18YNdkyeZSiKwJCkzZYuU
	VGQdHendG52e9sPDHjRJc8pgExYYY7HITOuGySipr63mwQGmGFZXKiKjTzmF
	ySQC43WEbUm81aX288fS1k6/dz/Pvg2LhY3IUIpJCCOqbEeEJJI9ol69jseb
	5Vz5cgYyVTQjw90QRgC6FREkK6K+nq19+tzJHtFIE9EmtXQzhBEAyUcbGyIl
	gYI4SAM52EvSwy3sPthwOntigQH/+wV0IIEEEkjgCXC+BwSQwDr+AvtFaVOn
	bJAxAAAAAElFTkSuQmCC
}]

set flag(AHO) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAF6
	SURBVHjaYvz48SMDEvj3j4FBkP8fhA1Ez5+DSCQAEEAsQAk+Pj4g+f//f4ie
	/wWFDH///P/zh+HPn//Cwv/BUhDw7NkzgABigSqCqwYyHj74//s3FCEBRkbG
	P3/+AAQQC7pqIPnrF9D4/7+AGn4hawA7+B9AAAAxAM7/AQAAeXZ2TuLi8/z8
	/vz7/gABAfb4/XV0Lv7+/319ywEA//T0+fr6/Pv7/h8fDcHBhgKICagNaBzY
	/n9A1N5u9vfPv4b607U1p37/+V9fb/Tr199fv/4BEdBEBoY/AAEEdNKfv3//
	Ah336/dfoA2Zmft8/FSdnST//f23bceTvLwDQLOAesDG/WVg+AEQQIxv377l
	5+eHuh4CrK2hPgZ65sIFuAeAnr5z5w5AALH8A4U8A4oGoDqIaqRQgoQK0CEA
	AQTSAFcNjTxZWcbfv4GSDEASKMgIDBgggsoCBBBIw6tXr5Dj8s/WrZCY/gMM
	kNu3/zExAYPzzz+IGANAgAEAxmlOvh1IY9AAAAAASUVORK5CYII=
}]

set flag(AIA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABy0lEQVQoz02R
	P2hTURyFz3u5SeyrqTGplFIhmVwiRVwkKLgIBYditw46uImDgyDFqXRQ6ODg
	oAiCRZfSgiCiBRdFxCIIVURKBVFj8VGypOmLeffd+/vjEArC4fANZ/jgBJeu
	rL1Icp1cuGLXizlcCJvnG9F8/P7UqzIygXUgi8yj76AWcGbDBjsLx1/a0lRc
	DFO7PH5i1v9aCi/Pn+s4US/CJE7Aqqz68OJ9s9xbK2ykM+02kkSdn/32NZNw
	Jns9V5vaY1SifCXKF0jixObDAEjNnULzRn2yMbrNXzY1gjk6sZe49V30WZ3H
	7eljQ1mCIOyZoWurm4ANH3dHGhPVpaS6bQ62wwMP6mej0epqf8QSnEih+xTd
	u/nhKOo8IgHgzfQ4Ft/9fP69d0g5x3xv5cObWvn0kf5bx44VgBmbcz+uS+kM
	qwBpgMknC7earV3rWUiERInFkxJrlnL9ZK1oAhLtWvatnWdXb4bIHKm4wZrV
	k3hSR8Ikorr1+fefVOIUWx9bIgI4A+9FIKI8CCuxCqkn9aI+9fGnFpPSX8eH
	84A3yJwjGSsVWIRYB0qs6llJhBnEwixSHiYIwAEqi/8dmQJ+vy3AgNsHDzCA
	f5FZSACyTZQBAAAAAElFTkSuQmCC
}]

set flag(ALA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABp0lEQVQYGQXB
	32uNcRwH8Pf3eb47z2NHNtMkF6SVFeVmd/6SkbQb4UKUJG6WG7lS1i6woiTK
	rZLC36D8CatN5kxnO+c85/v57fVKy7d/FHagcsevtXvHrm37Rm/+/eZkWIEZ
	naIwOkbHGDPcs8PXry4jknu05x7g0X662DxbuzSZ1hIi6izGaqxOYlt3Pmcu
	FQJ/h2xhTn/i9150zc6gOxz1OJjZihiJEtvJ4y3AOWdOMEAQhsTBHJ5M2aHu
	amHmZq7uCgcwTPRtqT7/OMoegiEcr/ZjtbG+GFMYuVEYubJZqdvT258+5Ly6
	G+sHaXcQIjEt0bG/PIBSooJCiSnKNBFVhXCmyl+Q+U07c6Hn09Y9JYFvjOJ6
	Y0dTcOVWmVWhtWt2m6n7/TKHPPt68/mNlZ3BWNSeXH43Y9NoceXrLVUl0cJK
	oixGYmcX+98/IgfPTgijri4WQpKpOCdRGY9qhhcOFrCAFFNJQJUxPBSVhbks
	iqp3AouEpj0133RHwN4TM1FnUbVQI6AkrLzFvw5DRsc/nz5cuA+9i6UXN4EK
	KAADDDCggAK9/3EdTC0rAD4NAAAAAElFTkSuQmCC
}]

set flag(ALB) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABeUlEQVQYGQXB
	PW+OcRjG4d/9wuNWpKERjcUgkUhMRh8DiclkEUsHhi5GsQixWGph9gWsBouN
	r+Cl0dSj+rT3/zqvF8fRfZ0YE3qA0XExwgwJPRg4OCQkzDCOsPnqJVARmTlG
	7PxZ3Zn6PuLt3uHDtSHcO7eUUvr25t0IAL77c8h4v390d+pvrOan+ys3uzd1
	tpcvfh9srfVudvLSpsGYSUVURLnfHGr718HcWslOu7/+12Tt0TSkKc3S5dD3
	RkWUVK4vh8eX001aNft+PLe5bYR/OlhlszJLUw89RYWnq+RXCaTHa11rrbW2
	fbZfT7tWSmvRWknAmFDuyCN0vYsri/qwfzTK3NrHZT5YdAuvNJUMyaA3QF4y
	b21ye7779/ailnNbzu3+qe7Jj+XkVjLMMvwIxoQMpSzNMHt2bhhct4b61+cZ
	1875E2FWUoWnOzACJR82LvZSSshSvrV+oaQMpXvvjiJTFZ7QfQYgwcEhwcEg
	YQYAcDAAZvgPZfpCQJ1kCSMAAAAASUVORK5CYII=
}]

set flag(ALG) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABl0lEQVQYGUXB
	PWtTURwH4N+55+YmuUSs0lhSySAFRfwGOhcRDdRFP4CLi4OjCuIi6Adw1kVc
	6igu4qKL4CBuioJkanxrrPHmnP+reKH4POHYjck8LdAikUSkaRGr+vPt7Sp2
	ALi7tUTEzMrvzfze1jUHzE1NRVVErIzD0aiLAu7m/02n07IsSofP9n6KqqiQ
	CTNt/CJZ/2CjkXU6Zuatuq7dvYSZuYsqq7DK+Hdz8dO3PuWGnw/OTjAcIkbf
	Z2ZFEhIVUmFhctn88qOmfOfkkXhusnj2NBQFWt4SkSIRiSoLZeVMtPpn+V5o
	p1cu797Kb9/MrlwqiiLGGEKwVuGUWCULZ6asPDM+vjOvdufd6zerjRPrD7dj
	jCGEGKO7m1mB1JAKMWemnNOTtd6yg/uvP/LjRwe3LjuRmQEIIQBQ1QKpYeEs
	lJkS5Xd9XD218uDooN684OOx9Xq+z8wAlEh7JLw6WCFlYs7C1M3TtcrOnHYP
	Af+EEMwMgJkFnD+Er7tIQAMkoAEWQIWXL14d7h8AYGaqCsDMAPwFMOdNyRXy
	5CUAAAAASUVORK5CYII=
}]

set flag(AND) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABjUlEQVQYGQXB
	vWoUARQG0G9mJxuXKCIRwmJAEIzYKCKk0AcQKwUhlb2ljZ1PYBXwFdL4FNrY
	GIsYEEUCgQVRWJHo7jpzf7/rOc2zl19FCICEWPvm9U1yjXQAEQAQGyAQQAAE
	ulUfTx9NAWRVRAvsN02ORlbl47GTNnpu5UazUv19cNB1bQvgbOkZ5d5W/agy
	6cG08WRZJXWqFCkRTKcBdCSTlVGR5ZlVdvx2e10tUxa1effBEVU5SJk2pgS6
	CJKMZESRVaWX/5xtfl72e6vmeEIqTWpQmjRqBrRijKwIetCcVSJr1u+tNl7N
	lUIKh4E6cBCqEmjFIrM86E53zr5c/K6Tc/u//r5Y/zlMTo4ulUqK0LRUDWjF
	IoLuNE/RurIzC9f3969//DB1t2u3TvOflCqHge4EOukZke7pXqqoknuPD78d
	boXLzu5JprKXMqVH4x5At+jFoy6c79w5XgOwBeiNXSOD3G5ba64aIxr3iiDQ
	3H74bj6XlVi/ilxg9ukJiQhEIAIR4B0QCIAAgP94zHf3zGOkqAAAAABJRU5E
	rkJggg==
}]

set flag(ANG) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAAGXRFWHRTb2Z0
	d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAU5JREFUeNpcUbFKA0EQ3T0v
	dwcWwc5wXHEBgwHtxX9Ipb2kEwURIfgJAf/BfIB+gmUai2CR6hAEEZIujRAu
	uzu748xuOILDMryZeTPz5k5+9PtOiEiwKUQUgkL0IUhJCfAZSyEXRUzB8XAo
	KHCOHgIwsBa1Ji8AAmBvzNtsFvMoRLdcIvGITTWnZPEb33zB5NC+J8QL7KjT
	sVstNLhhGy1i3br/xJ+0dbdg9mYjlGJvDDXEhmUCp8jTM6b1WKmrI8Q6eQBc
	r1kVVbWmHr625uu87rBBa1dlyfhb7ivR3t7Aknx1gSh7vV5RFBvqJmGIo1E9
	n0fnZ/b0xI2f9qZT/lChlGXZarWKrDcACKCq5GBg2gfueSJvr6EpgTdjjOx2
	u7ShrutmUvABXF7gyysDEp6mKW3ghjzPd3mN/ctQDzeUZel/qwipXR9Ag4P9
	CTAAKtFSoA6PIf4AAAAASUVORK5CYII=
}]

set flag(ANT) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABj0lEQVQoz5WN
	v2vTcRiE7/ttENRYI5KEhBR1jKBUwaFa6KBCreDsj0kQuogo3eyiSx0KOpnB
	UujQRUGpRXAQAv4JHdIuolKUItUuQpN87t73dYjdXHyGBw7uOIzh/8jeAxuz
	s78Ad3f3DFbcb1cuKFwrbf3YYbcrkZSGyeOrq4XTQBXR+va9ZxZuj6a5/slq
	h+jGsyd4ZpK3HqZuLwX5eGQkAXkCGh4TZjIP59u2jZ1K5SorNY6PpqWVfnhK
	1FRKJ8kSUHBgX+ng1e7w14mZfgydO7L0bPOmvrjMZTF5qfW5OZ31+3de3y2U
	Sz4YuDykqVdPFi7OvPh5mz3RcpknRWfrXiH9fvDyflakSwJyAOESeexAuvxx
	oVZCvZLVy6iX0aigcXTo2oenzeIuKSf/PkAKGsXztjm+2z58/UbssbO8nPob
	SXQaTA7kDoQUSk5aIt+96a2tDdq99c7W/LyRToUYbgIKAlyWV6oZGVJI24uL
	9bm5yPPt563yaDPkYYKbywBkHSABAnzPg4h/uQD8Ac/8It7I+FZQAAAAAElF
	TkSuQmCC
}]

set flag(ARG) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABNklEQVQYGU3B
	vY5MARjH4f+ZPWYX2YLJikahEpQSpcZH4hJcgEaiVKtdj4iGzscdaCTUkg0h
	u/bk7Pv+fmZMJJ5nePTRo8oWYSZUKpmLgqmYYYapmIvlIuOvyuOrWSPqgCEB
	26HZ6SwawdbWpx+OxqlySn6cisG0NkELC0sbCwtXu0NmxudXDq9fWp0SkyjG
	CG5EETfQM0MObh6O1/ZZLbOmxhg9edtHL7EW5x+698B/hiG3V1nkL7fixvQG
	vtpf/P3a/yXAmMStGOPa8k6mw2R2767/GRQYP/3kxr5zq8ENvO+5eyjIsVuQ
	5ej7wx6ffL74bCffTizSWFjYWlhY2FjY5PLZvHh3YVzAkMXBblqbtGnSDG2K
	YCDt0GjWGG69Ov4+MxVzMRVTpSFFZgKBFCkSUskyfwD2AXDnZM0ACgAAAABJ
	RU5ErkJggg==
}]

set flag(ARM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABE0lEQVQoz1VP
	vU6bQRCc+3yV3VKgiJY3oMzTIapILtMktDwaEgqS9WEJEm7nJ8XZkKxWoxnt
	zGq31fU11hWzbI9hEmNAMjAbZ2Kg43BY7u4AxEaykTY2yEiZKIEMCem433cs
	C5D8eoYUGT6NQ6bqFKtCVbu8JNCxrnEwN0mYjukmwwqZIlipMtAvtj9uefPE
	N8tkSJOq8r+kylX6UrufeO9j0LZo0qLrP58os1ylKYE/fYzPKz5uqQrpqkhz
	/fwfANrv7+hfv+X1MWHMqD7RZVUsuGIuu6un+4fuBTATxhV9ZCouT2nCjOkY
	Hd1HZAibC4AAWyPaydEWtQhSLIN4p1e0lz3wBg+YZyR4JpiSgGECW/wFGOaH
	zdgVIuEAAAAASUVORK5CYII=
}]

set flag(ARU) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABUElEQVQoz1WR
	oW5VURBF55bDoyEEBAJQDZZfqKh+BvGC4CcISXENDosouAYsilQgajBgCp6A
	whFEEwjipUlvz+xZG3EvAczOmslMZiUz3H728bTTFm0cBUh0lIqQQszZCSm6
	om20X6P2t28tjw/f7Nwf4wIGoqDsAhEqCoSzvH/woV3dXCyPD/PkZPnq6cHq
	UWZWWUZlgcpZJKi4ceVSwMa662j7nqWXdx9kSuU0WVaRRVZlkSKFiuhqSKdt
	8WK1O2ZVIRDWBEWv+YgK4ehqvUfhs15VFp5cC2c5y7PSBCI67VyoQtN0OXEV
	+d+CVSQWjs6QX2O4vmd9C6ed5p/8W1Y4h7b18/PbdvH50ZPVne/r80k0cRZV
	JMydQliwdW3z9eOd4exLtJu7RnaGZctkWEYO2WljKkIBPz69H+Lhu1iP0Ymu
	kGbof948AyEC4nL7DWjSqvNwXMxsAAAAAElFTkSuQmCC
}]

set flag(ASA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAB40lEQVQYGTXB
	y0tUYRgH4N93znfOmTmTWA5qZo2dRFt00e6SDEWKlEIQFQQF7VpJUJt2bQP/
	ATfWLhetXETkoFBaRCIxGs6g0hRlF7VMHAbPd32j2/OwKKL1dfwlpY1jGAPA
	Ahb/WGD4Dm50w/gAq6qioSEQQJaMgTEwhrSGUvB1eR+mI2fRgQzr672Wpkfj
	Oc45iDA3R1pDK0hFUOIwnp10Xm3Fsl9TG2ZPiMZ0fua1mM7PF4ocAFnSGkoh
	sjMd/mRDouQmkmH7Qe9MP4LqwtP7nx4+eDf7se3ipeaOc1xLG9pyH89FQcFj
	KrG7KejqZ3UZ+mNhfPjr25e8pil0FwKUV9Z9fqUymt0o2eCLt7cl2XOBhSn6
	r7J0b8+pW3VHD+nN9GpxhjlebXqbO4vBqLN1c82kvi/KsRFZyDPfc2obCOBV
	nernmFN+ji3bFdai41c/r/xggB4cZFNTJITYpYrdTq45Oe/ojUR7W6L3PM+0
	Vt7fZmqVjAzSZ0cmUhwwUnIhSAhvThx4I/aruHJET/QsPcmM3uRJP8we8y5f
	U9wNuHGcDwwQAwNcSBIxxTHFMQkBKSmOiUSl133RHkxWuyW/cWdwuuvxt2UG
	bAIWsIAGLGABC1hAAxa/WWDCxfW7wA7gF48Y+Xx8JKcmAAAAAElFTkSuQmCC
}]

set flag(ATF) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABVklEQVQoz2WR
	rYuWARDE5/EeTzT4gXAghyaD9cqdJrPlxGSwaDiLQQ3ifyAWPQ0XRYPJIhi0
	C1fkgtF4ahEMJl9ed2Z2DM8rHAgTlmX3tzu7A44+BAAgs8fdDQBLSwAaOIxb
	gID6pzmwPAJ4sn01QJJhGADk3n1Yg3R3ZbMlKbLIlvx659kIIMiPn78XcxJ8
	3Q8Zcv/PL1NFU2Z59cxxoEag27C8qAZSFSlF0qJJFy2ZMjAfUd1pu5MgCDLh
	UyxKVJVJSS0ZqBGW3XIW+CRVUw9Ldksi7Y5kQCMwZb314J3UlHX+NmXSy/LF
	jbN3bq53MpvVyzef32M+AmWHstSc/GmxOuXdve/AcPnSuUfPP8oB+hDQtKkm
	NYGrTJoU6VMnjmzdWEv6xdPNjbXV6Uol9crpY5Kl0JbaWrgs9tsPX65dubDz
	6tPu3jdAA3D9wC//l4A+EJ/8C+XbXBddaTjbAAAAAElFTkSuQmCC
}]

set flag(AUS) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAACC0lEQVQoz03H
	T0hTcRwA8O/b3mhLndO5tmnPtuUi56YdYguzwrKB2SIiKOiUFR2joGSHLkXB
	QBE6ZlHQJbBGBDGFKK1cRA0TTALdFhk129JtbHu/9/vbVfhcPtLHkdszxo7o
	1PpYMS5zfoWHr7f+PLy3ffB+AapFAApABy8MJB6+BFgHwNJQZOxRtI/YFTSf
	EkiVdngsNsvrNPqy+JtRrmJyLhKQZSmzupGYXXkyOi6lTCbnnbv6wl9SLnNN
	M9TXaVyqqThmPFCkEkZYcTaG97tjE3MupWny3rjunf+4rqvH6OtkVhsorq3B
	IFHc6e3diIoT/R0A8D2bj03MRS/3Oax1ADVd8fQwWK0vuOtPvT1nsMSbg3p/
	oGRuOXLQq9gbrg7vUxE5e8xnkKWjvW4ApPdLrfkGx0wWkRrKVnVTS6Xlit7C
	1efJX15Py2Ti21q+UthQmxqNT18trnx9r/+c6QwMdFeLlQwxZfAWmeJcvjKf
	I0yIZGp17V9FCHFmqOtxfMFkNGQW3ugAKFBOKD91yHPzYggTRhkHzgimnHPB
	hKbR0QfJUrnGGQOgOgCMKRNChPa0tTvNJ8O7NUwwoZhQTJiKSZvDPHKpVyOM
	MQFAZQDMOW9uNE1/SPfsss1++qE4zJrGmOCUChXha+dDvp3bNMyeTS8BIAkg
	AkABEADehG6ut//G8ttbABwA/gMK+BukP9MlmgAAAABJRU5ErkJggg==
}]

set flag(AUT) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAA6UlEQVQoz32R
	rW5CQRSEv21vatA3NwgcpjUoHgyN54EwvAGeF0C1glBca/b8TMXeFGhIJydf
	Rkw2Z+cUcVXe+4dTBKzXgDLJJEIehMsdd5nphl/bbQeA9P5BBBEyaxynmqyq
	VpmV2SyhY7nU6xv9gFLuRChC7nK/Gvda68sw5G5XTqdT3/eAJITQH9VaGyeT
	yeVyaSuNqV/zWCCpu4Yevn+blzKz2GJRViudz9xsLA/F3TeIKMPwudl0eTg8
	7/c6HhlrGTsZ2YwbHsznQJfwZM50KjM8cMOsmOFOo3trnIiE8n1/yH9u3PQD
	fNZaTbVZG8gAAAAASUVORK5CYII=
}]

set flag(AZE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABbklEQVQYGQXB
	wW6MYRgF4PP9/Wcao4mNSEtKB1sS1ra9iV7A3EFXjTvoRncjLoGNGyAmQewk
	HbshQoQNWi0z73vOeT1Pw6M3WBIAABigYYIACRokaIRBIoi+63HGg90xABdc
	pSoasllFm0bKtNOVqufT1z1GI6z1X89ThqrSliqlLKQrXSGHnfL2xSGGG23W
	2s2jo/j+oyxIJos0abIyTTrTmUUONzdfTac9ug4klCUhqeW/K3t7g6vXTl68
	HNzYPpnN/s7nlTSzMjqgs+SC5aJEro9vDXbGXw4PR/fvrV/fuXDnriiRouwi
	0AFoJIIIttTq+MNq8WlrMvn19NlysTh/+66t2IJtRQQN9AFIlLJEM93VtyeP
	K9Li7/mxM60s0eaaeQb0uw8xeaCPf5RiWiGGIiMDSjPMNCnSun3J7z+jxyky
	uTW8nCJNimnmgDTTosSiJJW0En6iYR84BQgEEEAABAIIgACBAAgYILCB/67c
	ZQ8jC0OkAAAAAElFTkSuQmCC
}]

set flag(BAH) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABTklEQVQoz1WR
	L2/TcRyEr82P/UlaycKydCAIOIIhJAjI9AKC9AXMTPEOhsHxKta9BBI0eh5P
	BXSiyC0hdJ+77x2ivwYwl0dc7sQzwPExzs6wtYXVCgBsSAAg9Wz3IGE4HAB4
	P5vh6Mi7uyZbIqDZSmQLoC2bCZPPl5cdAMy/Xc3nbTptd+9xxZbQYJ8upxza
	k+078KgDYKctfuj8/N3L5YunLa5EMeNKagMc+PB69aUD0FqTpOXy4pMG4PMn
	TNj3XMkaiBDAEIDUSJL8ec2PM36/qgyrb5tpG26ysH6QpGKNhjqdcrJfqX71
	34eBaWEIgGRVaTQ+fVuvnlVUaZv2JmEl0godAEnc2+PJyYfJg/pVZdP5m7Fs
	OQ+z/bW77ADw8P7+m9ccj3V7q63Qpq2EGxstaXbLb9Syw8HBxeNHWCxwc9Pr
	XHut+s/x2v3Ozh9eL3joerW9BQAAAABJRU5ErkJggg==
}]

set flag(BAN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABO0lEQVQoz4VR
	vUrEQBDeOwIiiBYiXNQoaKMcaCtopaUP4BvYXWF9r+IDaCVELH0DbQ7BRi0k
	ItpoIZKbb2bWmY1BrRyGYTN8f7vphL3wUxoChcCpqe361wEhM9hwMHSwVVRR
	YRVRZmkaaKYyBOWgzJJyrN6exHGyXWH/XhbeERmPEzgtcN4jEgJQzBYGzSyG
	KTfCOxUOR9IlisyBsPRBRy9U93GWE9SsYISuxZUo7s7YqtjRQLSZulvT7gMR
	E4EagjuwiH2w8torf6NttofNZyeAYZLJgYJfUdm2N1NJGGmOx828mk4OSm0k
	CnaylaW6nCNmA1Fsg1nOct4vYPIinCLVgdOTmelFD+N1Oril5U9H303ieBUn
	i05zuEoimANzPpMjbUcbuO77g5ihb5RX1NapEqET8j8/8t/6AsCmX7pWqH+w
	AAAAAElFTkSuQmCC
}]

set flag(BAR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABWklEQVQYGT3B
	v26OcRgG4Pt9v18HWgmJgeTrIhxAx0YkRiaLUSebxc7UyUgwWpyAgdkxOABD
	aUwSzZeg8d5/nkctrmvC6hD/pfLpEGdOUEadR804d/MxcAIYIMAB4OnLuwCq
	ujxP69+t4JKn9mrleejBk3suKSXl/YtXA//0t++nSYdT8ws6bXWrJ/Wiz8cb
	RlJ2r2wDnIGqRtJOKYXO8zc8OtbRVz17ze6FCmXacgEcSCXtlF321E1L7z4q
	kcUOqTCRIxfAGSinlMglpUt717ksXBbu3WCXyFChyg7AGXBSVtGhq5u393nm
	56/lzi12L1SoUJEL8AxYaTpWpHSxV7y4w3lSb7FLVOTYSQrgAGxHjtQSutji
	o/vqYlM9RMVdTjkFeACU6+rlbam8AFtrtKYIbQxh+Nr6QjpJJQXUBDwEBmDA
	AH58eFunqA2KqB3UwO7BPvAH2AAF4C9msGd7j5HF4wAAAABJRU5ErkJggg==
}]

set flag(BDI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAB/UlEQVQYGR3B
	T0iTcRgH8O/7umS+r25jplsZzZFl0qLEQwrSIfrjMTp1KSWyki5Fp6Brih1a
	ENGlU0kG/QPBTgMZRSZEkTQVw9ZGSri1/23z9z6/54n6fAxJJKCslf4u3tKu
	QICJmAhKcb1OIgwwUMc/kdl5dpWMA9Phr2e/A6guLFRisYa2NmhN5TKI4HaL
	1k46bZ8ask8cF5Gm8aYGc7BotFj+5mCwM2L3DRRePadstvXciDtysPRmVqVS
	wYm723r2Juqrtz7eXJxddPk9Pk+j78GXaG9730h4ODg5KSLZXFo5FIhG5b97
	K9GZ5Ex/YAA+mMQMINC8YymbGJu/UpCaiHAmb2R/i0hF1Jm502/X33X6wmII
	6jCrXNeiWbTlthWpb8VlKavWrkhbd6+Uamvl1WKt7LW9jiZiAsP85SYWTUKF
	P/ka1/a0HPrx4lEuuZTfSK49vh+2e7RLZQoZYkezRjNMzdrRlMqnOlo6ngxO
	eUR2n7/sC+33BkPhsRuWSOzYXLd/30p22SEFhgs5bFTWRyNjR7x9wvLz0igM
	w3/9moiRGb+t8rnQs9fjhyfioffRz3ewCQMP4Vx0RKQ6/yH/dKqhdTu0dopF
	dhzTsoRoK53yD1+wh04C8Fz1GPFkfFeh/VNvTwloBAhggAAFMMAAASWgETg6
	/XJp5+ZffWgmdFUZoUUAAAAASUVORK5CYII=
}]

set flag(BEL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAA7klEQVQoz22R
	QUqDYQxE36dVRFTEjXThxgt4IW/SW/U61V0FV4riKjNJXPT/WxWHIau8zEAG
	v/XxzkUAVFHX1Cd1S3HwAlitVkBVVdXZeXKV4NE+xkeX6ke31HZLX+v1AoDe
	bl8yMzOrBNmtyaneREe0NO7upoSqzkxnWurO7uh2t7qjOzq0A5AmIDO9k3y4
	/R/ADrBT0g8gDkCpY6qEvU+w7VD8BuY5J4x9JUkRYVsRfxNa+/Ntb+dK1qyp
	9377RB3RFk4yPSd4uVxKsnMMgcYQGITMvcncuWD8+fTmmVjgoszNGfXG6wOA
	4RSe4BuvWmXvO4SAMQAAAABJRU5ErkJggg==
}]

set flag(BEN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAA/klEQVQoz22O
	MW5VQRAEa99bRxCQOrDkyzjjOk7wKbgKCRLngYAI2f5Y1k5PN8H7IGMYlVoT
	VGtm8BGeOY9BAP0B+3/A5MTdzR3g2PE+dgAex9C+a9sqUXLO0+nTZAL5+vNb
	p9t9MS5MJ/dJ/WYlK6kxrmwmxk67lZaLQdKv1COhbCbQtCK1ZLER9wvvrwIw
	EXJXlyxZSSLl/cqq1EpV1joWruUvTERbspaXWt4cd36srD/2Oce78nGhUquX
	rOqVJK1/baRIOr/Uqq5yVZcTH4XDPgoq1HQDk2fKunxzWV1yz223ely9RaIK
	CYnuA8PgFh5AsGCB4InvnzGvOeYXJAFrPCBhL78AAAAASUVORK5CYII=
}]

set flag(BER) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABuklEQVQoz2WR
	u2tTARxGv3tzTW6xGBXThybQDrbSVScFhzpYlIKgiGjHqkOGguhQqrj5L0jB
	QQSRCIqUOvhcRCWdrKgRoSFVKRQNpJA2ub+nQ5rJ5ZvOt5wTlK/eeB0Ozd39
	djv3OQpxaz1fLDQvHt/feDgfAgIYYIAAAgAIDh8oLj64wAP59veKN5tBX/+u
	gdyr5frR8qNQ2JhNxJhdxJk/LCxE9+wpKmM9H9+mGhveakV7drckOLbVTKor
	xuzEymREYE4XCgZEz3qPXDk4lv77q7XyM8hleobz9er6D907Ql+caahUQirl
	7p4kq9PTAkRr4+cp7r2/mh0N+kLyr1sj46P76uWaEgdMTsnNtYyY3+lPnFmA
	6Pritd+52aDyJ5vddOH2u+XqcG5iZ6POiRK56vviqcuXpmxyUkUECF4Ah2Zm
	qFZTJmMBszEpsRE588v5iY3NhqrEcXxm9tObpaUwBJxZiYzFiZRIEzIiY1ai
	E1NPMpk4Hccnzz52EQEiATrijNmZjbbp7WU+fa7kwm1RU0Xn4Cw7Bged2US9
	457Zu/pNxFVjVVclIHgOUDekdNMKQP81FiAN/AM2m0mcDZJMBAAAAABJRU5E
	rkJggg==
}]

set flag(BHU) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABnklEQVQoz23K
	v2/McRzH8ef3e5+79tL2gtzFj5RGJcLAH+APYLIYDQYJ6R8gFpMwMHWiDFi7
	IGmEySAGgxCLgaQGOYk0vetdr+e+/Xzen/fLIGLxyHN8FpO3BMP5y3EHIzTw
	Eq/wiIM38IA/IAQjHL8BCEeOZ5HB1FhUtBA/q7BMKqLpVdp5uhY8AFL8gTKe
	pQRZzRO+b6mqFKtx2bs26sbO6pfascNepwSE/t2eFaK2Pw4Go5hy3WPRXt5a
	+1nsiZpKnihx8IyblJCpjL9G5cbkkA9fD8fx/fOV75tbncu3tBOVExBwUJaS
	ZBSmKnVnVomTWl2hplPnr0I59+iSmolkDsENyeSmIlKz3t7rPqn2Nwa5Sv1J
	cy5t2MubGkTNpCInh9IdeVItTmYvrIe7/c12M2+nXrd17+LCh2fjufn+2Tsa
	JcyUzaD0CDXT9Mn+8PT0t+3Fh1eK6ebwzWOxq08r7dtnjtw/p3aUJXkGQjmL
	StO73sH1Zaayjs63vr6oN2JxYIEy0TLcUCZnPDsUoyewhO/iHTyC4WOc//TH
	b4UhI+oszL6NAAAAAElFTkSuQmCC
}]

set flag(BIH) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABn0lEQVQoz2WR
	T4jMcRjGn9/s4mRDUVs4iIubi6uUNXapxdZsojhIIeWGi6M/iRxs21JoollJ
	/oyIFdLaaKIkBxIXucgwtTP5ve/zfR+H3zip5/Acnk9PT08GNFaVF0yeW3rq
	+K7qvluzHSzqA4AgIhBEAEHM31YHCEQvgMpg348mL1y88XTm4cCaacGyjFmw
	J1iCS1T4yKHVTt0bf9MLAFLtQevD57yyaePk42Zlbb0ny5GZ6JJLprCPX/8s
	658LsARECIlovO9cq7fWbRi9Pl0mk+jKTJErTGHm4R4FgJTAFEx6/a5z9fbv
	9eWdV54PkRStSCuZuZxdIJjkSU65x8u37Us3fw1s3jPxZDjPk+AKk8wskeoC
	KYku8zDKXC8a7bFac3B47/jUSDIrNhiLhigB4UnGoMs9zFPu8exV+3y1uWX7
	/rP3d4imcHqkfw0kwz3MwyzMu5qamT1z+efW0cMn7uxWmFNMKn4Ip/oXz3EG
	GSSc4RQZX7559W7r4IGjE7WFK5fPSyEgMuAREACLI/8zBJYcO73i5JFPwHcA
	fwHqy2BAh+HAXQAAAABJRU5ErkJggg==
}]

set flag(BIZ) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABo0lEQVQYGQXB
	PWtTYRiA4fucniappknURCIkFFuqgyJIwcUPOgmKo4OTk7N/wcFFEMR/4CaO
	7oJQ7SgFKzrZgrbW2LRJkybpyfs+H15XMgUAAAABgRyAAgCAgYEBkLCw9eLZ
	WcBwU6bFUnE8OV0K0aQ/nB3NzCW9gShRXMTevPyWUW/mpwp7PVd1MVJh9U73
	fCvPVXc64cP7K4NBNYpH8VYjhUsp4IaoRyNN9NHj9buX51fS9g1rPmjXnzxd
	K8xOg2gQjaIQUgQxF0XFFy90WsVaeZBs/vi88fWT/542k/LVa9shJiFaFAdL
	EVNzVReldbFT8zOFcj3fFd/pNBcWazSaS3+jWhCP6mApwVSJ6kGts1s79qOT
	/GRYbPxi+WB4OGXc+zMfg8foIgaWEYjqUTyqf/neWrm3Lnl2+/pSUNvq/zyu
	dNc+3gyiQUwsBcvIESUqQRhL+vrVrfsPNyrFvghHJO+er+4dEsXEUtUEyNjf
	Tybn2nMuQhQPM9nm2+VqdaTKv4NCzb1aGam5qcvIYTvpgoGBgYDABEYgUIIS
	AAYGAPAfKHQZMNhmNNIAAAAASUVORK5CYII=
}]

set flag(BLR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABRUlEQVQoz01P
	sUoDQRB9uRy2qUJIkcZ/yE9YiD8gwVRpQhorsdPY2KmFXxFMEIQUljZ+RAQL
	kUPkcnea3Z3dcXbv4mV5PB4z783sgIuCBwNerRiwOzCAAn6BAsiAFPgGvoCG
	+KAUplM2Bs7BWiYLS0wEIinyDueLRYw0xXLJkwkE4pZY4ApaWLPWohu9ngNi
	tFqc5xiPa7e0ZV5p9W5TBmCMBCKXJJjPcX0dSlT2PJdQutZi8Bvabcjdw2EV
	oGpeFfsPS5fIb0CS8GzGN7fbD2xZqZoDyi/F7uCIn5+K0cnxiIzT2hpjtbFG
	O+kHYTVJ0dF+i16u5IbHB3d5sbm/y5o6axrhdQW1jnQaBR3rLDZFZLEnGzpt
	5Ovo/LR72CVnwzAPciTjheUsK489sEGj+Pj86Xbe3l/7Z31oeBBqgSA2gEP5
	/gBvN3WWTCGG7wAAAABJRU5ErkJggg==
}]

set flag(BOL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABHElEQVQoz21R
	PaoUYRCs2f008pmpCwaC4DG8h7G5eAkRQzHzDiYewnsYi4Esbx/jV38GMysG
	NkVT1d10QffSR0dcIzImEGBFiuA/GADw4ROApkuMpA7sJT7aB7Fyrco1b99/
	HABQ9OcP2EgqYW+7YqWKJSsuj08Bxt0r338x82RF1Lh2w0awatasFbPm4eHd
	+RnG7WvcPF3NSyvUjVo2TP8SNmzm4d7Nr3cYCBq3aoW4ZcLuQwpmw4aJDlGC
	EaFgK4StcnXYd28mYaPCEsYX4aV50e+EKRN6I6Wzy0auHhzXzyvGmzPe8vJ9
	nhkqYjgzWe5kK5aKn+Py7YwBQdFpnFQxcjQxFW3YTuvYtWEIC74CAfQPNjmv
	v92K2PMfrSN8t/K7NFgAAAAASUVORK5CYII=
}]

set flag(BOT) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABDklEQVQoz31R
	sUqjYRCcjT+KYAicoJ2BA/EN8wRi6YvcA9jYpFMfIU0gWB0XuIBC2J1vxuIz
	IXeIU8wu7O6wzMT1s/8SHZRSoJCCJUigQGHfA8OfxN1PGBBsRxME0JaCPmoe
	NZtyyc2+f3obRoCM3+VmSKDdDMq0O5dcMuXLkwAVm81mPB73l2x3/hIRsVwu
	A8BsNlutViRZLFZHZlVl7kpVTafT+Xw+ACBbVe0P+vif9cy+AGAA0BpJZuVO
	PzPrUHsvASDW6/VkMvn++z6NiMViMZy/nN3e4HXrEg496Uy5ul3C1Sl+Pf4Y
	QMmji+NuJZpBoRS9aUIzmqPJAkAFHt6xPQiV+Iw2/8tYIHCMD2d1fWGQkG1Q
	AAAAAElFTkSuQmCC
}]

set flag(BRA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABrUlEQVQoz02R
	O2iTYRSG3/75Qq0oIYMS24JDFcFbBkcVlAoi4uAloMRJUSGTQ10KCkWx4KK0
	3kAcxMvQCirWwUXNpi62OAgOUhW8ECxNm1/id95zjkOU5OFweOHlcIanC8fR
	xgD+3xGIHaE1TQQAI+URB9zNzNRVTbet/x3AqXcJjWpKihhFZeLsRADg8G8L
	37XVGe8cTN173GWw8Gvv3UykUCVq7M/1//vg7mqkcc+mtNSrw8Nj01YQ+kDz
	x9OLhx58levVDFWEgogEBho1SW/tT0sDnP5QOlIp3Bz6UynVZ7pXnrkwdHhN
	rB6rR4qYoIkERG+ueXufJC4Oufx88PQNv/oky7jk/AnPbyy6R/f45tR8sa+B
	FAkiZueSk8/oiO5xS/6t0Gc++ehkmK95cfnr1sGue/HVe0EOCQiScwvJgfth
	6nOsHB1du5jWfrosevVRY/f2c49n44ax7JdaNrs0izoCIugUFVEZf5m51JO+
	uLLDpc9FvPvj5vEgFqhCJY0AAiKELCxbRRUxIVeUJ6W8tZEJdu3hutV5qilV
	aWJqALqws22x02jbtKKTv/JDL0Hida6XAAAAAElFTkSuQmCC
}]

set flag(BRN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAFb
	SURBVHjaYvz06RMDDPBu3/4vKorh718I9x8Y/YExIAgggBiBGnh5eSEq/v/7
	y/D6NcO8+f9fvWb4++f/nz8Mf/78+/79/+/fQDaQ/LJpE0AAsUCV/v8Poi5f
	YZg18//bdwy/foEUgdG/r1//g7mMsrJAGwACiAmhGgh0df83NjGIi0NU/P/1
	G8SAI6BmBgaAAGL59+8f3A//L19m6O75/+E91Hight8I1QxAxMAAEEBMcCeB
	gI7O/4kT/ktLwRT9QrEB6B8GBoAAYoGrBjHOnGbo6v7/7h1Y6W+Yw6A2MIKd
	BBBATEAn/YcBBiPj/xMm/BcX+//zF5pqYHABbQAGMUAAQf0A9fepU/97e/8/
	e4ZQDSH/ADX8hcQPQAAxvnr1SlBQEOokoNDDh/8bGv5//swAC/t/P36AxMHo
	9ZUrAAHEAlT648cPiD3/pk37V1nJgBq18JiGAIAAAwB361RtvY8fzAAAAABJ
	RU5ErkJggg==
}]

set flag(BRU) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABwUlEQVQYGSXB
	MUiUYRgH8P/7fqddd2ZJDpc0CF7QUITFLTpELUFtLUFBSzhEBGEI1R7oFA0O
	jUFxNAdNubVECV0RZYXehShZevd95/l99z7P/Z9Efz/XWQIC4LGPBIhdJKgA
	QYIEFUqQcGYGoNd+Af1LNsGeGeEUTqkKKKhmQlMz3fr6Koc9fuAGAA+wt8H4
	aXd7IyTJwaFAETihiTG4vuNURIV8fmJyEnvMzLmiy19Y3jwr78LAWB3OyB2q
	kMH7Q531H9HbhYU0TavV6vDISFAdGhzspWl4/sTiLTn9rL90LTdw0xcvWrYI
	h1ZjyQGYnr7faNR1l+jcxMkoyiWXr5ePDiUv5xm6penHtsd5H7darv0N7siD
	Xz9XHs4mKiqSmz8/dufN+0KQuUtnmldv9xWLp0ZHzcx732w2XfwF+ZEZSt31
	Zd22rP+2+B+GP40h2555/X1x508IQUTOjY/fmpqqVCouruHAsXuUOpghEkPI
	YkqqZrq2git31yQEVVHtlcvlWq2Wo8JMXVSiZaZq0Pxh8f09UE5MyNLHwW7C
	1TVdXddHsx0AbvMDqCChAVSQoMLnEBTcAQhfgOYBgorlz/gPZl4s9HveS9EA
	AAAASUVORK5CYII=
}]

set flag(BUL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABB0lEQVQoz21O
	MU5DUQzz+7wuldhYKhV1YeEenKkjCzfgMsyVmDgCqhg6dWEBFYnYcRh+Cx+E
	Ezm2nEhph8MBE9geeSq+IbsDmM/nAKpqvKka3WlMsN/v+2mppqL+Q2vNdt++
	bZfDMit/EpTLo/SpXJ4N/fnjueEO65v17n0nSxZNmkxGkhmRQTMUNFfnq839
	pgNQJYsqqUQzHDRZjIoo0hEVNFWC0TEgB2lQVKiJjUREYyAIBoIDo4JFDkRH
	xyNW15y9hlJSKMkMiUpSIZEZMiUtL/S0Qf98wNml/EKQRVYcHznyKEQo21Xe
	At3AQGGxKBJKiCAbCQkjS8gc20A7AJ40fts/EYAvPNBlho7k+roAAAAASUVO
	RK5CYII=
}]

set flag(BUR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABHElEQVQoz22O
	PWqVARBF7yffQzQmjVWK17iHrMEFpLC0FNJkAcE6qxBcQ3o3IGJhY2sRyQIi
	qPdvUrwE88DhcDnF3GGWwb/pvv+XZQBcXACYFi2ScRCPDXukeZS/rq5WAMDM
	9U8kSEba5T3UiEOOtGy3BVYA09nbJu+vkiMOdyJIBdYCSwJ7bMhjTfX7XFM9
	veT85UNTkACsX4Hts/DF7ktXmksevhSgm4/cvFXJbjjU5rm/AevJe5y/9o9b
	s3SsSt/54UQzPP0inlEVRVWvjvT5Giv+QBFF1woZqXzzSYoMymKoyHViFCsM
	x4pUKWLIUBVLVYwUunLjBsQKQvXxwbEiN941K9eqHHucJJM0MBa8A/iA992P
	xECBJ7gDwQVrzT/TBM4AAAAASUVORK5CYII=
}]

set flag(BVT) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABVElEQVQoz3VR
	PUsDQRDdvT0bC8kRLRITEW0sxNJG8E/YWYhgJ1ooduIvUPAH2FjYCiG/Qgio
	CLEzRlDRIiwEG3fnw5m9BCx0WN7uDe/NvZmxL2YUc8yTmw9fV8t958gYSsny
	Ab8wl2xxcizIzGfbdWtt9fCAEQwA64kcFUkwxqdWO0+FmF7f5Pr0IDLo94Vh
	opCELSdQCByiazZHfzAoLNSb1AhD0KpBqcoWTVDMYhRXeQNRbJSWQJTMlesW
	/xVCWxoOrdu4O9+Z/fARKXkmEpl8KIIgRdS8ZOrFxMVexyJiWZ4NH12+n27V
	+J/Issx7n/ecm97fhd5zpdWOydJgfY2Cdmy03ThqI0K+uNDt3ObSJqeRCVVt
	MdN3yQiaVKU+SIwAatMqAMhq6mRmSofmGs0MdfAmjd8BKBuRknnbHa9w3vti
	5WZwv/pYrcJ4x+WCzRglfgD0nlqSGDQqbgAAAABJRU5ErkJggg==
}]

set flag(CAF) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABj0lEQVQYGU3B
	P0hVARQG8O++e+31KnreweIpDWnSFEFrNdTqUK3V5ODQP5e3OkSTLS3h5OzQ
	khA8XbMlCHpNIRQoaESb8W6D55zvfCUR9PsVncvbZbd+vdS79fQ7WvBMNvj5
	qUdg/MIexhJBWIKEJSyqsju+vbY+NbW0d2Xt1fuHTOgQJ94+VsTzaxNeihRT
	HqJy+cnXKonN4fydzrOXbx5koXQkpZ0duX+7mEF5KJgeOlsXaFDs7/+YnJwg
	8UdRCEekuTmZa3ND/2SqKIrh8GMFOICyhCQIgo6YyVz/AQRgNBpVC+8WFq8u
	HhweUGSSrWTGfTO5r35ZjWQaKUZG3a77g3412BjMnp/dbXYtLRie7rR75jJb
	+bBiNKdbmtOnu9PNelMh4HKjRYbTLN1oMpe70ZxuNK88ECwDx1D153F3Jn65
	pzzTCUuZzGX24oYzPWkpT/HUGJcfobp9HJfqkHqSA5RccpxzRNzsuRRSSAQI
	8Mx1FFtbaLXQ6aDdxsnTAJEJziCB/AwSmSCRib9+A5KxXKBeasgWAAAAAElF
	TkSuQmCC
}]

set flag(CAM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABbUlEQVQoz12R
	sWpUYRCFz/29d/eGda9rWMiquGhjKRYGKzsDbmETfAftFUFFsbA14CMIqQy+
	gcRC3yI2ErUQqyAmO+fMjMVNIDh8DKcYZjhzKow/wQJ9CfAAenTSTwvUMLza
	ugYgAx7pAffwSCnocIXU6yRj5+2XGvjTpv38tfTI8JBnP2EeYkhJBhkmv7TW
	Ar/rz8t7V388tf39cE8yPdyWg9ksPA6/7kHuy6M0S3Iwn9/GxwIA7ilVJFyj
	G9cHk3Oz588uvHzRjEdnb63DlWZpBhJAERDyIEVmVVYfPBzdXaBdQdt2m/en
	jx5n3chMZpKOgBoAXJCSdmalK13Xbdwpk/Np1i0WZTIpg+Z4fX8hgCTDDO4X
	32wBqJomM7Ouq+Ewgfn2dpUeUkgCKuDdk9c3v33/S4ZQSCeDdGNQQYU8eUi5
	X7k82t15XwPdAYfjaUP1XoLHjw8p3VO9iDzwBKYV8AGwkyD/43TSPeUfjDQz
	rQB3UoEAAAAASUVORK5CYII=
}]

set flag(CAN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABnklEQVQYGU3B
	u24TQRQG4H92Z+31BWzZwUI0CCjgAQipU1PyBinTISFZosoL0FBwKRF1XgDx
	BkapLFGkIHJCiohEMVnYmXNmzg+k4vvc+ukzu7wsfBHOTgaLBf5DEoCInE6n
	HUCABHhbnfTmzwGUVxf9fp/XZL12hnJ8k2aVr27t7vru0HL+9vqVx7AGaD/O
	88UZryVj8+athTx4+aJ0jqQcHlpvXNy5LYBHMmajJqREMi6/RpPyaAUJvxZf
	fM7dJ5to2+xqRkmANxHkTFXGSLJ5994P+24wYlXnDx+vjo9m+/vWRrjWSUyA
	RwimyVRNlCQe3OXBAauha0KxPi0fPjKzFNvC90xUgCKFwKRUtRhIDnd2fk83
	ZL1WbZrJbDSfk9QQGCWLJMBb01DVYrQYzQx1Pdrbaz9/ct16srXl6jrnzBhz
	JVBNgE/n36nKKBaCmZF0nQqbj4tOjW4352x/hdY6sUhJAJ8Ai+om4yK3zjmS
	ALqTDUcaUBSFc666d78cz0yTAe4QMCABP4Eby2UIgSQAESEJQFVX29sdwPDP
	HxaxMt0iAhbaAAAAAElFTkSuQmCC
}]

set flag(CAT) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABKElEQVQoz02R
	vUoDURCFz8abaIgSJMRO7OwUC+18IRHxTUTElxEbCy20EhXsrEWM+JdI7pmZ
	Y7G7yU5xOAx3vpk7U9j9HuqQFBFNdXdJM3X3FBG2tQ8ACMgFh0xygRILGcAF
	lZ68fkkfJ69rG6OqhbucMJdTRhlFilmWRaLbW7gdp/7xcLw9xXwsl1jiJUpZ
	YohSLrD4fdVOn6dvg6V1NKKwXLEti7lqQqI35cM4rRwNsPnTLBCgmOMVWcoK
	omVfN+30ffa+2llrFrTsT8Y5u/bFCvuPk9Q7XJ3ueGOzrIe22lCykLVgo8tO
	+j3/GHaH1esKlmXlB1hljAjXshVPk9Q96E92+zXbpLbUqVYUFCxEyCUP2Ohi
	MUVE3D3PDlled6blyUsvCcA/Lgxo4qb1jlsAAAAASUVORK5CYII=
}]

set flag(CAY) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAB3UlEQVQYGXXB
	zUvTcRwH8PfvoU3X1LRNbZqwIShR2DPhvY5FEFq3zp0yD0URJkRRFzt0EWZ0
	iCi7DYKoDmVmDwQVaQ/LlbjhWoTa3MN3n8/n+/1Wf0Cvl3N/aORzY2L4xuzp
	Dek6F6PpyNBuM/ZsGogBBCjAAApQAAHK6dk1/GBs0GtrV/PzplR2W9tCkZYr
	d6aNEyYW0U44UDuxf+385HpiTiVP+knMBDM7/Hev3OXfUq3WbWyuiP2eRcCr
	rFat9f29vc+TU5xe3NMRCQHKTYV6JdEdjMelsQmdm+u3bik3R5mlwpZIri3d
	GmxpOpaITeRvMmtAu8Wd/W5d/b0cFtzGLAdul6KBri5iqdY0kbWnRkof3NKU
	wtnLzBaA1+22Lze0Pfm4WlG1zAo/frM0t2YL+YLWnirzivconxjIRHuezo7/
	LHRk0w/9uy9y7QdEhF7/grDDlj/N5YjC5BjjmoHDo8ZY89e+q2cupgD4QIWt
	JdEimkWINVmwY1iZS0eL6zLXx19+1SLHt3eeOxQ7mIIPiIhm0czCrIk1sbAI
	ib4wGezvs0f64mXGxIzz7UcQgA8oZr2ptYHZyD+GWbPRwppZ3n7B+wViMbWi
	oz0NwAG2AQQogAAFEKAAjf/4AwOvJc6zZIF/AAAAAElFTkSuQmCC
}]

set flag(CCK) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABt0lEQVQYGQXB
	vUuUARzA8e899+KZyXOkIBcqIkQ1ehFSDf0D0uDgVpRLEAVNbTUJQZtDkDS0
	NEZBDU29DolUNJQOGZlIntjl5XGPnr+36/PJcTEPAADmBBgIGAgICIzCCgh0
	KAAvbt6bOrnbbpTmvvZ7hCXu4eZm4RY+1rt/ZbT56Ff5807y/NZ8AZgazi4/
	KZ4Yat09szzzbKxY7phEK1TDNHTFbO1v+1MjGakM0SGBwW5ZL4w3az1Zt6vF
	vLSyuH9682GtLq4zQ/9E5GMjEddTaYZQoJU8Xe2frq52K3b13XDk5MFk/XcW
	17+kN8YbtbR9IKWF9Z7JtH1pJDc3ToFC/cNW8e16dUfC1TSsN6e3v6V96OP1
	4tFjvrBWkpDX28nAj16WSQi8qxtZt9nxToi6Zqp3jm93RH82mV1KxVXUXp7d
	WPyTBxIEDZcwC9098H3T2aXKcHlvfmJTuqquYqqu598MejhQQDA3NVVXdWu7
	ltHp90f2QsVE3NT13ED71VbJwoECgoZV+wfVzcLNVMM17JB62qfmPlHZuzaW
	n/9+eLFhQI5JEBDogICAgICAAgBUoQ4A/AfMqym/uOUqcwAAAABJRU5ErkJg
	gg==
}]

set flag(CGO) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABQ0lEQVQoz2WR
	P0oDURDGZ2ULIySRmBgVLLyBvZVNxEKt0qUSSWsrxELEwhN4BCGNhYJaWOsF
	9AZ6AqMm89d5s1kVfAwfu/t+3/dm32TwBMDwu7R85fT8tdJWRtVxKjY9g9w3
	BmuDIFVNxYRBRDgD7i1wXiEzNgu9pdHddR5p9kpvjooKGbk6cbhE67Ok6iim
	GlI2XPXjZyLbUnBJs+FBizbmCnSS9ArtHI3IDbnjQTMbu4pSf5E6VYo2IvuG
	7BRtQkAEhYEtZSePcr9FW1UMOgz3ZCdo4xQPvl+ekFBU3G/ydq0IDn0gO0b7
	IMNkyH5a8ngU7DV5r16irk4foY2mNETLDHGtLNxtUHf+T9+PQb97VBjYDeK3
	Hf+A0Knxbn3ZaQD/RPBM2QVBm6GRglOJFOUtZTsvcPlZmQ4yxqybadz/q1jf
	qoFmdjYAvu0AAAAASUVORK5CYII=
}]

set flag(CHA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABQUlEQVQozz2R
	O4qUURhE696+9iAY+BpBBzR3G+JifETmbsEVCBMYzgomdB2CTNRgIzJBM/z/
	rfqqDLoVKj11Cqqdv7m+PUwAdq+l//j6/tnDvSR4ukc7LG8hwAAAA+P37fzy
	6TUAB2R7+urz2fZumyBKix/M+x93LkWEtLu8HGMAwK8/q5TJprl3P8ROyk1Z
	Vv68SSmc/eJCwLCRoCpyWHAqkFNxpZXNkBFd7KKBUbIc2VVQAVasuJIKGCvr
	tBXRlIEBueRSpIjNVsLEMdMqpsmYprr+AY5VpjKF5L9BgWKG0yWUIAkYWKQC
	ZSkSYiZMKpabHHryWOGTYUoyFcpTsBUzto+TShFjpSpVBgYOqvL5oy2VdcXm
	3pO2OQPcNwzctnO8PApPQMPzb9jfoY5v9u9XH148hgQL6tANlncwTunAXzoi
	epJssbtiAAAAAElFTkSuQmCC
}]

set flag(CHI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABC0lEQVQoz3WM
	PUpDURCFv3vfExOLIGqT0qxBRFyKhTaCZRZg5U5SuQcbWyE2toJIEOxifiSa
	5M7cGYsEyTPmcDgwnO9M4OqBb0UhwszYiblzCti/gpKJXp8dXhzvdx4HWXKj
	XkAADyEURRFj9BVNJpOIcXlygHN+tPf2MX8fzWFZr33HzCJw+zTI7nfPI1HX
	jG+WmZXUdse6dXM/VEe3a5rTJhoASl5f4me9GM8sezRLjbpPpw6rb5eDGK3f
	Dxlot73Xc0mIuohL8iSekkslY6s17HZLgyDiKaFagao0qq6qUBoUqi7CL7Q+
	U0EzObMYRFGaTRdBMyqIBBFUWaQqOS9sEL7AVkz1/FMBP4aNaAYrQWjxAAAA
	AElFTkSuQmCC
}]

set flag(CHN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABJElEQVQoz12R
	MUpDYRCEJ8mLYhGwElOkEAQvoEfwGOYQllp4HQuRmMLGUkG8gJ7AQkUQExOz
	M7tr8b8XHsIWw7Iz+7HbeQECCKALANg+xvsd0DQFAFBLVwHsXpwPTjC7jP5e
	bB759qvPJoIppSRDSrLo5+m0CmAwzt7O62Dsn2ceC24cev+A8xsmmcakhVmS
	1WikAjK/ypj5z637LzsDT5m/MY1hllyFWV2kgApAfPnHqZDaOlK1z+UDl/eM
	VnaaBZnFEECsvLAun4QtziaWZJIlFU18SLUhXSmB5gt9XzNphSfW2cVARm0o
	LSlbAP+nJaw3QCqIQYZZPdFwp1mIKU93AJWAoHrDYZJdeYp1fHP+kOAe7uku
	oPPYemRbqPXsaKoC/gA6rnMwaYSm9QAAAABJRU5ErkJggg==
}]

set flag(CIV) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAA+UlEQVQoz4WR
	MU5CYRCEv4cvamIMJbGgobPiFN6CI9haeQM7r0LlCYx3IJb2SiSSf3dnLHhQ
	KNFpZov5difZzo+wBUAoWd9+gCSxM2nyMkGQkDCi5xNu7gFLnTUeX9qAvbfF
	9SId4QzH8nnZ0wP25g0VVYfcQauvVXMLxfRsiugRllGhcsWPtO2m1tzCEQqS
	XtBROK1E6V8aAEU4SHqS3W7XP0BWDoCVVlqN+vPCUCnpHK5GpasdBcKRynIO
	wEmlK6hwxVEgHalKF9Bry0jJxZUryAKAruvYa3Y+K1epykWj29yhNUq0RVve
	H14zc/fp3TB/miMAEk75BhikdpzkYSFzAAAAAElFTkSuQmCC
}]

set flag(CMR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABI0lEQVQoz1WR
	MYqUARSDv3/8V1C3sBJWtPEunsZGUBGcQq/gEbzC3sJjLLrY6wzsvOS9WMzs
	oCFlPgjJwle446SVm3e8AGDO3jNzb1jZsX29BSYzm3m6bfZNe7Ef2JtHyoUT
	JU60212vrEB+7m873Uv7h/jTkU5+rEwllWhZXs6wMsykp532orhTFTulqHJR
	iY4AaIYVaNqxx14cKYvyRRnlY+XwHwBsMJ5WSyO1UsrbyrPKVeVTpY7pSip4
	hg2mxx5XV02NKp8rvyq3h7yv6HAGyLGSUVRdHmupSDlU3ihSqvLw3MeJbVaM
	22opEkpVqk7p41AnoKGBlTs0vnpypZHpzXNxqUXCRuLSLL5P9wwLH+A3GAzw
	/Ruv/r0Z5uZ081F/ARDIZINLmW/kAAAAAElFTkSuQmCC
}]

set flag(COD) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAAGXRFWHRTb2Z0
	d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAbJJREFUeNp0kT9Mk0EYxp/v
	+tVSghYcTAohTFXjHwI4IAkDiUPDTLGNi8Y/LGpYXY2Eib8rTCyQNMahJH5V
	UtCEkgoJlgDRxIHJxMkC4le+3t338l7bgYXL3eXNe7978tw9VvA7AbjftVAo
	PuYCCiCQD+XxklAK0oMvv97sCF33PMBmxrmbfYB3n+9cc34PWjA0aZ98XS3o
	SfuHe43TSHW4MZH79RMhcoluE13luXy6kPpByT05vHOa2D7JH82Qbqbey/8R
	OcYVit3Ksjxbcukt0yUaTe7rh7uV4WJ5498skUHLiJwwimYz33RnP/KFTfqm
	HRZecdMsnPn7voZ6iLiIEFoM+izKzXxpFpNrtq5g8SDuK+l5Vrozij6lC0JB
	hCDM8583YL6cK72ccoai4QDUge1LlWh1+sMp9AWoICTEJYgAe33RgLny6uGr
	qWyi+gHmD0DSpoEgkjeQDmogYOg6+uX49cQng6JGM+5bUL69ZaEHf1Ab51Bc
	MEwOItZqDRzW0KX8I+60NaHqgdMQRpt4t4hMxNY6X3qK8ZGxTDFeF1EcrYbk
	pCuAhmbv7Kd+eCbAAHiZ+RMcNV6aAAAAAElFTkSuQmCC
}]

set flag(COK) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABtklEQVQoz22R
	T0iUYRjEn+/rzaVYXbNPW3QRKT3kpYRIgvbSQYzAQx2CkoXI/pzsIJ06dTSC
	qMUSkkgKJEQ8FBEkXRbq4kmj9VBRsUaH3EQWd79n5nntsBUFDcPvNAwDE7y8
	dO3ZenR76dt4ZdGJH2PvaVceOhydnXsukhGpiejfDvr7r8/fPF5tjmzlnY+V
	be1RlFz4uLm4XNy2fSfpaUZ6kqSfvjXmpkqT4VJran0tLv/wcZzYlaph61BV
	ZzfSLtFIGGhzkxcGc/mOdLNILXzRdtR373c9PWhp9e2dDQf6qunOYnIvYACf
	TJxXYDCXB21qfFhEw08Hj8UNOx6WUquu5as0Pqpk0NG1GjapQmEnzk0oTEFV
	nrnyQMRc+dXrmd7Mh+8blU3x3FouvV3ZneyOawo+nb44kMsTBAwk4QuFgpv5
	XN4XeALFwCEISH4prb0HXaJpYPgOzBQkjDSaZbPZUETNDCRo9d0K1qmwhcej
	9TRgs3dHRCQUUdKD/k+oToAAj5y8AfDN/FWYDY3cExEnoqDtiRpJ+1VmnjSQ
	pDdvpD91+X5XJjLzIhKI9P37Ze03Tf6nn7a2Q/aLLgpHAAAAAElFTkSuQmCC
}]

set flag(COL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABEUlEQVQoz2WO
	sa6OYRCEn48vR6MhIhQSci5A7Z60Kjegdiki0WuERknjiEKhUvrtzDuj+M+f
	HGwmkye7O5vdfr4h4bJCQnIC/yfYE24/fg6U0NBVFnFr4qLGjVq3unj9ageg
	1Xe6yGpFV6NWJ59mGm03HsTsQOnf29O6UTPtnEBEHnYMLHA3g4u6qVVRt2mn
	qEwrEGHj1rtnLx5++zFelSNXvoRR5MyRvR7du/H25fudAzZ2xz15RsdYR50r
	hyA7B36LX4OFzJgxUuWOLzsy9jYDsH/qk7ufn+riazUZVcoMUjSRjm9VyvLZ
	+flHPuxncN2Ha/fv1O5MfRyvSkfGzkqXuw43YfsCBmAgEPAV/0fAH7CAa8Ej
	7LXtAAAAAElFTkSuQmCC
}]

set flag(COM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABmElEQVQoz21R
	PWgUURict7sXL0Y8kDuDMYckhUXgIkYwjRi1EKxEREVifYidQVBQi2BpaWFK
	EcRGgj/YyhWpjFaHGEThDP5AiODperf73vd9Y7FBDTgMwzAwxTDu5EMs7MNQ
	CQBI/AtyIylM4ZMnLcyMXT8+jomqAQYoqYCQAggZyL+afniaoIxvKRdedffv
	6p6dqG9NKkCflM0MpDhXI5FgDQBuHL6Z5ul86+7s5IlGrcH/wACn1bkYDSxe
	WizFpasvrjUPNOdbt3qSjVX3DiDeXADg8jxPin3LX5b7eW9022hffj1o3/+8
	snTl4ByNBGkGMzOLSlvS10sbhanhKYV2up1g/thHf+pN+/u9WfVBxTMEC54a
	kvr4yvOXMRr4WenO7DkyPTJ9+/HlZjucfufLIUgU4DxcQOQRBUSS7Kisv/3q
	cB4XLzQzyetrtZH1o/2BKmlmBpJmJFEsNsSDg6urnQQewQ9tz85J+dD73ciU
	SopClKJUoyiVUKUZnt3Z6XBmGJ8eoTeJHwZvyAAxZAZvYHHlHwLAbyPSLKPP
	tnq7AAAAAElFTkSuQmCC
}]

set flag(CPV) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABgElEQVQoz31R
	PyxDYRC/771XRapNEE2UtgajSNOEMFSnjmKRCCJpJBKbxdKOljKYDRYrQiIW
	jcRESDQGg4m0EfUnpY+0Ke/75773KAuXXy53+X53v+/uCCQl1E0IYOgBLAAm
	wBJfHvHuBGAgLTOtyFxKKQiXwJHGJReECZ0JDWMmpPJcbqQqhtO6+IYMW0C9
	qQLrm0cRTKUBH0EdVcCFYqP4YOcFZjP9O+u5UYvD4XUUqZTXgV8VGhLtxjDc
	lZvs2yuY7VPbS/lyx2xkMx46sWwpiylgDc5AOOeEEKkGuAXSJf82ommvpmmY
	ut6cTpNgWR/3vM/dSIatqLQsEm9yJX0fa/ds/1kNQakWDD5ls4RS6ijgMP+0
	x1eklUolwzUmFuf0/IuMhc6Ska1Udv7yMdzberOSyKweT+xexZxF4ep62uBo
	AXQIpweiWnMDPFYCLzW/31NbTqw9VLrPi9HTuyFvI7S4wecm3ia19MJBlcBI
	9dchMYCf0+LuqLAv70DZJ4sSQiXhcg+/AAAAAElFTkSuQmCC
}]

set flag(CRC) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABJElEQVQoz2VR
	MUpDURCcl/wiKKg38BCeQCy8gxfwAEJuEFKr2FhYBCzEU3gLWy2sFDSKkt2d
	GYufRMVhGBjYXYadhu0JAktIiIIF1C/GSgNQh43RxeWhARuyRZckqWjSpJJi
	qcQqn44v2sIeArABGIBtwH/R+9ba63zeYTbD3p6/Pi3DslakLNkCadJS29iM
	25v2AOyMx3x8dJWyXOlMZCrSGYpwZq/D3d37u7tOAIrOVJX7hQhnrucU4Qhl
	DqoEdALEUpUynOVMZzjy9+2lZgpob9PJaP9AH+990F61ym0SpGSLg62tp/Oz
	9rVYdMOhpeWLbNv6/yWgtfb88tKAk8nVEUukiiqKVJYoslwSKclF2b6ejhtw
	vGpxXefa/hQMFCBg8A0y93t3cBk/8gAAAABJRU5ErkJggg==
}]

set flag(CRO) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABYElEQVQoz21R
	O0gDQRDdi4mmsBFEsAiKIEj6pE4KG7EVwUaEVFoLQkBLQRSE1DYWwVTWdoJN
	ihQpLezOI2U+d7lLdufj7F4SEVyGx9uZ92Zndz1Wv4v+8n/Ds4Z6XYDJ6TMZ
	JiYERvKMVsYwAM8xarWyrh3zd6AQJSR7eXQPWwxfDNvUuDpjo1lryXuFgrTM
	uN68UBvEu+eLh/zw8anWyA+MmVq1nnnsDIhIbglBwCRJTLerq9VppzMpl0ej
	URzH4/E4iiLBXq83M1ixW1LWlUqqTtrtwXCYqsMwFEcQ2MkxVRuQgYyUrbpU
	EnVcLPb7/VQtRwnxfd9Txx+3pzvBYGqQAckghf5n8/VaJj48uFne3JMMEAFy
	YW3l5fw9qzTI3ljpzLC0sXtSawrJua0BApaSvLN8AYlBGvD6ak7Uch15CEFb
	ttwiOjUJOoOn9t8UkJqAHCVmi5M5kQDHcfHR6gcS03cdsdAjaQAAAABJRU5E
	rkJggg==
}]

set flag(CUB) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABiElEQVQoz22R
	wUtUYRTFzze+Jh1HoTCUaFkRkcssQgQXQxCEECFBENJGkTZtaxnkroURFQoR
	FP0Folj5D9g+IshdEYzkPBl9893zndviPVt1OffHXVzugXPDd+Dc9AfUmygO
	IIAEhShEHpGIREEUEfV6dhbIJ7++vzCzN3jS5ZKzZBLlpJJkdJOY9ObBp7AP
	DD5+lP/8NXx/zq5OAu5yd1Tt7nC5u3sI4U+nkwkw+YDZ/stXzW4XreseUC0e
	qeZwRwio1xA6wPGlpb6JCVtZ6R0WW8MX16/MRsEok0hZqnj6RP+7h2uZgKzV
	wvh4n/HY8vLU7y/5Znf1/C2LFi1FJjNFyqjeWAP4kQngxkYtz+3F857Fz0OX
	Pl67OyqUVy3JKFJMGhvpB86EXaCxuOg7O4fk0Nw9vz3r/ysAIYR2u50JyMg9
	srEwbzduOt2rVOTuUpkXypQOCmZNoJP86Z1ncRd8+610p9zKISlJKXmSJ8fW
	k9WwDVw+9bp6akE4gX+KAAEBBAAQqP0F5qlT7M03oSAAAAAASUVORK5CYII=
}]

set flag(CXR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABuUlEQVQoz02R
	O2jTcRzEL8nf1qYx6iBNSlUssZBBER+L4GN09DEJSkVLsFAoFDpIRwkoioOC
	KCgitKg4FAqCgyA+KKI4RKoU4hCstQ4BsdU0//s+fg6mkOM4Dm67TwI9g7j+
	EBm05IADupbtRQFFApieKBdw+K33fnO4uWkwC6pB1VVdJKgGObFFp37IzPOZ
	COhAI/393lHb+96OvJDUqrlJEPGW6aSznhUJW6GIALjDzPXdPv2y3Y4/Zb6m
	rmLCQHHeGBAPDEEObJD9J5EE3MzL5f7udEp/bubtC1e2Jc7keLaX13YyNpY+
	8/wc3Tn3Ry5PIgl4NhuNjVWXl+3mrYLE6Xx3oyp8sEgPpAudw3388Jv3FxWK
	JIChoZxZiCIfHa2S8dJiZqSHd4pxhzo9Hu6jOa/WKC5QpIBTjUZnvS6Dg7li
	sWt29tf0k0Mr9fXVj/0TIyMyv+NNvvK6uaKum9ZtXPq0lAAelUp7FhZW49ib
	TSOdDCIR6SINikv0V8/d1YOvCulC5XElAihiu3Znhi/mx8e/qrYeVYVIl6qr
	dtqzS1Y7Zqcn/4ObAhptMNvBEtC1FcA8Ei//AZNQPUL8Q3U4AAAAAElFTkSu
	QmCC
}]

set flag(CYI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAMAAABBPP0LAAAABGdBTUEAALGP
	C/xhBQAAAAFzUkdCAK7OHOkAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUw
	AADqYAAAOpgAABdwnLpRPAAAALFQTFRF4uP3P1m8P1m9Pli56N4A3NMA8fP8
	8PP8m6nelaTcjJzZ//hh//hT7vH77fD7hJXWe43TSGHCdIfR//c7//Y1//Yv
	YHbKWnHIboLP//Yp//dF7O/7fY/UYnjLOlKuZnvM//Yj0McA4uL27O/6aH3N
	Y3nLN06lXXPJ//UZ7/L76+76UGjFR2HCNUufa4DOVm3H//URysEA6u36U2vG
	TmfE7fD6dYjRcobQ4uL0O1OwOVGrZcbW6QAAAAFiS0dEHJwEQQcAAAAJcEhZ
	cwAAAEgAAABIAEbJaz4AAAB2SURBVAgdBcExTsNQEAXAedbX322cuEoFjRvu
	f6egICigAtkUMBOQ8LcEiUkiIuIYVCQRSX4sBHN+jZmMi6iy5vVJ8j3qrGVn
	baq7R/Vh2E/1+VzJWY0FZW6/Obt1tsW99O1Y50pjcPfy7pq360dE9hsieGz4
	B5f4FYixcl59AAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDE0LTExLTI0VDE0OjQ3
	OjI2KzAxOjAwAqodqAAAACV0RVh0ZGF0ZTptb2RpZnkAMjAxNC0xMS0yNFQx
	NDo0NzoyNiswMTowMHP3pRQAAAAASUVORK5CYII=
}]

set flag(CYP) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAE+
	SURBVHjaYvz48SMDEvj3D0zAKQwAEEAsQMDFxQWU/v//P0QPmP7/H04hgRcv
	XgAEEAtM0X9kBqqyf0AxIMXIyAi0ASCAmFBV/2P4du3/r+f/H0/4//fL/x93
	/j9o+n+v8f//P1Ct//4BBBAL3PUgbV9O/n+59P+vN/9/vv7/btt/Dtb/fAH/
	hSL//2eCGPrnzx+AAGKB+A9iAAOn7n/mX///v/rP9v8/m/R/Hqv/gvFwlzGA
	nQQQQCANMIH/fxnYDzP56gt/4+PWu/b59fXPbwMEEF5hBDsJIIBYEMaD/fD4
	25czr97I89288uqKMLcIwniYVwECiPH9+/e8vLzIDnv+9fnuxwfcZZyEOYSR
	NQBD6e7duwABxPj27Vs+Pj5kY7CFLEgAiIEaAAII5Id3795BYvEPGOICkMAE
	CDAAlKhdBC91VK8AAAAASUVORK5CYII=
}]

set flag(CZE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABNklEQVQoz3VR
	PUvEQBCdxOVATyHCieBHYUptBLGNVhaCYHG9vcX9Ef+IcCKm8g9ce8kJovgH
	JBaiwhXu7syss5tLOIR7LC+T3ffmYzeCq/HNZe/6rAcBzFzzfNACmdU6Tztr
	u28VHe6t1h7nArWfOVRVFQu6DoeT6ej1p1a0sn/p64JKAmK3Qjp/ZmLO9hO3
	ADMDSl+SzLku6fsnQuLTg2SRARGVwTANOSK3TPp2TJuPw3SjI/+MKAwUzoii
	JIHBQCpIUr8pHkt8MbnbKR60sc4Ysp6dtRxYpem31opQWvdSMWRlnhX5TGQt
	GAPBIyzd+AWgwPgSXl3kJ6VX1/lam99BMfiuMBi8+vx9dPxZwta2nMWST6Qy
	gLWRMOJSM0ao8Isv/aM+fH3IrYXlb6OJsX7+JogB/gAzGXkTyGBGPQAAAABJ
	RU5ErkJggg==
}]

set flag(DEN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABJ0lEQVQoz21S
	O04DUQyc93YLBIpEhZRiG27AQeAgtNDlVilziFwhAkFBBFKWBKR4bA/FW5BA
	jFxY/nvsMgKJCQmcR+R2u5vPE/gjDgDoEzhZLAAgE5mllDqbnd3f5cen3EXC
	XaTck3xZLnsAgPLpGRGKkKSI2DzkYS9SRtFklmQdhmwdkJqiSQCSkpYtlCZj
	mokspE0JEXKXO+iSVKv2exhBk5lImIEUmUCJiFKKJEmtvDLVlN8otY67XY8f
	HwSh5ek/FCkz+23XzW5vY7ORu8xOVyuN4+H6JvfvbZ62gNz7y8un9boH0OgT
	CXJqZkccj5PRTE54IGJiSfQ6n4uUBwB0XR0GHA6l0e9eIxCREQDKM+Dfh3Tg
	4u3NHx9fr65+jO0P2pkr8AUGrln15CPgFgAAAABJRU5ErkJggg==
}]

set flag(DJI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABdUlEQVQoz02M
	P0vVYRiGr985P8xjFkVNIRTS4KpDWzhbo5+jya8imkPfoBYXExIkaRGElv5A
	uejQ0SiOeozj+z7PfTeoFFzcXMPF3ex88ct39H8zPgaoBBIRlFCERqESKkWj
	UCkaa2lsD0d8OuTwlwFAQnLaKVLOtORLebE2bIHJcZ489u0Jdr9xNnIH0s50
	yJmOvKrvTjZILWAbmHnA/Vv+8JX9I4Mtpxx5hdKZUNSRhM3mps/P793k+ayf
	zrjXmOLONd3iprgpZkgLsLfnjQ2fnrK42DSefeQ/ve/rH89DisyQIhWpi4ke
	d962gOfm3O97fh5b1vpg/dXZ2o+HP6trUamqRaW6Tt+Y5tluK6lpGi8sAAcX
	B6vHq9sn29X1X+1SVUORnWBIK6nb7dreOt1aPl4+Gh2Vpvz3XatLqIYynEAr
	aaDB68GbnZP3vc7EVG+qqlbVcFxuKNKZynRSaFf6K0uflxhABwICBAEFdO0B
	QMA4fwF8014jXnHg7AAAAABJRU5ErkJggg==
}]

set flag(DMA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABw0lEQVQoz1VS
	PWhTcRy891FjbBEExcKzxA5OGayCCnXxW0SoDg4SMhQpFiMKGhShFtEOj7q1
	OChYBwetoHaUpwgl4FoXoUMHiSHFDk1qIm3y+/j/HFJQbzgO7rjlzsMk/sIB
	AjhoDsE+tNvt1L0UBCBsMiEEMHFqAoBCzZmYOGfY2VUs1oIgKFwssGNxzE7E
	yezT2bBTXV1fdk7FiZjkvxHPyx32KL56xq9MZ5Uds3DUE4Hgw0Gh+k96YO13
	fFpyg08Kg+0jtca1hQ0SIkeiAoKnZXg7YsiymcJEZlZfnGie278lv5Sihalj
	uy6PJ+Tf6jYjL9jTWHzjAbg/drdS+cEiwjwdhT3B6kh2pn0g/+z5Rhfzr7X0
	0GKDiDKZvcnHeU9VAZiZwWCQydGXh5dyn1thwYa/r/c1dTzp8+M5M/N9v16v
	exhD8Xyx3Cyzsjge+do6VGu+O0nDCT88q9fft0rdwaODJir92/tLccmHQFRI
	iZVJeSrrvmzzr3zy6ytbH3yIOmlWZidqCkEIAhv3pnvFRFTEydujPDSQvjn6
	8/XjuVfJhYwTVVVTdQqBhxv/DdnRK7ex+ziq1Wp0Kdp0OycA/gBNnSyMAF7b
	SQAAAABJRU5ErkJggg==
}]

set flag(DOM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABN0lEQVQoz3VR
	MWqUYRSc798fixWEEIwsmCKN4gG8jYVN6lR2OYOFJxCCF0iX3gukiN1KakFZ
	u+TNvBmLfyOxcIrh8Zh5A/PG6s0FHtAyyrB/fnv/TLvvB4cGDOgRzwA+nb8N
	kMAdO7LXTzDm9fPT05CRQloKub28nAEk+PHrrhd1uzudzG5utymG5aqQq+Nj
	A3MbCbrTTrfVkewkcarCcjFVJidSwAxZflBrb5hHMq1S5SqTqQppUsDo7jFG
	kiQA8n+Mafq9240tcHh2ptvbsEKZDOvg6qqn+d2Hr5Kplkz55YunXz5+ngxk
	HypXpSr3lfu76ixqypSl7jag2cC+OHJxuiqJk+L+trrVaf81UNNmM8ioLQ5y
	TKtpjM3RuttLdbbVATxu/n3kwq9urnfro9cn54/Wy4A/xLJ33785oNsAAAAA
	SUVORK5CYII=
}]

set flag(ECU) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABKklEQVQoz22O
	PUqdYRCFz6evIFcJiCERK7lNmuwgq8kCbMTaStKkdUMuINiqlSI2MYkXo6Lv
	nB+LzysKDofhcOZhZobHky/wDcay7Q7T6HY3YwOGDRM2ADT43+KnfQCAkCxE
	iBONQpgQYeyEs+OfDWhAwKs54YQJYyaEGVRcMYelz+5oMAC/S8eVEKmYScGk
	0drkZlh8RB5eHpjrmRvXJzW0++UJ2sfdvR/fv/2+vqUiizJlSkVRLkkU6ZI3
	1lcPti/a9enm5ezDxZ9Wcsmki+50yUUVMw/1XxNg2vBgahy7+GI0ms5wPEVL
	BjwcAZs7O/3sLFWueu69u8rkmIQVamk6/XV42LaA5bsZ1lbCSmkkwEoxrIgh
	Q0HK7d+vwHAOEPBb8ZXBK7MAPAH8bIEjXhWmewAAAABJRU5ErkJggg==
}]

set flag(EGY) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABI0lEQVQoz52P
	IU5DYRCE5388UCSoUipwNWCqkByCO5D6OhIsqUByABwXqEFyhl6gCkigwVQQ
	+s/sDuIVAki+bCaTyewmW96AxIb8rd+jH2GbwO7lJQBnItMRVjhkCZJJS0la
	Avk8m7UADMfjEyIcAdIRJk0m6UqzZq0gm8NDAe3OyUlzdIze/uZ8BCK45tbp
	e/OwnayWGslS6fV27u9LRJRSANiGYTgzPpa34OP2wQXc+otSymq1arp3Nxls
	u75ca73KWNfnK/8EyMzmT9u2Lcof3EvzV9/OzDIajSaTyXK5jAhJkkidn73a
	urnbk5QZkiKi3+9Pp9MCYDweLxYLkiRrrbXWzpDsnEQphsPhfD5vAZAaDAYk
	pZC6RUrqtDvfgX/wCf7XTmNI7QE6AAAAAElFTkSuQmCC
}]

set flag(ENG) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAGC
	SURBVHjaYvz48SMDEvj3j+Hfty/npKX/MTAY3L7NwMf3DxUABBALUBEfHx+Q
	/P//P1QPJ7t6UdG/P3+EpKQY2Nj+I4Fnz54BBBALRBFcNUj4378fDx78+/37
	39+/QBvhqhkZGf/8+QMQQCxoqiEkUPX/X7+BShiQjAc7+B9AALE8SEmRi4//
	++ED0Dyg2Qx///77+fPfr1//f/9+PWMGUBVQHCT15w+LkNCF3FyAAGJ5t3q1
	oJLSr8eP///+8//Pb5BLgMYDyV+/3q1Z8w/MAPrn/69f7AoKzxgYAAKIhcve
	ntvIiE1e/t+/vwx/QIYBbfi4dStQKa+LC9QGoIa/f1lFRAT27QMIIMa3b9/y
	8/PDXQ/ywI8ft1xdgQar7tsHDyWgLNDTd+7cAQggFqA/kL0LkQQ5A4j+/mVE
	8jEQAEMJIIBAGuCqIaKMDAxsMjJAJzEyMQFNhYlBZQECCKTh1atXyHH56927
	Q1u2/GJgcLh0iUFICOSEf//+gB0CBAABBgAC4UQezUonUAAAAABJRU5ErkJg
	gg==
}]

set flag(ERI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABuUlEQVQoz2XR
	T0tUYRiG8fucec/p5NgMmVPT6BgVoaQLi5qyQmglFEE7N32MdoF9gjYto0WL
	drnJRdGiQIqoJEULZMYokJywyOnfOGee537e08qV8Ftc+yt4uRf3xzBbQ3sI
	SADZQYC7AghaQO+tmU4OzTzrh3z9oDWLtBxppJFe1ZNe1ahe5+7NuRSI4cPN
	5rEyj3+wyYhrv/T9ET4fka1IFCoUoahpNV8F4QAEJR9dZxZp9tvyeR3f5Ohd
	uzbPj4f5tqpvqrpeEA1UMwXhPBBNUZ5psJ/hMLfvMLkpUrbkk17c0okl/oi4
	WLFXR/XbuGIbLgQQG9dszzQzr/aT2T9FWblKNYFJsZ1e+S5TC7reyD+ah/NA
	pnSnJFPNvMbTRKlrTQbdNFb1Iq1cz+vyuaUDE62xSTy57Qh0n/rokvArw4qE
	g+IfSG5F/yJp9J9e7K8t953d6BnoZNGJRIGG84BfZeeFxiMSQP+8C7/YyeXh
	2kLpwkZSaSMO0i5EIqa+4AC6GHDaTfuGPrcG6oXRlatnWq6oPnC0QfPeUvbC
	fM4sNJ8BDB4DD3F5FjeyfeeRJtAUSHf2+l3wH1DdHMyEFARNAAAAAElFTkSu
	QmCC
}]

set flag(ESA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABPElEQVQoz1WR
	v2qUURDFz3U/99P0EVaICImkSCEBU/peopAHSJM2PolFioAQQhJSbyE2FiGo
	CC6GyL0zv2Nxs0schuEwzL9zpuj1XFX3BqooUJUqqqGKGhJS9Dio6vDDs14M
	AiKVOCFTEY50BB0c7c8HQaKbnwHOdKQjnekWjqCFW7gFrTFbfyzVcnJ5u7kx
	rRVbtukORrbAYAx4nD76fP69ZGYpRZJtWZZt//qyf8v4fOudH1gpZbFYDJ1t
	T3VwNb87//ojaG/u/uztrK0aVAowrKpX83e3p4v2Nsm9naf/bbCBcnz2+9WL
	8W8FbLsfHU6QLHBngP1knByfXheNl+8PNr7d1KUm1HCmW6O17CpFEumXs+mn
	jxeDwNZsfWjhDCId4ZZEEjHJvNcanEiiaHKq1OqRyxhLzAOApH+kWGxNdtRk
	DwAAAABJRU5ErkJggg==
}]

set flag(ESH) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABTUlEQVQoz5VQ
	sU5CUQztQ0xI0MQ8WTCwECbiD/ADLCzGT2BgcXAyjCwu/oEh8ROMeaMxfgAJ
	khBZgTjgpAGNgXDbe+u5F0UdPW16+9qetq9E/0FCFOFpt9uwzjkbAEeERbzP
	zBIEofPlcjdJ0oGp0+kz0rIBiwEFJsAZc7VY5AuFd6L0ZDKJ4xhJz/sLjFIE
	mT/q9aIxcBwIuYNcdju7rqYg2utpt6vzubZaKHqqVourFRyCEqUcuZ/eeIdD
	7XS0VtPlEoGvarSHijhPwNxNNVCpaKOh1zcapfBVvLufrauNobBSNJqN4kws
	VvzS6tZMdPGTvaiy2Tqs7olEpdJLvx/RKTWPmuO3MeOGjg0uYnEh9tay/1PF
	MvxwZvfL5dfBII0mrJLfySMtzkqgQcWJtzi1inX2+NImF9avRCdECyITVL6d
	374ERW2Gbh/pEwaWUAesUqiwAAAAAElFTkSuQmCC
}]

set flag(ESP) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABH0lEQVQoz32R
	rU5cURSFv3PntghCJQkCBUgQ9RieAVmN6CtMJsFjeBZsVVUtg2dUK5owyYTO
	lLln/yzEvRM6CenOypcl9l5i7SLeJrf9uyoCxmNAmWQSIQ/C5Y67zPQPl3d3
	LQDSz19EECGznoOqyapqlVk5PExoCVQEAfF3kS8L7e3X0Y5LJlWpDiaNYvlM
	kwABvlx53MJNu3q6WHd1s70RVRjQABCSje6/+G8vXycfHo+6edmKH248kwaQ
	XPL27OTPSXI9GZ1+bvVR6qS6YZUqskyaTPqYH48Pu+d1fdl9n35bf1ptsgeC
	S+5O6WB0dZWzGUMtQycDe+OGRzk+nk+nbUJjzsGBzPDADbNihjs93fvGiUgo
	q+1H/ufH/bwCdrRKrziyqwAAAAAASUVORK5CYII=
}]

set flag(EST) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAE/
	SURBVHjaYmRw3s8AB/8YGH79Y/gDRr/+gNhA9OMPmP2H4cc/ht9/AAJQKMcE
	AIAwDMB2YAV5U4ArNOCqa8v25MrqdnJPVsim3JlS0cU2MAoy6JvvCyAWiNFP
	3gPFQaqB1N+/IBIo/fsPiPz1598vIPf3P1lhdgaGPwABxAJ0xj+QkUCDQaYC
	Vf8CGQlSDVIHJP+A9Pz+B9QMdPEfgABiYdjv+Ne07M+jR3+A4DcIQsCvX2AC
	RoGE5OUZGA4CBBDISX/+/AVy4Rqg0sjKwTRQHqgYIIBAGv7+BSn+9fsXzHyQ
	AmSz4UYAFQMEEOPTp0/FxcX///8P5PzHDUBKGRkvXLgAEEAs/4BeBislqAEc
	9P8AAgikAa4aHoFAwxhQAJD7H6IBIIBAGh48eACyBwyBnvkHBhAGxKP/YADI
	BggwANQufux425lWAAAAAElFTkSuQmCC
}]

set flag(ETH) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABhElEQVQoz12L
	sWuTYRjE7/3yGSsWDbRKGgixnYRujg4d/A8KXerk4iK4OIiguDQ4Cy5uTk7Z
	RHB2FXEqKFhqCUrBBFNjkn5573mec6iKevyG+3FcwvYqJmOcJAzZEBmZMMCA
	CshA/l0WUGL87f7NRwAiFHKPsHC3bOEWMne6mxvD6Xxx+3GJqg6mz6OBh3sE
	I3uyVLboMZ3usWI2ZCPJ9nITQIm1wXJjzmJm4RE2J85dvFOr1T1iUlWH/QdS
	Rae5Nc+fxQUkd6R0F+hLBtmTt93hbGmj3Ts4urQ7uNKoH967ekPKElPqjMev
	CwCAS5QocJrrG+3ewdGqRVzrPB8eN6T8C1gECgCSSSZkKaeierW/FcqtxQ8v
	P26fOTX6c4AYgUQgdW/pyyeYyXKeY2fz6ffTiwwt/Bh1n22VmoiEWWqvDXvv
	ygBqfdM+QYosc364c/19c93NL++9KThTzjLCHMcOoAygoGFlRSTMYSzIdX4V
	TJ2WzGAG9xMCSFMg/gL/6n8TgJ8hCj2mpjr9CQAAAABJRU5ErkJggg==
}]

set flag(FAI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAFs
	SURBVHjaYvz8+TMDDPDKvbj9XlWV/eb7F2L//v0DivzDAAABxAIU5eHhAZL/
	//8v7xAVeVlSICTKx8cH5EIEkcGzZ88AAogFYjZE+tHLP3+ePnj48/d/bICR
	kRFoA0AAscBV/waiv//+/fn76w8DVg0QFwIEADEAzv8EDRzodokU4ur9/Pz+
	/P3/APv6+/3/RnXr+vv/+/z++vz/+/v++vv++/z/HxgEwZPcAojxJgODaGPx
	nycP/v8FSv75/weo8BdI1W8Q4x+I8QvCYJVTvLzxKEAAsagzX88XEnvw88+v
	vyDFCx9FhoovBRoJMvsP1GwIqSTGcorhMkAAsbx/I8HLywtxomvxq/+/fv38
	9e/wJBFMDwA9fS9HASCAWCDhDRECuhvogF+/sfsYCP78+QMQQCAN8CCXEmFm
	/iEjK8oMNIwBBQC5UD0AAcT48uVLeCzKyj7Yz2DryLD35k0Z5NgFBucfsEOA
	ACDAAHgwX+bAaYh7AAAAAElFTkSuQmCC
}]

set flag(FIJ) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABzElEQVQoz02R
	P2iTYRjE702+tDEl1mgS27TFarFoh9JWHVxcKkKd2kGqg4OTFFGRDoIViujm
	Ig4FFxUHRUGnWBCqoLSCQ0HBuFnt0qQojSY1Cd/7PM85BP9sd8PB7+7c0vmZ
	hTA3e+fT7I73iZbI5WL32c7K+PjBscpV5AxiaBjEYIaaQeCGey4+fzApO3ON
	wkfWaq4j157dNl+or6aHgzhCUIxiFKUYb89tBnfliSv0b3n7MlouW73ekkrV
	BYeFiweGkKQqxeiVXtnR5hBakE8Mnenbnyiv1YVueybe17vxpViotnqlKqfz
	l2L1avqklO55dPfOhdORtZFjLh5//DlY8W1fa7GHP7siu3ZvsNUrKTQvmVNC
	CbOnxbxAEKQH9uVLyaVIf6Ozy5m+Womu7h0YPCS+TFPi+q3YVpYmJzKPnmIk
	ghM/HK7pzVGsVZvN0CQWpTfWyHMvrvSUClrdZBD9Nnjk6OJUgNCUTpRiEKVX
	emNTEGyfvZFpZ3FiLPtsvlFxePM9gJhoVJT+b+DPMiE485rH93DU+/sfuLwO
	hAjQMI9IKgltIhGiUHOiEIMQyyW8u7Bg61QDzBymfkEMoSFs/op/1v4TYjAA
	+A0AOEaMgDxnCAAAAABJRU5ErkJggg==
}]

set flag(FIN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABN0lEQVQYGW3B
	MUvVYRjG4fs9/SORExQIBUpDONhU0NrY5+hTRKstUZ+kIWhuKIim2poKoqQW
	g0go7Az6vvfzu/OIgULX1XZ//tGJ2frdd+poPvvw9NbqiozECbP0e38xzaSr
	a3NJSR492CJUaev6pSSSctbHL31CS0kkfd87NKoi/9Na62YCFZGUZJQK7BQk
	yikKaq2bpttvHt/f3N3rVfQRV0YR6I6dUfSBTS821i48e/hy0oG7ORxUxcVw
	XNiMyjDdeNCLMdKNdDAJ5wgBhmPTzZGqVEFRQAEBJNrnr7+ubVwEEt17sjPM
	MM+3NyGnSWqtvX3/bZpNnGtqTWoaZphhkkiRIkWKFB2DPgmSSEpy5fJ5F7Za
	azqjSdGx9mnnB2CWbt54JXVp9uL1nfmqDDIW/2h/sfgL03Ro9wHosQQAAAAA
	SUVORK5CYII=
}]

set flag(FLK) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAB1UlEQVQoz1WR
	O2hTYRxHf7n5etPam2hRYhPqA4sOKooGUdqKOCpWUHBw0cFRUBzFSRxKwcm9
	i4oUp6JUTaE+h4oYS9rQQaXVKKH1lXKT3Nz7f3zXQRSEM5ztDCexdOXaeOfu
	q3d/3HEmCM6Fr4eu71g8MZAvjDUBHxAgBAgQgAA3MVi4MXnzaJDbnFyo2EaD
	e3PpfHbiPb8tfSFVEWW2VpXEksQPxkbMy0+34kpP5kURfgNBO16XEZs8FYQP
	/X2rUSI7dADGNCON2pFZKANixvNDw9t3el6nfvwcr88m+3r9Wr3sdrV/xhSK
	pryLRzrEYvRJkyMByLw7fu5YJn1vcVMhI2rjmfTB4V3V5XI9ICLRkHVqdr47
	ya2VlCsWIONOPbq94fSrJf6VMkxSnJsr9a8d7LAaBRwlUsYZ2Lble+V10ulj
	EoDMyCwun3Qkaj9uecKWNZov10oCgsNhtEbq1Zln31aWu9hbZQuQAYTVklhh
	ZVFiS3HMVpj10hlQ9Hw66Bd36x7/qbt/45uiGEBElFmZlUWIlViZlSIdvW/P
	H67tRZWJWkqTpZ4/hYAlzmU9FhVRYcuqLCqsrHb6Q3esRKwSG1UFKAGcBXyA
	/icE5O/df2IB7ze+vz+MSXZKegAAAABJRU5ErkJggg==
}]

set flag(FRA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABOElEQVQYGW3B
	PYpUQRgF0FvVz2AEJ1GQ1swFCG7AyFhwIyYmxiKGJjKx7mm2IGZGTjdVX90f
	nw2Cgee0dze3+Mv029fXkuackki21p69euE7cIKAgQ3Am5dPAMSxczw+SAIg
	ie0k9z5+DperstbP9x827IJf5yXF9ul0yoXt1pqk6x/fXTM18fARgQ4jjhTZ
	VHrvSVprvfck3tXwnF4zVQY20rIlS6GVpPce77ID4DlT07VaVQFbFe1IXraY
	w+HgHbB12G3nObPKVY00sBVNZcmUSecfkrKrqarU6lUFbKMom/SSueSLJJJ8
	oarU9FrgMrCNQdKLJrXo/5gzXF6rUQS2cxXp+1cHEWRvrfXecdEuDo+PJpsY
	LQPb+cxP327HqPPg3ainV8eqWmOUVFVjjOdfvhogYPzxG+6te2aLGUjlAAAA
	AElFTkSuQmCC
}]

set flag(FSM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABYElEQVQYGQXB
	v26IARjF4VO+phJNqxFEmjQGkpqMLCVGu1kkZnENLsDkKgwScQE6aAwMDNWE
	BSVCm/6RFJ/3e8/veJ6Zmw/XJUmSBGqoppuiq6imqsfq6h4LVw+SHty6JIko
	CYmdpfnZoB+//hLZACZ27j/eGCRJOvg9kUAM4+Tb15aTPHr+QTNqY7BZmp9T
	9SAEgjiYTGZGevLqKyTKNEHSBmOj6qFRFAc7q8sLhM0vh9/2/hgnunJh0eT1
	xz2DiaqGBhM7k1lbPZ1k/Od3n/dt1i6fuXpxKcnG1g5J26oeqhuAhLzY3El4
	v33YxGR98+f+0Tg1JgkGdQ/V7aiN4e2ng2qHnFucM9nePXq5tZso0GCi5li1
	MDZtbETGqe9cX7l7Y2WslmJoMEBUDGN1k4WTs3YMduZ9/Nmb70nOnjoRRLDj
	ABE9c/7e07G6usfC1apWtbrVrWoV6la3WqIl/QdJRZd0G7+eLAAAAABJRU5E
	rkJggg==
}]

set flag(GAB) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABHklEQVQoz1VR
	vUqcURSc+3mzrmJhEVIo+xABe8u8TEobscwL2KRLnyJFwGdShEAgKKtyz/xY
	fO6aPQzDwPllTsM3vIcBbniLsQEBogO4+nIFwLFjRbRkMqRJV4l0lVmqm+83
	HQaS2/WdIlnlmrlcpSrV0BgepVodrfCCjiU+9Cz2JIutpqaa16cwzacUMBpq
	MRUW6LpAawKYEGFQyRYjGRtRrdXDGToAQEklBLhN/yfe2tBoowNImDAYCHfr
	drilbDSc/7z++vn+7xMZSiXP7lCmXBJpKpRPPx7+uPzV8ef48Xn/3xo1u6gU
	LbroubloOpSPDpbASceg5E/He+REvQ2bhWg5tKVIdgy8NKx+42lgGIMYRrj7
	5+3bAQxgegWcI2hfW8eMMwAAAABJRU5ErkJggg==
}]

set flag(GAM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABMklEQVQoz1WO
	wUqWYRSE5/37CCItIeTHxIXgostx0y3o0q3gLvACvBUvojZCCLVpoZtEsjBy
	le/MnGnx+mUNs3jOHM5h2gdAeFTNo2auGUY+Cdg+OgKAqlTFhlxWpJJAllRk
	pJDvT08nAED616vYsIssO2SRIauz2NN7kU+3tgRMb66vX62vI5UkADL0F2pg
	Ja21+0+f23Lf7962m1/wqFORH2yHihw6cpZr7eTwbvr2BT9v8eN2LCBHCh0q
	nEEKFdw3fK/p2WusrGSV4ytUDwfjUhUOcF6+CJ5Uu7y63FxuVlXm1v+pUikE
	QRaLxdnHs4YD7O3uXdxd0KTZ3bv7AJrdpLuKKu+s7Zwfn08QGG0836CpskwW
	WVSJRVmKbDt2GR0N+8BvoAMC+j/WnGh2AQv8Ad3+bBGgHXrQAAAAAElFTkSu
	QmCC
}]

set flag(GBR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAB6ElEQVQoz2OY
	NHPfjqtvqqcfS2kGosOJjQdu3n27NrlxTUIdkOGZvc0jbYdtzIaoxp1zAvOr
	5x5lWLLi1P+Nq/79+3/74ZdFG27PX38HyP4/ped/XyuQMWnh5d65F06eePyv
	q+bf358TNl1gSGo5uOfku/9Ll/8/uPf///9t064Cyf+pmf8TEoF0Sd+lL4vW
	fO/uBrLnrbokaTIDpGHhhrt1E68+3Hf/T1P9fwiIifkfHgFi5Gb+f/Hiwp23
	jp7Li5qOCOpOZAA6FOQGNBAa+t/PD00MqOzMtZcMaxJr/0/u+J+S8j8+/n9k
	5P+QEJBSH59/rq6/7O1/Wlp+NzH5qqf3VVv7Z7Bbq7wVDhtsbf+YWUDMBeK/
	f//++fvn958/J6++YLCP29Qz53xU2o4rV9//f/vmZ3I8SJWRyW99Q7CGv0+d
	HPfP3CohPSskYT2DcDaDedi6xetBIfO5se5DV1dMyTEg+4+27i9NbaCrreyX
	/Pz//8usuS8SYpqmnmMQTGeYvPnyv39/v7dXHD1wu7DhYF7DYaAL/4Z4/A5y
	/vf3b3jattC41dsP3/r758frBN/soiUMVfMOTHFJds5cJKgzh0djMofqhPPX
	XrRKW7SIm5y+8pJBvJhBtIBBOFfEsK53z3VX0zwAPExoqi63l4YAAAAASUVO
	RK5CYII=
}]

set flag(GBS) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABIklEQVQoz12P
	sY6NARSEv//6rY0VCaqVaNTewBNpSHSyb6AnW6mUKoV38AYqGhKFoOCKMzPn
	KPbe7I2TyZcpJnMyy3B5Ddv3sKFNN7Az7Z2xWQHOzoDpXrpPHmSOA54xeEYz
	l/z67u0KwMznLyQkE0FmdKCaqRkty72++DA9kyzJSExmat+6i14Q1GbT8Cd5
	an+URh7qIPqftNtw7nyTntsv5DeftD2uSGmly63uypRbt6752XdW4FH8xH6s
	Qn79QT+PqqzqUlTZs3X/pn68Ym04kl5WYU+VW39TitSqrh0jt9NmZW24Yo+E
	NFKlalPKPh3J5ZY77vCLtWEjc3o6Es7dE12/qotKtRx7nCSTTNiw/IY+0J2H
	cAOAAoP3pmELt/kHYa9xjsTp3/QAAAAASUVORK5CYII=
}]

set flag(GBZ) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAFh
	SURBVHjaYnz//j0DDPz79w9CIjPg4M+fP0ASIIBYgBICAgJA8v///xBtYPr/
	fziFBB48eAAQQEwwRTDV//79/fb1X3v975cv0GyA2AkQQEyoZv//8/zZv6qC
	r9ev/qvM//vsCZoNQFcBBBATRCtU23+GLx8/AtFePpHP379/+fwJTQNQMUAA
	QTVABRj+cy2ezfb+rev9axzv3rJVFwPNRCgHOwkggJiQVQPBt9CY979/H//6
	692vX59qWv8zMSHUg20ACCCWfxAzIPYwMHCpqTPNWqqxP07Adt5fdna4UyDh
	AVQMEECMP0VZmes7/r14ygDUCUTfv///+uWj+3PuzayM/3j+s7D8//MbKM7w
	7y+jhPTbaQsAAojl3+vfTNevMvz9/f/3b4Y/fxn+/P4ewMHMKsn47S3jrw9A
	Uxh+g1SDpJ49B1oEEECMX4FeQUJA8IeB4Q0DgxCq+D9YagAIMACTvVKMKze5
	rAAAAABJRU5ErkJggg==
}]

set flag(GEO) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABtElEQVQYGTXB
	PWuTURgG4PucvH0Dpdo2BDQinXSOtJqh4Ofm4AdqB/EHOPkPBMGp0EUoCP4D
	lw5VMNBiHYKWqFSLayBDGrUkJpg3yftxnvPclkivy3Q6HRxTVQCqGp4twWPc
	aumEiKgqAFUNABSLRfZ7/vs3W75g5gskstVVipstlXik35cP782lCkpnGo2G
	xYT7sd/7+snt75EE6H+2/UFLJ9K9L4c71XS3BkBEAwAkpy5fmzsxE5SXAPCI
	ODrHieDqjUI+DCrLJFXFjJ48nrp7n38HsIZZRu8Zx7L7kc7ZxSWGeXqPnNVx
	audO/n72NEjWX9lC0R+0KEIncI7qOT1NL/J2k0lMJ+ocncstLAxbh0HwaMVe
	rODceRijaUrvGY/lc50i9sp1hCFVcsb6JLXzhbC6hXa7LSLOuWi7mmVZmqZJ
	kvQePvhz79ZoNBoOh1EU/VpfGwwGURTVajWrqgCSNxv9rXfjjdf8zzk6x4no
	5YvuzvZg7TlJVQ1UlWR+sTLb7eYry5gwp04jS40xAGburARxPHXzNgBVNc1m
	U0RUFQqFioiqhuWyAsN6XUQA6DEA/wDStk5zkli7nAAAAABJRU5ErkJggg==
}]

set flag(GEQ) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABXElEQVQoz2WR
	wUrUYRTFz/f9P5oRUco/zCJyMftEwahl5KpHEFq16V1cCSKImx7CN8iFmxYJ
	rlyIFFNN4JiYmPPde89p4ThYHX4cDofL3ZzUbpyO0MetCPid36feeUHJeLL5
	6scZtihSDIUzgu5ypzvNwp1mdAvb290rQJlt5g8vBhERDJNFhMksJtSoNaqF
	Lc4t4hrFiYTOWvt+/alDECQpX3+QGDMvJeq2klJKoxej7CCJLz/TTS0lTdg5
	Oto6/NSgaVAaNFO6uZur4yYQ0s7H6S8tpdVlPNM/Akhmd/w2eejt80k/GA67
	ZfZBnvn89dtf9xLJEs5OTg/n+QhBE6THCwsNGWSvbWkmUgAk5lyvLgsy87i+
	3n43+HUZHqyVZnCH++l4TDOayY3BTr9/sL9fcOVz309Kr8e2bTxoxnC40yxH
	yF3uIuWuiAwUnA+X36wc/zfxdPT7oQB/AKWpQyaFaDwHAAAAAElFTkSuQmCC
}]

set flag(GER) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABM0lEQVQoz3WR
	PU7EQAyFnZ+VqBCIhoJtKUFiqShBdCtByT224BZcBCmXoIGWoyCh8dhjm+dk
	BRWO8+I474sVp9tu78gKudMwSnPRFq5ETv/EqFp2u2dUPodZM1u07UO12XxR
	nabXse97uN8/PvPB3BZEzeM3mBnnw+NtTlgTHbmvZ3cTSaJWJChllsoAtDD4
	06YJPGndmG1UQyQWrRXpXL3yXHCU6sIrbSOAUAkzgk804BDxPTC7kaUsfDoT
	wBhrfy9GwQz3HoNbqsGNvqnllm6IziMGD3NXpC1F5HqhZBpQh153/IYJFxRn
	HsdwZQYUA3PDbVkzevMtxUnn9zSSUODzV1c9SZcAtFFoZA1tESBaTpHWf1M3
	vVweGDmwgWrJPxyH1DM5FjGQSRarnpyJBvoS+gE4IIdhmLKj2wAAAABJRU5E
	rkJggg==
}]

set flag(GHA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABF0lEQVQoz22O
	PYpUARCE6+kLhA2Ml2VMvIE38AaCiayB4GYewGQjT6ORsOM5PIOJHkBZ0Kmf
	LoO3g7NgUxRNV33QS/Fv5v7+Xy0FcH0NoDOYQVIHcW3YlXrit/v9CgBov/9A
	gqTS5neiKpastOx2A6wAOr3XJmvfVcVSGwBpgHWCZQng1qgL3f7Wp4+idHnJ
	s0ds1bIVFuEXtpfSqjXgVjefub/R4Y+W8urt1t4Az+ABgNatiy3gq5d8csHd
	xeHNa7aHI0BUM1gfvse7F/r2kx4rZMShnkvRsy9UxFCRx08f++sHrDAcK9Jo
	ixlqdHQp9MgTT0CsIDQ+PztX5Ik3cuSxRo5dJ0mTCQYLrgACBngin1x81ADA
	X4YyZWUolkzuAAAAAElFTkSuQmCC
}]

set flag(GLP) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABK0lEQVQoz3WR
	MWtUARCEZ989ziABCTaREBDzB9Lpr7DLX/A3WId0SbqQf5DCTuwE20C61CnC
	Ich1mot43Pl2dsbivQcm6DIsX7Ewy0zsfscCw1DogBIAQKP4Fwtttzk5mZwC
	MCxIqIJk0iwXXWUSJEjz+P48lrPrpy/3bfcmPfhfExHzq0/hZ/DRIRZz/KSD
	YJo0aaYzza4HgbG9szj72HAKv2rwbqOeS2ahhJIpU6BcEuVUdiYFNPiFeNN6
	y/F26nXvMCoHUPZMAa0axO0KLzrPVqjfNoe7/p9MMZ2JSjMFtM0S+LL2tzs4
	UUIWWOMWUlECLWWwCLSLm8utvdeW/hfOEBGAiB8HF4F7HD15n2YhadaYEccq
	BNJVksAP88+Br4+7fNAux9Z7aPAH+TdZT9V8m6gAAAAASUVORK5CYII=
}]

set flag(GRE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABTklEQVQoz2WR
	P0sDQRDF311ONGLgCBEb01jpgV1EwUIQyWcR8TtYCxYW4qcQRAWLdEYFEcUU
	AUnEqIdICvEPBDXH7nsWe4kBYWZ4swxvfzvr5ZbOAVzshgBKq2+g951YJERC
	JCatPwY/RELIBACWS2EURZJW5m4h7W1OSxAACXIpSRQe4xcvjuNisSgJAABJ
	5zfvFCiRkkSmOjvin1aeAzfUnwZQu/u2pLGylsbKGBlLWuXDYGOn7g0vnpbn
	8wdbM5KW1+qkjrejlAIpirvJ9/1mMw5M0mN0DFR5vU5HQqUhURrLBrXqvddu
	vxYK4YDhoGA/Afm+32o9BfvVzsJs5qtL9ZzkvHswFJwYHcmcVTrByVV7ajL3
	0UmslaWsZV/QtaSlLJXPDW0eNrzGw+d4flgS3PogSUgf+kcIkcLlddPDxFH6
	kV0C5l8QcOdw9RfrG2tQ02GPlgAAAABJRU5ErkJggg==
}]

set flag(GRN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABlElEQVQYGQXB
	sW/McRjH8ffv+uuluGhKI7iymComg4lImTpILAQh5w8wiMWgi0qaiHToVrGI
	CBZDxWSQSGMWi3Q4gkTq6krk0vQ8n+f7PF6vKgEAgLgPG7AItwknFolrxB5i
	iYCAgKrAkzd3OkeBoApKSQp4hlM8UeJZFL99YU03rr+qgY2dOf/nx4VWmW6W
	HBFRMpQoR5SpLPZxaEvbonUooG5ARnY3y0KvzLR0brzsrS0rz1TK+kN72teL
	vm2h4wioA6KUucM+99lfb/rqX52f0OyzBqpWLtnjnn3floVpVAoBDSAobfTg
	Q6XU+j+1VyiXB351cPAl34ayNAuzYl48oAYUvvzFu9NmxXdV+jRrxx41sGqt
	M9j909ZNlqZKHgqoA9z1FnP8TMsuTqg9anlLhK6YnRzTw549/yV393SH2kF4
	e1ydlk6MKbEslqHEsqmppuZbdnaf7vWL9UtAHTA58LuTBxpNkYUiQlWKdEKE
	U/npHeXUVLnZLQbVFgQEBEQHvhLviBnCiVXiCLGfeE8AAPwHQsEvIYdkd8wA
	AAAASUVORK5CYII=
}]

set flag(GRL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABJklEQVQoz2VP
	u2oCURA9V1cLC8GFBKwC/oKNH2JnbWtvn7QJWiSFjVr4G6IkNta2IhaL3e7i
	2zt3TopdxMfhwDAz58zDxHGMG6gCUL2GJ3gAisUiAJIAEIY8neD7zOWS4i2C
	IPCSwSSx22Ew4HyO45G+z0aDtdqt2hgjIplUTaLf52SC7ZaHA1crvn9wsXjY
	oKqZ9PYg4HQKK7xcaC0vF+73HI2eDcY1m6ZeZxRRBKp0Sid07pEiplSK220P
	vR4LBary6xO8/3I8ZquVLrTWVCoahhkFaC2XS/z+3amt5XB4VUOEIgJ4CmRF
	eD6j06Eqq1Vms9xs2O1yNksNYiEOziExZKygXKa1+P7B6wvyebNeI4rw9gYR
	iMC5hAqYPaA3xH360ALwDxiKW0pTDzAiAAAAAElFTkSuQmCC
}]

set flag(GUA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABFElEQVQYGWXB
	sW0VQRiF0W+8E7wAWViyTEBASBlE7oGAHCJyKqABKqAImqAGIgJLFkK2ZVar
	mfvfy/IkAtvntOV9auMfw+qfX24O3TvA9t3q12+fIyOzmQO97vn8jl05U+3F
	+dlyAmQHnM58+Bg7qsj5+um+09ld3UbFJpwskP/k/LiOnVl5edaQO8aOTBlV
	EvLQUOzIUcHmjlxuKspRkUecUUlFziwYdESFqkxnijwxFTuqTDXKHVEVObMy
	izxkZyhx5MgBd2SlzcoUU3lqKjsVVQF1hqVlKlOMymNkKCQyKnad1dMnF6fM
	yjZojV1rjaOl8eoc0uxUADcu//DbDLOa1d+/XT87IMlHv+50+eYCDOboL9UA
	c80hejgzAAAAAElFTkSuQmCC
}]

set flag(GUF) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABOElEQVQYGW3B
	PYpUQRgF0FvVz2AEJ1GQ1swFCG7AyFhwIyYmxiKGJjKx7mm2IGZGTjdVX90f
	nw2Cgee0dze3+Mv029fXkuackki21p69euE7cIKAgQ3Am5dPAMSxczw+SAIg
	ie0k9z5+DperstbP9x827IJf5yXF9ul0yoXt1pqk6x/fXTM18fARgQ4jjhTZ
	VHrvSVprvfck3tXwnF4zVQY20rIlS6GVpPce77ID4DlT07VaVQFbFe1IXraY
	w+HgHbB12G3nObPKVY00sBVNZcmUSecfkrKrqarU6lUFbKMom/SSueSLJJJ8
	oarU9FrgMrCNQdKLJrXo/5gzXF6rUQS2cxXp+1cHEWRvrfXecdEuDo+PJpsY
	LQPb+cxP327HqPPg3ainV8eqWmOUVFVjjOdfvhogYPzxG+6te2aLGUjlAAAA
	AElFTkSuQmCC
}]

set flag(GUI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABB0lEQVQoz12R
	MW6UYQxE37+7BUJBSCmQIpSGO3CPVFScgybnyEVyFypaoIGChhSe8TjF/7FZ
	YVmu5nnG8ja8VIBfcA2QkPD7ifdfoKDAYE4A9/fAJFvC6x4avG0+Hv3mlT5/
	siPFaj0+PJ4AmPn+g266pwU9o707+vanKqXW7dUtxQmYzFJrV9eMZzRTM1Wt
	6lJLLYpTYOvGHhv5vHsHkgsgWg64R7oA6gzMqLp2wO1/kdpjjwp5cgbWXA6R
	IrxHkqYKe6r+c8isPI47XsDRHglptA69xKrLkdNOr6MPMjc3I+HmINC2CQw6
	Hvzhrbu7pztN2P5CLpqv5N16c8LPJz7erR8TOPAMMxlnhVa9RAMAAAAASUVO
	RK5CYII=
}]

set flag(GUM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABR0lEQVQoz2VR
	u2pWYRCc7+QYCdj8RNCEH2zzBEIQBDstUliFlL6CVRo7IU0EIUWwio2FPoCF
	VXrBRxCDlaAJ5CJ4di4W50giWZZlYGeXGaZpCZdleIAzwmn6f9wD2D8IADsy
	bMiwQ0aGGCrljODF9lI/vv7xKzIkyJH89PjdjS4H/dagVkwpxdxdbgQ6ANbE
	pkPhwe+XXx+d3Npcf3b0qphiqlIMFQOdByigQEUEmfs/T+Ph6OTLfPH7UK7K
	2GQM9BAkiKFDgvJC48OVjTidP5EqdpMqNQO9ASulUONBzs+yu7e8du/w8Xnq
	JgaGNfk20Bko/2MzVbi4+LM6O9xYf/P5dD5Uq0o5JKRMpiWQKWZgyOzMXz/5
	9nHhQ3u/+nwyzZCRglESldszkKFAQezezvaLuUOUIkFuUhQYaGfXQuUVPK6I
	y+z/AuOWSOYxBBL2AAAAAElFTkSuQmCC
}]

set flag(GUY) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAB0ElEQVQoz1WR
	QUjTYRiHf5/7Y6xmphIb1jTLQ4zonCDB0EsU1EUIOgmdOgRNEmoXwUvkQVqH
	Tu3QKbBDGARBJJFCHdxFI2211Lahm+nE7b/tfd/veztIYPDwOz2XH48ZGIji
	buyHt1zOFeADDgAgh6B/SwBgloCdJ6nQcN+Z/tifBr/OvSvW8lYaAhEVUWYr
	4pidsOXZZ7PeBcCWNhemFj/FvfhId+LijZJ/JF/zny6lC/vrzHUyRI7YcTQU
	BSEwAZjBwd5KxcvS+8wWhz/2n5qPBAtXorfi3UO+deWGv1vfYWq2tbblPueM
	Bcz4ODY2VKTO8gG80MeJh3yinVWDqnea0vG7atKrL/PV7ZnpGWMBkxjT9TUV
	AYsKPyBqH+J7YxwwpMqqpBpWfV6TY5FHpz0Aag/uEbNMMseu0vDNA7tV9T7Z
	rmLNS69Mr1VLmIfnAMOsRDmRVJCuJ/nypRbV8+xGi7XAi9W3c4VMtvJNqHqu
	8yyq8BzQIjLH/KbHJh/3dIZGS/7RX/v+5GLq++5XalYZJGAJWIGFg7cMbHZ0
	rVwLJ2+PbPk09eVVdu8n0Z6D9B6PiBNRsdZatdZZEMzJIMoNIAVkgO1Dpen/
	0g4QIIS/7wc2IdVNLoAAAAAASUVORK5CYII=
}]

set flag(HAI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABDklEQVQoz01R
	QUpEUQzLH94gjm6HwY2gG4/nAUTvoMfxAqKnEAQRGXDjYnxJExfvf5hSSmiT
	trTT+ubFwAoAIDkCutENGQehGxEgwIAANANP91cBUrHhuAq2VamKFJUHYPnx
	4bUBSPC97zZq1GaqOSJNRfJuuwbUYMQpwwtbFclSKEumZoEUQK0EVahlhyP2
	cCmkKf/RgNvZ79eJtqc8qFKDUS650esxgZZK8oYb4H0qAHe3+XiPOroihj2d
	YQ8Z9XDGq8vrn+e3tgfOzVKPhOoRrR4xYtQ9NEWXmvU5zhopZMSl8dzV5Bhi
	EqpUaRZQ0+5iEqOyOA0xNYkpWVotxwYwfQBe3jgAjrCOMsP+AQ2Dh8qvp5cY
	AAAAAElFTkSuQmCC
}]

set flag(HKG) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABUElEQVQoz1WR
	sS6EcRDE5/vfR3wcIqJQ0OoUSjqPQucJJDyFwlOI4pQaEi+h4nJESET4jrCz
	u6O4I2wmky0mmd38qmcgMZ788b9yAIADCRSgdqB7cAAAmcpUBDwUjgiRIuX+
	64Nery4AoLy7V4QiQCqiu7mlmem3k5M0iiYzkWVlBUABgNQ4HVFKKZ2Odne0
	tja1uFgVpNlIIh2oE1CE3OFeVVVzeKiXF93caqrpHB3NPDy87+3ZcDg6L4Ea
	gDxEwj0Zur7W9rZ6Z2oaZej8PD8+0gyk3POnweEumuivx8ezgDY2lKnppj09
	ZduOfyAdKAmAlJnoaTY5P6/1dZnp8kJNM9HtjtJyz98GuItMUuTX42O1v//Z
	71vbzl1dDQcDmcGZHiUiRxySXi0vF1Iecn6SubTUWVgYPj3Vq6twz4gSoQgH
	qj5g/7n+Xfw/+0ngG/KLPeaGKavtAAAAAElFTkSuQmCC
}]

set flag(HMD) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAACC0lEQVQoz03H
	T0hTcRwA8O/b3mhLndO5tmnPtuUi56YdYguzwrKB2SIiKOiUFR2joGSHLkXB
	QBE6ZlHQJbBGBDGFKK1cRA0TTALdFhk129JtbHu/9/vbVfhcPtLHkdszxo7o
	1PpYMS5zfoWHr7f+PLy3ffB+AapFAApABy8MJB6+BFgHwNJQZOxRtI/YFTSf
	EkiVdngsNsvrNPqy+JtRrmJyLhKQZSmzupGYXXkyOi6lTCbnnbv6wl9SLnNN
	M9TXaVyqqThmPFCkEkZYcTaG97tjE3MupWny3rjunf+4rqvH6OtkVhsorq3B
	IFHc6e3diIoT/R0A8D2bj03MRS/3Oax1ADVd8fQwWK0vuOtPvT1nsMSbg3p/
	oGRuOXLQq9gbrg7vUxE5e8xnkKWjvW4ApPdLrfkGx0wWkRrKVnVTS6Xlit7C
	1efJX15Py2Ti21q+UthQmxqNT18trnx9r/+c6QwMdFeLlQwxZfAWmeJcvjKf
	I0yIZGp17V9FCHFmqOtxfMFkNGQW3ugAKFBOKD91yHPzYggTRhkHzgimnHPB
	hKbR0QfJUrnGGQOgOgCMKRNChPa0tTvNJ8O7NUwwoZhQTJiKSZvDPHKpVyOM
	MQFAZQDMOW9uNE1/SPfsss1++qE4zJrGmOCUChXha+dDvp3bNMyeTS8BIAkg
	AkABEADehG6ut//G8ttbABwA/gMK+BukP9MlmgAAAABJRU5ErkJggg==
}]

set flag(HON) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABYklEQVQoz22R
	MWsUcRTEZ+MSc14fIxhFCNjmCyjIgWI6BbvUfgkLEYuDQFC0SKHYiKBCIJ0g
	9oelpY0WRi4KWpjdsPt/82Ysluvy+PGYx/CKYSpcfoN/xDAUCkEhBfA0UONv
	ebRzDYAEWZlIKWmmSTPFFKmgmH63+7pGUQkd/uozlYmF7aAGSlFhRtH6hRHQ
	1dOnm7dvrJ10aTtlpwVbzoFwQpIljUc1m+uYz+eSJGXmcRN7b79HRN+Xru+7
	rpu++Pr7z3Hbtk3TtG07m82WhrS2bZ9dxp3Jedv7n47efziyvb21NlquBteA
	pCVJi9t90cv9H7bvTlbv3Vq1/ergZ9fnwjfJ6vHzz1uTq+0JJaVMCnDKkpRm
	yoYkyeNz9fTZxwrYvf/w5rfDNkLBLHQpGZGFjlChI8gU6Y1L4y8HT2qAZ2pc
	uTgKihTpQQTFFNOZHh4sA6iAB8DKoshymhhaH/bKf9m9dMO1MvScAAAAAElF
	TkSuQmCC
}]

set flag(HUN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAA7ElEQVQoz32O
	KVJDURBF76v6OBQuIgaWwSLYBCoKn11lH8kWYsAiolJ9h0b8fGa4out01elh
	7PElAgBkAS08VwETgPV2C6CTTmBDjgUpUpMtNRkp5GG3mwAAzeeXtmE3GRtk
	yCZTDKurQl6t15kvdPqz3VUtdTGssLqYqnm+gGF7jAGgu9Fo9F8ZY5xOp/ml
	i/UOvwZjJJk+pP/3d4/uJAMP2Dxujq9HWXSVWC6aNMvFpZV1d3O7fzpMOEMS
	Teoilepim2XSJVO22gAmFBitrlcMJSukyVASm7IUWTZsG8DAPVBAAecfUEDj
	W94AIuRtBtudfHgAAAAASUVORK5CYII=
}]

set flag(INA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAFA
	SURBVHjaYrwvyMzw6S8DGPwD0//ACAj+wNj/kNgAAcTC8P6vUF87UPr/v38M
	//79//v3/18g+Yfh35//v//++/vn/x8g+v3/N4hxe9YigABiYWAGG/biOQNI
	6V+wNBj9/f0PqOj3738g1b////rFLCUNtAEggFgY/jIAjYSo/gdWygBU8ec3
	iP37z7/fv0DsXyARxj9AOQaAAGIBOe7b179fPv3/85cBah5Q6a9/v8HafoOM
	//frF1CckYf3FwMDQACxCOSmctjY//34EeSef2AEchiY8QfsB4jlf/8yCwiK
	nT8LEECMf/+CguY/EDCAIW7AxMT0/v17gABi+ffvHyMjI0g9Az7VEFmgLwAC
	iAmoAb9SNG0AAQSyAWgXRA8DDADtZEABQC5IFqgYIIBAGn78+PEPAhjAEAeA
	aAUIMAD/YnbumkL3sQAAAABJRU5ErkJggg==
}]

set flag(IND) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABQElEQVQoz01N
	vWpUYRA93/WiGIv4s6YwMYgxIBaKgq8hPoLgI1hapcuTmN4mYJNGsBE7qyx2
	W1nIJm6xd86Pxd1dM5wZZs6ZOdNyhk14TAOGCRseG65HogeAw48AArcYUSCY
	LbxmdqiYcSVM6u/Xzz0AIKkZIlhJIYorqXUd4iGuduOhid47r9vNZ+h3EidC
	NP199/t0X9arR+eHk1nCmA5bf98PTltJXWsJkozfPp3+Wl4sXjy992N6+e7N
	YydxnHSt/ZlfdB2AAMkGi8XyYHfry9n55WKZJE5GCYDdja5A0AIkyfODO99+
	znl96+WT20lW6gpu+IDjt8ez+YwmVSWWi2KpaJaKIkWae9t7J0cnPYiR2uz9
	XzU3l7RkYUCPATQntyajzaqaNGVJYihJkSwYDe+BASAwXAGvMFzDAPAP+jxN
	FpQER60AAAAASUVORK5CYII=
}]

set flag(IOT) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAACBklEQVQoz2O8
	Xtu744dc4ZRnCxWOsDH9i7yq12z+Yc8HqYM3fzAw/GFg+MLA8ItBcxHD9Rgw
	9xdjtPvMWdM9mUREfz95+v3BI1ZVFXYB7hXbn8nL8UmIcj198/TBr/WCXLIf
	P/xWE3B+8ewryyyJY8zXpNm+fWb5+pXz5y/Gd49//v3P9lBw9RnuP3/+/fn7
	V9ruyZ0/D/78ZHz1/WZ16HOWLe9EfFQ1GbhY/t259/vBI059faDc+2dvnR0k
	ZaV5tz+o/v3/G9AxLAzs/OzCCxdHs3xwCvjx+9/hE2+V/vxk4RC9/JjXkPf9
	x+9/z2x/8PvPv7//giRtV9tc/H5Q79f5XXpzJzewyHy48+6/koapGMM7voeX
	Hgnzs/6RUuTi+ebqLCkvw7vlfqkBX+7/n83KDHmfbDfONKhiZGDo7Oxzfvr8
	M8jFf/7/+fP39+9/v8EkmP23hWORYunXG6XMk2Ryli+YyJKeb+TrpXDvwUcO
	DmYFWb7T516IiHLKiHMdO/1cQY734aPP/No698tOqEzkiHumYWVewzJz4hEp
	Sd4nTz8DDQPZ8BtkKtD1YC7IKpGYVzbt399/YZ4978q65d2Msamby/LNX7z+
	ysHOLC3Fc/Hya2FhTglRjrMXX8lI8Tx78ZmLg/Xv3rq3+uXiYty3bz8G+qEU
	EoUwEoj+YXD/gBGQwQAAJgkU3iaCHvIAAAAASUVORK5CYII=
}]

set flag(IRI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABVUlEQVQoz11P
	u05CURCcczkBlZioBYUIDVQW+gHW/oKFf0BHb/wH7CyNhbG2wVhqQ0FMSOxM
	8BGs1BARgvfs2R0LHkEnk9nX7CbrcAL8YAoD4kwXGWbq4THE0f4RADMzmJpG
	U2WMNqGIxkgRjaJydXrl4eHgeqM3o85NkRpUokqwICpBg2gorZaRwDcPmxvZ
	jbXsWm/U21zZfPl+2cqXnr6ftlaKz6PX0nKxO+iW8+XHr8ft9e3hwdCpqnMO
	AEkQBDlOeXdLI/f2uJTlDM65wWCQTL6d9ibx8oIf78x6np9xEYCZOVWdLkzv
	k6psNCjCep2ZzNyfJEm/388c53KoVtluIw3sdJim7HS4s0vvacZWi2nKVgvj
	MR4ehjfXLgUytZp1uwiBIhThPFnIoeoqlc/7e29A8pOiUKAIoiIKRJwIYsRE
	Y4QqVBGCAW4E2ALxt/w3AvALz3tDHh73Z68AAAAASUVORK5CYII=
}]

set flag(IRL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABFElEQVQYGWXB
	PWpVYRSF4fccPkGUVP6EBG0EJyJYOQAbS1s7BSGjyFTSZDBpLLyFYKVXPHx7
	7bW8ErG4eZ6FS9j4yyB273crK+Bb2h6/emnjiSe+z2DPxesLwAfx6ZPTZVkh
	B0CsfH6XVKx07T9cDQaQr7927T7Ya39y7yT//f6ZbzfJTNXy6LlhYOy0W251
	5S7N9EyKLsMAmlYkS1aOOTXjGRddwEDIXV1qycpdmsmMCskwEG3Jmp5q5Yid
	numZ1NJlGIhKzZ5qVU/HOVIzFK20BAOhVnVVV3XlmKMZCjduYLBR1tnDs+qS
	el1WYFkWbq2Dpy+g6cZtWPgEP0Cwwcb1x+vzB+e2JdnW9y/P3rw1mH/+AErD
	cqlo/C2bAAAAAElFTkSuQmCC
}]

set flag(IRQ) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABWklEQVQoz51Q
	sUoDQRCd1UODqIWYHIcGFK7R5iCYQr9AP0DUz0idPl8hltoHIWInarRNbBQl
	oBgjmIgmd0lud3bHuTtFBSsfw9sHO+/NzgqCb5jf+s8SkaFYZCJjgEtrQg0a
	CREQSSn6wX65bMVxRI9Nbo26lUr4sySzJClZi2yWJ1iQz9PSMqRtICCUoA1x
	vCZCFVVkRh5OMoR02lQqHKeNMaHBw/sKoh4i9pU8aZ6dPp0Hw2Fn0H3tv+9e
	7XV9PwiCVquVPAmOH46u3278sJuZmMukZi6fL6yR0XGR6oW9eqd+170lQzvu
	Nkdb8Qa0Mb8utVxzVnng1NjkSiZHBAvTWb7KzXr7twdbi5vcxwbheV6hUGi/
	tAUJpRRqZDbaKD5RadTMwoiBGti2XSqVrFqtVq1WG42GiiFjJCLiWCEqXs91
	XYh+CYCjHMeJ4jkfEyNrTJihvwD/wAd4jkJ+Fq2yhwAAAABJRU5ErkJggg==
}]

set flag(ISL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABYUlEQVQoz21R
	sWrUcRjL7/5/h9ap7VXhKLQ4uvgABXFXN8EX8AlcvB4FEScHQRwENxEHcRMn
	B/sIDuImOPQG0bYcHBSO70u+OJzn1AxZQhJCGm68xgr6+uBn112Tur2XCCKI
	BRGECARAIHoAzw72AVS5tTacHADt8MlN0SyTRVmlZKXqzfhdDwDwr7OFqgDw
	+Bjw9Pd50qkiFayUyBptrQHsUVWCqiTbNtN2sEinlKykgiWJMhBNUmsNgG0Y
	p/fvbb7/4IvQWpvP5+0HMBw/4nRq0pmViUxnVoYjK7MinCzGpd29b1+OmqRl
	vGEYp3dvb378dGHDYDCYzWZ9t/Ni8vTW9M95Um/H+xVp+87kKLkcUMliiazd
	q5c/P3/VY0GqlrLtirCdVPwzmNTSQAFgjwiqrmyskQLQj0YARsN1qpIlWRKr
	JMgFVEP3+P+RZ7PD7xtb109OtrcfAgHU6uBaMf4CWkFmlMpro3cAAAAASUVO
	RK5CYII=
}]

set flag(ISR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAFB
	SURBVHjaYnz58iUDEvgHBnAGEPz58wfIBZIQLkAAMbK7v5yUJwYU+vsfCBj+
	/gMqBZL///79D2T/+fv/D5D9B8j+/+fP/+70GwABxAi0QUxMDKQWDCCM/9gA
	IyPjtWvXAAKIBa4IWXXfkv///v8vjELRAHEnQACxQFwMVf2fYf7W/zce/+dn
	/S/B9D9v4n81mf+ZAQgNQJ8ABBATXDVY7H+A9f8/v//nhP338/v/+/f/GGcU
	K4CmAwQQExDDVQPByv3/f//5v2HD/96l/3///T93G5L6/0B//wEIIBa4Bog9
	KX4gduec/1ys/2cUg8IKWRaoGCCAoH5AC5zSJHjIIDRAPA0QQCzyLv9aGoGB
	zQAMbCAJjKU/fxn+/mUEkiDBv6CYAXKB8fDvP8OKmn8AAcR4+/Zt5IjEZCAD
	oEqAAAMAKQh5Em/pfi4AAAAASUVORK5CYII=
}]

set flag(ITA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAE2
	SURBVHjaYmSYyMDwgwEE/jEw/GF4mvT0HyqQUlX9B5aEIIAAYmH4wlDtWg1S
	DwT//0lKSv7/D+T9/w+nYmL+//79/88fIPll0yaAAGJhYAGJP/n69O+/v0CA
	UAcHt2////ULqJpRVhZoA0AAsQCtAZoMVP0HiP7+RlcNBEDVYA0Mv38DNQAE
	EMj8vwx//wCt/AdC/zEBkgagYoAAYgF6FGj277+///wlpAEoz8AAEEAgDX/B
	Zv/69wuoB48GRrCTAAKICajh9//fv/6CVP/++wu7BrDxQFf/YWAACCCwk0BK
	f0MQdg1/gBqAPv0L9ANAALEAY+33vz+S3JIgb/z5C45CBkZGRgY4UFICKQUj
	oJMAAoiRoZSB4RMojkHx/YPhbNVZoM3AOISQQPUK9vaQOIYAgAADAC5Wd4RR
	wnKfAAAAAElFTkSuQmCC
}]

set flag(IVB) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABxUlEQVQoz03R
	z0tUcRQF8Pueb2ae04wzopUTz2AWQxQDLoMp+rEJaSUE7WwRRH9AtJTWbloF
	bdyVYAQmUhCEFEXSD6JIMmcsQixCyppyfrx3z73320Ik4XA4i7P7eI8vTzzs
	HJm81bnSO1sMeeL32fHC+7HRfefuCBETbff/4Q1nJp/cq9FQlNRXvK2/Wory
	ewv339GHpU2wCgxiAgcRwObnbwRzfdfD1T2pN4/C5pa2O+mBQpf9U+1k4cux
	ZpKCgEUYKrGLohwRB3N+7eLBQ9k/YSte8/sG0uUDG582l+Nsh4nZVcYetJKM
	Z2ruV/PpOBH7X09c6OkvzqyXP3vRuvZPJ8d7qtWf6cGueMwGTQ6XM+dPHoXG
	gCPigF8tzlRGX9a977mcr7z4ov52ODtSIIk7zGEMlIdGnJdKICKOiP3pNf9b
	OyPSff2j+HxjkBn1lc3bz6gVB8ziFAtLd4WccwwokfhEAiizCQAGsyaJY1ZA
	mOXq6f2VfLrRmL12JnImRBwQiYgBCihgzLbzNsAaq2G1mDeT5Y+9DCGSgIgB
	K5WygImYiAIGqIgD9OZUTcSp+qqsKkTmEV0iinc4d6PuNt6OEfn/ACmtQ9bD
	5m1xAAAAAElFTkSuQmCC
}]

set flag(JAM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAByElEQVQoz1WR
	T0gTcBzF3/5EtZpmG4NyNYsyvYycEZF5SCIp81DQIUQooVMFHYPoEkg3b0XU
	IZiCB7FDl+gfHcpIzCLaIGxtFGg5so05a/u+7/e3DjOoxzu8y+fw3vPU3mGh
	jFMfMZ0HADjAAfqPBagAEbyPIxqA53QXkmNX123AdME9LrqSmsLMqdZUnSq5
	3qv9jTwc0l9F7u544J+YQvf92pHE/P49tt1r977zzbKxRjqSjAd4ISzRoMy+
	5tjTbUuAD8DezkOPXhTlt+1rYXfIfE4+rKhzHAjJ5agEybvjcv0OqxbMZrN+
	AGZWqerEE51N62AfT+5g+xqasS0gqbSMjHImJSQ3kwC8AFSNJMl0htduMvdV
	WoPS1iC5L3LpBmdSUpeqrgJmqqpCaY7IlbMS2yKZoswVqrGtMnyxuqt5FSAJ
	wA+ApKqc6NLB47I2yMl5ufWN4ng+LGcSHN0pI0nenlRTRb300Z6Oob6l/l7+
	JIdzksxL2Vg2eV5gqsTORjl2kPGYflpomvu86GlvxNTLoY2b+OoHx/O2KKxv
	qk7pqNQmn54LW2/ECnmL9aQ8K8+wUELiLZYz/78rf3MFUKAFDw+gtQF/ALzG
	Pha9rFgEAAAAAElFTkSuQmCC
}]

set flag(JOR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABKElEQVQoz5XO
	IUuDYRQF4PPNT5MgiGVhMN38A2urpqEgLAmCYBMsi4ZVi0XXbSsiCMIQYTiE
	hVXbfsBAmyBLg/fcc69BJ4YZfLhcTjjh4Br/kwXw3m73gbG7u0syk2TfSM4/
	yV6vlwPYQBy+vj1LN9KUlMQfiYkppUSyVCoByAGEB6QdaZMsN/bi+CgWybJs
	MpkUHICEWi3cy7ToP0a3G39w9wIAVKvRakW9HmRMp9HtxuXVgjpgZjmAGI+j
	04nhEEwReew34/RkwaQIAAUHgozBALPZZDXFbmNhG8DXpNyBJbMgn7bZaaxQ
	9+nhliLFpEQ3c1I0V2Vta3Q+yh34WLG7g+JLZbkoMzeKdJqbyRRGN0kKyQVD
	dgGcNYF1IM3PfgWbBwcMAD4BuIZbuSC3UW8AAAAASUVORK5CYII=
}]

set flag(JPN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAE2
	SURBVHjaYvz69SsDEvj37x+ERGbAwZ9//wACiAUoysXFBST///8P0QOm//+H
	U0jgxYsXAAHEAlP0H8HYt+//4SP/f//6b2b238sLrpqRkRFoCUAAsaCrXrv2
	/8KF///8+f/r9//Dh/8/ffI/OQWiAeJCgABigrseJPT27f/Vq////v3/1y8o
	Wrzk/+PHcEv+/PkDEEBMEM/B3fj/40eo0t9g8suX/w8f/odZAVQMEEAsQAzj
	/2cQFf3PxARWCrYEaBXQLCkpqB/+/wcqBgggJrjxQPX/hYX/+/v///kLqhpI
	Bgf/l5ODhxiQBAggFriToDoTEv5zcf3ftQuk2s7uf0wM3MdAAPQDQAAxvn37
	lo+PDy4KZUDcycj4/z9CBojv3r0LEEAgG969eweLSBDEBSCWAAQYACaTbJ/k
	uok9AAAAAElFTkSuQmCC
}]

set flag(KAZ) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABkklEQVQYGQXB
	T2jPcRzH8df3+/tqtR/b7MASaxqpZaWQy4py0MptHDhSuMhRnNzcltppRQnl
	4pebtOin/CsnOZBmXGaFfrZp8vt9P+/P8+XxKBptf1ExUblfCrEeUkhIgUCg
	QCUKFKhW0Wh7de/sikafaSZbWFkCKnd7NLqqMs447GTferNRSVrRrntpprRA
	YYe9k88H3O6w9blPbtCXceDtfYVqSkmST3k+o56djUmHvDDF46O0jvDkH044
	2YEFZRYj/vqQi2EXTiXdpjsTfmX1BrR80E+brCWcssNWrVLIzqc9V9uD/Oin
	s4937/NhR70aQx9j/2R+nXDCkaWgUui7R+/7LPgPzREvTfrFI84tsvsXw2sM
	HPeDBU4EDqygVGDnM8yCOt6yTvNbHp/2nSm3xvzhsq90GA4cKNsiKokdLF7l
	hnC2ltjzifHN/Jz23SGW5/P1lz5W4EDZEqoU4HRp0+2WzwcKK6Fg21tfAFY9
	OIazi4yzpaBQ6+/NGLhW/lagQLVUo0CBAoEClUioK5X6D79pWnPKXqElAAAA
	AElFTkSuQmCC
}]

set flag(KEN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABeklEQVQoz5WO
	P09TYRyFz3t70UJqdLHqUkg3Q5j0U/gRymBgRcNsGmUiYXdnYnGtiwvRgaXu
	RG8bY3JvA9II0qCXe9/z++NCE1efnOFJnuUA/0kA0O/3AdgcVSUpIqLqqlVd
	C0kRkoPBIAEA+GQyKYoiz/P89LS3vt6ezR5c/NrY3PxWFOPxOBuNsiwjCSAc
	D4fdtTU38znldGoHBxCxXm+p3b4JZknaOBq8D2fAndc7OjlxERdCZKf6sx3S
	BdU3s4vd2qyqPUZXTZc7o8MPaQk0y0qvfruIRyYm57zWhaZTp+W1Rvc6WqRL
	RFVHIL0FJElACBbgIQQPl0J4I1FtqQWKMYICtaAGIBx/+dhdeaqqN1fdLn/k
	eLufiNZbz+896ribu5t52kg/Hb0LeIUXz15+vcqopMVoftsWn4wZIg+7PNef
	0UpRiunq3cef94YpKohwpdmhUkxopPH7qtD4UOW+tdxBE3UxNVQI2AYqQIA4
	n/wjMhcDBGjhL1tiPSuoLxxPAAAAAElFTkSuQmCC
}]

set flag(KGZ) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABKklEQVQoz21R
	MWqVYRCc78sTKwkGLAK+RhuDheI5cqPcxMoz5AKWYhHBwlqESIJdIIG8mdkd
	i/9/iYXLsmyxuzOzM27wGL2v/zYPaQDABsDTszMA6UY3quJCOXbsSLEhtR3p
	z/n5BgCQvvyNqlRFwpMaW2Gov6tvFbHJSHO7NbBpIJ3H6VGbU84PRmmccPeJ
	faeQkSI1MAGg6gF9vuF4LX+lv3C84sEJQ4YrSAOzAbiWA6HGC+WAuWZdsQfz
	ck+JjO0FIYtEMWL9Iu6YQ+Jol1v25W6dJlvCqkFaDoD0N423nO+VUv2gPis7
	Rmp72r0uLAJWVrz/yPlOuacv1DcK2RZcqdp/SR7Hx0OKq60h5adiz+caz9z2
	XH5YBWBcAd4b2f9zd3F9sXkCfwH251SCGplr/wAAAABJRU5ErkJggg==
}]

set flag(KIR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAB7klEQVQYGQXB
	S0hUYRgG4PecuZiDUwgxkeamKFwUhFRUULRoqs2AOnajIJmI0CBypaAURRAR
	MhR2Iyw3Qi66LUJIMg0kKl1EUUQ6Vji2USen0XPO/3+XnseZAgQA4AICACAA
	AAAfACCAAAQQACDsAquvdwGAqrKoELsaPRZTkPeoEFoyyiREagO19kffizAA
	QOlPHipKrEQg8m65BHJnS5atWKvWSOCHqmoEcAEoK0SUWImUiNm6TdFIY4TZ
	iDFqAzFGbCBkCXDDgOtAAyMmULIaBE6mXKtJqinUUq6eJ4Fhb1l8AyIBnG/d
	N2r4b1kyJaV/S709sfarsiamfgez5eB8pBhfvNAczz7Usqh3rWNsQZxLnf1t
	rfsfvPFTu1YlZL7vrS2YUGt9lJk77xXDMJcbV1x8ZuaK3HOmsuFE1um+PxSu
	2JjcWTk1s/z6Q6E5tVZUbg/MCMvZdNXnydLg2FzbyRpheTI8n//+ysGGm7mR
	TO/z2eOHErm8N/x+3lrJNFSJaM/j38Ry7vC6r9OlwbG5jsz6vfVZJ90ysG/P
	ji2bKj5+KRJLXW1cRN59WiSWIwcS03lvdKKwe+tKFYxOLNzpuuKgrD3ZVDvU
	/3N7KiGCiZc5wJxu2+z7pv/uOEDpU3VPR2b1V+7g0W3jk7H/tRQ4p4KlUZ8A
	AAAASUVORK5CYII=
}]

set flag(KOR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABw0lEQVQoz2P8
	+P0rAxL49+8fmISwoBgG/gAxE1Caj4MLiJ49eHT1/EXW/4x8HNwCXFz83NyC
	3LyczMyXz5x9fPeuKD+/mIAQUAMLxODXr19v3br1w/sPImJiyoqK/+/e/f/n
	z38VlWcvXq5du0ZAUFBYSEhGVvYPxIb///9/+PDh9+/fhibGylKS/3t7/xcU
	/M/L+V9XrSAm6ubl9ebNm+cvXgCVAW1gBPqBl50TqO3Vq1dcvLyMew5wTJ34
	//fvL3+Yfv78JZAQ8Ski8uPrN1LSUoyMjA+ePWGB+BKoW0REBMjY+YbP+A/z
	bybOJsP8Zz/Zqx+f02dn55aWAipgYGQEOgmoAaQaCN6+fcvDzfVVXTdXvZKZ
	jfURu9iHHz/vGrupf//85u1HSUlJRqAekB/+/QOqvnnz5rRp04D+9jDgVLVQ
	ecIsxPD9h7MOm6uT9L59++vr60+ePAnxA8s/cChxcXEB+QcPHdbU0qwNU7tk
	wv7n739dBfZ7926uXrNeWFhYQEAAqADiJJAN0tLS7u7uL1++FBOTBOrXU+KC
	uFNcXMrDwwOoQV1dHRyvDIzP375Fjkg4xfAHzGCAsP/8AasGYgCFMRk3LYUn
	aAAAAABJRU5ErkJggg==
}]

set flag(KSA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABc0lEQVQoz32R
	vWpUcRTE535ks5vAInGLgDFGQmqtVRRsfYtUfjR5BH2G1IKd0bxAKpsQLFQE
	hVsIG7tV2BXW5CZ77zkz529horFximGaHwMzGR7grwIgQMDO3YDmQmhQAnj2
	8GkCEoKiQhHBIEVKDHe6Qgq5/PWj3RJAAkY/RxGRIwfSaXtqtLmy47SZNQnp
	pK3r5nhl6SqAEoGUUsvm1vU765c3jpujd1/f31y90ck7RZYfDA/ubtz7PPr0
	4u1zp58BDFJy+tFs2p3rrVy60it6h+PDlu10Nv1RTwoUJrocQA6DQpQPFgdr
	g7VxPamtrr5X3c589a3qFgvD8XCv2pNI8axBwZSw+/FVljIGTWZuJBu2eZZP
	Tiakp0jngIGiy83bzdubC+ViSunPVv35vsuf7Dxu1TIuAnQGt99sMxQKkznd
	ZFv3t/a/7Lv899AASjTw4HJ/meFOUu5yih5OcefDS1GrS9cYjAgAGdb/ORIt
	/q9fMHo3F4nnAQ0AAAAASUVORK5CYII=
}]

set flag(KUW) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABJklEQVQoz31R
	P0odcRic3awi8WHxTMQnSBpPEN4BvISeIZ1t4J3APuoNcoBX5AYewNrWtCEQ
	keU3f74U65Y6TDEMH3wzTAcA18AeMAIjoJmZRZspQBgAbLLBV+Rjwris2JFK
	ihTSUsiI5vZmOwDAcz39/O1z+9A0HTNkSJNmc2tpNE8XpxgxAEjK/6xfvry6
	OPh84DiJy6kkdmVy9nf2d7/tDgBsS9Ko9XJ9sjqpN9B13XqxHgBIJikpSL0N
	dF2SHsD0oLG53gOqkgwASLbWCtL9fZZLe8rvsqcWSCrpF4vnu7spkgbw+wu/
	3N6+tFatFVmthXwVIuQPZ2d/Hx4GAOn049PqmBzlXqzpTurJaYzehl12D3QA
	HoEj4A+QeV/MYnIwmwD+A51oZSkrOm7nAAAAAElFTkSuQmCC
}]

set flag(LAO) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABZklEQVQoz2WR
	vWqUYRCFz/vtZ4RFTUxcFdQUbpne1k5IoRaprERIY7edhAi5BgnY2go2snfg
	fZgiIvnBaDSJZL93zjljsRhWnGJ4DoeBgacI/4wB/4WLOMtFQNncBJA27JRA
	QQSZZEZcbEScjcftqPd0bfDg5PA4ZcuWaieGRKUIWaRIBudvL25h3G7fH91b
	HO6ro1NCV7U03z57NMjMd+P9nb1JASoV9J0bl3fwpgEdQnUJlQldmvLq+d2V
	YX9l2N94sTw315zV7Fg6ls4FqA2qlTAlKjotXGmu9nuZmZnXr/VuLfTqeTDI
	ICWADWjJ1ajKMA6+x8lvTg+OfsXuQUegY1YmIwG2qKQywlTaOD7nxtvd9Sc3
	AWx/2Dv8yaag0qKVBlwe4+H61ssfX78pJIrBOpn+IIWblCiJopeWB6OPr9v3
	+HTpyxCMjEgqGXDYkcnMSBIkJEv4rFWgnP4nlTM8rTjj/g9Gz0Rs5+L2RgAA
	AABJRU5ErkJggg==
}]

set flag(LAT) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABGklEQVQoz3WR
	MWpCURBF75OHQhRSC2rhXtJkKfYhhQtInTLbcBNi87dgCEkRSKGSgMydO5Pi
	/y+myDBc7oOZN8Oc8gyc0UUA3ut1Wq8DoH4Dd+s1gIzIiJTCFfJ0D/cg5R5k
	uIt82WxqBYD8ef9IKaQgWxUZpIyihZnI8XweQD0DHsnrajO5h1E00WSUmcgh
	eQLK5243WSxklpmISCDa3TI7E92jDoev222RVErJzMwEkP9HGQyOh0P9aprx
	bCYzdH9mXib0vh1VR6O33a48Aver1XG/D3eZBbuNdTFm7ZVul8unpqkBhHuS
	0aZZmAWZZklma5zpSglANSDpN9NpkOGS9509hHSX1B7dgfIAnHqQdgXV/mJu
	8U+AX3wogUnxxsC4AAAAAElFTkSuQmCC
}]

set flag(LBA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAA3ElEQVQoz1VR
	223DQAxjAH+kE7RARul0QaboAP3IYpmhEB/qh2zHPgiCdEeKPOiCH5yOgADa
	Yup65wXA4/vRQOB03E6iSC21FCliKIvN5+9zAdDo19/LsduDGNBEhXQxvH3c
	VoV0HM88xwwVlYtNhjRpVkotFBYEhsfDoFdQyFRtdbloQkOI1WLkaIOyUjQr
	ZGouHaOwQHBrbOzo8XAky2K4EmTT3D866rsIm/MqCxlC62T9ML5ChTIZuw1h
	gcDw8/rliJHylpJlSLYit91GcMH9tMg1T5FDOysH/gF/KJDzTQ98HgAAAABJ
	RU5ErkJggg==
}]

set flag(LBR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAFk
	SURBVHjaYmRgiGZAgH/nGZaDKAaGP2DyHxIbQgIEEFA2evPWy9+//9q85XJr
	+45///79/QtEf/+Awe/fv3/9+vXz588fP358//799c3rAAHEAtTh4qTOzs5i
	Y620Y+fV59XF///8AaJ/QPL37/9/gezf/4CM379ZJCQvTJwFEEAgDXv23LSx
	Udq46dLvP38lWnr+4wCMjIxmKdkAAQTU8OfilSfbd14BGvr3z99nxdkgs0Gm
	wsz+CzT+z7/fv1glZU7PWgQQQIy/375mFhSGmAG07T9uwMjE9PbGDYAAYrkk
	LCrT1/b72TOQeSB3A10PcjHQbDADaC+Y++cPq7TMyYWrAQKI8fvrl6xgG/Ab
	D5QF+uHFjWsAAcRySVRcvq3+59MnYGMglvz6B3I02AaIf0DkX3Y5uWPLNwIE
	EOPX50/ZRMTQ/IBhG0gAiJ9fvQwQQCznJKX/oEbnH9SoRWYAAUCAAQBu0mcN
	l6fCkgAAAABJRU5ErkJggg==
}]

set flag(LCA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABlUlEQVQYGQXB
	PWuTYRQG4Pt5ktSYWsGKiIO2IBRr0UVcinMEBd2kg+BQ3Rz9FS6dBBUHRZ1c
	HKxxKDg4Ceoi+AcUhEIwefPx5n3OOfftdaV7j5tqmlotAKAUDgDVPJVQt0M3
	NM6QnGpMvY7ao0m6c0MACElgaDzGxcsZ0o/v7C3LXREKIqg3HybtpTYADCvS
	QQelwzptl9ES9Ht0bGUic4aDodWTCVAWQIiOcIQ0m6XNfv76/tXg9ZOt2615
	xXC4w4kwQcqUJIQjKBLTmhtdfNwfDA4+b3ZULVK4zFVMQYHI5ohQUJQWC3XP
	pX+/bFxKbWX0szmyhsUCFrIiNwDKJChQMlcz1/qV/Onlu7375fnD5u3ei/PX
	UmMKEyl3AcrhCqqYwlBnHX6zC0efXrpVNm7a9ulnwy8+dZEyQ1AQs1FhIuWB
	UZO2emV3p9bfoj/Ng7vl6qmqcpgrQqQAtGc1nDpxHLVpfQX9tV3NzyYzwLFs
	11d3Ds7sZ0stiQFAqf9oNpyBorlIA2ZAhggCEOBAgoBEMKHF/zWAVbgb7FYW
	AAAAAElFTkSuQmCC
}]

set flag(LES) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABvElEQVQYGU3B
	z0vTcRgH8Pdn+1izbBn2Y5ljEaJCREE38SB0qkv3wP6IDhGdutdFcHTxEIFd
	OiYEHcKQtEaESTiT0vkDZ982t9Z33+37PM/n+TSCQa+XqVar6FJVAKoKQLtE
	RP/ZOWzceLBgAYT7hbO56+o42PmUvXLLmCTgOwD4rvz77Q8lxsK6BZAZHl9f
	nOU4GsheNSYB+P+FMd95sbpfC4f6e5GwFqobS3O18qZ616wH2cs3YYzv+rJ3
	eG9+oxa2WcFEGH5qo0bgvZ7JXYv+BNwKhdvJnpT3vkV8/9VaYa9JTBQLn5zj
	TA1DSBzpOz0yPlXZXW0EW6MTd5P2qPe+WK7ffvb5Y6keE1E7pguPKL0stoE2
	LICf35dODY4Bplx8e2zi0sP54vJ2vRULq6HoB1/MU7LCjjtAsKo6ODp5fmzS
	eK2G8dTzQqnO7BNMMQ3McuYrJUImFhWnAoFVVZPs8aqv1w4eL+622kIKbm5S
	boZthZSZSJRFnaiDwKrqrzCafrdV+i3nTvRKynHfS059E9PP7rg4ES+uwzun
	DgT75M3K9MwKDhrooAgjeaQBC0SAAAIQIIACAqTxFx1tUOIeIM3mAAAAAElF
	TkSuQmCC
}]

set flag(LIB) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABUElEQVQoz1VR
	vUoeARCcPQ/tRDu5iILPoOYt8gwJMVY+QXwAbUVrIXU6LaIhpLIIEpD4RUyh
	RJTEDwsb8TPf7exOiuNOXZZhFmaW/bHfeIxssSFsebacQAlgan0VgDKRqQhF
	iFQQpOgiky4S9J8fdkoAKMu4/oukGAqq1Ymu2tNdrFV7UU0nUI5eXY1VFQBI
	kgC7ub/ZPtz+N3x48/JtNV4pU5IkM4wuHRUoCpjBTGawQob98y/H/d73/tHe
	2b4rBbRpzCwys+0uQcf93ufTvduH29qHu72dX/0TdQFkY+jUKW0dbIZCCQ+v
	w9e+rrPTSyTLztCssfFq48/d9fLHpVC8m3+9MLMY6YaRZgoAdgq8eL8Slxdi
	ne5yz3ooOuuhkSLlFF3Bcnbu26fDkoAGA5uYBL1giG7uohfOpKO5coQYuh8A
	sB/PH5lPHtyVaBHAfxBTROZGdvt8AAAAAElFTkSuQmCC
}]

set flag(LIE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABVklEQVQoz2WM
	MWqUYRiE5//20xAli0ZYCLJCIgYsAkLK3MAjCN7CCwh6iTQpxUrSBbXwAIKF
	GJBYxEZRgmBgl+Sdmfe12KRQ4WGYgYcZMH2BBBqABgESYkHCCQgQEJdFHcLT
	59t3Vn/evfXtwfTL+6/rh9/Xj09WpVKWlHJKSaWcL5/tdzQA9XBzf6mfNcXO
	9GhjvPLk42My6aRMJZWkb0+WATUAWTj4tHX96nxpdCbr1YdtcqE6lEEHHUop
	gejIxhzeft56c7gp57mvUAibhogQ6CEECucG0Pr904N78/GN2W+pLFu0JKVo
	0pJNSZY8uXbzNXb7u9neyq8xfhyXo6gii/F/pjhqG48w63Ng2dTCViRZihRL
	TEWRpSixpJF1AnQAJRWZ5MUZo8i8+GYxSky72Qn0BEoaJmtNhJzkYCbZpBQh
	lZTpZsNOYDgCBORl4u/5DwD+AH37YQHmFNV7AAAAAElFTkSuQmCC
}]

set flag(LTU) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABIElEQVQoz1WN
	MU6cUQyE518eQjShBgpOgOi4QSROxAWi3CNtijSp03ACRKJUVFAgBaVCK4E8
	45kUb1mCZY0+22N74W9A2IYFAzDgDVuvLHiFAWF19AlA0oh30DsxomzTQpgI
	5tOvr2OsgAXRw5KePqTnGJlZMWMuu8cAxs81jkosJj1P2kw0TU55gmt3r64f
	Mc5+4PLj8/16rZYsmjTZLJNd1cXm1JMPB1dfMPACudmUJYvNcrFJs7qq39bU
	whoDQEeKyqWeH6q8WSsXJ4cMAYxvn3EaPt+Vqai6aE0bzdpoM9T+ib7fYJwD
	B3/VfxjSZKpStYFtR4x67PcFMApoKoeHIaGOGBIkJJCLBCndS7e6X4DlFhDg
	V/X7Ev/1DayAfyUid0Oi1K3gAAAAAElFTkSuQmCC
}]

set flag(LUX) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABGklEQVQoz32P
	MUqDURCE5yWvUETjD2IEQUERbKy9hZV4EgttAxaewnPoCSw8hpW/gagRw3s7
	MxZ/TBp1WIZvh2Vhkk9P8D4BAEASSiBmKKFSVKoKVCEsJ2PyiusRAEvJQtAW
	yET1yV5UkyYd1eR0dJsxK6jF7QtEUI4Aw6SDjuoajuqorjUNdwRknJ374Ahb
	26BsgjLpuYdJi44wicFA+8M0Ho+bpgFgG4bhv5RSats2d3W7aAG/CilJysuj
	///byZaULx83Lo49+TIF2pQph7zgro6EZtVX9/1896TDzf7zhysRcqUrHXSV
	YwFyCHvreHtABtRDb3cNYQdBgUJV6iDUJYm2BGSldPPpqRBCEYoQQPlZpTmr
	c2AF3+HEeWtfY7YNAAAAAElFTkSuQmCC
}]

set flag(MAC) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABj0lEQVQoz02R
	MWtTcRTFz3v+CZQXaeoSGoliJlts1aVLqZP9CN0EQRRBQQSjgt38Burk7GqH
	dujkIkjBSRdXoWrqEEig5JH37j33XocY6Bl+nOXAgV+GN0CF/3GAc8q8zPqM
	CQkT7G7vAvBwD7cw0rKcACc1GapOuqpTTQ/eHyQkAPGnHFiYmXlokcxC77az
	d8flhHpai4SoabfZhSOHwz3MjW4eeq+TlypFuvS5vClORP20C6EIRU0hyAEY
	jEGaRvDD33Jc8/bF7f76C7GCLm9/T4QiJuqzAUE3NVXXO22strYeXL2/2lpB
	xLP1Jw9XXo0rvLyciwmNIM7hFjZ6G6N6JC5fx/L42qPN9mYjb5yUJ9cv3Djf
	aC41Wq9/fNLQxcbi4MsggdBQMaFTTfpH/YW0ULOecpqyNKpGw+lQXek0J4gE
	gsbZJTWdarVzZadTdNaW1g5/HX4bft/7+ZGhdKMbiIQK6lwultWUbqTuH++7
	O52VVXT2Wj0zszBzgyDDc+B0LlLmUqszpuWM/ib+Ab9BPtHvLCFuAAAAAElF
	TkSuQmCC
}]

set flag(MAD) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABAElEQVQoz3WO
	PU5CARCE58lLiAlGEgoqGhsu5Dk8hVyIQ1h4DUQSMaGQhp3ZWYv3g8a42Uy2
	+GZmm9PphGFszxeL/v5nWwDz+RxAVQHAZlPHT6QaaSLdkCXVoOfttu3yehqo
	/R6HQ5H9BotREUU2q1XfcKWrIFVEST3KqGBnAGmgtX2lCxX6mz0aMBqqqus5
	TnmehcUizTBpRjFSnN7rZXyp+nw8PfL9K6IYk2AyHExGBs2HO75e0Noe46sq
	FRcGzV90UlZOhI8fL3U65g1KZsiUU05oaBg9y9ul0yzKoqmUSpmZlelEoNnt
	drZtS7K9fl7jDTBwAwgQEIAAAwJm+AYksGMfhq67xAAAAABJRU5ErkJggg==
}]

set flag(MAR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAA7ElEQVQoz31R
	MUoEQRCsORe5L5ywqWBiYuDj7lf3jENDQQMzzQ3uELuquwxmj90FsSmKYaaL
	rqluxly1Pv+JZgD7PQBXoQqZViJlCZJJL/h0OAwAAPvjE5nINNl5QtAMR5hs
	41jAAMDlVXdESSYRYYaDXQCygKGAlgnJEiiL3+bzPUt8OMb1T5izAMAGALTw
	QL7fxHkbp228jpfuDuliKWXJDFAmb9/iy0zF3Qu9mNBmS6QjIPWHDePxiSaL
	Cz+SJXXBVf/iFMuUiSPmGxFKZKILNhR2O5NQQgTZSEjoLPUMkVlAO68X+c+O
	e/0C+ctawEbwXw8AAAAASUVORK5CYII=
}]

set flag(MAS) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABl0lEQVQoz02R
	OywEQRzGvzHr7HEeJzRcCBEakSh0EpSuUkmohN6KgkSpUmiEEBGJQoGGENEQ
	1Umu8khELrg7wp1X4xHszuyM2Vkn/pl8+eb1yzf/IUA8HDzZXp0GEO0ffbdb
	AKFGHB1lvgP4PyXh4OJNiqrTh7Gm5qbbQMDe3G29TJZPTVYUUFcCUgiZq49M
	xhgb3gZ6juKlbS1HocJPCDfalR056H0ZHDJhS8YlcwRj0nFopPpqbd2AV+Lh
	MdRYnxcy+ecXldJlDGVL8yblUmq8FkJpgzVCiujCU1ZINzs1Gx3oPYTk8yvt
	x2dVy4HxIGzBucYzyRmNRC62tggQm5sp6u7cU2Brok9FcHSEnY3KIHU0XvPV
	cyl9TSZJHKixxu30LRgT3CMpnnCYyd6IWSDVorqtNb+29nx/n7DsPSkuka4L
	id+wfmgF9tla1R4xjJfra5IAKi2Lp9MeiXMP5mfSnfGm/qLrBurqTmMx8pVK
	GeHwLybXdSj9+wFtoHefEwnDech8390JVaohauQM1x7+nPtG5AE/uhZa2ZoS
	qSMAAAAASUVORK5CYII=
}]

set flag(MAW) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABNElEQVQoz22M
	IWvWYQDE768vKhqGY2XCTMYFQaw2wb6mXfwCphc0GQSbwew3kPkFRBCsBoNJ
	1IlVTPN+d89jeB0M9DiOX7i7Rf/ovPRAGtJz/UeLpPV6LWmMMcfYb2+mb5qZ
	7Ccf4V1iIAEODw9XkqR5dPS97e12H160j0DwBA7Me/zJBvb29iSdkbQ15nZ7
	q70BL9u79hf4bA7st/y+b+/YO/Y2SFpVWlolM5nkaTAMmGbB123BK3vCAs+k
	lSSlE2YisoRz9oQJcwP2BpSMzWB2c2+RCRNPn2qf5AJDWp29p8d3+PrTaagb
	qAmU1BTqDGiuXs7rD1rpin5cyrdCoXjYNcU1A4+/g7Taqq5ppWOR7F7YpWQ0
	hQGDjDBIk5m2nW2qYy16KP2SIvnEOQU5gSFFuqg/jqNd29pTLggAAAAASUVO
	RK5CYII=
}]

set flag(MDA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABW0lEQVQozz2Q
	u2pVYRSEZ++zTzTeQIIQIl664Bv4AsHCdGmigpa2AUtbGysfQHuxsbKLaLCx
	tROsBI1gJKJED8k/s2YszjbDx1SzZmB1WNzGsYT6tIYB+AUbPgUbH1ZhQBh9
	APDoySqAMmx0Sw+T4Cy71CQHfaZXthQxJVMfnz0fACDY/cGqVCX6gunBq5en
	Xby5Pkt49JkhQw4rFxvQwyhjnlYFqb3dunpp1g759dvfpIXNIzLQQ3CgisqU
	E+68Xjz/tF1/M9vZXoibG91atRZRwICyFM1dTljVnbnRYup7HzdTJkP+P4DK
	Jq2K6LhJ3cbbx6TvXNtKOKZJSwYGwJKpUC46aZu32I4elNrde39ipimiyajG
	BRYozytiZvh5e4N2S8f4pDl/a7nGBUleXppKYRmTFfjC5Bx7K/mNyYmFy5Uq
	V6HKQAe8AHTM/vv77uFD2CPv1mCMAPgHcLpkVbQJKU4AAAAASUVORK5CYII=
}]

set flag(MDV) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABTklEQVQoz2WR
	PWtUYRSE517vJiaFqIUQJaCIVouVCNoHO/+FrQiWKWOprf9Ci9iLZTo7CYiN
	aJVGEdx93/k4FruRBQ9TnNOcmeEZzoAAwXr+7flPAgBMAC4dHgJAgqTskmGV
	FAkkpJCWQH47Pp4AAOXvP9pWJSmqrLCXVFSRxV6tb/9cjPv7AqYAlRLy5uXd
	5SwlLWt5a7o535q//f2upfXRw6IfPTm5SAYYA8AuyWHM5uWN8frjnYMrw+UH
	W/dj2qSZzpBadSgZosuKmxd3tm+r/Prs1QwzlxXBrN5LWjuUVSRLhDPgM09R
	eHb1+cPdR63UBnUo7Fg5BCgypEzDo/Klnb7vnu/c+/jrQ9JjwywyUs4j6cKi
	v3j6KezVGfb0k6KOqGILWeL0p5cNYBJQ1LC3t0tCjgiu/9UKglR2v2bbAoav
	5xS1QTQb56ZG4C9pvUswQ3aebwAAAABJRU5ErkJggg==
}]

set flag(MEX) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABb0lEQVQYGUXB
	wYrNYRgG8Of75j8nIZ2ZCaGZmhVlwcaGzsZsuARJbsDCLVhY2ChbCzdgr1iI
	hZISUzakQ8mUiZJOHO/7vM9jjIXfr+HqPvQB/5Bfbk87uiQAkjifb6+vAyAg
	QMAA9BuXbwFNqqhcXlrprQPeAcCZi9euQ1bRme/u3R2ww9j6sV2qXxm20fyf
	HNOPtpy5cPSIgAGQrJKoomh4x/TNE0mrJ84t2MqAJLIzCXSIZdHFqiza/vT2
	+dcPr+/fufn+1UMDjlCmIpUUMCCiJBazyCrbo/GhWT+wd+3k+NhxSyZVEmmS
	QAdNVRazGErbj18++7xneen0qUcvnspWhDLNNBNAB0GRxSxGhuHzZzY0+8aq
	jbMXbFekMxVpFoEBgWJlMSujaHl5fPDSxSvepQhn2LDKJQIDAike3r+SlT/z
	d2sNQGsNu1rvi2urACyLKaBhAhCYAwK+Y/PB5qiPSGpXzGZbk0kHiL868Af6
	o1TwHvc2PwAAAABJRU5ErkJggg==
}]

set flag(MGL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABHklEQVQoz12R
	sWqVQRSEv/3vHxSxiCSFUdKIknfIO1iFQArfJPggvkZewN7WwsJKREEQQbwJ
	yc7sTor9b+7FwxR7DjNn5rAlbKvDil9wuOk63FzzrG+aDjPA5SWn5FMvt/19
	f/pPpbXYxV6hx3t+Fyl2pPXV1QxAcvSD340/7bvbX0dakNq7vqbWSOX4uMME
	5G3Yb1y0SDK1RorqoPXUukDqMHcoHxtvnC9msm+X3UOWmgcpEsOB8xaUM+VQ
	2q570GxG9nJ0ivPamSuy1Ad1sNlxKNtIXXEFp9Zac3e3TcVwkLBjewhWzfkp
	HinWf3kWgYUbrTEE0wezPsosaC9eTk+EVGwkiqfiV7Q20KFc7/xihwM+w/Od
	wfobJ+M16h6eGU4SHktdqAAAAABJRU5ErkJggg==
}]

set flag(MHL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABzUlEQVQoz2WM
	P2hTURjFz3vvJmm0oW1ii520tqRqQWopkap1yWAHhQ469Q8K3VzFRXAqzuLi
	4qROOog6GEqF0liMmUoNsUNIJWopJjY0mry8e7/vuw5KKXj4cfgt5ziI3sV+
	hKAFloB99IGWC3ilACw+vDo23BuLhlbXt3/5htmSCLMQiSEOGNogqb5d61zr
	vwMF4Gj80NTFAWtRKNU+lX8yCbEYEkPSMl6UG7OdK9Md+dCRY405KEAiYQ+A
	4yAc9v6+MtuWcbRBKlS42ZUZjO3ZobSdXJDrjxU0lb43XmQ2u2PhXGHHEGuy
	beMl7I+Zw++m4iU7PGFT87bvZGCdxQfLCiyttnmZLRuyROwHDrGk1dp8It87
	ctqef2TjpyrV4M3zjY1S7dn92wogFjFGDIvvu/3261xPbnI0ZlP3/J7xD8Xd
	t0/fr+QrO9XfJ47HAa0AYpaWcZVuTsfWZ89yZGym7J5Z+lhdymaKW7XAN9Zz
	vLDnOgBIAdpv26RbuTFeS46ey+uR15laNr9crzeNBWBd5RoWIhaWf4MrA/Xk
	pcGiP/FktblV2TSB7uuOJroihkSYjYCIhZnEAuRcTt/KbXfsfW4DXwD9H3JA
	CMAf5ecf9j6ovQkAAAAASUVORK5CYII=
}]

set flag(MKD) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABiElEQVQozz3J
	PUiWYRiG4fP1e9vCpqAiJQpC+gENnGyoraGfKYiWmqwxajGCoFGniIYmCQKp
	KcqtoqXBisihJSz74cOhwETy07qv+3muFgnO6Tix8SUMhvK/LuryFzagB79h
	FVZGWF6hZQJu3+AqflyblUopzkJk02RnPPtCzvRW+UJ6SGunn7ZMwg57dInz
	hZnid6IUL8qt/FkOeTh8ObygZnqgvqIF/NPcK+wrPia2FT8Lz6eRCZ8IH5An
	w2/EoCq0dZRmsPAnvZgspA/KR+RRucrL4V/hKXk9vEsMiRe0vAaK1+W15Hv6
	vUx4TLb8IdyTb4b3hvtFf9brtBzFF9Mf0z+CjfSQ3AnPyQ5/k9fDj2SHt6s5
	rHqHts7RjMhfg4H02fAX+UlYsuWX4ZPylfADMZ9ezYS2Qqc/PS4OydPy83CE
	h+Ut4Yfyffl4eEq8LcwWoK2n6JtIujt9VywVdgup2S/6kj1CyafkVuFa4Uyp
	AzS9HvUcdZYKFYAKdY5aqWObuLk6sMA/749Eh3/IgcAAAAAASUVORK5CYII=
}]

set flag(MLI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABCUlEQVQoz22R
	sW0VARBE3/kfQgICp0aysGiDmC6gBxJHboGEVlwADUAHhOAGkJG+dmZnCe7w
	N4jVS9/MSLvwCY4ABMz3D7x8BpCQkK/kDeHEyj03b2+AJJmcP21o8LL4cPDZ
	K807jzT2SPe3tysrMD9+3XW6uzvi0DPaKc23mqqRlsvLwEpIptNOu5XpmZrx
	jGZqUlPaBKTACjTtsWPHp+z/CcCKcVot94NQJ2E0tU/CziZ07LhS7sdCzehx
	w7JPMhpVl9vqyj8N0UP82N4ntdXamKm/GzRVY+GmG1g5ovji+YVadp8tAi2L
	wCCemNemeyOwcA0/wXCEI18+cvXiz5tDPpP3+4+3+w1jNHIyxTHacQAAAABJ
	RU5ErkJggg==
}]

set flag(MLT) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAE2
	SURBVHjaYvz48SPDv38MTEwMSODfmzc8ysr/gAwMBBBALEDAysJy8+ZNbW0t
	BkaQtv//GRhYWP4XFTF//sz0+/f/P3/+w8gvmzYBBBDLvz9/7ty/9+rZsz+/
	f+sbGv4HKWf4//fv/wcP/n/48P/X7/+/f/3/9QuomlFWFmgDQACxMLGwaGho
	fv7yFaEaCP79AykCqfsF0gPWwPD7N1ADQACx/AN7wNTMDKQaDKHg92+YHoQG
	oHEAAQTWwABVBWeAALJqiIY/f4BKAQIIpAGqAsV8mAYkGxjBTgIIIBbsxv/7
	D1cHNx4YUH8YGAACCOEkFA3//6EY/weo4S/D379ANQABxIKsGh5xjMzMDDIy
	DLy8QINB6O9fCAKaDRBAIBvevHnzDwaA1oKoV6/4tmxBi2MIAAgwAE21W+t5
	kcN2AAAAAElFTkSuQmCC
}]

set flag(MNE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAMCAIAAADkharWAAABUUlEQVQYGQXB
	P6vWdRwG4Os5z88Uk4azB4ZCRLm4NOXQUPQC2lx6DY1OLk4uUkFbS3tr0RaB
	omCDQbT4b2koKhL1eM73c99d165PPgIAoVUmQtp0Rmsla7o592o+PULBgBBC
	iIZUOHvteBPITw+GEoYwhNGpIbx25dJMN1EWJQzh+Ot3nNnW1V+63w9D2LNW
	D6RDWCz2N97Om2f2h6dP1vTiuf0X7y4Wi7CSTYVFGHax++q9C9993p3fb908
	efRiEcKwxmZ1WITR/HF0cPmNw/fvvXX2r1XHvz4bhhBNemA6LD3RVS+/fPzf
	J3fvnP/528Pf/j06ff3Bh4vR0WHaAyujq1YtFq//cPn5j3/Otjv1/dPrn92N
	DkOZsZlOLYYw/P3x/TA3H0affyOUEFpbV4dTVy7tCWUo1RAQSkns/rn9QdqM
	lbRmmjYjbSpJEaGF/wHENQ18JLr3IgAAAABJRU5ErkJggg==
}]

set flag(MNP) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABqElEQVQoz01R
	vWuTYRy8vH2bNmrTD6NNYlpL1C5VMFQEJ6WC4FJwcXcXCk4qOPgPiDiIiKA4
	uWsRN0GnYB1sLYgEmxYTi6aSvtaE57n7PQ5R6XEcN90dXAonbuM/jHAGIxzh
	DF2HLkEHEXA9xgDu3rwIIAQzQy7rDxf9bMllwPqvgZdVW/+eogIpSvdv3IsB
	AGFza0cKhRF3vJzw62qSFFIYnThSP39058m30loj8lQ+tw9wEWDBghQomyza
	yYL7yOmHn8uv01PXn05lrbNwKTjKk6QAF4HGECgzs9P51vJG+9ni/qB0jPzb
	la0Hn8oZrHtH50Ua4CI4moJknlJGIT52amZobDh9bvbg/NxktTrc3x+c5GmU
	AEagUaJEWrI9NlP6sbzRaLWTldraUr1v7syqbw94L/JvQ4yuMwVPI/V8afBQ
	9OXRZbz5Wak1mtcuNCvFzp1XoIwU9W8STaQ89aG2fev9UHZ8r8wkqxxovqvl
	F6sjvXjJAMZwztNyo3skI+U3Bxceh/mzGQu6+mK60/o9MW6UmUzBAEuh78ru
	IwEHcJf2TI8G4A8wz0AZJdztFgAAAABJRU5ErkJggg==
}]

set flag(MNC) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAEO
	SURBVHjaYvzPgAD/UNlYEUAAmuTYAAAQhAEYqF/zFbe50RZ1cMmS9TLi0pJL
	RjZohAMTGFUN9HdnHgEE1sDw//+Tp0ClINW/f0NIKPoFJH/9//ULyGaUlQXa
	ABBALGCz/6OoBkoDzYMoBan+DdHA8Ps3UANAALEAMSNQNVDFnz8Mv4EkFrPh
	GoCmAwQQCwMrK4Os7H8Wlv9/gR74g3AxktMhJIOU1L+DBwECiPH169dCQkL/
	gYABDHEDJiam69evAwQQy79//yB8sN9xAogsUDFAAIE0QDgENQDBnz9/AAII
	agNcDwQwMjIyoAAgFyoLEEAgDS9evPgDBv/AAGIShA1iMIAgkAH0A1AKIMAA
	5a1fe6Xb4q0AAAAASUVORK5CYII=
}]

set flag(MOZ) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABhUlEQVQoz03G
	PWuTYRjF8XM3d2JtbenSQoRHLXQUOvsFBMFJ0E27dxMXUayOgopzcXByEHEJ
	iC+fQDrVLtVJF4tpkqIxiel9rutcDvKA8Od3TnqyjlvXgFPAFBBgtf9XajNS
	AN+e3u2s48eSVOThJneZhZnMRLqZSBmdne1OBnCuHxsvvz+/4DurTtLldFKk
	SGdRKV7orOYrZGQAoVhMvvner96/2WyfjYiIUKgeRYSknPP+6f08AT7P+epl
	+/PC2luP9pifkQc0kiylkDSykGR1pup86MwUoH0xbb1eWdiYizQ5Px5cGfV7
	o15v1Dv81/CwO+x2h93BeAAgT4FXb/zh9cnRu9nZI//ozW1DIQpBQ2GioVii
	NWgtAOkYaNzZjN2vmDc9uPdracEkRIQUkkKQFB5So3nyy97bDAB9iwZxiWjd
	XvxdQiXEWoZKBBGeTqytHXzKAmaWDTfaURFTRxDBFAQMIJIhGeAIx7GrjzRe
	hh5DK9BPyACDBBlUINXfIAAGtPAXn2ZJkiBzj0YAAAAASUVORK5CYII=
}]

set flag(MRI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABL0lEQVQoz22Q
	v2qVURDE5xyPEsQgXEHIBS0C4nPoU6Szs7WyCCnT+gzaW6YRRIJWgo2vIJjC
	7mIRwTN/1uLLhwSyLMNvh4GBbV8B4f9kPbVyVlj8cQc4PDkpAAmSsksuK1JJ
	RZYUcuHvZ2fjI/Ac+5cXv8qOFbosUyFNespkJk3ee7R9C4xjnB7ff/bzz6Uc
	OZanSjLpyVCe9Jym/PjB/idcDGDPbagN9ShFdCJEm+iEZ3VWn+hEZ7sN3B04
	+LzdPLmlnWTJsmktDZSuTIny9uHmCz40G8Crqh+FiVIVq+aN2vvhbvdtJGiN
	VRPQ9dC1NKAqSRgvz3H0VLu/TKjQmc500ZkJvThFx5s9vz7HePceOJJywFD2
	1TtDWYuq5Ni2y7/foOEFMNfVTaAVAnT8A8TfZaBHSy1BAAAAAElFTkSuQmCC
}]

set flag(MSR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABuElEQVQoz22R
	MWhTYRRG73t5SfqI1pioRENqRYwWIzpoSSVDR3ERR8HdwdG5OLjYoVtHcVAR
	6iCtOlkQoVBFB0UobSJCK5iCBJvmxbzk3u/e3yEqDsIZznKm463cnHntl2ee
	dG77z0YD3GpO3xhvXL5YuPKwQwQiJjIi/ot39sSdxflpOlIcrG9QN3KFYuZg
	drmOxueWinXFQYwGMczFmli4Nxfcb8+nG/uDt8vJ3ch6vVRuX1/8qXiw+nOy
	LYlytQo1wAG2u/6RqO+/2FOVo+WgNIZwrxVLqZMTUSa/Fh6PhYRZYIdzrfED
	TVGDKBH7rUvX/Wx2qVPaCotNL/c0nAwqlXaYj9gJA3B9SSVSi4AljYk4sHer
	S8dG33y1c8EIASsb9bWxzETSedxnOKgN0FYDqwFKxIn32xdO187s7MRbcXqz
	lxbo9vfeh28uEk+ZrlYenB95HrWsFLz6tHnqS/2lTwSoiZiIsiizsthQIsbc
	wlT9R96FnbuPagwjQkDECidQER02Iir4LYHa7OMaYALtqw4DiGjhUEZEAQNU
	xGAqYoACRuLMqU/aZUcEj+jan6P/xf4RENEv5XdGLZULIu0AAAAASUVORK5C
	YII=
}]

set flag(MTN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABX0lEQVQoz1WR
	vWqUURiEZ5eDCTFi0CrFNgkWFuI1KEjE0kaxsRXBC5Dcgb2k1EKwUYQQEEtb
	gyKCgnUSQcQgZCPZ+XmPxecKwhQPAzNTzAiPgSkwBgDUXAYMcA4DnwCLaPiF
	zWubAKpX9UqPnczsspsNKXZJZUXbW9sNpwD0/eOD9ERRV5ybF9S7nn6Wumhy
	REWT5QkaxgCqeip2lhaUHk55a02318QjMrPlRZKkqQjEGEYQd/tYNyZmUU0b
	r3llh2ychXfWySOyqBoCBVdUUtf7H3p2VTwkD6hv5He+3NCHn2SRoWMYDUbK
	jrnA3a/eW9ebu9z6IhfvX9Teb+7siitUNCw0GOpi6LLO8N4rXb/MB5eErkef
	+OStuEJ1OU75b8DxUKAunuWLj3z+TgxV4nmp6MgVV1BomELl1dOrGtxIS5Ll
	skay7O4k6UkFU4zwEDgEav4r/4d/fgEnwDn8Ael6aF3HYCPYAAAAAElFTkSu
	QmCC
}]

set flag(MTQ) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAB5ElEQVQYGVXB
	O2iTURgG4Pf8l0CSJthYY2IaKsaqKO0QTCahIaBC7aAUBXXSIg4KLkaKTnUp
	FAfBUVFRB0VQ3MUuRY0I0UEHSdGmJJgIzZ/7fznn+9Q6+TwC44uw5cJ8fs/O
	yO2HH4uvv4FIbdwkItO8BnRPX5lOT0YLc0+ABkA6/LmlhSPhoC+XTR7Lp2Jj
	w1P51FQmCcAJ+7P5/ZFh/8mje2fPZER0x6eVFQMawKg2uuX15sTubc2WbXUc
	3rRWa9mO9Pn0H7V2fCRAxIA04EpP0uzh8cT2kKFD18XA8XhTf+B5Us1fyIaD
	ZqfvCgGgL+4+L2UnEtV62zQ0ZoSC5sDxDqVHmXm5WCGi+kbPZ2hSUSIaevDi
	g1BKCSGY2XGVAAxD8P+IyHaUrsM0jZZl6ckDJwxTdz3lSVmuWKuV5lq1lYyH
	mHm5WFldtzQIx5Olr41avXPr/jsBs3B9aabZti+emmx3nMV775n45Z3jzJw/
	/8xz1Whs6Oq5g49ffSlXWm8e3dAgCUCn57wtVYMBc2SLH4L/UYok0c9fveLn
	2kwuxfhDGmBbKnX5bHosNuQqtW9XRPsOIQSARDREigpzmdjWYM92NcGAFMAl
	oI2/fIALWEC3Xn9KRPH4NNAHAoAPIKAC0G8yIROVYYiN4QAAAABJRU5ErkJg
	gg==
}]

set flag(MYA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABF0lEQVQoz22R
	sS5EURCGv3Ndi0i0KLZQUPEgHkWv3YfZnsYT6MQ7CMm2IuJirzv/nDOKw41F
	Mplm/u+ffzIJbsABmIBBgRY6cVrgb7Xgs9nB7t7k5Hjz4yOur7u+Tykr+dma
	eyOFe3z3t6urFlhfb44ON6bTSSn0/fZ8/owsdB9SmEIWZiGl6bRuoJSAiEgR
	pUSYleTlSyoLUwWQKtD0Aze3vYn3Zb64fJEaVMJs9B4B6n0xDHcPw+Pitet8
	+ZyTUaQVdQXcC7RPnG7l89wvSickpJAa68OG0fvrhhppB5KWYa+4/xz/UuMe
	7g5tgTX3+PYeA6xgLjyTMxVo5Ozvh4RnXEhJwp3a3cm5VoH0vvpI/vvuOAI+
	ATPsVhJe32UyAAAAAElFTkSuQmCC
}]

set flag(MYT) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABkUlEQVQYGTXB
	P2tTURwG4Pf8IQk3GiMZHF0MKrZVimgdin4UV906+gUEcXFw1a/iKNIKQrSD
	ELuFhGtiLLnx5pzffV9LxOdxVVXhHxK8AIBMid4jJV6Ikd5zy8gIoCgKAJrN
	cHyMblfOod1W0wAQqeVSh4cqCknT6dRVVVUUhSSQyFkAHOScGip4NVRKarUE
	OOcmk0kEIAnS79XKgMvd7snJZPkrUQreHh9eP0+Jq1W/3/fek4zY+nF2tlws
	HHTj5q3378azWQ0vq+3B/WvfR19y5qUrvb29u2YWSQJYV9VwOGx12nWdsK7e
	vH4Ih6NnH0jevrMjudHoqySSkaQkMzs9/XZvfz94/2LzNj9/KcuvQgh60oTw
	+eMnF6Ikkh6ApJ3dXcHlbLapQ1pHrCPWIZ2nuq7/bDYpHzw6wFYkCcDMgg8x
	xuxc5+mRyp9NymxFBNdptdudjuUcYzQzN5/Pe72epMViIap/tZ/NGlKSA4L3
	ZVkCGAwG3vvxeOzKsuR/ZsmMlhJJMyOQ6jrG6GMkia2/XWsovO2+6qgAAAAA
	SUVORK5CYII=
}]

set flag(NAM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAB9klEQVQYGQXB
	T0jTYRgH8O9v+21ubo65Ri3toBlaIAUNRlAQWPY/hJAsjBxd7CKiQmUwjQpM
	i0Ii8CBBRIeKikYIQRix0zpYh8jISqupzQaCbW6+z/O+T5+PBYwCJcAGbKAE
	KMAADDCggPDovWMH6lVVc9QABrCAoYHEvoCv6CkrZXP+4pqD2WhtmPXOWKTl
	6Cbvwqx79Jas5IUon0zagNvtoviRJ56y4o3x/b9+ricmr9fZHt8Wa/AEbl+R
	tymjlBBbiYGp/g4bgAVjgZwWWSBi2lK/rrtra8XyvKe7UxZzokiqN/8b7Pm2
	wTrYv9sG1EredXXsULm7MLsYOtHWcHhvZeDRmLxICilRSk6e+nPm+P3s81T6
	DTKwASY2mWxFOBwZvtlYScueC53yY16IxBcqjPTN1PkvTXXNZL/UBmvBsAGl
	td7TVH22tdo/8cx6+EDWlCiSpua/50+/Wk3fmRzOqzyByBAUbKC8p3dHyFn0
	Dl2WD5+ESJzeQqIvE627Pj38fi6loMgQG9aGwbC/T8c3zn20Rq5JXgmRNEaX
	ejvSrt9D787lSjkFIq3YEBvNRoNhV8VqHK3tEopI0KHaWpZ2bX+68HLy8+ug
	J+hz+1gzC2uttWhtNBSsAmAAA3x9fHeiZnVw/CIygAEUwAADCmDAAAz48R9A
	7xWZSSCVzQAAAABJRU5ErkJggg==
}]

set flag(NCA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABO0lEQVQoz11R
	sWpUARCcvXuB3CkcwYQIKmmMrU0ES/2CNPmItPcFgRT+gpWFpSCIVcBfSJO0
	NldZKUEfd5683ZlJ8e7gzmFgYZllmZnA1OiwgoTCmkIJ3TaBBh0uzgBAthwU
	aJRMRmmYHJRcdMolf76cNyjA+NGaAoWSi0g5udJluaOTfjoJ/FXz6gTH+94b
	QQbVn5laUpUaF91/KPlgjK9vFCQjAoBtGIY9/5DzVspmPPKDc68REW3bDnq3
	q10/2V3NXnz/8sdMbwKQ1GyqsbqIt0c3fLZrbOnDlhQv3+f0dfxceO3YJUX+
	prXUhELRZZM4fBjvPv5qbr/p+slwduckOvaZIDXJcpa7PlO6iOePgE9oUEoM
	Hk9QdBIlJJGMIlIQkUYxZJcAKHC6wHxdZAn/8H+7feUpANjBPS8xYrvq1kWW
	AAAAAElFTkSuQmCC
}]

set flag(NCL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABnUlEQVQoz32P
	PUiVYRiG7/f4dtK+UuwQUZ4SEUtqsYSagmqNJrdqERyirb2hFoeIaGsSAsHN
	giRsCuQ4WKeT8dVQBGdp6JfwBz3feZ77eZ+GDxq7uLime7kDrjTxDyYQYIIQ
	BISQBCGKskSR4gCKuzdPAECnuy9+cw+bnaNSjUxu5mZOc1qiJZo/vtWKm+gF
	fLK+WK99qQ38zDLZ2Nq79O5q49M5MtFcmdSSMh0ZrAKMt/PnU8dGamNv+/qK
	hQXNc5ud3bh24cnJ3+326zFjMlpp/86BFTyKD77ex587KXbcmeccH1d3DUHP
	HH919uEHF3Gli7pqGB66hGYFiD6xVYk6P69UXV/XuTlxl3B62wWucHEXd4ET
	CYiAoFlNF3n9hqjSTKenxV3t/Z4g6kJXlg3KBMSe87o8lOrtsLbKl8siqt2u
	zMzovV/9T6dEqUKqkcbRQ9Z6gwjBszy7PNKz0tCdXXWXxqp+Pzy4+DFTK9dK
	Y3keQEQBNb74fIqTun97l8pOVmn9sOGDVDMmI2nJSgEEjAIFIEABFIDi//wF
	jBtBxwGpFikAAAAASUVORK5CYII=
}]

set flag(NED) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAA/UlEQVQoz32O
	zSqFYRSF16tPUueMJAnhElyByzKQCzAyNXQN5u7lJDE4RUeU3r1+DD4OCqvd
	6mm39mq34Ev+yb9OC4DTcwCxYUEKDTEUyBRDpWr0l+urAQDA3D1AgpwiVCmm
	mKp0pnp6pXrb2zEwYPMou/tYm0AOCSlUyJAfMB6T2No00BaLxXQ6BZAEQZC/
	1FqbzWaD7TGdZAm/Cq2RHLwM/d+ftARAw+HFydnx7fy1aMqdKrmo4tJNuqSD
	rcnN+eWA++en1z5fvBVdcqd7qahOL5007cn6KvA4oLvk7Y31sYlyyaWx1aTo
	SJYtjS/hFOhAB/gN+G1DwJ++8g7ZJGpzgprw5QAAAABJRU5ErkJggg==
}]

set flag(NEP) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAAAkAAAALCAMAAACah1cpAAAAyVBMVEX///8d
	LckcKrcaJJ0fMNYfMNYyKcnnAQH209MGCTYHCjcHCzgIDDgIDToJDjwKDz4K
	EEQLEEcLEUkOFl0RGnIRG3USHHgTHX8WEjYYHn8aFT4dLZYeGFUiHGwnH4Mq
	IpksRLQuJaswJ7kzKcarAACzAADBAADCAADHAADQAADYAADcAADdAADeAADf
	S0vjUlLkV1fkXV3nbW3qfX3qgoLsAADsiIjwAADyrq7529v53Nz53d3539/5
	4OD65OT65ub76ur76+v88PCIW1PxAAAACXRSTlMA8/b8/f7+/v7eA+YDAAAA
	YElEQVQIHQXBBUICAQAAsNFdUhLSSJfkoVL/fxSbeCwKGJ4TIWBwvCXDoP/6
	De4R6F6ej+Wsgc5q0WvVaxW+5qdDFbT3/3/rMjR/rsFuXMLndLuZfI9yfBQL
	+Vw2k069AbzpCOr68fHsAAAAAElFTkSuQmCC
}]

set flag(NFK) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABoUlEQVQozz2Q
	u0oDQRSGz8ZbhAQFDRJBLEwTKy+tlVpbCVqIDyCItVinEkUstVR8AFERxMYi
	L2AVtYvrLbhr3I2zmTkz4z/r5ezMMHM4//efs0Rz9L8Orw8bYSOKomaz2Xhv
	hGHov/rb59s0QJQn6iJEJ/bW+hZOY8zM+Ex/vj/jdcTtSLAYzg/36uxseXa5
	sqQMK61O10+dgMg+hr42WrSFtZY8u3OxI6SoLFaMsVES1V7vlFIjAyOpgwHb
	opqNNtZ45LFm/8OXLIHMeBkkpZLKKDwhyBCTthpFzApdkUfV++pz8PwUPO1d
	7pElsCB2mlTgHFhrPNiwJfdd3V4JJdqyDR90CIpzYwVk6iDBYFQjC9hJ9QRN
	czpi2AoPrg9+HYz8a0kSbkihKwdTsh7UP+PPlmg9vD18qS+MhgGA15rTlhL6
	4cEU8y1MLUyPTe+e7eK+Nr9WyBdqLzXlcO6vpAI4MBf7ihB0d/Xksrlyb7k0
	VAJicnQSZz2sjxVKGpEKPCoSNG4ltHm8uTqx0t2ZDeIgkclgbjBO4v2b/aON
	I/qLbz7rVCDqPDNaAAAAAElFTkSuQmCC
}]

set flag(NGR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABHElEQVQoz3WR
	sUpdYRCEv3M9eAMKkduIhY2NDyLp8wDWIS+QyiZV+pR5DV/Ch7CwMY2FYDBw
	+HdmNsUhQSJOsc3OMvOxE99hASAg7j7dHe0fJQGSPC6P59/OEQQGzMw8c/Xh
	al2nc7w73m7eQXc3sK3t5cdLURWV6/rH9cwM9P3vn45tJ2HT/+T49ul2ZFTq
	9PCUMBOSdqxYrn6l4TEyylUuBjNgrJYiRf+5kwyP4VGpynogFJdLlqLmVYLG
	WkkWYkY4UjQyZL1ZqV8kVNfwkFUene4X0OkMj+pS5PxNkLUy1RvQ6lJbMWJm
	oaKTg5NySZ6mCVgnsLfZO3t/5rbbjhlMfIFfIFhg4ebrzW5/t35a0sPzw8Xn
	CwKA4JA/03x2ID6r1H0AAAAASUVORK5CYII=
}]

set flag(NIG) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABUElEQVQYGQXB
	vWrTYRjG4ftN/hIDUkQUySBFWgQFN1cnnd09ALvq4uTmIQkegEKHZpFuipBC
	oIOTHzSlfT7un9c1eC39k2aSZEshWQq55JKv5JBDvpIv5VuadCG9+SAJe2C5
	ccs1uuZds0666MRF58W7T5MupYTf53LLTaeqcdJJJZV0UEHmuPvArbH7cbJc
	PVSnJLAAAAFgaAw2eMxvnH/7Ona73XK5lAQIIfj+hc0Jdc3+M568BABgjLHd
	bifbkgBAEsCvn6w/c53MFzx+AQCAxrA92QYAhBDAnX2ePievuf8IAABggO1x
	fHZ8cO8gOowRxiAjAy67AWPbi2mxPlsPvdXRq6PN3012Zmd0REc6oyMrozMd
	5azuw9uHpx9PJ82Uo1Z7q+wsd3WmM53lSmd1FdXdTbdbNzX0XvojWQoppJBK
	CimkkkoKqSRLIe3pP79iampshg6AAAAAAElFTkSuQmCC
}]

set flag(NIU) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABm0lEQVQoz02R
	TShFQRTHz9yZh/tQCi9JSflIWYgkSXasrbGUlJBXVmJnoWysZC3ZsJKQJOVz
	oaRI6CE9hZd4Pu67M2fGmXc9ud1Oc2+/+Z/fnGHR6MW0mJvKG1E54YnDntHK
	ec/3Zq8H2x6GNpYWst0sjRi8RtOD4iVcet03M/51FXcjbLi5/7KwJnm2I1Zb
	NzWPLPJsx9FEgtGACDKe4tsVryWNVax4OX8/AeyicPfeNBwUnXw0HM2HO1Jo
	FCpfSl8p6TDmv/mOeIoz2qsRnp+N9w2JVyM9k/wQ8h21NFohyVAPsiJGax7r
	2qtrKyu+YbfV7QVVK8dyrDRRsBTqXPiqb21c45wFNBUGBpNKmLtY7d757GPL
	u8ujk/56E2x9RnpiA6e5va4IZWg6tHYc8kCWvOp2y3NIkVrT0QggDTsPrdJf
	AY20DAnHe0gJABPE/NGBtB3if3tLgZRSoFZgsjK/Avp36tQ2mKitYEOoUAew
	18G5RgWcRkeihjNAZZyQSCsRlvawKy0oLhX3bKQNt8aBNGRk0F7z7yaqP2CO
	dAd2++edAAAAAElFTkSuQmCC
}]

set flag(NOR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABVElEQVQoz3VR
	PUsDQRDdvT0bC8kRLRITEW0sxNJG8E/YWYhgJ1ooduIvUPAH2FjYCiG/Qgio
	CLEzRlDRIiwEG3fnw5m9BCx0WN7uDe/NvZmxL2YUc8yTmw9fV8t958gYSsny
	Ab8wl2xxcizIzGfbdWtt9fCAEQwA64kcFUkwxqdWO0+FmF7f5Pr0IDLo94Vh
	opCELSdQCByiazZHfzAoLNSb1AhD0KpBqcoWTVDMYhRXeQNRbJSWQJTMlesW
	/xVCWxoOrdu4O9+Z/fARKXkmEpl8KIIgRdS8ZOrFxMVexyJiWZ4NH12+n27V
	+J/Issx7n/ecm97fhd5zpdWOydJgfY2Cdmy03ThqI0K+uNDt3ObSJqeRCVVt
	MdN3yQiaVKU+SIwAatMqAMhq6mRmSofmGs0MdfAmjd8BKBuRknnbHa9w3vti
	5WZwv/pYrcJ4x+WCzRglfgD0nlqSGDQqbgAAAABJRU5ErkJggg==
}]

set flag(NRU) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABUUlEQVQoz1WR
	MUtXARTFz9M3SBCiQfgHg3RyCFpahKQv0BC0Bq0ObU0trroJTuFnkD5E5Ozg
	5BAhJZQRgmLvvXvPOdfh9Zc8nOHC/V24nNNg8hbEP9kIgkQQCoBA/OceYAti
	a+cNAMsuSJJNWTZpSkmTSimpT9sfWgCoOvt9KZckalw7qVtHMqnlh/NAtDAk
	UEVZMumQSSc9pZVUUJkCosU9zs5wFlmNClUly5JkSeT4oGTRReBv++3j58W1
	FzmcU4TVQGWWWU6bZdpZps12bulkUe3Kq2fvdyfff86tP3l0eHx6eT1EKpMh
	ZSookplK6vFk4cs+ZpDM9MbT1Xevn29vvpSbrmeX1Q/uw/2gbnAX7sJBAGiB
	IHV0cvbrz9XXH+d9P+Q0RJKUSFGSbWs86JOuBnsHhxdX3dKD+5STnqKmxBGX
	ADTA+t06x0Zv58Jd3QAELXK+4DE6MQAAAABJRU5ErkJggg==
}]

set flag(NZL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAB2ElEQVQoz02R
	PWtTYRiG75ycJD2HNM1Jk8YQa8FGMQGx/QEWwUmloOhoR3FwEFcdpIO7Y6GI
	2ILoIipiBRUsOuhQ6JdFB/tB09CYxMamyUne53ne1yEg3W4urmu6A5/vTL7b
	Tz54tHw/tRq2rHvlIzeG9MVzJ688KQEtgAEG2oACFGAHTqdvzT2f4GS6vfYd
	fguZbCyVeLNQXVzfJ9LM+rxb/tDob/hMbF4/nrRnrBfB1ULkby20Vzd+O+TF
	26TP+upVbdQnM+4Uc83fdT8+tZMczMYBtl66I5TLh4dzFEvoo0M9I2cOEpml
	0LEOG0XyrJb6VO+bKg1MeEUjAiirOnY5EI093XC2At4WuTP1QTufr4djbSV3
	vbWkg9nKwDV384SpXYgUARU81fB2ndSX5T++31mv0sdvOyu7kuqRxTKPO9sF
	U5nb8xYabr9uvjXD2z/e27O/7NvBOMfwlXuZhPr4Z4VWSqLI3NwsKGIiViTT
	fva4I4CyACbSSjSTEIlSukNGke56RFqRXI9uMImwBpQNMLOQEmLpSoqElKhu
	z/wwveTpZqe3My+j3aBFbDLpKJEwC7MmFmJhEmLNLNOhsUuR4rxOixhAAsBV
	4ODQlwrgQ/s/YUAD7j/4kDqsp9KA0AAAAABJRU5ErkJggg==
}]

set flag(OMN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABGklEQVQoz3WN
	PUpDARCE58WngvjTCYIQiB7AVtBjeAA9g6RO52ls08YcwNzAJkUsTRrBndlZ
	ixf/UL9iZpadZZsJfnD2sgJsG539ogVwuVy+zmY75+fPo9HBwV4VgKpP+8Zi
	sWgB5Gq1e3Hx9vQU8/mfvY6maST1AGwcHi7H463BwOR/7Q7bzQQ4HQ7f5vOS
	ikqxSJMOFsMRJivC5Ha//zCdtgZKWWRJpiAiAiTIiqhOuyABaAVUqiQzTPXI
	YiDYRDRca3WZ7K0PSEdYqoibW0YGk/Q6hIOmUif7erxDC8CSSZNFRsZXLxlJ
	OmTKqUx4/UGbR0dFWnm8Q5pMyqIpS6XMTGciITT3gAABBgRcXwEBCHgFDPhj
	7NbAO7zseXiFqGPtAAAAAElFTkSuQmCC
}]

set flag(PAK) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABh0lEQVQoz2VR
	TUsCURR900wDNipSi5hUMChD2tTWgvoB/gTxD7jNbS5du4n+heGqwJ2roI9t
	iyTTKSkisdFm3n1f3ZlJEjozXB7v3XPPeedpEzohIaYwTZ+lyZQQSQgPf1xA
	uID5wsCPkKSZxGrqZv2oPmMzToSQnAvOCVbGZFgFZ5K1z9tGNF4pJaUczoZf
	9EtIoYhKW5nncc8THjAACdidjWdRZynqjiqXHLuBQ3W3erh+4FHP0IzaXs2O
	2biJHHS1RObAqUjAg6JdzKfyl8MrKmnGyhRWC+WdckAQDBUMdBKNR+AWIrGc
	iOmx1+kLCLh9v2vcNAbuABRwxQNL2K/mQAIevH+/YQCVfAUoAKVdp9t3++gn
	UOCYkpQLhOB+l/2rvbX90mYJE3fBzSVyF48XHaeD0QUESf4sgWRoA0Xq16eO
	6xxvHMfNePO++fD54AufC/F7hyglTdNsy7Z0i6lAvd1rt55aGBplVF/Wt1Jb
	QglU0EbjkQzhc3/7ZJt8/HvgxYdfIT+HykCM1NsTPQAAAABJRU5ErkJggg==
}]

set flag(PAN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABTUlEQVQoz1WQ
	vUrcURTE517/KQJxm4WFCGJhZcDWVhAsrO3zDLaxTC1i6UMEBXshPoGVbBOI
	hVooBnfV4J6PGYvrLjocDlP8zmcZjUZ4JxIASaLfJ9AipoZAB6DX6wH4918k
	+vOQAMh2dvj8LHdFzPLdyUnXGt+M9es8nyb6vlYXekVS/r3k41jmdJOZ3Ovi
	YrQJkr7OY3UBT5PSaEmNo5vMWwHd31ZqWl+uEDTTaEw3msldZnSfcw+g+7bf
	/dyK20dlKqhIBIWI3Y2N6lYilKmI6l4Gg+7srLv+w5sHXT3IU0F5ylMe5dPu
	D31UrTW2tyuMQUw5eehlIk/OODs8tIODdirJCpvSKUt5KkWPNzqHQz899eOj
	vLiQFBEdgkkNvpRIOBGpYIkspRQAcysrn/f2QGJpqf2mYPMeRrwQFjBOPYe/
	LSJIkgQZZCt4BT95XQq8uyPAAAAAAElFTkSuQmCC
}]

set flag(PAR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABH0lEQVQoz21S
	O0oEQRSsnhkHNRHBQITdC3gMUwPxOG5gYGLoLUQQg8UbGIqBV/CDLKz/XdTp
	elUG4/7A4lFUP+oV3fRLxgxa1P9WMoBeD4AlSIgwA0GTIJ2z53jU71cAAPvh
	ERGIcM4t/1WTnRs3jXNOnY6ACuOx6xoSANvwFJgdJNsoCg2H1ZvqtbJEWf5Z
	YN3d/VxeKOd6dx/d7iwgpWFTF+1Lp6G2Pfo43X45HO3489XzAEgVkhbcNlaW
	96588H2G5ZUFvw0pPb9/rdZLIbUTmlwfVnjSkGVUZfHwNEhYvz063rofZFKZ
	IJVpUnkmTCno7mZ9fnJdoRHDG+tFsGCYUZCKSIySFMMRoqAwLQAJ5Q2CgIB5
	bgXnvpjtBvwCb+9W8ZtWokUAAAAASUVORK5CYII=
}]

set flag(PCN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAB6klEQVQoz03R
	TWsTURTG8XNnJpOaTNLUpqSGtF34QkWLVVEKSikYqyvFnVA3xYXdCeLCjV9A
	XEk+gDuzEVypUIgWLWn6omnaxrSWWKQTa+I0JTUzmXvOveMiFQoPf377h92f
	XEiNfJkqjSdaW48ofav1OAn5pL55tzhmZt8A2AAcgAB4G+zOw19PpyLnY05p
	i58MWBtOd7wLMj9CNXN/rbyBCEI2CT1OPiJKv0ips8Oy79owq5jRlU9saalb
	WF59b+B3Ucy8f7vf5dpWw6me63fmik0jpBRzOWUHwkL1MUUFx/WqFrjYlD4L
	jlhCY9I5fv1dMPzdrzevDmVOXckCkGqOps8MBnsjctFN9LDGdO9N48/mh8jo
	Cu8p13Z2t/Vj2qq5V0S/31ofKeQWtMDPQsL0PcsOxmVdWbe+ClmhgdOLz8vG
	GLX0Fh2txzqN6KWqWRC2AsC1V6/n4pfHK5XCLDKiC+py/q9DNr+o1RqedDpC
	VSTqMAwk4WM2AFcAbJAChacIVAVylAw8nQkibDr6k3sZJCyvzZDAids5AFIA
	iEgiCkTB2+UHQJIf509sl/onk/nqt6HlUh8AaQAcScaiASJBQhJKFAJJkhCE
	3vzqjUjQTb082xlWpj8rAJIBPDh85H+0Jw+BACQA/AOT0y9akd0sRAAAAABJ
	RU5ErkJggg==
}]

set flag(PER) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAEf
	SURBVHjaYvzPgAD/gPj5c4Z/IPofHCgq/gNLQRBAALGAFFZXA4n///4xApWK
	i/8HmfGf8f9/ZgYGpv///8fE/P/9+/+fP0Dyy6ZNAAEE1sDw//+Tpwx//wLR
	f4hyZHD79v9fv4CqGWVlgTYABBAL2Oz/UNW/f6OrBgKgarAGht+/gRoAAogF
	iBmBqoE2/vnD8PvPf0yApAFoHEAAgZ305y/ElQQ0/PkDNB0ggMBO+vsH7Kdf
	+DUwgp0EEEBgJwGN//UL5CqgBFYNYOOBhv5hYAAIIJAGZnCQAZ0IchhWDX+A
	GkChAnQOQACBNDD9/sMgKQk25i8kBhkZGRHRqaQECUMgAioGCCDGr0ixCIrh
	8+ehEQz0IgTY2kKlwAAgwAACPWGEO27OJwAAAABJRU5ErkJggg==
}]

set flag(PHI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABZ0lEQVQoz2VR
	v0tCYRS9vqykV+FQTrlYEKhQRNDYP+BSrq2tTe4O/gOBgVFBQ0QGTwgDnZsi
	AmtqMMiilhYNKs3v1+m+71UIXQ73O8M5l3PvF6pUStlsl+iD/DIWyoKJsEQM
	khCw0m4fVKujzWbHGGgNpYzWRimfKGmk0rYbKXW1Wgz1eq+RSIx1tdqL5913
	u0JrkhJS+goptJBaCJ/H4269vu0QTQJdx3nIZIZzuWQ8PiEErFSJHzWDueIR
	HMkxhp9nohJQSiWH8vnldJo9ui+M3/uBwUdgCBO9Ez0Bj8AYUct1FwuFsldM
	NU47SnB6xamUUExiavqCrtngAjPAHChGmEWvj6PEevlwzSbDQHdkYosozIms
	YYMoirsWdvZx04DdelBN9mrKGj6JpoB5OjvH3i7eOoO6H6LYoInPZw1LaJ/Q
	8S2uLikapXGXjxqyIynoDK0D8NbhEW/ha3PV/H7y32//R1DfNyFV+0s6xVEA
	AAAASUVORK5CYII=
}]

set flag(PLE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAFq
	SURBVHjaYpjNQBoACCDG/wwMb6qrdzIwXP0HAn///v3zB0xAwO/fv2EkkNi0
	aRNAALEANYkw/I968nTf37/L//79+Ps3UPlvOPgFgkAAZMrKygIVAwQQSMP/
	f/8Z/v51+vtX8fdvBQ/v/wmx/7EBRkbGhw8fAgQQyz+gjm/fGEHa/in8/vN/
	57b/TP//x8RgagAqBLoZIICYEN758fP/79//P378v2jR/77+/9h0AL0DEEAs
	EMX/P3/59/8fw+9f//+z/PcL/J+VjsVJYEsAAogJ6CSgwf9+/WT4/v0hz6//
	Xh5YVYMM/Q909T+AAAL5gfnPH6Ce3aq/J3iw/f67/teWlb+B4fT396+/v37/
	+/PnH4j9599fZX6loy1HAQIIpOE925814ZLnlFklgcH/7w9I9T+gCmB8/Pn7
	/w9QDzCg//7/+/ffX4Y/DAABxNjJwFAeyMAgxMDwC4b+IDH+wBj/wCQDA0CA
	AQDkoFQxcPY0cQAAAABJRU5ErkJggg==
}]

set flag(PLW) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABb0lEQVQoz02R
	vWqVURBF1/nuF1EMuRA0oPhD1BfQ3jRiUCzESgQfQPABLAQ7H0Aso4WlIIiK
	lfoAdjYBQQ0SQwoxiHqTXM+Z2dvikphhGJhiM6xZhYdmi50SFQQBof9dd2ZP
	z4i7FwBkyyWDgLQjSpRBqGvpkJvc0i+XRj0dwNqm02Rw7vD7haNvi+PN2sK7
	1fPNrnKVW/r4dEHqAckpIrg6v3T91P3Cupk7O/vauvdqZbHimm7pllDVISWE
	oGtXTjworEIU1ruyeuP0Ewa1hmu6pptMpSMI0dKFv9P9p138rmwc2v9tqvzZ
	DURCqEOkHPJmmxq1+d1Aavh9a/hzfKDKNV01uaCOqgnZdu2frdyS52CQmo0c
	Pv54c7S9b0IcScpE9EiRg5Zu4tHy7S+/zlw+9hzXF18vPf18reLJWyc+CHrG
	auqOHKSlQyxvLH74cTHk1jg54xBhMkvaKagq3Nnk9x6XY6g7q/ZolgiY4R+o
	BTqvumzVSgAAAABJRU5ErkJggg==
}]

set flag(PNG) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABfUlEQVQYGZXB
	vWqTARgF4JM/kILUtdA6OGTwBgIKxYCbuOkgdBEhEIi6CdJdHHQTGuzgBUiN
	FlQcOukgqIsYg9DhoxicVIox6XfO+35H6B34PLgM/AAMGEgggQQSEFACC+Av
	8Ac4BH4DP4EagIebm5eAdlWhqpDpSGQ4Akvhc/Kr8EyOsDTb3W0C+AXf/z5d
	z7yauSQh05Itn5fb8jK9Q79VbW2tAuoAqsqRuddq3Ws0xpkmLXldvkifKH2a
	7tKmpQqoA8jMiLi+sXGm271LPpEWogv6Ef2SPqA/0j1aAlAH0Gw2+/3+cGvr
	+c6zXq/3tNW6VfLrJ/ozvS2/py/QL+iICmgA6HQ6AMbjsY4dFMX06Og1Ceks
	Wfsgn6LfqHZyeTGd1gHM5/PRaFSWpe12uz2bzUgeSg/IG9I30o+FMhwRQBNA
	REgaDAb7+/vD4ZCkJJKS3klXyDuha5H1TABNAFKsrKwURTGZTFZXV3UsIiTF
	se3ML5k3M1v4T7eBfz6eORtoGPRxAAAAAElFTkSuQmCC
}]

set flag(POL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAEI
	SURBVHjaYvz/8SMDDPyD43//gPQ/bAAggFhACvn4gMT///8Zwdr+/wcRjP//
	MzMwMP1HAV+ePQMIIBYGqKL/yIz/2AAjI+O/P38AAoiFSNUQKaCTAAKIBehW
	RrhqMMSjAagDIIBYGPj5Gfr6/j979v/PH4Y/f/7D0e/f/38DGb/BjN8gWWnp
	fwsXAgQQ2EkPH/5/8OD/718MvyHqfv3/9fv/r18gNhLJ+OkT0DkAAQR2ElgI
	ZDyyIlTVEMv/MDAABBBIAzPYAQxwRZja/gA1/GX4+xfoHIAAAmlg+v2HQVIS
	bMxfhj8gnYxgIxkgJBD9/QtBQMUAAcT4FRy5cMSAykWTAgKAAAMA0PVcqMe0
	XaEAAAAASUVORK5CYII=
}]

set flag(POR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABXklEQVQoz22R
	MWuTYRSFz/fmbVIrpUI62CGCgyLipP4Dndw6unTrIJ2cM3YpiL9A3ARnCwr+
	AUH0D+igS52iaYmJ6XfPufc6JKFLDw+XM9yHO9wGT4Eplgmgwt8t66VUTDDc
	HwKIiMjwxnHT4WqkjlTIlHI1p8fHFQVAnpz+2uj4/b7f61O7rhG7b5mnTGPS
	0izJZjAIoAKISA9//tC3WnXfOOfMx5zuceOFJS2NCwFkAAUBT5d0NuP6e3UP
	DifPjuzLdtOjYNla2goSQIFB7nRWcD6ztlw5u367LWtRWq5ZkheCFECFwUMK
	fR3ZrUd+59Vw++qN+e43S+uPLduVQzZkABUCneb28Yf6dzl5cnLtz8/ud3Y+
	WZldbENKSYsLCtH5W3z5mb1N+/Da1GMZW5JLQYQc7gAq/oHSztYORbkriQEr
	mZsCCQkS3BcE0OABMAbOAQPOgYLR38t/vMh/jtdGdkPAeiYAAAAASUVORK5C
	YII=
}]

set flag(PRK) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABb0lEQVQoz02R
	P2tUURDFz737skJYhMAqRos0ksIm2OZLJCz2kg+ydVLpB9AyldtpkYVUNhYB
	e02jpNm4plB4cfeemTvH4j3/DFPMgZlifr/0dKp2ja48gg4PkKAHPcwD/K+H
	SO8/6/F9AIAkINSPISkgSVBEF/XhU5t+It15+SKul6gedDRZbQtA5qouc5mF
	m2j54fbi9asGUFouc8Zg8izt7KRSOJv5+TloMMIIWiJhBq4zkAOIWgcHB3F5
	qa9fOJ8PJhMNh0EGWQsrWUknw4zdAbzi3jjv7ZU3s7y/r9EI47GMQcpMZJAi
	5e5ABqDquv5m7942h4d+dobVKhaLKEWkSum3yTAD0ABIZjw9HR4daftBs7tb
	plPd3CQzkbD+Abln9ww0DsRoFFdXv45PUD0ktbfY3NTGRpjJO0oO99jaWgPN
	xcfVk0eNoOiZd9QhKUK9ECEkCPOL72nw/Lb++CPSA2v88+qBv6Yj4MBd/AYN
	hFjkgC5H4AAAAABJRU5ErkJggg==
}]

set flag(PUR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABiElEQVQoz21R
	O0sDQRD+7mE0L2yiBDRRRAQ1oIiPXv+AP0AQwUoIaGuwsFaws7Ww0SaVGEXB
	IiopRIKFGAuFoClCiCJ4yd3e7jh3PguHj2F2dma++XY1oLSL0RQaTcAB1B+4
	PvAdMHTABAbKmVoM+ZReaNFsYUtyFblCSQ7cTyghGBwUslkNoLUMyk/UG6mu
	ZELRWCspIs6yo2/Tde+o1Mv9ve4xKooGUap3plfD5WdT6iYMg0E/4H6uMwxl
	mswgt7a0mWmcndJ1EbU6zSeyfW/5qKiSsL+W8X2gu/tyb481YHIcg0MUDlH+
	HErQ9t3snCyN2VeG02hyqeN4EKKNqOKLxnGOWOHhAVnvaDi02LM/Hnk13BGW
	3soNn7qlbInHkxcXvJJYXtJKj5xEW5A2NiiRJP1X75fxXE3TKre3zKCarsF7
	9kcr65uR9q6wd6/IG+wFyqv1e7gBlsUMjfSCPeXmJnASwLtt+a/O1T/LeF4q
	JSHlUbHIDA+dO8MdwA1g/flg57//DgAfnkcsDzN1MH4AAAAASUVORK5CYII=
}]

set flag(PYF) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABQklEQVQoz1VR
	PUoDYRScL26ICJpCRFMELbTQRmNpZeUFbDyB4Bm8hqWFvZ3a2ApiJRI0RBBS
	KaISMCsx5ns/Y5HduA5TDDPz4MGENqD4g//nKNKCThRYODwEAHe604xqMHVV
	qLoIVSlCVRd5ODtLHAigPL/QDGYUoZmLcMQoLtFjpEhSr0cgfLy9zc7NAQBJ
	EgjEffp4GmYqU/M75AZHcA8h9NK05Pn3BIBAvH/1TvpHt8PLu/TzmHzNDrIC
	Slk7czkYnGs37YZa67th/f7P4JRjAO6eFNsghqW9i/ZKrD9ZT1vNg93ttXLe
	D6S7J4V7kJxOKpuN9aty1dy3Vher5cliqqrhBlja3x92OhRxEcboMWZi7KhQ
	rbK8fN1sJg6YaKlWg0hQc5UgMiHi+QiuSjOamZkD4QaI+ZBaEPp/75FIgF/9
	0EQFGUmfywAAAABJRU5ErkJggg==
}]

set flag(QAT) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAFU
	SURBVHjaYvz59es/Bij4x/AvSULo3OfffxgYfjEw/ICRvxkQACCAGIEa2Li4
	gKz///9DhBZXl//9+/vf379//wDp33///PkDJv/9+V22fC1AALFAjIerXtFU
	9/rRA7AiIPoF1PAHhH4BSSFpGaACgABiQlb979+/8NpGkFqQCpCi32DG718g
	BLQBqAYggFjgjoNoW1xVBjL11y+wDVCzwdzff0FeYwAIICagqRDVEA3RLR0Q
	6T+/f/4BGQxV/RtMAhUABBALUMN/qPL////9n19SAHLGL4TTwTb8/gfyN0gD
	QAAx/YMbD9LxP6G7H2zkLxD5C6wTauFvYKgBNQAEEAsDzEkQn8zMzQAbD3E6
	2Pg/IOP/AMP4D0glQAAxfnz/louHD+4HINkXG/EX7GVw2P8FkaAY+QuMmQkn
	zgMEEMgPH969+wcGQHkTWfmXDPgAQIABAGt9W+VUXtJZAAAAAElFTkSuQmCC
}]

set flag(REU) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABOElEQVQYGW3B
	PYpUQRgF0FvVz2AEJ1GQ1swFCG7AyFhwIyYmxiKGJjKx7mm2IGZGTjdVX90f
	nw2Cgee0dze3+Mv029fXkuackki21p69euE7cIKAgQ3Am5dPAMSxczw+SAIg
	ie0k9z5+DperstbP9x827IJf5yXF9ul0yoXt1pqk6x/fXTM18fARgQ4jjhTZ
	VHrvSVprvfck3tXwnF4zVQY20rIlS6GVpPce77ID4DlT07VaVQFbFe1IXraY
	w+HgHbB12G3nObPKVY00sBVNZcmUSecfkrKrqarU6lUFbKMom/SSueSLJJJ8
	oarU9FrgMrCNQdKLJrXo/5gzXF6rUQS2cxXp+1cHEWRvrfXecdEuDo+PJpsY
	LQPb+cxP327HqPPg3ainV8eqWmOUVFVjjOdfvhogYPzxG+6te2aLGUjlAAAA
	AElFTkSuQmCC
}]

set flag(ROU) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABFElEQVQoz12R
	MUpdYRCFv3vzP0l6myAW2roAF5LCJgsJ2GVJD1IG7FyEnQgWgRiCqG/mzJwU
	9wafDqf95nxwJs6u+SsAZhgPV+cfD6DpppvxQp/RvGbwW5ffT4DuqT1/Ovq2
	2exAtkB+TH+VMy0583G7HQwwd7+y2tVz9y0827lG6ZtwhDOn4+OGAbSptsoq
	27LDlp12uMORC0Bmw0BdbVVLqGzH63uH/QYABtEqp/wfyD0m7HSsSki9AFUt
	OWQVe0DYua80rUrRWYRacopV411DJpIlwWAnqTM75axpD1ga0hFWoqIKGKCU
	Px9uUlZ9mOcjeJqmBEEyxKmoWtIwwQ8I0LLj/c8vY9CioUX/oS/WjZf7Byet
	b51DivSxAAAAAElFTkSuQmCC
}]

set flag(RSA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAB00lEQVQoz03G
	T0iTcRzH8c+z/ba25xkamg1KkWA1D3UoQoSSpKCgIKGgrnWJIjoJ81JGiFC3
	rG5BHTtIUEYQRURUginB6lAesnnInpw5ZHv25/f98+sgQfDizRuY6MRE+4k3
	owvFuWo+L8AGAlpAA4iAKrAOVIA/gHfjHWziHpSzHdtPbR3sev3efJiBkGMG
	syNy/7U2PW32fUP/2eq1+drS0u+P4ZfRofM76zUzM+dKi47IWXJknbWOyOvp
	UcADMPt2bEd+Zfyr/6tpRBojey/mku0di8suipyqU3GiTtVL++tTUx6AQqGw
	uy8cGsRkKf2TE2u2JQ6peEqUSTYQOe7OZJ/cmTQAmOXp86hciRdONm79SJXV
	b3K9Wg2tkBVLQlaJhDdJCyEMABE+ejh25JDeLyVLrUSTI3bqB51JURIiYVYi
	5Yy/BRkYAMPHvL493s2F4HPVWBvdPXg9iAWr34N6TUScqlN1opoJTPeuC+bh
	OPL95sps22rESNDI/nOvHiWePa6E5WUiteTIKrMyay6XLhZfGj2Oq8XAj8UH
	ervObBt+8SA9/6kWtKHXTxMps2NWESeiIgDUwyWAkR04MLb59uXTK0AIKKCA
	/TcMMACAgeRf4EIuXwMYIBwAAAAASUVORK5CYII=
}]

set flag(RUS) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAA8klEQVQoz22P
	PU7CURDEfw/+FXY0hljQ2Fh4DRNuQss9PIVXoOAuFhYUho6YSEzezNu1eEQ+
	ZLLZnd3Zj2w5HJITIqKHzuIKDgZgMgHITChAZs8KjDNHeYbd7nvomzPznOQt
	lFIioiwWuVzmfk8ErWVrRGRraV94O6fTslp9DZtNPD+X7RY7LeSUUspar/18
	DjAANlL+DXS591Wl6rFiF4gB6Eer0uLU+u+ClBDDmvGTXn/qZ9hZHXJUhRzS
	kVQ3Kdzu/LDmbXiBsd9DH7eXd2LhVtrjPQwBI5nZLCXcsJCK1D/Dxqa1bgHl
	AHFmXKZXEvALP4llHgB5KsQAAAAASUVORK5CYII=
}]

set flag(RWA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABRUlEQVQoz22M
	MYqUURCE673/zYKyKshssJHgZQQzgz2BCAZiZCKCgeCaGegBzPQQIngNMRFB
	HFc3GXUcu6urDH4GdsGmKaqgvmqXnjqE+SgVAQEEKEgIgULsjDBCeH4DAGyX
	mwwJJZdbaUp1i0fLF83x+uu945ca8/bJb5chgXIVaLNMeZu+c/hkPz50bY6W
	cYz7XYDlEkqgzELaWWY5y5TfrO7+Yf8WB29PbyE0MkS3KJQ8MyVXebtjvsTB
	o4+vKC/3J6zX7edfLKaH1meDdtq0w0447ZRjjjZbv7b6/m5cHAA27r+MgGcm
	/qu9X728hyGhtbQD4PnSuTZAmyTG4jEe3OSndaYyK7MiFLPJSjqzgpWpun6l
	3j/DwAlOt7wwDody0Yo99yqzJztzShY5sVRV9WNTWKHhNrAF4szzjAagXRQw
	8A/4uWjBDx8mgAAAAABJRU5ErkJggg==
}]

set flag(SAM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABKUlEQVQoz2WR
	wUpCURRF99OXg0ZCTRxY1LChOAj6AT+gWb/RzB+p33BYgRBhEEg0kEhToiBC
	GiQUPM/e954GT1PzsNmTuxbnwkmAIywmAjbvbIphBP4lBdBsnu7tb9fru1eX
	j7Vatdt9G7+Og2JRNwXSJZ/3d6uVAgB8d2fr/OzaLJTLm53Oc4lTMkQO3eg0
	N3MyqVYjUABijGi3nyaTrNE46PXezdwos+BmzqmbzULOhBAKo9Hn8cnhV+b9
	/pgETTS6mU9tWQCQApYqKzG7u3gYDj42FGAyisw3cEFLEUgD7hFuXS8+MFDO
	/NNc0PNOyAikEUhIN4O0Aq3SkFxSLhQlJ/EHrWsiFBACcqFAoVJxEgoQQSYk
	JOQtIYQ8EUh+Vg+JtdMuPwH4BW/TXRBCE1rMAAAAAElFTkSuQmCC
}]

set flag(SCO) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAB8UlEQVQoz2N4
	BAbes28y6K9m8NzMELuXIXQnQ+B2Bu/NDO4bGVw3MijPZ2CYKFt7+O7du5eu
	XGGo3fn4Pxh8/f2nfMP9krnXC9bdzV13N3PN3dQVNxP7L8TMv/bu6/cfP358
	//7dtvcoA4P+ykmHn/2DgbknXwQ2nfKZdNG9/7xT+ZG+/Y8gSr99+5a+4joD
	QzkDQ/z+yqW3YyZduvr8y18wePX5h3vzaaf6U88+fIWoPnr7tVrOPpeG4wy8
	kxkYoveWbXkQMedaSPOZ5j2P/vz58/v371+/fv38+ROiOmPVDdWEnQrlB+0n
	n2Vg7WRgCN9ZtOF+8MIb/vOueWcfcOs6h6xaq+Kwqs8G+YZjUrVHrPtOMzC0
	MjAEb8/fcM9/2hXP2hNFG+8iqwa6++vXr6HzLkmGbxEp2G/Wd5KBoZGBwX9r
	1rxrns2njtz9AFH95vM3/bLDWkUHX3z4/OXLl8+fP68/+0QgYpNx6X4GhmYG
	BtG5lZvv/wIDoOqJBx7qZe3TrDiiXHpILnZ7w7abnz59+ggG7pOBTkpkCJ1/
	GeLLLz9+hsy7GtB4wnvaRbfpF5ymnLPtO2NZsN+06+Sbj58ggCFxLQMwmh88
	eKDafJiBoZ2BtZ9BfjaD8GQG3n4G9m4Gxk4QYihlYEhlCF16BQwA49NQAwda
	M+4AAAAASUVORK5CYII=
}]

set flag(SEN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABK0lEQVQoz1WR
	MWqWYRCEnzf5QUEEGzERYpEulZ12dhZ2HsBCsPQIqXIDbyKk8SJ2goVoJdgY
	FXdmdyy+X4PDtM/ssLO44FqDXnJwAMNsNnPGcO0dcP7sHJjMZNaDhgavXz4c
	H9xUXjhS7EhXl5c7APL5x5dO9zQRqxPlhhJllA+Vqkjr5GRgxzCTnnbao9Ck
	Ene0UkmltAFIe6Bpx257nOhKevtRv1vPT+vO4X8AG+BptTz2mOj9t3r3Sd+l
	+7fr6T2l9pWwB3aYHntcU24nenS3Hh/pZ9WTI2WuL6x9JaOoujxWVxCp12dK
	1KmM/sXH9ga4rZZGaiVFKlFSK0qUqli46QZ2FBof3zpWy9tb0VoCg1jm1HRv
	Hli8ggJDQfH1DfB35mGKebjfeNMf/ixbkSwt/F0AAAAASUVORK5CYII=
}]

set flag(SEY) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABrElEQVQoz0VQ
	v2tTYRQ97/VFUUJ1cJAHUQpKFQqGR0uNg8FfEBqfSyf/iU4OQgcnV0GKi4KT
	Q+1mkU6KOJYOCUFpa1sJNSWQKsbyTJp77/cdh7QIl8M5cA7ncAPgOXAIAAiB
	3urqk8lJAPAe/gA+hh/A4/9FQDY/fw+A9yPF4vbU1CPSARaYjby18KHSjHqE
	2fJyBEQAW61+GNr09GeyAziq8pnyo1KUKhShalAoDBu893AuTJKdQqEDOJpw
	wfhBqUIVig4DUPVACMA5AoOZmRpodMIF5YpQhCIcHJOJCc7NoVaLADMLi9e2
	x8bapPGF8r1QlaoUoXMslTg7y9IN5CLf7Q4nSeV+nRC8NL7Toxm5HMtlpimT
	hCTJgPTeR0A0frU1fmkXr4xLQlWOjvLOXVarvHhhaFWne9le828zXUojICvf
	/sI3ikXlufOsVFh9wLOnenQ//nxr/GzU9+tr+2ubvzfjfIzXiHLByuX16/x+
	i4+Tg+KV5sls59enrd31je5Gu9fuH/bNm4OL87HzDicQPE3P+NO2eDP+ii00
	gA7QBQwYvtAAOZYG5PEPUu89tvQkTmMAAAAASUVORK5CYII=
}]

set flag(SGS) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAB1UlEQVQoz32L
	T0hTARzHv29vyy3Z1mZTXrGDtCg0EgphUlF2iQZB1E4eJHYLEfEQomWHTgbd
	s2NJIQgeZLEg2MFaVGYgCB4akVCSf8o55/be7897HXbvc/jwuXxMZ3w0ev3+
	2yKexowBq3O+cnXE9D5MDz3Km0AEiANR4DAQBEzAMIBJ7/M16r2wni+ishvr
	PhXvSU28+ln7+IlIhZWlaZdZFxaGDe84fuUehqubTt3WGoVioX3bs1p2sz8u
	VR2PiVjBJI5jJ5OJQmHUf6d6+fGNW+FquVZc9p1uC18887uwPO+22d/2iSiT
	6cnl0q2twbW1jXx+pVCA79DEVHvCePAu+Dee3Gtg8k/6xEA/qdlgIaLBwbTp
	9+6NvezoiGQyZwH4z81OjW3f/L4ub2INT+TL4pNs5/nxrgDbNrMZjQZnS+/3
	UqX8ayN7OwvAf3dla+RKSGSnuBEQ9jH7DlZXh7+6RGBubO9U0+1bx/RkIhIo
	lzcB+ACXWYlUWJiYSBwHRC6zEPGz6cUjR/v7+oYabu/c3BIAP0AiLrMyC7MQ
	KVEzhBnPX5RmZpaYpV4/SKWs5lBnFsuKMouIiiizMjdDRFwRVXVVw6ouAAPo
	BioAATZgA4z/8g/i+CQpUQfuwgAAAABJRU5ErkJggg==
}]

set flag(SHN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAB00lEQVQozzXR
	P0iUcRzH8c/z+OidV2gaR0L/BCkwi4YKaiiXootbpCEjgoYgoU1oCaKpQCSo
	ISqIwiEaCvSICANrKZOChh4s8go06CrPs868P8/z/fdr6ZY3vOa3V9h14NbJ
	0WdvSrmpcwsxLmTvZHYmD49d7l8cAGqAAAQYQAABgZcdnBg/LrO9h3bMPCG2
	r/uObSt8GHfb34dFVceqTE7E1FREH9++57lEk7sygt9FlFdh6lIpV62XOBjy
	spE4ZoURi1Xr2LIxlbt7P3hnm3anu1r+rlgQuaaEn06Xg/pCtTle1VrkXx18
	uC65rCpLK6lrU+cB8kdO34yCxNP+s5W2zkLz+tyeU66jY6b7YD12FKsaeyAf
	1LlmWUgB8gceXHq7ef/ct0pYbsn/wYvXPye6M735aePYYPNz7c8XR7nn0WTx
	uhkDEpzhE8OvCt8LKy9pr4h686Xw069Y+jwnwlSN2/wvYzdqYav1qR4FyAfI
	qbI4X9lTZjbnnGdCrMQ8+eNIuCGEteanM6ICUACIiDEriTIrsxErsxIrs338
	vMSzQyIqUuzZ2g5YAESs1pVOiSiLsRiLyv86VRNRUaeaVDUg8oCLQKUxkhpr
	pUFr0AAB1v4DRzlJ2ewhEaEAAAAASUVORK5CYII=
}]

set flag(SIN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABJ0lEQVQoz42S
	PUpDURCFz73vQjQknY34k9IiriArcD3au5asIVWKYNIpaRRMHwKCiCikkTgz
	7xyLp4KK4sd0881p5qQHgEDZ3oZZ1DUBAgD4YwIAUAjszOfV8bHNZry9zf0+
	1+u4ulKEIuDOCLkrQu53o1EBUPX7fnkZk0k5OdkMh/nwMO3t+/RC7jKXG83k
	Xh0cBFAAqK6rXm9zf8/xeOvsTBEv5+cyp5vcZC4zudOdQHUKtAaDfHQEKa5v
	fDZ7HY+bbLo1qszonrvdx9WqFKBeLGw6FRI6HUQrt9uMgHt2b4IRkTzS7m4B
	kq/XudORJAiCfifn/LRcFgJJkgT8ZTfbAArJCvjPAQBEFJKfNj5IKeELCVDz
	zQJy8/zMd4LBb4AMEmTTgDfsYE4M6iXffwAAAABJRU5ErkJggg==
}]

set flag(SJM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABVElEQVQoz3VR
	PUsDQRDdvT0bC8kRLRITEW0sxNJG8E/YWYhgJ1ooduIvUPAH2FjYCiG/Qgio
	CLEzRlDRIiwEG3fnw5m9BCx0WN7uDe/NvZmxL2YUc8yTmw9fV8t958gYSsny
	Ab8wl2xxcizIzGfbdWtt9fCAEQwA64kcFUkwxqdWO0+FmF7f5Pr0IDLo94Vh
	opCELSdQCByiazZHfzAoLNSb1AhD0KpBqcoWTVDMYhRXeQNRbJSWQJTMlesW
	/xVCWxoOrdu4O9+Z/fARKXkmEpl8KIIgRdS8ZOrFxMVexyJiWZ4NH12+n27V
	+J/Issx7n/ecm97fhd5zpdWOydJgfY2Cdmy03ThqI0K+uNDt3ObSJqeRCVVt
	MdN3yQiaVKU+SIwAatMqAMhq6mRmSofmGs0MdfAmjd8BKBuRknnbHa9w3vti
	5WZwv/pYrcJ4x+WCzRglfgD0nlqSGDQqbgAAAABJRU5ErkJggg==
}]

set flag(SKN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABp0lEQVQoz22R
	T4TUcRyG39/0m+3HTsXY2CLaNkoiiqikTZYOU8QqrchEf9Wqjm1FNKeIZdUh
	rUm3zGlkJdnS1navYUVKzLTW1LIU6/u+n++nQ7O3Ho/39NzeBGPAEjpEQMsr
	IABCsh0TBZRPdpIEFYwOjgKIHqNHc1M0i5KUZTqxjlNP1Gxx/pdI1uv1FCkA
	b/5pmZtFY6SZ0bitl0Mr+fBGvF2plssXUm/2bdrw4QpSRMToFk1uijRariuM
	bNbLcd77FnbuOdbdXSgd3nVo99ctK7h4ACkAg8klk6T+tTy+io/ucvYLyfD7
	1dN88nN4X231ffoCAaQQFI2ByOvSVhXmOHYrfJ8jyZ414epl7s1qOBd8kehT
	BFIEmLS+qFPFMPv64OTzyVY7hMDenvDgJoszwcfpITiZkBFIkcPQRqY/QuPN
	YOnocHsBS1PPsowTI0yuBZ/v1JBcEpA+HsB0VZ8+knF6/0Bp5m2tcj30f6af
	DU466SG4CBnMACQALp4/IzHrYpqzO6eZf0e8oEtOuuSSm8EMZu1GI1k+GUd2
	oFoA3iPi//7jLxZTLSDsujZ6AAAAAElFTkSuQmCC
}]

set flag(SLE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABCElEQVQoz32R
	PUpDURCFzzVXQ8AmoIaY0tdmCVlVlhDIWmKRVQixsZFYpwhoE7ALwp0zZyzu
	e/6hHqb4OMwfMwl3+CYBBACwY3VAgMgAFjcLAA6PCIpCMMzDKVI0GGUWpLi6
	X+Xa99leVDNAlzNoMpNZWFGpPOlPQOTZ1azpN8Pe0MMdLonBtn2QogdNZPAy
	X6yv1+l4tMGgByAiEAjEX0op7fevWULNjogP+FVISdKJpM6I/4UISWk6fZzP
	x4cD3butGV53p9zVOh6j0dly+ZC3291mc77bvZnJTKWolBbMopis1Bo1zQB4
	ygDNNB6ftqemzMKshTrTXe7hDkAJuP1848/QF6iBd4FScfY3YEy7AAAAAElF
	TkSuQmCC
}]

set flag(SLO) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABRklEQVQoz22M
	sWpUYRCFz3/vD8oWgaBgFjux1EotrXwFCxEfQ7BTLAJ2Kgoi2KhFejtbfQMb
	G7GJRViFhM29uvznzBmLu4ZV/Bi+OTMDU8ZxxAa2J2+GE2RXALPZLBOrVaDk
	7HQPAMjMXLcNhmGo0+PHz/cPFoe9Y/fhZXRd/o9Siu3Sb3988ujC8bFu3zzz
	6u1iGMIJyaKplEyZtOSdc6dePv1Q43DY/7a6f+1LbF2/d+nzrdc7RE+50Wxu
	NOnWTMbRksCPCliJN3uLs+/2xGCeb5lUUtmUbQqRFBQAXIEa7t73V9uRRTOT
	dFPXAgy0KGsbdAfUuos7N8YHy+WBpWgy/5iMppDcZCkYW9vzZ3hR7+J7/+uT
	f34FmWS2lq2tw8lGhKKsLl4BqoGOwnyeJBQQQRYSEiZLiJjKQBkBbxT+Hv85
	AfgNXohcMctre+sAAAAASUVORK5CYII=
}]

set flag(SMR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABU0lEQVQoz2VP
	O0hbYRg9/80VhIS0oChkcxEsXTuKSwdfm0t3V92FIC46CYVC6VIHJ4dCB2fx
	sTgLItGlqKASMKDBRMz9v++cDtfIBQ8Hvtf5XqHdE4g+SOYmd1mEkQRSENVB
	AJAEBABSHgWgJCUq4K7VSfPJkooOGaUAhKI6hGBk+l7tHh/OViB+/LxZbMgv
	TtD/QBKEH3vrzcbOc/O+fdu+Odla/bNc7KEhoO7f50LzSUYZ8WW0Ubv8dTYy
	342auN69rswc9qajy1y1arK98ZjA4FTM6Tq9+JlWk/LLUaVz0OoOHN/8jq7o
	ipRRMKYwuoK5jDBXd3BpP/vwlWtuLzvl+tNz4lJedQpmKYzmJXNFwlwdH/80
	pI2/U71MswtjV/8U4+u1TiBDiozGZLiM/hJctDA2+c2p85ZqFZjgHlxyAmTA
	YhcZYUSWE6/hW8b6JAD8B7ZET6EOwlYHAAAAAElFTkSuQmCC
}]

set flag(SOL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABz0lEQVQoz4WN
	QUiTYRzGn7Xv+0gl3MKCCS0LVgdDSQyExU4WEVGHygiCWF285KkI8VKwaJcO
	UQQdWjQIpnjx0mjhoGIOYY7ARtGhSQh90Sq3nM73+b/v12F17nd4Ts/ze3x+
	/1Ii0Ts5+XFq6kAy6WrdAAwAQADzLzuB1fsX4kOjsFKp8NjYTtvGxMTugYHt
	pVKThNZGxBMxQh/FOhldiA298zquJh4/8QFvU6mDw8Nd6fRP11WtltHaIw3p
	kbYfmzcvPz/UX1xZt2+X7Oz1rAVY9boJBv2iTXf3tmZTlPJEfFTO6dibc8fm
	0VnLVnF38Ut4VxiAFY0Gxsd74leqT1N9s7NrmUyNdGBaNy5NHx4sfGjItRfu
	lih6pCEAq1Co5fMhKszM/Jqba5AdJ0YWzh9/1XSquVV/ctGlUcooCkUEgAWo
	XG5NxMtM/x6MfD51tBjZt1Td2LpX2KjU1pWnqKlE0ZCa7YEhoZQTP/Oyv2/Z
	BMqvv+24U3Rp2Ba32yKi9d8Ha3SkEowtR/YWv0OevXfyK1/pUem2mxQlhqK1
	GA3AunjkVihwtnd/5VM99Kj8Qzx7T08XNUULhWJEjOg2RgPwFR/AdfCwjPk0
	sIn/8gcg3yvguq2bYwAAAABJRU5ErkJggg==
}]

set flag(SOM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABP0lEQVQoz02R
	sWqVURCE59z7W0QvREVQFKJ5AUtLC8HH8DF8BWstrex8BytLG4mFrSAIRrCI
	EpPLzTk781n8/sRlWabY3Zlh2uErTneaq5Iq9WiUVLnsvsxJ08mZXjyVJMC0
	oEQORUvWlVUZhwrDvHx9Nk2TJP08xyhRBVuGYSqUGWaEMrc3TckqEcGRowrD
	+n3B4wOePOBky64YZhSjKKOeqRSrGdl069E9bu5xf58mnj3k+A/vvpBQpiJ1
	rXrJkWcB4cM39tbc3XDnKpsrvP+6qDJlqTJVyWGECo62g08/OLwOcHTMry3T
	avET1DO5YtrMWCbhYJ83R1yYwxswuzcVOahqUqW8LjOWg7ef6cUIH7/TRP/3
	Xo5UmrRLZXXrmhaSOas2b9gqZDeDI/U0PT/X6RJkj7ou8f8xJyppo7+3bXjt
	qDFgVAAAAABJRU5ErkJggg==
}]

set flag(SPM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAACA0lEQVQYGQXB
	T0iTYRwH8O/zbDO3wXi3udlUBMmSDLRLSJPMIpMgakTQJboEdckOdSgIKugS
	FIWHKBAq7N/JQ9A5ig5d/BOOkgnNtuncq69ze/fvfZ/nfX9Pnw/bfxXzvVPC
	ocHl2e3PDwELIKAOeAEDICAAmAAHHIA8a6mp1rV7dGTszqFJN9aXHO2bmEi8
	e/HPGxx//7Lg104eH+t6cr9cozP9B4YzKz84ESkoYdtuzcznm2u5xqXJj0qu
	5fK71fJGtZxPLzdb9axe3JA2AIePl19FC6vxv+lpfVFKcm2mhSo+b/NUciEW
	MS6f/x7VjESsdHBfVgsZALGVdFqLRPf42K7Nbt9Ychjr61nv6dy4kvoKiEy2
	Y2gg++tP59yXoYtniycu1HhA02wpBRFIuWSfHv25U/Z1x4uB9pYjpSLRqDuu
	I+PhEikXcLylSj0RCikwUspVODyQGe5PB/216bfJRMfW0u+uljUYDxsTR+ef
	vbkFzDId8D9+oHL53I7nppGKaNtP7874uFWutjWaEA4F202rIV/PHVvOnFtY
	fMQJ0Ls3dxMF1bKkS+vF0MyHkULBt6Uzs0L1Khk6V64IBmrgTUB4HcCV3B/o
	8e0N92pecthqcez5p5GWzTgTQsC24eG2JRj3SMBkm0AF4MA34DomAQFYgAA4
	YAIcIKACtAF1IPAf6ZoMYzvdd3sAAAAASUVORK5CYII=
}]

set flag(SRB) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABP0lEQVQoz3WQ
	vUoDURCFz2ZvFhTTiPgTNRIxqVNZ2irqE4hY+gZaBDvB1wiikFYExTJaCoIg
	BCRioyhBJSubFXF35ljc7LIgHqaYOXxn7mWcZ0ABBSRpsiP++EaAse0NkCCV
	FEJIJZRMK3VemycmBqD8untUoKtmfK0oyrfLz0LYU0BIkna3V50dvKDUmFTA
	HRku7MwD7LZurDOgM72pluqLc0vXPz1QPpbRWW0IWa7vjjZeAAUJEFQAtZnC
	bbFkQKUoVEA1E5OV81PEcdRug/YcTDIACMAASgoooL63rsLjJkmvOAWU7eJB
	IJEThmE63K2sVw72lbyv79UuzpgIgKp6nuf7vtPv9x3HsYHvzsPT4ZGKTm9t
	DlUXLGppAK7rBkHg+L6fz+eREUlLZOlcLgcgCAIjIlEUWVdV0z/8p1+bif6F
	7/cjRwAAAABJRU5ErkJggg==
}]

set flag(SRI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABl0lEQVQYGUXB
	zU4TYRQG4DPTGTu01FI1Kor4k7gwwaULoyZ4A25ceAPu3XkZXo24Ml4AJiQk
	SKQaFRVTqAmlfzDfed/zuvR5snrvhf3HkIwhCwVNFBGCRJEKkCjM7PVWLzN7
	k8Ky8Cfnx/uz/vulyaHCQTgdAqpefe3+qF19Lcysdp36mZFGSsXuRqvZmWKW
	1XMo0CjqeorWpfmPzebNe3lhpjCFaEGFKzgdcPi58fDlt4PtqrdywsTJUfza
	as2OC7+F3BQkPSC6EZLTEZGai/O1578v3B59etdpX573bozoHkQeCg8ALrrg
	Cqe7lFpXZ3sbbZOvv+qvPj7sXJnSnWShIOAeEJIRCqc7TvX9w8Ld9YFZIuBj
	7Lzt0iGwMNHDHckIISkSU4mkPzvN8WCpe31ysN288+gINcMRZKEgiAQXXO4K
	X+jV3dV6f7MqmiZUqPHz4/LKg9nwS55lyEVk8laRR5apbJg11p79PTs5V7Yz
	qWSUykuvq2F/sbt83L5YZ+OtpxJFKkC6ggpGQKAEiUGKlIWFzOwfmFRzUr2a
	cfUAAAAASUVORK5CYII=
}]

set flag(STP) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABeklEQVQoz02R
	vWpUYRRF973zZW5mmLkhKIjgT2HrE9gL/kTEiSiMjaWNlYWFj6A2WlgJRm1G
	iJBASBFsLH0ACysLgyAxRBGdnL3PORZxJLBY7Hqvags4/xT4DQAIQDMfxmYu
	KOeA3Z8PHl9A5RERDvdwhTylkJxMyckQg2+frZc+kJ53V7bvj9zdFVS4ggzS
	ySDDzM3EE4OTqFEA9P9k1fiTj563GemZBijBCMu0BDMtnJ2aG0dRBwD33hcN
	vnH4XG1jbcMO7f2mtV1ru9bZt3drttDYsMtTLQoAyNOY34VtZVKyyYSTN5Ts
	0hWuvLCXr82MN8aSUACkK13ZN5xWJuvaRiM2XVu6ykwb32KvZ9dvEskASgAV
	OT1iWlTcsdhnplXzvLzMH1NLED27NubeVKWjz7soAXwd6tMcH54lt/59QueB
	mZQbnQo/s+AfHqHsADvzenXx+DGj5pxOORmUS6BcCik8wumOX6hWgeV7wB5g
	M3Ro/M98kH+Av15tSZVO5daBAAAAAElFTkSuQmCC
}]

set flag(SUD) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABOUlEQVQoz5WP
	sUpCcRSHf957CVP0Sks4uPkALY1Ba20+QS9QW0NEUwVBDbX2BC1NQmtQb+AT
	OOiQ3SI1Rfyf3zmnQTODlj4+vukHh4PqHhxzdUkBpsAEGAOfwAD4AN6BHK5x
	s3G5/ziIaDCDqlOhdBKki/hSR81mAiKr9E82J+f3WSTqIlB1kblBXIKH4CK5
	Ws2ABIQF71ayw0Z6tX0Wec7d/AdbBHFs7XYEQF0Z2C31Dp6OOytjL5eXTL2c
	epp6mnqp9JLPRyBoKioi0kk6Jw9H+uvCEoCZRSDUSGOwsK7rpzunOcffe3cz
	S0DM/iq+FS92L6Jp1J/0zczdZ10Qx/FwOExgoLPQK2R3WeO2EUIIIYjIvCIS
	Aimk1uv1VquVYIT862rhuVBdq7KspMwgOStJ/QYAsIV/8QVvRk91C7xORgAA
	AABJRU5ErkJggg==
}]

set flag(SUI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAAAsAAAALCAMAAACecocUAAAAwFBMVEXjAADl
	AADnAADpAADrAADtAADvAADxAADzAAD1AAD1IyP1PT32KSn2Kir2QkL3AAD3
	Ly/3Rkb3R0f3UFD39/f4V1j4W1v4+Pj5AAD5WFj5WFn5W1v5+fn6Pz/6QUL6
	RET6W1v6XV36+vr7AAD7RUX7R0f7SUn7YGD7YWL7+/v7/Pv8TEz8ZWX8Zmb8
	aWn8amr8/Pz9AAD9bW39cnL9dXX9/P39/f3+WVn+XFz+X1/+eXn+enr+/v7/
	AAD/e3r/e3v1l9HgAAAAYUlEQVQIHQXBwRGDMAwEwJOsT8yXdtJ/PxkY0Mny
	Zde+AC4Av/txuPecw46TAZWC/tAVWBJBpssvhMTsXQoYiUyWFHibSlZL44hn
	LVaWv3HP3Kpe2zTG3ETLrcs+kgRJ0h8dNE+C4hW4yAAAAABJRU5ErkJggg==
}]

set flag(SUR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABOklEQVQoz02R
	vWrUcRBF7y9ZRYhZhWCz6NtICn0OBWux08ZKRcgDpNTOJk1eQLDWV4ggC+sH
	iSC6M3fmWOz+Q4bDMAzc5tyhI+mfttMTlkLyREx7pplCz++/kNRUNyW7q9tJ
	ue2yySxnpztPjk/Gz/XF/NoegBCSAJCAzQk0AGNnnP36OpB481bLpaooy8bm
	wTmVfLiBk0wicY7F4uL9u1lL48dKy2/YSuPkZbKXkNwLngSZRJCpsqQdSXKR
	ucXJabAI7ganQSURW+zeBChjk0EG6+Aw+BR8XHMY/F1fBpTZ0qylsT/n1m3Z
	OAnzOqd8crC5U04O7lianf/5vn993hsT2kpJB9CTplYL7Y7d1eps6JkePXyc
	7ey8tO7OrHTblMtuN1VdX159Hnoq/Z6KjCulhtRXPpv6b+o/841pDPbzyUMA
	AAAASUVORK5CYII=
}]

set flag(SVK) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABfklEQVQoz2VR
	Oy9EURCec/daLPGIiGYL8S9IRAih8AMoSIjKo1CwCVHpVAoJFYWwpQgKhSBR
	eXQeIbINK977QHbtmTNjzr2y8fgymeeZyTdzlPnIABDkQWQDspb8gPJACV2p
	OqGQaGb2WxxrWTEHvORPvD8+u/74zNIypN+ZidFIpmh0hP9BKYWIbsvA7Uhv
	dfv5VUkizpNTEF01Zxdzi/EsBQySMYSGEUVTVYUbGT53Dw6TbS1VbdksDw5B
	eRn39JjxiZfb1GWyCBA1kpYGTTmkcE0QzL1jEIQIGeKFOU6lObriOPyWc5BY
	GxCCqFmjdYx3GtkhKNRvuoY2N+/i8xn47BjrbnzYK9bGDtGkNDvIciD1aa8Q
	VLsAdZGZgvJQpql1er0g0omhna3U/hFZNtoTj5PGwtrw7s6K2wAQSFzTSQxe
	Y7P1zWr7OLixVq0153Is2ndQCydVmqwEUPJtbl8/W6Y2++3IO0T2tYiRDaw8
	nZ6qD+8j8gK/wz8lwRdL30e5pCYihQAAAABJRU5ErkJggg==
}]

set flag(SWE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABTElEQVQoz02R
	P2rUcRTE57v+NEVEQVEIEgRzAEsrKwuxEe9gERC2Mm4jKBaWNtp6hTSCpUUO
	4BkCIZ2KqLBs3ps/FmZNhscwxXxeMwMP3mAtvXoNA8aFxQuUUYUiVnUWuiYA
	L+ePANgZO0tYgeZ7j6lQptwS5bZb+jT/MAEAcvxzKQcnR0kjOvz2p+WmWiqq
	5G5tX98EaoJtQw5PLv5rxzWN1ZKzkpsqqqi2WgZq6ADjzgJ1lBBh3HEnHXdc
	cZ2G9Ni4/fvLwQQCUdLxGkidYmftihumiQlGwphJweeBc56Ke7hNDNx9/mzx
	5PD7L8qfH75LOq57+3tNltyrWdEtk9q5eeXr2/cTVqTVUtPrZ1VkUS0XqiEO
	c2bONoDjCVVNb13dbAqXbiEN9/a1y5SbpkVHsmTZgAe2nv4f8sfHfRAmbuze
	BwjU+gwQMIC/3Ll5iEbYURQAAAAASUVORK5CYII=
}]

set flag(SWZ) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABw0lEQVQYGR3B
	TUjTcRgH8Of/32/LWlEWISXtUkM6FBh4DMLUVmC3LkHniqCLHiocgpRQl947
	VaAeiiKKiiCSTt4ioTcLDAqcHkJiapu/PS/fp9Xnkxy7+q4elf4DoCAGVKEM
	VmVFVGVWVkTWlpAGhOVTpSI1OcEd/o8ZTA1EcDLA4AYYMDA+FcZzfbnsdV/9
	5QC5OcyhDnNXgripQ9wE0HRtW2+4HW6ctN7z8ytzc24WXH427JWTKE+M3f/z
	5dPHW9eWfsybcGxIa6Fwd5JSEIkZJVrsXrf5QP4loEnaaPDM7PeWjt07h4Y7
	jm/vGrv3jVlEqkSpEiVkhdK21U1bR14s9vcfOXq4R0RqtdrgufKzybf5rjOz
	zy8cOr0v5MFEQakpnYoHOdPaw9MPHzxSsxhjCKE8PFSZ/vB+sPx1/4n6huLe
	6iUlCimRqW15eked1nCjJPKGuSqSNSQznxeujP6uLLRNXNQ0k7S3E1GydJly
	3SNYqbiJu5AZIGZCMDcmMKBu6oawcUfl5pPQV398lvcg65pBk2bc4QCYBRmC
	u8ENDoezl+OupHPg9eJyZEVkjazMcFViJVaCEoMYpEoAKWh9+Ask7mFOZkF2
	IwAAAABJRU5ErkJggg==
}]

set flag(SYR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAE4
	SURBVHjaYvzPgAD/UNlYEUAAmuTYAAAQhAEYqF/zFbe50RZ1cMmS9TLi0pJL
	RjZohAMTGFUN9HdnHgEE1sDw//+Tp0ClINW/f0NIKPoFJH/9//ULyGaUlQXa
	ABBALJ8+fuTl5WWA6vsPIbECBkbGdw8fAgQQE9zRQKHv/36uurfm+//fEBW/
	/v+df3vRpz9f4Hr+/fsHEEBMQAw3df399fuf7Ft1ewWEu+rOyt2Pdk2/Oh1m
	BcOfP38AAojlH9wNDP+DFAM+/fwYohwIEYhUCn/x7XmMWjSEywh2MEAAMb59
	+5afnx+/6yGyjIyMd+7cAQggRiArLS3t3r17v8HgFxhAGCASzPrz5/efP39V
	VFQuXrwIEECgYP39+4+kpCRQCigKlIOAP2DWHzD4CwNAxQABRDICCDAAz55K
	KgzD0rYAAAAASUVORK5CYII=
}]

set flag(TAN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAByUlEQVQYGTXB
	S2wLcBwH8G/Xv2q6bomtVM2Ees1CHJB4hITFTBOJpBGWFDOWaki8FpclaFxc
	SBw4WDzvLk2aHcRBSDwODS5cZUpXazjU0v5ef03w+QRwG2jgHwMEMEAAAeaA
	KI4PYkSwewB/OdQxsXcCgHkzb+pVTNWkJRmTg4s45uTRY06nhZkLhYKDA+C/
	/i6rVzVlY2VFkI/28ZYgfy5x7ibVasTMB4Z6d9yHg8HMq6l4FWVlXRajseXS
	Mcf3JunZc2o2OdRG2SzvORR/+QUOgELFi7BYm6T7eSDClWnOXeXZWWpZv5ZP
	j0faexa++bH55JUTDgIx5SYvWSDZVdJR5ycPqTjFjQYb02iG9w3HmpiXf3eh
	0tyO+i+HBtQktUb2d9LP73Ixz5UZIuLkUjozHlzZFy1O77z29jIFkOz0IHNY
	jNw67g3R3TtSnCJiFqLMYR4c7q5q4vyr0dfVTQSIQs1DxH0YgpZl5DpXq9wS
	76Zzlyze3/Pi27bJj5kyxdi8mBeDGCBwG1dj7JSEw4lEgndt1dSR9lBYb70/
	W6ptiET8ivlePFQD6r0aQBbAf/k8Usdwo4SnDz5BukAGMYiBDGIwgwBR/AF1
	5CkSC6NWEgAAAABJRU5ErkJggg==
}]

set flag(TCA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABxElEQVQoz1XR
	PWhTARTF8fvSl++kjWla0saKResiKIioOFgR3UQq4iji5tbBuS6dio7i4qKI
	H6MEhyKiddFUBJFCaKRKCGLTptV8qO+9e8+9zyFLC38OZ/85b2fnFhOHFha7
	t7rlnIs5//y1XHXm2OiVR20iEIGIdwRn4uT80vxZGi8Fq6vU69l4aXB46GVd
	V75vQQ0wgQImpgIr31lwXzTuJ7/mY8tvgnZH/3rxQs5TZ/ofv6LjXXYn8t1i
	um1Rq28lJCwSsVvee+7G1OH09o8/tW9OfiR+YP9mo1VNJr0NYsbt6fLwnkGv
	Xf2yXrpbuU7EkfqZS5FU6mlnZC022ggzjxNHIgenWm7GY4sOxOLFy7F9s+gh
	VF+gROziU+X5ZG75pzUt5UDev659HksfdQgcdP2BX/WH69uMaDzq+uCQiN0n
	7/zCTAzS/oghwMS4VvdWoKyOcNDpRZay+WzOm2yyCIj8CBEExhpCRcAsGogy
	qwiYvHuV0xd+N09tbD74cELJJzKXCFAVUYGKKENZVPqrutZK3nx20VQDhIlM
	SMQuEQvCsUJKYIABKjBR7R9oFqqq5miopkTmEF3dbbnLdYe09fsPMiU+wnxv
	qP0AAAAASUVORK5CYII=
}]

set flag(TCH) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABCElEQVQoz32R
	PUpDURSE5+orRLCRvCJFujQB24AbcE0psoKUlm4jjTvIFpIqVZoQK/+QOzPn
	WLy8oKIOH8PcuZwDl1uAe+ADRwWg3r9Se28a4HU+vwMQkRFppxR2SCmFGJTF
	oIL0cvnQAAHEbvdipx1k2iaDDNKsrnStJj0aXQHvzXR6M5lct+1lZFrRjUkh
	pW0pTrTtxePjbfF+X9oWQGYikci/VEp53mya7rFddQq/CqWE1CCiL/7dn1ky
	I6JwMimzWR4OsFPqcVopZV/CLoPB02LRxHp9vlrldgsyyaw1az2GUyNCxngM
	oAngjMJwmCRkiCALCQmdS7A7Aihv3Uf04PvxxxWAT6fvZdSyVnfbAAAAAElF
	TkSuQmCC
}]

set flag(TGA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAE8
	SURBVHjaYvz48SMDEvj3D0TwCQoCaawIIIBYgPJ8fHwMd+78X7WKISSEQVX1
	/38Ghtxcxj9/mP/8Yfr9+/+fP/9h5JdNmwACiAVi8P+WFoa/fxla2/7Pm8vA
	yPj//n2QIiD6BSR//f/1C8hmlJUF2gAQQEwg1UAzi4sZWFj+FxZAuFClIHU/
	QeQvqB6gBoAAgtrAoKPzf+5chv8gCAIgFQizISQDEDEwAAQQCw8/P0NR8f+H
	D4CuZPj95/8fqDRcHdx4hj9/gDYABBDIhv9//4D99Auk4TfE4N/IZkP9AHYS
	QACxADEjWAhoAIoiVNUg2T9ANzAABBBIAzM4yBjgijC1/QFq+AsKRgYGgAAC
	aWD6/YdBUhJszF+GPyCdjGAjGSAkEP39C0FAxQABxPgVNSIZcETwP1hSAAgw
	AP4dTt/+nGWfAAAAAElFTkSuQmCC
}]

set flag(THA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABDklEQVQoz31R
	sUpDURTLtQ+KVB2qi1MXdXJx0N3BjxEcqz/gz3QVuklxL35F9zrUCvaeJMfh
	QWuhGkIIZwjhpCQ28LbfyZIAnp8BpAUnyHSCkRLIJDMiI5JMcjkalcwE0Ora
	5C6UUhaLRbm9e3m4v/z4WMlppWzRVIqiLFoyw7SP+/tPj+Pm7fX9+upkNvsk
	zXDQEYpQrY5QrVrrYHAEjBvAbU8yGRnMWtvartU1MqrbCwnADfAtkYwaZmgd
	/zu7VkU4ogLLpnd4cXbePzjskkkqaNIMkQ6aFGnSkk9Pe9PpTVmtVp1Ox/Zf
	z2kBoJQyn88bd7t7wyHajhKCEEsEyA1tSJA8mZSv7SH/2bjFD1//ZYwabPa3
	AAAAAElFTkSuQmCC
}]

set flag(TJK) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAGC
	SURBVHjaYtzPgAD/wAgI/oARhAtnQxgAAcQClFatrgaS///9AyKGv3////n7
	7++f/3/A6Pfvf2ASyP73+/fhTZsAAogFbOL/X0+e/v/7F6gaKPoPqAdIAhUB
	yV9Axq//v34BuWyyskAbAAKIxezrV05OToiT/v//DyR/3Wlg4tH+z8D89+MJ
	ZoXq/4yc/8GAkZGR/elTgABignsApPo/w++HE5gELP///fb/zwdmmay/jyb8
	RwJ//vwBCCCmf//+QVQDwe+H/cyyeYyCLkCp///+/GeVYpSr+HuvHqoc6PV/
	/wACiPHjx488PDz/Ieb/B+n8+7Dz/7d7IA3s0ozytXDjmZiY7t+/DxBALHDj
	4QxG2VIGkPb/DEiOgfsQIIAYGVQZ0mrS7r269/vP799/f//68wuIgOxff8Ek
	SPDXn7+///z9qyKucrH1IkAAsTD8YPj9948kv+RvsChQDsgAKv3z7w+E/PMX
	FC8g8O8v0AaAAGJgEGdg4GdgYGcgEgAEGADVtDiKtIsdZQAAAABJRU5ErkJg
	gg==
}]

set flag(TKL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAB0UlEQVQYGQXB
	TUjTcRjA8e/+rEltmiINFF8y3w4hic0gOgZGUF6kQ7cu3cI6RdAxJKI6BF66
	FQRC0qEgNIheqaiMJtOSWEY1Rurybbr09zy/59fnEyP5BgcAoEbYAgfr4CAF
	EThQUFAgzhaXb7UBZiERNjPdM70dc3Wp5WBaKqc+ful8nd2/tLpL1ETDo9sv
	4kQAhQUXC3p1uGX0biFdU34506oSvGlf63P9N3dn4mixVNPcWAUWYZgP3oet
	TX/pRn74zOHRh6dr46XaqqXG3YU/a8mOpnyma9qpiRhohDe/LVqR44de9ezN
	nbuSH7nQcXNs6Pq9UzM/mrz6iamDPW1fnTNRAxdBRTWIWn9XLpnaODs4dn7k
	s5Mg4p986FXVGK4l/dOJqQbQCNRbULVfC3XOWXt6/kjPlJOwLRQ3Zbxcmk+/
	nc43O/EiHjQOJhqcWO5784HO2bXKjpP9T/v3vf+9WHft8cBycU9Nw7f7xYSK
	eR/AIlBVE7V3s91/V3ea6mQ2s1KpSibXL5544CoJ8ZqbHBIN6gGLg4paQzoh
	rv5ZdnDbfzrWl62vXgkmC6vVA4vt08v1rQ3V3oL3BhqDcXCgoKAAbEARDGoh
	Dg4MDAyi//ZbJYFnemt3AAAAAElFTkSuQmCC
}]

set flag(TKM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABj0lEQVQoz4WO
	P2tTcRiFTy733tyk9s8krThoFwdxKEjFyVFwlI4uIvoFghSku6M6FvoNnARB
	0MXBqbQOTQsabdJgNFiqJiY1ue857+86JLj6DGc7PE8J1wHgzc+l3sfuELi7
	Aggzq1dO39ZhwBjTzTEhBrBRe7LczYtQTheqD9PeTLnya9i7XdvabR3sdxpy
	MZByOl/UNiMAKPD76GuUt4933i9Uzuy1P8xXZx+/3FxbvZnLPn0/anTbjW9N
	ugBECAhFSNKi3x2lSdhpHdy7sbZ9uLd+60FUiipJ2USjmZMigBgBCj4e8HSU
	Z6VCjtf1d0/vbND9+far1knHSBMpUgIQwxCCJ4n/GYbZajCp3mnc33p0aXG5
	efLluP+DookmTZJiCAo+Glgz41yfFMzNpN32PklzUjKRkpxTg+Rp4pkxqxYm
	mwSYi5oeKNLlwQFEGINBcyvXrqbILly2aQBNZjKjJj1yyf2fQYPDRnz2ovW6
	55YWJdFJp1zyIJcHd3cFAShhHhjjWY7zwGdgHf/hLwvQQSZdbMVqAAAAAElF
	TkSuQmCC
}]

set flag(TLS) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABaElEQVQoz2WP
	MWtUURBGz9ushFXhFVuIwbSx2AhqkJhKRGwE/4AIgo3YiAFJs2kVbLRVImK1
	CtqYFIJFCoMosTD/YVksQpTgruu939w7Fu+FLDgcPqY438CwfBJv4eCQJhAE
	GMMIfsM+/II9KICNt6vXSoovmT+JlNwSydwMM5d8Iofr603g607+cXpw62Y+
	8ib590hKLtVEuaLH6FIxO5uhCeTsnz6m0TDduWfTW8l78t0DVdGjqgJShgbQ
	6XS63e7nTX/8RLtL8ofyS/KGPEYP0eMBEjAFvFhba7fbCwvnX738MNq3C1cC
	S/I9853g0qFdln/7/Slg/sx8q3V0ZWV1bm58+66OD+XP5O+Dj2q1/qEsx4NB
	E9je/tbrvT63aA/u69iW+fPo/UOvPm/mZlY9HUK4eFnL1zX9yHwzTHr1YsIS
	KVEVFs/ajRMzjafip3FKSIWEGVWakVJFhuIqvAMgQ55Y/qeaf+G4QufBufgg
	AAAAAElFTkSuQmCC
}]

set flag(TOG) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABZ0lEQVQoz02R
	sWtUYRDE58t9ueQ9TuEszCUQgvamSx2w9P+wEcXCSgJ2ks7e0mvSWIjYJ02w
	UxtFkGiZJsXTEOLb2d2xeDnMsgyz2838ivB/cmFG+0AH+GJtoRUVAPb2AGg0
	Kn2PWpV6ev+cvXu6Jz2cSaZ78N3r9xUAVlc1m2FnB2/mOj1FxIvp7xpUUqLS
	lJbJpZXNlw+wBEBm2N3F9raePEaEyJsNm8KmWFP6plhTrC3WFN4aoyZQ+h4n
	J2pbfP2mrtN4/PyH8S89zcM8BsO1CV99GDJMpzo40HwOd5ECPp4bL2hhFmSY
	hTF4Jxw/UQGo60TKCbqWl0VuyCateZBpHmSYJzdaHt9G4THK1iP1vyBXmkS5
	aUicdqUi0svK3bPDT/X7GWZrzktmEsnUVScZJjGTw6mMcYnPHeq9Izy84cx1
	Jj3Dg0x6kOkuegw0IjNC8eUtCp4BfxYg7RpUA/LaJwEHJvgHcW5DMdMnTWMA
	AAAASUVORK5CYII=
}]

set flag(TPE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABEUlEQVQoz22R
	sU0DURBE585nOUUCCRw4JiGiBWqwKAMKgIwuoApTAhRgUYB1BIYEgUC2bP7M
	zif4YHyC1WiSnbcaaSsc3mIzMmQkY63Ht9MDwH/UALi6PAJwvDvo1fX9fBFG
	ROxMz3ta1mSW8o8vJpOmnN5b+mS83+9X7fXi7mUlWbPW/MiJmSmnlMlqNDLQ
	wLDNFEAmvVqJYcnfUaacWACQBhpIEZiueXEzk/30/qkwbW/d3gAAGiTZDsXz
	qyQzckRIHnDxmy6AZKCJ+RgPZ7ltMxOoTG7X2PaqVDJQkTklSJ1QNw0pSypA
	TyoVtwt0MBEKRKAANYXhMJNQQARZkZBQXEJEkYFq2X0k/vvuZgXgC0lTZuDh
	PtkPAAAAAElFTkSuQmCC
}]

set flag(TRI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABxUlEQVQoz03R
	T0sbQRgG8GezeImRHEMOuQS8thXBloAuxYKhtD30IOzBg1IRQQn14iG29Rv4
	Fbx69SYRD540pIld1i7ubNJulkRwu6mNmsSs2deZBUseXgYG5jd/3sHAdZPJ
	JMIkEolBozFQ1QHgA/dAF7gDboB/wF/AAyQaH6ezs929PcZYEATpdPqTquLo
	iA4O8PBAvk9D4+3+vrzdakmK8iKb/a5ppmlyZljWzPw8XV/T8TG5f8h16eqK
	lxSL9SxL3gYolUL7JqOqRrXabDYdx9EZe720REFAlTL1fer3+fYYG+vVavJX
	fq1MBqenIJpeWDhnzAmjXVy8WVkRplT6D+5tW/7GwctX1GqRrnOjLC7ypfV6
	3bbt8k8ju74uTLEoQDzecxwBMDUlgN/HD42b2eXlimH8DlPS9XcbnykgOjmR
	4vFuoyF/4WBykjxP9IQfXakQ0dzqatkwfoUp6ecfNjdF103z9vJS3gIiExMC
	8N754fv4pYG3uRzfvlqrVS2rqGkf83lEIt1CQc5z8Ow5RqMUjWI0hpgoybIg
	Se9zuabndTqddrutMTa3tna3syPxjwyGCsPTkZHg8DClKHgKKxQeAZ4ENaAf
	SFbqAAAAAElFTkSuQmCC
}]

set flag(TUN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABN0lEQVQoz32R
	sUpDYQyFz61dBUEoFFsHp452cfIB1KFbp4Kzo25C36GrTr6C4uAktljhLrp0
	7aq7UF1ukv9z+ItaEEMI4ZCPhJwC/URa7f/MAknDoSRSUkqKwEPhuMsdM37V
	j9vbuiQJXt8UoQhOTrS9zcYGwHRKWTIeU1WYFe12kuqSSCynj4+1WHB5yXxO
	u02vR2uL7i7TJ8xklqRakhSRtyslHh/pdLi4YHOTsuTgEHOqKi+RVJMkD8ww
	I4L5nKMjRiMmE7pd1tcxWwLuKQOE445VpESrxc01p6cMBpQl7+/fwM9JWZI5
	7uzv8/xCv894zN4es1n+j9xxd6mepLUsmTEacX7O2RmNBsDdHff3PDzgJg9F
	KAM1czWbmMlDV1cyK8zkrlx3dvIPFZGk4nPVyH88zvEFZ5M7fnU1EMUAAAAA
	SUVORK5CYII=
}]

set flag(TUR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABN0lEQVQoz32R
	MWoCURCG5xntEgWtLCxEsLHWA0hi5wHEziN4AGvxAvZaaGEhVlaWgth5BLMn
	0F1I9s3un5n3FowQMgzL8Pb/Zv43z4AekT7Xf6ZRYDKhJEGakqQUnFDCYCZm
	WItf33C3y2s3YxAEIlV1rycY9nvcbqqLLWyMOJba1GoyQQG4xqoeDqndVl2j
	genU6WJlHEDWCpBT36KWifU6dbuYzzEaYbtFFGG1wuubm5MNEW1OLX196+n7
	B2TI8aj/zmes1yiXsdmg08kA5tQDcFdE8CkLQKulNppNXC7q6nrF4eABbymv
	m3JDablEsYjxWM1IDAYIQywWmRnWpuyBF7cyaYDZDP0+CgV1f7+rT38BFkC3
	Qh7IAVStujYJnU5CmkqFSiVyjTXdDiXVTvT8kP+8sY8fXUA+Twjp4bAAAAAA
	SUVORK5CYII=
}]

set flag(TUV) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABgklEQVQoz3VS
	3yvDURQ/1/agFPawJxrTnjxoRZkHtSQr/gBFEmWoUZTx5okslEelPWgPEm9a
	aUUhEklRXuxFijFL7Sv77v507r42HjidPn3qnnM/n3PuJePwExKAFxIJLSYv
	krEBWImBHet6V+d1tZQghRQCieJMMy4kZw1t4HDBadRwepQZ2yZKKay2sETU
	X0EIyWazdus4nWNL5y9ZI8elxMs5agiFxEoq5E7zyNbr5FQoU6adpOac6cFl
	f82Q18mlYLpHUMGpRl2NPWvJ/qM3L1BehgrxVHvssRuFfLWVkU53jnHUoQKo
	ULqB656ga9NXfQGUEvG8APYqxVKqwn9jtCyePJjcsoGWVKgu6nccd51toKbL
	UZ6YiRPGGDGv0sZ7+NJjfHzSknWpGP+eYb+1L3I/fJcPHEzvkXw+b7PZ9CT/
	LMcKPMUtZTIZ0gMwOhsUaBt3zwrIudDIXI20vok9JcXtoZJS4OImEtck8OtR
	rTQLGHaDtwPWo7BbeGxV/A1fJutTUD67uI0AAAAASUVORK5CYII=
}]

set flag(UAE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAAK/I
	NwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAEq
	SURBVHjaYvzPgAD/GBiYaxkY/oARkPMLzPiFwgAIwKG80wAAwlAADAnq0MNW
	GTipvfcpheWmmy9GNGUPey/RkskiWwP6mhDy5BVAYA0M//8/ecrw9y8QPfj8
	++/fv7//A9UBFYHIX39//fr3C8iQ5ZEF2gAQQCxgs/9DVAOVrXRe+R8HYGRk
	fKj6ECCAWIBOZQSqBjuB4fef/7gByJP//gEEENhJf0BmE9bAyPjnzx+AAAI7
	6S/I+P+/f+HXwAi2BCCAwE4CGv/rF8hVv37hcQ+QBDoJIIBAGphBxv9m+A0K
	G2tr61+/fv3+/RtKgll//vz+8+eviorKxYsXAQIIpIHp9x8GSUmQnj9/Zf78
	hgCgcyEkEPyFAaA9AAHE+BUcp3AkzEAAAAQYAHrGaQbZnz4fAAAAAElFTkSu
	QmCC
}]

set flag(UGA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABS0lEQVQoz5WQ
	MUvWcRzE76d/DVvcpKgI3BqaxMUX0FaDYz6vwPEhFVqaBMXBt/CAOIiLEOiq
	z6CbL0CEImiypUDq+d59v+eQgbZ5HMfnuO2AB6oB2Nj4BKDKVZlZVZIyU5JE
	6S+IkgaD/XZtTOCj/d1IIG0aiaJNgzbtsMNmay9+/DrqJs/RnhlMO1GE0w5b
	LtrhChddARMTnDxDNzaHtpr4JkugLGJtbffy8v3SEoZDrKyARITJ9pLdCboP
	wFvlT7KkpFJcnJ/Pi4t+v7+1ublDZkRGJDktrQLdNlCpr1IwRJGcOT3t9XoL
	e3vHw+HWaEQyIkjOkldA2/+M16+W//z+UqWqKLMqqljFvIVwskpTj2cPDs+7
	d28wPq4q4v4n//IWgGwtnz9BV48wti7kUyehhIhkI5FCEhJSqIQSztpFuwbq
	jnG//jcBuAEbGURHnAviAAAAAABJRU5ErkJggg==
}]

set flag(UKR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAA90lEQVQoz22M
	QUpDUQxFz/t9CIrDTpQK4mZcjgtw7CLchmsQhO7AmYJzHVjQl+ReB/2tFgzh
	cBNO0rgz+5JIECSk5h47DgEdcXsNIFtuZVKUnG6pRWqKcsohR/nh/rMzAbxt
	XKZEyFWEHTVLozzkKF+cNr7UEZJLpEm5imFnOXbeKI9ylKMAdYbKLUXKuf/9
	x54ph+CDznK9PL4c9V1ySiFSCinkKKUUNefVyRHnj61eYXVjv5iB0w57/Mtp
	unp/WneJ5rAH5KF0YEPamdAlFqQdsJf+OYOCIukSkxPOdtuAaC0gYcucbUqi
	bZ6RUM5kn7eB3xEB/ABIh27oU+sPZQAAAABJRU5ErkJggg==
}]

set flag(UMI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABjklEQVQoz01R
	PUsDQRCd+8BWNArB/IO0SZnORrTRysLCwk5SiFUQrLQRxMpCsbYyqSKCQSQJ
	CgaL2NgEbLSQO42eSe5j73ZnnNyRkGF5PHbmvZnZ1TYOXmEUOBFSytO7beW6
	qtMhRAWQHGABp2vPXYXqtvXNdTdPdhiG14+fvu97njcYDHpxOI5TKpU0Fmwu
	pXuupDhYzMBEIa6UD6HXR9cl38Mg0FOz79VrE4HTsFpIVZpfa4wNa7UwV25Y
	DpJ5csL6ZFCdUNeNTq1mAgIQVho2u3I1N+DqX0QbSayvUxAMjxAYRcb8fOr+
	3uTtFnMz5bo1bNKwGc/r1lYhtX9jGZeXyQMAkcZoGM8XF6aMN+ZbNubhz+rW
	D+Fe1XL/KFxeZm+KIiVlICWk0wsPD1q73c5ms0qpeF1KLMdkzPnFeJmd3V3t
	I5ebLhbVywt1u9jvk+9zcmgce4dSCikjpYRSU5nMVaulNZvNfD6f+Ex2GHMh
	RBCIWCuPj460N13j0ccfSSMyAOjF+AvgATgxcvwDMFB/QVm8bpUAAAAASUVO
	RK5CYII=
}]

set flag(URU) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABYklEQVQoz2WR
	sYqTURSEz725ucZCsovCFrL4CLaWgi+wb2AnqN2CjQ+wvoK2iqA2woqInYWF
	WGhhiAqyQVlJsfzKjxA3+c98x2KTKDjNmTnVx0xq29bMzAwsZwMzg/X5T8XM
	anVpPyVqf8fTxsO3zfFcWAiT6BQiXCHYu/M6NU1T637Or8wEl6J3LSKFxVqs
	TM559GlSwOF3zoqQ2SiFvxzPiBAhQkKEA8SZQe/W/YNS66D0duaL74EP6vVF
	9F98aH8de0d0onM6Red0YnuzTu99SUfNz83hcLHoIqJfCzCbg/EXiSVYyfn9
	6HPZfXJ49XJuZy5CACGFCAUClwlEABuny427B+XBo2/bW8PDH4sVw5qEVVSn
	kOLC2VPzx+P0cTI9v3VO4t9ClsFYfS0iSklv3o2TXXl2++ZFBwlXdCeVC1c4
	OEjhMgIRz3efpsnXqePLGU+cOY5j4O6YAYY7ZtnsD8yTlKlETVUNAAAAAElF
	TkSuQmCC
}]

set flag(USA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABuElEQVQoz1WR
	z0tbQRDHZzXBS7EgCEqxwUuvvZUiqHjTeqgHQawXMW09eCrNRQXx4B8g4kGk
	oC0FPXjwoGChjT/wUNH2UqRBkEKixJeE5OXlZbO7b3fHScQUhy/LdxjmM8Ms
	i04eQz2sBasBFADSuxr5jrycy95QbmuiGlCDtebLgQ5QfY7rIAg+/dBSipVv
	WilJIUSlUuEkzv2trTVGDb2jLzeOrLFAUhoNVo3Q+AtmIe+CVwS/BJyzNwOJ
	s2OasE9gIvXOqXK53DUtC4XC848iFBOe57mum8/nc7mcMWO+752cHLLou6Oe
	0a61OE2osnUAEvEcpOanOr1MYPB9FAKUapgY+nn+G6LRPdq7e0YWi8UXMZnN
	Zhs/XKdSKXi9e8fOZDKO46TT6b/W7Oxshugg6wdMa+hbaLIa2xa4kYmO9waS
	tnlwsMqWkkSmdWokcZlgyeRle/tTGmKtRURbi7qpe7pUZxiWt7+Gnqwvsv7h
	ht04Og64Lm1clRBI2yuFdUPE2Pjjq3/s4uJPJPKsFA4/UgIRCIcPQ+tAiBaA
	K2Nsy9I8u377io7z/yPvjQAoAfCaglp6V70FaIBiqkAClSIAAAAASUVORK5C
	YII=
}]

set flag(UZB) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABY0lEQVQoz31R
	O0sDQRCehTOQIgS9WESISAgSsLZOFayChZ2dgo2xsrCwEOv8ACEgSH5AQNJd
	YWcZzkbskhguSDAPScBEd2d2ndsjaBNnh2F29pvHfiMAjur1i3w+Vak81mr3
	AOh5Vy/P77ntVKl0zlcAafUrcgQnTKc3ntfy/b7Wulzenc8pFhOj0bxabaLS
	CimySlGjcekAwGAwKxS2hsNZsZjt9abuWjwIPl033mqNlSSpSEpkdCaT5D7O
	Cdx1b3cmQX+d6OkBibAjw5ptSYeMUkpLhTJ0kmqjCQMxmXwnEivcxxgD9iwT
	IYTvvzo8d4QOE2A5nF+F0BodDXoR+Lc+dzAGEcQBwPHp9Ucn0IhkZ0VpGWHl
	6VUYjJhazW6e+Q2nvg/u3lt73LUQJVFaYiw9qKQO87gAs5FzDfjg8EIUYTqR
	VjaKOiq+YD/sy2EiQ6SJPymgsFjl34VGNtpyyMWv/AA6PG9e7QeSggAAAABJ
	RU5ErkJggg==
}]

set flag(VAN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABkUlEQVQoz02L
	TYjMARjGn//M38e6cBNa2nIy2MO4SGoPnOQwLOXjMAdOitO6rDPOo72uIkWK
	GuXGQbFKe9mJk5ZCLnbXxyz/eZ/nfV8Hs6V+/XoOvwf7duDtQ4wAM4D/B4EB
	8AdYBX4BP4AVYAkoe1+w0J/+/L58MGs9j/3uKYerkOpSjUwp19zvdksA7xZz
	6dvHU2dqt25UP8lD8iSHGJOWZkkWo6MB1ACE55sFv9etLl0tnrg/pQ1Ts+Qg
	zYaQAZQAzh73rZu1/F13HuvKNC5eY0c0p9xMZk66mXOX89m/Q1X5zfucuqCX
	86oq3r4uZxGBjCKiFlFk1MN93aZ67xFKAJ++6tiElles2VC7VZy+XJlRNCNp
	Q5McG+u/eo0SwPM5fli0A3vVbuF8pz+YtMER0mlhTJobk0oNNggvUAIQ1Wyw
	3SrOdVZtwqqDxooWxqAFmaagwlU4+igB7NmtE0d3Tt39ve3kFjZIJ9dTKQaV
	UsjTPdzTYSgLoDkyu30cOAyMA3NAAAIMiLUtAICAjfgLJMVRmxtqIJ0AAAAA
	SUVORK5CYII=
}]

set flag(VAT) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABa0lEQVQYGVXB
	sU7TURjG4ff8ewq1aqsNHQSNiRrD6IBREicHjYPX4jV4Bd6DV2DcdHHAmBhN
	jIOEpbAwtBKJErDS8533Z8FFniftfRnK+1KWZIWi2nKTure21VzyWWFn+eDy
	zReaowpElQItpP5Q6nDWeDzO+icmokIVATNSp6lBMicqJ9Kc7SxZVFGhikAV
	AgWpmU7j8GBzZ+fV8ay9evthr7dsu7FDzFURUHHgggvk73uHGx9ftmvqa3vz
	27Pp768R0ciIgIAKBQoEFOr06srFp0+eH+3ujj73766/6fYf2c6WUBUBAYEL
	npFapMWjn69/Td7e6D1YSVc+fXg/WL620Gpnh0TFBQUOKFBQxqXdXV+6fn9/
	tLXY+rF273FxnYwn2RYOCCgQuOBCynjWag1oOL+2mprU5NxJ7YjIEYJQaygi
	EWpC9Vipk1KjlCSdGwxAEjqVRu/kP7LkkEMRcsjShTsb1pL/o1N/AVOWRi44
	Y2x0AAAAAElFTkSuQmCC
}]

set flag(VEN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABY0lEQVQoz11R
	O0sDQRCevRxIChtJkyKEGDv9A2qpgSRlsLdXRBRMYeM/CNqkEaI/QJsEUsQg
	pLCxsBTEF0QLH0TEmCI7szvO3l2Cunz3MY9vZmdulXmH1guAB/kpsBbcsQ52
	DPEoMMjBXz6Ben8vvm1OrydLcx8AhtkAkGKKAXmMzMQj/r6s+56Ffb36vKFL
	WwcAnxINavAXdABUKuVuaOeBM4cAT6EuYD3qGklDBkApUACdcjnb7Q6JgNAi
	ca2Wisc9Zh4MqFi8R7RaW0ROpyc6nXPPrUTOl4SwqNvtfqFwl8vdNptfjUZG
	1CFEJrv58hkDRKyRj4+culp905pFUam8DoemdZZdmL8JO7qfsQSL62ubvcee
	kUJNBg2FjGSkq2MZwBCZxHRi52rXb8JFjGYtPkDQhIPmkTGOEMocysysAPhy
	jYcEyaTkJCqLS6VyNkHIAhk6gIjVIHrZCPDX/ZeS8wN/9Fp0eMAmHQAAAABJ
	RU5ErkJggg==
}]

set flag(VIE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABC0lEQVQoz32R
	IU7dYRDE50+fAEETJOJpZB2GAyA4RV2v0CBAwFXaag5R1VM0gCKIhjZhZ/b7
	IT5SeAlhM9ms2Jmd7Czopcbm/CYWJJ2eSmIMjaFu0uqQKMHmVX+4ulpJkuD6
	Rt3qxlY3B2aYX6aMiyrsZb0e0koSg43tKo7DrvlZuChPguwhrYa0dCshUYcL
	8898MpjLYq/4/ELQvKD0dCmHM/OtwGAOixPz59mSkiFtSaJDggsXd8XXgoJH
	zovfj1RNvLJkU6VkKnFZfDH35nvxw//lSTIJH5JpEZtVcVLcmiqOzLZ5KGKl
	1a1J2HK0v4+ttGLZy9pKZGsn+pj5Q3UPafm7GeQ7Gc96AotzVU0bgOPYAAAA
	AElFTkSuQmCC
}]

set flag(VIN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABY0lEQVQoz0WR
	zUpWARRF972fpaAlpIEa9sMHEUETkegdHDisidCgF9CpNHUk1KOEUPQClZMa
	NXFQkFZk1GdEqO29zzkN7sVgTQ9rcXYDvAEMjADEh1UkOhLIRBqZmNwG2DMG
	eHPzxsTElcjiwuPx8ZOqANyUB3BbOrYfrElhpXae7owBAPDlKzMy4qDqDxBV
	OsPBvSMqtDi1CKIFkIlw2lUVQBydkiGlRqes+ltFBhlUqkvKiIooO1Ha/c4X
	n7Q0q3ONXu5z9TqXZ0RTKYU6Q9plp1RN6f1Iu4dcmuGdS3z9jW9/qEFvcBru
	DSmVnC7dnubDm9x6pyg+uqXhRTLV9fxPkiCllFW8e5nLs3z2Ub+oJ/c4gH6T
	Sjkc0RtsJ5l2VqmKKK5c1Yk5QPcoKuQMV/QHUs3NnberbeeBC4DuD5XlBgI8
	aD2cjsiICBgN8Bwg8Bnwz1frcL/u2cxpXNsADCQA/ANPe1r179gXLwAAAABJ
	RU5ErkJggg==
}]

set flag(VUS) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAB0klEQVQYGW3B
	vWsTcRgH8O/vXnJ5ITnumkipJWZTFEVsq0XwpZuCOoiLIrro0K3oIjiITgGh
	4uLkIAjq4F8gBhG01U2wRtIQtelLuDaXJpLc5e5+eR5LJgU/H9HpdPAXIgC0
	AwD9jwZQXLxRjQmh6BzVOPiiZObCzjOIUDdvyO4rKONCy9EginqlhhPXACWi
	sLv9EGwbxi5FzRrwI/qmqmWiK2ycDtvFsO/0QnegjW60RjQpKZm5zEG9Fywz
	VRMxZf7ByVj6nO8fbzvNm7PPrZGPq9thLmEaydvZbFIpFn9JiZX1aVL2hP0Y
	Sa/lbH39kC8vHK5/92P83vNCK3UskZldXMw1m31NAX7+8Nacg/sOnQLgubfu
	ze9du3vfunZ16/GjmC43/TufFo7OzFgy8ohIyRfizWZkWTqDzz+5FHibQtAA
	AUlBqZ5qJOsrF1qtrq6DmXYI13VN02RmAO36mZfl5MUjZ9eX3/6utnMThbRd
	yHhPXfXz2FgKQK1W1YgIADMD0LMv9u8uKfqJ/PjrcHQ1ogPvStcLhempqQQz
	CyGkJOE4jm3bPASAiAEmCoJgY2nJ9v2BrovJyTTAACqVimg0GvQvKSURAZBS
	0hCIJBGG/gDo4Sbz/sED/gAAAABJRU5ErkJggg==
}]

set flag(WLF) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABfklEQVQoz2WR
	P0tbARTFTx4PUWOoXSTWSkFSBwkidnArFnXwa6gh0GxV4iDiF8gqdHTpWsTF
	IpRO/QBub2jri1Xo1M36vOf+6fASEIQz/Licc8+FWwGOAUS8B3BaqTgwt7mZ
	n58r8FQJkAI4OHgLICIW9/fVbHJlZXz+dQhd1clQDdJUnfxydpYCKN0A7q+v
	law2GsVVbg8PTppQKRAJcnR2FmWDOwYx0s3czEkXJrWJuaOjsYWFot/PWjtO
	lle5mZclTk2SJCKsKFTk1eHhj27378VFtr398sOukQ6kl2uf62+mbj9+D7Vn
	71bDXO/uTMTI8WbzRafzs9utt9uT6+t5r6dA+uvrt7Hm4n2eO8WpTjrFhS5S
	9Pu/e716q/Xn5KS6tARSgVQBJ13EVV1kwCTIbGtrZm/v+cZGdXk5a7dHarVB
	ILRczIFbxEkT4c1N1um4SCihljYaCqQCOHVkejpIV3MdJlWDdFVXDbNSBVD5
	BPx79Et/xDKc+BBGgf+WQT1xegwtBgAAAABJRU5ErkJggg==
}]

set flag(WLS) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAB9ElEQVQoz2XH
	S0hUURzH8d99zMPrWNg03NHJksjKinCCVkVF0QuipFpYUdADAiHGXdBWKApX
	LeyxSykIolAIe0kTVEQwGk1IjaTilJPzrLxz79xzz/mfVkHQd/X5KrlcDv9E
	BPJcaBoAIpJSEpErPB0qERGRDsCMmlKiOplxkk+tyezirqPh+GYp5dz1a8G2
	dl/jEsSWGU0xSTQ1Pa0DUKDMjz7hhXw5lWoo21qxKKX8cuwgSrUKG+EeW5dM
	zlw4HT7fw31BFYAQnAOxrpPmuW5LiIYduyojQ26xBjNkeG7rvbs/37wupD/q
	SyNEpAJQVU0M3JFS0otnZcasz5/s8TGNmC/7g3ZuVZqav/d0xw8k/BGTiLQt
	p9bX1y8KP09X9m4q9N8w/H7v8bDzdSrQaEibyXJRjr0P6cb9lnRzx/ZU5qVS
	14u+PZfy1dnOvlJU8ddCpOddlVMpUFsw+JoJK+gtnElo86Zsr1t58+qoyjhI
	elx447v19AoWyYoPbbXbnfaqOflwm32817tyGBdvaX7m/RIVEFTBwIl7gj3Y
	+Pub4Vw+URreJ2eXi3emdeQR16vu27iYaLYdlQcoCA4dHELwsBEd7A9nWtyZ
	1TJC3qEBVlzrDO3XOrL22UHl1QanNQgJggUFCYAABjCA/wf6uwRwAPgDIWgX
	wXNTG/kAAAAASUVORK5CYII=
}]

set flag(YEM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAA9UlEQVQoz5VQ
	O27DMAylCi0GYqDIZKDo4otkCXocX6Bzxhg5RE/QU/gWBgwU7dbBcQdRpPpE
	NW6WFOgT8cQ/KblP+oVe+FpZJRp7BKrDMzglJVFSSVFIYoJECIMpsnLWP15e
	vfVK+v5GIgkSmVgsjxMbh6AcoN89POYJ98dj2u3ofMaIpJig4FwpCjsrNhNO
	t9lsv7xblqWqKlspkZ1bcM5N0+RVtWTnArqdjqhzSM4FF8ef/TEhr6z+dOr3
	+6d5nkUE9sorkFqcdV33fe+wRtd14ziyIYRwdTE4Qgxt2w7DkL8VnqZpuATY
	Du4fk9G8FJTX/hvfVjNhov9Vc48AAAAASUVORK5CYII=
}]

set flag(ZAM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABLklEQVQoz1WR
	O0rdYRDFz42fjYJEMaAWloqVe0gXcBcpUmUNIWUKH7gDS7chWEqqpLRIKUKU
	JGDmPCbFP/eKwzBM8Tvz4MyWPi9hHo4RQICAAAUIqBfNAHD+7hxAd7udThLH
	bjveeng8+v3AVFmrpYOTyzHNvvtz53YSRbbUlq3w2+irlacvtz+WVWd7hz93
	MBB02rE7jmSpJcs2w+USrY/bb2RtzYDCcGzYbduK/qepWObx6feVx6e3Vffh
	xYf9T9cYCJw80xZDWYpopqgqVSl0FGBAcMRwoiduIQsrVawi2F4I2hMqk3OU
	pqKu6iqShBBpEsjPl9Cc0KmG1VUUCUMCMFBQtLm6OV+ixeuOx+6vV+t/d9qv
	J4uAGd6/dHThq4DC9Q02gAMAwFdgDfgHza93SyGoF7QAAAAASUVORK5CYII=
}]

set flag(ZIM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABmklEQVQoz02R
	P2iTcRRF3y/9mvgn0Ukq0lIDdaiCLk4ODkqREmjAoUIEEUFc1bGCg5OrOlU3
	h4IiiF0yaEWFoE5Fl0wdOrlYIzFfk7z73rsONRK4cM98Tmpvt+eX52VJxERC
	JERsxCpiIjoGRUn5n7y0v7TafDBzGs4IetCDFjQP84DTPOBhRtz5uJ7yPD8w
	WfICN97eWljoM0HESYxNSSWR0ky328xEhBMP8xfli8ura/duXIhBISnNAqAp
	TcNAaBiyKbQfSdZ9vFKoH69c+fL76a/F6enXX7dO9HMHAiDUoa4IqAMHe1gT
	STutjWxrs9z4TNru+8bk+aXFWg3DIQBV1X+nAKrVaqvVyrKTZ/37B9J2Px0u
	nKu9vF5/cmTgQEADCCgNAQ3Dvim8E8lC4tDN+xHBM53ntxuXJnpZUgZCwKSR
	EEmZwIIVizYnkjqdTqVSGQ5662+uXq53mCmpjD05I0sCoac0t/PzW+r3+wMM
	nzXvHj01Uk6LgBMWFv6/iZO+8mozbf/Ynj02K9dEeqOoOoo9znvty/IXxrxc
	MBH01HwAAAAASUVORK5CYII=
}]

set flag(ZZG) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAAABGdBTUEAALGO
	fPtRkwAAACBjSFJNAAB6JQAAgIMAAPn/AACA6AAAdTAAAOpgAAA6lwAAF2+X
	qZnUAAAA8ElEQVQoz5VQQY6DMAxMAkIrYD/AgUv/xz6oL+ExVbvdShxRxY04
	9o4d2qW9reM4TjKTsePcP81jDsMXczLDQkQpR8sonwOAOY5jCUJRhNvtJzMA
	ijHS32KWCPi+7wEuP8zatmVToVeLJmQ63DSNlrQsS13XyETE2WCOonsdwh6v
	4ArkqqrmeQ5K8n7X0YbU+N6vXofX/s3Ey0aU9/9BnA6Hz2FI0ySQJsru0BCS
	GHldEfNh6Lrz8VjS6SSXM39fNzQQeyh8XTlGR+Tv94RfgqokKbpOFXYiwWjP
	rcrCUdLVOdZ6NSarMln+9PQ4EWvjF197HFPkEuTnAAAAAElFTkSuQmCC
}]

# set flag(ZZR) [image create photo -data {
# 	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAYAAAB24g05AAABG0lEQVQokaWS
# 	PW4CQQyFv2G3QimoghQJKW24RxouwgG4Ri6RI0SROEvKIEVCCCkN7M/Ys+MU
# 	JuyiEKXINB77+T177Am73c74xwlVZTYeu2N2qZVzvup3XQfAdnug/AaH5L+I
# 	ZkYIwTtYLDpbLgP7fU+IsRdo23S+17UXEclMJgWr1Sfleg3zOWw2DqqAaCCl
# 	jIihCqqGCIgabeN5s5l3Mxq2KmKIMiDnq+S6zqRU9AKeZOhF5d/J3xyA8pWC
# 	B32ibj98UE3rCU1z8t0maU5PdPwm3fHCM+UjUMobuXuHGNGcKWIkafQpy9E3
# 	IZVbdaFC77mFfo1Mpw5UnlgCdjzCdEpuGkZAjpEREKKLd0A4wPkDRH6eYUxP
# 	thvEvgBty9VbUwA/GwAAAABJRU5ErkJggg==
# }]

set flag(ZZR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAALBAMAAACEzBAKAAAAFVBMVEUAAAAr
	Kyu/mSa/v7/nuC7/1VX////Cd+o5AAAAJUlEQVQI12NggAFGQTAQYGCE8JEY
	qi5gEISFYZYGBslYGMZQAAAwFhFWYX2Z8AAAAABJRU5ErkJggg==
}]

# set flag(ZZX) [image create photo -data {
# 	iVBORw0KGgoAAAANSUhEUgAAABAAAAALCAIAAAD5gJpuAAABaUlEQVQYGQXBvWqTARzF4ZPX
# 	ECNGo+AkFL+wgwQzeQVOgqCTu0MrgiCdHDqK4OAgCJUoXoLg4OYdiDSIoKVaJwepCrY1kPb9
# 	n/PzeTo3bk06aiDISZJKTBzKLnBSSTkmTtwVnDx7qXe4FwImictVidv9grKrqiWZz3Z3fn3u
# 	Bvf6vb/be1Lskmy3ozPbd25+X3u9MN3oO/txm+TI4BSiSZIEHEcCeHb//cetE3efjKebg5er
# 	XyUJSXQ6EjRgcGJkKaNzf+49vSJJ0EFLjy6MF2cISRJIjWMcqKQSL13/AoYkRhWyfPWtJAEg
# 	1CVOKilJhMmb80mBYwsgL95dk5SUJIkmaW27WldrH0y/HVtb+ZC2JCd+tbq1vtEXQZGF0iR2
# 	W1CkoHAtPx6NF3cmDz5dvrh7++ECkJRAhxB0wfPZv8HwuIKkKJjNn8OV56fjHB0G23EqB/M9
# 	RDep3z/WJQESAACBIIhDCMgigv+ogHr46DNZMAAAAABJRU5ErkJggg==
# }]

set flag(FRG) $flag(GER)

### ----------------------------------------------------------------------------
### the following flags are taken from http://www.iconfinder.com
### ----------------------------------------------------------------------------

namespace eval 16x16 {

set flag(ALB) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAeUlEQVR42mNgGAygh0LM0POf
	geE/ORivAb+B+A8U/ybVgPVAXICG15NiwHwglgFiBSiWgYoRbcAqIDYCYkYoNoKKEW3AbiCe
	AsSuUDwFKka0AReB+CQQh0DxSagYSbEAwlugmKxoBOF/UEzYAHb2/+RguAGUJuWBBQDrkSM2
	0lXxNgAAAABJRU5ErkJggg==
}]

set flag(ARM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAQElEQVR42mNgGBagh0LM0HOT
	Qeg/OZh6Bvgo5v0nB8MNYDBe8J8sDDMgJCb9PzkYbsCnFQz/ycHUM4DSdDDSAQCv2egZIeHr
	cwAAAABJRU5ErkJggg==
}]

set flag(AZE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAcklEQVR42mNgGBagh0IMJLY+
	+k8WppoBsxMq/qPjOXmt/+dPWfl/dnr9f2zyIAw34L2xw390/KW29f8HJ7//X+rb/3/0i/yP
	TQ3cgO0RVv/R8Y5Ut/+7e7L+b493+I9NHoThBgTM0/9PDqaeAZSmg5EOACaIAsxq80Y6AAAA
	AElFTkSuQmCC
}]

set flag(BAS) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAoElEQVR42mNgGBagh0LM0CM8
	weW/Yqfj/yk+Wv+vaMv9vwrF71YuAWMYHyQ3FahGqcPxv9BEl/9wAw4bK/6PyTL9zzrd7b9T
	udX/LdYqGAZsBYo5A+VYZ7iB1R42UUQYALMBXdHdTcv/3wNibIaDMNwAmE0g/BaItx5f/3/G
	ta3/r757CMYg9hag2FskdSBMPQMo9gLFgUhxNFKakIY4AACfwC3EVYpJ+AAAAABJRU5ErkJg
	gg==
}]

set flag(BEL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAS0lEQVR42mNgoALooRCDif/I
	OMKH9//fW6oo+HOu2f/3xg4oeNSAUQMGmQEsTAz/kXG0L+//P9fVUPDnPMv/782dUTCyCyjK
	TBQBAC++gyzyXzSOAAAAAElFTkSuQmCC
}]

set flag(BIH) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAm0lEQVR42mNgGBagh0IMJJSn
	/gdhE/9V/xNLN/7fM1/t/7/TDBh44wzd/zC1YIxuAJPK1P/mQav/p5av/39wsQrpBoAwm8b0
	/1aha//H5K/+v3eBGukGgDAj0CUeiZv+eyUuR/EO0QbAsH/6tv+e8UBDFuiQZwAIh+ft/B+S
	ueb/7vk65BkAwk4xG/6HZq35X5gXjMMACtPBSAcA7GjkHg4TmgcAAAAASUVORK5CYII=
}]

set flag(BLR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAZUlEQVR42mNgGBagh0LM0PO4
	quH/reCo/+fEFUjCcAOetnb+vxOVQL4B9zPy/t8OjaHABR09/+8mplPmggNJcf9brVRJwggX
	tHT+n1iX9p+hxoA0DI+F6ob//RUJ5BtAaToY6QAAN27eNGf7EYcAAAAASUVORK5CYII=
}]

set flag(BUL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAPklEQVR42mNgGBagh0LM0POf
	TEA9A5beOvOfHAw3gGFa3n+yMNUM6PY1+k8OhhtwTU3oPzmYegZQmpCGOAAAGwxGKv/wa2UA
	AAAASUVORK5CYII=
}]

set flag(CAT) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAMUlEQVR42mNgGAygh0LM0PP7
	Oud/cjDcgDuKEv/JwaMuGFwuuM37nxwMN4DSlDjEAQCPP1fUDqKmywAAAABJRU5ErkJggg==
}]

set flag(CRO) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAgUlEQVR42mNgGBagh0LM0POf
	geE/ORivAett/P432qb9z/Ir+n/I2J6AAUuX/kfHLzon/H+eUQjERf/fdvT+x6YGYQA2cPny
	///19RAMYmMBcAPWrr31Hx1vXnT6/+/mVjAGsbGpgRsgLj7tPzbsqDsVjHHJEzSAEIYbQGk6
	GOkAAJFcETmt/3YDAAAAAElFTkSuQmCC
}]

set flag(CZE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAnElEQVR42mNgGAygh0LM0BNd
	v+z/wxfv/5MK4AYIutb9Vwxq/z9744n/v//8Jc8AGPYpnvf/5sNX5BsAwjJ+Lf/7lx/6/+Pn
	b/IMgOG0uMb/r9q7cGLcLnCq+F+r5f7/kqjM/+siUjgxVgNczZP/75LWwKsRqwEKjmX/29Wd
	/l8RkSZKM4oBoebx/w/Kav6/Li5LEoYbQGlKHOIAAJuIcES0ux3dAAAAAElFTkSuQmCC
}]

set flag(DEN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAc0lEQVR42mNgoALooRAz9JwQ
	0PuPjB82TPgPAqflrP6jyyHj4WTArbii/8j49cotYAPuZFT/R5dDxnAD/pMJ4AZcD878j4xf
	LVkPVgCyBV0OGQ+nWDglbf4fGT9qmvj/78+f/89qOP9Hl0PGcAMozQsDCwDmOZ3wQi2GsgAA
	AABJRU5ErkJggg==
}]

set flag(GBR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAArElEQVR42mNgGBagh0LM0PP3
	77//X7/9/N8yedt/Pp2C/4yKmf+z61b8v2geAMYgNkiMFyjXDFQDUgvSAzfAPrz3/+HTt/+D
	wL1Hr//HFM7/n9ewEm4AiB1TMO//3YevwWqOnL7z3z68D2FAZN5csIKt+y7///fvH1jRuw9f
	4Qa8/fAFLAaSA6kBqQXpgRtw2SnqPzZ8UsIUjHHJU88Air1AcSBSHI2UJqQhDgDMLlLG3DQt
	SQAAAABJRU5ErkJggg==
}]

set flag(GER) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAOklEQVR42mNgGBagh0IMJv6T
	ialkgC+QQw6GG3AXyCEHU8+Az60M/8nBcAP+n2P4Tw6mngGUJqQhDgDpCO0vjUAQEgAAAABJ
	RU5ErkJggg==
}]

set flag(GRE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAm0lEQVR42mNgGAygh0LM0MMb
	t/4/CD99++2/bvFOMFswccN/4aSNeDHcAInUTf9B+Nm7b//Nq/aC2UduvP7/9vNPvBhuwI9f
	f/+D8L9///7//A1h29XtJ94FMIGnQBcYl+8Gsw9fJ8EFQkD/gjDIAKOy3f9hfKJdADPx8/ff
	/98RsBWrCwjZRLQLSMWIMEgC+pkMDDeA0pQ4xAEAk0WHzHg3q/QAAAAASUVORK5CYII=
}]

set flag(ESP) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAnUlEQVR42mNgGAygh0LM0LNW
	VPI/OZh6BjyfzPYfGd/v5/z/DE0MG4Yb8Gsvw38YfrSQ9f+CINH/Z7u5/3/ZgRDHhjEM+Lmb
	4f+uVJX/vV6O/7e1p/9/vFSQRAP2MPzfUaH6v8tc6f/KVM3/j5aJEGfA0wls/2H4RIP4/2Pl
	kv/P1Aj9v9bB/x9ZDh1TLxbWScr+JwfDDaA0JQ5xAAAutzY+UJI4vwAAAABJRU5ErkJggg==
}]

set flag(EST) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAQklEQVR42mNgGAygh0IMJIrO
	/ScLU8+AnMP/ycJwAxgY/pOJqWQADw/Pf3Iw3IB///79JwfDDfhPJqCeAZSmxCEOAPDOS8zy
	lqXeAAAAAElFTkSuQmCC
}]

set flag(FAI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAkElEQVR42mNgGAygh0LM0PMf
	CZy+9+F/s1vp/+X2Kf8XHH7yHx8YRAbsu/b2PwzP2PcIbkDFypv/keXQMdyACS75/5HxEavQ
	/5cs/P6ji6NjuAG9LgX/kfFhoAEXgQagi6NjuAEHrr/9D8Mz9yO8ULnq5n9kOXQ8SKPxDMgA
	97L/yxxS/y888pQ4AyhNygMLANP86uW8qL8kAAAAAElFTkSuQmCC
}]

set flag(FIN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAaElEQVR42mNgGAygh0LM0PMf
	Cdx5/Po/g34OGB85f/c/PjCIDHBJm/wfhq3j++AGmER1/UeWQ8dwA2AaSMYwA9wzp/6HYbvE
	frgC85ju/8hy6HiQxsJdoAFMhrlgfPQCkQZQmhKHOAAAox+aqZM97TcAAAAASUVORK5CYII=
}]

set flag(FRA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAR0lEQVR42mNgGAygh0IMJNRC
	/iPjyKIJ/9HB/ZSi/+cE1VDwqAHDywBmjdD/yDgaaMC/339Q8L3U4v/nRDRRMMIFFKbEIQ4A
	7kZV/V/PFwAAAAAASUVORK5CYII=
}]

set flag(GEO) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAmklEQVR42tWSKw6EQBQER4ND
	cEDCEQinQGI4CQKL4D58JLXpzM5OssMzYHY7aQHVKfHAuV9I97CuI2TfYV0/jxSFb4iYNu+k
	gqaBqoLzTAV6J6aNKVgWmCZbIKZNIuh7LptlvgaPAue40ygYBi6b574GT28wzzCO9g3EtDGP
	2LZQ17ZATBtTcBywbfG7l6VviJg234Knf+Kf5wWie7ZIbecFOgAAAABJRU5ErkJggg==
}]

set flag(HUN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAPUlEQVR42mNgGBagh0LM0HNO
	0/I/OZh6BrzdvPM/ORhuwH8yAdyAfWcO/icHww1wLwj4Tw6mngGUpoORDgAzXCOooNZIJgAA
	AABJRU5ErkJggg==
}]

set flag(NIR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAdklEQVR42mNgGBagh0LM0PMf
	B7geFfj/GhDjAgQN2FYf9H97HREGfDl58j86/nzt2v+7Sxf+v794PpiNTQ3cgDMMDP/R8VlZ
	2f+P58//f3/6dDAbmxqCLng0YwYYE3QBLj/eDggAY7ID8bavLxgTNIDSdDDSAQDQMmnGDyXo
	UgAAAABJRU5ErkJggg==
}]

set flag(ISL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAY0lEQVR42mNgGAygh0LM0MMU
	NOc/DMukLPv/pmPK/1c1Xf918tb8R5ZDx4PIALnU5f9h2LR0A9wA57qt/5Hl0DHcgNdNff+R
	8WPf+P+PPKL+o4ujY+oZQLEXhkE0UpqUBxYAAAL2YRLf5iHLAAAAAElFTkSuQmCC
}]

set flag(ITA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAASUlEQVR42mNgGAygh0IMJCa5
	/UfGkTva/qOD+6W1/89pm6PgUQOGlwGsUzz/I+OoHe3/f//9g4LvltX+P6tniYIRLqAwJQ5x
	AADcTGxbhSpG7AAAAABJRU5ErkJggg==
}]

set flag(KAZ) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAl0lEQVR42mNgGBagh0LM0GOy
	Y/F/8Q1b/jOsPkQahhngv3/yf5UtazAUcK7d819ty+r/Aut34Dcg+MDE/6pYDEg90vb/1TPL
	/81nSoH8g7gNCDkw4b/61lUokk67Z/9PPtLx/9pDl/9Vp6r+++6bQpoLRDZsAxvqumfmf2Ng
	GElv2kh6GICcDRJX3LwOfxhQHAuUpoORDgAHGAv9eQI6vwAAAABJRU5ErkJggg==
}]

set flag(KGZ) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAV0lEQVR42mNgGBagh0LM0POf
	geE/ORi/AUxALADFTKQawALEAUA8DYoDoGJEGyAFxPOAOAOK50HFSDKgD4gnQnEfqQbAvDAJ
	agDJXqA4EEmNRkoT0hAHAP6AAglu7sTuAAAAAElFTkSuQmCC
}]

set flag(LAT) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAMElEQVR42mNgGBagh0LM0DNX
	yfQ/OZh6BmwMiP9PDoYb8J9MQD0XDHwgUpoORjoAAFp/AIzyhg+mAAAAAElFTkSuQmCC
}]

set flag(LTU) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAQUlEQVR42mNgGBagh0LM0PN3
	p/B/cjD1DFgyV+U/ORhuAEOWy3+yMNUMqLUz/U8OhhtwUF33PzmYegZQmpCGOAAALs8N1iQ5
	bmUAAAAASUVORK5CYII=
}]

set flag(LUX) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAPklEQVR42mNgGBagh0LM0PPe
	2OE/OZh6BnypavpPDoYb8J9MQD0DIg+/+k8OhhvAsPjBf7Iw9QygMCENcQAAuXtmDDx22ZEA
	AAAASUVORK5CYII=
}]

set flag(MDA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAfklEQVR42mNgGBagh0IMJNzW
	/UfGkeUF//9fYkDBd/3l/p/h1EfBeA34dZbh/9PdrP8/HGEDs0k24PQSgf+zIxXAGMQm2YBt
	swT/l8Wa/S+Mtv9/dokI6Qbc287+f0qx7P/5lbL/H+9iJ90AUMB9Os4ExmQFImmxQGE6GOkA
	AD2s7/Pzio0cAAAAAElFTkSuQmCC
}]

set flag(MKD) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAvElEQVR42mNgGBagh0LM0PMg
	WOP/+23a/99v1P5/20zt/w1FCH41SQuMYXyQ3PsN2mC1D0I0/sMNgCl4GK3x/+1y7f8P4zXA
	/EcJGmAMlosDyq0AysVowA2EG3DXUf3/LX2ozUpAxbEa/x+no2KQASA5kBqQWpAeuAE/Xur9
	//5c9//nUzr/3y7R/v+8XvP//UD1/9/u6oLx/QD1/8/qNMFyIDXfn+n+B+khzgVpRLiA4jCg
	OBYoTQcjHQAAeLkFn5aAW0EAAAAASUVORK5CYII=
}]

set flag(MLT) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAX0lEQVR42mNgGAygh0LM0PMf
	CL6///D/19dv/9HBeRFtnBhuwJeXr/7fvHzl/4OLl////fmLdAP+/vz5//X9h/8/Pn32/9+/
	f6Qb8B8PGDWAGgZI6OHEcAMoTYlDHAAANVeVtH4RcBUAAAAASUVORK5CYII=
}]

set flag(NED) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAVUlEQVR42mNgGAygh0LM0LNO
	RuM/OZh6BqxX1P1PDoYb8OfHz//kYLgB/8kEcAO+fvv5nxwMN0DJvfs/ORhugKJb939yMNwA
	Vc/e/+RguAGUpsQhDgB5s2TKBxsu1AAAAABJRU5ErkJggg==
}]

set flag(NOR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAnUlEQVR42mNgGAygh0LM0LOL
	R/8/DB+3ifhf1LLkv09yz//LqdX/keXQ8SAy4LRn8n8YvprXBDfgXs/c/8hy6BhuQGrFnP/I
	WNe94r+cVd5/dHF0DDcgvWruf2Ss51HxX946/z+6ODqGG3DKPfE/DF/NaUR4oXv2f2Q5dDyI
	YmEnn+F/GD5uF/m/GGiAH9iAmv/IcugYbgClSXlgAQDGiVYq5k6CqAAAAABJRU5ErkJggg==
}]

set flag(POL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAANElEQVR42mNgGAygh0LM0POf
	TDCcDHjTMvM/ORhuwB0Rm//k4MFkgJzLf3Iw3ABKU+IQBwDeL59czrIU1QAAAABJRU5ErkJg
	gg==
}]

set flag(POR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAnElEQVR42mNgGAygh0IMJNIY
	/qPjbGuG//8Z8GPaGMAExPYtnP97S7n/v3Tm/v+bi0QD4qYx/H9QoP3/Wkvl/8eRzv8fhZFo
	QPJUhv+Himz+bzhw//+54tT/N8pINMCpleH/smrh/w+z8//frFT7/7SajDCwbGT431vM/v+1
	HcP/P5z0iAWWVMb/6DjPhun/f1ZWvBjhAgpT4hAHAHKABaa9wBCuAAAAAElFTkSuQmCC
}]

set flag(ROU) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAS0lEQVR42mNgGAygh0IMJLTr
	/yPjiNSo/38uiqHgeyEK/88JqqHgUQOGlwGs+o3/kXFkWsz/H+ckUPCdUIX/Z4XVUDDCBRSm
	xCEOAOdfL0I9QRIEAAAAAElFTkSuQmCC
}]

set flag(RUS) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAU0lEQVR42mNgGAygh0LM0POf
	TEA9A37++vOfHAw3gN1uxX9yMNwABstl/8nCMAM4Leb/JwfDDbisLfefHAw34CqQQw5GGKCv
	9J8cjAhEClPiEAcAzq5qUCXvgWMAAAAASUVORK5CYII=
}]

set flag(SCO) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAgUlEQVR42mNgGBagh0LM0PP3
	37//X3/8+d+88c5/3rTd/xnidmDFPEC55g13/n8BqgXpgRtg13ry/+Gb7/6DwL1XX//HzLj4
	nykeoRHEjp5+8f/dl1/BakBqQXrgBuBThNdwZAPQnfkV6ky83sNnwBdSDaDICxQHIsXRSGlC
	GuIAADk6WvX4px/lAAAAAElFTkSuQmCC
}]

set flag(SLO) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAYElEQVR42mNgGBagh0LM0POf
	TIBhwJHdX/+7un75f2TXV9IMiIz8/x+MPd79X74cQsPF8GC4AQwMIM7//ywMv/+7Gb8G0zAx
	/BjmAoal/8nBiDAgzjoMTD0DKE0HIx0AAE8nHBU0bZbUAAAAAElFTkSuQmCC
}]

set flag(SRB) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAA2klEQVR42tXSzQoBURwF8HkA
	GxuPMqkhSg1beQd5AFnNjjJTdrJQVoSEGdPsaEYKS6n5WHsDezWOmrq3220SzYZTv/p3T53V
	FYRfSC8hoXcWc2CdslKEf+fFDhwrMvaNGpx6Nbo/GjiIeRBOuQRbk2CrEhy5BLbj0YF0oQli
	3u7DVRW4XQXL7gBsx6MDqWILxGK1hW9sImt9B7bj0YFMRQGhTy34uoHAMGDOLLAdjw6E4RPE
	zZzgOtJwGXZw24zBdjw6ACbh44F74OHue9H9LrED34QOJP2Jf54Xir52CgrqQtMAAAAASUVO
	RK5CYII=
}]

set flag(SUI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAV0lEQVR42mNgYGDooRAz9Pxn
	YPhPDqaxAQoK///Hx0MwiE2yAWFh/+EAxKaPASCnghSDcH8/wgAQGyaO5B1MA0D+JQRAamhn
	AMVeGPhYoGpComteoAQDADBc9khZcwObAAAAAElFTkSuQmCC
}]

set flag(SVK) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAyElEQVR42mNgGAygh0LM0POf
	TEA9A/78+fsfhL9Nm/X/Y2T8/6/tPf8/hsf+//P9x3+YHDYMN8AgaOV/ED7sFv//S2nV/x9r
	1v9/b273PzxtzX+YHDYMN0DVa+l/EN7nmvD/Q0jU//dtPf/fm9n+90lY/R8mhw3DDdD3mPcf
	hEujJv8PdWj/7+Q86X9jaNd/E58F/2Fy2DDcgDeyqv9B+K28+v+1vvlgzU/0rP7DxHFhuAFv
	ZVT+k4MRBiho/CcHww2gNCUOcQAATpV4OUT0Md0AAAAASUVORK5CYII=
}]

set flag(SWE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAd0lEQVR42mNgGAygh0IMJIIm
	/0fG8+aa//93muG/YmL9f3Q5FDx4DMhsCf2PjI9tUAAbUNvr9R9dDhnDDQApJgfDDYivj/6P
	jA+tUwIrKOn0/48uh4wHUSByRU7/j4znzbP//+Mk13/N9Nb/6HLIGOECClPiEAcAPEQsA8Zi
	N2gAAAAASUVORK5CYII=
}]

set flag(TJK) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAdElEQVR42mNgGBagh0LM0HNH
	TPY/ORhhgLjcf3Iw3IC/X778x8CfP///8/YWGIPY2NTADfiPBfz7fv//v58vgPg5mI0NwA34
	8uPrf3T8+euL/x+fLAHixWA2NjVwA6SqDf+Tg+EGSFYb/CcHww2gNB2MdAAA15QnAprMoDgA
	AAAASUVORK5CYII=
}]

set flag(TKM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAA4klEQVR42mNgGAygh0IMJFps
	/1tU2v6fm+r6f0lW8H/Vauv/rG2O/0HieDGyAXbllv+3hrv+3xRu8l+rxuq/4pSw/7xd7v+N
	5iQTZ4B1seX/KTkW/6fnWvzXLrX6L9DjCTYkZE0tcQbYAl2wys/4/9oAI7ALGFvs/itODiPe
	C5ZFlv+nhgFdEGr2X6PCirD/McKgAqg52fz/rGSz/zo1ZBjgWGnxf22E2f8N0cAwqCXHBTmW
	//e2pv/fXxf3X7uYRANY2xz+u+Ra/z/vYPz/goPBf71i2/8gMUIY4QIKU+IQBwAP6AZ87LPQ
	wwAAAABJRU5ErkJggg==
}]

set flag(TUR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAlklEQVR42mNgGAygh0LM0POY
	S/w/OZgGBnBL/H9fXPX/8/Q5/1+Hxv1/Iq5MmgHvsor+f9ux5/9jARmIIj7p/8+0zP4/EVUk
	zoAvS1b8f5dfDlfwVEbj/49TZ/6/Dk8gzoC3GQX/v+/a9/+xoBxEET/QBRom/58IKxAfBu/y
	yv5/njabvDAgPxb4pP6Tg+EGUJoShzgAAA34KBzqw0BYAAAAAElFTkSuQmCC
}]

set flag(UKR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAOElEQVR42mNgGAygh0IMJMK3
	/ycLDyMDGmdE/icHww34f53hPzl4EBnw+yrzf3IwIhYoTIlDHAAAqIhO3CegkI4AAAAASUVO
	RK5CYII=
}]

set flag(UZB) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAWUlEQVR42mNgGBagh0LM0GPQ
	+P1/2Iwf/0G0eSsCg/j4MIoByQt+gDV5Tvjx37bz+3+bDhIMOLb/4X9yMNyA/2QChAsOrP9P
	DkaEQbvFf3Iw9QygNB2MdAAAIdAuuDlm4L0AAAAASUVORK5CYII=
}]

set flag(WLS) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAABeUlEQVR42mNgGBagh0LM0PMf
	Dfz98+f/58dP4fx/f//+//3jJ4T97x9cHMWAnx8//3954tz/S80T/h+w8Pt/JrcGrOj1oZP/
	T3rE/r9a2/3/4aI1/399//7/892HmAZ8e/v+/63lG/7fmrf8/zY12/8Xkkv/P123/f9WAe3/
	u/i0/h9SsPr/aNOu/1fqev4/XrkJ04CPt+79v5RX9//l/qP/1/Cp/z8Tlvn/lF/S/218mmAD
	TiUX/78zef7/o3YhcG/ADWDY6PBfaor1/1w/o/81Dgb/t0I1bQbSO4A0iL2PX/v/HG39/ybN
	Vv9B6sEY2QAQ5lhh97/Q2+j/XDmt/736uv/zvAz/7wZqzAg2/u9aaP6/xt7gv2aHJW4D9OvN
	/8dFG//3yjH7L9Nv+T801vh/rZXef5N6i/8e6cb/K10M/4vMtsFtgPBcm/+8i23/8y+w/c+y
	2u4/51Lb/7yLbP8zrbX/LzDf5j/Hcrv/PEB5TAMoTEhDHAAACJQ+Hm1krYMAAAAASUVORK5C
	YII=
}]

set flag(ZZX) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAABNVBMVEX///8AAAAAAAAAAAAA
	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABJapdLbJtRcqFYe6lag71ahL1bhL1bhL5d
	hb9dhr9fh79ggrFgiMBhicBiicBjisFki8FljMFoirlojsNqj8RqkMRuk8Vxk8B0l8d0l8h4
	msd5msl7nMp8nct9nst9n8t+n8t+oMyCoc2Coc6Cos2Doc2Eo86FpM6Gpc+KqdGMqdGPq9KQ
	rNORrdOSrtSTr9WUsNSWsNaXsNaXstaZs9aZs9eas9abtNabtdectdiettmguNmhuNmhudmi
	udmiudqiutqjutqjutukutqku9ulvNupv9yqwN2swd6vw9+0yOK3yeK4yeK6y+O9zuW/0OXA
	0ObB0ebF0+jH1unK2OrM2evR3u3a5PHn7fW1W/LeAAAADnRSTlMAAwYJDA8SFRgdICMqN3e1
	3vkAAAC0SURBVBgZXcG7TgNBDAXQa4894bUrUCoaFmok/v8PqIE+IgUSEBAQdtjMy4NSJco5
	wAFiYexYEb3DVgNh61FcHVCzF+Ss0pZOqPyOcvnhZ7F7T2eFGCmE4SSN4/xomEICo6bqn/Xm
	2hZapwpB/p7+Ls5fr1Y/01oMjGjxq395a+k2hRbB2Bgv1If7rn8i28B5nrXxc27aPazURaNT
	6YFsvhVSYF3oWLEvO3LY0zIRE3aa4dA/cfdVCR8ES20AAAAASUVORK5CYII=
}]

} ;# namespace 16x16

namespace eval 22x22 {

set flag(ALB) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAs0lEQVR42u3UMQ6CQBQE0G9H
	ySksvAImNNzA3tDY0VPSkNiQEFougPEgcBmbTSzQwmXQicF2dwkW/OQ1w+5U/BVZZzLFTKTQ
	Itql5YoV3KGFG7XMlE1xBWeI4UQxs8qmOIM9BLClgFlmU3yB8HPwR8hvxsU5HMGHDfnMcpvi
	KyWwo2SSGxW/oIYGUjhQyqzmGePfbbzcQUQdM+ViQR5Q0tP15vX0Jyvtedqlb/Fcz+Y67xkA
	tBQ0hsZB9ucAAAAASUVORK5CYII=
}]

set flag(ARM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAARUlEQVR42mNgGAVDGvTQCDP0
	3GQQ+k9NPIQN9lPI/U9NDDeYwXjBf6pimhscFpv2n5oYbvCnFQz/qYmHsMG0ytKjYIgCAJ7+
	yXwO6mC3AAAAAElFTkSuQmCC
}]

set flag(AZE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAeElEQVR42mNgGAVDGvTQCAOJ
	rY/+UxUPXYNnJlb9x4dnN07/P3fupv+z8lr/E1ILwnCD3xs7/MeHf6ze8P+9ieP/T9Gp/782
	df0npJ72Bm+NtPyPD++oCP+/a2rR/22prv8JqQVhuMEB8/T/UxMPYYNplaVHwRAFAD24/8v9
	KFBoAAAAAElFTkSuQmCC
}]

set flag(BAS) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAABBUlEQVR42mNgGAX0AD00wkBi
	lvt/5pnu/8Nyzf7vMVf6f1VbDgN/v3UDjLHJ7QXqCQfqBZkBMgtu8Awvzf9GDbb/GWZ7/Oed
	7Po/L8Ho/3EjBYIGg9TkJxj+5wPqAek1arD7DzILbjBI0WUg7gzS+a/a7gBWJNbv/L8uQv//
	WT15DIPPAcXqIvT+i/c5g9WqAPWA9F7WgViIYjAMnwdqKo4z/C840QWsSbnDAegKLbjBM4Eu
	UoFaDlJTBFR7Dmo5DMMNflyc9R8dn6/N+1+wvvF/2J62/+F7Wv8/+fQSjEFskFg+UA6kBpte
	uMH/qQxo72KahTHNUgXN0jHNch6tyopRMEQBAEVYQf3+ajqhAAAAAElFTkSuQmCC
}]

set flag(BEL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAU0lEQVR42mNgoCHooREGE/+x
	4Sg/3v9/b6lixV/yzf6/N3bAikcNHjV41OBRg0cNJs9gVhbG/9hwfAD//z/X1LHiL/mW/99b
	uGLFyC6mSQ0ytAAAjmn8h/3qzBUAAAAASUVORK5CYII=
}]

set flag(BIH) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAA60lEQVR42mNgGAVDGvTQCAMJ
	5an/QZhJddr/8Lyd/wMztv0Pjq/7/+EQ+/9/pxnw4uDIlP8w/XCMbjAM1/Sd+G8Xse5/cEwB
	QcNJMhiEM2sPgLFzYDlew0k2mEV9+n+zoNX/Zyy78t8zJAen4SQbDMIChrP/a7ot+9867cx/
	r/AqrIaTZTAMx5fu+e+RuPl/dHIxhuEUGQzCOQ2H/luGrP3vE1mNYjjFBoNwYcuR/4WtR/77
	ReTBDaeKwczAdK7vs+L/9KWX/9v6lIANp4rBsAg18Fn5v37Cyf+hcYX/XQNy8BhMoyw9CoYo
	AADhBsGtl2PcxAAAAABJRU5ErkJggg==
}]

set flag(BLR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAjElEQVR42mNgGAVDGvTQCDP0
	3M8q+P+4tun/FVPb/+fEFSjGcIMfFlf+f9bR+/+avRt1Db6blPH/UVU99Q1+kFv8/25c6v9L
	uqbUNfhZV9//F1Nm/L/h5ksbg69T22BYUCxws/zfYq1KMcaIPM+WwP8MNQaUY5Tk1tlLfYNh
	GcS92oO6BtMqS4+CIQoAd7+0x+yIP4oAAAAASUVORK5CYII=
}]

set flag(BUL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAANklEQVR42mNgGAX0AD00wgw9
	/6kMRg3GNJhhWt5/quJRgzEMvqYm9J+aeNRgTINpVQiNAtoCAB47qQ/7xPZjAAAAAElFTkSu
	QmCC
}]

set flag(CAT) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAbElEQVR42mNgGAVIoIdGmKHn
	z13O/9TEcINfFgj9pyaGG3xPT/w/NTHtg+JpiMh/amK4wY+9RP9TE9M+KB65if6nJkaEcQQw
	bKiIaR8UdzUl/lMTww1+VSr4n5oYKSj4/1MTww2mVek2CmgLAOS/spex8r9VAAAAAElFTkSu
	QmCC
}]

set flag(CRO) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAvklEQVR42mNgGAVDGvTQCDP0
	/Gdg+E9NTJTBf5hZ/t+U1Px/WNX8/yZ1p/+XJXXAYhQbfEdO479D/tL/RS55/xMTiv5HZUz4
	/0BWjUiDFy/+jw/fCU/8/6+gAIzvAdmE1CMMJgQ2bPj/PzsbgkFsAoB4g5OT//+fMgWCQWxi
	DV69+uZ/fPjG/K3//5eW/v9fUvL/xoKt/wmphxssLj7tPz6srTz9f2/ENCCeDmYTUk+0waRi
	2htMqyw9CoYoAAAUWR2sGd/0wwAAAABJRU5ErkJggg==
}]

set flag(CZE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAA2klEQVR42mNgGAVIoIdGmKEn
	vmnF/ycvP/ynFoAbLOha9181tPP/yt0X/v/9+5e6BsNwSOWi//efvqW+wSCsEND2f9KqI/9/
	/f5DXYNh2LNwzv9zN55Q32AQFvdq/N++cN//z99+UNdgGE6Mafj/qq2TKEyUwRLOVf8rtD3/
	nxeV/X9dRIooTNBgV4vk/5tkdIg2kKDBCo5l/5s0Xf5fEZEm2VDsBrvU/vczjf+/X1KVLAOx
	GqxqX/x/qor1/2sUGIhhcLRF3P8jcpr/b0jKUwXDDaZV6TYKaAsAEOPmFVQKnn0AAAAASUVO
	RK5CYII=
}]

set flag(DEN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAgElEQVR42mNgGIqgh0aYoeeE
	gN5/bPhp/9z/IPBq6Yb/uNRgw6MGDweDXy5c+x8b/nL5Btjgb7cf/MelBhuGG/yfygBu8LNJ
	C/5jw5/PXAIr/Hrt9n9carDh0VQxHAw+LWf9Hxt+OmH+/7/fvv9/tWT9f1xqsGG4wbQqj0cB
	GAAARzMTTjlTH9cAAAAASUVORK5CYII=
}]

set flag(ESP) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAA4klEQVR42mNgGAVIoIdGmKFn
	rajkf2riIWzw04ls/7Hhx/3YxQlhuMG/9jL8R8cP5nD/318q8v9SB9//H3sY/2NTgwvjNPjm
	PKb/J8u4//faKPxflqv3//YiZuoYfLJP8/9aH8H/M3yc/69tnP7/cKP2/+87qGDw0TrL/xsj
	+f4XGJr/nx7k/P9wlc3/L5sYKTd4/RST/1uLBf5P8tH5P8dD/P+yfqv/33YxkW7wk172/8j4
	ZjvP/wfdHP+vtgj+f9DF+f96G9//Rz2oavDhIZxB1kvL/6cmhhtMq9JtFNAWAAD/MW2kgrY7
	dQAAAABJRU5ErkJggg==
}]

set flag(EST) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAQUlEQVR42mNgGAVIoIdGGEgU
	nftPVTxqMKbByvb/qYrhBjMw/KcyHqoGJyQk/Kcmhhv8n8pg1GBMg2lVuo0C2gIADdaam6+D
	fKYAAAAASUVORK5CYII=
}]

set flag(FAI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAqUlEQVR42mNgGIqgh0aYoec/
	FlC56ub/2U6Z/98bO/zXDFv8/96rb/+JBaMG09HgBYef/EfHPn1nUQzu2Xb/PzZ12DDc4BTv
	1v/Y8D7rCLDBNe6V/3GpwYbhBoM0UxPDDU70af+PDe+FurjSo+o/LjXYMNzgJUef/kfHvv2o
	Ydy/4/5/bOqw4dF0PMAGV6++9X+Wc/b/N8aO/7UjFv+/T47BtCqPRwEYAAAffglKD9BeJgAA
	AABJRU5ErkJggg==
}]

set flag(FIN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAcUlEQVR42mNgGAX0AD00wgw9
	/7GAScsO/GfQzwFjVd/G/6SAUYMxDY4sn/8fHRtHdMIN5rUs/o9NDS4MNxhmANUwzQ2OrV70
	Hx2bRnUhgsKq+D82NbjwaHIjzuApKw78ZzbMA2PNgGbyDKZVITQKaAsAEUYA5R7i8zIAAAAA
	SUVORK5CYII=
}]

set flag(FRA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAUUlEQVR42mNgGAVIoIdGGEio
	hfzHhqOLJ/7HBe6nlfw/J6iGFY8aPGrwqMHD02BWzbD/2HB86cT//379worvp5f8Py+mhRUj
	XEyj0m0U0BYAABVwr6ACXKMpAAAAAElFTkSuQmCC
}]

set flag(GBR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAyElEQVR42mNgGAX0AD00wgw9
	/6HgzoNX/8Nz5vxnVMxEwZ+On/t/QkAPjEFsdPmw7Nn/b99/BTPmP9zgHQev/v/37x9YEESv
	3HLmv4pDLUGDle1r/6/YfBpFL8gsuMEgRW5xk/7fuPsCbuv3H7/+N03a+p9PtxDDYD6dgv+N
	E7eA1cDAzXsv/rsDzQCZhWIwCOPSgG4wLgfAzIEbDFKMD7+YuxJuMIhNSD3cYJgmamHaG0yz
	oKBZ5NEsudEsg9AsS9OqEBoFtAUAuN683fDHK6AAAAAASUVORK5CYII=
}]

set flag(GEO) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAzUlEQVR42u2UMQqEMBREU3kN
	Cy9g5TX0Blp4Dm0sLLyF4NUs7EQLC5llCBIXNvkpzFYODPxi5oE/iUq9umkIZDVA0jgCSmlz
	FvQbvK5A1/mDmWXHCd42IM+BOAaaRgYzwyw77FrB5wksC1DXwHHIYGaYZYdd5yoe3XGawml+
	7gXmLOQN+Co9ZAPOMjidJKbIWcj/8R7zZOcZqKqv62MFM1OWuuO8FfsOFIU+oLaVwcwwyw67
	4svre/9VMCu+PJumCYgibc6+Ow71d3sVVh8i+3egfvXZXAAAAABJRU5ErkJggg==
}]

set flag(GER) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAANUlEQVR42mNgGAX0AD00wmDi
	P5XxqMFoBt8FcqiJRw3GNPj/OYb/1MSjBmMaTKtCaBTQFgAA7lDpcPgL908AAAAASUVORK5C
	YII=
}]

set flag(GRE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAy0lEQVR42mNgGAVIoIdGmKGH
	N279fxCWy9zy/9+/f/9LFl38DxMjBxNlcFj/8f99W26ShOEG65Xs+g/CdnX7wQa3r7/+HyY2
	advt/3dffCYJww3+jweULr5IflBETzr5H4TTZ50Fu3jhgQf/YWLdm27833DqCUmYqDAuWHD+
	/+6LL0jCtE8VB66++g/CR2+8ARt8+/nn/zAxcjDc4FXHHv+nJsYICmphuMGP3nz9T00MN7hj
	w/X/1MRwg4WTNvynJoYbTKvSbRTQFgAA3L8X+yfaqdAAAAAASUVORK5CYII=
}]

set flag(HUN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAQ0lEQVR42mNgGAVDGvTQCDP0
	nNO0/E9NPIQNfrtp+39qYrjB/6kMaG/wntMH/lMTww12Lwj4T008hA2mVZYeBUMUAAAmzEMH
	adUMjAAAAABJRU5ErkJggg==
}]

set flag(ISL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAaUlEQVR42mNgGAVIoIdGmKGH
	KWjOf3ScPOXQ/5clTf/vyJn+P3L9xX9sanDhUYPpaPCkLVf+o+M9F5/ADX769ut/bGpwYbjB
	TwKT/2PD9w3dwAbjkseFaW8wzYJiNLkNYYNpVWyOAjAAAFcKr4G+v6L5AAAAAElFTkSuQmCC
}]

set flag(ITA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAUUlEQVR42mNgGAVIoIdGGEhM
	cvuPDUfv7PiPC9wvr/t/TtscKx41eNTgUYOHp8HsU7z/Y8MxOzv///rzGyu+W9Xw/6y+FVaM
	cDGNSrdRQFsAALgN3c7l6HfJAAAAAElFTkSuQmCC
}]

set flag(KAZ) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAA5klEQVR42mNgGAVDGvTQCDP0
	iG/Y8t9w+9L/DKsPUQfDDLbfPfd/4+ky6husv33Z/4yjLXgVy23a8D/4wMT/rntm/udcu4c4
	g812LPpfdKIOp0KOtXv/N54p+//rlf7/e4/t/zvsnkOcweY7F/4vON6AVRHX2t3/QfLzL6f8
	//9G9//v1/r/vfdN/W+8YzFlBosBI7bsZA3QsGn/V1yN/999ruC/7a65/9vOFlMeFGpbVv9X
	2bLmvwXQAbrblv83BaoHWUiVyGNcffC/za55/533zPovsXHzACc3MVplEFpl6VEwRAEAKhsS
	oYtgwYAAAAAASUVORK5CYII=
}]

set flag(KGZ) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAc0lEQVR42mNgGAX0AD00wgw9
	/xkY/lMTDwKD+YBYDor5qGWwNBAnAfFsKE6CilFkMB/UoMVA3AHFi6FifJQYLAd15VQg9oPi
	qVAxOWoYXADEE6C4kBoGw4JiLhAvguK51AgKmkUeTZPboMx5tCqERgFtAQDgdxW+khc/cgAA
	AABJRU5ErkJggg==
}]

set flag(LAT) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAL0lEQVR42mNgGAVDGvTQCDP0
	zFUy/U9NPGowpsH/qQxob/Bo5NHeYFpl6VEwRAEA5Xf6UIJWUaQAAAAASUVORK5CYII=
}]

set flag(LTU) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAOUlEQVR42mNgGAX0AD00wgw9
	f3cK/6cmHjUY02CGLJf/VMWjBmMYfFBd9z818ajBmAbTqhAaBbQFAKRLMB8nm07WAAAAAElF
	TkSuQmCC
}]

set flag(LUX) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAANklEQVR42mNgGAX0AD00wgw9
	740d/lMTjxqMafB/KoNRgzENZlj84D9V8ajBmAbTqBAaBbQFAMsd6v9Tdt4ZAAAAAElFTkSu
	QmCC
}]

set flag(MDA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAoklEQVR42mNgGAVDGvTQCAMJ
	t3X/seHoivz//y8xYMX3AuX+n+HUx4oH3uAH2zj+n1vK8//xDn4wm2oGF4ao/F8aJwnGIDZV
	DP58kvF/eaTJ/wl+mmDclWL2/8tJKhj89wLD/5Rotf+RCXb/vaJ8//fl6fz/d5FKQbGqlef/
	wlLF/0sqFP/v6uWmXhiDXHhpFRcYg9iDP7mRbzCNsvQoGKIAAAA12Xn6zUnsAAAAAElFTkSu
	QmCC
}]

set flag(MKD) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAABCElEQVR42mNgGAVDGvTQCDP0
	PAjW+P9+o/b/7y90/79dof3/loHa/xuKqPjTcR0wRhe/pa/2/+1yiN73m7T/PwjR+A83GKbo
	YZzG/w97dP5/Pq0DVoBswOsZWmCMLAZSA1IL0vMwHqEew2C4BZFAH2zT/v+yX+v/TS2I2ONU
	DTAGsUFiL/u0/n/YDjQwSgPDFzgNBmMltf+PUjT+v56t9f+ug/r/R0kaYHzHXh0sBrZECYs+
	ZIO/3df9//kM0Es7dP6/Xab9/9Ukrf/P6zX/P87WALvoWbUmMAz1wOEIYoN8BJIDqQGpfbtU
	G6wXZMa3e7p0MJhmQUHzyKN6cqNZBqFVlh4FQxQAAE/cBmtVGoDeAAAAAElFTkSuQmCC
}]

set flag(MLT) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAk0lEQVR42u3UuwrCMBiG4VyE
	k7fg5H323lziiR4ED1FLEU9gS5O8FofiUoiQOOWFf32Gb/iFiH2VBDqR0GXbluvugGkahpqN
	Jk7Xw7quueQbitWaKs3RA/jP8G2vKBZLpJRkcs5dHf3A1lheZcU2zXioE9ZaP/BnY615nktM
	t7W3jXEswhH+JzyeOl0Ph/pusbC9AQxcMuF5dvURAAAAAElFTkSuQmCC
}]

set flag(NED) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAATElEQVR42mNgGAVIoIdGmKFn
	nYzGf2riUYMxDX6yded/amK4wf+pDIawwRv3XftPTQw3WNGt+z818RA2WN277z81MdxgWpVu
	o4C2AACj+9DTVTn5kQAAAABJRU5ErkJggg==
}]

set flag(NIR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAo0lEQVR42mNgGAVDGvTQCDP0
	/CcA/n79+v80HycYg9iEANEGf3rz/P86c4n/600lgOxn1DP4x6cP/5cXaP9fnq8JZlPF4D9/
	/vz/+u7d/8v1df8vl5eB2SAxogw+w8DwHx9+MmfO/xutrf+vNzaC2YTUk2Tww46O/7dra0kz
	mJiguF5QAMYkBQUxye2sqCgYUzW5gQ3m5ATjwWEwrbL0KBiiAABvk9KDGnJn0QAAAABJRU5E
	rkJggg==
}]

set flag(NOR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAvElEQVR42mNgGIqgh0aYoWcX
	j/5/dHyve87/yLwp/xkUov9fuvHo/yEtz//Y1GHDowbT0eDLaTX/0fGrbQdQDL5Z2fMfmzps
	GG7wlIW7/mPDxr41YIOrulb+x6UGG4YbDNJMVQwzePqSPf+xYRO/WrDC2t7V/3GpwYbhBl9K
	qvyPjl9u2Y8SxjfKuv5jU4cNj6ZjehrMb/QfHd/tmv0/Gmgws1LM/0vXHvw/pOv9H5s6bBiR
	jmlUHo8CMAAAcC/Fmk5SM0kAAAAASUVORK5CYII=
}]

set flag(POL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAPUlEQVR42mNgGAVIoIdGmKHn
	P5XBqMHDweA3TdP/UxPDDb4jYvOfmnjUYDoafFfR/T81MdxgWpVuo4C2AABQF0cCokIbUwAA
	AABJRU5ErkJggg==
}]

set flag(POR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAA/klEQVR42mNgGAVIoIdGGEik
	MfzHh/8zkIaHmcGMQOzUxvA/uI/h/9Nghv9vHBj+/2Wk1OBUhv+Vixn+L8mQ/L/Omf//U13+
	/2fDJf/fSmH4/48Sg9UqGP4fPAN0qYPx/7vnrv2/e/ba/6f2xv/vZTL8/6xCgcEuwCDoW8Xw
	/1KS+f8Vu+78X77zzv8ryRb/r/Yy/H/pRIHBKuUM/zNmMPw/4SP5/8aO7f+vb9/2/3aUzP8H
	8xn+f1GiMIxTpzH8r5/A9X+rJd//16r8/693cP9/WEJhGMNShWMrw/8QYKp4EgJJFf+GfwZh
	S2X6jw//Z2cnCSNcTKPSbRTQFgAAchYJno05iAkAAAAASUVORK5CYII=
}]

set flag(ROU) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAU0lEQVR42mNgGAVIoIdGGEho
	1//HhqPSIv//uSiGFd8LVfh/TlANKx41eNTgUYOHp8HsBk3/seHojNj/389KYcV3IpT+nxVR
	w4oRLqZR6TYKaAsAA29frWChL1UAAAAASUVORK5CYII=
}]

set flag(RUS) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAATElEQVR42mNgGAVIoIdGmKHn
	P5XBqMGYBgdVHvpPTQw3mMFy2X+q4qFrsJdJ2X9qYrjBV7Xl/lMTD2GDrxmo/KcmRqQKGpVu
	o4C2AADsgNkbiAhcsAAAAABJRU5ErkJggg==
}]

set flag(SCO) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAArElEQVR42mNgGAX0AD00wgw9
	/6Hg9ouv/8OmXPjPELeDJBw65TxYLwzADd5+6fX/f//+gQVB9MoTz/8rlxwkaCBIzYoTz1D0
	7gCaBTcYpMit6/T/G8++wG39/uvP/8b1d/7zpu3GMBAk1rD+9v9vP//A1d98/uW/O9AMsBpk
	g4nSQKwD0A0m5EWigwyXwbgihehIprvBVA8KmkQeTZIbzTIIzbI0rQqhUUBbAACG6NS3RwgN
	0wAAAABJRU5ErkJggg==
}]

set flag(SLO) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAgUlEQVR42mNgGAVDGvTQCDP0
	/KcywGrwzx9//x869AOMf37/Sz2Dr+x9/p+f/wcYXwWyKTI4Ovr/fxiOc3v+f+PGf2AMYiPL
	EYvhBjMwgDgQzMTw539B4H0wBrGR5YjHWAyG4H9Q/J8yg6MZFv+nJkZEHvlOw4qHsMG0ytKj
	YIgCACKUM4MN2O0KAAAAAElFTkSuQmCC
}]

set flag(SRB) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAABQElEQVR42u2UPUtCYRxH/QB9
	HbNCo5qS3qCld4kkiEKnEqrNQgikIB28FWVvQkGDRGRYeqkeKxwKFQobtKylwKWpxVMtchFu
	JHk3D5ztx+HPMzw6XRUFbo3UuWO1Rirpr2FhMBLtbOeotw1hbK5MWNQ3cj5jJdJv4sJmJuro
	QXR1VObiE4sJ2aUn5DRwPFmHaDCVH241WlE62zJAbMLKnc9G3G1HTPWx2T1C6U7NYrimyYFS
	y9gCOVnmYV0iK59y7/Gw5tundKemanjIvkQ2m0E450n5t0jH40irB/8PD466eHl+Irm9Q+4s
	QiaRQPIGyg8PO3dRujgnkQ4FufF6ud3wkwrucSgFKN2pWQxTwmc+z/W0meTKMunvt74c1/Me
	F/wV1fAPH9lHcuEwr7Er3oRMoVCoTPg/aB/W6neroi1fG8Pw1VF0WioAAAAASUVORK5CYII=
}]

set flag(SUI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAXklEQVR42mNgYGDooRFm6PnP
	wPCfmng4G2xq+v+/rS0Eg9hUM/jBg/9wAGKPGkyZwaDIAWlGxr9/IwwGsdHl0SIUu8GgmCcV
	gPQMnME0C4rR5DYwBtOsEBo5BT0tMABaeOmeWmnUegAAAABJRU5ErkJggg==
}]

set flag(SVK) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAA0UlEQVR42mNgGAVIoIdGmKHn
	P5XBMDH4+7xF/z+Gx/7/Ut0AxiA2SIwsgws6j/yH4Ruxuf8/+Ab//75kBRiD2CAxZDWEMNxg
	Va+l/2H4rH/K/0/JGf+/TZ0JxiA2SAxZDSGM1eBTAen/31s6/P+UngPGIPZJoBjFBs+Ja/8/
	Ty/sf71dCRiD2CAxsgzOtar4D8MNXvX/Y+MXwxWB2CAxZDWEMNzgtzIq/5HxC2Pb/1NjOv9P
	AWIQG12eEMZpMKWYDgYraf2nJoYbTKvSbRTQFgAAM9j1gdDntvEAAAAASUVORK5CYII=
}]

set flag(SWE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAgklEQVR42mNgGAVIoIdGGEgE
	Tf6PDR9cq/z/32mG/9tXav7HpQYrHjWYfgaf3SzzHxv+dJQNbPCHI+z/canBhuEGgzRTE8MN
	3rdG5T82/O4wB1jhm0Nc/3GpwYZHUwUdDeaPmfkfG967zvD/15N8/7esMvuPSw02jHAxjUq3
	UUBbAAAz51h0RFUyWwAAAABJRU5ErkJggg==
}]

set flag(TJK) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAf0lEQVR42mNgGAVDGvTQCDP0
	3BGT/U9NTHuDH1o7/qcmhhv8nwD49/PF/7/f7oExiE0IEG3w3293///7/hCIH4DZVDH4378/
	//9+vfH/78eTEAxk//v3m0oufr///5+XK8EYxCbaxXYTAv9TE8MNlqw2+E9NTHuDaZWlR8EQ
	BQDMcFBTexBofAAAAABJRU5ErkJggg==
}]

set flag(TKM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAABR0lEQVR42mNgGAVIoIdGGEi0
	2P4H4fx8s/8Lk8z+z40P/r81M+A/TJxkjG5wdpHb/0Vlaf8npbr9X5/lDFcoPTHwv2if73+x
	Pj/yDK7ONf2/x8Pk/xZfo/+ngg3AYpITAv7LTw75z9nh8j9yfSN5BiekW/7vLLD5PyPJ4v+s
	eDO4QvF+//9s7Y7/mw8vJNPF+ab/9wYa/d/jb/T/ZJQBXCHI1cFraoBBEkSewVkpZv8nRpn+
	74iw+b803Ih6kZeVbPa/N8rsf2OE9f8lYVQ0uDbf5P9eP4P/2/xQg4JigwuBYRxXYPu/KtXp
	f3+mKRVdnAd0cYDh/81h5v9PRVLRxSUp1v+Ptkf/PzKx/v+eeC/qGdwQa/H/cGrc/wPJbv9P
	e1EhKNjbnf6DcBMwCK65Gf6/bGf4/4qD4X+YOKkY4WIalW6jgLYAAIyRC4DGLkUIAAAAAElF
	TkSuQmCC
}]

set flag(TUR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAA1ElEQVR42mNgGAVIoIdGmKHn
	MZf4f2riYWTwU2X9/x+7J/7/tmXH/49tPf9fWLtRbvBTWc3/v+89+P99/6H/z9SM4BY9EVH8
	/5hbgnyDP9S3/f/76fP/p0p6GBreZhT8f+Ub9v+JsDzpBn9ZvOL/z0tXMBQ/17f6/+vq9f8/
	Tpwm08W1Lf//fv7y/5mKAaaLU3P/v3IPJM/FT6XV//+6fff/j8PH/j/TMQeLPVM3goQxxalC
	Qef/x9bu/982bIGkCkvnEZNBBGT+UxPDDaZV6TYKaAsA6RVQ2AVxWW0AAAAASUVORK5CYII=
}]

set flag(UKR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAP0lEQVR42mNgGAVIoIdGGEiE
	b/9PVTxq8DAwuGlG5H9qYrjB/68z/KcmHjWYjgb/usL6n5oYkY5pVLqNAtoCAGpCoQPaPRS3
	AAAAAElFTkSuQmCC
}]

set flag(UZB) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAaklEQVR42mNgGAVDGvTQCDP0
	GDR+/2/Z9v1/+Mwf/0FsELbtRGCYGLEYxeCy1T/BhqMbSrHBTj3f/0fN/vHfrpOKBp/ZevU/
	NTHc4P9UBrQ3+My2Ff+piRGR127xn5p4CBtMqyw9CoYoAAChEFlw1INlvAAAAABJRU5ErkJg
	gg==
}]

set flag(WLS) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAACX0lEQVR42u2USUjUYRjGh+pS
	4DKCJtIhHKbUWRx1ZnQcG5U29CCILTYuZB3M0CywIpS6KIRIHqSFwKCyLNNcalxqnFIUpYVS
	sJLWYToILhOFGWX++s+f9ODoVAc7+cAD38bved/38Ekky/ofqlgiSyrwoJmZGf5VHsGfhoZx
	NLXTk3UIp90xd/5zepr3VxuYnHDyY+oboy9fu4W7gccGhnjX3MGTY6W0GFN46BeONTSRydFx
	8X7E1kuvMRWrr5L+jHx6I5OZEgJcYfbGtsXB379O8aL6Om9qm7AmZdDir6YrSM/E8Fs+1t3B
	4qfirncobd5hWH0U9GUW8GVsnMGScvq3mhcHv6qu5cHuA+La3mDhhtcG+uTxOAXw08xCEdj+
	G9opVeEUxjCwr4j+LWbsrZ2Lg0fudfM8+4i4fpyWS42XnHaZkWd5J+hcbxDB9wVot1TNo/xi
	HLYeBovL6Q6O4/MHhztY0pyAywkFWio1apSlMVyRqbjltZEuHyWtQvsdAtTmqlSwRdj3+Kiw
	SZVcDgln89FoZhmi54NX1ZmQVRq5HagU23UB6gW4q9Jm7xAxoCFQQZkhnDapgsYABTnpUayu
	NXkGz3rbYT3bD2qpCwijSqUmqUBPSq5ODLsWrCL+eDQrb5pYe87IBZkCv+q4P4P9zxsJqopl
	765ItCdjWFOzCcUpPSGnDeQla7goVyIvN6Av0uF7KY4ynZr5hS0INhRGUZKoITtLS0SJnhX1
	JnaYI0jdr8WcrWXdGYM4svSdGvLSotiToyPgbOxfjKIp3r2Chezp3Rx4iT6hZS2tfgFhtZXx
	Kt9skwAAAABJRU5ErkJggg==
}]

set flag(ZZX) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QA/wD/AP+gvaeTAAAA
	CXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH2wELDwkJ/Q6sLQAAAu1JREFUOMu1lc2PG0UQ
	xX/d0zNee23iXSXEmyUoywEJWCCIExICRfxv/BkICXHiBocgLiGnHDiQHFAIgbDriP3ILru2
	xx7PTHdXcRhjwtfNW1JfSv1eve6uem1UlYsIywWFAbpAumJebz7+/Hs1ZvWKnTXwxo2N1Zx9
	8VwP90e4EAUflaIMKIrBoCiqgCrGGgyQWIsogCKqiCjWGIxp9v8ZnTVHFMGKCFUdqHyg9kLl
	A2UdAbjUbYGCtYYss/Q6aUMkSr/bAmMoqga3XLUgIrggUHmhrAUAVSVzCe+9fpWzvGRWBnyI
	oIa5Bl660iVEIUsTdm9scOf+IUUVsIuHSqwhiGJFIkUVmC9WXni2LnfotlN+2DtnUtTEqJR1
	o+x0XLGWOX45mNDKEq5d7jAt/BJfVIEYBReDLJMKiMKV/hpPT3LOpxUovPvWgKISWqllsNHh
	2wcHnOUlw+MZVzfahCj4IBgDxkAMERdipCibSgBBmkKJtThjefV6n1kVGU1rXhn06PdaTOYe
	H5TKB6IY8tKTPNezQaTpirO8ZlZ6AOogDI9n7Ax6vLjZ4cN3Bnz2zWNU4dbbWzwcjtg7zLEW
	XGLZP55ycl6SumaIyzXBItgQA1EEkaaFVJXhs5zeeooPkU9v/8Sk8PggjGeerc027Sxhd2eT
	Xidl+GxKXLSfiBJFCD7gYgRjBFmYkTWGvaOc38clt25u8/V3Qx79POLSesYnt3+k8sLOVo+P
	bm7z5HDCr4cTrGGJjyIgigsh4GyL502u9sJX9/ZJneWDN68xLyNViERRuh3L+7sDhidTvry3
	z7yKpM4u8SIgIeKiKEb/UgzNQJyOSr64+4TXXu6z+UKLvaMpUYTr2+vcuX/Ao6djTsdzUmf/
	hhVtrsNFERKFf9pyklhGec3dB0dk6UKRwuPfJtS+UekS+y+cKsSoDbGq0kr/25rbrQRdeMwy
	l/2/jasqUWIzIEU+vhCj3wX6K+YdGWAdcCsmDuaiPtM/ACDR6QZS/ItqAAAAAElFTkSuQmCC
}]

} ;# namespace 22x22

namespace eval 32x32 {

set flag(ALB) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABQElEQVR42u3WMUsCYRzH8Uec
	HV0EX4BzQzXYIohTS62BU+DSFK2anAghCEGQgzkq0lC0BdbWC3BsCHoFQc7e9T39FUdDQ9zT
	A/E88MG/9/y558fpPXfG+OGHMT3HTC8yJnLBB/h1gCXCxPdQx6wGuMACT9hDDa94Ub2vuXf1
	ph7gCqc4RAO7OEJddUNzLYxsBLhEFyXkcYPM+iSrOq+5rnpTDzDEGYpaNKvPZF1Uz9BGgDGO
	UUgs/F1BPWMbASZoo/xDgLJ6JjYCTNFBE1X93p8Ll3SsqZ6pjQDX6OMeASrYwLbqQHN99aYa
	IN5kzjHAne77+J+/hR3VNc0N1LtMM0C80z1ihgfMcaLbMKN6rrmZekObW/GbNpxNXYGWjv3p
	w+hZ2++BaidPw1tddv8+8A8C5HKRC18BXL8V++GH0/EBxP3X8n2ZSbIAAAAASUVORK5CYII=
}]

set flag(ARM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAY0lEQVR42u3WoQ2AUBRD0SLw
	gGEMBJIVvwRPgvnrIBkBywJF8VboS+hN6o8s4JxLUBEP5cJAxQzIAzibkYoFoJs2KhYAzDsl
	M+AD9MtKxQJwHy0VC8BTQcUMyANQ/wHn3L97AYkv6b73gCYLAAAAAElFTkSuQmCC
}]

set flag(AZE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAvElEQVR42mNgGAWjYBQMAtAz
	wBhIbH30f0DwqAMGjQM4Ntz5PxAY7oC7Nj7/ScH3AuL/P1285v+jlr7/98NS/pOqH4bhDnhv
	7PCfFPzr1Nn/n+IyIHwr9/9fKhr+fwyI/k+qOWQ74M/N23D2B4+Q/3/fvvv/fclK+jng10kq
	h8BjK7v/pOAn/oH/Xy+c//9FU+P/pyFh/0nVD8NwB4TO0v8/EBjugIB5+v8HAo86YPA4YKDb
	A6NgFIyCkQ0A02FkB2UH4cwAAAAASUVORK5CYII=
}]

set flag(BAS) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABn0lEQVR42mNgGAWjYBQwMPQM
	MAYSsz3+gzDbdLf/Sekm/w+aKv6/qi2HFz/MTvoPAyA2IfWHTBT/x2aagu2A2Qd3gHG97X+G
	We5wCfE+5/+V0Qb/L+hS7gCQGVVR+v8lgGbCLQbaZdRgi3AASFFbiO5/hU5HhCIgBjlsrofG
	/ytkOACkZ567xn8TkOeQzFTocvzfCrQLZCfcATBNJwwVwFHAPcUVroF5pvt/rxLL/7sslIl2
	wG6gWu9iS7BemDncU13/Z6QYg+2AqcNwAAxvs1b5H5lthhJf/JNc/yenmfzfY66E0wF7gXIp
	QDX8k1zg+liBZkTkmP3fCjQT3R6cDoDhFU5q/+0rrf8zIqUPAaDhoDi9WZACd8Ct/JT/1UAx
	QSSLQXrsgHqXA83AZT5BB4DwZSCe7KsNjjvkuIzbUAN3AIiNLCcPVDvJTxusF5/ZcAd8OXXs
	PyH8/MLJ/weeXvy//xkEX3p7H+4AEBsmDlIDUkuMmXAH/B8gMHhCYMDTwKDLBQNWDgxYSTjg
	dcGA14YD3h4Y6BbRKBgFo2BAAQBqPhzCBx4bXwAAAABJRU5ErkJggg==
}]

set flag(BEL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAd0lEQVR42mNgGAUMDD0DjMHE
	f0JYSIDp/+eLyv//3lLFi/9cVvv/wd7u/3tjB4J41AGjDhh1wKgDRh0w6oBRB4w6YNQBow4Y
	dcCoA+AO4GBj/E8IS4ux/v98Vv3/n6sa+PF5zf8fXF3+v7dyJ4iRQ2BAu2YjGwAABeO3LzUa
	bfYAAAAASUVORK5CYII=
}]

set flag(BIH) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABi0lEQVR42mNgGAWjYBQMAtAz
	wBhIKE/9j4xd4zb+r+498V/QaM5/bY9l/8uL/P7/PcXw/99p0vCLvTz/2dUn/Ec3H45xOQCE
	WdSm/Z+86NL/XYcf/ZeynP9/cosdyY6gyAEgHJi5/X9Sxb7/kkAHyNnMIdkRFDsAhLl1Z/5f
	seUWEN/+z6s3k6TooIoDQNgxesN/59gN/51iNvxXsFv4f0qrPVGOoJoDQFjCYv7/kxdf/F+8
	4eZ/Tq0pREUHVR0Awrpey//bRqz7X9hy5L++9/L/7bXueB1BdQeAsIjJ3P8Pn376Xz/hJMGQ
	oIkDGFWm/tdwXQpOF8VtR//reS3G6QiaOAA5TVy59fa/R+JmnLmDpg7g1pn5n99g9n+v5C3/
	56y69t8qdA1GSNDUATBsFboWHBIgWsR4Booj6OIANo3pYNovbev/HYcegnMHLDro4gAYtghZ
	83/x+hvgCkzWZgE4JF7soaMDQJUXMxCn1xz4v/fY4/9K9vP+15V5E+mAAW4PjIJRMApGNgAA
	0uvX5l4rqwwAAAAASUVORK5CYII=
}]

set flag(BLR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAA9ElEQVR42mNgGAWjYBQMAtAz
	wJih50Fe8f9nnX3/H5VV/7/pF/r/nLgCXTDcAXeTMv4/rm74/7Co/P9VG2f6OwBk+fOJ0/4/
	be/5fysogv4OeFhS9f/F1Jn/H9c2/b8dFkN/B1x38gTH/RVTm/9XzOwGJgoeVdb9fzFt1v9r
	Du70d8Cz7v7/z3snQdJASBT9HQDy/asFS4AJcer/u/GpAxQCfdAQCI4a2DRwzsXj/z45Rbpg
	rLkgI9vtP3uFPl0wUjlQCS8HsntT/zPUGNAHYysJszoT6e8A5LogtdiH/g5Arg0zW2Pp74CB
	bg+MglEwCkY2AAA9WLt32aZu4gAAAABJRU5ErkJggg==
}]

set flag(BUL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAQklEQVR42u3WMQ0AMAwDQWMo
	iMIrksyFVjoODEfqv+T9RktEJFV4KocCAGAOQPc4MgAAxgDeXk4MAIA5gPQlI/q7Bt0U32yL
	EN/PAAAAAElFTkSuQmCC
}]

set flag(CAT) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAgUlEQVR42u3WuwmAQBAE0EtN
	/MEpWIaZBRjZkaHxgZnFCX7QUEELEMZsW5gNduDlEwzLOmexKEggc+FbIjDoKXC0HgxSYM4r
	MEiBe0jBoGcDz5iAQc8G9qYAgx0iKbDVJRj0jPCdYjDo2cDVZ2DQs4Gz82BQdIjWHAxSgP2U
	WizU/MBuFkkJJ9cDAAAAAElFTkSuQmCC
}]

set flag(CRO) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABS0lEQVR42u2Wv0sCYRyHbytn
	ESMIoYaghgiLGiJQgkIXQ3GQgg6ChigQLgfBX+BUVwalJKHSUlPSpENLf0T/gA1NuhoI8XR2
	oGvv9cOi94EPfPgOHx7uXU5RJBLJL0AfcBQdRWEQ+ZsCnSEbj5Pz1Ea9XK1FKK5sUhgLG7c5
	OsO27xe4X/Azfljn3OFH3dbwHaTYXw8T0Y55WPRZFLAZ5h9M2zGCmr2jNLNB1R3gdjbApXuL
	s50Mr3Y7Ilt9gWYToXg8UCpBLAbptNm9XkR3+gKiVKugaZDNmgLd3r0JYl2gXIZ4HDIZSKXM
	Xqn8oEAwCPm8+QTJpNlDIesCrdYLImk/PYOqgq6bX8Ho3ZvoTk/A5SoiktXpHI3rGkSjkEjQ
	uKkbt1NEd3oCTmcB0UxNXLC3dMTu8sl7t7LxKYGviBToCQz6f0Aikfxv3gC+HqcTPlNVogAA
	AABJRU5ErkJggg==
}]

set flag(CZE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABFklEQVR42mNgGAWjYBCAngHG
	DD3xTSv+P3j+7j+9AdwBgq51/zXCu/4v3Xnu/79//wbGATCc3rHm/72nbwfOASCsEtzxf86m
	k///0jg0cDoAERpr/z99/XHgHADC2pE9/+dtPvX/z9+/A+MAGKZFTiHJAbTIKSQ7gNo5hWwH
	wHLK8h1n//95+45sTJEDVO2L/09Vtfl/Q0aJbEyWA4Rcav8nGIb9PyCp+v+6iBRFmGQHaNoV
	/p+qYk2xxaQ7AOjrKKOI/4ckVahmOdEO0LYr+N+navf/GhUtJs4BQF8nGob+PyahRHWLCToA
	lMJ71exp4mu8DqBmCifZAdRO4SQ5IN4y9v8RRR2KChWKCqKBbpSOglEwoAAAoo+QmKlKNscA
	AAAASUVORK5CYII=
}]

set flag(DEN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAoklEQVR42mNgGAWDAPQMMGbo
	OSGg958Qvhlb+B8Gfj5/9f+EkMF/YvThw6MOGHXAqANGHQB3wGXnqP+E8MOGCXAH/Hrz7v8V
	15j/xOjDh+EO+D9AYNQBcAec03X/TwjfK2xGpIFXb/6f1/f8T4w+fHg0G446YNQBow6AO+CM
	qsN/QvhOetX/P5+/gPH3e4/+n1F3+k+MPnwY7oCB7heMgpENADRM8y+kQ95zAAAAAElFTkSu
	QmCC
}]

set flag(ESP) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABbElEQVR42u2WPUgCYRyHL7tA
	Bx1EU4u+rsAiohavMAocooKmhmgIWtsqhMYiSwmxoUKMtEgow/QuQyP6crWWwmq4am0Rt4yG
	ll9ScGPe0HUO7wPP8vIfHl5e+L8URSCUAT6FpXyc0QIlJAHlE3BUa4YSigHvxxUoZSHxo5RZ
	qYoBn1cUfjOfUuM2rMXjvha5pBql5qUqKaBwVoXkhAnRIQuiw2bw4wZ8XFT+T8BrRAVhi8al
	UwMXq4dvhMHJfA2EHRo5TiV/wHPMhJtwM3bbqxG0MuBXgzj0+pEJt+Ilppc/ILvcgvS0Deus
	EQvdbQjNesF7gsUzO7JLdfIHPHisuHaxCPXqMdPFwukYwMaYA5nFfty7G+UPeIpYkY33IDSo
	Q6Cv+AZsRnhZA+44B4S9BvkDUv4mbK90ID2nwdokC/+oHedTOmy6O3Ea+MMbeIurUMr8Af2t
	lFmpkmVEAsSARD0DJRQDlP6UEgiK8gW5Pnogn9KwrQAAAABJRU5ErkJggg==
}]

set flag(EST) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAATElEQVR42u3WwQkAIAwEwVRj
	J9YTsA5rs6VTEGzhAu7C5T3PRBAVaJp3zliyDACAOoDWZdkDRMg0AAAuIDPl2APIFAAAdQDu
	n5Do7zZEn55O1xIVdAAAAABJRU5ErkJggg==
}]

set flag(FAI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAu0lEQVR42mNgGAWjgIGhZ4Ax
	Q89/AsC29eT/Mo+a/++NHcDYJnjm//hZl/5TCkYdMOqAUQcMHgeALMCH+dL3YDhAPGfff0L6
	CGG4A6J9O/8TwkscUuEOaHQr/0+MHkIY7gCYwfTGg8cB4X49/wnhRQ5pcI217pX/idFDCMMd
	4NRx6j8+LJCBmQglcvf9J6SPEB4tB0YdMOqAoeMAp/ZT/8u86v6/NnECY7vQ2f+T5lymngMG
	ulk+CkY2AACR5MXoE2msOgAAAABJRU5ErkJggg==
}]

set flag(FIN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAg0lEQVR42mNgGAWjYBQwMPQM
	MGbo+U8AJNYt+c+gn4OCl20/859SMOqAUQcMHgc0ztj2Hx82DO/AcEBI8Zz/hPQRwnAHoBtO
	NzzqgEHjgPa5u/7jw8aRnRiaI8rn/yekjxAeLQdGHTB0HJDWtOw/m0k+Cl658yz1HDDQTbJR
	MApGNgAA7LChpn/HWScAAAAASUVORK5CYII=
}]

set flag(FRA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAdUlEQVR42mNgGAWjYBCAngHG
	QEIt5D8hLGSW8P/r9x//CYG/377/v6hk9v+coBpBPOqAUQeMOmDUAaMOGHXAqANGHTDqALgD
	OLTD/xPC0tYp/798+Pz/74+fePHvDx//X9K0+X9eUpcgRoTAADdKR8EoGFAAAImOE2i/B5/M
	AAAAAElFTkSuQmCC
}]

set flag(GBR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABaElEQVR42mNgGAWjYBQwMPQM
	MGbo+Y8EXr759L+oZc1/Ls28/4yKmVgxCFxxjfl/QkAPjEFsEMClHmRWYfPq/6/efka26j9W
	B8DAqYsP/pv5d1DsAFO/9v8nL9zHZgXCAWUd6/6/fvcZQ8HXbz//983Z81/cpIxkB4gZl/7v
	nb0bbAY6eAO0q6JzPcIBIA3ChiX/26ft+P/j528MDe8/fv2fU7/iP4d6LkEHgNRk1y3//+7D
	VwxzvgAd0zlj538RoF0gtSgOgGH78N7/R87cwRpkR8/e/e8Q0YfTAYT0WgV1oYQSVgcQ8sXP
	X79xOoCY0MPqgP9kAGwOIBXAHQAygFR8StoC7gAQmxwz4A6AGURvPHgcMOBRMOCJcMCz4aAo
	iBRsqv9PXrgf7kNk8OjZu/9JpYv+sxNRFLOr5fxPKFn4/+HTt5h1y/ef/6csOvBf0bYG1QED
	XhkNeHU84A2SgW6SjYJRMLIBAOinGFkwvnxuAAAAAElFTkSuQmCC
}]

set flag(GEO) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAA90lEQVR42u2WMQqDQBREtxHU
	JtFGPZ6QKoUn8RA22nilWEmsrAKpVCYMS1iSgMlXiBY7MOzy4b8dXJavUlZWO1C+sVUOqfoe
	8DxAKW3uWRNqPsAwALebXpcGmGN8DXC9Ascj0DTLA1wumtF1wgBVBZxOgOMAaQoUhTwAe9hL
	Bllk/hygroEs083nM1CW8gDsYS8ZZJEpugJ+tjhedwXsJUN8BdQ0AeOo16UB5hgvAe53iNy2
	gOuaANyzJuSYAEEAkQ8Hc/jTrAk5JsA77E/eUYAkgchR9AlkTcixs8DOAjsLdjQLljzDMAR8
	X5v7Nc9w659SK6tN9QBjRuSGDWa6uQAAAABJRU5ErkJggg==
}]

set flag(GER) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAQElEQVR42u3WwQkAIBADwfSP
	tdmBtUS5JhJwFyLcb55KRCSt8OZxaAAAlADOOxIDAKAH4C0nBgBADyD9JSP6uwtzrjBZrRFX
	TQAAAABJRU5ErkJggg==
}]

set flag(GRE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAA3UlEQVR42mNgGAWjYBCAngHG
	DD28cev/I+NJ227/B4FFBx/8R5ejJh6aDgCJHbr2iiqYLAdcefThP7UA3AEgC5HxuXvvwAqu
	Pv74H12ubuWV/5XLLlEFwx1AiqvNq/ZSPw2AghoZg3wOAreff/6PLle86ML/zNlnqYIHTxog
	xQFrTz75f+HBe6rg0YII7oAbTz/9R8ZvP/8EO+DD11//0eWoicnKhtQEcAckTD31fyAwzjRA
	Lwx3QNOaq/8HAg+eNLDr4ov/A4EHTxoQS9n4fyAw3AED3SgdBaNgQAEAGvwLT8wYvQ0AAAAA
	SUVORK5CYII=
}]

set flag(HUN) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAYUlEQVR42u3Wqw2AUBSD4bMO
	DovDoUhQzHENW9zZYBQewSF6XVfoSeif1H+yEc65BFXxou7dAMUMyAM4+hGKEfCdFxQjAKIM
	IOB+HyhGwLytUIyAqSxQzIA8APUfcM79uwZ3qfuN8CE8nwAAAABJRU5ErkJggg==
}]

set flag(ISL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAg0lEQVR42mNgGAWjgIGhZ4Ax
	Qw9T0Jz/+HDfpsv/389e+v+OnCkYg4BVxab/hPQRwqMOGHXAqAMGjwOK5p34jw8fuPIMwwET
	t1z5T0gfIQx3wPezl/4Twq/re+AOIEY9MRjuAJjB9MaDxwEDHgUDnghHy4FRB4w6YNQBA90s
	HwUjGwAArE0w8aXSqUIAAAAASUVORK5CYII=
}]

set flag(ITA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAdUlEQVR42mNgGAWjYBCAngHG
	QGKS239CWHhW8P+vv3/8JwT+fv/+/6KV6/9z2uYE8agDRh0w6oBRB4w6YNQBow4YdcCoA+AO
	4Jzm+58QlpoT+f/9j8//f/z5iRd/+/Lp/wVH7/9nDW0IYkQIDHCjdBSMggEFAJZpfetsGjEc
	AAAAAElFTkSuQmCC
}]

set flag(KAZ) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABqklEQVR42mNgGAWjYBQMAtAz
	wJihh2n1gf8Km9f/F1y//T/D6kP0wzAHsK/Z+3/GpYz/yUfaB8gBa/f+X3Y14X/OsaaBcQAz
	MAqqT1X+d987gwQDDv4X2bD1v+uemf+99037r7NtOViMLAdIbNz8f9rFzP/pR1uJ1iwETC9Z
	x5r/L7mS+H/99ej/DafL/lvsXECeA8SAPpkJTAMxh3qI1uyxd/r/Nddj/v9/owvGH16Y/k86
	0vGfY+0e0h3Aumbf/+5zBf/DD/YTpVF208b/nkAH7LsdBHcACOcC05D4hi1gTJIDuNbu/r/o
	ShJRUaC3bdn/OZfS/pvuWPR/4oWc/39e64EtP3vf83/A/sn/Ew53/q8/XU67EABFV9OZ0v9W
	O+eDE23Vqar/nWcLgVm447/h9qVgfuGJenLTQDdRGkGJzQBomRkwFBx2z/nvBswJNrvm/dfa
	tuK/PzAUQB6ieS4QWL/jP8+6Xf/9gBYqbl73Xxtoue++Kf9BhRqdyoFD/9mAPjXcvuS/z76p
	/wP3T/ovCgzJoVkSDnhdMOC14UC3B0bBKBgFIxsAAHW3juLH2Q6lAAAAAElFTkSuQmCC
}]

set flag(KGZ) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAA4ElEQVR42u3WPwrCMBQG8DdY
	OkoR7xBw10M4OBU8gE5dpBcwXQSh4CSCY4VewM1BJycPVb/AN2SX1yjmwQ8eTSFfm/SPSKxY
	sUTqwKTuRLoQYoDPAiQwhox9bwFSMDCFFeTsDcdUA7gJJlBACze4si84lmoGMJzoAQc4w4n9
	nWNGK0DCW+2u9gglLKnksZbnJBoBMq63u+UNbGABc/YNx3KeqxpgDRb2sIMtj6kG8JfActIX
	PNlb7SXwN6HbcBVcqOpjE37FY+i/iGYhXkS+AYxgyD5+DX86QOhfslix/rvez5OTondxINwA
	AAAASUVORK5CYII=
}]

set flag(LAT) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAPUlEQVR42u3WMQ0AMAhFQbTU
	Q11ioVrpVguQ9C75+xsYiAAGyOZFnrWrYwIEzAmoJgIcoQABL6D7HwD+dgFZ8Ff1ZKxIvgAA
	AABJRU5ErkJggg==
}]

set flag(LTU) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAR0lEQVR42u3WMQ0AIBBD0XpA
	BBMuUIOWM8SIMHLI6CX8n3R/YyUiksI8xd0tHQMAoA5Aa6ZlAACUAZw+0jEAAOoA3JeM6O8e
	xt7PQc6lNCEAAAAASUVORK5CYII=
}]

set flag(LUX) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAQklEQVR42u3WQQ0AIBADwXrC
	AALPBcZwgISejF7CbtL/PCsRkVThqd7aTgwAgDkAhwIAYA5A5zoyAADmAMKXjOjvGn7sc9fb
	x58/AAAAAElFTkSuQmCC
}]

set flag(MDA) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABJklEQVR42mNgGAWjYBQMAtAz
	wBhIuK37TwgLBSz8//UM2///lxjw4r+nGP+fl9D+f4ZTnyAedQDZDvhxhuH/r3MM/zf3CP6/
	vVHw/7+LEDG6OWBysfz/3dN5/++fLv//2FwZMBskRjcH5AUr/a+2VP3f7yz9f6KTNJgNEqOL
	A14dYfpfHWfyf7Kt1v+1kQL/V4cLgNm9mUb/PxyjgwO+nGL4H+yp8j80LOB/TZXJ/4x8h//+
	wWH/O9IM/38+QacoSIiU/Z+doP4/P0fvf0S8zf+MBOv/3Vlq9EsD/RUi/2cncv9fVKv5f3G9
	6v+NhZz/59cJ0c8Bv4FZ8PJaZmCwG/1vSdb7f30DM1iM7gXRnS3M/x/tZBwtioeDAwa4PTAK
	RsEoGNkAAHCXDbenRmGHAAAAAElFTkSuQmCC
}]

set flag(MKD) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAB4ElEQVR42u1WS0scQRDev2KU
	mZ6Zbq/JKScPinqKKIHEB8SToj/C50EICRi8R0guyTUJgQQliog5R1ndt+66upt9kJ3cvnTV
	ZneVHXf3IIzgfFDQUNVffVVdPT2hUIAAAe4A1ny20FrsiUD+gwM3rfD3vBd/fimkZi0cdhk3
	WnJGcCwZrVvFEhdxUizlyH90EBsRqAuoBcZGBQpfJdyMYsu+tnGkvEmPH5twz3TcqeK1V8yR
	NJB9ZXNSN9OLwieJ2JgW+6DqbxLA1mMg8UKg+E2y4uK2RHTYO0FpV7LfyxcdMlHc+s/xXSIx
	LZj7aoy3gCsWfybwW6umKjPLuhviuv9iw8b5S/t61Toms2TznsJnifjzm4+nrQC2bt2RCYHS
	D4nCF4mTvkY3qFPxp40E5KOkpR1d8aTgva24OxNQq8zUwzRnsYjElED4oa501ebO0JoSki81
	bzV1qq2ASlSh/FPyAObeOci+sZFetJgsPi74PMOPqiJogCL9Jsr7sn4LaB0ZMKvDZRgsKDJo
	cvuJI71gIbtuI/fe4RzlA4lKRDUE1IhaGZ1paU8L3HSQnBZNfhqyy7cOD6abUuiE098ORNUt
	zMDKLc3Anb0F/nwH/PwS+vYW+P4a+v0/ECBAgPuNf1pHc8N4icysAAAAAElFTkSuQmCC
}]

set flag(MLT) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAxUlEQVR42u2WvQrCMBSF+xCu
	PoGjr9mX0kVEiHHQRhqrolIttmgrKInNsS3i4uAP2DjcD86c79zc4ToOQfwBruU4Lu4YY2C0
	hslzvIMKdxg2Wl/nSUAnB4QTgWjs1StQNs82IdZsBOlLeL0+jssVVHaqSUBfq+bS9yGEAGMM
	WZoins1rEij+vBz7tGjOOceg00Usg2oqte6AivZV86R43MoS5ucL4mDxsvnPBD6FBEiABEiA
	BEhAbSPwZvvrPARsH6UEYZUbbTA/Udn8glEAAAAASUVORK5CYII=
}]

set flag(NED) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAXElEQVR42u3WoRGAQBBD0S0E
	gzsawVEKBnkexc3QCYY6qCm4bSEr/p+JfzIRRAUa5sV4pibHAACoA/iOLscSIFMAANQB7Ocr
	xxIwr5ccAwAgAct2y7EEuE8pkbUfyGhkVe/SuA0AAAAASUVORK5CYII=
}]

set flag(NIR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABCklEQVR42mNgGAWjYBQMAtAz
	wJih5z8Z4Gl9/f8zDAxgDGKTAyhywKPW1v+HNFj+H5RjBbPp7oCDDdn/57rL/V/kIPv/QH0W
	/R1weF71/+np/P+npfD9PzK3hv4OeDCl+//JFY3/Ty4s/v9gcgf9HPDz58//nz9//n+/t/f/
	9cmT/1/p6gKzQWIgObIcAEvNxOL706aBDTji5/f/fFbW/1/fv4PFSDWHbAecVFf//+vHj//n
	zc3/75WU/P/+0SOwGN0cAAuBq2Fh/y9HRIDZFIUAuWng3uLF/+/On095GiC3JLwSHv7/gpvb
	wJSEIEtPMDP/P8XENHAOGNC6YHg5YKDbA6NgFIyCkQ0AwW0/B7TB4S0AAAAASUVORK5CYII=
}]

set flag(NOR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAzElEQVR42mNgGAWjgIGhZ4Ax
	Q88uHv3/+PC7I2f+N0xY+59BIRqM9x27+v/pko3/CekjhEcdMOqAUQcMHgeALMCHf334hOGA
	Hy/f/CekjxCGO2DuygP/CWH/1F64A0rblv0nRg8hDHcAzGC640HjgEVrD/8nhAPT++EaK7tW
	/CdGDyEMd8Cb/Sf+48O/3n/ETITPX/0npI8QHi0HRh0w6oBB5ABB4//48NuDJ/83AR3AohwL
	xvuOXP7/ZNH6/4T0EcKIoniAm+WjYGQDAJks9GRZccnGAAAAAElFTkSuQmCC
}]

set flag(POL) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAATklEQVR42mNgGAWjYBCAngHG
	DD3/BwiMOmDUAaMOGHUA3AFv6qf+HwgMd8AdEZv/A4FHHTDqgFEHDB4H3NPw+T8QGO6AgW4T
	joJRMLIBAChuE6otqR3sAAAAAElFTkSuQmCC
}]

set flag(POR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABvklEQVR42u2WO0hbURjHv4AW
	LKiVXORqFbPoULC4uFgREaRDKT6GahdDKb7SQZRS6eJriIptl0KlPsHNKlkEKRWU4tImwclX
	GxMvPhZJdJRA9ddjW3DpoOJNVO4f/mf4lu/H+R7niFiydAX0Js5WR4NwHiOXYwvgegLY6oVf
	tlgDqKQP+4TGQaF9TPjxSjBULFwiHJsOoBI9ey8MuR24KnU6nusYD3TCWTrfX98lVHdxiDMB
	lLuFwIaw4LITyc8kWJVHqDqPyP0MFls0fB5ht9hEgM4JYWlVONDtRD0e/Kt7eFf2iE5Ps5+t
	EbknBFtNAril/GFKaB0RPjfbWRwf49NckMkvG3wdHWb+hcZmo+BXJTpMMAEg8R9A80dhK9eO
	/+0QUwrgBMLXP8h2gUbIJfjMAjjxy1GhsFOVoUwj0FOD12/wzbvJz+4nGM50wmoqAm0m9kCR
	Sj6zILjfpbH8OIWow0E0J4eVijssz6axvqbGsdTkMXSqKx5QpajtSqb3aTo7hcqPUllTccMp
	HNlisIjK3H974c8ialeJm4T9olgsov/AHFmv4Y0DuF2fwHlMUtKl+PQG4vwptWQprvoN3/KR
	7Yu4jtcAAAAASUVORK5CYII=
}]

set flag(ROU) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAdklEQVR42mNgGAWjYBCAngHG
	QEK7/j8hLGRe/v/TKcn/fy6K4cW/Tor9vyiv8v+coBpBPOqAUQeMOmDUAaMOGHXAqANGHTDq
	ALgDOI1b/hPCUnbV/98ck///9Yw0Xvz5qMz/Cypq/8+KEcaIEBjgRukoGAUDCgD2+Vqq3Rj1
	6AAAAABJRU5ErkJggg==
}]

set flag(RUS) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAXUlEQVR42u3WoRGAQAxE0VSC
	xJxAoCiCyrgWsDRALaDoZXG5Ejbi/5n1T2USQVSgbl50mQIAoA7gvD85loDYLlkGAEAZwLHs
	ciwBT5vkGAAACXjXWY6NO2B+Soms/dLbcKNlmwcKAAAAAElFTkSuQmCC
}]

set flag(SCO) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABVElEQVR42mNgGAWjYBQwMPQM
	MGbo+Y8EXn788b9o6fX/nCm7/jPE7aAK5kze9b8AaOarTz+RrfqP1QEwcOruh/+m9ccottwE
	aMZJoFnYANwBZStu/H+N5joQ+Przz/++7ff/i+XsI9li0ex9/3uBer/++INh7pvPP/+Xr7yJ
	cABIg1Dm3v/tm+/+//H7L4aGd19+/c9ZdO0/exLhaAGpyVp4FawHHXwBOqZjy73/wll7IeqR
	HQDDdq0n/x+59Q5rkB299f6/fdtJnJYT0mvZdBxVDzYHEPLFT2AIofiCktDD5QBi4xGUsilK
	P4QcQExKpigHEesA5Lz84sMPnBaTXIYMGQcMWBQMWCIc0Gw4YAWRfNGB/5N3PQT7EB08evP9
	f+Lsy0Bf7CQYr2xANQmzLv1/+OYb1miZsvvhf4Wig6gOGPDKaMCr4wFvkAx0k2wUjIKRDQBX
	WEKvSWmbHQAAAABJRU5ErkJggg==
}]

set flag(SLO) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAy0lEQVR42u2WQQqCQBiFf6FN
	iyB029Z1Z+gCXcR1t/AKuegEnsA2LbxBEHkDI2lwE9WrGUJJhggmm4H+Bx+PBwN+MCgScTgc
	BxJbhmJYitsCorogTQWS5KD69Ng/FVgvC3jeFb5fqpa7N4G6BrpsVgXCEIgiqJZbd86ERiAI
	gC7T0R55foMQUC237pwJjQCRHK8M6IzFfIssg2q5defMeCMgGdMRs8lO9fcf/oFA/zwFfCph
	g/YtoCFs0H4HLN0BC7gjYPt/gMPh/HfuyQnYv3YM2EwAAAAASUVORK5CYII=
}]

set flag(SRB) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAACMklEQVR42u2W3UuTYRiH/QP6
	O+pUiVzLGSuFOTrwI7GgjxPBucxMpDlJPBhrTFJbQREEpZQEmQmGutpXvtv7rjFySLLVxA2d
	LvyIIImKgqvXgh3NeEPnOtgFP56jm/vivu+Dp6ioQIH/gL48p6hPKtWQj/yzgF9zBLG0bO8F
	xMPlSA0NPDRW4z5zErFCt3cCYkMtflsr3toKxN56vHVqfNYmBMPZP2K5FvCfr8Zl1OEyVPKi
	S4PvnBanuQpvUw2iag8mEFCVMdWmQugvxm0vQbCV4Ok7hKtSvXsr6FHXkS32o/WIx/VMnNIR
	tJzgpbmS1z06Jjv0TB+rYkhbw3a1SpIR2Kc1kS0H9GZiFhuz3R3MPbPw7vZdkpITsbGcxPBj
	DPpmtqtVEkUC6VCY5MgoYUMjn9fXWRwfY6apmU+rq1xuv5F7gflQiOVUCsF6jZjHQ9Bxk6j8
	JhMJLnQ4ci+wEAz+bibZ7KQCIm+u9xMVBFKyVEv7QO4FEr5XrMjN3j4ZYSMWY2H8OfPhMOkP
	aS622HMrsH9rAqNjLEUiBAYcJCcmEa50MjflZG1tFeNp0+4IjHgiZMu4N8L7wQeEb3USkm8g
	4nYTtPcSutNNdPg+3sGnbFerJBkB/kJ8yIHUVczM1VZWVpaJyysItR1EMun4vrHBTlAk8GNz
	k1nrJaKP7pGWbyEdjxMwVvExKLFTFAls8fPrN9am/SzJN5B2efiyuMRuoFggVxQEMgL5/pQW
	KJBXfgHlG6fnGJOv+QAAAABJRU5ErkJggg==
}]

set flag(SUI) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAbklEQVR42u3WwQnAIBAEwG3P
	DizK6mzG58o+gzGPIJ4JK+znkGMenhwAlOCgEGBEDDDgPSAlMudrVNsGqJXDUc0AA/4F0Fip
	6V1aGwGqze5PRvQZoNleddTLgO8Bwh+h/wEDDDh6JfNWbMBqQGQ630yqSWvZTwkAAAAASUVO
	RK5CYII=
}]

set flag(SVK) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABjElEQVR42u2Wv0sCYRjH/UOa
	yiLxVx0kOmU0mC2l4TlEUGgJZYKJFjk2WHB7ELQpCbaUS1Y0SkvRUmNrk3eI+KMGv937UqeZ
	Ekce53APfOC57/O8vJ/jltPptNJqAIpTGR0HlUoTGGyBZqOBZq3WHXGmuEB5gQVvZCiVcBSV
	raj0XF5k+ytwefeKdopPbxDs0ygNG1D2LaN6yKGa4mhPMsHhpDud5+QiCYzOZ9BOMHkLnnGA
	H5/A+9UNPor3FNKTjMwC4k7nObn0FNhIXoO32sTP4EMltof6ySmF9CQjM7KjmEBoXxSwTKHs
	X0H1IIV6+oxCepLxFhtCSgr4YwUIThdKQ3qKENikSM8zLrA7BeUEzJ4sXoIJZEwe5A1zYGeP
	KHmDm2bP6wm6o5gAIZLIg/FmMeZOSxnpSbYtzv57+Q+BnNmDTs6tXlzsHoNZar0p6UlGZt3O
	yEUS+P62vxgx4nE1jnAkR3lYi9Os575M/hb4gp+0U/p1sWwBpdAEWgJ6E9RAElD7p1QrrVSt
	T+M2tG4sjKBLAAAAAElFTkSuQmCC
}]

set flag(SWE) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAkklEQVR42mNgGAWjYBCAngHG
	QCJo8n9CeOlC4///TjPAsVpKzX9i9OHFow4YdcCoA2AOKOoI+E8In90sg+KA9kku/4nRhw/D
	HYBsMD3xqAPgDoivj/5PCB/bII+iubzL9z8x+vDh0Ww46oBRB8AdIJYw5z8hvGSx6/9PJ8Tg
	2Cy//T8x+vBhRAgMcJtwFIyCkQ0AvkQLlqgIJ+sAAAAASUVORK5CYII=
}]

set flag(TJK) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAA10lEQVR42u2WSwrCMBCGewrB
	hXfwZHoATyAU7+FS7ANE3agnaEEtgo+dKFLRopjHOG2luE3ApuB88MN0QtKPySaWRRBEBbAN
	x7I3tQaYCAlUR+DmeKCVoYNxQXd/IQCKSCmAX6Yg7iHIxzar054q2gIiXoBkVxBJhFnndTwv
	R0BKhj9dfURmOIUgr5NltvZ7AfHEkU9w9Dvgxz7w0yCv0x6ulXIF/OzBK2oD23eBHXpYt7Dn
	6l+BG45BJU4wwvhf337WUz2nEKh3mmAiJFAdAdPvAYIg/ps36tQRi1yVdLEAAAAASUVORK5C
	YII=
}]

set flag(TKM) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAACbElEQVR42u2Wy08TURjF0bjR
	uDDGxP/A6AJnOtP2UmiRoDEWpNRCWzrttPRhsEhfisVHMNVKRUVrohGMEjWRxEdLUROioRLB
	R2yJNmmMLIx/y/G2pgHU5TB10ZOcmcV8X/K735w7c+vqaqrpP9BYlU0vl3SoWBgieOlU4HkP
	j4cuE9JeO+aONmJ1jWT+F8ChYBNm40bEAm1ImvV4POhB+oxrTeOmRMv6AXQFGvDs1DE8ifhx
	26/HRIhgRuTXNPL3vdgz4cDWKwdRf9clLYD9LEHOyiKr1iCjVeKDikWujyk/20C97Zoe5EEf
	dlw/XJ6EbToG5aRPOgAhQvDWzmIqTAFOErzwqTFPgSqj5+jqS67Um9Pn4Xk1Kh2AKBAMBrW4
	49bgkbUBV/2NuGxuWtO4fay9fN8yegCp5Xdg77klnMCJlQlM/zGBincmDbDQlY9/mUF3alj6
	DCzaaAbqFchwCnziSxlg/2reOLKPZqJZ+l1g6SeYdHBI2FQY8eiQdPBIdSjk+w509RJc7FXi
	ZpsGU6IesW4Vxjt4+QCEKEHWpkDSpMQ5ixpPOzksCqyMAKcJlnoYFNoZfDSxKBgY5F2MfADO
	kBrx4yr4Ai0IDLTCF9Yh45YxAy4KMBxUwRv6DeCmACkvJx+AvfQKrAw+G1gsmFnkjSyWREbe
	EM7ZqAd0eB0PYrZPwIJDLR+Aw0nwJmpG7kYY2aEoCrcimPd2yhhCCvBe7EA2MYTZC1Zk+5uR
	3y/jNnSKBD+Ne1HczaC4i8U3lsEP/TpnYDP9q1XsdGlRbOHw3cCh2Mph+QiHrxyP1TVSeWUC
	VT6U1lRTVfULvIyZP+U0VhsAAAAASUVORK5CYII=
}]

set flag(TUR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABZ0lEQVR42mNgGAWjYBCAngHG
	DD2PucT/DwQedcAQcwCf1P/HvFJ0dgDQwrdJWf+/79r7/8+Ll/9/373//+uq9f/fxKT+f8wj
	SXsHfJm/5P+/f//+/3n1+v/b1Nz/T2U1wSHxwtb9/0tnX6AjJGjngNeBUWDL/376BLEMXQ0o
	BIAh9ERcmTYO+LZt138Q+DRhGl5D3qblgaPkpYMXJISo4gCgz/48fQZ2wOuQWOwGcIv/f+kW
	8P/b1p3///3+/f/77v1AMQnqOeD3k6cQB4TG4XaAncf/rxu2/P/348f/7/sPkZww8UfB5u2Q
	KJgyC38UpOSAQ+mFhfP/pzIa1HPAK59QSCL88uX/K69grFkUnAhFFGmXDT9PmwNxxLv3/9/l
	lf1/pmYETvUv3fwhOYNbgsYFETBO30Qm/f+2cev/3/cf/v918za4IAKnCwotH62MRh2A4oAn
	wvL/BwLDHTDQjdJRMAoGFAAAEgQ4vH7o7/QAAAAASUVORK5CYII=
}]

set flag(UKR) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAWUlEQVR42mNgGAWjYBCAngHG
	QCJ8+/8BwaMOGHXAqANGHQBzgHDCyv8DgeEO+HqJ7f9AYLgD/l9n+D8QeNQBow4YdcDgccCP
	yxz/BwIj6oIBbpSOglEwoAAAhUPyQCffJ9MAAAAASUVORK5CYII=
}]

set flag(UZB) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAA2klEQVR42mNgGAWjYBQMAtAz
	wJihx6Dx+38Yjpnz479lO4Jv3Pz9v2svEPd9/28NFHfqQchRijEckLP05/+0RT9RFBk1ff9v
	2wHBZq3f/1u109ABcw///m/aglDgM+nHfzMg3xtIg9h2nd//u/fT0AGhM378r1n/E+xrH6il
	YAdMRDjArY8GDojKPPUfhnNLTv9PyT/1PzEXgmOyEOzY7FP/43MQainFcAf8uXHn/0BguAP+
	DxAYdcDgSQNRuab/BwIjyoF2i/8DgUcdMHgcMNDtgVEwCkbByAYAU/Qqbu6V2asAAAAASUVO
	RK5CYII=
}]

set flag(WLS) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAEUUlEQVR42u2Wf0xbVRTHuzk1
	UWkHQpZlS2AONtb29b2u0Ja2tGML0zEzo5hpWPgHh2G6jcQyEZAfMglmQ1yXKJrhgrNT3FiB
	zfFTJG0ZP7Z1mCGMGROpojimUWSGH0W+3nsbiGZWfiSGP+xNTu6779x7z+d8z3nJE4n8wz/8
	QyQqWWITlWCJxoIB/piawu2+m5gYG/O55998iwKYIkHdlbUYOFkJR2IqatZGwe3svGufZ2IC
	/W9X4MujZWw9PT2N4Ws9cF92sed5A4wM/oCfem5guO8rXDMXoj5UC5sQj5aHeTSKpXDEJ5Fg
	k38DHCCArcrH4JTI0b4jGa7CUrRtTkBfzpHZ4J7JSQw6OucG8IyP42qKGfa9Gei1lKNauxMN
	T6agMVCOC+JNcAQq4G69xPb+PnQLV/YcQL1Ehs+I1RE/nSkInduzijDl8TB1rpsPoz+zeH4l
	GL75NW4RuzMygq7cI7iSXYzza6MZQHvEFgy2ONnFnbtS2LsacSSb64lCM+Z4Zh9+cX/HFHBl
	FqEhmEd3WtbcADc+tqFrfw7sL+Wz9djoKL6x1cEWEImLJEiXIRFDHVfx2/BtNJJLW0imNGCT
	WIZWWgIJh7ZgAeOjdzB4rg7dT6ehJz0fHamH8G2zfW6An7/ohX2dHh3PmWebyxm3G5UBG1AV
	sBEdUY9j5PshuLtcaA7imOwUoJWANItpGaSoU+/ErwSwU/8UXAdzYQ/T4foLOfP/CrrIwf78
	Uvb8Y6cLn5PLPyIA1oAINK3XwxHzBBpDBBa4lshP603VcRAFqG/AasPw5W64L7agm2RvDzei
	90CebwBR7RbMmCpPi7d4BU6t5/DgBwYYD2lYU50mAA20thJvM9JnanayprOTSF9NYKgK9B09
	07aSwyVir8cKkFTE4q9xmP0TAJcTjaATehwjEOVhMhRoOFbbT0nQJhKIZkvrTj9JmjVVh6pA
	IdoIBAWgkPTMK1sF8Ie1ENlMdwf3BTBjgScNOB2uYBfTYDRr2gdnSR/QgFR+2pjnGZgMFY/I
	8WyyCqfC5MxHe6M2SIrcOCWCyw0LB6AmK4qBRcUjIVXFgl4gFzYEyZAdJ8CUoYZFUDA1aOZv
	agSsKtOzbO+zGrDmuA5pu5SwrpZiwxvaxQEsP2vEGosO2/dHwxoqhzJPg4TnoyCqMTELeVcP
	83YB1uBIVqLiGB6bX9XMntdmqnFinQy+7vcNQC7nsqOhfVkN+WsavLOJQ0SJzuurNiE6XYXk
	RAHaLA32JKlQFSJF+g4B954xYpUlBnsTeAS/p0dGvICsbcLCAe63xmLfVo5JXqbgUUC6OGm3
	EpJyPVZUxuKgiUMBL0NeLPEZBby4jcNK4qNnwwvVOB4uRSnPoWKjAhmPKsHlqRdegtUkk9Bj
	Oq/cJGv6SS6rMnoBPzRgxSfG2b0PEN/yM971PeR96FGt9xzph2XnTHjoff3ieuA/t1mAJf4l
	8w//+H+PPwFd9LUxoPP8AAAAAABJRU5ErkJggg==
}]

set flag(ZZX) [image create photo -data {
	iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAACXBIWXMAAAsTAAALEwEAmpwY
	AAAAIGNIUk0AAHolAACAgwAA+f8AAIDpAAB1MAAA6mAAADqYAAAXb5JfxUYAAASkSURBVHja
	7JfbbhNXFIa/vWfGNokdyIEmISrNASTUkIK4qWirovAQpfRF+gZ9kz5BJUR7g2hVtQGkAKlA
	QDknxImJD7E9x33oxQzGdoyaiyq56ZK2lzSz55/fa/1r7TXCWsthmuSQ7X8CAnCAfOYP0jQQ
	ucDIDz+uVoU44NALwfdXz4+5wFEpYHF29L+Jp93HNWC90gY46gJ5bSyJtvihwma7BWlIbN/T
	AtGzxw5A73+2f99QwSXRBiDvAhhjSRJNonQX5b0+/TXY7jsZrhDvXvRup+0KgekhqBKDNul9
	F0BbiJQhUubDilEGx02LxpUSz5U4jsBzJHGiiRNDrDVSQKwMriPhA7pyHIPSXQSMMUSJJk70
	ns0WsNZy8qMS4yN5Hr9u4EhBojUWh2LBoRUk5DyJMpb56RJBrHhebmKsRQ5QtyNFJwIyJQBh
	pIhiTRRrwi7vh4q5qREunZ9O/5krSZQhSgxaaWqtCGMsFxenKB1xafgxXy1N89n8OGFkCCPd
	we3gRwqdRVsCKG3wI00QpyvMvB8ppBCcnR2l1U548KLOrp/geRKtLe1I0w4S2oGiUg/4dG6U
	pxu7bOz4LM2NMVRwaUdJBzfo4GriVISZBowlijVxnwaMtUyP5SgO5Vh5sE2jFeG5giBUzEwM
	EcSK4pEcwwWXtWdVPE+itGH1cYXpz08yVsqxVfVRQncq411edS8Bgx8pkoyAEKm6rbWcnCyy
	247ZrvvkXEliDKdnilxZXuDm3U0Qgkvnpnj6psm1lVeAwI805VrA7NQI959VMVm+rU2xlZZ9
	VZBpQJnemtbGsrHtc+bjUayBWjthaf4Y2lhu3N1kq+ZTOpIDoNYKqe6GGGNR2pD3HLaqPu0g
	QfQJ0ZUGIUUXAW0IY91h1alXbdkNYso1n+JwjqW5Ub65NM/vf5W5tvKK4YLLleVT1FsRP99e
	Z7sRYgycmCiyXmnRDBWtUO2pBEcKhgruexFqbTDGYmzvsliebDTIOQ7HjxZ4vtnkt7UyZz4Z
	JVaGr89Nc2qmxLFinvML4wznXAqeZHa6yPhIgYcvail2H64xFqW6NKBs1t3s3jbuh4pqMw3t
	hdMT/PTHS365s461lhurb9iqBXy7vMBWLcAIyxdnJ/GkZGc3pN6O077Yh2sFKGN6UwCSQeNZ
	GGtuParw3fICjiPQ1nLtz5fkvbQBrT7Z4eGrOltVny8Xp7hwegLPkVy//ZpaMyTvOQNwBVrr
	rhQonal+7/Icyf2/d7hx7w07jZBzC2OMDOczvQiUNrythbhScnFxkrafcOdxhZv3NvEc54O4
	vWWoDZ5jB55sae+G67deE0aayxdmuHp5gXI1oFz1CWPF7FSJ8ZECAGsvalxbeZmWnBx4EiOE
	RSWqtw+4A3LVHTLHEfy6VubRegNXCk5MDLP2rEqiNM0goVIPUcayXfWxVnR6ySCzWeS6IqAR
	+5g1hIBytY1AsFn1MdYigNUnbzuHlhSSf5uuRHYAdghgDPsdyRwpe8aqbtD9gggBtpuAyTJV
	yB3cXGrsewIaa9lt1A9jKtcCmASWgOMH/PIKsCayb4JS5g/SIqAp/v84PWwC/wwAi/T9PpYJ
	bYYAAAAASUVORK5CYII=
}]

} ;# namespace 32x32
} ;# namespace icon

if {[::scidc::misc::debug?]} {
	set countries [::scidc::app::get countryCodes]

	foreach r $regions {
		foreach item [set region($r)] {
			set code [lindex $item 0]
			if {[lsearch -exact $countries $code] == -1} {
				puts stderr "Invalid country code $code"
			}
			if {![info exists icon::flag($code)]} {
				puts stderr "Missing tiny flag for country code $code"
			}
			set file [file join $::scidc::dir::share flags $code.png]
			if {![file readable $file]} {
				puts "File $file is missing"
			}
			set exists($code) 1
		}
	}
	foreach code $countries {
		if {![info exists exists($code)]} {
			puts stderr "Country code $code is not yet known"
		}
	}
}

} ;# namespace country

# vi:set ts=3 sw=3:
