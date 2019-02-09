#!/usr/bin/env bash
set -euo pipefail

# Expecting environment variables upon entry:
# * VENDOR_HOME - the path to install vendor'd items into

export VENDOR_GOLANG_INSTALL_VERSION="${VENDOR_GOLANG_INSTALL_VERSION:-go1.11.5}"
export VENDOR_GOLANG_HOME="${VENDOR_GOLANG_HOME:-$VENDOR_HOME/gohome}"
export VENDOR_GOLANG_BIN="${VENDOR_GOLANG_BIN:-$VENDOR_GOLANG_HOME/go/bin}"
export VENDOR_GOLANG_ECOSYSTEM_HOME="${VENDOR_GOLANG_ECOSYSTEM_HOME:-$VENDOR_HOME/gopath}"

mkdir -p "$VENDOR_GOLANG_HOME"
mkdir -p "$VENDOR_GOLANG_ECOSYSTEM_HOME"

echo "Installing Google Go $VENDOR_GOLANG_INSTALL_VERSION in $VENDOR_GOLANG_HOME"
cd "$VENDOR_HOME"
wget "https://dl.google.com/go/$VENDOR_GOLANG_INSTALL_VERSION.linux-amd64.tar.gz"
tar xf "$VENDOR_GOLANG_INSTALL_VERSION.linux-amd64.tar.gz" -C gohome

export GOHOME="$VENDOR_GOLANG_HOME"
export GOPATH="$VENDOR_GOLANG_ECOSYSTEM_HOME"
"$VENDOR_GOLANG_BIN"/go get -u -d github.com/magefile/mage
cd "$VENDOR_GOLANG_ECOSYSTEM_HOME"/src/github.com/magefile/mage
PATH="$VENDOR_GOLANG_BIN:$PATH" "$VENDOR_GOLANG_BIN"/go run bootstrap.go

echo "Vendor'd GOHOME is available in $VENDOR_GOLANG_BIN"
echo "Vendor'd GOPATH is available in $VENDOR_GOLANG_ECOSYSTEM_HOME"
printf "[ ] "
"$VENDOR_GOLANG_BIN"/go version
printf "[ ] "
"$VENDOR_GOLANG_ECOSYSTEM_HOME"/bin/mage -version | head -n 1
