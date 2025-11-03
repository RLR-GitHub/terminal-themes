#!/bin/bash
# Output Parser Module
# Parse and re-style command output based on patterns

set -e

# Default theme
THEME="${RORY_THEME:-hacker}"

# Load color codes based on theme
load_colors() {
    case "$THEME" in
        halloween)
            COLOR_PRIMARY="\e[38;5;208m"
            COLOR_SECONDARY="\e[38;5;214m"
            COLOR_ACCENT="\e[38;5;220m"
            COLOR_ERROR="\e[38;5;196m"
            COLOR_SUCCESS="\e[38;5;46m"
            ;;
        christmas)
            COLOR_PRIMARY="\e[38;5;196m"
            COLOR_SECONDARY="\e[38;5;46m"
            COLOR_ACCENT="\e[38;5;15m"
            COLOR_ERROR="\e[38;5;196m"
            COLOR_SUCCESS="\e[38;5;46m"
            ;;
        easter)
            COLOR_PRIMARY="\e[38;5;205m"
            COLOR_SECONDARY="\e[38;5;117m"
            COLOR_ACCENT="\e[38;5;120m"
            COLOR_ERROR="\e[38;5;196m"
            COLOR_SUCCESS="\e[38;5;46m"
            ;;
        hacker|matrix)
            COLOR_PRIMARY="\e[38;5;46m"
            COLOR_SECONDARY="\e[38;5;82m"
            COLOR_ACCENT="\e[38;5;40m"
            COLOR_ERROR="\e[38;5;196m"
            COLOR_SUCCESS="\e[38;5;46m"
            ;;
        *)
            COLOR_PRIMARY="\e[32m"
            COLOR_SECONDARY="\e[36m"
            COLOR_ACCENT="\e[33m"
            COLOR_ERROR="\e[31m"
            COLOR_SUCCESS="\e[32m"
            ;;
    esac
    
    COLOR_RESET="\e[0m"
    COLOR_BOLD="\e[1m"
    COLOR_DIM="\e[2m"
}

# Apply color rules to input
colorize_output() {
    local line="$1"
    
    # Error patterns
    line=$(echo "$line" | sed -E "s/(error|ERROR|Error|failed|FAILED|Failed|fatal|FATAL|Fatal)/${COLOR_BOLD}${COLOR_ERROR}\1${COLOR_RESET}/g")
    
    # Warning patterns
    line=$(echo "$line" | sed -E "s/(warning|WARNING|Warning|warn|WARN|Warn)/${COLOR_BOLD}${COLOR_ACCENT}\1${COLOR_RESET}/g")
    
    # Success patterns
    line=$(echo "$line" | sed -E "s/(success|SUCCESS|Success|ok|OK|passed|PASSED|Passed|done|DONE|Done)/${COLOR_SUCCESS}\1${COLOR_RESET}/g")
    
    # File paths
    line=$(echo "$line" | sed -E "s|(/[a-zA-Z0-9._/-]+)|${COLOR_SECONDARY}\1${COLOR_RESET}|g")
    
    # URLs
    line=$(echo "$line" | sed -E "s|(https?://[^ ]+)|${COLOR_PRIMARY}\1${COLOR_RESET}|g")
    
    # IP addresses
    line=$(echo "$line" | sed -E "s|([0-9]{1,3}\.){3}[0-9]{1,3}|${COLOR_ACCENT}&${COLOR_RESET}|g")
    
    # Numbers
    line=$(echo "$line" | sed -E "s|\b([0-9]+)\b|${COLOR_ACCENT}\1${COLOR_RESET}|g")
    
    # Git-specific patterns
    line=$(echo "$line" | sed -E "s/^(\+.*)$/${COLOR_SUCCESS}\1${COLOR_RESET}/")  # Added lines
    line=$(echo "$line" | sed -E "s/^(-.*)$/${COLOR_ERROR}\1${COLOR_RESET}/")    # Removed lines
    line=$(echo "$line" | sed -E "s/^(M .*)$/${COLOR_ACCENT}\1${COLOR_RESET}/")  # Modified
    
    echo -e "$line"
}

# Parse command-specific output
parse_ls() {
    while IFS= read -r line; do
        # Directories
        line=$(echo "$line" | sed -E "s|([a-zA-Z0-9._-]+)/$|${COLOR_BOLD}${COLOR_PRIMARY}\1/${COLOR_RESET}|g")
        
        # Executables
        line=$(echo "$line" | sed -E "s|([a-zA-Z0-9._-]+)\*$|${COLOR_BOLD}${COLOR_SUCCESS}\1*${COLOR_RESET}|g")
        
        # Hidden files
        line=$(echo "$line" | sed -E "s|(\.[a-zA-Z0-9._-]+)|${COLOR_DIM}${COLOR_SECONDARY}\1${COLOR_RESET}|g")
        
        echo -e "$line"
    done
}

parse_git_status() {
    while IFS= read -r line; do
        # Modified files
        line=$(echo "$line" | sed -E "s/^( M .*)$/${COLOR_ACCENT}\1${COLOR_RESET}/")
        
        # New files
        line=$(echo "$line" | sed -E "s/^(\?\? .*)$/${COLOR_PRIMARY}\1${COLOR_RESET}/")
        
        # Deleted files
        line=$(echo "$line" | sed -E "s/^( D .*)$/${COLOR_ERROR}\1${COLOR_RESET}/")
        
        # Staged files
        line=$(echo "$line" | sed -E "s/^(A  .*)$/${COLOR_SUCCESS}\1${COLOR_RESET}/")
        
        echo -e "$line"
    done
}

parse_git_log() {
    while IFS= read -r line; do
        # Commit hash
        line=$(echo "$line" | sed -E "s/^(commit [a-f0-9]+)$/${COLOR_BOLD}${COLOR_PRIMARY}\1${COLOR_RESET}/")
        
        # Author
        line=$(echo "$line" | sed -E "s/^(Author:.*)$/${COLOR_SECONDARY}\1${COLOR_RESET}/")
        
        # Date
        line=$(echo "$line" | sed -E "s/^(Date:.*)$/${COLOR_ACCENT}\1${COLOR_RESET}/")
        
        echo -e "$line"
    done
}

parse_grep() {
    local pattern="$1"
    
    while IFS= read -r line; do
        # Highlight matched pattern
        line=$(echo "$line" | sed -E "s/(${pattern})/${COLOR_BOLD}${COLOR_PRIMARY}\1${COLOR_RESET}/g")
        
        echo -e "$line"
    done
}

# Main function
main() {
    local command="${1:-generic}"
    shift
    
    load_colors
    
    case "$command" in
        ls)
            parse_ls
            ;;
        git-status)
            parse_git_status
            ;;
        git-log)
            parse_git_log
            ;;
        grep)
            parse_grep "$@"
            ;;
        generic|*)
            while IFS= read -r line; do
                colorize_output "$line"
            done
            ;;
    esac
}

# Run if executed directly or used as pipe
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

