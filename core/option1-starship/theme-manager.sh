#!/bin/bash
# Theme Manager
# Switch between different terminal themes

set -e

RORY_TERMINAL_DIR="${HOME}/.config/rory-terminal"
THEMES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../themes" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

print_step() { echo -e "${BLUE}==>${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${CYAN}ℹ${NC} $1"; }

# Available themes
THEMES=("halloween" "christmas" "easter" "hacker" "matrix")

# Theme metadata
declare -A THEME_ICONS=(
    ["halloween"]="🎃"
    ["christmas"]="🎄"
    ["easter"]="🐰"
    ["hacker"]="💻"
    ["matrix"]="🟢"
)

declare -A THEME_COLORS=(
    ["halloween"]="orange/black"
    ["christmas"]="red/green"
    ["easter"]="pastel rainbow"
    ["hacker"]="bright green"
    ["matrix"]="classic green"
)

declare -A THEME_DESCRIPTIONS=(
    ["halloween"]="Spooky Halloween vibes with orange matrix rain"
    ["christmas"]="Festive holiday theme with red and green"
    ["easter"]="Spring celebration with pastel colors"
    ["hacker"]="Cyberpunk green with r0ry.computer branding"
    ["matrix"]="Classic Matrix movie aesthetic"
)

# List available themes
list_themes() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║        Available Terminal Themes         ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
    echo ""
    
    local current_theme=$(get_current_theme)
    
    for theme in "${THEMES[@]}"; do
        local icon="${THEME_ICONS[$theme]}"
        local colors="${THEME_COLORS[$theme]}"
        local desc="${THEME_DESCRIPTIONS[$theme]}"
        local marker=""
        
        if [[ "$theme" == "$current_theme" ]]; then
            marker="${GREEN}★ ACTIVE${NC}"
        fi
        
        echo -e "  ${icon} ${YELLOW}${theme}${NC} ${marker}"
        echo -e "      Colors: ${colors}"
        echo -e "      ${desc}"
        echo ""
    done
}

# Get current theme
get_current_theme() {
    local theme_file="${RORY_TERMINAL_DIR}/current-theme"
    
    if [[ -f "$theme_file" ]]; then
        cat "$theme_file"
    else
        echo "none"
    fi
}

# Set theme
set_theme() {
    local theme="$1"
    
    # Validate theme
    local valid=0
    for t in "${THEMES[@]}"; do
        if [[ "$t" == "$theme" ]]; then
            valid=1
            break
        fi
    done
    
    if [[ $valid -eq 0 ]]; then
        print_error "Invalid theme: $theme"
        echo "Available themes: ${THEMES[*]}"
        return 1
    fi
    
    # Create config directory
    mkdir -p "$RORY_TERMINAL_DIR"
    
    # Save current theme
    echo "$theme" > "${RORY_TERMINAL_DIR}/current-theme"
    
    # Copy Starship config if using Option 1
    if [[ -f "${THEMES_DIR}/starship/${theme}.toml" ]]; then
        cp "${THEMES_DIR}/starship/${theme}.toml" "${HOME}/.config/starship.toml"
        print_success "Starship config updated"
    fi
    
    local icon="${THEME_ICONS[$theme]}"
    print_success "Theme set to: ${icon} ${theme}"
    echo ""
    echo "Changes will take effect in new terminal sessions."
    echo "Or reload your shell: source ~/.bashrc (or ~/.zshrc)"
}

# Run matrix animation for current theme
run_matrix() {
    local theme="${1:-$(get_current_theme)}"
    
    if [[ "$theme" == "none" ]]; then
        print_error "No theme set. Use 'theme-manager set <theme>' first"
        return 1
    fi
    
    local script="${THEMES_DIR}/bash/matrix-${theme}.sh"
    
    if [[ ! -f "$script" ]]; then
        print_error "Theme script not found: $script"
        return 1
    fi
    
    if [[ ! -x "$script" ]]; then
        chmod +x "$script"
    fi
    
    print_info "Running ${theme} matrix animation..."
    "$script" --init
}

# Show theme info
show_info() {
    local theme="${1:-$(get_current_theme)}"
    
    if [[ "$theme" == "none" ]]; then
        print_error "No theme set"
        return 1
    fi
    
    local icon="${THEME_ICONS[$theme]}"
    local colors="${THEME_COLORS[$theme]}"
    local desc="${THEME_DESCRIPTIONS[$theme]}"
    
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           Theme Information              ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${icon} ${YELLOW}${theme}${NC}"
    echo ""
    echo -e "  ${BLUE}Colors:${NC} ${colors}"
    echo -e "  ${BLUE}Description:${NC} ${desc}"
    echo ""
    echo -e "  ${BLUE}Files:${NC}"
    echo -e "    - Bash script: themes/bash/matrix-${theme}.sh"
    echo -e "    - Starship config: themes/starship/${theme}.toml"
    echo ""
}

# Print usage
usage() {
    echo "Theme Manager - Rory Terminal Themes"
    echo ""
    echo "Usage: theme-manager <command> [options]"
    echo ""
    echo "Commands:"
    echo "  list              List all available themes"
    echo "  set <theme>       Set active theme"
    echo "  current           Show current theme"
    echo "  info [theme]      Show theme information"
    echo "  matrix [theme]    Run matrix animation"
    echo ""
    echo "Examples:"
    echo "  theme-manager list"
    echo "  theme-manager set hacker"
    echo "  theme-manager matrix halloween"
    echo ""
}

# Main function
main() {
    local command="${1:-list}"
    local arg="${2}"
    
    case "$command" in
        list)
            list_themes
            ;;
        set)
            if [[ -z "$arg" ]]; then
                print_error "Theme name required"
                echo "Usage: theme-manager set <theme>"
                return 1
            fi
            set_theme "$arg"
            ;;
        current)
            local current=$(get_current_theme)
            if [[ "$current" == "none" ]]; then
                echo "No theme set"
            else
                local icon="${THEME_ICONS[$current]}"
                echo -e "Current theme: ${icon} ${YELLOW}${current}${NC}"
            fi
            ;;
        info)
            show_info "$arg"
            ;;
        matrix)
            run_matrix "$arg"
            ;;
        help|--help|-h)
            usage
            ;;
        *)
            print_error "Unknown command: $command"
            usage
            return 1
            ;;
    esac
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

