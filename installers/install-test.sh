#!/bin/bash
# Test version of install.sh that supports local installation for CI/CD

set -e

VERSION="3.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
INSTALL_DIR="${HOME}/.local/share/rory-terminal"
CONFIG_DIR="${HOME}/.config/rory-terminal"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_step() { echo -e "${BLUE}==>${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_info() { echo -e "${CYAN}ℹ${NC} $1"; }

# Test mode installation
print_step "Running test installation..."

# Create directories
mkdir -p "$INSTALL_DIR"
mkdir -p "$CONFIG_DIR"
mkdir -p "${HOME}/.local/bin"

# Copy files from local repository
print_step "Copying files from local repository..."
if [ -d "$ROOT_DIR/core" ]; then
    cp -r "$ROOT_DIR/core" "$INSTALL_DIR/"
    print_success "Copied core files"
fi

if [ -d "$ROOT_DIR/themes" ]; then
    cp -r "$ROOT_DIR/themes" "$INSTALL_DIR/"
    print_success "Copied theme files"
fi

if [ -d "$ROOT_DIR/config" ]; then
    cp -r "$ROOT_DIR/config" "$INSTALL_DIR/"
    print_success "Copied config files"
fi

# Create dummy launcher
cat > "${HOME}/.local/bin/rory-terminal" << 'EOF'
#!/bin/bash
echo "Rory Terminal (test installation)"
echo "Version: 3.0.0"
echo "Installation directory: $HOME/.local/share/rory-terminal"
exit 0
EOF
chmod +x "${HOME}/.local/bin/rory-terminal"

# Save install info
cat > "${CONFIG_DIR}/install-info.txt" << EOF
Installation Date: $(date)
Version: $VERSION
Install Mode: test
Directory: $INSTALL_DIR
EOF

print_success "Test installation completed successfully"
print_info "Installation directory: $INSTALL_DIR"
print_info "Configuration directory: $CONFIG_DIR"
