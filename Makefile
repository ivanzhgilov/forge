.DEFAULT_GOAL := help

GUILE ?= guile
SRC_DIR ?= src
MAIN ?= $(SRC_DIR)/main.scm
GUILE_FLAGS ?= -L $(SRC_DIR) -L .

TEST_RUNNER ?= tests/run.scm
TEST_LOG ?= logs/test.log

.PHONY: run help version test

run:
	$(GUILE) $(GUILE_FLAGS) $(MAIN) $(ARGS)

help:
	$(GUILE) $(GUILE_FLAGS) $(MAIN) --help

version:
	$(GUILE) $(GUILE_FLAGS) $(MAIN) --version

test:
	@mkdir -p "$(dir $(TEST_LOG))"
	$(GUILE) $(GUILE_FLAGS) $(TEST_RUNNER) "$(TEST_LOG)"
