#!/bin/bash

# Description: Find issues on github with either labels, language, tags, or keywords.

set -ef pipefail

required_tools=("jq" "curl")

# Check for missing tools to perform the script reliably.
if [[ ! $(command -v jq) || ! $(command -v curl) ]]; then
    for i in "${required_tools[@]}"; do
        test ! "$(command -v "$i")" && >&2 echo "You are missing the $i tool!"
    done
    >&2 echo "Need both jq and curl tools installed to run!"
    exit 1
fi

API_HEADER="Accept: application/vnd.github.v3+json"

show_help () {
    >&2 echo "Usage: $0 [--language='haskell'|--label='good first issue']"
    >&2 echo "Example: $0"
}

LANGUAGE="$1"

data=$(curl -s -H "$API_HEADER" "https://api.github.com/search/issues?q=language=$LANGUAGE")

titles=()
html_urls=()
readarray -t titles < <(echo "$data" | jq '.items.[].title')
readarray -t html_urls < <(echo "$data" | jq '.items.[].html_url')

for i in "${!titles[@]}"; do
    echo "Title: ${titles[$i]}"
    echo "URL:   ${html_urls[$i]}"
done

