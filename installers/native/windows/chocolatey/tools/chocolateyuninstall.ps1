$ErrorActionPreference = 'Stop'

$packageName = 'rory-terminal'
$installDir = "$env:PROGRAMFILES\RoryTerminal"

Write-Host "Uninstalling Rory Terminal..." -ForegroundColor Yellow

# Remove Windows Terminal integration
if (Test-Path "$installDir\windows-terminal-integration.ps1") {
    & "$installDir\windows-terminal-integration.ps1" -Action remove
}

# Remove from PATH
$path = [Environment]::GetEnvironmentVariable("Path", "Machine")
$newPath = ($path.Split(';') | Where-Object { $_ -ne $installDir }) -join ';'
[Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")

# Remove PowerShell module
$modulePath = "$env:ProgramFiles\WindowsPowerShell\Modules\RoryTerminal"
if (Test-Path $modulePath) {
    Remove-Item $modulePath -Recurse -Force
}

# Remove from PowerShell profiles
$profiles = @(
    $PROFILE.AllUsersAllHosts,
    $PROFILE.AllUsersCurrentHost,
    $PROFILE.CurrentUserAllHosts,
    $PROFILE.CurrentUserCurrentHost
)

foreach ($profile in $profiles) {
    if (Test-Path $profile) {
        $content = Get-Content $profile -Raw
        if ($content -like "*RoryTerminal*") {
            $newContent = $content -replace '(?ms)# Rory Terminal.*?}', ''
            Set-Content $profile $newContent.Trim()
        }
    }
}

# Remove Start Menu shortcuts
$startMenuPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Rory Terminal"
if (Test-Path $startMenuPath) {
    Remove-Item $startMenuPath -Recurse -Force
}

# Remove installation directory
if (Test-Path $installDir) {
    Remove-Item $installDir -Recurse -Force
}

# Remove user config
$configPath = "$env:APPDATA\RoryTerminal"
if (Test-Path $configPath) {
    Write-Host "Removing user configuration..." -ForegroundColor Blue
    Remove-Item $configPath -Recurse -Force
}

Write-Host "Rory Terminal has been uninstalled" -ForegroundColor Green
