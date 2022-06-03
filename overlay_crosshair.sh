#!/bin/bash

# overlay_crosshair.sh - A simple 'crosshair' overlay on your screen.
# Description: Sometimes, you want an index point at the very center
# of your screen. This script will draw red letter `X` as the
# crosshair.
# See osd_cat --help for more details.

# Example for 1366x768 resolution
# echo 'X' | osd_cat --align center \
#                    --delay -1 \
#                    --font '-*-*-*-*-*-*-20-*-*-*-*-*-*-*' \
#                    --indent 0 \
#                    --offset=375


if [[ ! $(command -v osd_cat) ]];then
    >&2 echo "osd_cat doesn't exist!"
    >&2 echo "Need osd_cat to function."
    exit 1
fi

# 1024x576 resolution size
echo 'X' | osd_cat --align center \
                   --delay -1 \
                   --font '-*-*-*-*-*-*-10-*-*-*-*-*-*-*' \
                   --indent -171 \
                   --offset=285
