# This is considered a "typical" project Makefile and is designed to be 
# symlink'd from a project directory as "Makefile"
# All useful variables that can be overridden in the environment start with CCPF_*

CCPF_VERSION := 1.0.0
SHELL := /bin/bash
MAKEFLAGS := silent

CCPF_PROJECT_HOME ?= $(shell echo `pwd`)
CCPF_PROJECT_NAME ?= $(shell basename $(CCPF_PROJECT_HOME))
CCPF_PROJECT_VENDOR_HOME ?= $(CCPF_PROJECT_HOME)/vendor

CCPF_HOME ?= $(CCPF_PROJECT_VENDOR_HOME)/command-center-publishing-framework
CCPF_JSONNET ?= $(CCPF_HOME)/bin/jsonnet
CCPF_JQ ?= $(CCPF_HOME)/bin/jq
CCPF_LOG_LEVEL ?= "NONE"
CCPF_FACTS_FILES ?= $(CCPF_HOME)/etc/common.ccpf-factsgen.jsonnet:$(CCPF_PROJECT_HOME)/project.ccpf-factsgen.jsonnet
JSONNET_PATH ?= $(CCPF_PROJECT_HOME)/.secrets:$(CCPF_PROJECT_HOME)/etc:$(CCPF_PROJECT_HOME)/lib:$(HOME)/.ccpf/secrets:$(HOME)/.ccpf/etc:$(CCPF_HOME)/lib:$(CCPF_HOME)/etc

# This is the primary JSonnet configuration file, it creates all the project's
# definition and configuration files using Jsonnet -m (multi-file) strategy.
CCPF_PROJECT_JSONNET ?= project.ccpf-defn.jsonnet

# This file holds the list of files configured by the jsonnet --multi command
PROJECT_DEFN_JSONNET_CONFIGURED_FILES_LIST := .ccpf_project.ccpf-defn.jsonnet_configured
DELETE_CONFIGURED_FILES_SCRIPT := .ccpf_delete_configured_files.sh

CCPF_CUSTOM_PRE_CONFIGURE_SCRIPT_NAME := ./before_configure.ccpf-make-plugin.sh
CCPF_CUSTOM_POST_CONFIGURE_SCRIPT_NAME := ./after_configure.ccpf-make-plugin.sh
CCPF_CUSTOM_INCLUDE_FILES := *.ccpf-make.inc

# This is the "environment facts bootstrap" script which figures out what's in the
# runtime environment and stores that data in the destination path. That destination
# path is then available in JSONNET_PATH for use in project.ccpf-defn.jsonnet.
CCPF_FACTS_CONFIGURATOR_SCRIPT ?= $(CCPF_HOME)/bin/configure-ccpf-facts.sh
CCPF_FACTS_DEST_PATH ?= $(CCPF_PROJECT_HOME)/.ccpf_facts
CCPF_FACTS_DEST_PATH_RELATIVE ?= $(shell realpath --relative-to=$(CCPF_PROJECT_HOME) $(CCPF_FACTS_DEST_PATH))

include $(CCPF_HOME)/lib/common.ccpf-make.inc

default: help

.ONESHELL:
pre-configure:
	mkdir -p $(CCPF_FACTS_DEST_PATH)
	if [ -f $(CCPF_CUSTOM_PRE_CONFIGURE_SCRIPT_NAME) ]; then
		$(call logInfo,Running custom pre-configuration script $(GREEN)$(CCPF_CUSTOM_PRE_CONFIGURE_SCRIPT_NAME)$(RESET) for $(GREEN)$(CCPF_PROJECT_NAME)$(RESET))
		chmod +x $(CCPF_CUSTOM_PRE_CONFIGURE_SCRIPT_NAME)
		$(CCPF_CUSTOM_PRE_CONFIGURE_SCRIPT_NAME) $(CCPF_PROJECT_NAME)
	fi

.ONESHELL:
configure-facts: pre-configure
	$(call logInfo,Running $(GREEN)$(CCPF_FACTS_CONFIGURATOR_SCRIPT)$(RESET)$(comma) dest $(YELLOW)$(CCPF_FACTS_DEST_PATH_RELATIVE)$(RESET))
	CCPF_VERSION=$(CCPF_VERSION) CCPF_HOME=$(CCPF_HOME) CCPF_FACTS_FILES=$(CCPF_FACTS_FILES) CCPF_LOG=$(CCPF_LOG) \
		CCPF_JSONNET=$(CCPF_JSONNET) CCPF_JQ=$(CCPF_JQ) \
	    CCPF_PROJECT_HOME=$(CCPF_PROJECT_HOME) CCPF_PROJECT_NAME=$(CCPF_PROJECT_NAME) \
		CCPF_MAKEFILE_CUSTOM_PRE_CONFIGURE_SCRIPT_NAME=$(CCPF_CUSTOM_PRE_CONFIGURE_SCRIPT_NAME) \
		CCPF_MAKEFILE_CUSTOM_POST_CONFIGURE_SCRIPT_NAME=$(CCPF_CUSTOM_POST_CONFIGURE_SCRIPT_NAME) \
		CCPF_MAKEFILE_CUSTOM_INCLUDE_FILE=$(CCPF_CUSTOM_INCLUDE_FILES) \
	    JSONNET_PATH="$(JSONNET_PATH)" DEST_PATH=$(CCPF_FACTS_DEST_PATH) \
		bash $(CCPF_FACTS_CONFIGURATOR_SCRIPT)

