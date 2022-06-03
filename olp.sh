#!/bin/bash

# Description: Prepend exactly one line *with a newline*,
# at the top of a file with the given string.
# Remark: Do note it is an in-place operation.

set -ef -o pipefail

STRING="$1"
FILE="$2"

show_help () {
    >&2 echo "Usage: $0 'string to prepend' <FILENAME>"
    >&2 echo "Example: $0 '#!/bin/bash' my_script.sh"
    >&2 echo
    >&2 printf "%s\n" "To write multple lines, append with \n."
    >&2 printf "%s\n" "Example: $0 '#!/bin/bash\n\necho \"Hello world\"' my_script.sh"
}

if [[ -z "$STRING" || -z "$FILE" ]];then
    show_help
    exit 1
fi

echo -e "$STRING\n$(cat "$FILE")" > "$FILE"
