#!/usr/bin/env bash
set -euo pipefail

# Install CCPF from GitHub and setup local symlinks

export CCPF_SRC_REPO_URL=https://github.com/shah/command-center-publishing-framework
export CCPF_HOME="${CCPF_HOME:-/opt/command-center-publishing-framework}"
export CCPF_BIN_LINKS_PATH="${CCPF_HOME:-/usr/bin}"

sudo apt install -qq make git graphviz

if [ -d "$CCPF_HOME" ]; then
    cd "$CCPF_HOME"
    sudo git pull
    echo "CCPF upgraded in $CCPF_HOME"
else
    sudo mkdir -p "$CCPF_HOME"
    sudo git clone "$CCPF_SRC_REPO_URL" "$CCPF_HOME"
    sudo ln -s "$CCPF_HOME/bin/ccpf-init" "$CCPF_BIN_LINKS_PATH/ccpf-init"
    sudo ln -s "$CCPF_HOME/bin/ccpf-make" "$CCPF_BIN_LINKS_PATH/ccpf-make"
    echo "CCPF installed in $CCPF_HOME"
    echo "ccpf-init, ccpf-make symlinked in $CCPF_BIN_LINKS_PATH"
fi

"$CCPF_HOME"/bin/doctor.sh