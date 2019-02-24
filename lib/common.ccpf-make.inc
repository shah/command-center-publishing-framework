GREEN    := $(shell tput -Txterm setaf 2)
YELLOW   := $(shell tput -Txterm setaf 3)
WHITE    := $(shell tput -Txterm setaf 7)
RESET    := $(shell tput -Txterm sgr0)
REDFLASH := $(shell tput -Txterm setaf 4)

comma := ,
.ONESHELL:
define logInfo
	if [ "$(CCPF_LOG_LEVEL)" = 'INFO' ]; then
		echo "$1"
	fi
endef

vendor/gohome:
	VENDOR_HOME=$(CCPF_PROJECT_VENDOR_HOME) $(CCPF_HOME)/bin/vendorize-golang-ecosystem.sh

$(CCPF_PROJECT_VENDOR_HOME)/gohome:
	VENDOR_HOME=$(CCPF_PROJECT_VENDOR_HOME) $(CCPF_HOME)/bin/vendorize-golang-ecosystem.sh

vendor/java/home:
	VENDOR_HOME=$(CCPF_PROJECT_VENDOR_HOME) $(CCPF_HOME)/bin/vendorize-java-ecosystem.sh

$(CCPF_PROJECT_VENDOR_HOME)/java/home:
	VENDOR_HOME=$(CCPF_PROJECT_VENDOR_HOME) $(CCPF_HOME)/bin/vendorize-java-ecosystem.sh

vendor/nvm:
	VENDOR_HOME=$(CCPF_PROJECT_VENDOR_HOME) $(CCPF_HOME)/bin/vendorize-nodejs-ecosystem.sh

$(CCPF_PROJECT_VENDOR_HOME)/nvm:
	VENDOR_HOME=$(CCPF_PROJECT_VENDOR_HOME) $(CCPF_HOME)/bin/vendorize-nodejs-ecosystem.sh

TARGET_MAX_CHAR_NUM=15
# All targets should have a ## Help text above the target and they'll be automatically collected
# Show help, using auto generator from https://gist.github.com/prwhite/8168133
help:
	@echo 'Command Center Publishing Framework $(CCPF_VERSION)'
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${WHITE}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@echo ''	
	@echo '${YELLOW}CCPF_ORIGINAL_TARGET${RESET}=${GREEN}$(CCPF_ORIGINAL_TARGET)${RESET}'
	@echo '${YELLOW}JSONNET_PATH${RESET}=${GREEN}$(JSONNET_PATH)${RESET}'
	@echo '${YELLOW}CCPF_HOME${RESET}=${GREEN}$(CCPF_HOME)${RESET}'
	@echo '${YELLOW}CCPF_PROJECT_HOME${RESET}=${GREEN}$(CCPF_PROJECT_HOME)${RESET}'
	@echo '${YELLOW}CCPF_PROJECT_VENDOR_HOME${RESET}=${GREEN}$(CCPF_PROJECT_VENDOR_HOME)${RESET}'
	@echo '${YELLOW}CCPF_FACTS_FILES${RESET}=${GREEN}$(CCPF_FACTS_FILES)${RESET}'
	@echo '${YELLOW}CCPF_FACTS_CONFIGURATOR_SCRIPT${RESET}=${GREEN}$(CCPF_FACTS_CONFIGURATOR_SCRIPT)${RESET}'
	@echo '${YELLOW}CCPF_LOG_LEVEL${RESET}=${GREEN}$(CCPF_LOG_LEVEL)${RESET}'
	@echo '${YELLOW}CCPF_PROJECT_MAKEFILE_SUBDIRS${RESET}=${GREEN}$(CCPF_PROJECT_MAKEFILE_SUBDIRS)${RESET}'
