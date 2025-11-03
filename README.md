# 🌈 Rory's Terminal Theme Collection

<div align="center">

![Version](https://img.shields.io/badge/version-3.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Bash](https://img.shields.io/badge/bash-4.0%2B-orange)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS-lightgrey)

**Transform your terminal into an immersive cyberpunk experience with Matrix-style animations**

[View Demo](https://github.com/RLR-GitHub/terminal-themes) • [Report Bug](https://github.com/RLR-GitHub/terminal-themes/issues) • [Request Feature](https://github.com/RLR-GitHub/terminal-themes/issues)

</div>

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
- 🎨 **256-Color Support** - Rich terminal colors using ANSI escape codes
- ⚡ **Lightweight** - Pure bash with no external dependencies
- 🔧 **Customizable** - Easy to modify symbols, colors, and speeds
- 🖥️ **Cross-Platform** - Works on Linux, macOS, and WSL
- 🚀 **Startup Integration** - Auto-launch on terminal startup
- 🎭 **Multiple Modes** - Brief intro mode (`--init`) or infinite mode

---

## 📋 Requirements

- **Bash 4.0+** (check with `bash --version`)
- **Terminal** with 256-color support (most modern terminals)
- **UTF-8** character encoding (for emoji and katakana support)

### Recommended Terminals
- ✅ iTerm2 (macOS)
- ✅ GNOME Terminal (Linux)
- ✅ Terminator (Linux)
- ✅ Windows Terminal (Windows)
- ✅ Alacritty (All platforms)
- ✅ kitty (All platforms)

---

## 🚀 Quick Start

### One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/install.sh | bash
```

### Manual Installation

1. **Clone the repository**
```bash
git clone https://github.com/RLR-GitHub/terminal-themes.git
cd terminal-themes
```

2. **Choose your theme and copy the script**
```bash
# Example: Halloween theme
cp themes/matrix-halloween.sh ~/matrix.sh
chmod +x ~/matrix.sh
```

3. **Add to your shell configuration**

For **bash** users, add to `~/.bashrc`:
```bash
echo '~/matrix.sh --init' >> ~/.bashrc
```

For **zsh** users, add to `~/.zshrc`:
```bash
echo '~/matrix.sh --init' >> ~/.zshrc
```

4. **Reload your shell**
```bash
source ~/.bashrc  # or source ~/.zshrc
```

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

## 🌐 Interactive HTML Demo

This repository includes an interactive HTML preview page that showcases all themes with live animations:

```bash
# Open the demo in your browser
open demo/rory-terminal-themes.html

# Or start a local server
cd demo
python3 -m http.server 8000
# Visit http://localhost:8000/rory-terminal-themes.html
```

The demo page features:
- ✨ Live Matrix rain animations for each theme
- 📋 One-click copy buttons for all bash scripts
- 🎨 Responsive design with theme-specific styling
- 🎭 Random alert flashing effects

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
- [ ] Automated install script
- [ ] Package manager support (Homebrew, apt)
- [ ] More holiday themes
- [ ] Color scheme customization wizard
- [ ] Terminal recording/GIF generation
- [ ] Windows native support (PowerShell)
- [ ] Configuration file support (~/.matrixrc)
- [ ] Plugin system for custom themes
- [ ] Performance optimizations for large terminals

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
