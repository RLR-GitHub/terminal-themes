# ASCII Matrix Theme - Cyberpunk Terminal with Blocky ASCII Art
# PowerShell version for Windows
# Interactive terminal with purple-cyan gradient effects

param(
    [switch]$Init
)

$ErrorActionPreference = "SilentlyContinue"

# Theme configuration
$SYMBOLS = 'r0ry.computer>▶◀█▓▒░#@%&*0123456789!()_+[]{}|;:<>?ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝ'.ToCharArray()
$ALERTS = @("SYSTEM READY", "COMMAND PROCESSED", "ACCESS GRANTED", "HACK COMPLETE", "SCAN FINISHED", "STATUS UPDATE", "BANNER LOADED", "THEME CHANGED")

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

# Display ASCII art banner
function Show-AsciiBanner {
    $width = [Console]::WindowWidth
    $height = [Console]::WindowHeight

    $row = [Math]::Max(0, ($height / 2) - 8)
    $col = [Math]::Max(0, ($width / 2) - 35)

    # Purple to cyan gradient colors (ANSI 256-color mode)
    $colors = @(141, 135, 129, 123, 87, 81, 75, 69, 63, 57, 51, 45)

    # ASCII art banner
    $banner = @(
        "   ██████╗      ██████╗     ██████╗    ██╗   ██╗",
        "   ██╔══██╗    ██╔═████╗    ██╔══██╗   ╚██╗ ██╔╝",
        "   ██████╔╝    ██║██╔██║    ██████╔╝    ╚████╔╝ ",
        "   ██╔══██╗    ╚██████╔╝    ██╔══██╗     ╚██╔╝  ",
        "   ██║  ██║     ╚═██╔═╝     ██║  ██║      ██║   ",
        "   ╚═╝  ╚═╝       ╚═╝       ╚═╝  ╚═╝      ╚═╝   ",
        "                                                  ",
        "    ╔═══════════════════════════════════════╗    ",
        "    ║   CYBERPUNK TERMINAL SYSTEM v4.0      ║    ",
        "    ║   > r0ry.computer                     ║    ",
        "    ╚═══════════════════════════════════════╝    "
    )

    $lineNum = 0
    foreach ($line in $banner) {
        $colorIdx = $lineNum % $colors.Count
        $color = $colors[$colorIdx]

        try {
            [Console]::SetCursorPosition($col, ($row + $lineNum))
            Write-Host -NoNewline "`e[38;5;${color}m$line`e[0m"
        } catch {
            # Ignore positioning errors
        }
        $lineNum++
    }

    # Status message
    try {
        [Console]::SetCursorPosition(($width / 2) - 20, ($row + $lineNum + 2))
        Write-Host -NoNewline "`e[38;5;51m[ INITIALIZING MATRIX PROTOCOL... ]`e[0m"
    } catch {
        # Ignore positioning errors
    }

    Start-Sleep -Seconds 3
}

# Get color for purple or cyan shades
function Get-GradientColor {
    $useCyan = (Get-Random -Maximum 2) -eq 1

    if ($useCyan) {
        # Cyan shades
        $colorCode = Get-Random -Minimum 45 -Maximum 51
    } else {
        # Purple shades
        $colorCode = Get-Random -Minimum 135 -Maximum 141
    }

    # Occasionally use bright accent colors
    $rand = Get-Random -Maximum 20
    if ($rand -eq 0) {
        $colorCode = 201  # Hot pink accent
    } elseif ($rand -eq 1) {
        $colorCode = 51   # Bright cyan accent
    }

    return "`e[38;5;${colorCode}m"
}

