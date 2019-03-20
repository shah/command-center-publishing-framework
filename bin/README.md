# Command Center Publishing Framework (CCPF) Binaries

The **Command Center Publishing Framework** (**CCPF**) philosophy is to vendor
all dependencies to whatever extent possible. Unless a package is _very_ common
(such as make or git), our approach is to vendor every dependency.

Anytime you want to check dependencies, run:

    $CCPF_HOME/bin/doctor.sh

The reason vendoring is important is:

* We want determistically reproducible builds
* We want fully portable builds
* We want containers to be easy to build and deploy without ops personnel
  having to figure out all the dependencies

## Simple single-executable binaries vendor'ing approach

For simple single-executable binaries, include the versioned binary for Ubuntu
18.04 or above with the version number in the file name (e.g. 
**jsonnet-v.0.11.2**) but include symlink to the non-versioned filename. This
is important because we want versoined binaries to be clear. But, symlinks
should be included for developer convenience (adding to config files, paths,
etc.). When binaries need to be updated, we can add newer versions without
removing older versions (we can just switch the symlink to the latest 
version).

Sample $CCPF_HOME/bin layout, note the symlinks:

    drwxrwxr-x 2 snshah snshah     4096 Feb 10 10:30 .
    drwxrwxr-x 6 snshah snshah     4096 Feb 10 10:18 ..
    -rwxrwxr-x 1 snshah snshah      184 Feb 10 10:18 ccpf-make
    -rwxrwxr-x 1 snshah snshah     2005 Feb 10 10:27 doctor.sh
    -rwxrwxr-x 1 snshah snshah     4285 Feb 10 10:18 generate-ccpf-facts.sh
    lrwxrwxrwx 1 snshah snshah       11 Feb 10 10:18 hugo -> ./hugo-0.54
    -rwxrwxr-x 1 snshah snshah 21632224 Feb 10 10:18 hugo-0.54
    lrwxrwxrwx 1 snshah snshah        8 Feb 10 10:18 jq -> ./jq-1.6
    -rwxrwxr-x 1 snshah snshah  3953824 Feb 10 10:18 jq-1.6
    lrwxrwxrwx 1 snshah snshah       17 Feb 10 10:18 jsonnet -> ./jsonnet-v0.11.2
    -rwxrwxr-x 1 snshah snshah 10914624 Feb 10 10:18 jsonnet-v0.11.2
    -rw-rw-r-- 1 snshah snshah  7393779 Feb 10 10:18 plantuml.1.2019.0.jar
    lrwxrwxrwx 1 snshah snshah       23 Feb 10 10:18 plantuml.jar -> ./plantuml.1.2019.0.jar
    -rw-rw-r-- 1 snshah snshah        0 Feb 10 10:30 README.md
    -rwxrwxr-x 1 snshah snshah      826 Feb 10 10:18 vendorize-CCPF.sh
    -rwxrwxr-x 1 snshah snshah     1318 Feb 10 10:18 vendorize-golang-ecosystem.sh
    -rwxrwxr-x 1 snshah snshah     1017 Feb 10 10:18 vendorize-java-ecosystem.sh

## Complex packages vendor'ing approach

For complex dependencies like Java, .NET, Google Go, etc. we use a project-specific 
"vendor" directory approach. See these scripts as examples:

* vendorize-golang-ecosystem.sh
* vendorize-java-ecosystem.sh  

Sample $CCPF_PROJECT_HOME/vendor layout, note the easy to use structure:

    vendor
    ├── command-center-publishing-framework
    ├── gohome
    │   ├── go
    │   ├── gocache
    │   └── tmp
    ├── gopath
    │   ├── bin
    │   └── src
    └── java
        └── home
