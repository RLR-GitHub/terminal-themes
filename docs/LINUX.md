# Linux Installation Guide

Complete guide for installing Rory Terminal Themes on Linux distributions.

## Quick Install

### One-Line Install
```bash
curl -fsSL https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.sh | bash
```

### Distribution Packages

#### Debian/Ubuntu (.deb)
```bash
wget https://github.com/RLR-GitHub/terminal-themes/releases/download/v3.0.0/rory-terminal_3.0.0_all.deb
sudo dpkg -i rory-terminal_3.0.0_all.deb
sudo apt install -f  # Fix dependencies
```

#### Fedora/RHEL/CentOS (.rpm)
```bash
wget https://github.com/RLR-GitHub/terminal-themes/releases/download/v3.0.0/rory-terminal-3.0.0-1.noarch.rpm
sudo dnf install rory-terminal-3.0.0-1.noarch.rpm
```

#### Arch Linux (AUR)
```bash
yay -S rory-terminal
# Or
paru -S rory-terminal
```

#### Universal (AppImage)
```bash
wget https://github.com/RLR-GitHub/terminal-themes/releases/download/v3.0.0/RoryTerminal-3.0.0-x86_64.AppImage
chmod +x RoryTerminal-3.0.0-x86_64.AppImage
./RoryTerminal-3.0.0-x86_64.AppImage
```

## Requirements

### All Distributions
- **Bash 4.0+** or **zsh** or **fish**
- **curl** or **wget**
- **git** (recommended)

### Ubuntu/Debian
```bash
sudo apt update
sudo apt install bash curl git build-essential
```

### Fedora/RHEL/CentOS
```bash
sudo dnf install bash curl git gcc make
```

### Arch Linux
```bash
sudo pacman -S bash curl git base-devel
```

### openSUSE
```bash
sudo zypper install bash curl git gcc make
```

## Installation Options

### Option 1: Starship (Recommended)
Modern prompt with theme support.

**Auto-installs via package manager:**
- Ubuntu/Debian: Downloads from GitHub
- Fedora: `sudo dnf install starship`
- Arch: `sudo pacman -S starship`

**Includes:**
- Starship prompt
- Modern tools (eza, bat, delta)
- Shell plugins
- Theme manager

### Option 2: PTY Shim (Advanced)
Deep terminal customization with color injection.

**Requires compilation:**
```bash
sudo apt install build-essential  # Debian/Ubuntu
sudo dnf groupinstall "Development Tools"  # Fedora
sudo pacman -S base-devel  # Arch
```

**Includes:**
- PTY wrapper (compiled C code)
- Color rules engine
- Command hooks
- Output parser

### Option 3: Matrix Only
Minimal installation.

## Post-Installation

### Reload Shell
```bash
# Bash
source ~/.bashrc

# Zsh
source ~/.zshrc

# Fish
source ~/.config/fish/config.fish
```

### Verify Installation
```bash
command -v starship
command -v theme-manager
command -v matrix
```

## Terminal Emulators

### GNOME Terminal (Default Ubuntu/Fedora)
```bash
# Preferences → Profiles → Colors
# Set color palette to support 256 colors
```

### Alacritty (Recommended)
```bash
# Ubuntu/Debian
sudo add-apt-repository ppa:aslatter/ppa
sudo apt update && sudo apt install alacritty

# Fedora
sudo dnf install alacritty

# Arch
sudo pacman -S alacritty
```

**Config** (`~/.config/alacritty/alacritty.yml`):
```yaml
colors:
  primary:
    background: '#0a1a0a'
    foreground: '#00ff00'
```

### kitty
```bash
# Ubuntu/Debian
sudo apt install kitty

# Fedora
sudo dnf install kitty

# Arch
sudo pacman -S kitty
```

### Terminator
```bash
sudo apt install terminator
```

## Package Managers

### Ubuntu/Debian (apt)
```bash
sudo apt install starship eza bat git-delta
```

Note: `bat` is installed as `batcat` on Debian/Ubuntu.

### Fedora (dnf)
```bash
sudo dnf install starship eza bat git-delta
```

### Arch (pacman)
```bash
sudo pacman -S starship eza bat git-delta
```

### Universal (via cargo)
```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install tools
cargo install starship eza bat git-delta
```

## Themes

### List Themes
```bash
theme-manager list
```

