#!/bin/bash
# Build macOS .pkg installer for Rory Terminal Themes
# Creates a platform-native installer for macOS systems

set -euo pipefail
trap 'echo "❌ Build failed at line $LINENO"; exit 1' ERR

VERSION="${1:-3.0.0}"
PACKAGE_NAME="RoryTerminal"
IDENTIFIER="com.rory.terminal-themes"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
BUILD_DIR="${ROOT_DIR}/build/macos"
DIST_DIR="${ROOT_DIR}/dist/macos"
PKG_ROOT="${BUILD_DIR}/pkgroot"
SCRIPTS_DIR="${BUILD_DIR}/scripts"

print_step() { 
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "==> $1"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}
print_success() { echo "✅ $1"; }
print_error() { echo "❌ $1"; exit 1; }

print_step "Building macOS .pkg installer for Rory Terminal v${VERSION}"

# Clean previous build
if [[ -d "$BUILD_DIR" ]]; then
    rm -rf "$BUILD_DIR"
fi

# Create build directories
mkdir -p "$PKG_ROOT/usr/local/bin"
mkdir -p "$PKG_ROOT/usr/local/share/rory-terminal"
mkdir -p "$PKG_ROOT/usr/local/share/rory-terminal/themes"
mkdir -p "$PKG_ROOT/usr/local/etc/rory-terminal"
mkdir -p "$SCRIPTS_DIR"

print_success "Build directories created"

# Copy files
print_step "Copying application files..."

# Core modules
cp -r "${ROOT_DIR}/core" "$PKG_ROOT/usr/local/share/rory-terminal/"
cp -r "${ROOT_DIR}/themes" "$PKG_ROOT/usr/local/share/rory-terminal/"
if [[ -d "${ROOT_DIR}/config" ]]; then
    cp -r "${ROOT_DIR}/config" "$PKG_ROOT/usr/local/share/rory-terminal/"
fi
cp -r "${ROOT_DIR}/installers/desktop" "$PKG_ROOT/usr/local/share/rory-terminal/"

# Make scripts executable
find "$PKG_ROOT/usr/local/share/rory-terminal" -name "*.sh" -exec chmod +x {} \;

# Create symlinks for easy access
ln -s "../share/rory-terminal/core/option1-starship/theme-manager.sh" \
    "$PKG_ROOT/usr/local/bin/rory-theme"
ln -s "../share/rory-terminal/themes/bash/matrix-hacker.sh" \
    "$PKG_ROOT/usr/local/bin/rory-matrix"

print_success "Files copied"

# Create postinstall script
print_step "Creating post-install script..."

cat > "${SCRIPTS_DIR}/postinstall" << 'EOF'
#!/bin/bash
# Post-installation script

USER_HOME=$(eval echo ~${SUDO_USER})
SHELL_TYPE="${SHELL##*/}"

echo "Configuring Rory Terminal for user: ${SUDO_USER}"

# Detect shell
if [[ -n "$ZSH_VERSION" ]] || [[ "$SHELL_TYPE" == "zsh" ]]; then
    CONFIG_FILE="${USER_HOME}/.zshrc"
elif [[ -n "$BASH_VERSION" ]] || [[ "$SHELL_TYPE" == "bash" ]]; then
    CONFIG_FILE="${USER_HOME}/.bashrc"
else
    CONFIG_FILE="${USER_HOME}/.bashrc"
fi

# Add to PATH if not already present
if ! grep -q "/usr/local/bin/rory" "$CONFIG_FILE" 2>/dev/null; then
    echo "" >> "$CONFIG_FILE"
    echo "# Rory Terminal - Added by installer" >> "$CONFIG_FILE"
    echo 'export PATH="/usr/local/bin:$PATH"' >> "$CONFIG_FILE"
    echo "alias theme='rory-theme'" >> "$CONFIG_FILE"
    echo "alias matrix='rory-matrix --init'" >> "$CONFIG_FILE"
fi

# Create config directory
mkdir -p "${USER_HOME}/.config/rory-terminal"
chown -R ${SUDO_USER}:staff "${USER_HOME}/.config/rory-terminal"

echo "Installation complete!"
echo "Run 'rory-theme' to manage themes"
echo "Run 'rory-matrix' for Matrix animation"

exit 0
EOF

chmod +x "${SCRIPTS_DIR}/postinstall"

print_success "Post-install script created"

# Create uninstall script
print_step "Creating uninstall script..."

cat > "$PKG_ROOT/usr/local/bin/rory-terminal-uninstall" << 'EOF'
#!/bin/bash
# Uninstall Rory Terminal

echo "Uninstalling Rory Terminal..."

