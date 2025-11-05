#!/bin/bash
# ASCII Matrix Theme - Cyberpunk Terminal with Blocky ASCII Art
# Interactive terminal with purple-cyan gradient effects

init_term() {
    printf '\e[?1049h\e[?25l'
    shopt -s checkwinsize; (:;:)

    # Ensure COLUMNS and LINES are set
    [ -z "$COLUMNS" ] && COLUMNS=$(tput cols 2>/dev/null || echo 80)
    [ -z "$LINES" ] && LINES=$(tput lines 2>/dev/null || echo 24)

    # Display banner if available
    if [ -f "$(dirname "$0")/../universal/ascii-banner.sh" ]; then
        source "$(dirname "$0")/../universal/ascii-banner.sh"
        display_banner "ascii" 2>/dev/null || true
    fi
}

cleanup() {
    printf "\e[?1049l\e[?25h"
    clear
    exit 0
}

# ASCII Art Banner - Display on startup
show_ascii_banner() {
    # Ensure terminal dimensions are available
    [ -z "$COLUMNS" ] && COLUMNS=$(tput cols 2>/dev/null || echo 80)
    [ -z "$LINES" ] && LINES=$(tput lines 2>/dev/null || echo 24)

    local row=$((LINES / 2 - 8))
    local col=$((COLUMNS / 2 - 35))

    # Prevent negative positioning
    [ $row -lt 0 ] && row=0
    [ $col -lt 0 ] && col=0

    # Purple to cyan gradient colors (ANSI 256-color mode)
    local colors=(141 135 129 123 87 81 75 69 63 57 51 45)

    # r0ry.computer ASCII art
    local banner=(
        "   ██████╗      ██████╗     ██████╗    ██╗   ██╗"
        "   ██╔══██╗    ██╔═████╗    ██╔══██╗   ╚██╗ ██╔╝"
        "   ██████╔╝    ██║██╔██║    ██████╔╝    ╚████╔╝ "
        "   ██╔══██╗    ╚██████╔╝    ██╔══██╗     ╚██╔╝  "
        "   ██║  ██║     ╚═██╔═╝     ██║  ██║      ██║   "
        "   ╚═╝  ╚═╝       ╚═╝       ╚═╝  ╚═╝      ╚═╝   "
        "                                                  "
        "    ╔═══════════════════════════════════════╗    "
        "    ║   CYBERPUNK TERMINAL SYSTEM v4.0      ║    "
        "    ║   > r0ry.computer                     ║    "
        "    ╚═══════════════════════════════════════╝    "
    )

    local line_num=0
    for line in "${banner[@]}"; do
        local color_idx=$((line_num % ${#colors[@]}))
        local color=${colors[$color_idx]}
        printf '\e[%d;%dH\e[38;5;%dm%s\e[0m' $((row + line_num)) "$col" "$color" "$line"
        ((line_num++))
    done

    # Status message
    printf '\e[%d;%dH\e[38;5;51m%s\e[0m' $((row + line_num + 2)) $((COLUMNS / 2 - 20)) "[ INITIALIZING MATRIX PROTOCOL... ]"

    sleep 3
}

# Enhanced rain with ASCII block characters
rain() {
    # Ensure terminal dimensions are available
    [ -z "$COLUMNS" ] && COLUMNS=$(tput cols 2>/dev/null || echo 80)
    [ -z "$LINES" ] && LINES=$(tput lines 2>/dev/null || echo 24)

    ((symbolCol = RANDOM % COLUMNS + 1))
    ((symbolSpeed = RANDOM % 9 + 1))
    ((symbolLen = RANDOM % 12 + 3))

    # Determine if this column should be purple or cyan
    local use_cyan=$((RANDOM % 2))

    for (( i = 0; i <= LINES + symbolLen; i++ )); do
        symbol="${SYMBOLS:RANDOM % ${#SYMBOLS}:1}"

        # Color selection: purple (93-99, 129-141) or cyan (45-51, 81-87)
        if [ $use_cyan -eq 1 ]; then
            color=$((RANDOM % 6 + 45))  # Cyan shades
        else
            color=$((RANDOM % 6 + 135)) # Purple shades
        fi

        # Occasionally use bright accent colors
        if [ $((RANDOM % 20)) -eq 0 ]; then
            color=201  # Hot pink accent
        elif [ $((RANDOM % 20)) -eq 1 ]; then
            color=51   # Bright cyan accent
        fi

        printf '\e[%d;%dH\e[38;5;%dm%s\e[0m' "$i" "$symbolCol" "$color" "$symbol"
        (( i > symbolLen )) && printf '\e[%d;%dH ' "$((i - symbolLen))" "$symbolCol"
        sleep "0.0$symbolSpeed"
    done
}

# Display ASCII art alerts
alert() {
    # Ensure terminal dimensions are available
    [ -z "$COLUMNS" ] && COLUMNS=$(tput cols 2>/dev/null || echo 80)
    [ -z "$LINES" ] && LINES=$(tput lines 2>/dev/null || echo 24)

    alert_msg=${ALERTS[$((RANDOM % ${#ALERTS[@]}))]}
    row=$((RANDOM % (LINES - 12) + 6))
    col=$(( (COLUMNS - 50) / 2 ))

    [ $col -lt 1 ] && col=1

    # Create bordered alert box with cyberpunk styling
    local box_width=50
    local msg_len=${#alert_msg}
    local padding=$(( (box_width - msg_len - 2) / 2 ))

    printf '\e[s'

    # Alert box with gradient border
    printf '\e[%d;%dH\e[38;5;141m╔' "$row" "$col"
    printf '═%.0s' $(seq 1 $((box_width - 2)))
    printf '╗\e[0m'

    printf '\e[%d;%dH\e[38;5;135m║\e[38;5;51m' $((row + 1)) "$col"
    printf '%*s' "$padding" ""
    printf "\e[1m%s\e[0m" "$alert_msg"
    printf '%*s' "$padding" ""
    printf '\e[38;5;135m║\e[0m'

    printf '\e[%d;%dH\e[38;5;129m╚' $((row + 2)) "$col"
    printf '═%.0s' $(seq 1 $((box_width - 2)))
    printf '╝\e[0m'

    sleep 1.5

    # Clear alert
    for i in 0 1 2; do
        printf '\e[%d;%dH%*s' $((row + i)) "$col" "$box_width" " "
    done

    printf '\e[u'
}

# Show ASCII art command tips
show_tips() {
    # Ensure terminal dimensions are available
    [ -z "$COLUMNS" ] && COLUMNS=$(tput cols 2>/dev/null || echo 80)
    [ -z "$LINES" ] && LINES=$(tput lines 2>/dev/null || echo 24)

    local row=$((LINES - 4))
    local tips=(
        "[ Tip: This theme features blocky ASCII art effects ]"
        "[ Tip: The gradient flows from purple to cyan ]"
        "[ Tip: Watch for the cyberpunk alert messages ]"
        "[ Tip: r0ry.computer - SYSTEM READY ]"
        "[ Tip: ASCII characters form the matrix rain ]"
    )

    local tip=${tips[$((RANDOM % ${#tips[@]}))]}
    local col=$(( (COLUMNS - ${#tip}) / 2 ))
    [ $col -lt 1 ] && col=1

    printf '\e[%d;%dH\e[38;5;99m%s\e[0m' "$row" "$col" "$tip"
    sleep 2
    printf '\e[%d;%dH%*s' "$row" "$col" "${#tip}" " "
}

trap cleanup SIGINT SIGTERM EXIT

# Enhanced symbol set with ASCII block characters
SYMBOLS='r0ry.computer>▶◀█▓▒░#@%&*0123456789!()_+[]{}|;:<>?ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝ'
ALERTS=("SYSTEM READY" "COMMAND PROCESSED" "ACCESS GRANTED" "HACK COMPLETE" "SCAN FINISHED" "STATUS UPDATE" "BANNER LOADED" "THEME CHANGED")

init_term

if [ "$1" = "--init" ]; then
    # Show banner on initialization
    show_ascii_banner

    # 5-second animation burst
    end_time=$((SECONDS + 5))
    while [ $SECONDS -lt $end_time ]; do
        (( RANDOM % 15 == 0 )) && alert
        (( RANDOM % 30 == 0 )) && show_tips
        rain &
        sleep 0.05
    done
    kill $(jobs -p) 2>/dev/null
else
    # Continuous mode
    while true; do
        (( RANDOM % 25 == 0 )) && alert
        (( RANDOM % 50 == 0 )) && show_tips
        rain &
        sleep 0.08
    done
fi
