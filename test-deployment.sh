#!/bin/bash
# Test deployment script for Rory Terminal Themes
# This script tests the deployment process on the current system

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Rory Terminal Themes Deployment Test ===${NC}"
echo ""

# System information
echo -e "${YELLOW}System Information:${NC}"
echo "OS: $(uname -s)"
echo "Kernel: $(uname -r)"
echo "Shell: $SHELL"
echo "Bash version: ${BASH_VERSION:-Not running in bash}"
echo "/bin/sh links to: $(ls -la /bin/sh 2>/dev/null | awk '{print $NF}' || echo 'Unknown')"
echo ""

# Test prerequisites
echo -e "${YELLOW}Testing prerequisites:${NC}"

# Check bash
if command -v bash >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} bash found: $(which bash)"
    bash --version | head -1
else
    echo -e "${RED}✗${NC} bash not found!"
fi

# Check curl/wget
if command -v curl >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} curl found"
elif command -v wget >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} wget found"
else
    echo -e "${RED}✗${NC} Neither curl nor wget found!"
fi

echo ""

# Test installation
echo -e "${YELLOW}Testing installation:${NC}"

# Clean up any previous installation
if [ -f "$HOME/.local/bin/matrix" ]; then
    echo "Cleaning up previous installation..."
    rm -f "$HOME/.local/bin/matrix"*
fi

# Run installer
echo "Running installer..."
if [ -f "./installers/install.sh" ]; then
    bash ./installers/install.sh --theme hacker --option matrix-only --non-interactive
else
    echo -e "${RED}Error: installer not found at ./installers/install.sh${NC}"
    echo "Please run this script from the repository root."
    exit 1
fi

echo ""

# Test execution methods
echo -e "${YELLOW}Testing execution methods:${NC}"

# Method 1: Direct execution
echo -n "1. Direct execution: "
if [ -x "$HOME/.local/bin/matrix" ]; then
    if timeout 2s "$HOME/.local/bin/matrix" --version >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Works${NC}"
    else
        echo -e "${RED}✗ Failed${NC}"
    fi
else
    echo -e "${RED}✗ Not executable${NC}"
fi

# Method 2: With bash
echo -n "2. With bash: "
if timeout 2s bash "$HOME/.local/bin/matrix" --version >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Works${NC}"
else
    echo -e "${RED}✗ Failed${NC}"
fi

# Method 3: With sh (tests Ubuntu dash compatibility)
echo -n "3. With sh (dash on Ubuntu): "
if timeout 2s sh "$HOME/.local/bin/matrix" --version >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Works (wrapper is working!)${NC}"
else
    echo -e "${YELLOW}⚠ Expected to fail with raw bash script${NC}"
fi

# Method 4: Via PATH
echo -n "4. Via PATH: "
export PATH="$HOME/.local/bin:$PATH"
if command -v matrix >/dev/null 2>&1; then
    if timeout 2s matrix --version >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Works${NC}"
    else
        echo -e "${RED}✗ Command found but execution failed${NC}"
    fi
else
    echo -e "${RED}✗ Not in PATH${NC}"
fi

echo ""

# Test actual animation
echo -e "${YELLOW}Testing Matrix animation:${NC}"
echo "Running 3-second test..."
if timeout 3s matrix >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Animation runs successfully${NC}"
else
    exit_code=$?
    if [ $exit_code -eq 124 ]; then
        echo -e "${GREEN}✓ Animation runs successfully (timed out as expected)${NC}"
    else
        echo -e "${RED}✗ Animation failed with exit code: $exit_code${NC}"
    fi
fi

echo ""

# Check files created
echo -e "${YELLOW}Files created:${NC}"
ls -la "$HOME/.local/bin/matrix"* 2>/dev/null || echo "No matrix files found"
echo ""

# Summary
echo -e "${BLUE}=== Test Complete ===${NC}"
echo ""
echo "To use the matrix command, either:"
echo "1. Add to your current session: export PATH=\"\$HOME/.local/bin:\$PATH\""
echo "2. Restart your shell"
echo "3. Source your shell config: source ~/.bashrc"
echo ""
echo "Run matrix with:"
echo "  matrix          # Full animation"
echo "  matrix --init   # 5-second intro"
