.DEFAULT_GOAL := help

GUILE ?= guile
SRC_DIR ?= src
TEST_DIR ?= tests
MAIN ?= $(SRC_DIR)/main.scm

GUILE_FLAGS ?= -L $(SRC_DIR) -L .
TEST_FILES ?= $(sort $(wildcard $(TEST_DIR)/*.scm))

.PHONY: run help version test

run:
	$(GUILE) $(GUILE_FLAGS) $(MAIN) $(ARGS)

help:
	$(GUILE) $(GUILE_FLAGS) $(MAIN) --help

version:
	$(GUILE) $(GUILE_FLAGS) $(MAIN) --version

test:
	@set -e; \
	if [ -z "$(strip $(TEST_FILES))" ]; then \
		printf 'No test files found in %s\n' '$(TEST_DIR)' >&2; \
		exit 1; \
	fi; \
	for test_file in $(TEST_FILES); do \
		printf '\n==> %s\n' "$$test_file"; \
		$(GUILE) $(GUILE_FLAGS) "$$test_file"; \
	done
