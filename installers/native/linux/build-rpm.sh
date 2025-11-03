#!/bin/bash
# Build RPM package for Fedora/RHEL/CentOS

set -e

VERSION="3.0.0"
RELEASE="1"
PACKAGE_NAME="rory-terminal"
ARCH="noarch"
BUILD_DIR="$(pwd)/build/rpm"
ROOT_DIR="$(pwd)/../../.."
SPEC_FILE="${BUILD_DIR}/SPECS/${PACKAGE_NAME}.spec"

print_step() { echo "==> $1"; }
print_success() { echo "✓ $1"; }
print_error() { echo "✗ $1"; exit 1; }

print_step "Building RPM package for Rory Terminal v${VERSION}"

# Check for rpmbuild
if ! command -v rpmbuild &> /dev/null; then
    print_error "rpmbuild not found. Install: sudo dnf install rpm-build"
fi

# Clean previous build
if [[ -d "$BUILD_DIR" ]]; then
    rm -rf "$BUILD_DIR"
fi

# Create RPM build structure
mkdir -p "${BUILD_DIR}"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

print_success "RPM build structure created"

# Create source tarball
print_step "Creating source tarball..."

TARBALL="${BUILD_DIR}/SOURCES/${PACKAGE_NAME}-${VERSION}.tar.gz"
tar czf "$TARBALL" -C "${ROOT_DIR}/.." \
    --transform "s,^terminal-themes,${PACKAGE_NAME}-${VERSION}," \
    terminal-themes/core \
    terminal-themes/themes \
    terminal-themes/LICENSE \
    terminal-themes/README.md

print_success "Source tarball created"

# Create RPM spec file
print_step "Creating spec file..."

cat > "$SPEC_FILE" << EOF
Name:           ${PACKAGE_NAME}
Version:        ${VERSION}
Release:        ${RELEASE}%{?dist}
Summary:        Cyberpunk terminal themes collection
License:        MIT
URL:            https://github.com/RLR-GitHub/terminal-themes
Source0:        %{name}-%{version}.tar.gz
BuildArch:      ${ARCH}

Requires:       bash >= 4.0
Recommends:     git curl starship

%description
Rory Terminal Themes provides Matrix-style terminal animations
and modern terminal customization with Starship integration.

Features include:
 - 5 unique themes (Halloween, Christmas, Easter, Hacker, Matrix)
 - Cross-platform compatibility
 - Starship prompt integration
 - Modern terminal tools support

%prep
%setup -q

%build
# No build required for shell scripts

%install
rm -rf %{buildroot}

# Create directories
install -d %{buildroot}/opt/rory-terminal
install -d %{buildroot}%{_bindir}
install -d %{buildroot}%{_datadir}/applications

# Copy files
cp -r core %{buildroot}/opt/rory-terminal/
cp -r themes %{buildroot}/opt/rory-terminal/

# Create wrapper scripts
cat > %{buildroot}%{_bindir}/rory-theme << 'WRAPPER'
#!/bin/bash
exec /opt/rory-terminal/core/option1-starship/theme-manager.sh "\$@"
WRAPPER

cat > %{buildroot}%{_bindir}/rory-matrix << 'WRAPPER'
#!/bin/bash
exec /opt/rory-terminal/themes/bash/matrix-hacker.sh "\$@"
WRAPPER

chmod +x %{buildroot}%{_bindir}/*

# Desktop entry
cat > %{buildroot}%{_datadir}/applications/rory-terminal.desktop << 'DESKTOP'
[Desktop Entry]
Type=Application
Name=Rory Terminal Themes
Comment=Cyberpunk terminal customization
Exec=rory-theme
Icon=utilities-terminal
Terminal=true
Categories=Utility;System;
DESKTOP

%files
%license LICENSE
%doc README.md
/opt/rory-terminal/
%{_bindir}/rory-theme
%{_bindir}/rory-matrix
%{_datadir}/applications/rory-terminal.desktop

%post
echo "Rory Terminal installed to /opt/rory-terminal"
echo "Run: rory-theme --help to get started"

%changelog
* $(date +"%a %b %d %Y") Roderick Lawrence Renwick <rodericklrenwick@gmail.com> - ${VERSION}-${RELEASE}
- Initial RPM release
EOF

print_success "Spec file created"

# Build RPM
print_step "Building RPM package..."

rpmbuild --define "_topdir ${BUILD_DIR}" -ba "$SPEC_FILE" || {
    print_error "RPM build failed"
}

print_success "RPM package built"

# Find and display the built RPM
RPM_FILE=$(find "${BUILD_DIR}/RPMS" -name "*.rpm" | head -1)
SRPM_FILE=$(find "${BUILD_DIR}/SRPMS" -name "*.rpm" | head -1)

print_success "Binary RPM: $RPM_FILE"
print_success "Source RPM: $SRPM_FILE"

# Optional: Sign RPM
if command -v rpmsign &> /dev/null && [[ -n "${GPG_KEY}" ]]; then
    print_step "Signing RPM..."
    rpmsign --key-id="$GPG_KEY" --addsign "$RPM_FILE"
    print_success "RPM signed"
fi

print_success "RPM package build complete!"
echo ""
echo "Install with: sudo dnf install $RPM_FILE"
echo "Or: sudo rpm -ivh $RPM_FILE"

