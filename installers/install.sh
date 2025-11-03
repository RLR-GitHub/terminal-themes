#!/bin/bash
# Rory Terminal Themes - Universal Installer
# Supports macOS, Linux, multiple shells, and installation options

set -e

VERSION="3.0.0"
REPO_URL="https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main"
INSTALL_DIR="${HOME}/.local/share/rory-terminal"
CONFIG_DIR="${HOME}/.config/rory-terminal"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Print functions
print_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║     ██████╗  ██████╗ ██████╗ ██╗   ██╗                   ║
║     ██╔══██╗██╔═══██╗██╔══██╗╚██╗ ██╔╝                   ║
║     ██████╔╝██║   ██║██████╔╝ ╚████╔╝                    ║
║     ██╔══██╗██║   ██║██╔══██╗  ╚██╔╝                     ║
║     ██║  ██║╚██████╔╝██║  ██║   ██║                      ║
║     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝                      ║
║                                                           ║
║           Terminal Themes Collection v3.0                 ║
║        Universal Cross-Platform Installation              ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

print_step() { echo -e "${BLUE}==>${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_info() { echo -e "${CYAN}ℹ${NC} $1"; }

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "${ID:-linux}"
    else
        echo "linux"
    fi
}

# Detect distribution for Linux
detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "$ID"
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
    else
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
    fi
}

# Detect shell
detect_shell() {
    local current_shell="${SHELL##*/}"
    
    case "$current_shell" in
        bash|zsh|fish)
            echo "$current_shell"
            ;;
        *)
            # Try to detect from environment
            if [[ -n "$ZSH_VERSION" ]]; then
                echo "zsh"
            elif [[ -n "$BASH_VERSION" ]]; then
                echo "bash"
            else
                echo "bash"  # Default fallback
            fi
            ;;
    esac
}

# Get shell config file
get_shell_config() {
    local shell_type="$1"
    
    case "$shell_type" in
        bash)
            echo "${HOME}/.bashrc"
            ;;
        zsh)
            echo "${HOME}/.zshrc"
            ;;
        fish)
            echo "${HOME}/.config/fish/config.fish"
            ;;
        *)
            echo "${HOME}/.bashrc"
            ;;
    esac
}

# Check requirements
check_requirements() {
    print_step "Checking system requirements..."
    
    local os=$(detect_os)
    local pkg_manager=$(detect_package_manager)
    local shell_type=$(detect_shell)
    
    print_info "OS: $os"
    print_info "Package Manager: $pkg_manager"
    print_info "Shell: $shell_type"
    
    # Check bash version if using bash
    if [[ "$shell_type" == "bash" ]]; then
        local bash_version="${BASH_VERSION%%[.]*}"
        if [[ "$bash_version" -lt 4 ]]; then
            print_warning "Bash 4.0+ recommended. Current: $BASH_VERSION"
        else
            print_success "Bash version OK"
        fi
    fi
    
    # Check for curl or wget
    if command -v curl &> /dev/null; then
        print_success "curl found"
    elif command -v wget &> /dev/null; then
        print_success "wget found"
    else
        print_error "curl or wget required for installation"
        exit 1
    fi
    
    # Check for git
    if command -v git &> /dev/null; then
        print_success "git found"
    else
        print_warning "git not found (optional, but recommended)"
    fi
    
    echo ""
}

# Select installation option
select_option() {
    echo ""
    echo -e "${MAGENTA}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║        Choose Installation Option            ║${NC}"
    echo -e "${MAGENTA}╚══════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${YELLOW}1)${NC} ${GREEN}Simple (Recommended)${NC}"
    echo -e "     Starship prompt + modern tools (eza, bat, delta)"
    echo -e "     ✓ Easy to set up"
    echo -e "     ✓ Works with existing shell"
    echo -e "     ✓ Cross-platform"
    echo ""
    echo -e "  ${YELLOW}2)${NC} ${CYAN}Advanced${NC}"
    echo -e "     PTY shim with custom color injection"
    echo -e "     ✓ Full output control"
    echo -e "     ✓ Command-specific styling"
    echo -e "     ✓ Requires compilation"
    echo ""
    echo -e "  ${YELLOW}3)${NC} ${BLUE}Matrix Only${NC}"
    echo -e "     Just the Matrix rain animations"
    echo -e "     ✓ Lightweight"
    echo -e "     ✓ No dependencies"
    echo ""
    
    read -p "Enter choice [1-3] (default: 1): " option
    option="${option:-1}"
    
    case "$option" in
        1)
            INSTALL_OPTION="starship"
            print_success "Selected: Starship (Simple)"
            ;;
        2)
            INSTALL_OPTION="pty-shim"
            print_success "Selected: PTY Shim (Advanced)"
            ;;
        3)
            INSTALL_OPTION="matrix-only"
            print_success "Selected: Matrix Only"
            ;;
        *)
            print_error "Invalid option. Defaulting to Simple."
            INSTALL_OPTION="starship"
            ;;
    esac
}

