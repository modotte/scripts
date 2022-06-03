#!/bin/bash

# Description: Change oldemail@gmail.com to new@email.com inside all
# *.cabal files found in current directory.

for i in $(find . -name "*.cabal"); do
    # Make sure to prepend 3 additional spaces for new address.
    # This will ensure indentation consistency.    
    gawk -i inplace '{ sub("oldemail@gmail.com", "   new@email.com", $2) }' "$i"
done
