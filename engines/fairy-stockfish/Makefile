# ======================================================================
# Makefile for Scidb for Unix operating systems
# ======================================================================

include ../../Makefile.in

EXE = fairy-stockfish-scidb

all:
	@true

clean:
	@true

depend:
	# no action

install:
	@install -m 755 -d $(ENGINESDIR)
	@install -m 755 -p $(EXE) $(ENGINESDIR)

uninstall:
	@rm -f $(ENGINESDIR)/$(EXE)

# vi:set ts=3 sw=3:
