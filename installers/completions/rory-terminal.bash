#!/bin/bash
# Bash completion for rory-terminal

_rory_terminal() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # Main commands
    opts="install theme matrix gui help version"
    
    case "${prev}" in
        rory-terminal)
            COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
            return 0
            ;;
        theme)
            local theme_opts="set list current"
            COMPREPLY=( $(compgen -W "${theme_opts}" -- ${cur}) )
            return 0
            ;;
        set|matrix)
            local themes="halloween christmas easter hacker matrix"
            COMPREPLY=( $(compgen -W "${themes}" -- ${cur}) )
            return 0
            ;;
    esac
}

_rory_theme() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    opts="set list current enable-starship disable-starship"
    
    case "${prev}" in
        rory-theme)
            COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
            return 0
            ;;
        set)
            local themes="halloween christmas easter hacker matrix"
            COMPREPLY=( $(compgen -W "${themes}" -- ${cur}) )
            return 0
            ;;
    esac
}

_rory_matrix() {
    local cur themes
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    themes="halloween christmas easter hacker matrix"
    
    COMPREPLY=( $(compgen -W "${themes}" -- ${cur}) )
    return 0
}

complete -F _rory_terminal rory-terminal
complete -F _rory_theme rory-theme
complete -F _rory_matrix rory-matrix
