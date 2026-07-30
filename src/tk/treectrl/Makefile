# ======================================================================
# Makefile for Scidc for Unix operating systems
# ======================================================================

include ../../../Makefile.in

.SUFFIXES: .c

INCL_PRE		= -I.
INCL_POST	=
INCLUDE		= $(INCL_PRE) $(INCL_POST)
ALL_INCLUDE	= $(INCL_PRE) $(TCL_INCLUDE) $(TK_INCLUDE) $(INCL_POST)
DEFINES		= -DHAVE_UNISTD_H=1 -DSTDC_HEADERS=1
CFLAGS		+= $(OPTIMIZE) $(C_DEBUG) $(SYS_CFLAGS) $(DEFINES)

SRC_C = \
	qebind.c \
	tkTreeColumn.c \
	tkTreeCtrl.c \
	tkTreeDisplay.c \
	tkTreeDrag.c \
	tkTreeElem.c \
	tkTreeItem.c \
	tkTreeMarquee.c \
	tkTreeNotify.c \
	tkTreeStyle.c \
	tkTreeTheme.c \
	tkTreeUtils.c \

SRC	= $(SRC_C)
OBJS	= $(SRC_C:.c=.o)
LIB	= libtreectrl

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

qebind.o: qebind.h
tkTreeColumn.o: tkTreeCtrl.h
tkTreeColumn.o: qebind.h
tkTreeCtrl.o: tkTreeCtrl.h
tkTreeCtrl.o: qebind.h
tkTreeDisplay.o: tkTreeCtrl.h
tkTreeDisplay.o: qebind.h
tkTreeDrag.o: tkTreeCtrl.h
tkTreeDrag.o: qebind.h
tkTreeElem.o: tkTreeCtrl.h
tkTreeElem.o: qebind.h
tkTreeElem.o: tkTreeElem.h
tkTreeItem.o: tkTreeCtrl.h
tkTreeItem.o: qebind.h
tkTreeMarquee.o: tkTreeCtrl.h
tkTreeMarquee.o: qebind.h
tkTreeNotify.o: tkTreeCtrl.h
tkTreeNotify.o: qebind.h
tkTreeStyle.o: tkTreeCtrl.h
tkTreeStyle.o: qebind.h
tkTreeStyle.o: tkTreeElem.h
tkTreeTheme.o: tkTreeCtrl.h
tkTreeTheme.o: qebind.h
tkTreeUtils.o: tkTreeCtrl.h
tkTreeUtils.o: qebind.h
