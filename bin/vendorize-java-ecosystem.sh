#!/usr/bin/env bash
set -euo pipefail

# Expecting environment variables upon entry:
# * VENDOR_HOME - the path to install vendor'd items into

# TODO: Evaluate and switch to https://github.com/shyiko/jabba (NVM-like tool for JVMs)

export VENDOR_JAVA_INSTALL_VERSION="${VENDOR_JAVA_INSTALL_VERSION:-openjdk-11.0.2}"
export VENDOR_JAVA_ROOT="${VENDOR_JAVA_ROOT:-$VENDOR_HOME/java}"
export VENDOR_JAVA_HOME_ORIG="${VENDOR_JAVA_HOME_ORIG:-$VENDOR_JAVA_ROOT/jdk-11.0.2}"
export VENDOR_JAVA_HOME="${VENDOR_JAVA_HOME_LOCAL:-$VENDOR_JAVA_ROOT/home}"

mkdir -p "$VENDOR_JAVA_ROOT"

echo "Installing Java $VENDOR_JAVA_INSTALL_VERSION in $VENDOR_JAVA_ROOT"
cd "$VENDOR_HOME"
wget "https://download.java.net/java/GA/jdk11/9/GPL/${VENDOR_JAVA_INSTALL_VERSION}_linux-x64_bin.tar.gz"
tar xf "${VENDOR_JAVA_INSTALL_VERSION}_linux-x64_bin.tar.gz" -C "$VENDOR_JAVA_ROOT"

# Take the version number out so all the config variables don't have to change
mv $VENDOR_JAVA_HOME_ORIG $VENDOR_JAVA_HOME

echo "Vendor'd JAVA_HOME is available in $VENDOR_JAVA_HOME"
printf "[*] "
"$VENDOR_JAVA_HOME"/bin/java --version | head -n 1 
