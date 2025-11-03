#!/bin/bash
# Command Hooks Module
# Pre/post command execution hooks for custom styling

RORY_TERMINAL_DIR="${HOME}/.config/rory-terminal"
HOOKS_ENABLED=true

# Colors (loaded based on active theme)
load_theme_colors() {
    local theme="${1:-hacker}"
    
    case "$theme" in
        halloween)
            PRIMARY_COLOR="\e[38;5;208m"
            SECONDARY_COLOR="\e[38;5;214m"
            ACCENT_COLOR="\e[38;5;220m"
            ;;
        christmas)
            PRIMARY_COLOR="\e[38;5;196m"
            SECONDARY_COLOR="\e[38;5;46m"
            ACCENT_COLOR="\e[38;5;15m"
            ;;
        easter)
            PRIMARY_COLOR="\e[38;5;205m"
            SECONDARY_COLOR="\e[38;5;117m"
            ACCENT_COLOR="\e[38;5;120m"
            ;;
        hacker)
            PRIMARY_COLOR="\e[38;5;46m"
            SECONDARY_COLOR="\e[38;5;82m"
            ACCENT_COLOR="\e[38;5;40m"
            ;;
        matrix)
            PRIMARY_COLOR="\e[92m"
            SECONDARY_COLOR="\e[32m"
            ACCENT_COLOR="\e[32m"
            ;;
        *)
            PRIMARY_COLOR="\e[32m"
            SECONDARY_COLOR="\e[36m"
            ACCENT_COLOR="\e[33m"
            ;;
    esac
    
    RESET="\e[0m"
}

# Get current theme
get_current_theme() {
    if [[ -f "${RORY_TERMINAL_DIR}/current-theme" ]]; then
        cat "${RORY_TERMINAL_DIR}/current-theme"
    else
        echo "hacker"
    fi
}

# Pre-command hook
preexec() {
    if [[ "$HOOKS_ENABLED" != "true" ]]; then
        return
    fi
    
    local cmd="$1"
    local theme=$(get_current_theme)
    load_theme_colors "$theme"
    
    # Display command info
    echo -e "${ACCENT_COLOR}▶ Executing:${RESET} ${PRIMARY_COLOR}${cmd}${RESET}"
}

# Post-command hook
precmd() {
    local exit_code=$?
    
    if [[ "$HOOKS_ENABLED" != "true" ]]; then
        return
    fi
    
    local theme=$(get_current_theme)
    load_theme_colors "$theme"
    
    # Display exit code status
    if [[ $exit_code -eq 0 ]]; then
        echo -e "${SECONDARY_COLOR}✓ Success${RESET} [${exit_code}]"
    else
        echo -e "\e[31m✗ Failed${RESET} [${exit_code}]"
    fi
}

# Command duration tracking
command_timer_start() {
    CMD_START_TIME=$(date +%s%N)
}

command_timer_stop() {
    if [[ -z "$CMD_START_TIME" ]]; then
        return
    fi
    
    local end_time=$(date +%s%N)
    local elapsed=$(( (end_time - CMD_START_TIME) / 1000000 ))  # Convert to milliseconds
    
    local theme=$(get_current_theme)
    load_theme_colors "$theme"
    
    if [[ $elapsed -gt 1000 ]]; then
        # Show duration if > 1 second
        local seconds=$(( elapsed / 1000 ))
        echo -e "${ACCENT_COLOR}⏱  Duration:${RESET} ${seconds}s"
    fi
    
    unset CMD_START_TIME
}

# Git status indicator
show_git_status() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        return
    fi
    
    local theme=$(get_current_theme)
    load_theme_colors "$theme"
    
    local branch=$(git branch --show-current 2>/dev/null)
    local status=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    
    if [[ $status -gt 0 ]]; then
        echo -e "${PRIMARY_COLOR}[${branch}${RESET} ${ACCENT_COLOR}±${status}${PRIMARY_COLOR}]${RESET}"
    else
        echo -e "${PRIMARY_COLOR}[${branch}]${RESET}"
    fi
}

# Setup hooks for bash
setup_bash_hooks() {
    # Use DEBUG trap for preexec
    trap 'preexec "$BASH_COMMAND"; command_timer_start' DEBUG
    
    # Use PROMPT_COMMAND for precmd
    PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }precmd; command_timer_stop"
}

# Setup hooks for zsh
setup_zsh_hooks() {
    autoload -Uz add-zsh-hook
    
    add-zsh-hook preexec preexec
    add-zsh-hook precmd precmd
    add-zsh-hook preexec command_timer_start
    add-zsh-hook precmd command_timer_stop
}

# Auto-setup based on shell
if [[ -n "$BASH_VERSION" ]]; then
    setup_bash_hooks
elif [[ -n "$ZSH_VERSION" ]]; then
    setup_zsh_hooks
fi

# Export functions
export -f preexec precmd load_theme_colors get_current_theme 2>/dev/null

