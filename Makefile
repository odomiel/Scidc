# ======================================================================
# Makefile for Scidc for Unix operating systems
# ======================================================================

include Makefile.in

MAKEFLAGS += --no-print-directory

all: Makefile.in check-mtime
	@$(MAKE) -C man
	@if [ $$? != 0 ]; then exit 1; fi
	@$(MAKE) -C src
	@if [ $$? != 0 ]; then exit 1; fi
	@$(MAKE) -C engines
	@if [ $$? != 0 ]; then exit 1; fi
	@$(MAKE) -C tcl
	@if [ $$? != 0 ]; then exit 1; fi
	@echo ""
	@echo "Build erfolgreich. AppImage erstellen mit:"
	@echo "  bash build-appimage.sh"

check-mtime:
	@if [ Makefile.in -ot configure ]; then                    \
		echo "";                                                \
		echo "Makefile.in is older than the configure script."; \
		echo "It is recommended to re-configure. Invoke";       \
		echo "\"./configure\", or touch Makefile.in if you";    \
		echo "think you don't need this.";                      \
		echo "";                                                \
		exit 1;                                                 \
	fi

depend:
	@$(MAKE) -C src depend
	@$(MAKE) -C engines depend
	@$(MAKE) -C tcl depend

clean-subdirs:
	@$(MAKE) -C man clean
	@$(MAKE) -C src clean
	@$(MAKE) -C engines clean
	@$(MAKE) -C tcl clean

clean: clean-subdirs
	@if [ -f Makefile.in ]; then                              \
		echo "";                                               \
		echo "Now you may use \"make\" to build the program."; \
	fi

dist-clean: clean-subdirs
	@echo "Clean `pwd`"
	@rm -f Makefile.in Makefile.in.bak

Makefile.in:
	@echo "****** Please use the 'configure' script before building Scidb ******"
	@exit 1

update-magic:
	@echo "Update magic file"
	@if [ ! -r /etc/magic ] || [ -z "`cat /etc/magic | grep Scidb`" ]; then \
		magic="$(HOME)/.magic";                                              \
		if [ ! -r $$magic ] || [ -z "`cat $$magic | grep Scidb`" ]; then     \
			done=0;                                                           \
			if [ "`id -u`" -eq 0 ]; then                                      \
				if [ -f /etc/magic ]; then                                     \
					echo "" >> /etc/magic;                                      \
					cat magic >> /etc/magic;                                    \
					done=1;                                                     \
				fi;                                                            \
			fi;                                                               \
			if [ $$done = 0 ]; then                                           \
				if [ ! -r $$magic ]; then                                      \
					touch $$magic;                                              \
				elif [ -w $$magic ]; then                                      \
					 echo "" >> $$magic;                                        \
				fi;                                                            \
				if [ -w $$magic ]; then                                        \
					cat magic >> $$magic;                                       \
				fi;                                                            \
			fi;                                                               \
		fi;                                                                  \
	fi

# vi:set ts=3 sw=3:
