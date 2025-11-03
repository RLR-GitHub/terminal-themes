#!/bin/bash
# Simplified build script for CI/CD environments

set -e

VERSION="${VERSION:-3.0.0}"
ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

echo "Building simplified packages for v${VERSION}..."

# Create dist directories
mkdir -p "$ROOT_DIR/dist/linux"
mkdir -p "$ROOT_DIR/dist/macos" 
mkdir -p "$ROOT_DIR/dist/windows"
mkdir -p "$ROOT_DIR/dist/universal"

# Create universal zip
cd "$ROOT_DIR"
echo "Creating universal zip..."
zip -r "dist/universal/rory-terminal-${VERSION}-universal.zip" \
    core themes config installers docs README.md LICENSE \
    -x "*.git*" "*/.DS_Store" "*/dist/*" "*/.github/*" "*/build/*" \
    > /dev/null 2>&1

# Create source tarball
echo "Creating source tarball..."
git archive --format=tar.gz --prefix="rory-terminal-${VERSION}/" \
    -o "dist/universal/rory-terminal-${VERSION}.tar.gz" HEAD 2>/dev/null || \
tar czf "dist/universal/rory-terminal-${VERSION}.tar.gz" \
    --exclude=".git" --exclude="dist" --exclude="build" \
    --transform="s,^,rory-terminal-${VERSION}/," \
    core themes config installers docs README.md LICENSE

echo "✓ Build completed successfully"
echo "Packages created in dist/"
