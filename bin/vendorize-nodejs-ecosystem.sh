#!/usr/bin/env bash
set -euo pipefail

# Expecting environment variables upon entry:
# * VENDOR_HOME - the path to install vendor'd items into

# TODO evaluate [fnm](https://github.com/Schniz/fnm), Fast and simple Node.js version manager

export NVM_DIR="${NVM_DIR:-$VENDOR_HOME/nvm}" && (
    rm -rf "$NVM_DIR"
    git clone https://github.com/creationix/nvm.git "$NVM_DIR"
    cd "$NVM_DIR"
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"

nvm install --lts node

echo "Vendor'd NVM_DIR is available in $NVM_DIR"
printf "[*] Node Version Manager (NVM) "
nvm --version | head -n 1
printf "[*] NodeJS "
node --version | head -n 1
