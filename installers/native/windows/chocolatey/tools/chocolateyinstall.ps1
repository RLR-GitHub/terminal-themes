$ErrorActionPreference = 'Stop'

$packageName = 'rory-terminal'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installDir = "$env:PROGRAMFILES\RoryTerminal"

$packageArgs = @{
  packageName    = $packageName
  unzipLocation  = $toolsDir
  url            = 'https://github.com/RLR-GitHub/terminal-themes/releases/download/v3.0.0/rory-terminal-3.0.0-windows.zip'
  checksum       = 'PLACEHOLDER_CHECKSUM'
  checksumType   = 'sha256'
}

# Create installation directory
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
}

# Download and extract package
Install-ChocolateyZipPackage @packageArgs

# Copy files to installation directory
Write-Host "Installing Rory Terminal to $installDir..." -ForegroundColor Blue
Get-ChildItem "$toolsDir\rory-terminal-*" -Directory | ForEach-Object {
    Copy-Item "$_\*" $installDir -Recurse -Force
}

# Install PowerShell module
$modulePath = "$env:ProgramFiles\WindowsPowerShell\Modules\RoryTerminal"
if (-not (Test-Path $modulePath)) {
    New-Item -ItemType Directory -Path $modulePath -Force | Out-Null
}
Copy-Item "$installDir\RoryTerminal.ps*" $modulePath -Force

# Add to PATH
$path = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($path -notlike "*$installDir*") {
    [Environment]::SetEnvironmentVariable("Path", "$path;$installDir", "Machine")
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# Create Start Menu shortcuts
$startMenuPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Rory Terminal"
if (-not (Test-Path $startMenuPath)) {
    New-Item -ItemType Directory -Path $startMenuPath -Force | Out-Null
}

# Run shortcut creation script
& "$installDir\RoryTerminal.lnk.ps1" -StartMenu

# Configure Windows Terminal if installed
if (Get-Command wt -ErrorAction SilentlyContinue) {
    Write-Host "Configuring Windows Terminal integration..." -ForegroundColor Blue
    & "$installDir\windows-terminal-integration.ps1" -Action install -Theme hacker
}

# Update PowerShell profile
$profileContent = @'

# Rory Terminal
if (Get-Module -ListAvailable -Name RoryTerminal) {
    Import-Module RoryTerminal
}
'@

$profiles = @(
    $PROFILE.AllUsersAllHosts,
    $PROFILE.AllUsersCurrentHost,
    $PROFILE.CurrentUserAllHosts,
    $PROFILE.CurrentUserCurrentHost
)

foreach ($profile in $profiles) {
    if (Test-Path $profile) {
        $content = Get-Content $profile -Raw
        if ($content -notlike "*RoryTerminal*") {
            Add-Content $profile $profileContent
            break
        }
    } else {
        $profileDir = Split-Path $profile
        if (-not (Test-Path $profileDir)) {
            New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
        }
        Set-Content $profile $profileContent
        break
    }
}

Write-Host "`nRory Terminal installed successfully!" -ForegroundColor Green
Write-Host "Run 'Get-RoryTheme' to see available themes" -ForegroundColor Yellow
Write-Host "Run 'Show-RoryThemeSelector' to open the GUI theme selector" -ForegroundColor Yellow
Write-Host "Restart your terminal to load the module automatically" -ForegroundColor Cyan
