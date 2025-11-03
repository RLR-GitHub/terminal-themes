# Rory Terminal Themes - Windows PowerShell Installer
# Universal installer for Windows with PowerShell

param(
    [string]$Theme = "",
    [switch]$Uninstall
)

$ErrorActionPreference = "Stop"
$Version = "3.0.0"
$RepoUrl = "https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main"
$InstallDir = "$env:LOCALAPPDATA\RoryTerminal"
$ProfilePath = $PROFILE.CurrentUserCurrentHost

# Colors for output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Type = "Info"
    )
    
    switch ($Type) {
        "Success" { Write-Host "✓ $Message" -ForegroundColor Green }
        "Error"   { Write-Host "✗ $Message" -ForegroundColor Red }
        "Warning" { Write-Host "⚠ $Message" -ForegroundColor Yellow }
        "Step"    { Write-Host "==> $Message" -ForegroundColor Blue }
        "Info"    { Write-Host "ℹ $Message" -ForegroundColor Cyan }
        default   { Write-Host $Message }
    }
}

# Print banner
function Show-Banner {
    Clear-Host
    Write-Host @"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║     ██████╗  ██████╗ ██████╗ ██╗   ██╗                   ║
║     ██╔══██╗██╔═══██╗██╔══██╗╚██╗ ██╔╝                   ║
║     ██████╔╝██║   ██║██████╔╝ ╚████╔╝                    ║
║     ██╔══██╗██║   ██║██╔══██╗  ╚██╔╝                     ║
║     ██║  ██║╚██████╔╝██║  ██║   ██║                      ║
║     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝                      ║
║                                                           ║
║           Terminal Themes Collection v3.0                 ║
║              Windows Installation                         ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan
    Write-Host ""
}

# Check requirements
function Test-Requirements {
    Write-ColorOutput "Checking system requirements..." "Step"
    
    # Check PowerShell version
    $psVersion = $PSVersionTable.PSVersion
    Write-ColorOutput "PowerShell: $psVersion" "Info"
    
    if ($psVersion.Major -lt 5) {
        Write-ColorOutput "PowerShell 5.0+ required. Please upgrade." "Error"
        exit 1
    }
    Write-ColorOutput "PowerShell version OK" "Success"
    
    # Check for Windows Terminal
    $hasWindowsTerminal = Get-Command wt.exe -ErrorAction SilentlyContinue
    if ($hasWindowsTerminal) {
        Write-ColorOutput "Windows Terminal detected" "Success"
    } else {
        Write-ColorOutput "Windows Terminal not found (optional)" "Warning"
    }
    
    # Check for package managers
    $hasWinget = Get-Command winget -ErrorAction SilentlyContinue
    $hasScoop = Get-Command scoop -ErrorAction SilentlyContinue
    $hasChoco = Get-Command choco -ErrorAction SilentlyContinue
    
    if ($hasWinget) {
        Write-ColorOutput "Package manager: winget" "Info"
        $script:PackageManager = "winget"
    } elseif ($hasScoop) {
        Write-ColorOutput "Package manager: scoop" "Info"
        $script:PackageManager = "scoop"
    } elseif ($hasChoco) {
        Write-ColorOutput "Package manager: chocolatey" "Info"
        $script:PackageManager = "choco"
    } else {
        Write-ColorOutput "No package manager found (optional)" "Warning"
        $script:PackageManager = "none"
    }
    
    Write-Host ""
}

# Select installation option
function Select-InstallOption {
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Magenta
    Write-Host "║        Choose Installation Option            ║" -ForegroundColor Magenta
    Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "  1) " -NoNewline -ForegroundColor Yellow
    Write-Host "Simple (Recommended)" -ForegroundColor Green
    Write-Host "     Starship prompt with modern tools"
    Write-Host "     ✓ Easy setup"
    Write-Host "     ✓ Cross-platform"
    Write-Host ""
    Write-Host "  2) " -NoNewline -ForegroundColor Yellow
    Write-Host "Matrix Only" -ForegroundColor Blue
    Write-Host "     Just PowerShell Matrix animations"
    Write-Host "     ✓ Lightweight"
    Write-Host "     ✓ No dependencies"
    Write-Host ""
    
    $choice = Read-Host "Enter choice [1-2] (default: 1)"
    if ([string]::IsNullOrWhiteSpace($choice)) { $choice = "1" }
    
    switch ($choice) {
        "1" {
            Write-ColorOutput "Selected: Starship (Simple)" "Success"
            return "starship"
        }
        "2" {
            Write-ColorOutput "Selected: Matrix Only" "Success"
            return "matrix-only"
        }
        default {
            Write-ColorOutput "Invalid option. Defaulting to Simple." "Warning"
            return "starship"
        }
    }
}

