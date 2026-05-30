# ======================================================================
# Makefile for Scidc for Unix operating systems
# ======================================================================

include ../../../Makefile.in

.SUFFIXES: .txt .html .dat

TARGETS 	= $(SOURCES:.txt=.html)
CONTENTS	= Contents.dat
INDEX   	= Index.dat
CQL		= CQL.dat

all:
	@echo "SOURCES = `ls *.txt | sed ':a;N;$$!ba;s/\n/ /g'`" >  Makefile.tmp
	@echo "include ../Makefile" >> Makefile.tmp
	@for f in `ls *.txt`; do \
		echo "`basename $$f .txt`.html: $$f ../make_html.tcl" >> Makefile.tmp; \
	done
	@make -f Makefile.tmp targets
	@rm -f Makefile.tmp

targets: $(TARGETS) $(INDEX) $(CQL) $(CONTENTS)

.txt.html:
	@echo "Generating $@"
	@$$TCL_SHELL ../make_html.tcl $< > $@

$(INDEX): $(SOURCES) ../make_index.tcl
	@echo "Generating $@"
	@$$TCL_SHELL ../make_index.tcl > $@

$(CQL): $(SOURCES) ../make_cql.tcl
	@echo "Generating $@"
	@$$TCL_SHELL ../make_cql.tcl > $@

$(CONTENTS): Overview.txt ../make_contents.tcl
	@echo "Generating $@"
	@$$TCL_SHELL ../make_contents.tcl Overview.txt > $@

clean:
	rm -f Makefile.tmp

# vi:set ts=3 sw=3:
