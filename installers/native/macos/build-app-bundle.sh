#!/bin/bash
# Build macOS application bundle for Rory Terminal

set -e

VERSION="${1:-3.0.0}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
APP_DIR="$SCRIPT_DIR/RoryTerminal.app"
BUILD_DIR="$PROJECT_ROOT/build/macos"
DIST_DIR="$PROJECT_ROOT/dist/macos"

echo "Building Rory Terminal.app v${VERSION}..."

# Create build directories
mkdir -p "$BUILD_DIR"
mkdir -p "$DIST_DIR"

# Clean existing app if exists
if [ -d "$BUILD_DIR/RoryTerminal.app" ]; then
    rm -rf "$BUILD_DIR/RoryTerminal.app"
fi

# Copy app structure to build directory
cp -R "$APP_DIR" "$BUILD_DIR/"
APP_BUILD="$BUILD_DIR/RoryTerminal.app"

# Create Resources subdirectory for Rory Terminal files
RESOURCES_DIR="$APP_BUILD/Contents/Resources"
mkdir -p "$RESOURCES_DIR/rory-terminal"

# Copy Rory Terminal files
echo "Copying Rory Terminal files..."
cp -R "$PROJECT_ROOT/core" "$RESOURCES_DIR/rory-terminal/"
cp -R "$PROJECT_ROOT/themes" "$RESOURCES_DIR/rory-terminal/"
cp -R "$PROJECT_ROOT/config" "$RESOURCES_DIR/rory-terminal/"
cp -R "$PROJECT_ROOT/installers" "$RESOURCES_DIR/rory-terminal/"
cp "$PROJECT_ROOT/LICENSE" "$RESOURCES_DIR/rory-terminal/"
cp "$PROJECT_ROOT/README.md" "$RESOURCES_DIR/rory-terminal/"

# Create bin directory for utilities
mkdir -p "$RESOURCES_DIR/bin"

# Create icon (placeholder - you would normally use iconutil)
# For now, create a simple icon file
echo "Creating icon placeholder..."
touch "$RESOURCES_DIR/RoryTerminal.icns"

# Make all scripts executable
find "$RESOURCES_DIR" -name "*.sh" -exec chmod +x {} \;
find "$RESOURCES_DIR" -name "*.py" -exec chmod +x {} \;

# Create PkgInfo file
echo "APPLRory" > "$APP_BUILD/Contents/PkgInfo"

# Create LaunchAgent plist (optional - for background services)
LAUNCH_AGENT="$APP_BUILD/Contents/Resources/com.rlrgithub.roryterminal.plist"
cat > "$LAUNCH_AGENT" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.rlrgithub.roryterminal</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Applications/RoryTerminal.app/Contents/MacOS/RoryTerminal</string>
        <string>--background</string>
    </array>
    <key>RunAtLoad</key>
    <false/>
    <key>KeepAlive</key>
    <false/>
</dict>
</plist>
EOF

# Create AppleScript definition file
cat > "$RESOURCES_DIR/RoryTerminal.sdef" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE dictionary SYSTEM "file://localhost/System/Library/DTDs/sdef.dtd">
<dictionary title="Rory Terminal">
    <suite name="Rory Terminal Suite" code="RORY">
        <command name="set theme" code="RORYSTHM">
            <direct-parameter description="Theme name" type="text"/>
        </command>
        <command name="show matrix" code="RORYSHWM">
            <parameter name="with theme" code="WTHM" type="text" optional="yes"/>
        </command>
    </suite>
</dictionary>
EOF

# Sign the app (if certificate available)
if command -v codesign &> /dev/null && security find-identity -p codesigning &> /dev/null; then
    echo "Signing application..."
    codesign --force --deep --sign - "$APP_BUILD" 2>/dev/null || true
fi

echo "Application bundle created: $APP_BUILD"

# Create DMG installer
echo "Creating DMG installer..."
DMG_NAME="RoryTerminal-${VERSION}"
DMG_PATH="$DIST_DIR/${DMG_NAME}.dmg"
VOLUME_NAME="Rory Terminal"

# Create temporary directory for DMG contents
DMG_TEMP="$BUILD_DIR/dmg-temp"
rm -rf "$DMG_TEMP"
mkdir -p "$DMG_TEMP"

# Copy app to DMG temp
cp -R "$APP_BUILD" "$DMG_TEMP/"

# Create symbolic link to Applications
ln -s /Applications "$DMG_TEMP/Applications"

# Create README for DMG
cat > "$DMG_TEMP/README.txt" << 'EOF'
Rory Terminal Installation
=========================

1. Drag RoryTerminal.app to the Applications folder
2. Launch from Applications or Spotlight
3. Follow the setup wizard

For command-line installation:
- Open Terminal
- Run: /Applications/RoryTerminal.app/Contents/MacOS/RoryTerminal install

Enjoy your cyberpunk terminal experience!
EOF

# Create DMG
if command -v create-dmg &> /dev/null; then
    # Use create-dmg if available (install with: brew install create-dmg)
    create-dmg \
        --volname "$VOLUME_NAME" \
        --window-pos 200 120 \
        --window-size 600 400 \
        --icon-size 100 \
        --icon "RoryTerminal.app" 150 150 \
        --app-drop-link 450 150 \
        --hide-extension "RoryTerminal.app" \
        "$DMG_PATH" \
        "$DMG_TEMP"
else
    # Fallback to hdiutil
    echo "Creating DMG with hdiutil..."
    
    # Remove old DMG if exists
    [ -f "$DMG_PATH" ] && rm "$DMG_PATH"
    
    # Create DMG
    hdiutil create -volname "$VOLUME_NAME" \
        -srcfolder "$DMG_TEMP" \
        -ov -format UDZO \
        "$DMG_PATH"
fi

# Clean up
rm -rf "$DMG_TEMP"

echo ""
echo "Build complete!"
echo "Application: $APP_BUILD"
echo "DMG installer: $DMG_PATH"
echo ""
echo "To install:"
echo "  1. Open the DMG and drag RoryTerminal.app to Applications"
echo "  2. Or copy directly: cp -R '$APP_BUILD' /Applications/"
