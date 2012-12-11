#!/bin/bash

declare -a extensions
declare -a patterns

for arg
do
    if [ "$arg" = "${arg,,}" ] # $arg is lower case
    then
        pattern_test=-iname
    else
        pattern_test=-name
    fi

    first_char="${arg:0:1}"
    if [ "$first_char" = . ]
    then
        ext="${arg#.}"
        [ ${#extensions[*]} -gt 0 ] && extensions+=(-or)
        extensions+=($pattern_test "*.$ext")
    else
        [ ${#patterns[*]} -gt 0 ] && patterns+=(-or)
        patterns+=($pattern_test "*$arg*")
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

