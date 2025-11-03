#!/bin/bash
# Build all packages that can be built on the current platform

set -e

VERSION="3.0.0"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR"

echo "🚀 Building Rory Terminal Packages v${VERSION}"
echo "============================================"

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
    OS="windows"
fi

echo "📋 Detected OS: $OS"
echo ""

# Always build universal packages
echo "📦 Building universal packages..."
./quick-release.sh

# Build platform-specific packages
case "$OS" in
    macos)
        echo ""
        echo "🍎 Building macOS packages..."
        
        # Build app bundle and DMG
        if [ -x "./installers/native/macos/build-app-bundle.sh" ]; then
            echo "  → Building app bundle..."
            ./installers/native/macos/build-app-bundle.sh
        fi
        
        # Build pkg with fixed distribution.xml
        echo "  → Building .pkg installer..."
        BUILD_DIR="build/macos"
        DIST_DIR="dist/macos"
        PACKAGE_NAME="RoryTerminal"
        IDENTIFIER="com.rory.terminal-themes"
        
        # Create build directories
        rm -rf "$BUILD_DIR"
        mkdir -p "$BUILD_DIR/pkgroot/Applications"
        mkdir -p "$BUILD_DIR/scripts"
        mkdir -p "$DIST_DIR"
        
        # Copy app to pkgroot if it exists
        if [ -d "build/macos/RoryTerminal.app" ]; then
            cp -R "build/macos/RoryTerminal.app" "$BUILD_DIR/pkgroot/Applications/"
        else
            # Create minimal structure if app doesn't exist
            mkdir -p "$BUILD_DIR/pkgroot/opt/rory-terminal"
            cp -r core themes config "$BUILD_DIR/pkgroot/opt/rory-terminal/"
        fi
        
        # Create postinstall script
        cat > "$BUILD_DIR/scripts/postinstall" << 'POSTINSTALL'
#!/bin/bash
# Create command line launcher
ln -sf /Applications/RoryTerminal.app/Contents/MacOS/RoryTerminal /usr/local/bin/rory-terminal 2>/dev/null || true
# Set up shell integration
if [ -d "/opt/rory-terminal" ]; then
    chmod +x /opt/rory-terminal/installers/install.sh 2>/dev/null || true
fi
exit 0
POSTINSTALL
        chmod +x "$BUILD_DIR/scripts/postinstall"
        
        # Build component package
        pkgbuild --root "$BUILD_DIR/pkgroot" \
                 --scripts "$BUILD_DIR/scripts" \
                 --identifier "$IDENTIFIER" \
                 --version "$VERSION" \
                 --ownership recommended \
                 "$BUILD_DIR/${PACKAGE_NAME}-component.pkg"
        
        # Create simple distribution.xml
        cat > "$BUILD_DIR/distribution.xml" << EOF
<?xml version="1.0" encoding="utf-8"?>
<installer-gui-script minSpecVersion="1">
    <title>Rory Terminal Themes</title>
    <organization>com.rory</organization>
    <domains enable_localSystem="true"/>
    <options customize="never" require-scripts="false"/>
    <pkg-ref id="$IDENTIFIER" version="$VERSION" onConclusion="none">${PACKAGE_NAME}-component.pkg</pkg-ref>
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
        
        # Build product package
        productbuild --distribution "$BUILD_DIR/distribution.xml" \
                     --package-path "$BUILD_DIR" \
                     "${DIST_DIR}/${PACKAGE_NAME}-${VERSION}.pkg"
        
        echo "  ✅ Created: ${DIST_DIR}/${PACKAGE_NAME}-${VERSION}.pkg"
        ;;
        
    linux)
        echo ""
        echo "🐧 Building Linux packages..."
        
        # Check for required tools
        if command -v dpkg-deb >/dev/null 2>&1; then
            echo "  → Building .deb package..."
            ./installers/native/linux/build-deb.sh
        else
            echo "  ⚠️  dpkg-deb not found - skipping .deb"
        fi
        
        if command -v rpmbuild >/dev/null 2>&1; then
            echo "  → Building .rpm package..."
            ./installers/native/linux/build-rpm.sh
        else
            echo "  ⚠️  rpmbuild not found - skipping .rpm"
        fi
        
        if command -v appimagetool >/dev/null 2>&1; then
            echo "  → Building AppImage..."
            ./installers/native/linux/build-appimage.sh
        else
            echo "  ⚠️  appimagetool not found - skipping AppImage"
        fi
        ;;
        
    windows)
        echo ""
        echo "🪟 Building Windows packages..."
        echo "  → Please run build-packages.ps1 in PowerShell"
        ;;
esac

echo ""
echo "📦 Build Summary:"
echo "=================="
find dist -type f -name "*.pkg" -o -name "*.dmg" -o -name "*.zip" -o -name "*.tar.gz" -o -name "*.deb" -o -name "*.rpm" -o -name "*.AppImage" | sort

echo ""
echo "✅ Build complete!"
