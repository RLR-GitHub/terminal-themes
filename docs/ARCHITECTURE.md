# Architecture Guide

Rory Terminal Themes uses a modular architecture that supports two distinct approaches for terminal customization across Windows, macOS, and Linux platforms.

## Overview

The project is designed around two installation options:

1. **Option #1: Starship (Simple)** - Modern, cross-platform prompt with theme integration
2. **Option #2: PTY Shim (Advanced)** - Deep output interception with custom color injection

## Directory Structure

```
terminal-themes/
├── core/                         # Core modules
│   ├── option1-starship/         # Starship integration
│   └── option2-pty-shim/         # PTY wrapper
├── themes/                       # Theme implementations
│   ├── bash/                     # Bash Matrix animations
│   ├── powershell/               # PowerShell Matrix animations
│   ├── starship/                 # Starship .toml configs
│   ├── cmd/                      # CMD support (limited)
│   └── universal/                # Cross-platform configs
├── installers/                   # Installation scripts
│   ├── install.sh                # Unix installer
│   ├── install.ps1               # Windows installer
│   ├── install.cmd               # CMD wrapper
│   └── native/                   # Native packages
├── docs/                         # Documentation
├── demo/                         # Web demo
└── config/                       # Configuration files
```

## Option #1: Starship Architecture

### Components

1. **Starship Integration (`starship-integration.sh`)**
   - Detects OS and package manager
   - Installs Starship via package manager or official installer
   - Configures shell (bash/zsh/fish)
   - Manages theme switching

2. **Modern Tools (`modern-tools.sh`)**
   - Installs eza (ls replacement)
   - Installs bat (cat replacement)
   - Installs delta (git diff)
   - Configures aliases

3. **ZSH Plugins (`zsh-plugins.sh`)**
   - Syntax highlighting
   - Autosuggestions
   - Shell integration

4. **Theme Manager (`theme-manager.sh`)**
   - Lists available themes
   - Switches active theme
   - Runs Matrix animations
   - Manages configuration

### Data Flow

```
User Command → Shell → Starship → Theme Config → Styled Prompt
              ↓
         Modern Tools → Enhanced Output
```

### Configuration

- User config: `~/.config/rory-terminal/config.json`
- Starship config: `~/.config/starship.toml`
- Current theme: `~/.config/rory-terminal/current-theme`

## Option #2: PTY Shim Architecture

### Components

1. **PTY Wrapper (`pty-wrapper.c`)**
   - C program that creates pseudoterminal
   - Intercepts I/O between command and terminal
   - Applies color rules in real-time
   - Platform-specific (Linux/macOS only)

2. **Color Rules (`color-rules.json`)**
   - Pattern matching configuration
   - Theme-specific color mappings
   - Command-specific rules
   - Regex-based transformations

3. **Command Hooks (`command-hooks.sh`)**
   - Pre-command execution
   - Post-command status
   - Duration tracking
   - Git integration

4. **Output Parser (`output-parser.sh`)**
   - Command-specific parsers
   - Pattern colorization
   - Streaming transformation

### Data Flow

```
User Command → PTY Wrapper → Command Execution
                    ↓
              Output Stream → Color Injection → Terminal Display
                    ↓
              Hooks (pre/post)
```

### Compilation

```bash
cd core/option2-pty-shim
make
sudo make install
```

Installs to:
- `/usr/local/bin/pty-wrapper`
- `/usr/local/bin/rory-terminal-hooks`
- `/usr/local/bin/rory-terminal-parser`

## Platform Implementations

### macOS
- **Package Manager**: Homebrew preferred
- **Shells**: bash, zsh (default)
- **Terminal**: Terminal.app, iTerm2
- **Native Package**: .pkg installer

### Linux
- **Package Managers**: apt, dnf, pacman, zypper
- **Shells**: bash, zsh, fish
- **Terminals**: GNOME Terminal, Alacritty, kitty
- **Native Packages**: .deb, .rpm, AppImage

### Windows
- **Package Managers**: winget, scoop, chocolatey
- **Shells**: PowerShell 5.1+, PowerShell 7+
- **Terminal**: Windows Terminal (recommended), PowerShell ISE
- **Native Package**: .msi installer
- **Note**: PTY shim not supported on Windows

## Theme System

Each theme consists of:

1. **Bash Script** (`themes/bash/matrix-{theme}.sh`)
   - Matrix rain animation
   - Theme-specific colors and symbols
   - Alert messages
   - `--init` mode for startup

2. **PowerShell Script** (`themes/powershell/Matrix-{Theme}.ps1`)
   - Windows equivalent of bash version
   - PowerShell-specific APIs
   - Same visual style

3. **Starship Config** (`themes/starship/{theme}.toml`)
   - Prompt configuration
   - Color palette
   - Module styling
   - Git integration

### Theme Colors

Each theme defines:
- Primary color (main accent)
- Secondary color (secondary elements)
- Accent color (highlights)
- Error color (errors/failures)
- Success color (success/completion)

## Installation Flow

### Unix (Linux/macOS)

```
install.sh → Detect OS/Shell
          → Select Option (Starship/PTY/Matrix-only)
          → Select Theme
          → Install Dependencies
          → Configure Shell
          → Complete
```

### Windows

```
install.ps1 → Check PowerShell Version
           → Check Windows Terminal
           → Select Option (Starship/Matrix-only)
           → Select Theme
           → Install Starship (if option 1)
           → Configure Profile
           → Complete
```

## Configuration Files

### User Configuration

`~/.config/rory-terminal/config.json`:
```json
{
  "version": "3.0.0",
  "active_theme": "hacker",
  "install_option": "starship",
  "platform": "macos",
  "shell": "zsh"
}
```

### Theme Registry

`config/themes.json`:
```json
{
  "themes": {
    "halloween": {...},
    "christmas": {...},
    "easter": {...},
    "hacker": {...},
    "matrix": {...}
  }
}
```

## Extension Points

### Adding New Themes

1. Create bash script: `themes/bash/matrix-{name}.sh`
2. Create PowerShell script: `themes/powershell/Matrix-{Name}.ps1`
3. Create Starship config: `themes/starship/{name}.toml`
4. Update theme manager metadata
5. Update documentation

### Adding New Platforms

1. Create platform-specific installer
2. Add platform detection
3. Implement theme scripts
4. Update documentation
5. Test thoroughly

## Performance Considerations

### Option #1 (Starship)
- Fast: ~1-5ms prompt latency
- Minimal overhead
- Async git operations

### Option #2 (PTY Shim)
- Moderate: ~1-2ms per command
- Pattern matching overhead
- Real-time processing

## Security Considerations

- All scripts should be reviewed before installation
- Native packages can be signed
- User-level installation preferred
- No root required for basic installation
- PTY wrapper requires compilation from source

## Future Architecture

Planned improvements:
- Plugin system for custom themes
- Configuration GUI
- Cloud theme sync
- Performance profiling
- Windows PTY support (if possible)

