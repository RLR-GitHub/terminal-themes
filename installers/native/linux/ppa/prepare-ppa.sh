#!/bin/bash
# Prepare Ubuntu PPA for Rory Terminal
# This script prepares the package for Launchpad PPA upload

set -e

VERSION="3.0.0"
PACKAGE_NAME="rory-terminal"
MAINTAINER="Roderick Lawrence Renwick <rodericklrenwick@gmail.com>"
PPA_NAME="ppa:rlr-github/terminal-themes"

# Create build directory
BUILD_DIR="$(pwd)/ppa-build"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Create source package directory
SOURCE_DIR="$BUILD_DIR/${PACKAGE_NAME}-${VERSION}"
mkdir -p "$SOURCE_DIR"

# Copy source files
echo "Copying source files..."
cp -r ../../../core "$SOURCE_DIR/"
cp -r ../../../themes "$SOURCE_DIR/"
cp -r ../../../config "$SOURCE_DIR/"
cp -r ../../../installers/desktop "$SOURCE_DIR/"
cp ../../../LICENSE "$SOURCE_DIR/"
cp ../../../README.md "$SOURCE_DIR/"

# Create debian directory
DEBIAN_DIR="$SOURCE_DIR/debian"
mkdir -p "$DEBIAN_DIR"

# Create debian/changelog
cat > "$DEBIAN_DIR/changelog" << EOF
${PACKAGE_NAME} (${VERSION}-1) focal; urgency=medium

  * Initial release of Rory Terminal Themes
  * 5 cyberpunk themes with Matrix animations
  * Starship prompt integration
  * GUI theme selector
  * Desktop integration

 -- ${MAINTAINER}  $(date -R)
EOF

# Create debian/control
cat > "$DEBIAN_DIR/control" << EOF
Source: ${PACKAGE_NAME}
Section: utils
Priority: optional
Maintainer: ${MAINTAINER}
Build-Depends: debhelper-compat (= 13), bash
Standards-Version: 4.5.1
Homepage: https://github.com/RLR-GitHub/terminal-themes
Vcs-Browser: https://github.com/RLR-GitHub/terminal-themes
Vcs-Git: https://github.com/RLR-GitHub/terminal-themes.git

Package: ${PACKAGE_NAME}
Architecture: all
Depends: \${shlibs:Depends}, \${misc:Depends}, bash (>= 4.0), python3, python3-tk, zenity
Recommends: starship, git, curl, gnome-terminal | konsole | xfce4-terminal | mate-terminal
Suggests: bat, eza, git-delta
Description: Cyberpunk terminal themes with Matrix animations
 Rory Terminal provides Matrix-style terminal animations and modern terminal
 customization with Starship integration. Features 5 unique themes (Halloween,
 Christmas, Easter, Hacker, Matrix) with cross-platform compatibility.
 .
 Features:
  - Matrix rain animations with theme-specific colors
  - Starship prompt integration  
  - Modern terminal tools (eza, bat, delta)
  - GUI theme selector
  - Command-line and desktop launcher support
EOF

# Create debian/rules
cat > "$DEBIAN_DIR/rules" << 'EOF'
#!/usr/bin/make -f

%:
	dh $@

override_dh_auto_install:
	# Install to opt
	mkdir -p $(CURDIR)/debian/rory-terminal/opt/rory-terminal
	cp -r core themes config $(CURDIR)/debian/rory-terminal/opt/rory-terminal/
	
	# Install desktop files
	mkdir -p $(CURDIR)/debian/rory-terminal/usr/share/applications
	cp desktop/*.desktop $(CURDIR)/debian/rory-terminal/usr/share/applications/
	
	# Install launcher scripts
	mkdir -p $(CURDIR)/debian/rory-terminal/usr/local/bin
	cp desktop/rory-terminal-launcher.sh $(CURDIR)/debian/rory-terminal/usr/local/bin/
	cp desktop/theme-selector.py $(CURDIR)/debian/rory-terminal/usr/local/bin/
	cp desktop/theme-selector-zenity.sh $(CURDIR)/debian/rory-terminal/usr/local/bin/
	chmod +x $(CURDIR)/debian/rory-terminal/usr/local/bin/*
	
	# Create symlinks
	mkdir -p $(CURDIR)/debian/rory-terminal/usr/bin
	ln -s /usr/local/bin/rory-terminal-launcher.sh $(CURDIR)/debian/rory-terminal/usr/bin/rory-terminal
	
	# Install documentation
	mkdir -p $(CURDIR)/debian/rory-terminal/usr/share/doc/rory-terminal
	cp README.md LICENSE $(CURDIR)/debian/rory-terminal/usr/share/doc/rory-terminal/
EOF

chmod +x "$DEBIAN_DIR/rules"

# Create debian/compat
echo "13" > "$DEBIAN_DIR/compat"

# Create debian/copyright
cat > "$DEBIAN_DIR/copyright" << EOF
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: ${PACKAGE_NAME}
Upstream-Contact: ${MAINTAINER}
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

# Create source package
echo "Building source package..."
cd "$SOURCE_DIR"

# Create original tarball
tar czf "../${PACKAGE_NAME}_${VERSION}.orig.tar.gz" --exclude=debian .

# Build source package
debuild -S -sa

echo "Source package created in: $BUILD_DIR"
echo ""
echo "To upload to PPA:"
echo "  dput ${PPA_NAME} ${BUILD_DIR}/${PACKAGE_NAME}_${VERSION}-1_source.changes"
echo ""
echo "First time setup:"
echo "  1. Create PPA at: https://launchpad.net/~/+activate-ppa"
echo "  2. Import GPG key to Launchpad"
echo "  3. Run: dput ${PPA_NAME} *.changes"
