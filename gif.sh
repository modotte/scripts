#!/bin/bash

# Description: Find issues on github with either labels, language, tags, or keywords.

set -ef pipefail

if [[ ! $(command -v jq) || ! $(command -v curl) ]];then
    >&2 echo "Need both jq and curl tool installed to run!"
    exit 1
fi

API_HEADER="Accept: application/vnd.github.v3+json"

LANGUAGE="$1"

data=$(curl -s -H "$API_HEADER" "https://api.github.com/search/issues?q=language=$LANGUAGE")

titles=()
html_urls=()
readarray -t titles < <(echo "$data" | jq '. | .items | .[].title')
readarray -t html_urls < <(echo "$data" | jq '. | .items | .[].html_url')

for i in "${!titles[@]}"; do
    echo "Title: ${titles[$i]}"
    echo "URL:   ${html_urls[$i]}"
done

