# 🌈 Rory Terminal - Universal Terminal Theming Platform

<div align="center">

![Version](https://img.shields.io/badge/version-3.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue)
![Bash](https://img.shields.io/badge/bash-4.0%2B-orange)

**Transform your terminal into an immersive cyberpunk experience with Matrix-style animations**

[View Demo](https://rlr-github.github.io/terminal-themes) • [Documentation](https://github.com/RLR-GitHub/terminal-themes/wiki) • [Report Bug](https://github.com/RLR-GitHub/terminal-themes/issues) • [Request Feature](https://github.com/RLR-GitHub/terminal-themes/issues)

</div>

---

<div align="center">

```
  >

  ######     ######    ######   #    #      
  #     #   #     #   #     #  #    #      
  #     #   #     #   #     #  #  #       
  ######    #     #   ######    ##         
  #   #     #     #   #   #      #          
  #    #    #     #   #    #     #          
  #     #   ######    #     #    #          
```

*Welcome to your customized terminal experience.*

</div>

---

## 📸 Terminal Preview

When you run any Rory Terminal theme, you'll see the ASCII "> RORY" banner followed by the Matrix rain animation:

<div align="center">
<img src="https://user-images.githubusercontent.com/placeholder/terminal-demo.gif" alt="Rory Terminal in action" width="600">
</div>

> **Note:** The RORY banner colors adapt to your selected theme (Halloween orange, Christmas red/green, Easter pastels, Hacker bright green, Matrix dark green).

---

## 🎨 Theme Showcase

This repository contains **5 unique terminal themes** featuring Matrix-style digital rain animations with custom color schemes, symbols, and alerts for different occasions:

| Theme | Preview | Color Scheme | Best For |
|-------|---------|--------------|----------|
| 🎃 **Halloween** | Spooky orange/black | `#ff6b00` | October vibes |
| 🎄 **Christmas** | Festive red/green | `#ff0000` `#00ff00` | Holiday season |
| 🐰 **Easter** | Pastel rainbow | `#ff69b4` `#87ceeb` `#98fb98` | Spring celebrations |
| 💻 **Hacker** | Bright green cyber | `#00ff00` | r0ry.computer branding |
| 🟢 **Matrix** | Classic green | `#0f0` | Traditional Matrix look |

---

## ✨ Features

- 🌧️ **Matrix Digital Rain** - Authentic falling character animations
- 🎯 **Custom Alerts** - Theme-specific flashing alerts and messages
- 🎨 **Universal Theming** - Works across Windows, macOS, and Linux
- ⚡ **Smart Installation** - Detects your OS and shell automatically
- 🔧 **Multiple Backends** - Starship integration or PTY color injection
- 🖥️ **GUI & CLI** - Desktop app with theme selector + command-line tools
- 📦 **Native Packages** - Available in all major package managers
- 🚀 **Shell Integration** - Works with bash, zsh, fish, PowerShell, and CMD
- 🎭 **Modern Tools** - Enhanced with eza, bat, delta, and more
- 🔌 **Windows Terminal** - Automatic profile and color scheme setup

---

## 📦 Deployment Pipelines

### Complete Installation Matrix

<table>
<thead>
<tr>
<th>Platform</th>
<th>Package Manager</th>
<th>GUI App</th>
<th>Command Line</th>
<th>Native Installer</th>
</tr>
</thead>
<tbody>
<tr>
<td rowspan="6"><b>🐧 Linux</b></td>
<td>APT/Debian</td>
<td><code>sudo apt install rory-terminal</code></td>
<td><code>curl -fsSL https://git.io/rory-terminal | bash</code></td>
<td><a href="https://github.com/RLR-GitHub/terminal-themes/releases">Download .deb</a> <sup>*</sup></td>
</tr>
<tr>
<td>YUM/RPM</td>
<td><code>sudo dnf install rory-terminal</code></td>
<td>Same as above</td>
<td><a href="https://github.com/RLR-GitHub/terminal-themes/releases">Download .rpm</a></td>
</tr>
<tr>
<td>Snap</td>
<td><code>sudo snap install rory-terminal</code></td>
<td>Included in snap</td>
<td>N/A</td>
</tr>
<tr>
<td>Flatpak</td>
<td><code>flatpak install flathub com.rory.Terminal</code></td>
<td>Included in flatpak</td>
<td>N/A</td>
</tr>
<tr>
<td>AppImage</td>
<td>N/A</td>
<td><a href="https://github.com/RLR-GitHub/terminal-themes/releases">Download AppImage</a></td>
<td>N/A</td>
</tr>
<tr>
<td>AUR (Arch)</td>
<td><code>yay -S rory-terminal</code></td>
<td>Same package</td>
<td>N/A</td>
</tr>
<tr>
<td rowspan="3"><b>🍎 macOS</b></td>
<td>Homebrew</td>
<td><code>brew install --cask rory-terminal</code></td>
<td><code>brew install rory-terminal</code></td>
<td>N/A</td>
</tr>
<tr>
<td>MacPorts</td>
<td><code>sudo port install rory-terminal</code></td>
<td>Same package</td>
<td>N/A</td>
</tr>
<tr>
<td>Direct Download</td>
<td><a href="https://github.com/RLR-GitHub/terminal-themes/releases">Download .dmg</a></td>
<td><code>curl -fsSL https://git.io/rory-terminal | bash</code></td>
<td><a href="https://github.com/RLR-GitHub/terminal-themes/releases">Download .pkg</a></td>
</tr>
<tr>
<td rowspan="4"><b>🪟 Windows</b></td>
<td>Winget</td>
<td><code>winget install RoryTerminal</code></td>
<td>Included</td>
<td>N/A</td>
</tr>
<tr>
<td>Chocolatey</td>
<td><code>choco install rory-terminal</code></td>
<td>Included</td>
<td>N/A</td>
</tr>
<tr>
<td>Scoop</td>
<td><code>scoop install rory-terminal</code></td>
<td>Included</td>
<td>N/A</td>
</tr>
<tr>
<td>Direct Download</td>
<td>N/A</td>
<td><code>iwr -useb https://git.io/rory-terminal | iex</code></td>
<td><a href="https://github.com/RLR-GitHub/terminal-themes/releases">Download .msi</a></td>
</tr>
</tbody>
</table>

### 🚀 Quick Install Commands by OS

<details>
<summary><b>🐧 Ubuntu/Debian</b></summary>

```bash
# Option 1: PPA (recommended)
sudo add-apt-repository ppa:rlr-github/terminal-themes
sudo apt update
sudo apt install rory-terminal

# Option 2: Download .deb
wget https://github.com/RLR-GitHub/terminal-themes/releases/download/v3.0.0/rory-terminal_3.0.0_amd64.deb
sudo dpkg -i rory-terminal_3.0.0_amd64.deb

# Option 3: Snap
sudo snap install rory-terminal

# Option 4: Script install
curl -fsSL https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.sh | bash
```
</details>

<details>
<summary><b>🍎 macOS</b></summary>

```bash
# Option 1: Homebrew Cask (GUI app)
brew install --cask rory-terminal

# Option 2: Homebrew Formula (CLI only)
brew install rory-terminal

# Option 3: Download DMG
# Visit: https://github.com/RLR-GitHub/terminal-themes/releases

# Option 4: Script install
curl -fsSL https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.sh | bash
```
</details>

<details>
<summary><b>🪟 Windows</b></summary>

```powershell
# Option 1: Winget (Windows 11/10)
winget install RoryTerminal

# Option 2: Chocolatey
choco install rory-terminal

# Option 3: PowerShell script
iwr -useb https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.ps1 | iex

# Option 4: Download MSI
# Visit: https://github.com/RLR-GitHub/terminal-themes/releases
```
</details>

### 📱 Desktop Integration

All installation methods provide:
- **Desktop shortcuts** - Launch from your applications menu
- **Terminal commands** - Run `rory-terminal` from anywhere
- **Shell integration** - Automatic theme loading
- **GUI theme selector** - Visual theme management

> **Note**: <sup>*</sup> Native installers (.deb, .rpm, .msi) will be available shortly via GitHub Releases. For now, please use the script installation methods or check the [Actions tab](https://github.com/RLR-GitHub/terminal-themes/actions) for build status.

## 📋 Requirements

### Minimum Requirements
- **Windows:** Windows 10+ with PowerShell 5.1+
- **macOS:** macOS 10.14+ with bash 4.0+
- **Linux:** Any modern distribution with bash 4.0+

### Recommended Setup
- **Windows Terminal** (Windows) or **iTerm2** (macOS) or **GNOME Terminal** (Linux)
- **Starship prompt** (auto-installed)
- **256-color support** and **UTF-8 encoding**
- **Nerd Font** (recommended: FiraCode Nerd Font)

---

## 🚀 Quick Start

### One-Line Install

**Unix/Linux/macOS:**
```bash
curl -fsSL https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.sh | bash
```

**Windows PowerShell:**
```powershell
iwr -useb https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.ps1 | iex
```

### GUI Application

- **Windows:** Download from [Microsoft Store](#) or use the MSI installer
- **macOS:** Download from [Mac App Store](#) or use `brew install --cask rory-terminal`
- **Linux:** Install via your package manager or download the AppImage

---

## 📖 Detailed Installation

### Step 1: Download Theme Script

Choose your favorite theme and save it as `~/matrix.sh`:

```bash
# Halloween Theme
curl -o ~/matrix.sh https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/themes/matrix-halloween.sh

# Christmas Theme
curl -o ~/matrix.sh https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/themes/matrix-christmas.sh

# Easter Theme
curl -o ~/matrix.sh https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/themes/matrix-easter.sh

# Hacker Theme
curl -o ~/matrix.sh https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/themes/matrix-hacker.sh

# Matrix Theme
curl -o ~/matrix.sh https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/themes/matrix-classic.sh
```

### Step 2: Make Executable

```bash
chmod +x ~/matrix.sh
```

### Step 3: Configure Bash/Zsh

Add the following to your `~/.bashrc` or `~/.zshrc`:

```bash
# ================================
# Rory's Cyberpunk Terminal Setup
# ================================

# Set terminal title
function set-title() {
    echo -ne "\033]0;$@\007"
}

# System status command
function sys-status() {
    echo -e "\e[1;32m╓───[ SYSTEM STATUS ]──────────────\e[0m"
    echo -e "\e[1;32m╟─\e[0m \e[1;33mUser:\e[0m $(whoami)@$(hostname)"
    echo -e "\e[1;32m╟─\e[0m \e[1;33mUptime:\e[0m $(uptime -p)"
    echo -e "\e[1;32m╟─\e[0m \e[1;33mDisk:\e[0m $(df -h / | awk 'NR==2{print $5}')"
    echo -e "\e[1;32m╙──────────────────────────────────\e[0m"
}

set-title "r0ry.computer"

# Hacker-themed aliases
alias ll='ls -la --color=auto'
alias gitc='git commit -m'
alias hack='echo "Initiating hack sequence..." && sleep 1 && echo "Access granted."'
alias scan='echo "Scanning network..." && ping -c 3 8.8.8.8'
alias matrix='~/matrix.sh'

# Custom cyberpunk prompt
PS1='\[\e[0;32m\]┌──(\[\e[1;31m\]\u@\h\[\e[0;32m\])─[\[\e[0m\]\w\[\e[0;32m\]]\n└──\$ \[\e[0m\]'

# Launch Matrix animation on startup (5-second intro)
~/matrix.sh --init
```

### Step 4: Reload Shell

```bash
source ~/.bashrc  # or source ~/.zshrc
```

---

## 🎮 Usage

### Run Matrix Animation

```bash
# 5-second intro mode (auto-stops)
~/matrix.sh --init

# Infinite mode (press Ctrl+C to exit)
~/matrix.sh

# Or use the alias
matrix
```

### System Commands

```bash
# Display system status
sys-status

# Hacker simulation
hack

# Network scan simulation
scan

# Enhanced directory listing
ll
```

---

## 🎨 Theme Details

### 🎃 Halloween Theme
```bash
Colors: Orange shades (#ff6b00 range)
Symbols: 🎃👻💀🦇🕷️🕸️ + numbers
Alerts: "BOO!", "HAUNTED!", "GHOST DETECTED", "TRICK OR TREAT"
Vibe: Spooky and mysterious
```

### 🎄 Christmas Theme
```bash
Colors: Alternating red/green (#ff0000, #00ff00)
Symbols: 🎄⛄🎅🎁❄️⭐🔔 + numbers
Alerts: "HO HO HO!", "MERRY XMAS!", "SANTA DETECTED", "JINGLE BELLS"
Vibe: Festive and jolly
```

### 🐰 Easter Theme
```bash
Colors: Pastel pink/cyan/green (#ff69b4, #87ceeb, #98fb98)
Symbols: 🐰🥚🐣🌷🌸🦋🌼 + numbers
Alerts: "EGG FOUND!", "BUNNY HOP!", "SPRING TIME", "EASTER JOY"
Vibe: Bright and cheerful
```

### 💻 Hacker Theme
```bash
Colors: Bright green (#00ff00 range)
Symbols: r0ry.computer branding + katakana
Alerts: "ACCESS GRANTED", "BREACH DETECTED", "ROOT ACCESS", "SYSTEM OWNED"
Vibe: Cyberpunk and elite
```

### 🟢 Matrix Theme
```bash
Colors: Classic Matrix green (#0f0 range)
Symbols: Numbers + Japanese katakana characters
Alerts: "SYSTEM ALERT", "BREACH DETECTED", "NODE COMPROMISED", "CODE RED"
Vibe: Original Matrix movie aesthetic
```

---

## ⚙️ Customization

### Modify Symbols

Edit the `SYMBOLS` variable in your chosen script:

```bash
SYMBOLS='your_custom_symbols_here'
```

### Change Alert Messages

Edit the `ALERTS` array:

```bash
ALERTS=("MESSAGE 1" "MESSAGE 2" "MESSAGE 3")
```

### Adjust Animation Speed

Modify the sleep values:

```bash
sleep 0.05  # Faster (lower = faster)
sleep 0.1   # Slower (higher = slower)
```

### Change Colors

Colors use 256-color ANSI codes. Adjust the `color` variable ranges:

```bash
color=$((RANDOM % 6 + 82))  # Green range (82-88)
color=$((RANDOM % 6 + 202)) # Orange range (202-208)
color=$((RANDOM % 6 + 196)) # Red range (196-202)
```

[View 256-color chart](https://www.ditig.com/256-colors-cheat-sheet)

### Customize Alert Frequency

Change the `RANDOM %` values to adjust alert probability:

```bash
(( RANDOM % 10 == 0 )) && alert  # 10% chance (more frequent)
(( RANDOM % 20 == 0 )) && alert  # 5% chance (less frequent)
(( RANDOM % 50 == 0 )) && alert  # 2% chance (rare)
```

---

## 🌐 Interactive Online Demo

Try it live in your browser: [https://rlr-github.github.io/terminal-themes](https://rlr-github.github.io/terminal-themes)

The demo features:
- ✨ Live Matrix rain animations for each theme
- 📋 Platform-specific installation commands
- 🎨 Responsive design with theme-specific styling
- 🎭 Random alert flashing effects
- 🖥️ OS detection for tailored instructions

---

## 🔧 Troubleshooting

### Issue: Emojis don't display correctly

**Solution:** Ensure your terminal supports UTF-8 encoding:
```bash
# Check current locale
locale

# Set UTF-8 locale (add to ~/.bashrc)
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
```

### Issue: Colors look wrong

**Solution:** Verify 256-color support:
```bash
# Test color support
echo $TERM

# Should be 'xterm-256color' or similar
# If not, add to ~/.bashrc:
export TERM=xterm-256color
```

### Issue: Script doesn't stop with Ctrl+C

**Solution:** The `trap` command should handle this. If not working:
```bash
# Force kill the script
pkill -f matrix.sh

# Or use killall
killall matrix.sh
```

### Issue: Animation is too fast/slow

**Solution:** Adjust the `sleep` values in your script:
```bash
# Find these lines and modify the numbers
sleep 0.05  # Make this larger to slow down
sleep 0.1   # Or smaller to speed up
```

### Issue: Script runs but terminal is garbled after exit

**Solution:** The cleanup function should restore the terminal. If not:
```bash
# Manually reset terminal
reset

# Or
stty sane
```

---

## 📁 Repository Structure

```
terminal-themes/
├── README.md                          # This file
├── LICENSE                            # MIT License
├── install.sh                         # Automated installation script
├── themes/
│   ├── matrix-halloween.sh           # 🎃 Halloween theme
│   ├── matrix-christmas.sh           # 🎄 Christmas theme
│   ├── matrix-easter.sh              # 🐰 Easter theme
│   ├── matrix-hacker.sh              # 💻 Hacker theme
│   └── matrix-classic.sh             # 🟢 Classic Matrix theme
├── demo/
│   └── rory-terminal-themes.html     # Interactive HTML showcase
├── docs/
│   ├── CUSTOMIZATION.md              # Advanced customization guide
│   ├── CONTRIBUTING.md               # Contribution guidelines
│   └── CHANGELOG.md                  # Version history
└── assets/
    ├── screenshots/                   # Theme screenshots
    └── demos/                         # GIF demonstrations
```

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/NewTheme`)
3. **Commit** your changes (`git commit -m 'Add Valentine's Day theme'`)
4. **Push** to the branch (`git push origin feature/NewTheme`)
5. **Open** a Pull Request

### Ideas for New Themes:
- 💝 Valentine's Day (pink/red hearts)
- 🎆 New Year's (gold/silver fireworks)
- 🍀 St. Patrick's Day (green clovers)
- 🎃 Thanksgiving (autumn colors)
- 🏳️‍🌈 Pride (rainbow colors)
- 🌊 Ocean (blue/teal waves)
- 🔥 Fire (red/orange flames)
- 🌙 Night Sky (purple/blue stars)

---

## 📝 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2024 Roderick Lawrence Renwick

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 👤 Author

**Roderick Lawrence Renwick (Rory)**

- 🌐 Website: [r0ry.com](https://r0ry.com) | [rlr.dev](https://rlr.dev)
- 💼 GitHub: [@RLR-GitHub](https://github.com/RLR-GitHub)
- 📧 Email: rodericklrenwick@gmail.com
- 🎓 MSECE @ Purdue University
- 🔬 Interests: Computer Vision & Machine Learning

---

## 🙏 Acknowledgments

- Inspired by the **Matrix** movie franchise (1999)
- Built with pure **Bash** scripting
- Terminal rendering using **ANSI escape codes**
- Special thanks to the open-source community

---

## 📊 Stats

![GitHub stars](https://img.shields.io/github/stars/RLR-GitHub/terminal-themes?style=social)
![GitHub forks](https://img.shields.io/github/forks/RLR-GitHub/terminal-themes?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/RLR-GitHub/terminal-themes?style=social)

---

## 🎯 Roadmap

- [x] Core Matrix rain animation
- [x] 5 initial themes (Halloween, Christmas, Easter, Hacker, Matrix)
- [x] Interactive HTML demo page
- [x] Comprehensive documentation
- [x] Automated install script (bash & PowerShell)
- [x] Package manager support (Homebrew, apt, Chocolatey, etc.)
- [x] Windows native support (PowerShell)
- [x] Cross-platform GUI application
- [x] Desktop integration (all platforms)
- [x] Shell completion support
- [x] Starship prompt integration
- [x] PTY wrapper for advanced theming
- [ ] More holiday themes
- [ ] Cloud sync for settings
- [ ] Theme marketplace
- [ ] AI-powered theme generation

---

## 💬 Support

If you found this project helpful, please consider:

- ⭐ **Starring** the repository
- 🐛 **Reporting** bugs and issues
- 💡 **Suggesting** new features
- 📢 **Sharing** with friends and colleagues

---

<div align="center">

**Made with ❤️ by Rory**

*Transform your terminal. Elevate your coding experience.*

[⬆ Back to Top](#-rorys-terminal-theme-collection)

</div>
