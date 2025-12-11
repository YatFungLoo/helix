#!/usr/bin/env bash
# Bash completion script for Helix editor

_hx() {
    local cur prev languages
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD - 1]}"

    if ! type "mapfile" > /dev/null; then # Source - https://stackoverflow.com/a/7522866
        MAPFILE_AVAIL=true
    else
        MAPFILE_AVAIL=false
    fi

    case "$prev" in
    -g | --grammar)
        if [ "MAPFILE_AVAIL" = true ] ; then
            mapfile -t COMPREPLY < <(compgen -W 'fetch build' -- "$cur")
        else
            COMPREPLY=($(compgen -W 'fetch build' -- "$cur"))
        fi
        return 0
        ;;
    --health)
        languages=$(hx --health all-languages | tail -n '+2' | awk '{print $1}' | sed 's/\x1b\[[0-9;]*m//g')
        if [ "MAPFILE_AVAIL" = true ] ; then
            mapfile -t COMPREPLY < <(compgen -W """clipboard languages all-languages all $languages""" -- "$cur")
        else
            COMPREPLY($(compgen -W """clipboard languages all-languages all $languages""" -- "$cur"))
        fi
        return 0
        ;;
    esac

    case "$2" in
    -*)
        if [ "MAPFILE_AVAIL" = true ] ; then
            mapfile -t COMPREPLY < <(compgen -W "-h --help --tutor -V --version -v -vv -vvv --health -g --grammar --vsplit --hsplit -c --config --log" -- """$2""")
        else
            COMPREPLY($(compgen -W "-h --help --tutor -V --version -v -vv -vvv --health -g --grammar --vsplit --hsplit -c --config --log" -- """$2"""))
        fi
        return 0
        ;;
    *)
        if [ "MAPFILE_AVAIL" = true ] ; then
            mapfile -t COMPREPLY < <(compgen -fd -- """$2""")
        else
            COMPREPLY($(compgen -fd -- """$2"""))
        fi
        return 0
        ;;
    esac
} && complete -o filenames -F _hx hx
