# ======================================================================
# Makefile for Scidc for Unix operating systems
# ======================================================================

include ../Makefile.in

all:
	@for dir in $(ENGINES); do           \
		$(MAKE) -C $$dir;                 \
		if [ $$? != 0 ]; then exit 1; fi; \
	done

depend:
	# no action

clean:
	@for dir in $(ENGINES); do \
		$(MAKE) -C $$dir clean; \
	done

install:
	@echo "Install engines"
	@for dir in $(ENGINES); do   \
		$(MAKE) -C $$dir install; \
	done

uninstall:
	@echo "Uninstall engines"
	@for dir in $(ENGINES); do     \
		$(MAKE) -C $$dir uninstall; \
	done

# vi:set ts=3 sw=3:
