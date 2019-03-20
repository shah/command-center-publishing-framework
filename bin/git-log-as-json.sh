#!/usr/bin/env bash
set -euo pipefail

CCPF_HOME="${CCPF_HOME:-./vendor/command-center-publishing-framework}"
CCPF_JQ="${CCPF_JQ:-$CCPF_HOME/bin/jq}"

JSON_FORMAT=$(cat <<-'END_JSON_FORMAT'
{
    "commit": "%H",
    "abbreviated_commit": "%h",
    "tree": "%T",
    "abbreviated_tree": "%t",
    "parent": "%P",
    "abbreviated_parent": "%p",
    "refs": "%D",
    "encoding": "%e",
    "subject": "%s",
    "sanitized_subject_line": "%f",
    "body": "%b",
    "commit_notes": "%N",
    "verification_flag": "%G?",
    "signer": "%GS",
    "signer_key": "%GK",
    "author": {
        "name": "%aN",
        "email": "%aE",
        "date": "%aD"
    },
    "commiter": {
        "name": "%cN",
        "email": "%cE",
        "date": "%cD"
    }
}
END_JSON_FORMAT
)

# Generate Git Log for given directory (or current directory if no path passed in).
# For each log item, convert it to JSON and pass it to jq which will combine the 
# lines into a single array. The output can be saved into a .json file.

git log --pretty=format:"$JSON_FORMAT" $@ | $CCPF_JQ --slurp .
