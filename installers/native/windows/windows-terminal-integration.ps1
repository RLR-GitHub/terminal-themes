# Windows Terminal Integration Script
# Automatically detects and configures Windows Terminal with Rory themes

param(
    [string]$Action = "install",
    [string]$Theme = "hacker"
)

$ErrorActionPreference = "Stop"

# Color schemes for Windows Terminal
$ColorSchemes = @{
    halloween = @{
        name = "Rory Halloween"
        background = "#1a0f00"
        foreground = "#ff6b00"
        black = "#000000"
        red = "#ff0000"
        green = "#00ff00"
        yellow = "#ffaa00"
        blue = "#ff6b00"
        purple = "#ff8800"
        cyan = "#ff9900"
        white = "#ffffff"
        brightBlack = "#666666"
        brightRed = "#ff3333"
        brightGreen = "#33ff33"
        brightYellow = "#ffcc00"
        brightBlue = "#ff8800"
        brightPurple = "#ff9900"
        brightCyan = "#ffaa00"
        brightWhite = "#ffffff"
        cursorColor = "#ff6b00"
        selectionBackground = "#ff6b0066"
    }
    christmas = @{
        name = "Rory Christmas"
        background = "#0f1a0f"
        foreground = "#00ff00"
        black = "#000000"
        red = "#ff0000"
        green = "#00ff00"
        yellow = "#ffff00"
        blue = "#0000ff"
        purple = "#ff00ff"
        cyan = "#00ffff"
        white = "#ffffff"
        brightBlack = "#666666"
        brightRed = "#ff6666"
        brightGreen = "#66ff66"
        brightYellow = "#ffff66"
        brightBlue = "#6666ff"
        brightPurple = "#ff66ff"
        brightCyan = "#66ffff"
        brightWhite = "#ffffff"
        cursorColor = "#ff0000"
        selectionBackground = "#00ff0066"
    }
    easter = @{
        name = "Rory Easter"
        background = "#1a0f1a"
        foreground = "#ff69b4"
        black = "#000000"
        red = "#ff0000"
        green = "#98fb98"
        yellow = "#ffff00"
        blue = "#87ceeb"
        purple = "#ff69b4"
        cyan = "#87ceeb"
        white = "#ffffff"
        brightBlack = "#666666"
        brightRed = "#ff6666"
        brightGreen = "#b8ffb8"
        brightYellow = "#ffff66"
        brightBlue = "#a7deeb"
        brightPurple = "#ff89d4"
        brightCyan = "#a7deeb"
        brightWhite = "#ffffff"
        cursorColor = "#ff69b4"
        selectionBackground = "#ff69b466"
    }
    hacker = @{
        name = "Rory Hacker"
        background = "#0a1a0a"
        foreground = "#00ff00"
        black = "#000000"
        red = "#ff0000"
        green = "#00ff00"
        yellow = "#ffff00"
        blue = "#0000ff"
        purple = "#ff00ff"
        cyan = "#00ffff"
        white = "#ffffff"
        brightBlack = "#555555"
        brightRed = "#ff5555"
        brightGreen = "#55ff55"
        brightYellow = "#ffff55"
        brightBlue = "#5555ff"
        brightPurple = "#ff55ff"
        brightCyan = "#55ffff"
        brightWhite = "#ffffff"
        cursorColor = "#00ff00"
        selectionBackground = "#00ff0066"
    }
    matrix = @{
        name = "Rory Matrix"
        background = "#001a00"
        foreground = "#0f0"
        black = "#000000"
        red = "#f00"
        green = "#0f0"
        yellow = "#ff0"
        blue = "#00f"
        purple = "#f0f"
        cyan = "#0ff"
        white = "#fff"
        brightBlack = "#555"
        brightRed = "#f55"
        brightGreen = "#5f5"
        brightYellow = "#ff5"
        brightBlue = "#55f"
        brightPurple = "#f5f"
        brightCyan = "#5ff"
        brightWhite = "#fff"
        cursorColor = "#0f0"
        selectionBackground = "#0f066"
    }
}

# Find Windows Terminal settings
function Find-WindowsTerminalSettings {
    $possiblePaths = @(
        "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
        "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
    )
    
    foreach ($path in $possiblePaths) {
        if (Test-Path $path) {
            return $path
        }
    }
    
    return $null
}

# Backup settings file
function Backup-Settings {
    param([string]$SettingsPath)
    
    $backupPath = "$SettingsPath.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item $SettingsPath $backupPath
    Write-Host "Backup created: $backupPath" -ForegroundColor Green
    return $backupPath
}

# Install color schemes
function Install-ColorSchemes {
    param(
        [string]$SettingsPath,
        [hashtable]$Settings
    )
    
    Write-Host "Installing Rory color schemes..." -ForegroundColor Blue
    
    # Ensure schemes array exists
    if (-not $Settings.schemes) {
        $Settings.schemes = @()
    }
    
    # Remove existing Rory schemes
    $Settings.schemes = @($Settings.schemes | Where-Object { $_.name -notlike "Rory *" })
    
    # Add all Rory color schemes
    foreach ($scheme in $ColorSchemes.Values) {
        $Settings.schemes += $scheme
    }
    
    Write-Host "Added $(($ColorSchemes.Values).Count) color schemes" -ForegroundColor Green
}

# Create Rory profile
function Install-RoryProfile {
    param(
        [hashtable]$Settings,
        [string]$DefaultTheme
    )
    
    Write-Host "Creating Rory Terminal profile..." -ForegroundColor Blue
    
    # Ensure profiles object exists
    if (-not $Settings.profiles) {
        $Settings.profiles = @{list = @()}
    } elseif (-not $Settings.profiles.list) {
        $Settings.profiles.list = @()
    }
    
    # Remove existing Rory profile
    $Settings.profiles.list = @($Settings.profiles.list | Where-Object { $_.name -ne "Rory Terminal" })
    
    # Create new profile
    $roryProfile = @{
        guid = "{12345678-1234-5678-1234-567812345678}"
        name = "Rory Terminal"
        commandline = "powershell.exe"
        colorScheme = "Rory $([char]::ToUpper($DefaultTheme[0]) + $DefaultTheme.Substring(1))"
        icon = "🚀"
        startingDirectory = "%USERPROFILE%"
        cursorShape = "vintage"
        useAcrylic = $true
        acrylicOpacity = 0.9
        padding = "8"
        fontFace = "Cascadia Code"
        fontSize = 12
    }
    
    # Add startup command
    $startupCommand = "& {if (Get-Command starship -ErrorAction SilentlyContinue) { Invoke-Expression (&starship init powershell) }; Write-Host 'Welcome to Rory Terminal!' -ForegroundColor Green}"
    $roryProfile.commandline = "powershell.exe -NoExit -Command `"$startupCommand`""
    
    # Add profile
    $Settings.profiles.list += $roryProfile
    
    Write-Host "Rory Terminal profile created" -ForegroundColor Green
}

# Add action to existing profiles
function Add-ProfileActions {
    param([hashtable]$Settings)
    
    Write-Host "Adding Rory actions to existing profiles..." -ForegroundColor Blue
    
    if ($Settings.actions -isnot [array]) {
        $Settings.actions = @()
    }
    
    # Remove existing Rory actions
    $Settings.actions = @($Settings.actions | Where-Object { 
        $_.name -notlike "Rory: *" -and $_.command -notlike "*rory*"
    })
    
    # Add Rory actions
    $roryActions = @(
        @{
            command = @{
                action = "newTab"
                profile = "{12345678-1234-5678-1234-567812345678}"
            }
            keys = "ctrl+alt+r"
            name = "Rory: New Terminal Tab"
        },
        @{
            command = @{
                action = "splitPane"
                split = "auto"
                profile = "{12345678-1234-5678-1234-567812345678}"
            }
            keys = "ctrl+alt+shift+r"
            name = "Rory: Split Pane"
        }
    )
    
    foreach ($action in $roryActions) {
        $Settings.actions += $action
    }
    
    Write-Host "Added Rory key bindings" -ForegroundColor Green
}

# Save settings
function Save-Settings {
    param(
        [string]$SettingsPath,
        [hashtable]$Settings
    )
    
    try {
        $json = $Settings | ConvertTo-Json -Depth 10
        Set-Content -Path $SettingsPath -Value $json -Encoding UTF8
        Write-Host "Settings saved successfully" -ForegroundColor Green
    } catch {
        Write-Error "Failed to save settings: $_"
    }
}

# Main installation function
function Install-WindowsTerminalIntegration {
    param([string]$Theme)
    
    Write-Host "`nWindows Terminal Integration" -ForegroundColor Cyan
    Write-Host "===========================" -ForegroundColor Cyan
    
    # Find settings file
    $settingsPath = Find-WindowsTerminalSettings
    if (-not $settingsPath) {
        Write-Warning "Windows Terminal not found. Please install Windows Terminal from the Microsoft Store."
        return
    }
    
    Write-Host "Found Windows Terminal settings: $settingsPath" -ForegroundColor Green
    
    # Backup settings
    $backupPath = Backup-Settings -SettingsPath $settingsPath
    
    try {
        # Load settings
        $settingsContent = Get-Content $settingsPath -Raw
        $settings = $settingsContent | ConvertFrom-Json -AsHashtable
        
        # Install components
        Install-ColorSchemes -SettingsPath $settingsPath -Settings $settings
        Install-RoryProfile -Settings $settings -DefaultTheme $Theme
        Add-ProfileActions -Settings $settings
        
        # Save settings
        Save-Settings -SettingsPath $settingsPath -Settings $settings
        
        Write-Host "`nInstallation complete!" -ForegroundColor Green
        Write-Host "Open Windows Terminal and try the new 'Rory Terminal' profile" -ForegroundColor Yellow
        Write-Host "Use Ctrl+Alt+R to open a new Rory tab" -ForegroundColor Yellow
        
    } catch {
        Write-Error "Installation failed: $_"
        Write-Host "Restoring backup..." -ForegroundColor Yellow
        Copy-Item $backupPath $settingsPath -Force
    }
}

# Set active theme
function Set-WindowsTerminalTheme {
    param([string]$Theme)
    
    $settingsPath = Find-WindowsTerminalSettings
    if (-not $settingsPath) {
        Write-Warning "Windows Terminal not found"
        return
    }
    
    try {
        $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json -AsHashtable
        
        # Update Rory profile color scheme
        foreach ($profile in $settings.profiles.list) {
            if ($profile.name -eq "Rory Terminal") {
                $profile.colorScheme = "Rory $([char]::ToUpper($Theme[0]) + $Theme.Substring(1))"
                break
            }
        }
        
        Save-Settings -SettingsPath $settingsPath -Settings $settings
        Write-Host "Theme changed to: $Theme" -ForegroundColor Green
        
    } catch {
        Write-Error "Failed to set theme: $_"
    }
}

# Remove integration
function Remove-WindowsTerminalIntegration {
    $settingsPath = Find-WindowsTerminalSettings
    if (-not $settingsPath) {
        Write-Warning "Windows Terminal not found"
        return
    }
    
    Write-Host "Removing Rory Terminal integration..." -ForegroundColor Yellow
    
    $backupPath = Backup-Settings -SettingsPath $settingsPath
    
    try {
        $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json -AsHashtable
        
        # Remove Rory profile
        $settings.profiles.list = @($settings.profiles.list | Where-Object { $_.name -ne "Rory Terminal" })
        
        # Remove Rory schemes
        $settings.schemes = @($settings.schemes | Where-Object { $_.name -notlike "Rory *" })
        
        # Remove Rory actions
        $settings.actions = @($settings.actions | Where-Object { 
            $_.name -notlike "Rory: *" -and $_.command -notlike "*rory*"
        })
        
        Save-Settings -SettingsPath $settingsPath -Settings $settings
        Write-Host "Rory Terminal integration removed" -ForegroundColor Green
        
    } catch {
        Write-Error "Removal failed: $_"
        Write-Host "Restoring backup..." -ForegroundColor Yellow
        Copy-Item $backupPath $settingsPath -Force
    }
}

# Main execution
switch ($Action) {
    "install" {
        Install-WindowsTerminalIntegration -Theme $Theme
    }
    "set-theme" {
        Set-WindowsTerminalTheme -Theme $Theme
    }
    "remove" {
        Remove-WindowsTerminalIntegration
    }
    default {
        Write-Host "Usage: windows-terminal-integration.ps1 [-Action {install|set-theme|remove}] [-Theme {halloween|christmas|easter|hacker|matrix}]"
    }
}
