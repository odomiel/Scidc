# ======================================================================
# Makefile for Scidc for Unix operating systems
# ======================================================================

include ../../../Makefile.in

.SUFFIXES: .c

INCL_PRE      = -I.
INCL_POST     =
INCLUDE       = $(INCL_PRE) $(INCL_POST)
ALL_INCLUDE   = $(INCL_PRE) $(TCL_INCLUDE) $(TK_INCLUDE) $(INCL_POST)
CFLAGS       += $(OPTIMIZE) $(PROFILING) $(C_DEBUG) $(SYS_CFLAGS)
CFLAGS       += -std=c99
#CFLAGS      += -DTK_LAYOUT_WITH_BASE_CHUNKS=0 -DTK_DRAW_IN_CONTEXT=0
EXTRA_CFLAGS += -DMODULE_SCOPE="" -g -O2 #-DNDEBUG=1

SRC_C	= \
	tkBitField.c \
	tkIntSet.c \
	tkMisc.c \
	tkRangeList.c \
	tkTextBTree.c \
	tkText.c \
	tkTextDisp.c \
	tkTextImage.c \
	tkTextIndex.c \
	tkTextLineBreak.c \
	tkTextMark.c \
	tkTextTag.c \
	tkTextTagSet.c \
	tkTextUndo.c \
	tkTextWind.c \

SRC	= $(SRC_C)
OBJS	= $(SRC_C:.c=.o)
LIB	= libTkText

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

tkBitField.o: tkBitField.h
tkBitField.o: tkBool.h
tkBitField.o: tkIntSet.h
tkBitField.o: tkAlloc.h
tkBitField.o: ./assert.h
tkBitField.o: tkBitFieldPriv.h
tkIntSet.o: tkIntSet.h
tkIntSet.o: tkBool.h
tkIntSet.o: tkBitField.h
tkIntSet.o: tkAlloc.h
tkIntSet.o: tkIntSetPriv.h
tkIntSet.o: ./assert.h
tkRangeList.o: tkRangeList.h
tkRangeList.o: tkBool.h
tkRangeList.o: tkAlloc.h
tkRangeList.o: ./assert.h
tkRangeList.o: tkRangeListPriv.h
tkTextBTree.o: tkText.h
tkTextBTree.o: tkTextUndo.h
tkTextBTree.o: tkBool.h
tkTextBTree.o: tkTextPriv.h
tkTextBTree.o: tkTextTagSet.h
tkTextBTree.o: tkBitField.h
tkTextBTree.o: tkIntSet.h
tkTextBTree.o: tkAlloc.h
tkTextBTree.o: ./assert.h
tkText.o: tkText.h
tkText.o: tkTextUndo.h
tkText.o: tkBool.h
tkText.o: tkTextTagSet.h
tkText.o: tkBitField.h
tkText.o: tkIntSet.h
tkText.o: tkAlloc.h
tkText.o: ./assert.h
tkText.o: tkTextPriv.h
tkTextDisp.o: tkText.h
tkTextDisp.o: tkTextUndo.h
tkTextDisp.o: tkBool.h
tkTextDisp.o: tkTextTagSet.h
tkTextDisp.o: tkBitField.h
tkTextDisp.o: tkIntSet.h
tkTextDisp.o: tkRangeList.h
tkTextDisp.o: tkAlloc.h
tkTextDisp.o: ./assert.h
tkTextImage.o: tkText.h
tkTextImage.o: tkTextUndo.h
tkTextImage.o: tkBool.h
tkTextImage.o: tkTextTagSet.h
tkTextImage.o: tkBitField.h
tkTextImage.o: tkIntSet.h
tkTextImage.o: tkAlloc.h
tkTextImage.o: ./assert.h
tkTextIndex.o: tkText.h
tkTextIndex.o: tkTextUndo.h
tkTextIndex.o: tkBool.h
tkTextIndex.o: tkTextTagSet.h
tkTextIndex.o: tkBitField.h
tkTextIndex.o: tkIntSet.h
tkTextIndex.o: tkAlloc.h
tkTextIndex.o: ./assert.h
tkTextLineBreak.o: tkText.h
tkTextLineBreak.o: tkTextUndo.h
tkTextLineBreak.o: tkBool.h
tkTextLineBreak.o: ./assert.h
tkTextMark.o: tkText.h
tkTextMark.o: tkTextUndo.h
tkTextMark.o: tkBool.h
tkTextMark.o: tkAlloc.h
tkTextMark.o: ./assert.h
tkTextTag.o: tkText.h
tkTextTag.o: tkTextUndo.h
tkTextTag.o: tkBool.h
tkTextTag.o: tkTextTagSet.h
tkTextTag.o: tkBitField.h
tkTextTag.o: tkIntSet.h
tkTextTag.o: tkAlloc.h
tkTextTag.o: ./assert.h
tkTextTagSet.o: tkTextTagSet.h
tkTextTagSet.o: tkBitField.h
tkTextTagSet.o: tkBool.h
tkTextTagSet.o: tkIntSet.h
tkTextTagSet.o: tkTextTagSetPriv.h
tkTextTagSet.o: ./assert.h
tkTextUndo.o: tkTextUndo.h
tkTextUndo.o: tkBool.h
tkTextUndo.o: tkAlloc.h
tkTextUndo.o: ./assert.h
tkTextUndo.o: tkTextUndoPriv.h
tkTextWind.o: tkText.h
tkTextWind.o: tkTextUndo.h
tkTextWind.o: tkBool.h
tkTextWind.o: tkTextTagSet.h
tkTextWind.o: tkBitField.h
tkTextWind.o: tkIntSet.h
tkTextWind.o: tkAlloc.h
tkTextWind.o: ./assert.h
