GUILE ?= guile
MAIN := src/main.scm

.PHONY: run help version test

run:
	$(GUILE) -L src -L . $(MAIN) $(ARGS)

help:
	$(GUILE) -L src -L . $(MAIN) --help

version:
	$(GUILE) -L src -L . $(MAIN) --version

test:
	$(GUILE) -L src tests/version.scm
	$(GUILE) -L src tests/dependency.scm
