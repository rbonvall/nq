#!/bin/bash

declare -a extensions
declare -a patterns
declare -a command_line

for arg
do
    if [ "$arg" = -s ]
    then
        show_command_line=yes
        continue
    fi

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