# Remove files
sudo rm -rf /usr/local/share/rory-terminal
sudo rm -rf /usr/local/etc/rory-terminal
sudo rm -f /usr/local/bin/rory-theme
sudo rm -f /usr/local/bin/rory-matrix
sudo rm -f /usr/local/bin/rory-terminal-uninstall

# Remove from shell configs
for config in ~/.bashrc ~/.zshrc; do
    if [[ -f "$config" ]]; then
        sed -i.bak '/# Rory Terminal/d' "$config"
        sed -i.bak '/rory-/d' "$config"
    fi
done

echo "Uninstall complete!"
EOF

chmod +x "$PKG_ROOT/usr/local/bin/rory-terminal-uninstall"

print_success "Uninstall script created"

# Build component package
print_step "Building component package..."

pkgbuild --root "$PKG_ROOT" \
         --identifier "$IDENTIFIER" \
         --version "$VERSION" \
         --scripts "$SCRIPTS_DIR" \
         --install-location "/" \
         "${BUILD_DIR}/${PACKAGE_NAME}-component.pkg"

print_success "Component package built"

# Create distribution XML
print_step "Creating distribution XML..."

cat > "${BUILD_DIR}/distribution.xml" << EOF
<?xml version="1.0" encoding="utf-8"?>
<installer-gui-script minSpecVersion="2">
    <title>Rory Terminal Themes</title>
    <organization>com.rory</organization>
    <domains enable_localSystem="true"/>
    <options customize="never" require-scripts="false" hostArchitectures="x86_64,arm64"/>
    
    <welcome file="welcome.html" mime-type="text/html"/>
    <license file="license.txt"/>
    <conclusion file="conclusion.html" mime-type="text/html"/>
    
    <pkg-ref id="$IDENTIFIER">
        <bundle-version>
            <bundle id="$IDENTIFIER" CFBundleVersion="$VERSION" path="${PACKAGE_NAME}-component.pkg"/>
        </bundle-version>
    </pkg-ref>
    
    <choices-outline>
        <line choice="default">
            <line choice="$IDENTIFIER"/>
        </line>
    </choices-outline>
    
    <choice id="default"/>
    <choice id="$IDENTIFIER" visible="false">
        <pkg-ref id="$IDENTIFIER"/>
    </choice>
</installer-gui-script>
EOF

# Create welcome page
cat > "${BUILD_DIR}/welcome.html" << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Welcome</title></head>
<body>
<h1>Welcome to Rory Terminal Themes</h1>
<p>This installer will install Rory Terminal Themes v3.0 on your Mac.</p>
<p>Features:</p>
<ul>
<li>5 unique Matrix-style terminal themes</li>
<li>Cross-platform compatibility</li>
<li>Starship prompt integration</li>
<li>Modern terminal tools</li>
</ul>
</body>
</html>
EOF

# Copy license
cp "${ROOT_DIR}/LICENSE" "${BUILD_DIR}/license.txt" || echo "MIT License" > "${BUILD_DIR}/license.txt"

# Create conclusion page
cat > "${BUILD_DIR}/conclusion.html" << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Installation Complete</title></head>
<body>
<h1>Installation Complete!</h1>
<p>Rory Terminal Themes has been successfully installed.</p>
<p><b>Next steps:</b></p>
<ol>
<li>Open a new terminal window</li>
<li>Run: <code>rory-theme list</code> to see available themes</li>
<li>Run: <code>rory-theme set &lt;theme&gt;</code> to change themes</li>
<li>Run: <code>rory-matrix</code> for a Matrix animation</li>
</ol>
<p>Documentation: <a href="https://github.com/RLR-GitHub/terminal-themes">github.com/RLR-GitHub/terminal-themes</a></p>
</body>
</html>
EOF

print_success "Distribution resources created"

# Build product package
print_step "Building product package..."

productbuild --distribution "${BUILD_DIR}/distribution.xml" \
             --package-path "$BUILD_DIR" \
             --resources "$BUILD_DIR" \
             "${BUILD_DIR}/${PACKAGE_NAME}-${VERSION}.pkg"

print_success "Product package built"

# Output location
print_step "Package created: ${BUILD_DIR}/${PACKAGE_NAME}-${VERSION}.pkg"

# Optional: Sign package (requires developer certificate)
if [[ -n "${SIGNING_IDENTITY}" ]]; then
    print_step "Signing package..."
    productsign --sign "$SIGNING_IDENTITY" \
                "${BUILD_DIR}/${PACKAGE_NAME}-${VERSION}.pkg" \
                "${BUILD_DIR}/${PACKAGE_NAME}-${VERSION}-signed.pkg"
    print_success "Package signed"
fi

print_success "macOS installer build complete!"
echo ""
echo "Install with: sudo installer -pkg ${BUILD_DIR}/${PACKAGE_NAME}-${VERSION}.pkg -target /"

