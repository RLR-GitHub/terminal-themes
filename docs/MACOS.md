# macOS Installation Guide

Complete guide for installing Rory Terminal Themes on macOS.

## Quick Install

### One-Line Install
```bash
curl -fsSL https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.sh | bash
```

### Native Package
```bash
# Download .pkg installer
# Double-click to install
# Or via command line:
sudo installer -pkg RoryTerminal-3.0.0.pkg -target /
```

## Requirements

- **macOS 10.15+** (Catalina or later)
- **Bash 4.0+** or **zsh**
- **Homebrew** (recommended)

### Install Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Installation Options

### Option 1: Starship (Recommended)
```bash
./install.sh
# Select option 1
# Choose your theme
```

**Includes:**
- Starship prompt
- Modern tools (eza, bat, delta)
- ZSH plugins (if using zsh)
- Theme manager

### Option 2: PTY Shim (Advanced)
```bash
./install.sh
# Select option 2
# Requires Xcode Command Line Tools
```

**Requires:**
```bash
xcode-select --install
```

**Includes:**
- PTY wrapper (compiled)
- Color injection system
- Command hooks
- Output parser

### Option 3: Matrix Only
Minimal installation with just Matrix animations.

## Post-Installation

### Reload Shell
```bash
# For bash
source ~/.bashrc

# For zsh
source ~/.zshrc
```

### Verify Installation
```bash
which starship
theme-manager --version
matrix --init
```

## Terminal Recommendations

### iTerm2 (Recommended)
```bash
brew install --cask iterm2
```

**Recommended Settings:**
- Preferences → Profiles → Colors → Color Presets → Import
- Preferences → Profiles → Text → Font → "Fira Code Nerd Font"
- Preferences → General → Selection → Copy to pasteboard on selection

### Terminal.app (Built-in)
Works great with default settings. Enable 256 colors:
- Preferences → Profiles → Advanced → Declare terminal as: xterm-256color

## Package Management

### Homebrew (Primary)
```bash
brew install starship
brew install eza bat git-delta
```

### MacPorts
```bash
sudo port install starship
sudo port install eza bat git-delta
```

## Themes

### List Available Themes
```bash
theme-manager list
```

### Change Theme
```bash
theme-manager set halloween
theme-manager set christmas
theme-manager set easter
theme-manager set hacker
theme-manager set matrix
```

### Run Matrix Animation
```bash
matrix              # Infinite mode
matrix --init       # 5-second intro
theme-manager matrix halloween  # Specific theme
```

## ZSH Integration

### Oh My Zsh
If you use Oh My Zsh, Rory Terminal integrates seamlessly:

```bash
# Add to ~/.zshrc before Oh My Zsh source
export RORY_THEME="hacker"

# After Oh My Zsh
eval "$(starship init zsh)"
```

### ZSH Plugins
Auto-installed with Option #1:
- zsh-syntax-highlighting
- zsh-autosuggestions

## Modern Tools

### eza (ls replacement)
```bash
ls        # Now uses eza
ll        # Long format with git status
la        # All files
lt        # Tree view
```

### bat (cat replacement)
```bash
cat file.txt    # Now uses bat with syntax highlighting
ccat file.txt   # Original cat
```

### delta (git diff)
```bash
git diff        # Now uses delta
git log -p      # Beautiful diff in logs
```

## Troubleshooting

### Bash Version Too Old
```bash
# Check version
bash --version

# Upgrade via Homebrew
brew install bash
echo /usr/local/bin/bash | sudo tee -a /etc/shells
chsh -s /usr/local/bin/bash
```

### Starship Not Found
```bash
# Check installation
which starship

# Reinstall
brew reinstall starship
```

### Emoji Not Displaying
Install a Nerd Font:
```bash
brew tap homebrew/cask-fonts
brew install --cask font-fira-code-nerd-font
brew install --cask font-meslo-lg-nerd-font
```

Set in terminal preferences.

### Permission Denied
```bash
chmod +x ~/.local/bin/*
```

### Colors Not Working
```bash
# Check TERM
echo $TERM  # Should be xterm-256color

# Set in shell config
export TERM=xterm-256color
```

## Uninstallation

### Via Installer
```bash
theme-manager uninstall
```

### Native Package
```bash
sudo /usr/local/bin/rory-terminal-uninstall
```

### Manual
```bash
rm -rf ~/.local/share/rory-terminal
rm -rf ~/.config/rory-terminal
rm ~/.local/bin/theme-manager
rm ~/.local/bin/matrix

# Remove from shell config
sed -i.bak '/Rory Terminal/d' ~/.bashrc
sed -i.bak '/Rory Terminal/d' ~/.zshrc
```

## Advanced Configuration

### Custom Starship Config
Edit `~/.config/starship.toml`:
```toml
# Override theme settings
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"

# Add custom modules
[git_commit]
commit_hash_length = 8
```

### Custom Aliases
Add to `.bashrc` or `.zshrc`:
```bash
# Custom Matrix
alias halloween-matrix='RORY_THEME=halloween matrix'
alias christmas-matrix='RORY_THEME=christmas matrix'

# Quick theme switching
alias theme-h='theme-manager set hacker'
alias theme-m='theme-manager set matrix'
```

### Startup Animation
Add to shell config:
```bash
# Run Matrix on startup
if [[ -o login ]]; then
    matrix --init
fi
```

## Performance Optimization

1. **Use zsh over bash** (faster completion)
2. **Enable Starship cache**:
   ```bash
   export STARSHIP_CACHE=~/.cache/starship
   ```
3. **Reduce prompt modules**:
   Edit `~/.config/starship.toml` and disable unused modules

## Integration with Other Tools

### tmux
```bash
# Add to ~/.tmux.conf
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",*256col*:Tc"
```

### vim/neovim
```vim
" Enable true colors
set termguicolors
colorscheme matrix  " If using vim theme
```

## Support

- GitHub: https://github.com/RLR-GitHub/terminal-themes
- Issues: https://github.com/RLR-GitHub/terminal-themes/issues
- Email: rodericklrenwick@gmail.com

