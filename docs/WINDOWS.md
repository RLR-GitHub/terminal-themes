# Windows Installation Guide

Complete guide for installing Rory Terminal Themes on Windows.

## Quick Install

### One-Line Install (PowerShell)
```powershell
iwr -useb https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.ps1 | iex
```

### Manual Install
1. Download `install.ps1`
2. Run: `powershell -ExecutionPolicy Bypass -File install.ps1`

## Requirements

- **Windows 10/11** (recommended)
- **PowerShell 5.1+** (PowerShell 7+ recommended)
- **Windows Terminal** (optional but recommended)

### Check PowerShell Version
```powershell
$PSVersionTable.PSVersion
```

## Installation Options

### Option 1: Starship (Recommended)
Modern cross-platform prompt with theme support.

**Installs:**
- Starship prompt
- Theme configurations
- PowerShell profile integration

**Best for:**
- Daily use
- Professional environments
- Cross-platform consistency

### Option 2: Matrix Only
Just the Matrix rain animations.

**Installs:**
- PowerShell Matrix scripts
- Basic theme support

**Best for:**
- Minimal installation
- Fun animations only

## Post-Installation

### Reload Profile
```powershell
. $PROFILE
```

### Check Installation
```powershell
Get-Command starship
$env:RORY_THEME
```

## Windows Terminal Integration

### Recommended Settings

1. Open Windows Terminal Settings (Ctrl+,)
2. Choose your profile (PowerShell)
3. Appearance → Color scheme → (choose compatible scheme)
4. Appearance → Font face → "Cascadia Code NF" or "FiraCode Nerd Font"

### Install Nerd Fonts

```powershell
# Via scoop
scoop bucket add nerd-fonts
scoop install FiraCode-NF

# Or download from
# https://www.nerdfonts.com/
```

## Package Managers

### winget
```powershell
winget install Starship.Starship
```

### Scoop
```powershell
scoop install starship
```

### Chocolatey
```powershell
choco install starship
```

## Themes

### List Themes
```powershell
Get-RoryTheme
```

### Change Theme
```powershell
Set-RoryTheme halloween
Set-RoryTheme christmas
Set-RoryTheme easter
Set-RoryTheme hacker
Set-RoryTheme matrix
```

### Run Matrix Animation
```powershell
matrix
matrix -Init  # 5-second intro
```

## Troubleshooting

### Execution Policy Error
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Profile Not Loading
Check profile location:
```powershell
$PROFILE
Test-Path $PROFILE
```

Create if missing:
```powershell
New-Item -Path $PROFILE -Type File -Force
```

### Starship Not Found
Ensure PATH includes Starship:
```powershell
$env:PATH -split ';' | Select-String starship
```

Add to PATH if needed:
```powershell
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\starship\bin", "User")
```

### Colors Not Showing
Enable ANSI colors:
```powershell
Set-ItemProperty HKCU:\Console VirtualTerminalLevel -Type DWORD 1
```

## Uninstallation

### Via Installer
```powershell
.\install.ps1 -Uninstall
```

### Manual Uninstall
1. Remove installation directory:
   ```powershell
   Remove-Item "$env:LOCALAPPDATA\RoryTerminal" -Recurse -Force
   ```

2. Remove from profile:
   Edit `$PROFILE` and remove Rory Terminal section

3. Restart PowerShell

## Advanced Configuration

### Custom Profile Integration

Add to `$PROFILE`:
```powershell
# Rory Terminal Custom Configuration
$env:RORY_THEME = "hacker"

# Custom aliases
function matrix-loop { 
    while ($true) { 
        & "$env:LOCALAPPDATA\RoryTerminal\Matrix.ps1"
    }
}

# Custom prompt
Invoke-Expression (&starship init powershell)
```

### Windows Terminal Custom Color Scheme

Add to `settings.json`:
```json
{
  "schemes": [
    {
      "name": "RoryHacker",
      "background": "#0a1a0a",
      "foreground": "#00ff00",
      "black": "#000000",
      "red": "#ff0000",
      "green": "#00ff00",
      "yellow": "#ffff00",
      "blue": "#0000ff",
      "purple": "#ff00ff",
      "cyan": "#00ffff",
      "white": "#ffffff",
      "brightBlack": "#555555",
      "brightRed": "#ff5555",
      "brightGreen": "#55ff55",
      "brightYellow": "#ffff55",
      "brightBlue": "#5555ff",
      "brightPurple": "#ff55ff",
      "brightCyan": "#55ffff",
      "brightWhite": "#ffffff"
    }
  ]
}
```

## Performance Tips

1. Use PowerShell 7+ for better performance
2. Install Windows Terminal for best experience
3. Use SSD for faster script loading
4. Close unnecessary background processes

## Known Limitations

- PTY shim (Option #2) not available on Windows
- Some emojis require specific fonts
- CMD has limited color support (use PowerShell)

## Support

- GitHub Issues: https://github.com/RLR-GitHub/terminal-themes/issues
- Documentation: https://github.com/RLR-GitHub/terminal-themes
- Email: rodericklrenwick@gmail.com

