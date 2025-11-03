# Easter Matrix Theme - Pastel Pink, Blue & Green
# PowerShell version for Windows

param(
    [switch]$Init
)

$ErrorActionPreference = "SilentlyContinue"

# Theme configuration
$SYMBOLS = '🐰🥚🐣🌷🌸🦋🌼0123456789!@#$%^&*()_+[]{}|;:<>?'.ToCharArray()
$ALERTS = @("EGG FOUND!", "BUNNY HOP!", "SPRING TIME", "EASTER JOY", "BASKET FULL", "HATCH ALERT", "BLOOM MODE", "HOPPY DAY!")

# Initialize terminal
function Initialize-Terminal {
    [Console]::CursorVisible = $false
    Clear-Host
}

# Cleanup and restore terminal
function Restore-Terminal {
    [Console]::CursorVisible = $true
    Clear-Host
}

# Get ANSI color code for pastel colors
function Get-PastelColor {
    $choice = Get-Random -Maximum 3
    switch ($choice) {
        0 { $colorCode = Get-Random -Minimum 205 -Maximum 211 }  # Pink
        1 { $colorCode = Get-Random -Minimum 117 -Maximum 123 }  # Cyan
        2 { $colorCode = Get-Random -Minimum 120 -Maximum 126 }  # Green
    }
    return "`e[38;5;${colorCode}m"
}

# Matrix rain animation
function Show-MatrixRain {
    $width = [Console]::WindowWidth
    $height = [Console]::WindowHeight
    
    $column = Get-Random -Minimum 1 -Maximum ($width - 1)
    $speed = Get-Random -Minimum 1 -Maximum 10
    $length = Get-Random -Minimum 2 -Maximum 11
    
    for ($i = 0; $i -le ($height + $length); $i++) {
        $symbol = $SYMBOLS | Get-Random
        $color = Get-PastelColor
        
        # Draw symbol
        if ($i -lt $height) {
            [Console]::SetCursorPosition($column, $i)
            Write-Host -NoNewline "$color$symbol`e[0m"
        }
        
        # Erase tail
        if ($i -gt $length) {
            [Console]::SetCursorPosition($column, ($i - $length))
            Write-Host -NoNewline " "
        }
        
        Start-Sleep -Milliseconds (10 * $speed)
    }
}

# Show random alert
function Show-Alert {
    $width = [Console]::WindowWidth
    $height = [Console]::WindowHeight
    
    $alert = $ALERTS | Get-Random
    $row = Get-Random -Minimum 5 -Maximum ($height - 5)
    $col = [Math]::Max(0, ($width - $alert.Length) / 2)
    
    [Console]::SetCursorPosition($col, $row)
    Write-Host -NoNewline "`e[7;1;38;5;205m$alert`e[0m"
    Start-Sleep -Milliseconds 200
    [Console]::SetCursorPosition($col, $row)
    Write-Host -NoNewline (" " * $alert.Length)
}

# Main execution
try {
    Initialize-Terminal
    
    if ($Init) {
        # Run for 5 seconds
        $endTime = (Get-Date).AddSeconds(5)
        
        while ((Get-Date) -lt $endTime) {
            if ((Get-Random -Maximum 10) -eq 0) {
                Show-Alert
            }
            Show-MatrixRain
        }
    } else {
        # Run indefinitely until Ctrl+C
        while ($true) {
            if ((Get-Random -Maximum 20) -eq 0) {
                Show-Alert
            }
            Show-MatrixRain
        }
    }
} finally {
    Restore-Terminal
}

