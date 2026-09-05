# ======================================================================
# Makefile for Scidc for Unix operating systems
# ======================================================================
#
# Uebersetzt expat 2.8.4 zu libexpat.a. Alle Schalter stehen in
# expat_config.h -- hier werden bewusst keine -D... gesetzt, damit es
# nur eine Stelle gibt, an der der Funktionsumfang festgelegt ist.
#
# Die beiden random_*.c entsprechen der Auswahl in expat_config.h
# (getrandom mit /dev/urandom als Rueckfall). Die uebrigen random_*.c
# im Verzeichnis gehoeren zur vollstaendigen Kopie von expats lib/ und
# werden auf diesem System nicht uebersetzt.
# ======================================================================

include ../../../Makefile.in

.SUFFIXES: .c

OPTIMIZE	= -O2
CFLAGS	+= $(OPTIMIZE) $(SYS_CFLAGS)

LIBOBJS =\
	xmlparse.o \
	xmltok.o \
	xmlrole.o \
	random_getrandom.o \
	random_dev_urandom.o \

LIB = libexpat

all: $(LIB).a

$(LIB).a: $(LIBOBJS)
	@echo "Building $(LIB).a"
	@$(AR) rc $(LIB).a $(LIBOBJS)
	@$(RANLIB) $(LIB).a

clean:
	@echo "Clean `pwd`"
	@rm -f $(LIBOBJS) $(LIB).a

depend:
	# do nothing

.c.o:
	@echo "Compiling `awk 'BEGIN { printf "%-30s", "$<" }'`  [$(CFLAGS:  = )]"
	@$(CC) -c $(CFLAGS) $(EXTRA_CFLAGS) -o $@ $<

# vi:set ts=3 sw=3:
# DO NOT DELETE THIS LINE -- make depend depends on it.

xmlparse.o:          expat_config.h expat.h expat_external.h internal.h \
                     siphash.h ascii.h asciitab.h xmltok.h xmlrole.h \
                     xcsinc.c
xmltok.o:            expat_config.h expat_external.h internal.h ascii.h \
                     asciitab.h iasciitab.h latin1tab.h nametab.h utf8tab.h \
                     xmltok.h xmltok_impl.h xmltok_impl.c xmltok_ns.c
xmlrole.o:           expat_config.h expat_external.h internal.h ascii.h \
                     xmlrole.h
random_getrandom.o:  expat_config.h random_getrandom.h memory_sanitizer.h
random_dev_urandom.o: expat_config.h random_dev_urandom.h memory_sanitizer.h
