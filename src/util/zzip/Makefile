# ======================================================================
# Makefile for Scidc for Unix operating systems
# ======================================================================

include ../../../Makefile.in

.SUFFIXES: .c
.PRECIOUS:

INCLUDE	= -I..
OPTIMIZE	= -O2 -fomit-frame-pointer
C_DEBUG	= -DNDEBUG -Wno-strict-aliasing
DEFINES	= -D_USE_MMAP -DZZIP_HAVE_STDINT_H
CFLAGS	+= $(OPTIMIZE) $(C_DEBUG) $(SYS_CFLAGS) $(DEFINES)

ALL_INCLUDE	= $(INCLUDE) $(ZLIB_INC)

SRC_C = \
	dir.c \
	err.c \
	file.c \
	info.c \
	plugin.c \
	stat.c \
	zip.c \

SRC	= $(SRC_C)
OBJS	= $(SRC_C:.c=.o)
LIB	= libzzip

all: $(LIB).a

clean:
	@echo "Clean `pwd`"
	@rm -f $(LIB).a $(OBJS) Makefile.bak

depend:
	makedepend -fMakefile -Y -- $(INCLUDE) -- -w1 $(SRC) 2>/dev/null
	@if [ -h Makefile.bak ]; then \
		cp Makefile Makefile.bak; \
		mv Makefile.bak Makefile; \
	fi

$(LIB).a: $(OBJS)
	@echo "Building $(LIB).a"
	@$(AR) $(ARFLAGS) $(LIB).a $(OBJS)
	@$(RANLIB) $(LIB).a

.c.o:
	@echo "Compiling `awk 'BEGIN { printf "%-30s", "$<" }'`  [$(CFLAGS:  = )]"
	@$(CC) -c $(CFLAGS) $(EXTRA_CFLAGS) $(ALL_INCLUDE) $<

# vi:set ts=3 sw=3:
# DO NOT DELETE THIS LINE -- make depend depends on it.

dir.o: ../zzip/zzip.h
dir.o: ../zzip/types.h
dir.o: ../zzip/plugin.h
dir.o: ../zzip/lib.h
dir.o: ../zzip/conf.h
dir.o: ../zzip/_config.h
dir.o: ../zzip/stdint.h
dir.o: ../zzip/file.h
dir.o: __dirent.h
err.o: ../zzip/zzip.h
err.o: ../zzip/types.h
err.o: ../zzip/lib.h
err.o: ../zzip/conf.h
err.o: ../zzip/_config.h
err.o: ../zzip/stdint.h
file.o: ../zzip/zzip.h
file.o: ../zzip/types.h
file.o: ../zzip/plugin.h
file.o: ../zzip/lib.h
file.o: ../zzip/conf.h
file.o: ../zzip/_config.h
file.o: ../zzip/stdint.h
file.o: ../zzip/file.h
file.o: ../zzip/format.h
file.o: ../zzip/__debug.h
file.o: __hints.h
info.o: ../zzip/zzip.h
info.o: ../zzip/types.h
info.o: ../zzip/lib.h
info.o: ../zzip/conf.h
info.o: ../zzip/_config.h
info.o: ../zzip/stdint.h
info.o: ../zzip/file.h
info.o: ../zzip/format.h
plugin.o: ../zzip/zzip.h
plugin.o: ../zzip/types.h
plugin.o: ../zzip/plugin.h
plugin.o: ../zzip/lib.h
plugin.o: ../zzip/conf.h
plugin.o: ../zzip/_config.h
plugin.o: ../zzip/stdint.h
plugin.o: ../zzip/file.h
plugin.o: ../zzip/format.h
stat.o: ../zzip/zzip.h
stat.o: ../zzip/types.h
stat.o: ../zzip/plugin.h
stat.o: ../zzip/lib.h
stat.o: ../zzip/conf.h
stat.o: ../zzip/_config.h
stat.o: ../zzip/stdint.h
zip.o: ../zzip/zzip.h
zip.o: ../zzip/types.h
zip.o: ../zzip/plugin.h
zip.o: ../zzip/lib.h
zip.o: ../zzip/conf.h
zip.o: ../zzip/_config.h
zip.o: ../zzip/stdint.h
zip.o: ../zzip/file.h
zip.o: ../zzip/format.h
zip.o: __mmap.h
zip.o: __debug.h
zip.o: __hints.h