### Change Theme
```bash
theme-manager set hacker
theme-manager set matrix
theme-manager set halloween
theme-manager set christmas
theme-manager set easter
```

### Current Theme
```bash
theme-manager current
```

### Run Matrix Animation
```bash
matrix              # Infinite
matrix --init       # 5-second intro
```

## Shell-Specific Setup

### Bash
Auto-configured by installer. Manual setup:
```bash
# Add to ~/.bashrc
export RORY_THEME="hacker"
eval "$(starship init bash)"
```

### Zsh
```bash
# Add to ~/.zshrc
export RORY_THEME="hacker"
eval "$(starship init zsh)"

# Plugins (auto-installed)
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
```

### Fish
```bash
# Add to ~/.config/fish/config.fish
set -gx RORY_THEME hacker
starship init fish | source
```

## Modern Tools Usage

### eza (ls replacement)
```bash
ls     # Enhanced ls
ll     # Long format
la     # All files
lt     # Tree view
```

### bat (cat replacement)
```bash
cat file.txt     # Syntax highlighted
batcat file.txt  # On Debian/Ubuntu
```

### delta (git diff)
```bash
git diff         # Beautiful diffs
git log -p       # Enhanced logs
```

## Troubleshooting

### Starship Not Found
```bash
# Check PATH
echo $PATH | tr ':' '\n' | grep local

# Add to shell config
export PATH="$HOME/.local/bin:$PATH"
```

### Permission Denied
```bash
chmod +x ~/.local/bin/*
chmod +x /opt/rory-terminal/core/**/*.sh
```

### Missing Dependencies (Debian/Ubuntu)
```bash
sudo apt install --fix-broken
sudo apt install -f
```

### Compilation Errors (PTY Shim)
```bash
# Install development tools
sudo apt install build-essential libutil-dev
```

### Colors Not Working
```bash
# Check TERM
echo $TERM  # Should be xterm-256color

# Fix if needed
export TERM=xterm-256color
```

### Fonts Missing Symbols
Install Nerd Fonts:
```bash
# Ubuntu/Debian
sudo apt install fonts-firacode

# Or download manually
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/FiraCode.zip
unzip FiraCode.zip
fc-cache -fv
```

## Uninstallation

### Package Manager
```bash
# Debian/Ubuntu
sudo apt remove rory-terminal

# Fedora
sudo dnf remove rory-terminal

# Arch
sudo pacman -R rory-terminal
```

### Manual
```bash
rm -rf ~/.local/share/rory-terminal
rm -rf ~/.config/rory-terminal
rm ~/.local/bin/theme-manager
rm ~/.local/bin/matrix

# Remove from shell config
sed -i.bak '/Rory Terminal/d' ~/.bashrc
```

## Advanced Configuration

### Systemd Service (Auto-start Matrix)
Create `~/.config/systemd/user/rory-matrix.service`:
```ini
[Unit]
Description=Rory Terminal Matrix Animation

[Service]
Type=oneshot
ExecStart=%h/.local/bin/matrix --init

[Install]
WantedBy=default.target
```

Enable:
```bash
systemctl --user enable rory-matrix.service
systemctl --user start rory-matrix.service
```

### Custom Color Scheme
Create `~/.config/rory-terminal/custom-colors.json`:
```json
{
  "primary": "#00ff00",
  "secondary": "#00cc00",
  "accent": "#00ff33",
  "background": "#000000",
  "foreground": "#00ff00"
}
```

### Integration with i3/Sway
Add to `~/.config/i3/config`:
```bash
exec --no-startup-id matrix --init
```

## Distribution-Specific Notes

### Ubuntu/Pop!_OS
- Use GNOME Terminal or Alacritty
- `bat` installed as `batcat`
- Snap packages available

### Fedora/RHEL
- Starship in official repos
- SELinux may require: `sudo setsebool -P allow_execheap 1`

### Arch Linux
- All tools in official repos
- AUR package available
- Consider fish shell

### openSUSE
- Use zypper for packages
- YaST for configuration

## Performance Tips

1. Use zsh with zinit for fast plugin loading
2. Enable Starship cache
3. Use Alacritty or kitty for GPU acceleration
4. Disable unused prompt modules

## Support

- GitHub: https://github.com/RLR-GitHub/terminal-themes
- Issues: https://github.com/RLR-GitHub/terminal-themes/issues
- Wiki: https://github.com/RLR-GitHub/terminal-themes/wiki

