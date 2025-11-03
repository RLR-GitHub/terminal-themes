#!/bin/bash
# Build AppImage for Rory Terminal Themes
# AppImage provides universal Linux binary

set -e

VERSION="3.0.0"
PACKAGE_NAME="RoryTerminal"
ARCH="x86_64"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
BUILD_DIR="${ROOT_DIR}/build/appimage"
DIST_DIR="${ROOT_DIR}/dist/linux"
APPDIR="${BUILD_DIR}/${PACKAGE_NAME}.AppDir"

print_step() { echo "==> $1"; }
print_success() { echo "✓ $1"; }
print_error() { echo "✗ $1"; exit 1; }

print_step "Building AppImage for Rory Terminal v${VERSION}"

# Check for appimagetool
if ! command -v appimagetool &> /dev/null; then
    print_step "Downloading appimagetool..."
    wget -q https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage \
        -O /tmp/appimagetool
    chmod +x /tmp/appimagetool
    APPIMAGETOOL="/tmp/appimagetool"
else
    APPIMAGETOOL="appimagetool"
fi

# Clean previous build
if [[ -d "$BUILD_DIR" ]]; then
    rm -rf "$BUILD_DIR"
fi

# Create AppDir structure
mkdir -p "${APPDIR}/usr/bin"
mkdir -p "${APPDIR}/usr/share/rory-terminal"
mkdir -p "${APPDIR}/usr/share/applications"
mkdir -p "${APPDIR}/usr/share/icons/hicolor/256x256/apps"

print_success "AppDir structure created"

# Copy application files
print_step "Copying files..."

cp -r "${ROOT_DIR}/core" "${APPDIR}/usr/share/rory-terminal/"
cp -r "${ROOT_DIR}/themes" "${APPDIR}/usr/share/rory-terminal/"
cp -r "${ROOT_DIR}/config" "${APPDIR}/usr/share/rory-terminal/"
cp -r "${ROOT_DIR}/installers/desktop" "${APPDIR}/usr/share/rory-terminal/"

# Make scripts executable
find "${APPDIR}/usr/share/rory-terminal" -name "*.sh" -exec chmod +x {} \;

print_success "Files copied"

# Create AppRun script
print_step "Creating AppRun..."

cat > "${APPDIR}/AppRun" << 'EOF'
#!/bin/bash
# AppRun - Entry point for AppImage

APPDIR="$(dirname "$(readlink -f "$0")")"

# Set up environment
export PATH="${APPDIR}/usr/bin:${PATH}"
export RORY_TERMINAL_DIR="${APPDIR}/usr/share/rory-terminal"

# Run theme manager by default
exec "${APPDIR}/usr/share/rory-terminal/core/option1-starship/theme-manager.sh" "$@"
EOF

chmod +x "${APPDIR}/AppRun"

print_success "AppRun created"

# Create wrapper scripts
cat > "${APPDIR}/usr/bin/rory-theme" << 'EOF'
#!/bin/bash
exec "${RORY_TERMINAL_DIR}/core/option1-starship/theme-manager.sh" "$@"
EOF

cat > "${APPDIR}/usr/bin/rory-matrix" << 'EOF'
#!/bin/bash
exec "${RORY_TERMINAL_DIR}/themes/bash/matrix-hacker.sh" "$@"
EOF

chmod +x "${APPDIR}/usr/bin/"*

# Create desktop entry
print_step "Creating desktop entry..."

cat > "${APPDIR}/rory-terminal.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Rory Terminal Themes
Comment=Cyberpunk terminal customization
Exec=AppRun
Icon=rory-terminal
Terminal=true
Categories=Utility;System;
X-AppImage-Version=${VERSION}
EOF

# Symlink for AppImage standards
ln -s rory-terminal.desktop "${APPDIR}/usr/share/applications/"

print_success "Desktop entry created"

# Create icon (simple text-based for now)
print_step "Creating icon..."

# Create a simple SVG icon
cat > "${APPDIR}/rory-terminal.svg" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg width="256" height="256" xmlns="http://www.w3.org/2000/svg">
  <rect width="256" height="256" fill="#000000"/>
  <text x="128" y="140" font-family="monospace" font-size="80" fill="#00ff00" text-anchor="middle">R0RY</text>
  <circle cx="64" cy="200" r="8" fill="#00ff00"/>
  <circle cx="128" cy="200" r="8" fill="#00ff00"/>
  <circle cx="192" cy="200" r="8" fill="#00ff00"/>
</svg>
EOF

ln -s ../../../rory-terminal.svg "${APPDIR}/usr/share/icons/hicolor/256x256/apps/rory-terminal.svg"

print_success "Icon created"

# Build AppImage
print_step "Building AppImage..."

ARCH=$ARCH $APPIMAGETOOL "${APPDIR}" "${BUILD_DIR}/${PACKAGE_NAME}-${VERSION}-${ARCH}.AppImage" || {
    print_error "AppImage build failed"
}

# Make AppImage executable
chmod +x "${BUILD_DIR}/${PACKAGE_NAME}-${VERSION}-${ARCH}.AppImage"

print_success "AppImage created: ${BUILD_DIR}/${PACKAGE_NAME}-${VERSION}-${ARCH}.AppImage"

# Create dist directory and copy AppImage
mkdir -p "${DIST_DIR}"
cp "${BUILD_DIR}/${PACKAGE_NAME}-${VERSION}-${ARCH}.AppImage" "${DIST_DIR}/"
print_success "AppImage copied to: ${DIST_DIR}/${PACKAGE_NAME}-${VERSION}-${ARCH}.AppImage"

print_success "AppImage build complete!"
echo ""
echo "AppImage location: ${DIST_DIR}/${PACKAGE_NAME}-${VERSION}-${ARCH}.AppImage"
echo "Run with: ${DIST_DIR}/${PACKAGE_NAME}-${VERSION}-${ARCH}.AppImage"

