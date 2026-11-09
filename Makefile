GUILE ?= guile
MAIN := src/main.scm

.PHONY: run help version

run:
	$(GUILE) -L src -L . $(MAIN) $(ARGS)

help:
	$(GUILE) -L src -L . $(MAIN) --help

version:
	$(GUILE) -L src -L . $(MAIN) --version
