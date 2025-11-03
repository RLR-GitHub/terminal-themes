# Create Windows desktop shortcuts for Rory Terminal
# This script creates Start Menu and Desktop shortcuts

param(
    [switch]$Desktop,
    [switch]$StartMenu,
    [switch]$All
)

$ErrorActionPreference = "Stop"

# Installation paths
$InstallDir = "$env:PROGRAMFILES\RoryTerminal"
if (-not (Test-Path $InstallDir)) {
    $InstallDir = "$env:LOCALAPPDATA\RoryTerminal"
    if (-not (Test-Path $InstallDir)) {
        Write-Error "Rory Terminal not found. Please install first."
        exit 1
    }
}

# Create WScript Shell object
$WshShell = New-Object -ComObject WScript.Shell

# Function to create shortcut
function New-RoryShortcut {
    param(
        [string]$LinkPath,
        [string]$Name,
        [string]$TargetPath,
        [string]$Arguments = "",
        [string]$IconLocation = "",
        [string]$Description = "",
        [string]$WorkingDirectory = "",
        [string]$Hotkey = ""
    )
    
    $ShortcutPath = Join-Path $LinkPath "$Name.lnk"
    
    Write-Host "Creating shortcut: $ShortcutPath" -ForegroundColor Blue
    
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = $TargetPath
    
    if ($Arguments) {
        $Shortcut.Arguments = $Arguments
    }
    
    if ($IconLocation) {
        $Shortcut.IconLocation = $IconLocation
    } else {
        $Shortcut.IconLocation = "$TargetPath,0"
    }
    
    if ($Description) {
        $Shortcut.Description = $Description
    }
    
    if ($WorkingDirectory) {
        $Shortcut.WorkingDirectory = $WorkingDirectory
    } else {
        $Shortcut.WorkingDirectory = Split-Path $TargetPath
    }
    
    if ($Hotkey) {
        $Shortcut.Hotkey = $Hotkey
    }
    
    $Shortcut.WindowStyle = 1  # Normal window
    $Shortcut.Save()
    
    Write-Host "Created: $Name" -ForegroundColor Green
}

# Determine where to create shortcuts
$CreateDesktop = $Desktop -or $All -or (-not $Desktop -and -not $StartMenu)
$CreateStartMenu = $StartMenu -or $All

# Paths
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$StartMenuPath = Join-Path ([Environment]::GetFolderPath("StartMenu")) "Programs\Rory Terminal"

# Create Start Menu folder
if ($CreateStartMenu) {
    if (-not (Test-Path $StartMenuPath)) {
        New-Item -ItemType Directory -Path $StartMenuPath -Force | Out-Null
    }
}

# PowerShell path
$PowerShellPath = "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe"

# Create shortcuts
$shortcuts = @()

# Main Rory Terminal shortcut
if ($CreateDesktop) {
    $shortcuts += @{
        LinkPath = $DesktopPath
        Name = "Rory Terminal"
        TargetPath = $PowerShellPath
        Arguments = "-ExecutionPolicy Bypass -File `"$InstallDir\install.ps1`""
        Description = "Launch Rory Terminal theme manager"
        IconLocation = "$PowerShellPath,0"
        Hotkey = ""
    }
}

if ($CreateStartMenu) {
    # Main launcher
    $shortcuts += @{
        LinkPath = $StartMenuPath
        Name = "Rory Terminal"
        TargetPath = $PowerShellPath
        Arguments = "-ExecutionPolicy Bypass -File `"$InstallDir\install.ps1`""
        Description = "Launch Rory Terminal theme manager"
        IconLocation = "$PowerShellPath,0"
    }
    
    # Theme selector
    $shortcuts += @{
        LinkPath = $StartMenuPath
        Name = "Theme Selector"
        TargetPath = $PowerShellPath
        Arguments = "-ExecutionPolicy Bypass -Command `"& { Import-Module '$InstallDir\RoryTerminal.psm1'; Show-RoryThemeSelector }`""
        Description = "Select and apply terminal themes"
        IconLocation = "$PowerShellPath,0"
    }
    
    # Matrix animations
    foreach ($theme in @("Halloween", "Christmas", "Easter", "Hacker", "Matrix")) {
        $shortcuts += @{
            LinkPath = $StartMenuPath
            Name = "Matrix $theme"
            TargetPath = $PowerShellPath
            Arguments = "-ExecutionPolicy Bypass -File `"$InstallDir\themes\Matrix-$theme.ps1`""
            Description = "Run $theme Matrix animation"
            IconLocation = "$PowerShellPath,0"
        }
    }
    
    # Windows Terminal integration
    $shortcuts += @{
        LinkPath = $StartMenuPath
        Name = "Configure Windows Terminal"
        TargetPath = $PowerShellPath
        Arguments = "-ExecutionPolicy Bypass -File `"$InstallDir\windows-terminal-integration.ps1`" -Action install"
        Description = "Configure Windows Terminal with Rory themes"
        IconLocation = "$PowerShellPath,0"
    }
    
    # Uninstaller
    $shortcuts += @{
        LinkPath = $StartMenuPath
        Name = "Uninstall Rory Terminal"
        TargetPath = $PowerShellPath
        Arguments = "-ExecutionPolicy Bypass -File `"$InstallDir\install.ps1`" -Uninstall"
        Description = "Uninstall Rory Terminal"
        IconLocation = "$PowerShellPath,0"
    }
}

# Create all shortcuts
foreach ($shortcut in $shortcuts) {
    New-RoryShortcut @shortcut
}

# Create context menu entry (optional)
if ($All) {
    Write-Host "`nAdding context menu entry..." -ForegroundColor Blue
    
    $regPath = "HKCU:\Software\Classes\Directory\Background\shell\RoryTerminal"
    $regCommandPath = "$regPath\command"
    
    # Create registry keys
    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name "(Default)" -Value "Open Rory Terminal here"
    Set-ItemProperty -Path $regPath -Name "Icon" -Value "$PowerShellPath,0"
    
    New-Item -Path $regCommandPath -Force | Out-Null
    Set-ItemProperty -Path $regCommandPath -Name "(Default)" -Value "`"$PowerShellPath`" -NoExit -ExecutionPolicy Bypass -Command `"& { Import-Module '$InstallDir\RoryTerminal.psm1'; Write-Host 'Welcome to Rory Terminal!' -ForegroundColor Green }`""
    
    Write-Host "Context menu entry added" -ForegroundColor Green
}

Write-Host "`nShortcut creation complete!" -ForegroundColor Green

if ($CreateDesktop) {
    Write-Host "Desktop shortcuts created" -ForegroundColor Yellow
}

if ($CreateStartMenu) {
    Write-Host "Start Menu shortcuts created in: $StartMenuPath" -ForegroundColor Yellow
}

# Refresh desktop
$Shell = New-Object -ComObject Shell.Application
$Shell.MinimizeAll()
Start-Sleep -Milliseconds 200
$Shell.UndoMinimizeAll()
