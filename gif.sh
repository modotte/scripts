#!/bin/bash

# Description: Find issues on github with either labels, language, tags, or keywords.
# Requires bash-tint for colors!

. lib/bash-tint/src/tint

set -ef

REQUIRED_TOOLS=("jq" "curl" "awk")

# Check for missing tools to perform the script reliably.
if [[ ! "$(command -v jq)" ||  ! "$(command -v curl)" || ! "$(command -v awk)" ]]; then
    for i in "${REQUIRED_TOOLS[@]}"; do
        test ! "$(command -v "$i")" && >&2 echo "You are missing the $i tool!"
    done
    >&2 tintf "bold(%s) %s\n" "red(Error:)" "Need jq, curl and awk installed to run!"
    exit 1
fi

API_HEADER="Accept: application/vnd.github.v3+json"
API_LINK="https://api.github.com/search/issues?q=is:issue"
QUERY="$1"
ACCESS_FORBIDDEN=403

show_help () {
    >&2 echo "Usage: $0 <QUERY>"
    >&2 echo "Example: $0 'app+language=haskell+label=bug'"
}


response_code () {
    curl -s -H "$API_HEADER" -i "$API_LINK+$QUERY" | awk 'NR==1 && /^HTTP/ {print $2}'
}

if [[ -z "$QUERY" ]]; then
    show_help
    exit 1
else    
    data="$(curl -s -H "$API_HEADER" "$API_LINK+$QUERY")"
    if [[ "$(response_code)" = "$ACCESS_FORBIDDEN" ]];then
        if [[ "$(echo "$data" | jq '.message')" =~ x ]]; then
            >&2 tintf "bold(%s) %s\n" "red(Error:)" "Github's API rate limit exceeded. Please try again in another hour."
            exit 1
        fi
    fi

    if [[ "$(echo "$data" | jq '.total_count')" = 0 ]];then
        >&2 tintf "bold(%s) %s\n" "red(Error:)" "No results found. Please try again with different query."
        exit 1
    fi
fi

titles=()
html_urls=()
readarray -t titles < <(echo "$data" | jq '.items[].title')
readarray -t html_urls < <(echo "$data" | jq '.items[].html_url')

for i in "${!titles[@]}"; do
    tintf "bold(%s) %s\n" "green(Title:)" "${titles[$i]}"
    tintf "bold(%s) %s\n" "yellow(URL:  )" "${html_urls[$i]}"
done

