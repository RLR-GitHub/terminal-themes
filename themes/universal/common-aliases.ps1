# Universal Common Aliases for PowerShell
# Works on Windows PowerShell 5.1+ and PowerShell Core 7+

# ================================
# Rory Terminal - PowerShell Aliases
# ================================

# Navigation
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }
function ~ { Set-Location ~ }
Set-Alias -Name home -Value ~

# List files
function ll { Get-ChildItem -Force }
function la { Get-ChildItem -Force -Hidden }

# Git shortcuts (if git is installed)
if (Get-Command git -ErrorAction SilentlyContinue) {
    function g { git @args }
    function gs { git status }
    function gd { git diff }
    function gc { git commit }
    function gca { git commit -a }
    function gcm { param([string]$msg) git commit -m $msg }
    function gp { git push }
    function gpl { git pull }
    function gl { git log --oneline --graph --decorate }
    function gco { param([string]$branch) git checkout $branch }
}

# Directory operations
function mkcd {
    param([string]$Path)
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
    Set-Location $Path
}

# Find files
function find {
    param([string]$Name)
    Get-ChildItem -Recurse -Filter $Name
}

# Search in files
function grep {
    param(
        [string]$Pattern,
        [string]$Path = "."
    )
    Select-String -Path $Path -Pattern $Pattern -Recursive
}

# Process management
function psg {
    param([string]$Name)
    Get-Process | Where-Object { $_.ProcessName -like "*$Name*" }
}

# Network utilities
function Get-MyIP {
    (Invoke-WebRequest -Uri "https://ifconfig.me/ip").Content.Trim()
}
Set-Alias -Name myip -Value Get-MyIP

function Get-LocalIP {
    Get-NetIPAddress -AddressFamily IPv4 | 
        Where-Object { $_.IPAddress -ne "127.0.0.1" } |
        Select-Object -First 1 -ExpandProperty IPAddress
}
Set-Alias -Name localip -Value Get-LocalIP

# System information
function Get-SystemInfo {
    Get-ComputerInfo | Select-Object CsName, WindowsVersion, OsArchitecture, CsProcessors
}
Set-Alias -Name sysinfo -Value Get-SystemInfo

# Disk usage
function Get-DiskUsage {
    Get-PSDrive -PSProvider FileSystem | 
        Select-Object Name, 
                      @{Name="Used(GB)";Expression={[math]::Round($_.Used/1GB,2)}},
                      @{Name="Free(GB)";Expression={[math]::Round($_.Free/1GB,2)}},
                      @{Name="Total(GB)";Expression={[math]::Round(($_.Used+$_.Free)/1GB,2)}}
}
Set-Alias -Name df -Value Get-DiskUsage

# Quick edit
function Edit-Profile {
    & $env:EDITOR $PROFILE
    . $PROFILE
}
Set-Alias -Name editprofile -Value Edit-Profile

# Clean temp files
function Clear-TempFiles {
    Remove-Item $env:TEMP\* -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Temporary files cleared" -ForegroundColor Green
}
Set-Alias -Name cleantemp -Value Clear-TempFiles

# Extract archives
function Expand-Archive-Universal {
    param([string]$Path)
    
    if (-not (Test-Path $Path)) {
        Write-Error "File not found: $Path"
        return
    }
    
    $ext = [System.IO.Path]::GetExtension($Path).ToLower()
    
    switch ($ext) {
        ".zip" { 
            Expand-Archive -Path $Path -DestinationPath (Split-Path $Path)
        }
        ".7z" {
            if (Get-Command 7z -ErrorAction SilentlyContinue) {
                & 7z x $Path
            } else {
                Write-Error "7-Zip not installed"
            }
        }
        ".rar" {
            if (Get-Command unrar -ErrorAction SilentlyContinue) {
                & unrar x $Path
            } else {
                Write-Error "unrar not installed"
            }
        }
        default {
            Write-Error "Unsupported archive format: $ext"
        }
    }
}
Set-Alias -Name extract -Value Expand-Archive-Universal

# Quick server
function Start-HTTPServer {
    param([int]$Port = 8000)
    
    Write-Host "Starting HTTP server on port $Port..." -ForegroundColor Green
    Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
    
    if (Get-Command python -ErrorAction SilentlyContinue) {
        python -m http.server $Port
    } elseif (Get-Command python3 -ErrorAction SilentlyContinue) {
        python3 -m http.server $Port
    } else {
        Write-Error "Python not installed"
    }
}
Set-Alias -Name serve -Value Start-HTTPServer

# Weather
function Get-Weather {
    param([string]$Location = "")
    (Invoke-WebRequest -Uri "https://wttr.in/$Location").Content
}
Set-Alias -Name weather -Value Get-Weather

# Cheat sheet
function Get-Cheat {
    param([string]$Command)
    (Invoke-WebRequest -Uri "https://cheat.sh/$Command").Content
}
Set-Alias -Name cheat -Value Get-Cheat

# Rory Terminal specific
if (Test-Path "$env:LOCALAPPDATA\RoryTerminal\Matrix.ps1") {
    function Invoke-MatrixHalloween {
        $env:RORY_THEME = "halloween"
        & "$env:LOCALAPPDATA\RoryTerminal\Matrix.ps1" -Init
    }
    Set-Alias -Name matrix-h -Value Invoke-MatrixHalloween
    
    function Invoke-MatrixChristmas {
        $env:RORY_THEME = "christmas"
        & "$env:LOCALAPPDATA\RoryTerminal\Matrix.ps1" -Init
    }
    Set-Alias -Name matrix-c -Value Invoke-MatrixChristmas
    
    function Invoke-MatrixEaster {
        $env:RORY_THEME = "easter"
        & "$env:LOCALAPPDATA\RoryTerminal\Matrix.ps1" -Init
    }
    Set-Alias -Name matrix-e -Value Invoke-MatrixEaster
    
    function Invoke-MatrixHacker {
        $env:RORY_THEME = "hacker"
        & "$env:LOCALAPPDATA\RoryTerminal\Matrix.ps1" -Init
    }
    Set-Alias -Name matrix-m -Value Invoke-MatrixHacker
}

# Enhanced prompt (if Starship not installed)
if (-not (Get-Command starship -ErrorAction SilentlyContinue)) {
    function prompt {
        $loc = Get-Location
        $gitBranch = ""
        
        if (Get-Command git -ErrorAction SilentlyContinue) {
            $gitBranch = git branch --show-current 2>$null
            if ($gitBranch) {
                $gitBranch = " [$gitBranch]"
            }
        }
        
        Write-Host "PS " -NoNewline -ForegroundColor Green
        Write-Host $loc -NoNewline -ForegroundColor Cyan
        Write-Host $gitBranch -NoNewline -ForegroundColor Yellow
        return "> "
    }
}

Write-Host "Rory Terminal PowerShell Aliases Loaded" -ForegroundColor Green

