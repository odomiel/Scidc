# ======================================================================
# Makefile for Scidc for Unix operating systems
# ======================================================================

include ../../../Makefile.in

.SUFFIXES: .c

INCLUDE	= -I. $(ZLIB_INC)
OPTIMIZE	= -O2 -fomit-frame-pointer
C_DEBUG	= -DNDEBUG
DEFINES	= -DHAVE_ZLIB -DZLIB_COMPAT -DMZ_ZIP_NO_CRYPTO
CFLAGS	= $(OPTIMIZE) $(C_DEBUG) $(SYS_CFLAGS) $(DEFINES)

SRC_C = \
	mz_crypt.c \
	mz_os.c \
	mz_os_posix.c \
	mz_strm.c \
	mz_strm_buf.c \
	mz_strm_mem.c \
	mz_strm_os_posix.c \
	mz_strm_split.c \
	mz_strm_zlib.c \
	mz_zip.c \
	mz_zip_rw.c \

SRC	= $(SRC_C)
OBJS	= $(SRC_C:.c=.o)
LIB	= libminizip

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
# DO NOT DELETE THIS LINE -- make depend depends on it.
