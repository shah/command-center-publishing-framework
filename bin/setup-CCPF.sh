#!/usr/bin/env bash
set -euo pipefail

# Install CCPF from GitHub and setup local symlinks into /etc, /usr/lib, etc.
#
# TODO: make this script smarter by checking if CCPF is already installed and
#       doing a git pull to upgrade instead.
# TODO: only create jsonnet symlink if jsonnet is not already present

export CCPF_SRC_REPO_URL=https://github.com/shah/command-center-publishing-framework
export CCPF_HOME="${CCPF_HOME:-/opt/command-center-publishing-framework}"
export CCPF_BIN_LINKS_PATH="${CCPF_HOME:-/usr/bin}"

sudo apt install -qq make git graphviz

sudo mkdir -p $CCPF_HOME
sudo git clone $CCPF_SRC_REPO_URL $CCPF_HOME
sudo ln -s $CCPF_HOME/bin/ccpf-init $CCPF_BIN_LINKS_PATH/ccpf-init
sudo ln -s $CCPF_HOME/bin/ccpf-make $CCPF_BIN_LINKS_PATH/ccpf-make

echo "CCPF installed in $CCPF_HOME"
echo "ccpf-init, ccpf-make symlinked in $CCPF_BIN_LINKS_PATH"

$CCPF_HOME/bin/doctor.sh
