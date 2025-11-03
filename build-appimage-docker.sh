#!/bin/bash
# Build AppImage using Docker on macOS/Windows

VERSION="${1:-3.0.0}"

echo "Building AppImage v${VERSION} using Docker..."

# Build Docker image with necessary tools
cat > Dockerfile.appimage << 'EOF'
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    file \
    fuse \
    desktop-file-utils \
    && rm -rf /var/lib/apt/lists/*

# Download appimagetool
RUN wget -q https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage -O /usr/local/bin/appimagetool \
    && chmod +x /usr/local/bin/appimagetool

WORKDIR /workspace
EOF

# Build the Docker image
docker build -t appimage-builder -f Dockerfile.appimage .

# Run the build script inside Docker
docker run --rm -v "$(pwd):/workspace" appimage-builder bash -c "
    cd /workspace
    # Extract AppImage tool (can't run AppImage inside Docker directly)
    /usr/local/bin/appimagetool --appimage-extract
    mv squashfs-root /tmp/appimagetool
    # Make build script executable and run it
    chmod +x installers/native/linux/build-appimage.sh
    # Use extracted appimagetool
    export PATH=/tmp/appimagetool/usr/bin:\$PATH
    installers/native/linux/build-appimage.sh $VERSION
"

# Clean up
rm -f Dockerfile.appimage

echo "✅ AppImage build complete!"
echo "Check dist/linux/ for the AppImage file"
