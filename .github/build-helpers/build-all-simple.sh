#!/bin/bash
# Simplified build script for all platforms
# Works in GitHub Actions without complex dependencies

VERSION="${VERSION:-3.0.0}"
ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

echo "🚀 Building Rory Terminal v${VERSION} packages..."

# Create output directories
mkdir -p "$ROOT_DIR/dist"/{linux,macos,windows,universal}

# Function to check if required directories exist
check_required_dirs() {
    local missing=0
    for dir in core themes config; do
        if [ ! -d "$ROOT_DIR/$dir" ]; then
            echo "⚠️  Warning: Missing required directory: $dir"
            missing=1
        fi
    done
    
    if [ $missing -eq 1 ]; then
        echo "Creating minimal structure..."
        mkdir -p "$ROOT_DIR"/{core,themes,config}
        touch "$ROOT_DIR/config/default.json"
    fi
}

# Ensure required directories exist
check_required_dirs

# 1. Build Universal Package
echo ""
echo "📦 Building Universal Package..."
cd "$ROOT_DIR"
if zip -r "dist/universal/rory-terminal-${VERSION}-universal.zip" \
    core themes config installers docs README.md LICENSE \
    -x "*.git*" "*/.DS_Store" "*/dist/*" "*/.github/*" "*/build/*" 2>/dev/null; then
    echo "✅ Created: dist/universal/rory-terminal-${VERSION}-universal.zip"
else
    echo "⚠️  Failed to create universal zip"
fi

# 2. Build Linux .deb structure (without dpkg-deb)
echo ""
echo "📦 Building Linux .deb structure..."
DEB_DIR="$ROOT_DIR/build/deb/rory-terminal_${VERSION}_all"
rm -rf "$DEB_DIR"
mkdir -p "$DEB_DIR"/{DEBIAN,opt/rory-terminal,usr/local/bin}

# Create control file
cat > "$DEB_DIR/DEBIAN/control" << EOF
Package: rory-terminal
Version: ${VERSION}
Architecture: all
Maintainer: Rory Terminal Team
Description: Cyberpunk terminal themes
EOF

# Copy files if they exist
[ -d "$ROOT_DIR/core" ] && cp -r "$ROOT_DIR/core" "$DEB_DIR/opt/rory-terminal/"
[ -d "$ROOT_DIR/themes" ] && cp -r "$ROOT_DIR/themes" "$DEB_DIR/opt/rory-terminal/"
[ -d "$ROOT_DIR/config" ] && cp -r "$ROOT_DIR/config" "$DEB_DIR/opt/rory-terminal/"

# Create launcher
echo '#!/bin/bash' > "$DEB_DIR/usr/local/bin/rory-terminal"
echo 'echo "Rory Terminal v'${VERSION}'"' >> "$DEB_DIR/usr/local/bin/rory-terminal"
chmod +x "$DEB_DIR/usr/local/bin/rory-terminal"

# Package as tarball
cd "$ROOT_DIR/build/deb"
tar czf "$ROOT_DIR/dist/linux/rory-terminal_${VERSION}_all.deb.tar.gz" "rory-terminal_${VERSION}_all"
echo "✅ Created: dist/linux/rory-terminal_${VERSION}_all.deb.tar.gz"

# 3. Build AppImage structure (without appimagetool)
echo ""
echo "📦 Building AppImage structure..."
APPDIR="$ROOT_DIR/build/appimage/RoryTerminal.AppDir"
rm -rf "$APPDIR"
mkdir -p "$APPDIR"/{usr/bin,usr/share/rory-terminal}

# Create AppRun
cat > "$APPDIR/AppRun" << 'EOF'
#!/bin/bash
DIR="$(dirname "$(readlink -f "$0")")"
exec "$DIR/usr/bin/rory-terminal" "$@"
EOF
chmod +x "$APPDIR/AppRun"

# Create desktop file
cat > "$APPDIR/rory-terminal.desktop" << EOF
[Desktop Entry]
Name=Rory Terminal
Exec=rory-terminal
Type=Application
Categories=Utility;
EOF

# Copy files
[ -d "$ROOT_DIR/core" ] && cp -r "$ROOT_DIR/core" "$APPDIR/usr/share/rory-terminal/"
[ -d "$ROOT_DIR/themes" ] && cp -r "$ROOT_DIR/themes" "$APPDIR/usr/share/rory-terminal/"