# Select theme
select_theme() {
    echo ""
    echo -e "${MAGENTA}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║             Choose Your Theme                 ║${NC}"
    echo -e "${MAGENTA}╚══════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${YELLOW}1)${NC} 🎃 ${YELLOW}Halloween${NC}    - Spooky orange/black"
    echo -e "  ${YELLOW}2)${NC} 🎄 ${GREEN}Christmas${NC}    - Festive red/green"
    echo -e "  ${YELLOW}3)${NC} 🐰 ${MAGENTA}Easter${NC}       - Pastel rainbow"
    echo -e "  ${YELLOW}4)${NC} 💻 ${CYAN}Hacker${NC}       - Bright green cyber"
    echo -e "  ${YELLOW}5)${NC} 🟢 ${GREEN}Matrix${NC}       - Classic green"
    echo ""
    
    read -p "Enter choice [1-5] (default: 4): " choice
    choice="${choice:-4}"
    
    case "$choice" in
        1) THEME="halloween"; THEME_NAME="Halloween" ;;
        2) THEME="christmas"; THEME_NAME="Christmas" ;;
        3) THEME="easter"; THEME_NAME="Easter" ;;
        4) THEME="hacker"; THEME_NAME="Hacker" ;;
        5) THEME="matrix"; THEME_NAME="Matrix" ;;
        *) print_error "Invalid choice. Defaulting to Hacker."; THEME="hacker"; THEME_NAME="Hacker" ;;
    esac
    
    print_success "Selected: $THEME_NAME theme"
}

# Create directories
create_directories() {
    print_step "Creating directories..."
    
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$CONFIG_DIR"
    mkdir -p "${HOME}/.local/bin"
    
    print_success "Directories created"
}

