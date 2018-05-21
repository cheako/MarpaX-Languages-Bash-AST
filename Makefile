all:

install:

test:
	prove $(PROVEFLAGS)

.PHONY: all install test
