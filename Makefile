#
# Makefile
# phatblat.pass
#

################################################################################
#
# Variables
#

SHELL = /bin/sh
PROJECT_DIR = signpass
BIN_DIR = $(PROJECT_DIR)/bin
OUTPUT_BINARY = $(BIN_DIR)/signpass
PASS_PACKAGE = zsoltkebel.pass
XCODE_PROJECT = signpass/signpass.xcodeproj

TEAM_IDENTIFIER= # Pass this info when calling make pass
PASS_TYPE_IDENTIFIER= # Pass this info when calling make pass

################################################################################
#
# Help
#

.PHONY: help
help: MAKEFILE_FMT = "  \033[36m%-25s\033[0m%s\n"
help: ## (default) Displays this message
	@echo "Targets:"
	@grep -E '^[a-zA-Z0-9_-]*:.*?##' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?##"}; {printf $(MAKEFILE_FMT), $$1, $$2}'
: # Hacky way to display a newline ##

################################################################################
#
# Targets
#

.PHONY: version
version: ## Prints tool versions
	make --version
	xcodebuild -version

.PHONY: clean
clean: ## Cleans the project
	rm -rf $(BIN_DIR)

.PHONY: build
build: ## Builds the project
	rm -f $(PASS_PACKAGE)/.DS_Store
	xcodebuild -project $(XCODE_PROJECT) build
	ls -l $(OUTPUT_BINARY)

.PHONY: pass
pass: build ## Builds the pass
	teamIdentifier=$(TEAM_IDENTIFIER) passTypeIdentifier=$(PASS_TYPE_IDENTIFIER) envsubst < $(PASS_PACKAGE)/pass-info.json > $(PASS_PACKAGE)/pass.json
	$(OUTPUT_BINARY) -p $(PASS_PACKAGE)
