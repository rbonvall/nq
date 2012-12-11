#!/bin/bash

declare -a extensions
declare -a patterns

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
    else
        if [ ${#patterns[*]} -gt 0 ]
        then
            patterns+=(-or)
        fi
        patterns+=(-iname "*$arg*")
    fi
done

if [ ${#extensions[*]} -gt 0 ] && [ ${#patterns[*]} -gt 0 ]
then
    echo find "$PWD" "(" ${extensions[*]} ")" -and "(" ${patterns[*]} ")"
    find "$PWD" "(" ${extensions[*]} ")" -and "(" ${patterns[*]} ")"
elif [ ${#extensions[*]} -gt 0 ]
then
    echo find "$PWD" ${extensions[*]}
    find "$PWD" ${extensions[*]}
elif [ ${#patterns[*]} -gt 0 ]
then
    echo find "$PWD" ${patterns[*]}
    find "$PWD" ${patterns[*]}
else
    echo find "$PWD"
    find "$PWD"
fi

