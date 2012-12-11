#!/bin/bash

declare -a extensions

for arg in $*
do
    first_char="${arg:0:1}"
    if [ "$first_char" = . ]
    then
        ext="${arg#.}"
        if [ ${#extensions[*]} -gt 0 ]
        then
            extensions+=(-or)
        fi
        extensions+=(-iname "*.$ext")
    fi
done

echo find "$PWD" ${extensions[*]}
find "$PWD"  ${extensions[*]}

