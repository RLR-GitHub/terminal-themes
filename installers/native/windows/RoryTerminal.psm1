# RoryTerminal PowerShell Module
# Provides cmdlets for managing Rory Terminal themes and configurations

# Module configuration
$script:RoryTerminalRoot = if ($env:RORY_TERMINAL_DIR) { 
    $env:RORY_TERMINAL_DIR 
} elseif (Test-Path "$env:PROGRAMFILES\RoryTerminal") {
    "$env:PROGRAMFILES\RoryTerminal"
} else {
    "$env:LOCALAPPDATA\RoryTerminal"
}

$script:ConfigPath = "$env:APPDATA\RoryTerminal\config.json"
$script:ThemesPath = Join-Path $script:RoryTerminalRoot "themes"

# Available themes
$script:AvailableThemes = @("halloween", "christmas", "easter", "hacker", "matrix")

# Theme metadata
$script:ThemeMetadata = @{
    halloween = @{
        DisplayName = "Halloween"
        Icon = "🎃"
        Description = "Spooky orange matrix rain with Halloween symbols"
        PrimaryColor = "DarkYellow"
    }
    christmas = @{
        DisplayName = "Christmas"
        Icon = "🎄"
        Description = "Festive red and green with holiday cheer"
        PrimaryColor = "Red"
    }
    easter = @{
        DisplayName = "Easter"
        Icon = "🐰"
        Description = "Pastel rainbow colors for spring"
        PrimaryColor = "Magenta"
    }
    hacker = @{
        DisplayName = "Hacker"
        Icon = "💻"
        Description = "Bright green cyberpunk aesthetic"
        PrimaryColor = "Green"
    }
    matrix = @{
        DisplayName = "Matrix"
        Icon = "🟢"
        Description = "Classic Matrix movie green"
        PrimaryColor = "Green"
    }
}

# Get current configuration
function Get-RoryConfig {
    if (Test-Path $script:ConfigPath) {
        return Get-Content $script:ConfigPath -Raw | ConvertFrom-Json
    } else {
        return @{
            currentTheme = "hacker"
            enableStartup = $false
            enableAnimations = $true
            windowsTerminalIntegration = $false
        }
    }
}

# Save configuration
function Save-RoryConfig {
    param($Config)
    
    $configDir = Split-Path $script:ConfigPath
    if (-not (Test-Path $configDir)) {
        New-Item -ItemType Directory -Path $configDir -Force | Out-Null
    }
    
    $Config | ConvertTo-Json | Set-Content $script:ConfigPath -Encoding UTF8
}

<#
.SYNOPSIS
Gets available Rory Terminal themes.

.DESCRIPTION
Lists all available themes with their metadata including name, icon, and description.

.PARAMETER Name
Optional. Specific theme name to retrieve.

.EXAMPLE
Get-RoryTheme
Lists all available themes.

.EXAMPLE
Get-RoryTheme -Name hacker
Gets information about the hacker theme.
#>
function Get-RoryTheme {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [ValidateSet('halloween', 'christmas', 'easter', 'hacker', 'matrix')]
        [string]$Name
    )
    
    if ($Name) {
        $theme = $script:ThemeMetadata[$Name]
        [PSCustomObject]@{
            Name = $Name
            DisplayName = $theme.DisplayName
            Icon = $theme.Icon
            Description = $theme.Description
            PrimaryColor = $theme.PrimaryColor
            IsCurrent = (Get-RoryConfig).currentTheme -eq $Name
        }
    } else {
        $currentTheme = (Get-RoryConfig).currentTheme
        
        foreach ($themeName in $script:AvailableThemes) {
            $theme = $script:ThemeMetadata[$themeName]
            [PSCustomObject]@{
                Name = $themeName
                DisplayName = $theme.DisplayName
                Icon = $theme.Icon
                Description = $theme.Description
                PrimaryColor = $theme.PrimaryColor
                IsCurrent = $currentTheme -eq $themeName
            }
        }
    }
}

<#
.SYNOPSIS
Sets the active Rory Terminal theme.

.DESCRIPTION
Changes the current terminal theme and optionally updates Windows Terminal integration.

.PARAMETER Name
The name of the theme to activate.

.PARAMETER UpdateWindowsTerminal
Switch to also update Windows Terminal profiles with the new theme.

.EXAMPLE
Set-RoryTheme -Name halloween
Sets the Halloween theme.