# Select theme
function Select-Theme {
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Magenta
    Write-Host "║             Choose Your Theme                 ║" -ForegroundColor Magenta
    Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "  1) 🎃 " -NoNewline -ForegroundColor Yellow
    Write-Host "Halloween   " -NoNewline -ForegroundColor Yellow
    Write-Host "- Spooky orange/black"
    Write-Host "  2) 🎄 " -NoNewline -ForegroundColor Yellow
    Write-Host "Christmas   " -NoNewline -ForegroundColor Green
    Write-Host "- Festive red/green"
    Write-Host "  3) 🐰 " -NoNewline -ForegroundColor Yellow
    Write-Host "Easter      " -NoNewline -ForegroundColor Magenta
    Write-Host "- Pastel rainbow"
    Write-Host "  4) 💻 " -NoNewline -ForegroundColor Yellow
    Write-Host "Hacker      " -NoNewline -ForegroundColor Cyan
    Write-Host "- Bright green cyber"
    Write-Host "  5) 🟢 " -NoNewline -ForegroundColor Yellow
    Write-Host "Matrix      " -NoNewline -ForegroundColor Green
    Write-Host "- Classic green"
    Write-Host ""
    
    $choice = Read-Host "Enter choice [1-5] (default: 4)"
    if ([string]::IsNullOrWhiteSpace($choice)) { $choice = "4" }
    
    switch ($choice) {
        "1" { return @{Name="Halloween"; Key="halloween"} }
        "2" { return @{Name="Christmas"; Key="christmas"} }
        "3" { return @{Name="Easter"; Key="easter"} }
        "4" { return @{Name="Hacker"; Key="hacker"} }
        "5" { return @{Name="Matrix"; Key="matrix"} }
        default {
            Write-ColorOutput "Invalid choice. Defaulting to Hacker." "Warning"
            return @{Name="Hacker"; Key="hacker"}
        }
    }
}

# Install Starship
function Install-Starship {
    Write-ColorOutput "Installing Starship..." "Step"
    
    if (Get-Command starship -ErrorAction SilentlyContinue) {
        Write-ColorOutput "Starship already installed" "Success"
        return
    }
    
    switch ($script:PackageManager) {
        "winget" {
            winget install --id Starship.Starship -e --silent
        }
        "scoop" {
            scoop install starship
        }
        "choco" {
            choco install starship -y
        }
        default {
            # Manual install
            Write-ColorOutput "Installing via official installer..." "Info"
            Invoke-Expression (Invoke-WebRequest -Uri "https://starship.rs/install.ps1" -UseBasicParsing).Content
        }
    }
    
    if (Get-Command starship -ErrorAction SilentlyContinue) {
        Write-ColorOutput "Starship installed successfully" "Success"
    } else {
        Write-ColorOutput "Starship installation may have failed" "Warning"
    }
}

# Create directories
function Initialize-Directories {
    Write-ColorOutput "Creating directories..." "Step"
    
    if (-not (Test-Path $InstallDir)) {
        New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    }
    
    Write-ColorOutput "Directories created" "Success"
}

# Download file
function Get-RemoteFile {
    param(
        [string]$Url,
        [string]$Destination
    )
    
    try {
        Invoke-WebRequest -Uri $Url -OutFile $Destination -UseBasicParsing
        return $true
    } catch {
        Write-ColorOutput "Failed to download: $Url" "Error"
        return $false
    }
}

# Install Starship option
function Install-StarshipOption {
    param([hashtable]$ThemeInfo)
    
    Write-ColorOutput "Installing Starship + Themes..." "Step"
    
    Install-Starship
    
    # Download Starship config
    $configUrl = "$RepoUrl/themes/starship/$($ThemeInfo.Key).toml"
    $configPath = "$env:USERPROFILE\.config\starship.toml"
    
    # Create .config directory if needed
    $configDir = Split-Path $configPath
    if (-not (Test-Path $configDir)) {
        New-Item -ItemType Directory -Path $configDir -Force | Out-Null
    }
    
    if (Get-RemoteFile -Url $configUrl -Destination $configPath) {
        Write-ColorOutput "Starship theme configured" "Success"
    }
    
    # Save theme info
    $ThemeInfo.Key | Out-File "$InstallDir\current-theme.txt"
}

# Install Matrix only option
function Install-MatrixOnlyOption {
    param([hashtable]$ThemeInfo)
    
    Write-ColorOutput "Installing Matrix animations..." "Step"
    
    $scriptUrl = "$RepoUrl/themes/powershell/Matrix-$($ThemeInfo.Name).ps1"
    $scriptPath = "$InstallDir\Matrix.ps1"
    
    if (Get-RemoteFile -Url $scriptUrl -Destination $scriptPath) {
        Write-ColorOutput "Matrix animation installed" "Success"
    }
    
    # Save theme info
    $ThemeInfo.Key | Out-File "$InstallDir\current-theme.txt"
}

