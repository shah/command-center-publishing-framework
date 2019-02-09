#!/usr/bin/env bash
set -euo pipefail

# Expecting environment variables upon entry:
# * VENDOR_HOME - the path to install vendor'd items into

export VENDOR_JAVA_INSTALL_VERSION="${VENDOR_JAVA_INSTALL_VERSION:-openjdk-11.0.2}"
export VENDOR_JAVA_HOME="${VENDOR_JAVA_HOME:-$VENDOR_HOME/java}"
export VENDOR_JAVA_BIN="${VENDOR_JAVA_BIN:-$VENDOR_JAVA_HOME/jdk-11.0.2/bin}"

mkdir -p "$VENDOR_JAVA_HOME"

echo "Installing Java $VENDOR_JAVA_INSTALL_VERSION in $VENDOR_JAVA_HOME"
cd "$VENDOR_HOME"
wget "https://download.java.net/java/GA/jdk11/9/GPL/${VENDOR_JAVA_INSTALL_VERSION}_linux-x64_bin.tar.gz"
tar xf "${VENDOR_JAVA_INSTALL_VERSION}_linux-x64_bin.tar.gz" -C "$VENDOR_JAVA_HOME"

echo "Vendor'd JAVA_HOME is available in $VENDOR_JAVA_HOME"
printf "[ ] "
"$VENDOR_JAVA_BIN"/java --version | head -n 1 
