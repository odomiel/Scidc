# ======================================================================
# Makefile for Scidc for Unix operating systems
# ======================================================================

include ../../../Makefile.in

.SUFFIXES: .c

INCLUDE	= -I.
DEBUG		= -DNDEBUG
OPTIMIZE	= -O2

# Die Quellen sind eine unveraenderte Kopie von zlib 1.3.2. Was zlibs
# eigenes configure sonst in ein erzeugtes zconf.h schreiben wuerde,
# steht deshalb hier:
#
#   Z_HAVE_UNISTD_H     zieht <unistd.h> herein; ohne das ist lseek in
#                       gzlib.c nicht erklaert und der Bau bricht ab.
#   _LARGEFILE64_SOURCE zlibs configure setzt es auf Linux. Es erzeugt
#                       zusaetzlich gzopen64/gzseek64/gztell64/gzoffset64
#                       und die *_combine64. Die Systembibliothek fuehrt
#                       diese Namen; ohne sie koennte eine mitgelieferte
#                       Bibliothek eine gzFile bei libz.so.1 oeffnen und
#                       bei dieser Kopie weiterreichen.
DEFINES	= -DZ_HAVE_UNISTD_H -D_LARGEFILE64_SOURCE=1

CFLAGS	+= $(OPTIMIZE) $(DEBUG) $(SYS_CFLAGS) $(DEFINES)

SRC_C = \
	adler32.c \
	compress.c \
	crc32.c \
	deflate.c \
	gzclose.c \
	gzlib.c \
	gzread.c \
	gzwrite.c \
	infback.c \
	inffast.c \
	inflate.c \
	inftrees.c \
	trees.c \
	uncompr.c \
	zutil.c \

SRC	= $(SRC_C)
OBJS	= $(SRC_C:.c=.o)
LIB	= libz

all: $(LIB).a

clean:
	@echo "Clean `pwd`"
	@rm -f $(LIB).a $(OBJS)
 
depend:
	# do nothing

$(LIB).a: $(OBJS)
	@echo "Building $(LIB).a"
	@$(AR) $(ARFLAGS) $(LIB).a $(OBJS)
	@$(RANLIB) $(LIB).a

.c.o:
	@echo "Compiling `awk 'BEGIN { printf "%-30s", "$<" }'`  [$(CFLAGS:  = )]"
	@$(CC) -c $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) $<

# vi:set ts=3 sw=3:
