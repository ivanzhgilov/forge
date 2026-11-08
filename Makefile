GUILE ?= guile
MAIN := src/main.scm

.PHONY: run help version

run:
	$(GUILE) -L src $(MAIN) $(ARGS)

help:
	$(GUILE) -L src $(MAIN) --help

version:
	$(GUILE) -L src $(MAIN) --version
