#!/bin/bash
# Starship Integration Module
# Installs and configures Starship prompt for cross-platform terminal theming

set -e

RORY_TERMINAL_DIR="${HOME}/.config/rory-terminal"
STARSHIP_CONFIG_DIR="${HOME}/.config"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_step() { echo -e "${BLUE}==>${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "unknown"
    fi
}

# Detect package manager
detect_package_manager() {
    local os=$(detect_os)
    
    if [[ "$os" == "macos" ]]; then
        if command -v brew &> /dev/null; then
            echo "brew"
        else
            echo "none"
        fi
    elif [[ "$os" == "linux" ]]; then
        if command -v apt &> /dev/null; then
            echo "apt"
        elif command -v dnf &> /dev/null; then
            echo "dnf"
        elif command -v pacman &> /dev/null; then
            echo "pacman"
        elif command -v zypper &> /dev/null; then
            echo "zypper"
        else
            echo "none"
        fi
    else
        echo "none"
    fi
}

# Install Starship
install_starship() {
    print_step "Checking Starship installation..."
    
    if command -v starship &> /dev/null; then
        print_success "Starship already installed: $(starship --version | head -1)"
        return 0
    fi
    
    print_step "Installing Starship..."
    local pkg_manager=$(detect_package_manager)
    
    case "$pkg_manager" in
        brew)
            brew install starship
            ;;
        apt)
            curl -sS https://starship.rs/install.sh | sh -s -- -y
            ;;
        dnf)
            sudo dnf install -y starship
            ;;
        pacman)
            sudo pacman -S --noconfirm starship
            ;;
        *)
            # Fallback to official installer
            curl -sS https://starship.rs/install.sh | sh -s -- -y
            ;;
    esac
    
    if command -v starship &> /dev/null; then
        print_success "Starship installed successfully"
    else
        print_error "Failed to install Starship"
        return 1
    fi
}

# Configure shell for Starship
configure_shell() {
    local shell_type="$1"
    local config_file=""
    
    case "$shell_type" in
        bash)
            config_file="${HOME}/.bashrc"
            ;;
        zsh)
            config_file="${HOME}/.zshrc"
            ;;
        fish)
            config_file="${HOME}/.config/fish/config.fish"
            ;;
        *)
            print_error "Unsupported shell: $shell_type"
            return 1
            ;;
    esac
    
    print_step "Configuring $shell_type for Starship..."
    
    # Check if already configured
    if grep -q "starship init" "$config_file" 2>/dev/null; then
        print_warning "Starship already configured in $config_file"
        return 0
    fi
    
    # Add Starship initialization based on shell
    if [[ "$shell_type" == "fish" ]]; then
        echo -e "\n# Rory Terminal - Starship Prompt\nstarship init fish | source" >> "$config_file"
    else
        cat >> "$config_file" << 'EOF'

# ================================
# Rory Terminal - Starship Prompt
# ================================
eval "$(starship init ${SHELL##*/})"
EOF
    fi
    
    print_success "Shell configured for Starship"
}

# Set active theme
set_theme() {
    local theme="$1"
    local theme_file="${RORY_TERMINAL_DIR}/current-theme"
    
    # Ensure directory exists
    mkdir -p "$RORY_TERMINAL_DIR"
    
    # Save current theme
    echo "$theme" > "$theme_file"
    
    # Copy theme config to Starship config location
    local source_theme="${RORY_TERMINAL_DIR}/../../themes/starship/${theme}.toml"
    local target_config="${STARSHIP_CONFIG_DIR}/starship.toml"
    
    if [[ -f "$source_theme" ]]; then
        cp "$source_theme" "$target_config"
        print_success "Theme set to: $theme"
    else
        print_error "Theme file not found: $source_theme"
        return 1
    fi
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

# Main function
main() {
    local action="${1:-install}"
    local theme="${2:-hacker}"
    
    case "$action" in
        install)
            install_starship
            local shell_type="${SHELL##*/}"
            configure_shell "$shell_type"
            set_theme "$theme"
            print_success "Starship integration complete!"
            echo ""
            echo "Reload your shell: source ~/.${shell_type}rc"
            ;;
        set-theme)
            set_theme "$theme"
            ;;
        get-theme)
            get_current_theme
            ;;
        *)
            echo "Usage: $0 {install|set-theme|get-theme} [theme-name]"
            echo "Themes: halloween, christmas, easter, hacker, matrix"
            exit 1
            ;;
    esac
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