# Install Option 1: Starship
install_starship_option() {
    print_step "Installing Starship + Modern Tools..."
    
    # Download and run starship integration
    if command -v curl &> /dev/null; then
        curl -fsSL "${REPO_URL}/core/option1-starship/starship-integration.sh" -o "${INSTALL_DIR}/starship-integration.sh"
        curl -fsSL "${REPO_URL}/core/option1-starship/modern-tools.sh" -o "${INSTALL_DIR}/modern-tools.sh"
        curl -fsSL "${REPO_URL}/core/option1-starship/theme-manager.sh" -o "${HOME}/.local/bin/theme-manager"
    else
        wget -q "${REPO_URL}/core/option1-starship/starship-integration.sh" -O "${INSTALL_DIR}/starship-integration.sh"
        wget -q "${REPO_URL}/core/option1-starship/modern-tools.sh" -O "${INSTALL_DIR}/modern-tools.sh"
        wget -q "${REPO_URL}/core/option1-starship/theme-manager.sh" -O "${HOME}/.local/bin/theme-manager"
    fi
    
    chmod +x "${INSTALL_DIR}"/*.sh
    chmod +x "${HOME}/.local/bin/theme-manager"
    
    # Run installations
    bash "${INSTALL_DIR}/starship-integration.sh" install "$THEME" || print_warning "Starship installation encountered issues"
    bash "${INSTALL_DIR}/modern-tools.sh" || print_warning "Modern tools installation encountered issues"
    
    # Install ZSH plugins if using zsh
    local shell_type=$(detect_shell)
    if [[ "$shell_type" == "zsh" ]]; then
        if command -v curl &> /dev/null; then
            curl -fsSL "${REPO_URL}/core/option1-starship/zsh-plugins.sh" -o "${INSTALL_DIR}/zsh-plugins.sh"
        else
            wget -q "${REPO_URL}/core/option1-starship/zsh-plugins.sh" -O "${INSTALL_DIR}/zsh-plugins.sh"
        fi
        chmod +x "${INSTALL_DIR}/zsh-plugins.sh"
        bash "${INSTALL_DIR}/zsh-plugins.sh" || print_warning "ZSH plugins installation encountered issues"
    fi
    
    print_success "Starship option installed"
}

# Install Option 2: PTY Shim
install_pty_shim_option() {
    print_step "Installing PTY Shim (Advanced)..."
    
    # Check for build tools
    if ! command -v gcc &> /dev/null && ! command -v clang &> /dev/null; then
        print_error "GCC or Clang required for compilation"
        print_info "Install build tools:"
        
        local os=$(detect_os)
        case "$os" in
            macos)
                echo "  xcode-select --install"
                ;;
            ubuntu|debian)
                echo "  sudo apt install build-essential"
                ;;
            fedora|rhel|centos)
                echo "  sudo dnf groupinstall 'Development Tools'"
                ;;
            arch)
                echo "  sudo pacman -S base-devel"
                ;;
        esac
        
        return 1
    fi
    
    # Download PTY shim files
    local files=("pty-wrapper.c" "color-rules.json" "command-hooks.sh" "output-parser.sh" "Makefile")
    for file in "${files[@]}"; do
        if command -v curl &> /dev/null; then
            curl -fsSL "${REPO_URL}/core/option2-pty-shim/${file}" -o "${INSTALL_DIR}/${file}"
        else
            wget -q "${REPO_URL}/core/option2-pty-shim/${file}" -O "${INSTALL_DIR}/${file}"
        fi
    done
    
    # Compile
    cd "$INSTALL_DIR"
    make || {
        print_error "Compilation failed"
        return 1
    }
    
    # Install
    cp pty-wrapper "${HOME}/.local/bin/"
    cp command-hooks.sh "${HOME}/.local/bin/rory-terminal-hooks"
    cp output-parser.sh "${HOME}/.local/bin/rory-terminal-parser"
    cp color-rules.json "$CONFIG_DIR/"
    
    chmod +x "${HOME}/.local/bin/"rory-terminal-*
    
    print_success "PTY shim installed"
}

# Install Option 3: Matrix Only
install_matrix_only() {
    print_step "Installing Matrix animations..."
    
    local shell_type=$(detect_shell)
    local script_name="matrix-${THEME}.sh"
    
    # Download bash script
    if command -v curl &> /dev/null; then
        curl -fsSL "${REPO_URL}/themes/bash/${script_name}" -o "${HOME}/.local/bin/matrix"
    else
        wget -q "${REPO_URL}/themes/bash/${script_name}" -O "${HOME}/.local/bin/matrix"
    fi
    
    chmod +x "${HOME}/.local/bin/matrix"
    
    print_success "Matrix animation installed"
}

# Configure shell
configure_shell() {
    local shell_type=$(detect_shell)
    local config_file=$(get_shell_config "$shell_type")
    
    print_step "Configuring $shell_type..."
    
    # Backup config
    if [[ -f "$config_file" ]]; then
        cp "$config_file" "${config_file}.backup.$(date +%Y%m%d_%H%M%S)"
        print_info "Backup created: ${config_file}.backup.*"
    fi
    
    # Check if already configured
    if grep -q "# Rory Terminal" "$config_file" 2>/dev/null; then
        print_warning "Shell already configured. Skipping..."
        return 0
    fi
    
    # Add PATH if needed
    if ! grep -q "${HOME}/.local/bin" "$config_file" 2>/dev/null; then
        echo "" >> "$config_file"
        echo '# Add local bin to PATH' >> "$config_file"
        echo 'export PATH="${HOME}/.local/bin:${PATH}"' >> "$config_file"
    fi
    
    # Add theme configuration
    cat >> "$config_file" << 'EOF'

# ================================
# Rory Terminal Themes
# ================================
export RORY_THEME="${RORY_THEME:-hacker}"
EOF
    
    if [[ "$INSTALL_OPTION" == "pty-shim" ]]; then
        echo 'source "${HOME}/.local/bin/rory-terminal-hooks"' >> "$config_file"
    fi
    
    print_success "Shell configured"
}

# Save installation info
save_install_info() {
    cat > "${CONFIG_DIR}/install-info.txt" << EOF
Installation Date: $(date)
Version: $VERSION
Install Option: $INSTALL_OPTION
Theme: $THEME
OS: $(detect_os)
Shell: $(detect_shell)
EOF
    
    echo "$THEME" > "${CONFIG_DIR}/current-theme"
}

# Print completion message
print_completion() {
    local shell_type=$(detect_shell)
    local config_file=$(get_shell_config "$shell_type")
    
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                       ║${NC}"
    echo -e "${GREEN}║         Installation Complete! 🎉                    ║${NC}"
    echo -e "${GREEN}║                                                       ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Next Steps:${NC}"
    echo ""
    echo -e "  1. Reload your shell:"
    echo -e "     ${YELLOW}source $config_file${NC}"
    echo ""
    echo -e "  2. Or start a new terminal session"
    echo ""
    
    if [[ "$INSTALL_OPTION" == "starship" ]]; then
        echo -e "${CYAN}Available Commands:${NC}"
        echo ""
        echo -e "  ${YELLOW}theme-manager${NC}        - Manage themes"
        echo -e "  ${YELLOW}theme-manager set${NC}    - Change theme"
        echo -e "  ${YELLOW}theme-manager list${NC}   - List all themes"
        if command -v eza &> /dev/null; then
            echo -e "  ${YELLOW}ls${NC}                   - Enhanced with eza"
        fi
        if command -v bat &> /dev/null; then
            echo -e "  ${YELLOW}cat${NC}                  - Enhanced with bat"
        fi
    elif [[ "$INSTALL_OPTION" == "matrix-only" ]]; then
        echo -e "${CYAN}Available Commands:${NC}"
        echo ""
        echo -e "  ${YELLOW}matrix${NC}               - Run Matrix animation"
        echo -e "  ${YELLOW}matrix --init${NC}        - Brief 5-second intro"
    fi
    
    echo ""
    echo -e "${CYAN}Documentation:${NC}"
    echo -e "  https://github.com/RLR-GitHub/terminal-themes"
    echo ""
    echo -e "${GREEN}Enjoy your cyberpunk terminal! 🚀${NC}"
    echo ""
}

# Main installation flow
main() {
    print_banner
    check_requirements
    select_option
    select_theme
    create_directories
    
    case "$INSTALL_OPTION" in
        starship)
            install_starship_option
            ;;
        pty-shim)
            install_pty_shim_option
            ;;
        matrix-only)
            install_matrix_only
            ;;
    esac
    
    configure_shell
    save_install_info
    print_completion
}

# Run main
main "$@"