# Matrix rain animation with gradient
function Show-MatrixRain {
    $width = [Console]::WindowWidth
    $height = [Console]::WindowHeight

    $column = Get-Random -Minimum 1 -Maximum ($width - 1)
    $speed = Get-Random -Minimum 1 -Maximum 10
    $length = Get-Random -Minimum 3 -Maximum 13

    for ($i = 0; $i -le ($height + $length); $i++) {
        $symbol = $SYMBOLS | Get-Random
        $color = Get-GradientColor

        # Draw symbol
        if ($i -lt $height) {
            try {
                [Console]::SetCursorPosition($column, $i)
                Write-Host -NoNewline "$color$symbol`e[0m"
            } catch {
                # Ignore positioning errors
            }
        }

        # Erase tail
        if ($i -gt $length) {
            try {
                [Console]::SetCursorPosition($column, ($i - $length))
                Write-Host -NoNewline " "
            } catch {
                # Ignore positioning errors
            }
        }

        Start-Sleep -Milliseconds (10 * $speed)
    }
}

# Show ASCII art alert with bordered box
function Show-Alert {
    $width = [Console]::WindowWidth
    $height = [Console]::WindowHeight

    $alert = $ALERTS | Get-Random
    $row = Get-Random -Minimum 6 -Maximum ($height - 12)
    $boxWidth = 50
    $col = [Math]::Max(1, ($width - $boxWidth) / 2)

    $msgLen = $alert.Length
    $padding = [Math]::Max(0, ($boxWidth - $msgLen - 2) / 2)
    $paddingStr = " " * $padding

    # Draw bordered alert box
    try {
        # Top border
        [Console]::SetCursorPosition($col, $row)
        Write-Host -NoNewline "`e[38;5;141m╔$('═' * ($boxWidth - 2))╗`e[0m"

        # Message line
        [Console]::SetCursorPosition($col, ($row + 1))
        Write-Host -NoNewline "`e[38;5;135m║`e[38;5;51m$paddingStr`e[1m$alert`e[0m`e[38;5;51m$paddingStr`e[38;5;135m║`e[0m"

        # Bottom border
        [Console]::SetCursorPosition($col, ($row + 2))
        Write-Host -NoNewline "`e[38;5;129m╚$('═' * ($boxWidth - 2))╝`e[0m"
    } catch {
        # Ignore positioning errors
    }

    Start-Sleep -Milliseconds 1500

    # Clear alert
    for ($i = 0; $i -le 2; $i++) {
        try {
            [Console]::SetCursorPosition($col, ($row + $i))
            Write-Host -NoNewline (" " * $boxWidth)
        } catch {
            # Ignore positioning errors
        }
    }
}

# Show tips at bottom
function Show-Tips {
    $width = [Console]::WindowWidth
    $height = [Console]::WindowHeight

    $tips = @(
        "[ Tip: This theme features blocky ASCII art effects ]",
        "[ Tip: The gradient flows from purple to cyan ]",
        "[ Tip: Watch for the cyberpunk alert messages ]",
        "[ Tip: r0ry.computer - SYSTEM READY ]",
        "[ Tip: ASCII characters form the matrix rain ]"
    )

    $tip = $tips | Get-Random
    $row = $height - 4
    $col = [Math]::Max(1, ($width - $tip.Length) / 2)

    try {
        [Console]::SetCursorPosition($col, $row)
        Write-Host -NoNewline "`e[38;5;99m$tip`e[0m"
        Start-Sleep -Seconds 2
        [Console]::SetCursorPosition($col, $row)
        Write-Host -NoNewline (" " * $tip.Length)
    } catch {
        # Ignore positioning errors
    }
}

# Main execution
try {
    Initialize-Terminal

    if ($Init) {
        # Show banner on initialization
        Show-AsciiBanner

        # Run for 5 seconds
        $endTime = (Get-Date).AddSeconds(5)

        while ((Get-Date) -lt $endTime) {
            if ((Get-Random -Maximum 15) -eq 0) {
                Show-Alert
            }
            if ((Get-Random -Maximum 30) -eq 0) {
                Show-Tips
            }
            Show-MatrixRain
        }
    } else {
        # Run indefinitely until Ctrl+C
        while ($true) {
            if ((Get-Random -Maximum 25) -eq 0) {
                Show-Alert
            }
            if ((Get-Random -Maximum 50) -eq 0) {
                Show-Tips
            }
            Show-MatrixRain
        }
    }
} finally {
    Restore-Terminal
}
