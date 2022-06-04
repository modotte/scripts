#!/bin/bash

# Description: Find issues on github with either labels, language, tags, or keywords.

set -ef pipefail

if [[ ! $(command -v jq) || ! $(command -v curl) ]];then
    >&2 echo "Need both jq and curl tool installed to run!"
    exit 1
fi
