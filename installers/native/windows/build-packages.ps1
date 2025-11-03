# Build script for Windows packages (Chocolatey and Winget)
param(
    [string]$Version = "3.0.0",
    [switch]$Chocolatey,
    [switch]$Winget,
    [switch]$All
)

$ErrorActionPreference = 'Stop'

# Paths
$RootDir = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)))
$BuildDir = Join-Path $RootDir "build\windows"
$OutputDir = Join-Path $RootDir "dist\windows"

# Create directories
New-Item -ItemType Directory -Path $BuildDir -Force | Out-Null
New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null

function Build-ChocolateyPackage {
    Write-Host "`nBuilding Chocolatey package..." -ForegroundColor Cyan
    
    $chocoDir = Join-Path $BuildDir "chocolatey"
    $chocoSource = Join-Path $PSScriptRoot "chocolatey"
    
    # Clean and create directory
    if (Test-Path $chocoDir) {
        Remove-Item $chocoDir -Recurse -Force
    }
    Copy-Item $chocoSource $chocoDir -Recurse
    
    # Create release zip
    $zipPath = Join-Path $BuildDir "rory-terminal-$Version-windows.zip"
    Write-Host "Creating release archive..." -ForegroundColor Blue
    
    $tempDir = Join-Path $BuildDir "rory-terminal-$Version"
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
    
    # Copy all necessary files
    Copy-Item (Join-Path $RootDir "core") $tempDir -Recurse
    Copy-Item (Join-Path $RootDir "themes") $tempDir -Recurse
    Copy-Item (Join-Path $RootDir "config") $tempDir -Recurse
    Copy-Item (Join-Path $RootDir "installers\*.ps1") $tempDir
    Copy-Item (Join-Path $RootDir "installers\*.cmd") $tempDir
    Copy-Item (Join-Path $PSScriptRoot "*.ps1") $tempDir
    Copy-Item (Join-Path $PSScriptRoot "*.psd1") $tempDir
    Copy-Item (Join-Path $PSScriptRoot "*.psm1") $tempDir
    Copy-Item (Join-Path $RootDir "LICENSE") $tempDir
    Copy-Item (Join-Path $RootDir "README.md") $tempDir
    
    # Create zip
    Compress-Archive -Path $tempDir -DestinationPath $zipPath -Force
    
    # Calculate checksum
    $checksum = (Get-FileHash $zipPath -Algorithm SHA256).Hash
    Write-Host "Checksum: $checksum" -ForegroundColor Green
    
    # Update nuspec with version and checksum
    $nuspecPath = Join-Path $chocoDir "rory-terminal.nuspec"
    $nuspec = Get-Content $nuspecPath -Raw
    $nuspec = $nuspec -replace 'PLACEHOLDER_CHECKSUM', $checksum
    Set-Content $nuspecPath $nuspec
    
    # Pack the package
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Push-Location $chocoDir
        choco pack --outputdirectory $OutputDir
        Pop-Location
        
        Write-Host "Chocolatey package created: $OutputDir\rory-terminal.$Version.nupkg" -ForegroundColor Green
    } else {
        Write-Warning "Chocolatey not installed. Install with: Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
        Write-Host "Package files prepared in: $chocoDir" -ForegroundColor Yellow
    }
    
    # Cleanup
    Remove-Item $tempDir -Recurse -Force
}

function Build-WingetPackage {
    Write-Host "`nPreparing Winget manifest..." -ForegroundColor Cyan
    
    $wingetDir = Join-Path $OutputDir "winget"
    $manifestDir = Join-Path $wingetDir "manifests\r\RLR-GitHub\RoryTerminal\$Version"
    
    # Create directory structure
    New-Item -ItemType Directory -Path $manifestDir -Force | Out-Null
    
    # Copy manifest
    Copy-Item (Join-Path $PSScriptRoot "winget\rory-terminal.yaml") $manifestDir
    
    # Note: MSI files should be built separately and uploaded to releases
    # The manifest references the download URLs
    
    Write-Host "Winget manifest prepared in: $manifestDir" -ForegroundColor Green
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Build MSI installers and upload to GitHub releases" -ForegroundColor Yellow
    Write-Host "  2. Update SHA256 hashes in the manifest" -ForegroundColor Yellow
    Write-Host "  3. Submit PR to: https://github.com/microsoft/winget-pkgs" -ForegroundColor Yellow
}

# Main execution
Write-Host "Rory Terminal Package Builder" -ForegroundColor Magenta
Write-Host "============================" -ForegroundColor Magenta

if ($All -or (!$Chocolatey -and !$Winget)) {
    $Chocolatey = $true
    $Winget = $true
}

if ($Chocolatey) {
    Build-ChocolateyPackage
}

if ($Winget) {
    Build-WingetPackage
}

Write-Host "`nBuild complete!" -ForegroundColor Green
Write-Host "Output directory: $OutputDir" -ForegroundColor Cyan
