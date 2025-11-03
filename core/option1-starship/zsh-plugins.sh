#!/bin/bash
# ZSH Plugins Module
# Installs zsh-syntax-highlighting and zsh-autosuggestions

set -e

ZSH_CUSTOM="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"
ZSH_PLUGINS_DIR="${HOME}/.zsh"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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
        else
            echo "none"
        fi
    else
        echo "none"
    fi
}

# Check if Oh-My-Zsh is installed
has_oh_my_zsh() {
    [[ -d "${HOME}/.oh-my-zsh" ]]
}

# Install zsh-syntax-highlighting
install_syntax_highlighting() {
    print_step "Installing zsh-syntax-highlighting..."
    
    local pkg_manager=$(detect_package_manager)
    
    case "$pkg_manager" in
        brew)
            if brew list zsh-syntax-highlighting &> /dev/null; then
                print_success "zsh-syntax-highlighting already installed"
            else
                brew install zsh-syntax-highlighting
                print_success "zsh-syntax-highlighting installed via Homebrew"
            fi
            ;;
        apt)
            if dpkg -l | grep -q zsh-syntax-highlighting; then
                print_success "zsh-syntax-highlighting already installed"
            else
                sudo apt install -y zsh-syntax-highlighting
                print_success "zsh-syntax-highlighting installed via apt"
            fi
            ;;
        dnf)
            if rpm -q zsh-syntax-highlighting &> /dev/null; then
                print_success "zsh-syntax-highlighting already installed"
            else
                sudo dnf install -y zsh-syntax-highlighting
                print_success "zsh-syntax-highlighting installed via dnf"
            fi
            ;;
        pacman)
            if pacman -Q zsh-syntax-highlighting &> /dev/null; then
                print_success "zsh-syntax-highlighting already installed"
            else
                sudo pacman -S --noconfirm zsh-syntax-highlighting
                print_success "zsh-syntax-highlighting installed via pacman"
            fi
            ;;
        *)
            # Manual installation
            mkdir -p "$ZSH_PLUGINS_DIR"
            if [[ -d "${ZSH_PLUGINS_DIR}/zsh-syntax-highlighting" ]]; then
                print_success "zsh-syntax-highlighting already installed"
            else
                git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
                    "${ZSH_PLUGINS_DIR}/zsh-syntax-highlighting"
                print_success "zsh-syntax-highlighting installed manually"
            fi
            ;;
    esac
}

# Install zsh-autosuggestions
install_autosuggestions() {
    print_step "Installing zsh-autosuggestions..."
    
    local pkg_manager=$(detect_package_manager)
    
    case "$pkg_manager" in
        brew)
            if brew list zsh-autosuggestions &> /dev/null; then
                print_success "zsh-autosuggestions already installed"
            else
                brew install zsh-autosuggestions
                print_success "zsh-autosuggestions installed via Homebrew"
            fi
            ;;
        apt)
            if dpkg -l | grep -q zsh-autosuggestions; then
                print_success "zsh-autosuggestions already installed"
            else
                sudo apt install -y zsh-autosuggestions
                print_success "zsh-autosuggestions installed via apt"
            fi
            ;;
        dnf)
            if rpm -q zsh-autosuggestions &> /dev/null; then
                print_success "zsh-autosuggestions already installed"
            else
                sudo dnf install -y zsh-autosuggestions
                print_success "zsh-autosuggestions installed via dnf"
            fi
            ;;
        pacman)
            if pacman -Q zsh-autosuggestions &> /dev/null; then
                print_success "zsh-autosuggestions already installed"
            else
                sudo pacman -S --noconfirm zsh-autosuggestions
                print_success "zsh-autosuggestions installed via pacman"
            fi
            ;;
        *)
            # Manual installation
            mkdir -p "$ZSH_PLUGINS_DIR"
            if [[ -d "${ZSH_PLUGINS_DIR}/zsh-autosuggestions" ]]; then
                print_success "zsh-autosuggestions already installed"
            else
                git clone https://github.com/zsh-users/zsh-autosuggestions.git \
                    "${ZSH_PLUGINS_DIR}/zsh-autosuggestions"
                print_success "zsh-autosuggestions installed manually"
            fi
            ;;
    esac
}

# Configure .zshrc
configure_zshrc() {
    local zshrc="${HOME}/.zshrc"
    
    print_step "Configuring .zshrc..."
    
    # Check if already configured
    if grep -q "# Rory Terminal - ZSH Plugins" "$zshrc" 2>/dev/null; then
        print_warning "ZSH plugins already configured"
        return 0
    fi
    
    local pkg_manager=$(detect_package_manager)
    
    cat >> "$zshrc" << 'EOF'

# ================================
# Rory Terminal - ZSH Plugins
# ================================
EOF
    
    # Add syntax highlighting
    case "$pkg_manager" in
        brew)
            echo "source \$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$zshrc"
            ;;
        apt|dnf|pacman)
            echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null || true" >> "$zshrc"
            ;;
        *)
            echo "source ${ZSH_PLUGINS_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$zshrc"
            ;;
    esac
    
    # Add autosuggestions
    case "$pkg_manager" in
        brew)
            echo "source \$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> "$zshrc"
            ;;
        apt|dnf|pacman)
            echo "source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null || true" >> "$zshrc"
            ;;
        *)
            echo "source ${ZSH_PLUGINS_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh" >> "$zshrc"
            ;;
    esac
    
    print_success "ZSH configuration updated"
}

# Main function
main() {
    # Check if zsh is installed
    if ! command -v zsh &> /dev/null; then
        print_error "zsh is not installed"
        exit 1
    fi
    
    install_syntax_highlighting
    install_autosuggestions
    configure_zshrc
    
    print_success "ZSH plugins installation complete!"
    echo ""
    echo "Reload your shell: source ~/.zshrc"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