.EXAMPLE
Set-RoryTheme -Name matrix -UpdateWindowsTerminal
Sets the Matrix theme and updates Windows Terminal.
#>
function Set-RoryTheme {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateSet('halloween', 'christmas', 'easter', 'hacker', 'matrix')]
        [string]$Name,
        
        [switch]$UpdateWindowsTerminal
    )
    
    if ($PSCmdlet.ShouldProcess($Name, "Set theme")) {
        $config = Get-RoryConfig
        $oldTheme = $config.currentTheme
        $config.currentTheme = $Name
        
        Save-RoryConfig -Config $config
        
        Write-Host "`nTheme changed: " -NoNewline
        Write-Host "$oldTheme" -ForegroundColor Gray -NoNewline
        Write-Host " → " -NoNewline
        Write-Host "$Name" -ForegroundColor $script:ThemeMetadata[$Name].PrimaryColor
        
        # Update Starship config if exists
        $starshipConfig = "$env:USERPROFILE\.config\starship.toml"
        $themeConfig = Join-Path $script:ThemesPath "starship\$Name.toml"
        
        if ((Test-Path $themeConfig) -and (Get-Command starship -ErrorAction SilentlyContinue)) {
            Copy-Item $themeConfig $starshipConfig -Force
            Write-Host "✓ Starship configuration updated" -ForegroundColor Green
        }
        
        # Update Windows Terminal
        if ($UpdateWindowsTerminal) {
            $integrationScript = Join-Path $script:RoryTerminalRoot "windows-terminal-integration.ps1"
            if (Test-Path $integrationScript) {
                & $integrationScript -Action set-theme -Theme $Name
            }
        }
        
        Write-Host "`n$($script:ThemeMetadata[$Name].Icon) $($script:ThemeMetadata[$Name].DisplayName) theme activated!" -ForegroundColor $script:ThemeMetadata[$Name].PrimaryColor
    }
}

<#
.SYNOPSIS
Starts a Matrix animation with the specified theme.

.DESCRIPTION
Launches the Matrix rain animation using the specified theme's colors and symbols.

.PARAMETER Theme
The theme to use for the animation. Defaults to current theme.

.PARAMETER Duration
Duration in seconds to run the animation. Use 0 for infinite.

.EXAMPLE
Start-RoryMatrix
Starts Matrix animation with current theme.

.EXAMPLE
Start-RoryMatrix -Theme halloween -Duration 30
Runs Halloween Matrix animation for 30 seconds.
#>
function Start-RoryMatrix {
    [CmdletBinding()]
    param(
        [ValidateSet('halloween', 'christmas', 'easter', 'hacker', 'matrix')]
        [string]$Theme = (Get-RoryConfig).currentTheme,
        
        [int]$Duration = 0
    )
    
    $scriptPath = Join-Path $script:ThemesPath "powershell\Matrix-$Theme.ps1"
    
    if (Test-Path $scriptPath) {
        Write-Host "Starting $Theme Matrix animation..." -ForegroundColor $script:ThemeMetadata[$Theme].PrimaryColor
        Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
        
        if ($Duration -gt 0) {
            & $scriptPath -Duration $Duration
        } else {
            & $scriptPath
        }
    } else {
        Write-Error "Matrix script not found for theme: $Theme"
    }
}

<#
.SYNOPSIS
Shows the Rory Terminal theme selector GUI.

.DESCRIPTION
Launches a graphical interface for selecting and previewing themes.

