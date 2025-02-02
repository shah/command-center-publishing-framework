#!/usr/bin/env bash
set -euo pipefail

# Reviews all CCPF installation requirements and informs user of what's missing
# Only focuses on utilities that aren't included as part of the CCPF/bin

export CCPF_HOME="${CCPF_HOME:-./vendor/command-center-publishing-framework}"

GREEN=`tput -Txterm setaf 2`
YELLOW=`tput -Txterm setaf 3`
WHITE=`tput -Txterm setaf 7`
RESET=`tput -Txterm sgr0`

check-binary-exists() {
    if ! [ -x "$(command -v $1)" ]; then
        echo "[ ] $YELLOW$3$RESET" >&2
    else
        printf "[$GREEN*$RESET] $GREEN" 
        echo `eval $2 | head -n 1`
        printf "$RESET"
    fi
}

check-java-jar-exists() {
    if ! [ -f "$1" ]; then
        echo "[ ] $YELLOW$3$RESET" >&2
    else
        printf "[$GREEN*$RESET] $GREEN" 
        echo `eval vendor/java/home/bin/java -jar $2 | head -n 1`
        printf "$RESET"
    fi
}

check-binary-exists make "make -version" "Make not installed, install using OS package management"

check-binary-exists docker "docker --version" "Docker not installed, install it if you need it"
check-binary-exists docker-compose "docker-compose --version" "Docker Compose not installed, install it if you need it"

JQ=$CCPF_HOME/bin/jq
check-binary-exists $JQ "$JQ --version" "jq not found, but it's supposed to be part of the CCPF package"

JSONNET=$CCPF_HOME/bin/jsonnet
check-binary-exists $JSONNET "$JSONNET --version" "Jsonnet not found, but it's supposed to be part of the CCPF package"

SHELLCHECK=$CCPF_HOME/bin/shellcheck
check-binary-exists $SHELLCHECK "$SHELLCHECK --version" "Shellcheck not found, but it's supposed to be part of the CCPF package"

OSQUERY=osquery
check-binary-exists ${OSQUERY}d "${OSQUERY}d --version" "osQuery Daemon not found, install using their own package"
check-binary-exists ${OSQUERY}i "${OSQUERY}i --version" "osQuery CLI not found, install using their own package"

GO=vendor/gohome/go/bin/go
check-binary-exists $GO "$GO version" "Google Go not installed at $GO, vendor it using vendorize-golang-ecosystem.sh"

HUGO=$CCPF_HOME/bin/hugo
check-binary-exists $HUGO "$HUGO version" "Hugo not found, but it's supposed to be part of the CCPF package"

JAVA=vendor/java/home/bin/java 
check-binary-exists $JAVA "$JAVA --version" "Java not installed at $JAVA, vendor it using vendorize-java-ecosystem.sh"

if [ -x "$(command -v $JAVA)" ]; then
    PLANTUML="$CCPF_HOME/bin/plantuml.jar" 
    check-java-jar-exists $PLANTUML "$PLANTUML -version" "PlantUML not installed, but it's supposed to be part of the CCPF package"
fi    

export NODE_VERSION=default
NVM_EXEC="vendor/nvm/nvm-exec"
if [ -x "$(command -v $NVM_EXEC)" ]; then
    printf "[${GREEN}*${RESET}] ${GREEN}Node Package Manager "
    $NVM_EXEC npm --version | head -n 1
    printf "$RESET"
    printf "[${GREEN}*${RESET}] ${GREEN}NodeJS "
    $NVM_EXEC node --version | head -n 1
    printf "$RESET"
else
    echo "[ ] ${GREEN}NodeJS not installed, vendor it using vendorize-nodejs-ecosystem.sh${RESET}"
fi    

OAUTH2_PROXY=vendor/oauth2_proxy
check-binary-exists $OAUTH2_PROXY "$OAUTH2_PROXY --version" "oAuth2 Proxy not installed, vendor it using vendorize-oauth2_proxy.sh"

GRAPHVIZ_DOT=dot 
check-binary-exists $GRAPHVIZ_DOT "$GRAPHVIZ_DOT -V" "Graphviz Dot not installed, install using OS package management"