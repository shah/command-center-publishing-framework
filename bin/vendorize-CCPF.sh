#!/usr/bin/env bash
set -euo pipefail

# Install CCPF from GitHub and setup local symlinks

GREEN=`tput -Txterm setaf 2`
YELLOW=`tput -Txterm setaf 3`
WHITE=`tput -Txterm setaf 7`
RESET=`tput -Txterm sgr0`

export CCPF_SRC_REPO_URL=https://github.com/shah/command-center-publishing-framework
export CCPF_HOME="${CCPF_HOME:-./vendor/command-center-publishing-framework}"

sudo apt install -qq make git graphviz

if [ -d "$CCPF_HOME" ]; then
    cd "$CCPF_HOME"
    git pull
    echo "CCPF upgraded from $GREEN$CCPF_SRC_REPO_URL$RESET in $YELLOW$CCPF_HOME$RESET"
else
    mkdir -p "$CCPF_HOME"
    git clone "$CCPF_SRC_REPO_URL" "$CCPF_HOME"
    echo "CCPF cloned from $GREEN$CCPF_SRC_REPO_URL$RESET into $YELLOW$CCPF_HOME$RESET"
fi

rm -f Makefile
ln -s "$CCPF_HOME/lib/Makefile" Makefile
echo "Makefile symlinked to $YELLOW$CCPF_HOME/lib/Makefile$RESET"

make doctor