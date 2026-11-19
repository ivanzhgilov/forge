.DEFAULT_GOAL := help
GUILE_CACHE_ROOT ?= $(HOME)/.cache/guile/ccache

GUILE ?= guile
SRC_DIR ?= src
MAIN ?= $(SRC_DIR)/main.scm
GUILE_FLAGS ?= -L $(SRC_DIR) -L .

TEST_RUNNER ?= tests/run.scm
TEST_LOG ?= logs/test.log

.PHONY: run help version test clean-guile-cache

run:
	$(GUILE) $(GUILE_FLAGS) $(MAIN) $(ARGS)

help:
	$(GUILE) $(GUILE_FLAGS) $(MAIN) --help

version:
	$(GUILE) $(GUILE_FLAGS) $(MAIN) --version

test:
	@mkdir -p "$(dir $(TEST_LOG))"
	$(GUILE) $(GUILE_FLAGS) $(TEST_RUNNER) "$(TEST_LOG)"

clean-guile-cache:
	@for cache in "$(GUILE_CACHE_ROOT)"/*; do \
		[ -d "$$cache" ] || continue; \
		rm -rf "$$cache$(CURDIR)"; \
	done


