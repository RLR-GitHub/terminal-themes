#!/bin/bash
# Universal Common Aliases
# Works across all Unix-like systems (macOS, Linux, BSD)

# ================================
# Rory Terminal - Universal Aliases
# ================================

# Modern tool replacements (if installed)
if command -v eza &> /dev/null; then
    alias ls='eza --icons'
    alias ll='eza -l --icons --git'
    alias la='eza -la --icons --git'
    alias lt='eza --tree --icons'
    alias l='eza -l --icons'
else
    # Fallback to standard ls with colors
    if [[ "$OSTYPE" == "darwin"* ]]; then
        alias ls='ls -G'
        alias ll='ls -lG'
        alias la='ls -laG'
    else
        alias ls='ls --color=auto'
        alias ll='ls -l --color=auto'
        alias la='ls -la --color=auto'
    fi
fi

# bat (better cat)
if command -v bat &> /dev/null; then
    alias cat='bat --style=plain --paging=never'
    alias ccat='/bin/cat'  # Original cat
elif command -v batcat &> /dev/null; then
    alias cat='batcat --style=plain --paging=never'
    alias ccat='/bin/cat'
fi

# Git shortcuts
alias g='git'
alias gs='git status'
alias gd='git diff'
alias gc='git commit'
alias gca='git commit -a'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate'
alias gco='git checkout'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Disk usage
alias df='df -h'
alias du='du -h'

# Process management
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias ports='netstat -tulanp 2>/dev/null'

# System info
alias meminfo='free -m -l -t'
alias cpuinfo='lscpu'
alias ports='netstat -tulanp'

# Quick edits
alias bashrc='${EDITOR:-nano} ~/.bashrc && source ~/.bashrc'
alias zshrc='${EDITOR:-nano} ~/.zshrc && source ~/.zshrc'
alias vimrc='${EDITOR:-nano} ~/.vimrc'

# Network
alias myip='curl ifconfig.me'
alias localip='hostname -I 2>/dev/null || ipconfig getifaddr en0'
alias ping='ping -c 5'
alias fastping='ping -c 100 -s.2'

# History
alias h='history'
alias hgrep='history | grep'

# Date and time
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'

# Cleanup
alias cleanup='find . -type f -name "*.DS_Store" -ls -delete'
alias cleantemp='rm -rf /tmp/* 2>/dev/null'

# Make directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract archives
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Quick server
serve() {
    local port="${1:-8000}"
    python3 -m http.server "$port" 2>/dev/null || python -m SimpleHTTPServer "$port"
}

# Weather
weather() {
    curl "wttr.in/${1:-}"
}

# Cheat sheet
cheat() {
    curl "cheat.sh/$1"
}

# Rory Terminal specific
alias theme='theme-manager'
alias matrix-h='RORY_THEME=halloween matrix --init'
alias matrix-c='RORY_THEME=christmas matrix --init'
alias matrix-e='RORY_THEME=easter --init'
alias matrix-m='RORY_THEME=matrix matrix --init'

# Export functions
export -f mkcd extract serve weather cheat 2>/dev/null || true

