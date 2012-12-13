#!/bin/bash

declare -a extensions
declare -a patterns
declare -a command_line

usage() {
    name=$(basename $0)
    cat <<-EOF
	nq --- a simpler find
	Usage: $name [OPTIONS] [PATTERNS] [FIND-OPTIONS]

	OPTIONS can be one of:
	  -s: show find(1) command instead of executing it.
	  -h: show this message and exit.

	A PATTERN that starts with a dot is a file extension.
	Otherwise, it is a string to be found in the file name.
	A PATTERN is case-insensitive, unless it has at least
	one upper case letter in it.
	If a PATTERN ends with a slash, only directories are shown.

	FIND-OPTIONS are passed verbatim to find(1).
	From the first option starting with a dash,
	if not -s or -h, all options are FIND-OPTIONS.

	Project site: <https://github.com/rbonvall/nq>
	EOF
}

is_lowercase() {
    # $ is_lowercase foo && echo yes || echo no
    # yes
    # $ is_lowercase Foo && echo yes || echo no
    # no

    [ "$1" = "${1,,}" ]
}

starts_with() {
    # $ starts_with let letter && echo yes || echo no
    # yes
    # $ starts_with get setter && echo yes || echo no
    # no

    [ "$1" = "${2:0:${#1}}" ]
}

ends_with() {
    # $ ends_with use house && echo yes || echo no
    # yes
    # $ ends_with use home && echo yes || echo no
    # no

    [ "$1" = "${2: -${#1}}" ]
}

while (( "$#" ))
do
    if [ "$1" = -s ]
    then
        show_command_line=yes
        shift
        continue
    elif [ "$1" = -h ] || [ "$1" = --help ]
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
        if ends_with / "$1"
        then
            patterns+=($pattern_test "*${1%/}*" -type d)
        else
            patterns+=($pattern_test "*$1*")
        fi
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
