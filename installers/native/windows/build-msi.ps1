# Build Windows MSI installer for Rory Terminal Themes
# Requires WiX Toolset: https://wixtoolset.org/

param(
    [string]$Version = "3.0.0",
    [string]$WixPath = "C:\Program Files (x86)\WiX Toolset v3.11\bin"
)

$ErrorActionPreference = "Stop"

$PackageName = "RoryTerminal"
$Manufacturer = "Rory"
$UpgradeCode = "12345678-1234-1234-1234-123456789012"  # Generate new GUID for production
$BuildDir = Join-Path $PSScriptRoot "build"
$RootDir = Join-Path $PSScriptRoot "..\..\.."
$SourceDir = Join-Path $BuildDir "source"

function Write-Step {
    param([string]$Message)
    Write-Host "==> $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
    exit 1
}

Write-Step "Building Windows MSI installer for Rory Terminal v$Version"

# Check for WiX Toolset
if (-not (Test-Path "$WixPath\candle.exe")) {
    Write-Error "WiX Toolset not found at: $WixPath`nDownload from: https://wixtoolset.org/"
}

# Clean previous build
if (Test-Path $BuildDir) {
    Remove-Item -Path $BuildDir -Recurse -Force
}

# Create build directories
New-Item -ItemType Directory -Path $SourceDir -Force | Out-Null
New-Item -ItemType Directory -Path "$SourceDir\themes" -Force | Out-Null
New-Item -ItemType Directory -Path "$SourceDir\core" -Force | Out-Null

Write-Success "Build directories created"

# Copy files
Write-Step "Copying application files..."

# Copy PowerShell themes
Copy-Item "$RootDir\themes\powershell\*" "$SourceDir\themes\" -Recurse -Force

# Copy Starship configs
if (Test-Path "$RootDir\themes\starship") {
    Copy-Item "$RootDir\themes\starship" "$SourceDir\themes\" -Recurse -Force
}

# Copy install scripts
Copy-Item "$RootDir\installers\install.ps1" "$SourceDir\" -Force
Copy-Item "$RootDir\installers\install.cmd" "$SourceDir\" -Force

Write-Success "Files copied"

# Create WiX source file
Write-Step "Creating WiX product definition..."

