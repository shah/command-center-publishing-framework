# This Makefile is called by the CCPF main Makefile, it is not designed to be
# called on its own. The following variables are expected to be passed through
# the environment:
# CCPF_HOME, CCPF_VERSION, CCPF_LOG_LEVEL
# CCPF_JSONNET, CCPF_JQ 
# CCPF_PROJECT_NAME, CCPF_PROJECT_HOME, CCPF_PROJECT_VENDOR_HOME
# CCPF_FACTS_DEST_PATH

SHELL := /bin/bash
MAKEFLAGS := silent

CURRENT_DIR_NAME := $(shell basename `pwd`)
CURRENT_DIR_ABS_PATH := $(shell echo `pwd`)
CURRENT_DIR_REL_PATH := $(shell realpath --relative-to=$(CCPF_PROJECT_HOME) $(CURRENT_DIR_ABS_PATH))

include $(CCPF_HOME)/lib/common.ccpf-make.inc

default:
	$(call logInfo,No default target in $(YELLOW)$(CURRENT_DIR_REL_PATH)/Makefile$(RESET))

generate: vendorize
	cd $(CCPF_PROJECT_HOME) && \
	CCPF_HOME=$(CCPF_HOME) CCPF_JQ=$(CCPF_JQ)
		$(CCPF_HOME)/bin/git-log-as-json.sh > $(CURRENT_DIR_ABS_PATH)/%(changeLogFileName)s
	$(call logInfo,Generated $(YELLOW)$(CURRENT_DIR_REL_PATH)/%(changeLogFileName)s$(RESET))
	cd $(CCPF_PROJECT_HOME) && \
	NODE_VERSION=default "$(CCPF_PROJECT_VENDOR_HOME)/nvm/nvm-exec" \
		leasot --reporter json '**/*.md' | $(CCPF_JQ) . > $(CURRENT_DIR_ABS_PATH)/%(todosFileName)s
	$(call logInfo,Generated $(YELLOW)$(CURRENT_DIR_REL_PATH)/%(todosFileName)s$(RESET))

clean: clean-vendor
	rm -f $(CURRENT_DIR_REL_PATH)/%(changeLogFileName)s
	rm -f $(CURRENT_DIR_REL_PATH)/%(todosFileName)s

clean-vendor:
	$(call logInfo,Removing NPM module $(YELLOW)leasot$(RESET))
	NODE_VERSION=default "$(CCPF_PROJECT_VENDOR_HOME)/nvm/nvm-exec" npm uninstall --global leasot

LEASOT_INSTALLED := $(shell NODE_VERSION=default "$(CCPF_PROJECT_VENDOR_HOME)/nvm/nvm-exec" npm list --global leasot 2> /dev/null)
vendorize: $(CCPF_PROJECT_VENDOR_HOME)/nvm
ifndef LEASOT_INSTALLED
	$(call logInfo,Installing NPM module $(YELLOW)leasot$(RESET))
	NODE_VERSION=default "$(CCPF_PROJECT_VENDOR_HOME)/nvm/nvm-exec" npm install --global leasot
else
	$(call logInfo,NPM module $(YELLOW)leasot$(RESET) already installed)
endif
