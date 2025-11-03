#!/bin/bash
# Build Debian/Ubuntu .deb package for Rory Terminal Themes

set -e

VERSION="3.0.0"
PACKAGE_NAME="rory-terminal"
ARCH="all"
BUILD_DIR="$(pwd)/build/deb"
ROOT_DIR="$(pwd)/../../.."
DEB_ROOT="${BUILD_DIR}/${PACKAGE_NAME}_${VERSION}_${ARCH}"

print_step() { echo "==> $1"; }
print_success() { echo "✓ $1"; }
print_error() { echo "✗ $1"; exit 1; }

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

# Create desktop entry
print_step "Creating desktop entry..."

cat > "${DEB_ROOT}/usr/share/applications/rory-terminal.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Rory Terminal Themes
Comment=Cyberpunk terminal customization
Exec=rory-theme
Icon=utilities-terminal
Terminal=true
Categories=Utility;System;
Keywords=terminal;theme;cyberpunk;matrix;
EOF

print_success "Desktop entry created"

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

# Optional: Sign package
if command -v dpkg-sig &> /dev/null && [[ -n "${GPG_KEY}" ]]; then
    print_step "Signing package..."
    dpkg-sig -k "$GPG_KEY" --sign builder "${BUILD_DIR}/${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
    print_success "Package signed"
fi

print_success "Debian package build complete!"
echo ""
echo "Install with: sudo dpkg -i ${BUILD_DIR}/${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
echo "Or: sudo apt install ./${BUILD_DIR}/${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"