$WxsContent = @"
<?xml version="1.0" encoding="UTF-8"?>
<Wix xmlns="http://schemas.microsoft.com/wix/2006/wi">
    <Product Id="*" 
             Name="Rory Terminal Themes" 
             Language="1033" 
             Version="$Version" 
             Manufacturer="$Manufacturer" 
             UpgradeCode="$UpgradeCode">
        
        <Package InstallerVersion="200" 
                 Compressed="yes" 
                 InstallScope="perMachine" 
                 Description="Rory Terminal Themes - Cyberpunk terminal customization" 
                 Comments="Transform your terminal experience"/>
        
        <MajorUpgrade DowngradeErrorMessage="A newer version is already installed." />
        <MediaTemplate EmbedCab="yes" />
        
        <!-- Installation directory -->
        <Directory Id="TARGETDIR" Name="SourceDir">
            <Directory Id="ProgramFilesFolder">
                <Directory Id="INSTALLFOLDER" Name="RoryTerminal">
                    <Directory Id="ThemesFolder" Name="themes" />
                    <Directory Id="CoreFolder" Name="core" />
                </Directory>
            </Directory>
            <Directory Id="ProgramMenuFolder">
                <Directory Id="ApplicationProgramsFolder" Name="Rory Terminal" />
            </Directory>
        </Directory>
        
        <!-- Components -->
        <DirectoryRef Id="INSTALLFOLDER">
            <Component Id="MainComponent" Guid="*">
                <File Id="InstallPS1" Source="$(var.SourceDir)\install.ps1" KeyPath="yes" />
                <File Id="InstallCMD" Source="$(var.SourceDir)\install.cmd" />
            </Component>
        </DirectoryRef>
        
        <DirectoryRef Id="ThemesFolder">
            <Component Id="ThemesComponent" Guid="*">
                <File Id="MatrixHalloween" Source="$(var.SourceDir)\themes\Matrix-Halloween.ps1" />
                <File Id="MatrixChristmas" Source="$(var.SourceDir)\themes\Matrix-Christmas.ps1" />
                <File Id="MatrixEaster" Source="$(var.SourceDir)\themes\Matrix-Easter.ps1" />
                <File Id="MatrixHacker" Source="$(var.SourceDir)\themes\Matrix-Hacker.ps1" />
                <File Id="MatrixClassic" Source="$(var.SourceDir)\themes\Matrix-Classic.ps1" />
            </Component>
        </DirectoryRef>
        
        <!-- Start Menu Shortcuts -->
        <DirectoryRef Id="ApplicationProgramsFolder">
            <Component Id="ApplicationShortcut" Guid="*">
                <Shortcut Id="InstallShortcut"
                          Name="Install Rory Terminal"
                          Description="Install Rory Terminal Themes"
                          Target="[System64Folder]WindowsPowerShell\v1.0\powershell.exe"
                          Arguments="-ExecutionPolicy Bypass -File &quot;[INSTALLFOLDER]install.ps1&quot;"
                          WorkingDirectory="INSTALLFOLDER"/>
                <Shortcut Id="UninstallShortcut"
                          Name="Uninstall Rory Terminal"
                          Description="Uninstall Rory Terminal Themes"
                          Target="[System64Folder]msiexec.exe"
                          Arguments="/x [ProductCode]"/>
                <RemoveFolder Id="ApplicationProgramsFolder" On="uninstall"/>
                <RegistryValue Root="HKCU" 
                              Key="Software\Rory\Terminal" 
                              Name="installed" 
                              Type="integer" 
                              Value="1" 
                              KeyPath="yes"/>
            </Component>
        </DirectoryRef>
        
        <!-- Features -->
        <Feature Id="ProductFeature" Title="Rory Terminal Themes" Level="1">
            <ComponentRef Id="MainComponent" />
            <ComponentRef Id="ThemesComponent" />
            <ComponentRef Id="ApplicationShortcut" />
        </Feature>
        
        <!-- Custom actions -->
        <CustomAction Id="RunInstaller" 
                     Directory="INSTALLFOLDER" 
                     ExeCommand="powershell.exe -ExecutionPolicy Bypass -File &quot;[INSTALLFOLDER]install.ps1&quot;" 
                     Execute="deferred" 
                     Impersonate="yes" 
                     Return="check" />
        
        <!-- UI -->
        <UIRef Id="WixUI_Minimal"/>
        <UIRef Id="WixUI_ErrorProgressText"/>
        
        <WixVariable Id="WixUILicenseRtf" Value="$(var.SourceDir)\License.rtf" />
        
        <!-- Install sequence -->
        <InstallExecuteSequence>
            <Custom Action="RunInstaller" After="InstallFiles">NOT Installed</Custom>
        </InstallExecuteSequence>
    </Product>
</Wix>
"@

$WxsContent | Out-File "$BuildDir\Product.wxs" -Encoding UTF8

Write-Success "WiX product definition created"

# Create license RTF
Write-Step "Creating license file..."

$LicenseRtf = @"
{\rtf1\ansi\deff0
{\fonttbl{\f0\fnil\fcharset0 Arial;}}
{\colortbl ;\red0\green0\blue255;}
\viewkind4\uc1\pard\lang1033\f0\fs20
MIT License\par
\par
Copyright (c) 2024 Roderick Lawrence Renwick\par
\par
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\par
\par
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\par
\par
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\par
}
"@

$LicenseRtf | Out-File "$SourceDir\License.rtf" -Encoding UTF8

Write-Success "License file created"

# Compile WiX
Write-Step "Compiling WiX source..."

& "$WixPath\candle.exe" "$BuildDir\Product.wxs" `
    -dSourceDir="$SourceDir" `
    -out "$BuildDir\Product.wixobj" `
    -arch x64

if ($LASTEXITCODE -ne 0) {
    Write-Error "WiX compilation failed"
}

Write-Success "WiX source compiled"

# Link MSI
Write-Step "Linking MSI package..."

& "$WixPath\light.exe" "$BuildDir\Product.wixobj" `
    -out "$BuildDir\${PackageName}-${Version}.msi" `
    -ext WixUIExtension `
    -cultures:en-US

if ($LASTEXITCODE -ne 0) {
    Write-Error "MSI linking failed"
}

Write-Success "MSI package created"

# Output location
Write-Step "Package created: $BuildDir\${PackageName}-${Version}.msi"

# Optional: Sign MSI (requires certificate)
if ($env:SIGNING_CERT) {
    Write-Step "Signing MSI..."
    & signtool.exe sign /f $env:SIGNING_CERT /p $env:SIGNING_PASSWORD `
        /t http://timestamp.digicert.com `
        "$BuildDir\${PackageName}-${Version}.msi"
    Write-Success "MSI signed"
}

Write-Success "Windows MSI build complete!"
Write-Host ""
Write-Host "Install with: msiexec /i $BuildDir\${PackageName}-${Version}.msi"

