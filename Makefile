all:

install:

test:
	prove -l -v -f tx || true
	prove -l -f

.PHONY: all install test
