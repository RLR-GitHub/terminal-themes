# ⚡ Quick Start Guide

Get your terminal themed in under 60 seconds!

## 🚀 Super Quick Install

```bash
# One command to rule them all
curl -fsSL https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/install.sh | bash
```

This interactive installer will:

1. ✓ Check your system
2. ✓ Let you choose a theme
3. ✓ Download the script
4. ✓ Configure your shell
5. ✓ Run a test

---

## 📦 Manual Install (3 steps)

### 1. Download a theme

Pick your favorite:

```bash
# 🎨 ASCII (Default - Cyberpunk purple/cyan)
curl -o ~/matrix.sh https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/themes/bash/matrix-ascii.sh && chmod +x ~/matrix.sh

# 💻 Hacker (Bright green with r0ry.computer)
curl -o ~/matrix.sh https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/themes/bash/matrix-hacker.sh && chmod +x ~/matrix.sh

# 🟢 Matrix (Classic green)
curl -o ~/matrix.sh https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/themes/bash/matrix-classic.sh && chmod +x ~/matrix.sh

# 🎃 Halloween (Spooky orange)
curl -o ~/matrix.sh https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/themes/bash/matrix-halloween.sh && chmod +x ~/matrix.sh

# 🎄 Christmas (Festive red/green)
curl -o ~/matrix.sh https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/themes/bash/matrix-christmas.sh && chmod +x ~/matrix.sh

# 🐰 Easter (Pastel rainbow)
curl -o ~/matrix.sh https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/themes/bash/matrix-easter.sh && chmod +x ~/matrix.sh
```

### 2. Add to your shell

**For Bash:**

```bash
echo '~/matrix.sh --init' >> ~/.bashrc
```

**For Zsh:**

```bash
echo '~/matrix.sh --init' >> ~/.zshrc
```

### 3. Reload

```bash
source ~/.bashrc  # or source ~/.zshrc
```

Done! 🎉

---

## 🎮 Try It Now

```bash
# Run 5-second intro
~/matrix.sh --init

# Run infinite mode (Ctrl+C to exit)
~/matrix.sh
```

---

## 🎨 Optional: Add Full Configuration

For the complete experience with custom prompt and aliases:

**Copy this entire block** and paste into your `~/.bashrc` or `~/.zshrc`:

```bash
# ================================
# Rory's Cyberpunk Terminal Setup
# ================================

function set-title() {
    echo -ne "\033]0;$@\007"
}

function sys-status() {
    echo -e "\e[1;32m╓───[ SYSTEM STATUS ]──────────────\e[0m"
    echo -e "\e[1;32m╟─\e[0m \e[1;33mUser:\e[0m $(whoami)@$(hostname)"
    echo -e "\e[1;32m╟─\e[0m \e[1;33mUptime:\e[0m $(uptime -p 2>/dev/null || uptime)"
    echo -e "\e[1;32m╟─\e[0m \e[1;33mDisk:\e[0m $(df -h / | awk 'NR==2{print $5}')"
    echo -e "\e[1;32m╙──────────────────────────────────\e[0m"
}

set-title "r0ry.computer"

alias ll='ls -la --color=auto 2>/dev/null || ls -la'
alias gitc='git commit -m'
alias hack='echo "Initiating hack sequence..." && sleep 1 && echo "Access granted."'
alias scan='echo "Scanning network..." && ping -c 3 8.8.8.8'
alias matrix='~/matrix.sh'

PS1='\[\e[0;32m\]┌──(\[\e[1;31m\]\u@\h\[\e[0;32m\])─[\[\e[0m\]\w\[\e[0;32m\]]\n└──\$ \[\e[0m\]'

~/matrix.sh --init
```

Then reload: `source ~/.bashrc`

---

## 🔧 New Commands Available

```bash
matrix      # Run Matrix animation
sys-status  # System information
hack        # Hacker simulation
scan        # Network scan
ll          # Better file listing
```

---

## 🎭 Switch Themes

```bash
# Download a different theme (overwrites current)
curl -o ~/matrix.sh https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/themes/bash/matrix-easter.sh
chmod +x ~/matrix.sh

# Start new terminal or run:
source ~/.bashrc
```

---

## ❌ Uninstall

```bash
# Remove script
rm ~/matrix.sh

# Remove from shell config (manual edit)
nano ~/.bashrc  # or ~/.zshrc
# Delete the Rory's Cyberpunk Terminal Setup section
```

Or use the installer's uninstall:

```bash
curl -fsSL https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/install.sh | bash -s -- --uninstall
```

---

## 🐧 Ubuntu-Specific Tips

### GNOME Terminal Setup (Default Ubuntu Terminal)

```bash
# Enable 256 colors in GNOME Terminal
# Edit → Preferences → Profiles → Colors
# Set "Built-in schemes" to "Custom"
# Enable "Use colors from system theme" = OFF
```

### Ubuntu Uses dash, Not bash by Default

Ubuntu's `/bin/sh` is `dash`, which doesn't support bash features. If you get errors:

```bash
# Check your current shell
echo $SHELL

# If it's not bash, switch to bash:
chsh -s /bin/bash

# Or always run scripts with explicit bash:
bash ~/matrix.sh
```

### WSL Ubuntu (Windows Subsystem for Linux)

```bash
# Works perfectly on WSL Ubuntu!
# 1. Install Windows Terminal from Microsoft Store first
# 2. Run the installer normally:
curl -fsSL https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.sh | bash

# 3. Restart your WSL terminal
```

### Ubuntu LTS Version Support

- ✅ **24.04 LTS (Noble)**: Fully supported, all features
- ✅ **22.04 LTS (Jammy)**: Fully supported, all features
- ✅ **20.04 LTS (Focal)**: Fully supported (Bash 5.0+)
- ⚠️ **18.04 LTS (Bionic)**: Basic support, use manual install

---

## 🆘 Troubleshooting

### Emojis look weird?

```bash
# Add to ~/.bashrc
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
```

### Colors don't work?

```bash
# Add to ~/.bashrc
export TERM=xterm-256color
```

### Script won't stop?

```bash
# Press Ctrl+C
# Or force kill:
pkill -f matrix.sh
```

### Terminal is broken after exit?

```bash
reset
```

---

## 📚 Full Documentation

For detailed customization, theme creation, and more:

- [Full README](README.md)
- [Contributing Guide](CONTRIBUTING.md)
- [GitHub Repository](https://github.com/RLR-GitHub/terminal-themes)

---

## 💬 Get Help

- 🐛 [Report Issues](https://github.com/RLR-GitHub/terminal-themes/issues)
- 💡 [Request Features](https://github.com/RLR-GitHub/terminal-themes/issues/new)
- 📧 Email: <rodericklrenwick@gmail.com>

---

**Now go make your terminal awesome! 🚀**
