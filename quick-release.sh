#!/bin/bash
# Quick release script to build and create GitHub release

set -e

VERSION="3.0.0"
REPO="RLR-GitHub/terminal-themes"

echo "🚀 Quick Release Builder for Rory Terminal v${VERSION}"
echo "================================================"

# Create release directory
mkdir -p dist/release

# Create universal tarball
echo "📦 Creating source tarball..."
git archive --format=tar.gz --prefix="rory-terminal-${VERSION}/" \
    -o "dist/release/rory-terminal-${VERSION}.tar.gz" HEAD

# Create universal zip
echo "📦 Creating universal zip..."
zip -r "dist/release/rory-terminal-${VERSION}-universal.zip" \
    core themes config installers docs README.md LICENSE \
    -x "*.git*" "*/.DS_Store" "*/build/*" "*/dist/*" "*/quick-release.sh"

# Build Linux .deb package simulation (for quick testing)
echo "📦 Creating .deb package structure..."
DEB_DIR="dist/release/deb-build"
PACKAGE_NAME="rory-terminal"
DEB_NAME="${PACKAGE_NAME}_${VERSION}_all.deb"

rm -rf "$DEB_DIR"
mkdir -p "$DEB_DIR/DEBIAN"
mkdir -p "$DEB_DIR/opt/rory-terminal"
mkdir -p "$DEB_DIR/usr/local/bin"
mkdir -p "$DEB_DIR/usr/share/applications"
mkdir -p "$DEB_DIR/usr/share/doc/rory-terminal"

# Copy files
cp -r core themes config "$DEB_DIR/opt/rory-terminal/"
cp installers/desktop/*.desktop "$DEB_DIR/usr/share/applications/"
cp installers/desktop/rory-terminal-launcher.sh "$DEB_DIR/usr/local/bin/"
chmod +x "$DEB_DIR/usr/local/bin/rory-terminal-launcher.sh"
cp README.md LICENSE "$DEB_DIR/usr/share/doc/rory-terminal/"

# Create control file
cat > "$DEB_DIR/DEBIAN/control" << EOF
Package: ${PACKAGE_NAME}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: all
Depends: bash (>= 4.0), python3, python3-tk
Recommends: starship, git, curl, zenity
Suggests: bat, git-delta
Maintainer: Roderick Lawrence Renwick <rodericklrenwick@gmail.com>
Homepage: https://github.com/RLR-GitHub/terminal-themes
Description: Cyberpunk terminal themes with Matrix animations
 Rory Terminal provides Matrix-style terminal animations and modern terminal
 customization with Starship integration. Features 5 unique themes with
 cross-platform compatibility.
EOF

# Create postinst script
cat > "$DEB_DIR/DEBIAN/postinst" << 'EOF'
#!/bin/bash
set -e

# Create symlink
ln -sf /usr/local/bin/rory-terminal-launcher.sh /usr/local/bin/rory-terminal

# Update desktop database
if command -v update-desktop-database >/dev/null; then
    update-desktop-database
fi

echo "Rory Terminal installed successfully!"
echo "Run 'rory-terminal' to start"
EOF
chmod 755 "$DEB_DIR/DEBIAN/postinst"

# Build .deb if dpkg-deb is available
if command -v dpkg-deb >/dev/null; then
    echo "📦 Building .deb package..."
    dpkg-deb --build "$DEB_DIR" "dist/release/$DEB_NAME"
    echo "✅ Created: dist/release/$DEB_NAME"
else
    echo "⚠️  dpkg-deb not found - creating .deb structure only"
fi

# Create checksums
echo "🔒 Generating checksums..."
cd dist/release
sha256sum *.tar.gz *.zip *.deb 2>/dev/null > SHA256SUMS || true
cd ../..

echo ""
echo "📋 Release artifacts created in dist/release/:"
ls -la dist/release/

echo ""
echo "🚀 Next steps:"
echo "1. Go to: https://github.com/${REPO}/releases/new"
echo "2. Choose tag: v${VERSION}"
echo "3. Release title: 'Rory Terminal ${VERSION}'"
echo "4. Upload the files from dist/release/"
echo "5. Use the release notes from the script output"

echo ""
echo "📝 Suggested release notes:"
cat << 'NOTES'
# Rory Terminal 3.0.0 - Universal Terminal Theming Platform

## 🚀 Installation

### Quick Install (Unix/Linux/macOS)
```bash
curl -fsSL https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.sh | bash
```

### Quick Install (Windows PowerShell)
```powershell
iwr -useb https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.ps1 | iex
```

## 📦 Downloads

- **Ubuntu/Debian**: `rory-terminal_3.0.0_all.deb`
- **Universal**: `rory-terminal-3.0.0-universal.zip`
- **Source**: `rory-terminal-3.0.0.tar.gz`

## ✨ Features

- 5 cyberpunk themes with Matrix animations
- Cross-platform support (Windows, macOS, Linux)
- GUI theme selector
- Shell integration (bash, zsh, fish, PowerShell)
- Desktop integration

## 📝 What's New

- Complete platform rewrite
- Native package support
- GUI applications
- PowerShell module
- Automated deployment pipelines
NOTES
