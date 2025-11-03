#!/bin/bash
# Modern Tools Module
# Installs eza (ls replacement), bat (cat replacement), and delta (git diff)

set -e

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

# Install eza (modern ls replacement)
install_eza() {
    print_step "Installing eza..."
    
    if command -v eza &> /dev/null; then
        print_success "eza already installed"
        return 0
    fi
    
    local pkg_manager=$(detect_package_manager)
    
    case "$pkg_manager" in
        brew)
            brew install eza
            ;;
        apt)
            # eza requires newer repos, try cargo fallback
            if command -v cargo &> /dev/null; then
                cargo install eza
            else
                print_warning "eza not available in apt, installing via binary..."
                local arch=$(uname -m)
                local eza_version="0.17.0"
                wget "https://github.com/eza-community/eza/releases/download/v${eza_version}/eza_${arch}-unknown-linux-gnu.tar.gz" -O /tmp/eza.tar.gz
                sudo tar -xzf /tmp/eza.tar.gz -C /usr/local/bin
                rm /tmp/eza.tar.gz
            fi
            ;;
        dnf)
            sudo dnf install -y eza
            ;;
        pacman)
            sudo pacman -S --noconfirm eza
            ;;
        *)
            print_error "No package manager found. Please install eza manually."
            return 1
            ;;
    esac
    
    if command -v eza &> /dev/null; then
        print_success "eza installed successfully"
    else
        print_warning "eza installation may have failed"
    fi
}

# Install bat (modern cat replacement)
install_bat() {
    print_step "Installing bat..."
    
    if command -v bat &> /dev/null || command -v batcat &> /dev/null; then
        print_success "bat already installed"
        return 0
    fi
    
    local pkg_manager=$(detect_package_manager)
    
    case "$pkg_manager" in
        brew)
            brew install bat
            ;;
        apt)
            sudo apt install -y bat
            # On Debian/Ubuntu, bat is installed as batcat
            if ! command -v bat &> /dev/null && command -v batcat &> /dev/null; then
                mkdir -p ~/.local/bin
                ln -sf /usr/bin/batcat ~/.local/bin/bat
            fi
            ;;
        dnf)
            sudo dnf install -y bat
            ;;
        pacman)
            sudo pacman -S --noconfirm bat
            ;;
        *)
            print_error "No package manager found. Please install bat manually."
            return 1
            ;;
    esac
    
    if command -v bat &> /dev/null || command -v batcat &> /dev/null; then
        print_success "bat installed successfully"
    else
        print_warning "bat installation may have failed"
    fi
}

# Install delta (git diff tool)
install_delta() {
    print_step "Installing delta..."
    
    if command -v delta &> /dev/null; then
        print_success "delta already installed"
        return 0
    fi
    
    local pkg_manager=$(detect_package_manager)
    
    case "$pkg_manager" in
        brew)
            brew install git-delta
            ;;
        apt)
            # Try to install from GitHub releases
            local arch=$(uname -m)
            local delta_version="0.16.5"
            if [[ "$arch" == "x86_64" ]]; then
                wget "https://github.com/dandavison/delta/releases/download/${delta_version}/git-delta_${delta_version}_amd64.deb" -O /tmp/delta.deb
                sudo dpkg -i /tmp/delta.deb
                rm /tmp/delta.deb
            else
                print_warning "Delta binary not available for $arch, skipping..."
                return 0
            fi
            ;;
        dnf)
            sudo dnf install -y git-delta
            ;;
        pacman)
            sudo pacman -S --noconfirm git-delta
            ;;
        *)
            print_error "No package manager found. Please install delta manually."
            return 1
            ;;
    esac
    
    if command -v delta &> /dev/null; then
        print_success "delta installed successfully"
    else
        print_warning "delta installation may have failed"
    fi
}

# Configure shell aliases
configure_aliases() {
    local shell_type="${1:-bash}"
    local config_file=""
    
    case "$shell_type" in
        bash)
            config_file="${HOME}/.bashrc"
            ;;
        zsh)
            config_file="${HOME}/.zshrc"
            ;;
        *)
            print_error "Unsupported shell: $shell_type"
            return 1
            ;;
    esac
    
    print_step "Configuring aliases in $config_file..."
    
    # Check if already configured
    if grep -q "# Rory Terminal - Modern Tools" "$config_file" 2>/dev/null; then
        print_warning "Aliases already configured"
        return 0
    fi
    
    cat >> "$config_file" << 'EOF'

# ================================
# Rory Terminal - Modern Tools
# ================================

# eza aliases (if installed)
if command -v eza &> /dev/null; then
    alias ls='eza --icons'
    alias ll='eza -l --icons --git'
    alias la='eza -la --icons --git'
    alias lt='eza --tree --icons'
    alias l='eza -l --icons'
fi

# bat aliases (if installed)
if command -v bat &> /dev/null; then
    alias cat='bat --style=plain --paging=never'
    alias ccat='/bin/cat'  # original cat
elif command -v batcat &> /dev/null; then
    alias cat='batcat --style=plain --paging=never'
    alias ccat='/bin/cat'
fi

# Git with delta (if installed)
if command -v delta &> /dev/null; then
    export GIT_PAGER='delta'
fi
EOF
    
    print_success "Aliases configured"
}

# Configure git for delta
configure_git_delta() {
    if ! command -v delta &> /dev/null; then
        return 0
    fi
    
    print_step "Configuring git to use delta..."
    
    git config --global core.pager "delta"
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate "true"
    git config --global delta.light "false"
    git config --global delta.side-by-side "true"
    git config --global merge.conflictstyle "diff3"
    git config --global diff.colorMoved "default"
    
    print_success "Git configured for delta"
}

# Main function
main() {
    local install_all="${1:-yes}"
    
    install_eza || true
    install_bat || true
    install_delta || true
    
    local shell_type="${SHELL##*/}"
    configure_aliases "$shell_type"
    configure_git_delta
    
    print_success "Modern tools installation complete!"
    echo ""
    echo "Installed tools:"
    command -v eza &> /dev/null && echo "  - eza (ls alternative)"
    command -v bat &> /dev/null && echo "  - bat (cat alternative)"
    command -v delta &> /dev/null && echo "  - delta (git diff)"
    echo ""
    echo "Reload your shell: source ~/.${shell_type}rc"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