.EXAMPLE
Show-RoryThemeSelector
Opens the theme selector window.
#>
function Show-RoryThemeSelector {
    [CmdletBinding()]
    param()
    
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    
    # Create form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Rory Terminal - Theme Selector"
    $form.Size = New-Object System.Drawing.Size(500, 400)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    
    # Title label
    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Text = "Select Your Terminal Theme"
    $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    $titleLabel.Location = New-Object System.Drawing.Point(20, 20)
    $titleLabel.Size = New-Object System.Drawing.Size(460, 30)
    $form.Controls.Add($titleLabel)
    
    # Theme list
    $listBox = New-Object System.Windows.Forms.ListBox
    $listBox.Location = New-Object System.Drawing.Point(20, 60)
    $listBox.Size = New-Object System.Drawing.Size(200, 250)
    $listBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    
    $currentTheme = (Get-RoryConfig).currentTheme
    
    foreach ($theme in Get-RoryTheme) {
        $displayText = "$($theme.Icon) $($theme.DisplayName)"
        if ($theme.IsCurrent) {
            $displayText += " (current)"
        }
        [void]$listBox.Items.Add($displayText)
        
        if ($theme.Name -eq $currentTheme) {
            $listBox.SelectedIndex = $listBox.Items.Count - 1
        }
    }
    
    $form.Controls.Add($listBox)
    
    # Description panel
    $descPanel = New-Object System.Windows.Forms.GroupBox
    $descPanel.Text = "Theme Details"
    $descPanel.Location = New-Object System.Drawing.Point(240, 60)
    $descPanel.Size = New-Object System.Drawing.Size(220, 120)
    $form.Controls.Add($descPanel)
    
    $descLabel = New-Object System.Windows.Forms.Label
    $descLabel.Location = New-Object System.Drawing.Point(10, 20)
    $descLabel.Size = New-Object System.Drawing.Size(200, 90)
    $descLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $descPanel.Controls.Add($descLabel)
    
    # Preview button
    $previewBtn = New-Object System.Windows.Forms.Button
    $previewBtn.Text = "Preview Matrix"
    $previewBtn.Location = New-Object System.Drawing.Point(240, 190)
    $previewBtn.Size = New-Object System.Drawing.Size(100, 30)
    $form.Controls.Add($previewBtn)
    
    # Apply button
    $applyBtn = New-Object System.Windows.Forms.Button
    $applyBtn.Text = "Apply Theme"
    $applyBtn.Location = New-Object System.Drawing.Point(350, 190)
    $applyBtn.Size = New-Object System.Drawing.Size(110, 30)
    $applyBtn.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $form.Controls.Add($applyBtn)
    
    # Windows Terminal checkbox
    $wtCheckbox = New-Object System.Windows.Forms.CheckBox
    $wtCheckbox.Text = "Update Windows Terminal"
    $wtCheckbox.Location = New-Object System.Drawing.Point(240, 230)
    $wtCheckbox.Size = New-Object System.Drawing.Size(220, 20)
    $wtCheckbox.Checked = (Get-RoryConfig).windowsTerminalIntegration
    $form.Controls.Add($wtCheckbox)
    
    # Status label
    $statusLabel = New-Object System.Windows.Forms.Label
    $statusLabel.Location = New-Object System.Drawing.Point(20, 320)
    $statusLabel.Size = New-Object System.Drawing.Size(440, 20)
    $statusLabel.Text = "Ready"
    $form.Controls.Add($statusLabel)
    
    # Event handlers
    $listBox.add_SelectedIndexChanged({
        $selectedIndex = $listBox.SelectedIndex
        if ($selectedIndex -ge 0) {
            $selectedTheme = $script:AvailableThemes[$selectedIndex]
            $theme = $script:ThemeMetadata[$selectedTheme]
            $descLabel.Text = $theme.Description
        }
    })
    
    $previewBtn.add_Click({
        $selectedIndex = $listBox.SelectedIndex
        if ($selectedIndex -ge 0) {
            $selectedTheme = $script:AvailableThemes[$selectedIndex]
            $statusLabel.Text = "Starting Matrix preview..."
            
            Start-Process powershell -ArgumentList "-NoExit", "-Command", "& { Import-Module '$PSScriptRoot\RoryTerminal.psm1'; Start-RoryMatrix -Theme $selectedTheme -Duration 10 }"
            
            $statusLabel.Text = "Preview launched in new window"
        }
    })
    
    $applyBtn.add_Click({
        $selectedIndex = $listBox.SelectedIndex
        if ($selectedIndex -ge 0) {
            $selectedTheme = $script:AvailableThemes[$selectedIndex]
            $statusLabel.Text = "Applying theme..."
            
            if ($wtCheckbox.Checked) {
                Set-RoryTheme -Name $selectedTheme -UpdateWindowsTerminal
            } else {
                Set-RoryTheme -Name $selectedTheme
            }
            
            # Update config
            $config = Get-RoryConfig
            $config.windowsTerminalIntegration = $wtCheckbox.Checked
            Save-RoryConfig -Config $config
            
            $statusLabel.Text = "$selectedTheme theme applied!"
            
            # Update list to show new current
            $listBox.Items.Clear()
            foreach ($theme in Get-RoryTheme) {
                $displayText = "$($theme.Icon) $($theme.DisplayName)"
                if ($theme.IsCurrent) {
                    $displayText += " (current)"
                }
                [void]$listBox.Items.Add($displayText)
                
                if ($theme.Name -eq $selectedTheme) {
                    $listBox.SelectedIndex = $listBox.Items.Count - 1
                }
            }
        }
    })
    
    # Show form
    [void]$form.ShowDialog()
}

<#
.SYNOPSIS
Installs Rory Terminal integration.

.DESCRIPTION
Sets up Rory Terminal with Windows Terminal integration and Start Menu shortcuts.