.ONESHELL:
configure-project: configure-facts
	JSONNET_PATH="$(JSONNET_PATH)" \
			$(CCPF_JSONNET) --jpath $(CCPF_FACTS_DEST_PATH) \
					-S --multi . $(CCPF_PROJECT_JSONNET) > $(PROJECT_DEFN_JSONNET_CONFIGURED_FILES_LIST)
	
	$(call logInfo,Generated project definitions from $(GREEN)$(CCPF_PROJECT_JSONNET)$(RESET) (cached in $(YELLOW)$(PROJECT_DEFN_JSONNET_CONFIGURED_FILES_LIST)$(RESET)):)
	if [ "$(CCPF_LOG_LEVEL)" = 'INFO' ]; then
		cat $(PROJECT_DEFN_JSONNET_CONFIGURED_FILES_LIST)  | sed 's/^\.\//$(RESET)  > $(YELLOW)/'
		echo "$(RESET)"
	fi
	$(call logInfo,Created $(YELLOW).gitignore$(RESET) to prevent tracking of generated files)
	echo "# Generated by Makefile. DO NOT EDIT" > .gitignore
	echo $(PROJECT_DEFN_JSONNET_CONFIGURED_FILES_LIST) >> .gitignore
	echo ".secrets" >> .gitignore
	echo "**/*.ccpf-secrets.jsonnet" >> .gitignore
	echo "**/*.ccpf-secrets.json" >> .gitignore
	echo "**/*.ccpf-secrets.env" >> .gitignore
	echo $(DELETE_CONFIGURED_FILES_SCRIPT) >> .gitignore
	echo $(CCPF_FACTS_DEST_PATH_RELATIVE) >> .gitignore
	cat $(PROJECT_DEFN_JSONNET_CONFIGURED_FILES_LIST) | sed 's/^\.\///' >> .gitignore
	cat $(PROJECT_DEFN_JSONNET_CONFIGURED_FILES_LIST) | sed 's/^/rm -f /' > $(DELETE_CONFIGURED_FILES_SCRIPT)

unconfigure-project:
	bash $(DELETE_CONFIGURED_FILES_SCRIPT)
	$(call logInfo,Ran $(YELLOW)$(DELETE_CONFIGURED_FILES_SCRIPT)$(RESET))
	rm -f $(PROJECT_DEFN_JSONNET_CONFIGURED_FILES_LIST)
	rm -f $(DELETE_CONFIGURED_FILES_SCRIPT)
	$(call logInfo,Deleted $(YELLOW)$(PROJECT_DEFN_JSONNET_CONFIGURED_FILES_LIST)$(RESET) and $(YELLOW)$(DELETE_CONFIGURED_FILES_SCRIPT)$(RESET))
	rm -rf $(CCPF_FACTS_DEST_PATH)
	$(call logInfo,Deleted $(YELLOW)$(CCPF_FACTS_DEST_PATH_RELATIVE)$(RESET))

.ONESHELL:
## Generate all project artifacts from Jsonnet config
configure: configure-project
	if [ -f $(CCPF_CUSTOM_POST_CONFIGURE_SCRIPT_NAME) ]; then
		$(call logInfo,Running custom post-configuration script $(CCPF_CUSTOM_POST_CONFIGURE_SCRIPT_NAME) for $(CCPF_PROJECT_NAME))
		chmod +x $(CCPF_CUSTOM_POST_CONFIGURE_SCRIPT_NAME)
		$(CCPF_CUSTOM_POST_CONFIGURE_SCRIPT_NAME) $(CCPF_PROJECT_NAME)
	fi

## Opposite of configure, remove all generated artifacts and "reset" directory
unconfigure: unconfigure-project

## Run unconfigure and then configure together
reconfigure: unconfigure configure

## Check all dependencies
doctor:
	$(CCPF_HOME)/bin/doctor.sh

## Upgrade the vendorized CCPF version
upgrade-CCPF:
	$(CCPF_HOME)/bin/vendorize-CCPF.sh

.ONESHELL:
make-subdirs-with-MAKECMDGOALS:
	$(call logInfo,Starting make $(GREEN)$(MAKECMDGOALS)$(RESET) in all subdirectories)
	for subDir in $$(find . -type f -name 'Makefile' ! -path . ! -path "./vendor/*" | xargs -I{} dirname {}) ; do \
		$(call logInfo,Running make $(GREEN)$(MAKECMDGOALS)$(RESET) in $(GREEN)$$subDir$(RESET))
		CCPF_LOG_LEVEL=$(CCPF_LOG_LEVEL) \
		CCPF_HOME=$(CCPF_HOME) \
		CCPF_VERSION=$(CCPF_VERSION) \
		CCPF_JSONNET=$(CCPF_JSONNET) \
		CCPF_JQ=$(CCPF_JQ) \
		CCPF_PROJECT_NAME=$(CCPF_PROJECT_NAME) \
		CCPF_PROJECT_HOME=$(CCPF_PROJECT_HOME) \
		CCPF_PROJECT_VENDOR_HOME=$(CCPF_PROJECT_VENDOR_HOME) \
		CCPF_FACTS_DEST_PATH=$(CCPF_FACTS_DEST_PATH) \
			$(MAKE) $(MAKECMDGOALS) -C $$subDir; \
		$(call logInfo,Finished make $(GREEN)$(MAKECMDGOALS)$(RESET) in $(GREEN)$$subDir$(RESET))
	done
	$(call logInfo,Finished make $(GREEN)$(MAKECMDGOALS)$(RESET) in all subdirectories)

-include $(CCPF_CUSTOM_INCLUDE_FILES)
