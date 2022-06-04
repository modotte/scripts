#!/bin/bash

# Description: Find issues on github with either labels, language, tags, or keywords.

set -ef

required_tools=("jq" "curl")

# Check for missing tools to perform the script reliably.
if [[ ! "$(command -v jq)" ||  ! "$(command -v curl)" ]]; then
    for i in "${required_tools[@]}"; do
        test ! "$(command -v "$i")" && >&2 echo "You are missing the $i tool!"
    done
    >&2 echo "Need both jq and curl tools installed to run!"
    exit 1
fi

API_HEADER="Accept: application/vnd.github.v3+json"

show_help () {
    >&2 echo "Usage: $0 <QUERY>"
    >&2 echo "Example: $0 'app+language=haskell+label=bug'"
}

QUERY="$1"

if [[ -z "$QUERY" ]]; then
    show_help
    exit 1
else    
    data="$(curl -s -H "$API_HEADER" "https://api.github.com/search/issues?q=$QUERY")"

    if [[ "$(curl -s -H "$API_HEADER" -i "https://api.github.com/search/issues?q=$QUERY" | awk 'NR==1 && /^HTTP/ {print $2}')" = 403 ]];then
        _x="^API rate limit exceeded"
        if [[ "$(echo "$data" | jq '.message')" =~ x ]]; then
            >&2 echo "Github's API rate limit exceeded. Please try again in another hour."
            exit 1
        fi
    fi

    if [[ "$(echo "$data" | jq '.total_count')" = 0 ]];then
        >&2 echo "No results found. Please try again with different query."
        exit 1
    fi
fi

titles=()
html_urls=()
readarray -t titles < <(echo "$data" | jq '.items[].title')
readarray -t html_urls < <(echo "$data" | jq '.items[].html_url')

for i in "${!titles[@]}"; do
    echo "Title: ${titles[$i]}"
    echo "URL:   ${html_urls[$i]}"
done

