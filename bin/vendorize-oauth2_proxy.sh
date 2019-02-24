#!/usr/bin/env bash
set -euo pipefail

# Expecting environment variables upon entry:
# * VENDOR_HOME - the path to install vendor'd items into

export VENDOR_OA2PROXY_VERSION="${VENDOR_OA2PROXY_VERSION:-v2.2}"
export VENDOR_OA2PROXY_PACKAGE="${VENDOR_OA2PROXY_PACKAGE:-oauth2_proxy-2.2.0.linux-amd64.go1.8.1.tar.gz}"
export VENDOR_OA2PROXY_BIN="${VENDOR_OA2PROXY_BIN:-$VENDOR_HOME/oauth2_proxy}"

mkdir -p "$VENDOR_OA2PROXY_BIN"

echo "Installing oauth2_proxy $VENDOR_OA2PROXY_VERSION in $VENDOR_HOME"
cd "$VENDOR_HOME"
wget "https://github.com/bitly/oauth2_proxy/releases/download/${VENDOR_OA2PROXY_VERSION}/${VENDOR_OA2PROXY_PACKAGE}"
tar -xf "$VENDOR_OA2PROXY_PACKAGE" -C $VENDOR_HOME --strip-components=1

echo "Vendor'd oauth2_proxy is available as $VENDOR_OA2PROXY_BIN"
printf "[*] "
"$VENDOR_OA2PROXY_BIN" --version | head -n 1
