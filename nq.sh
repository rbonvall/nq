#!/bin/bash

declare -a extensions
declare -a patterns
declare -a command_line

is_lowercase() {
    [ "$1" = "${1,,}" ]
}

starts_with() {
    [ "$1" = "${2:0:${#1}}" ]
}

while (( "$#" ))
do
    if [ "$1" = -s ]
    then
        show_command_line=yes
        continue
    fi

    if is_lowercase "$1"
    then
        pattern_test=-iname
    else
        pattern_test=-name
    fi

    if starts_with . "$1"
    then
        ext="${1#.}"
        [ ${#extensions[*]} -gt 0 ] && extensions+=(-or)
        extensions+=($pattern_test "*.$ext")
    else
        [ ${#patterns[*]} -gt 0 ] && patterns+=(-or)
        patterns+=($pattern_test "*$1*")
    fi

    shift
done

command_line=(find "$PWD")

if [ ${#extensions[*]} -gt 0 ] && [ ${#patterns[*]} -gt 0 ]
then
    command_line+=("(" ${extensions[*]} ")" -and "(" ${patterns[*]} ")")
elif [ ${#extensions[*]} -gt 0 ]
then
    command_line+=(${extensions[*]})
elif [ ${#patterns[*]} -gt 0 ]
then
    command_line+=(${patterns[*]})
fi


if [ "${show_command_line:-no}" = yes ]
then
    echo ${command_line[*]} # Buggy!
else
    ${command_line[*]}
fi