# Configure PowerShell profile
function Set-PowerShellProfile {
    param(
        [string]$Option,
        [hashtable]$ThemeInfo
    )
    
    Write-ColorOutput "Configuring PowerShell profile..." "Step"
    
    # Backup existing profile
    if (Test-Path $ProfilePath) {
        $backup = "${ProfilePath}.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Copy-Item $ProfilePath $backup
        Write-ColorOutput "Backup created: $backup" "Info"
    } else {
        # Create profile directory if it doesn't exist
        $profileDir = Split-Path $ProfilePath
        if (-not (Test-Path $profileDir)) {
            New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
        }
    }
    
    # Check if already configured
    if (Test-Path $ProfilePath) {
        $content = Get-Content $ProfilePath -Raw
        if ($content -match "# Rory Terminal") {
            Write-ColorOutput "Profile already configured. Skipping..." "Warning"
            return
        }
    }
    
    # Add configuration
    $config = @"

# ================================
# Rory Terminal Themes
# ================================
`$env:RORY_THEME = "$($ThemeInfo.Key)"

"@
    
    if ($Option -eq "starship") {
        $config += @"
# Initialize Starship
Invoke-Expression (&starship init powershell)

# Aliases for theme management
function Set-RoryTheme { param([string]`$Theme) `$env:RORY_THEME = `$Theme }
function Get-RoryTheme { `$env:RORY_THEME }

"@
    } elseif ($Option -eq "matrix-only") {
        $config += @"
# Matrix animation alias
function Invoke-Matrix { & "$InstallDir\Matrix.ps1" @args }
Set-Alias -Name matrix -Value Invoke-Matrix

"@
    }
    
    Add-Content -Path $ProfilePath -Value $config
    Write-ColorOutput "PowerShell profile configured" "Success"
}

# Configure Windows Terminal
function Set-WindowsTerminal {
    param([hashtable]$ThemeInfo)
    
    $wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    
    if (-not (Test-Path $wtSettingsPath)) {
        Write-ColorOutput "Windows Terminal settings not found. Skipping integration." "Warning"
        return
    }
    
    Write-ColorOutput "Windows Terminal integration available" "Info"
    Write-Host "  To customize, edit: $wtSettingsPath"
}

# Print completion message
function Show-Completion {
    param(
        [string]$Option,
        [hashtable]$ThemeInfo
    )
    
    Write-Host ""
    Write-Host "╔═══════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                                                       ║" -ForegroundColor Green
    Write-Host "║         Installation Complete! 🎉                    ║" -ForegroundColor Green
    Write-Host "║                                                       ║" -ForegroundColor Green
    Write-Host "╚═══════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  1. Restart PowerShell or run:"
    Write-Host "     . `$PROFILE" -ForegroundColor Yellow
    Write-Host ""
    
    if ($Option -eq "starship") {
        Write-Host "  2. Available commands:" -ForegroundColor Cyan
        Write-Host "     Get-RoryTheme" -ForegroundColor Yellow
        Write-Host "     Set-RoryTheme <theme>" -ForegroundColor Yellow
        Write-Host ""
    } elseif ($Option -eq "matrix-only") {
        Write-Host "  2. Run Matrix animation:" -ForegroundColor Cyan
        Write-Host "     matrix" -ForegroundColor Yellow
        Write-Host "     matrix -Init" -ForegroundColor Yellow
        Write-Host ""
    }
    
    Write-Host "Documentation:" -ForegroundColor Cyan
    Write-Host "  https://github.com/RLR-GitHub/terminal-themes"
    Write-Host ""
    Write-Host "Enjoy your cyberpunk terminal! 🚀" -ForegroundColor Green
    Write-Host ""
}

# Uninstall function
function Remove-RoryTerminal {
    Write-ColorOutput "Uninstalling Rory Terminal Themes..." "Step"
    
    # Remove files
    if (Test-Path $InstallDir) {
        Remove-Item -Path $InstallDir -Recurse -Force
        Write-ColorOutput "Installation directory removed" "Success"
    }
    
    # Remove from profile
    if (Test-Path $ProfilePath) {
        $content = Get-Content $ProfilePath -Raw
        $pattern = "(?s)# ================================\s*# Rory Terminal.*?(?=\r?\n(?:# ====|$))"
        $newContent = $content -replace $pattern, ""
        $newContent | Set-Content $ProfilePath
        Write-ColorOutput "Profile configuration removed" "Success"
    }
    
    Write-Host ""
    Write-ColorOutput "Uninstall complete. Restart PowerShell for changes to take effect." "Success"
}

# Main installation flow
function Start-Installation {
    Show-Banner
    
    if ($Uninstall) {
        Remove-RoryTerminal
        return
    }
    
    Test-Requirements
    
    $option = Select-InstallOption
    $themeInfo = Select-Theme
    
    Initialize-Directories
    
    switch ($option) {
        "starship" {
            Install-StarshipOption -ThemeInfo $themeInfo
        }
        "matrix-only" {
            Install-MatrixOnlyOption -ThemeInfo $themeInfo
        }
    }
    
    Set-PowerShellProfile -Option $option -ThemeInfo $themeInfo
    Set-WindowsTerminal -ThemeInfo $themeInfo
    
    # Save installation info
    @{
        Date = Get-Date
        Version = $Version
        Option = $option
        Theme = $themeInfo.Key
        PowerShellVersion = $PSVersionTable.PSVersion
    } | ConvertTo-Json | Out-File "$InstallDir\install-info.json"
    
    Show-Completion -Option $option -ThemeInfo $themeInfo
}

# Run installation
Start-Installation

