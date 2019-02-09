#!/usr/bin/env bash
set -euo pipefail

# This script is executed by the Makefile before generating the configurations from project.ccpf-defn.jsonnet
# Expecting environment variables upon entry:
# CCPF_VERSION
# CCPF_HOME
# CCPF_JSONNET
# CCPF_JQ
# CCPF_LOG_LEVEL
# CCPF_FACTS_FILES
# CCPF_PROJECT_HOME
# CCPF_PROJECT_NAME
# CCPF_MAKEFILE_CUSTOM_PRE_CONFIGURE_SCRIPT_NAME
# CCPF_MAKEFILE_CUSTOM_POST_CONFIGURE_SCRIPT_NAME
# CCPF_MAKEFILE_CUSTOM_INCLUDE_FILE
# JSONNET_PATH
# DEST_PATH

DEST_PATH_RELATIVE=`realpath --relative-to="$CCPF_PROJECT_HOME" "$DEST_PATH"`
DEST_FILE_EXTN=.ccpf-facts.json
GREEN=`tput -Txterm setaf 2`
YELLOW=`tput -Txterm setaf 3`
WHITE=`tput -Txterm setaf 7`
RESET=`tput -Txterm sgr0`

if [ ! -d "$DEST_PATH" ]; then
    echo "A CCPF project definition facts destination directory path is expected as DEST_PATH."
    exit 1
fi

logInfo() {
	if [ "${CCPF_LOG_LEVEL:-}" = 'INFO' ]; then
		echo "$1"
	fi
}

osqueryFactsSingleRow() {
    logInfo "Running osQuery single row, saving to ${YELLOW}$DEST_PATH_RELATIVE/$1$DEST_FILE_EXTN${RESET}: ${GREEN}$2${RESET}"
	osqueryi --json "$2" | $CCPF_JQ '.[0]' > $DEST_PATH/$1$DEST_FILE_EXTN
}

osqueryFactsMultipleRows() {
    logInfo "Running osQuery multi row, saving to ${YELLOW}$DEST_PATH_RELATIVE/$1$DEST_FILE_EXTN${RESET}: ${GREEN}$2${RESET}"
	osqueryi --json "$2" > $DEST_PATH/$1$DEST_FILE_EXTN
}

shellEvalFacts() {
	destFile=$DEST_PATH/$1$DEST_FILE_EXTN
	touch $destFile
	existingValues=$(<$destFile)
	if [ -z "$existingValues" ]; then
	    logInfo "Running shell eval, saving to ${YELLOW}$DEST_PATH_RELATIVE/$1$DEST_FILE_EXTN${RESET}: ${WHITE}$2${RESET} ${GREEN}$3${RESET}"
		existingValues="{}"
	else
	    logInfo "Running shell eval, appending to ${YELLOW}$DEST_PATH_RELATIVE/$1$DEST_FILE_EXTN${RESET}: ${WHITE}$2${RESET} ${GREEN}$3${RESET}"
	fi
	textValue=`eval $3`;	
	echo $existingValues | $CCPF_JQ --arg key "$2" --arg value "$textValue" '. + {($key) : $value}' > $destFile
}

generateFacts() {
	logInfo "Generating facts from ${GREEN}$1${RESET} into ${YELLOW}$DEST_PATH_RELATIVE${RESET} using JSONNET_PATH ${GREEN}$JSONNET_PATH${RESET}"
	$CCPF_JSONNET $1 | $CCPF_JQ -r '.osQueries.singleRow[] | "osqueryFactsSingleRow \(.name) \"\(.query)\""' | source /dev/stdin
	$CCPF_JSONNET $1 | $CCPF_JQ -r '.osQueries.multipleRows[] | "osqueryFactsMultipleRows \(.name) \"\(.query)\""' | source /dev/stdin
	$CCPF_JSONNET $1 | $CCPF_JQ -r '.shellEvals[] | "shellEvalFacts \(.name) \(.key) \"\(.evalAsTextValue)\""' | source /dev/stdin
}

IFS=':' read -ra FF <<< "$CCPF_FACTS_FILES"
 for ff in "${FF[@]}"; do
     if [ -f "$ff" ]; then
         generateFacts "$ff"
     else
         logInfo "Skipping facts file ${YELLOW}$ff${RESET} from CCPF_FACTS_FILES, does not exist."
     fi
 done

CONTEXT_FACTS_JSONNET_TMPL=${CONTEXT_FACTS_JSONNET_TMPL:-$CCPF_HOME/etc/context.ccpf-facts.ccpf-tmpl.jsonnet}
CONTEXT_FACTS_GENERATED_FILE=${CONTEXT_FACTS_GENERATED_FILE:-context.ccpf-facts.json}

$CCPF_JSONNET --ext-str CCPF_VERSION=$CCPF_VERSION \
		--ext-str CCPF_HOME=$CCPF_HOME \
		--ext-str CCPF_LOG_LEVEL=${CCPF_LOG_LEVEL:-} \
		--ext-str CCPF_FACTS_FILES=$CCPF_FACTS_FILES \
		--ext-str CCPF_FACTS_DEST_PATH=$DEST_PATH \
		--ext-str GENERATED_ON="`date`" \
		--ext-str CCPF_JSONNET=$CCPF_JSONNET \
		--ext-str JSONNET_PATH=$JSONNET_PATH \
		--ext-str CCPF_JQ=$CCPF_JQ \
		--ext-str projectName=$CCPF_PROJECT_NAME\
		--ext-str projectHome=$CCPF_PROJECT_HOME \
		--ext-str CCPF_MakeFileCustomPreConfigureScriptName=$CCPF_MAKEFILE_CUSTOM_PRE_CONFIGURE_SCRIPT_NAME \
		--ext-str CCPF_MakeFileCustomPostConfigureScriptName=$CCPF_MAKEFILE_CUSTOM_POST_CONFIGURE_SCRIPT_NAME \
		--ext-str CCPF_MakeFileCustomTargetsIncludeFile=$CCPF_MAKEFILE_CUSTOM_INCLUDE_FILE \
		--ext-str currentUserName="`whoami`" \
		--ext-str currentUserId="`id -u`" \
		--ext-str currentUserGroupId="id -g" \
		--ext-str currentUserHome=$HOME \
		--output-file $DEST_PATH/$CONTEXT_FACTS_GENERATED_FILE \
		$CONTEXT_FACTS_JSONNET_TMPL

logInfo "Generated ${YELLOW}$CONTEXT_FACTS_GENERATED_FILE${RESET} from ${GREEN}$CONTEXT_FACTS_JSONNET_TMPL${RESET}"
