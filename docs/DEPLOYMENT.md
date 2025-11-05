# 🚀 Cross-Platform Deployment Guide

This guide provides comprehensive deployment instructions for Rory Terminal Themes across macOS, Linux (including Ubuntu), and Windows.

## Table of Contents

1. [Quick Install](#quick-install)
2. [Platform-Specific Instructions](#platform-specific-instructions)
3. [Troubleshooting Common Issues](#troubleshooting-common-issues)
4. [Manual Installation](#manual-installation)
5. [Deployment Best Practices](#deployment-best-practices)

---

## Quick Install

### 🌐 Universal One-Liner (Recommended)

**macOS/Linux:**

```bash
curl -fsSL https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.sh | bash
```

**Windows PowerShell:**

```powershell
iwr -useb https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.ps1 | iex
```

**Windows CMD:**

```cmd
powershell -Command "iwr -useb https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.ps1 | iex"
```

---

## Platform-Specific Instructions

### 🐧 Ubuntu/Debian Linux

#### Linux Prerequisites

```bash
# Update package list
sudo apt update

# Install required dependencies
sudo apt install -y curl git bash

# Verify bash is installed
bash --version
```

#### Linux Installation Methods

**Method 1: Automated Script (Recommended)**

```bash
curl -fsSL https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.sh | bash
```

**Method 2: Package Manager**

```bash
# Add PPA (when available)
sudo add-apt-repository ppa:rlr-github/terminal-themes
sudo apt update
sudo apt install rory-terminal

# Or download .deb directly
wget https://github.com/RLR-GitHub/terminal-themes/releases/latest/download/rory-terminal_3.0.0_amd64.deb
sudo dpkg -i rory-terminal_3.0.0_amd64.deb
sudo apt-get install -f  # Fix any dependency issues
```

**Method 3: Snap**

```bash
sudo snap install rory-terminal
```

### 🍎 macOS

#### macOS Prerequisites

```bash
# Install Xcode Command Line Tools (if needed)
xcode-select --install

# Install Homebrew (if needed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### macOS Installation Methods

**Method 1: Homebrew (Recommended)**

```bash
# Tap the repository
brew tap rlr-github/terminal-themes

# Install CLI version
brew install rory-terminal

# Or install GUI version
brew install --cask rory-terminal
```

**Method 2: Automated Script**

```bash
curl -fsSL https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.sh | bash
```

**Method 3: Native Package**

```bash
# Download and install .pkg
curl -LO https://github.com/RLR-GitHub/terminal-themes/releases/latest/download/rory-terminal-3.0.0.pkg
sudo installer -pkg rory-terminal-3.0.0.pkg -target /
```

### 🪟 Windows

#### Windows Prerequisites

- Windows 10/11 with PowerShell 5.1 or higher
- Windows Terminal (recommended)

#### Windows Installation Methods

**Method 1: Winget (Windows 11/10)**

```powershell
winget install RoryTerminal
```

**Method 2: Chocolatey**

```powershell
# Install Chocolatey first if needed
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Rory Terminal
choco install rory-terminal
```

**Method 3: Scoop**

```powershell
# Install Scoop first if needed
iwr -useb get.scoop.sh | iex

# Add bucket and install
scoop bucket add rlr-github https://github.com/RLR-GitHub/scoop-bucket
scoop install rory-terminal
```

**Method 4: PowerShell Script**

```powershell
# Run installation script
iwr -useb https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.ps1 | iex
```

---

## Troubleshooting Common Issues

### 🐛 Ubuntu: "Command not found" on line 1

**Issue:** Getting `/bin/sh: 1: command not found` when running matrix script

**Cause:** Ubuntu's default `/bin/sh` is `dash`, not `bash`. The script requires bash features.

**Solutions:**

1. **Ensure bash is installed:**

```bash
sudo apt install bash
```

1. **Run with explicit bash:**

```bash
bash ~/matrix.sh
# or
bash ~/.local/bin/matrix
```

1. **Make script executable and run directly:**

```bash
chmod +x ~/matrix.sh
./matrix.sh  # Uses shebang line
```

1. **Re-run installer** (it now includes compatibility fixes):

```bash
curl -fsSL https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.sh | bash
```

### 🔧 General Linux Issues

**Issue:** Script permissions error

**Solution:**

```bash
# Fix permissions
chmod +x ~/.local/bin/matrix
chmod +x ~/matrix.sh

# Verify PATH includes ~/.local/bin
echo $PATH | grep -q "$HOME/.local/bin" || export PATH="$HOME/.local/bin:$PATH"
```

**Issue:** Colors not displaying correctly

**Solution:**

```bash
# Check terminal color support
echo $TERM

# Set 256-color support
export TERM=xterm-256color

# Add to ~/.bashrc or ~/.zshrc
echo 'export TERM=xterm-256color' >> ~/.bashrc
```

### 🍎 macOS Issues

**Issue:** "zsh: command not found: matrix"

**Solution:**

```bash
# Add to ~/.zshrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**Issue:** Homebrew installation fails

**Solution:**

```bash
# Update Homebrew
brew update
brew upgrade

# Clean up
brew cleanup
brew doctor

# Retry installation
brew tap rlr-github/terminal-themes
brew install rory-terminal
```

### 🪟 Windows Issues

**Issue:** "Running scripts is disabled on this system"

**Solution:**

```powershell
# Run as Administrator
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Or for current session only
Set-ExecutionPolicy Bypass -Scope Process
```

**Issue:** Unicode characters not displaying

**Solution:**

```powershell
# Enable UTF-8 in Windows Terminal
# Settings > Profiles > Defaults > Advanced > Text encoding: UTF-8

# Or in PowerShell
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
```

---

## Manual Installation

### Step-by-Step for All Platforms

1. **Download the script:**

```bash
# Choose your theme
THEME="ascii"  # Options: ascii (default), hacker, matrix, halloween, christmas, easter

# Download (macOS/Linux)
curl -o ~/matrix.sh https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/themes/bash/matrix-${THEME}.sh

# Download (Windows PowerShell)
$theme = "ascii"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/themes/powershell/Matrix-${theme}.ps1" -OutFile "$HOME\matrix.ps1"
```

1. **Make executable (macOS/Linux):**

```bash
chmod +x ~/matrix.sh
```

1. **Create alias:**

**Bash/Zsh (macOS/Linux):**

```bash
echo 'alias matrix="$HOME/matrix.sh"' >> ~/.bashrc  # or ~/.zshrc
source ~/.bashrc
```

**PowerShell (Windows):**

```powershell
Add-Content $PROFILE "function matrix { & `"$HOME\matrix.ps1`" @args }"
. $PROFILE
```

1. **Run:**

```bash
matrix          # Full animation
matrix --init   # 5-second intro
```

---

## Deployment Best Practices

### 📋 Pre-Deployment Checklist

- [ ] Verify target platform and version
- [ ] Check shell compatibility (bash 4.0+, PowerShell 5.1+)
- [ ] Ensure network connectivity for downloads
- [ ] Have sudo/admin privileges if needed
- [ ] Back up existing shell configurations

### 🔒 Security Considerations

1. **Verify script sources:**

```bash
# Check script content before execution
curl -fsSL https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.sh | less
```

1. **Use checksums when available:**

```bash
# Verify package integrity
sha256sum rory-terminal_3.0.0_amd64.deb
```

1. **Install from official sources:**

- GitHub Releases: <https://github.com/RLR-GitHub/terminal-themes/releases>
- Official Website: <https://rory.computer/terminal-themes>

### 🚀 Automated Deployment

**For System Administrators:**

1. **Mass deployment script (Linux):**

```bash
#!/bin/bash
# deploy-rory-terminal.sh

HOSTS_FILE="hosts.txt"
THEME="${1:-ascii}"  # Defaults to ascii theme

while IFS= read -r host; do
    echo "Deploying to $host..."
    ssh "$host" 'curl -fsSL https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.sh | bash -s -- --theme '"$THEME"' --quiet'
done < "$HOSTS_FILE"
```

1. **Group Policy deployment (Windows):**

```powershell
# Deploy via GPO PowerShell startup script
$installScript = "https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.ps1"
Invoke-Expression (New-Object Net.WebClient).DownloadString($installScript)
```

1. **Configuration management integration:**

```yaml
# Ansible playbook example
---
- name: Install Rory Terminal Themes
  hosts: all
  tasks:
    - name: Download and run installer
      shell: curl -fsSL https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.sh | bash
      args:
        creates: /home/{{ ansible_user }}/.local/bin/matrix
```

### 📦 Creating Custom Packages

**Debian/Ubuntu (.deb):**

```bash
# Use the provided build script
./installers/native/linux/build-deb.sh
```

**macOS (.pkg):**

```bash
# Use the provided build script
./installers/native/macos/build-pkg.sh
```

**Windows (.msi):**

```powershell
# Use the provided build script
.\installers\native\windows\build-msi.ps1
```

---

## Additional Resources

- [Architecture Guide](ARCHITECTURE.md)
- [Platform Guides](.) - macOS.md, LINUX.md, WINDOWS.md
- [Contributing](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)

## Support

If you encounter issues not covered here:

1. Check [GitHub Issues](https://github.com/RLR-GitHub/terminal-themes/issues)
2. Review [FAQ](https://github.com/RLR-GitHub/terminal-themes/wiki/FAQ)
3. Contact: <rodericklrenwick@gmail.com>

---

Made with ❤️ by Rory | [r0ry.computer](https://r0ry.computer)