.PARAMETER IncludeWindowsTerminal
Also configure Windows Terminal with Rory profiles and themes.

.PARAMETER CreateShortcuts
Create desktop and Start Menu shortcuts.

.EXAMPLE
Install-RoryTerminal
Basic installation.

.EXAMPLE
Install-RoryTerminal -IncludeWindowsTerminal -CreateShortcuts
Full installation with all integrations.
#>
function Install-RoryTerminal {
    [CmdletBinding()]
    param(
        [switch]$IncludeWindowsTerminal,
        [switch]$CreateShortcuts
    )
    
    Write-Host "Installing Rory Terminal..." -ForegroundColor Cyan
    
    # Create config
    $config = Get-RoryConfig
    $config.enableStartup = $false
    $config.windowsTerminalIntegration = $IncludeWindowsTerminal
    Save-RoryConfig -Config $config
    
    # Windows Terminal integration
    if ($IncludeWindowsTerminal) {
        $integrationScript = Join-Path $script:RoryTerminalRoot "windows-terminal-integration.ps1"
        if (Test-Path $integrationScript) {
            Write-Host "Configuring Windows Terminal..." -ForegroundColor Blue
            & $integrationScript -Action install -Theme $config.currentTheme
        }
    }
    
    # Create shortcuts
    if ($CreateShortcuts) {
        $shortcutScript = Join-Path (Split-Path $script:RoryTerminalRoot) "desktop\RoryTerminal.lnk.ps1"
        if (Test-Path $shortcutScript) {
            Write-Host "Creating shortcuts..." -ForegroundColor Blue
            & $shortcutScript -All
        }
    }
    
    Write-Host "`nInstallation complete!" -ForegroundColor Green
    Write-Host "Use Get-RoryTheme to see available themes" -ForegroundColor Yellow
    Write-Host "Use Set-RoryTheme to change themes" -ForegroundColor Yellow
}

<#
.SYNOPSIS
Uninstalls Rory Terminal integration.

.DESCRIPTION
Removes Windows Terminal integration and optionally removes all configuration.

.PARAMETER RemoveConfig
Also remove user configuration files.

.PARAMETER RemoveWindowsTerminal
Remove Windows Terminal profiles and color schemes.

.EXAMPLE
Uninstall-RoryTerminal
Basic uninstall.

.EXAMPLE
Uninstall-RoryTerminal -RemoveConfig -RemoveWindowsTerminal
Complete removal of all components.
#>
function Uninstall-RoryTerminal {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [switch]$RemoveConfig,
        [switch]$RemoveWindowsTerminal
    )
    
    if ($PSCmdlet.ShouldProcess("Rory Terminal", "Uninstall")) {
        Write-Host "Uninstalling Rory Terminal..." -ForegroundColor Yellow
        
        # Remove Windows Terminal integration
        if ($RemoveWindowsTerminal) {
            $integrationScript = Join-Path $script:RoryTerminalRoot "windows-terminal-integration.ps1"
            if (Test-Path $integrationScript) {
                Write-Host "Removing Windows Terminal integration..." -ForegroundColor Blue
                & $integrationScript -Action remove
            }
        }
        
        # Remove config
        if ($RemoveConfig -and (Test-Path $script:ConfigPath)) {
            Remove-Item $script:ConfigPath -Force
            Write-Host "Configuration removed" -ForegroundColor Green
        }
        
        # Remove context menu
        $regPath = "HKCU:\Software\Classes\Directory\Background\shell\RoryTerminal"
        if (Test-Path $regPath) {
            Remove-Item $regPath -Recurse -Force
            Write-Host "Context menu entry removed" -ForegroundColor Green
        }
        
        Write-Host "`nUninstall complete" -ForegroundColor Green
    }
}

# Export module members
Export-ModuleMember -Function Get-RoryTheme, Set-RoryTheme, Start-RoryMatrix, Show-RoryThemeSelector, Install-RoryTerminal, Uninstall-RoryTerminal

# Welcome message
if (-not $env:RORY_TERMINAL_QUIET) {
    $currentTheme = (Get-RoryConfig).currentTheme
    $theme = $script:ThemeMetadata[$currentTheme]
    Write-Host "`n$($theme.Icon) Rory Terminal Module Loaded" -ForegroundColor $theme.PrimaryColor
    Write-Host "Current theme: $($theme.DisplayName)" -ForegroundColor Gray
    Write-Host "Use 'Get-Command -Module RoryTerminal' to see available commands`n" -ForegroundColor Gray
}
