#!/bin/bash
# Build Debian/Ubuntu .deb package for Rory Terminal Themes
# This script creates a platform-specific installer for Debian/Ubuntu systems

set -euo pipefail
trap 'echo "❌ Build failed at line $LINENO"; exit 1' ERR

VERSION="${1:-3.0.0}"
PACKAGE_NAME="rory-terminal"
ARCH="all"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
BUILD_DIR="${ROOT_DIR}/build/deb"
DIST_DIR="${ROOT_DIR}/dist/linux"
DEB_ROOT="${BUILD_DIR}/${PACKAGE_NAME}_${VERSION}_${ARCH}"

print_step() { 
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "==> $1"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}
print_success() { echo "✅ $1"; }
print_error() { echo "❌ $1"; exit 1; }

print_step "Building Debian package for Rory Terminal v${VERSION}"

# Clean previous build
if [[ -d "$BUILD_DIR" ]]; then
    rm -rf "$BUILD_DIR"
fi

# Create package structure
mkdir -p "${DEB_ROOT}/DEBIAN"
mkdir -p "${DEB_ROOT}/opt/rory-terminal"
mkdir -p "${DEB_ROOT}/usr/local/bin"
mkdir -p "${DEB_ROOT}/usr/share/applications"
mkdir -p "${DEB_ROOT}/usr/share/doc/${PACKAGE_NAME}"

print_success "Package structure created"

# Copy application files
print_step "Copying files..."

cp -r "${ROOT_DIR}/core" "${DEB_ROOT}/opt/rory-terminal/"
cp -r "${ROOT_DIR}/themes" "${DEB_ROOT}/opt/rory-terminal/"
cp -r "${ROOT_DIR}/config" "${DEB_ROOT}/opt/rory-terminal/"
cp -r "${ROOT_DIR}/installers/desktop" "${DEB_ROOT}/opt/rory-terminal/"
cp "${ROOT_DIR}/LICENSE" "${DEB_ROOT}/usr/share/doc/${PACKAGE_NAME}/"
cp "${ROOT_DIR}/README.md" "${DEB_ROOT}/usr/share/doc/${PACKAGE_NAME}/"

# Make scripts executable
find "${DEB_ROOT}/opt/rory-terminal" -name "*.sh" -exec chmod +x {} \;

print_success "Files copied"

# Create symlinks
print_step "Creating symlinks..."

cat > "${DEB_ROOT}/usr/local/bin/rory-theme" << 'EOF'
#!/bin/bash
exec /opt/rory-terminal/core/option1-starship/theme-manager.sh "$@"
EOF

cat > "${DEB_ROOT}/usr/local/bin/rory-matrix" << 'EOF'
#!/bin/bash
exec /opt/rory-terminal/themes/bash/matrix-hacker.sh "$@"
EOF

chmod +x "${DEB_ROOT}/usr/local/bin/"*

print_success "Symlinks created"

# Create control file
print_step "Creating control file..."

cat > "${DEB_ROOT}/DEBIAN/control" << EOF
Package: ${PACKAGE_NAME}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: ${ARCH}
Depends: bash (>= 4.0), coreutils
Recommends: git, curl
Suggests: starship, zsh
Maintainer: Roderick Lawrence Renwick <rodericklrenwick@gmail.com>
Homepage: https://github.com/RLR-GitHub/terminal-themes
Description: Cyberpunk terminal themes collection
 Rory Terminal Themes provides Matrix-style terminal animations
 and modern terminal customization with Starship integration.
 .
 Features include:
  - 5 unique themes (Halloween, Christmas, Easter, Hacker, Matrix)
  - Cross-platform compatibility
  - Starship prompt integration
  - Modern terminal tools support
EOF

print_success "Control file created"

# Create postinst script
print_step "Creating postinst script..."

cat > "${DEB_ROOT}/DEBIAN/postinst" << 'EOF'
#!/bin/bash
set -e

# Add to PATH message
echo "Rory Terminal installed to /opt/rory-terminal"
echo "Run: rory-theme --help to get started"
echo "Run: rory-matrix --init for Matrix animation"

exit 0
EOF

chmod +x "${DEB_ROOT}/DEBIAN/postinst"

print_success "Postinst script created"

# Create prerm script
print_step "Creating prerm script..."

cat > "${DEB_ROOT}/DEBIAN/prerm" << 'EOF'
#!/bin/bash
set -e

# Cleanup message
echo "Removing Rory Terminal..."

exit 0
EOF

chmod +x "${DEB_ROOT}/DEBIAN/prerm"

print_success "Prerm script created"

# Copy desktop entries
print_step "Copying desktop entries..."

if [[ -f "${ROOT_DIR}/installers/desktop/rory-terminal.desktop" ]]; then
    cp "${ROOT_DIR}/installers/desktop/rory-terminal.desktop" "${DEB_ROOT}/usr/share/applications/"
fi

if [[ -f "${ROOT_DIR}/installers/desktop/rory-matrix.desktop" ]]; then
    cp "${ROOT_DIR}/installers/desktop/rory-matrix.desktop" "${DEB_ROOT}/usr/share/applications/"
fi

# Also copy launcher script
if [[ -f "${ROOT_DIR}/installers/desktop/rory-terminal-launcher.sh" ]]; then
    cp "${ROOT_DIR}/installers/desktop/rory-terminal-launcher.sh" "${DEB_ROOT}/usr/local/bin/"
    chmod +x "${DEB_ROOT}/usr/local/bin/rory-terminal-launcher.sh"
fi

print_success "Desktop entries copied"

# Create copyright file
cat > "${DEB_ROOT}/usr/share/doc/${PACKAGE_NAME}/copyright" << 'EOF'
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: rory-terminal
Upstream-Contact: Roderick Lawrence Renwick <rodericklrenwick@gmail.com>
Source: https://github.com/RLR-GitHub/terminal-themes

Files: *
Copyright: 2024 Roderick Lawrence Renwick
License: MIT
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 .
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 .
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
EOF

# Build package
print_step "Building .deb package..."

dpkg-deb --build --root-owner-group "${DEB_ROOT}" || {
    print_error "Failed to build package. Make sure dpkg-deb is installed."
}

print_success "Package built: ${BUILD_DIR}/${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"

# Create dist directory and copy package
mkdir -p "${DIST_DIR}"
cp "${BUILD_DIR}/${PACKAGE_NAME}_${VERSION}_${ARCH}.deb" "${DIST_DIR}/"
print_success "Package copied to: ${DIST_DIR}/${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"

# Optional: Sign package
if command -v dpkg-sig &> /dev/null && [[ -n "${GPG_KEY}" ]]; then
    print_step "Signing package..."
    dpkg-sig -k "$GPG_KEY" --sign builder "${DIST_DIR}/${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
    print_success "Package signed"
fi

print_success "Debian package build complete!"
echo ""
echo "Package location: ${DIST_DIR}/${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
echo "Install with: sudo dpkg -i ${DIST_DIR}/${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
echo "Or: sudo apt install ./${DIST_DIR}/${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"

