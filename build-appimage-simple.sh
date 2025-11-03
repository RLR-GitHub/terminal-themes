#!/bin/bash
# Simplified AppImage build for Rory Terminal

set -e

VERSION="${1:-3.0.0}"
ARCH="x86_64"
BUILD_DIR="build/appimage-simple"
APPDIR="${BUILD_DIR}/RoryTerminal.AppDir"

echo "Building simplified AppImage structure for v${VERSION}..."

# Clean and create directories
rm -rf "$BUILD_DIR"
mkdir -p "$APPDIR/usr/bin"
mkdir -p "$APPDIR/usr/share/rory-terminal"
mkdir -p "$APPDIR/usr/share/applications"
mkdir -p "$APPDIR/usr/share/icons/hicolor/256x256/apps"

# Copy application files
echo "Copying files..."
cp -r core themes config "$APPDIR/usr/share/rory-terminal/"

# Create main executable
cat > "$APPDIR/usr/bin/rory-terminal" << 'EOF'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
export RORY_TERMINAL_DIR="$SCRIPT_DIR/share/rory-terminal"

# Simple menu
echo "Rory Terminal - Cyberpunk Themes"
echo "================================"
echo "1) Run Matrix Animation"
echo "2) Change Theme"
echo "3) Show Version"
echo ""
read -p "Select option (1-3): " choice

case $choice in
    1)
        exec bash "$RORY_TERMINAL_DIR/themes/bash/matrix-hacker.sh"
        ;;
    2)
        exec bash "$RORY_TERMINAL_DIR/core/option1-starship/theme-manager.sh"
        ;;
    3)
        echo "Rory Terminal v3.0.0"
        ;;
    *)
        echo "Invalid option"
        ;;
esac
EOF
chmod +x "$APPDIR/usr/bin/rory-terminal"

# Create AppRun
cat > "$APPDIR/AppRun" << 'EOF'
#!/bin/bash
APPDIR="$(dirname "$(readlink -f "$0")")"
export PATH="$APPDIR/usr/bin:$PATH"
export LD_LIBRARY_PATH="$APPDIR/usr/lib:$LD_LIBRARY_PATH"
exec "$APPDIR/usr/bin/rory-terminal" "$@"
EOF
chmod +x "$APPDIR/AppRun"

# Create desktop file
cat > "$APPDIR/rory-terminal.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Rory Terminal
Comment=Cyberpunk terminal themes
Exec=rory-terminal
Icon=rory-terminal
Terminal=true
Categories=Utility;TerminalEmulator;
EOF

# Create simple icon
cat > "$APPDIR/rory-terminal.png" << 'EOF'
# This would normally be a PNG file
# For now, using placeholder
EOF

# Copy desktop file to proper location
cp "$APPDIR/rory-terminal.desktop" "$APPDIR/usr/share/applications/"

# Make all scripts executable
find "$APPDIR" -name "*.sh" -exec chmod +x {} \;

echo "✅ AppImage structure created at: $APPDIR"
echo ""
echo "To create the actual AppImage on Linux:"
echo "1. Copy this directory to a Linux system"
echo "2. Download appimagetool:"
echo "   wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
echo "   chmod +x appimagetool-x86_64.AppImage"
echo "3. Build the AppImage:"
echo "   ./appimagetool-x86_64.AppImage $APPDIR"

# Create a tarball of the AppDir for easy transfer
echo ""
echo "Creating tarball for easy transfer..."
cd "$BUILD_DIR"
tar czf "RoryTerminal-${VERSION}-AppDir.tar.gz" "RoryTerminal.AppDir"
echo "✅ Created: $BUILD_DIR/RoryTerminal-${VERSION}-AppDir.tar.gz"