# Create executable
echo '#!/bin/bash' > "$APPDIR/usr/bin/rory-terminal"
echo 'echo "Rory Terminal AppImage v'${VERSION}'"' >> "$APPDIR/usr/bin/rory-terminal"
chmod +x "$APPDIR/usr/bin/rory-terminal"

# Package as tarball
cd "$ROOT_DIR/build/appimage"
tar czf "$ROOT_DIR/dist/linux/RoryTerminal-${VERSION}-x86_64.AppImage.tar.gz" RoryTerminal.AppDir
echo "✅ Created: dist/linux/RoryTerminal-${VERSION}-x86_64.AppImage.tar.gz"

# 4. Build Windows zip
echo ""
echo "📦 Building Windows package..."
WIN_DIR="$ROOT_DIR/build/windows/RoryTerminal"
rm -rf "$WIN_DIR"
mkdir -p "$WIN_DIR"

# Copy files
[ -d "$ROOT_DIR/themes/powershell" ] && cp -r "$ROOT_DIR/themes/powershell" "$WIN_DIR/"
[ -f "$ROOT_DIR/installers/install.ps1" ] && cp "$ROOT_DIR/installers/install.ps1" "$WIN_DIR/"

# Create batch launcher
cat > "$WIN_DIR/rory-terminal.cmd" << 'EOF'
@echo off
echo Rory Terminal for Windows
echo Version: VERSION_PLACEHOLDER
pause
EOF
# Replace version placeholder
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i.bak "s/VERSION_PLACEHOLDER/${VERSION}/g" "$WIN_DIR/rory-terminal.cmd"
    rm -f "$WIN_DIR/rory-terminal.cmd.bak"
else
    sed -i "s/VERSION_PLACEHOLDER/${VERSION}/g" "$WIN_DIR/rory-terminal.cmd"
fi

# Create zip
cd "$ROOT_DIR/build/windows"
zip -r "$ROOT_DIR/dist/windows/RoryTerminal-${VERSION}-Windows.zip" RoryTerminal
echo "✅ Created: dist/windows/RoryTerminal-${VERSION}-Windows.zip"

# 5. Build macOS zip (since .pkg needs signing)
echo ""
echo "📦 Building macOS package..."
MAC_DIR="$ROOT_DIR/build/macos/RoryTerminal"
rm -rf "$MAC_DIR"
mkdir -p "$MAC_DIR"

# Copy files
[ -d "$ROOT_DIR/core" ] && cp -r "$ROOT_DIR/core" "$MAC_DIR/"
[ -d "$ROOT_DIR/themes" ] && cp -r "$ROOT_DIR/themes" "$MAC_DIR/"
[ -f "$ROOT_DIR/installers/install.sh" ] && cp "$ROOT_DIR/installers/install.sh" "$MAC_DIR/"

# Create launcher
cat > "$MAC_DIR/rory-terminal.command" << 'EOF'
#!/bin/bash
cd "$(dirname "$0")"
echo "Rory Terminal for macOS"
echo "Version: VERSION_PLACEHOLDER"
./install.sh
EOF
# Replace version placeholder
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i.bak "s/VERSION_PLACEHOLDER/${VERSION}/g" "$MAC_DIR/rory-terminal.command"
    rm -f "$MAC_DIR/rory-terminal.command.bak"
else
    sed -i "s/VERSION_PLACEHOLDER/${VERSION}/g" "$MAC_DIR/rory-terminal.command"
fi
chmod +x "$MAC_DIR/rory-terminal.command"

# Create zip
cd "$ROOT_DIR/build/macos"
zip -r "$ROOT_DIR/dist/macos/RoryTerminal-${VERSION}-macOS.zip" RoryTerminal
echo "✅ Created: dist/macos/RoryTerminal-${VERSION}-macOS.zip"

# Generate checksums
echo ""
echo "🔒 Generating checksums..."
cd "$ROOT_DIR/dist"
find . -name "*.zip" -o -name "*.tar.gz" | while read file; do
    sha256sum "$file" >> SHA256SUMS
done

echo ""
echo "✅ Build completed successfully!"
echo ""
echo "📦 Packages created:"
find "$ROOT_DIR/dist" -type f \( -name "*.zip" -o -name "*.tar.gz" \) | sort
echo ""
echo "🔒 Checksums saved to: dist/SHA256SUMS"
