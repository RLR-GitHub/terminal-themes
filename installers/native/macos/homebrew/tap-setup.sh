#!/bin/bash
# Setup script for Homebrew tap
# This creates a tap repository for distributing Rory Terminal via Homebrew

set -e

REPO_NAME="homebrew-terminal-themes"
GITHUB_USER="RLR-GitHub"
TAP_NAME="${GITHUB_USER,,}/terminal-themes"

echo "Homebrew Tap Setup for Rory Terminal"
echo "===================================="

# Create tap directory structure
TAP_DIR="$(pwd)/homebrew-tap"
rm -rf "$TAP_DIR"
mkdir -p "$TAP_DIR/Formula"
mkdir -p "$TAP_DIR/Casks"

# Copy formula and cask
cp "$(dirname "$0")/rory-terminal.rb" "$TAP_DIR/Formula/"
cp "$(dirname "$0")/rory-terminal-cask.rb" "$TAP_DIR/Casks/rory-terminal.rb"

# Create README
cat > "$TAP_DIR/README.md" << EOF
# Rory Terminal Homebrew Tap

This tap provides formulae and casks for [Rory Terminal](https://github.com/${GITHUB_USER}/terminal-themes).

## Installation

\`\`\`bash
# Add the tap
brew tap ${TAP_NAME}

# Install the CLI tools (formula)
brew install rory-terminal

# Or install the GUI app (cask)
brew install --cask rory-terminal
\`\`\`

## Available Packages

### Formula: \`rory-terminal\`
Command-line tools and shell integrations for Rory Terminal themes.

### Cask: \`rory-terminal\`
macOS application with GUI for theme selection and management.

## What is Rory Terminal?

Rory Terminal provides cyberpunk-themed terminal customization with Matrix-style animations. Features include:

- 5 unique themes (Halloween, Christmas, Easter, Hacker, Matrix)
- Matrix rain animations
- Starship prompt integration
- Cross-platform support

## Usage

After installation:

\`\`\`bash
# CLI (formula)
rory-terminal          # Launch theme selector
rory-theme set hacker  # Set a theme
rory-matrix halloween  # Run Matrix animation

# GUI (cask)
open -a "Rory Terminal"  # Launch the app
\`\`\`

## License

MIT License - See the main repository for details.
EOF

# Create tap formula that redirects to this tap
cat > "$TAP_DIR/.github/workflows/tests.yml" << 'EOF'
name: brew test-bot
on:
  push:
    branches:
      - main
  pull_request:
jobs:
  test-bot:
    strategy:
      matrix:
        os: [ubuntu-22.04, macos-12]
    runs-on: ${{ matrix.os }}
    steps:
      - name: Set up Homebrew
        id: set-up-homebrew
        uses: Homebrew/actions/setup-homebrew@master

      - name: Cache Homebrew Bundler RubyGems
        id: cache
        uses: actions/cache@v3
        with:
          path: ${{ steps.set-up-homebrew.outputs.gems-path }}
          key: ${{ runner.os }}-rubygems-${{ steps.set-up-homebrew.outputs.gems-hash }}
          restore-keys: ${{ runner.os }}-rubygems-

      - name: Install Homebrew Bundler RubyGems
        if: steps.cache.outputs.cache-hit != 'true'
        run: brew install-bundler-gems

      - run: brew test-bot --only-cleanup-before

      - run: brew test-bot --only-setup

      - run: brew test-bot --only-tap-syntax

      - run: brew test-bot --only-formulae
        if: github.event_name == 'pull_request'

      - name: Upload bottles as artifact
        if: always() && github.event_name == 'pull_request'
        uses: actions/upload-artifact@main
        with:
          name: bottles
          path: '*.bottle.*'
EOF

# Create .gitignore
cat > "$TAP_DIR/.gitignore" << 'EOF'
*.bottle.*
.DS_Store
EOF

echo ""
echo "Tap structure created in: $TAP_DIR"
echo ""
echo "To publish the tap:"
echo "  1. Create repository: https://github.com/${GITHUB_USER}/${REPO_NAME}"
echo "  2. cd $TAP_DIR"
echo "  3. git init"
echo "  4. git add ."
echo "  5. git commit -m 'Initial tap with Rory Terminal formula and cask'"
echo "  6. git remote add origin https://github.com/${GITHUB_USER}/${REPO_NAME}.git"
echo "  7. git push -u origin main"
echo ""
echo "Users will then be able to install with:"
echo "  brew tap ${TAP_NAME}"
echo "  brew install rory-terminal"
echo "  brew install --cask rory-terminal"
