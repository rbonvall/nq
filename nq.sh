#!/bin/bash

declare -a extensions
declare -a patterns
declare -a command_line

usage() {
    name=$(basename $0)
    echo "nq --- a simpler find"
    echo "Usage: $name [OPTIONS] [PATTERNS] [FIND-OPTIONS]"
    echo
    echo "OPTIONS can be one of:"
    echo "  -s: show find(1) command instead of executing it."
    echo "  -h: show this message and exit."
    echo
    echo "A PATTERN that starts with a dot is a file extension."
    echo "Otherwise, it is a string to be found in the file name."
    echo "A PATTERN is case-insensitive, unless it has at least"
    echo "one upper case letter in it."
    echo
    echo "FIND-OPTIONS are passed verbatim to find(1)."
    echo "From the first option starting with a dash,"
    echo "if not -s or -h, all options are FIND-OPTIONS."
    echo
    echo "Project site: <https://github.com/rbonvall/nq>"
}

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
        shift
        continue
    elif [ "$1" = -h ]
    then
        usage
        exit
    elif starts_with - "$1"
    then
        break
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
        [ ${#extensions[@]} -gt 0 ] && extensions+=(-or)
        extensions+=($pattern_test "*.$ext")
    else
        [ ${#patterns[@]} -gt 0 ] && patterns+=(-or)
        patterns+=($pattern_test "*$1*")
    fi

    shift
done

command_line=(find "$PWD")

if [ ${#extensions[@]} -gt 0 ] && [ ${#patterns[@]} -gt 0 ]
then
    command_line+=("(" "${extensions[@]}" ")" -and "(" "${patterns[@]}" ")")
elif [ ${#extensions[@]} -gt 0 ]
then
    command_line+=("${extensions[@]}")
elif [ ${#patterns[@]} -gt 0 ]
then
    command_line+=("${patterns[@]}")
fi

command_line+=("$@")

if [ "${show_command_line:-no}" = yes ]
then
    echo "${command_line[@]}" # Buggy!
else
    "${command_line[@]}"
fi
