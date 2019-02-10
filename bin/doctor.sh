#!/usr/bin/env bash
set -euo pipefail

# Reviews all CCPF installation requirements and informs user of what's missing
# Only focuses on utilities that aren't included as part of the CCPF/bin

export CCPF_HOME="${CCPF_HOME:-/opt/command-center-publishing-framework}"

GREEN=`tput -Txterm setaf 2`
YELLOW=`tput -Txterm setaf 3`
WHITE=`tput -Txterm setaf 7`
RESET=`tput -Txterm sgr0`

check-exists() {
    if ! [ -x "$(command -v $1)" ]; then
        echo "[ ] $3" >&2
    else
        printf "[*] " 
        echo `eval $2 | head -n 1`
    fi
}

check-exists make "make -version" "Make not installed, install using OS package management"

JQ=$CCPF_HOME/bin/jq
check-exists $JQ "$JQ --version" "jq not found, but it's supposed to be part of the CCPF package"

JSONNET=$CCPF_HOME/bin/jsonnet
check-exists $JSONNET "$JSONNET --version" "Jsonnet not found, but it's supposed to be part of the CCPF package"

HUGO=$CCPF_HOME/bin/hugo
check-exists $HUGO "$HUGO version" "Hugo not found, but it's supposed to be part of the CCPF package"

JAVA=vendor/java/home/bin/java 
check-exists $JAVA "$JAVA --version" "Java not installed at $JAVA, vendor it using vendorize-java-ecosystem.sh"

GO=vendor/gohome/go/bin/go
check-exists $GO "$GO version" "Google Go not installed at $GO, vendor it using vendorize-golang-ecosystem.sh"

MAGE=vendor/gopath/bin/mage
check-exists $MAGE "$MAGE -version" "Mage not installed at $MAGE, vendor it using vendorize-golang-ecosystem.sh"
