#!/bin/bash
# Halloween Matrix Theme - Spooky Orange & Black

init_term() {
    printf '\e[?1049h\e[?25l'
    shopt -s checkwinsize; (:;:)
    
    # Display banner if available
    if [ -f "$(dirname "$0")/../universal/ascii-banner.sh" ]; then
        source "$(dirname "$0")/../universal/ascii-banner.sh"
        display_banner "halloween" 2>/dev/null || true
    fi
}

cleanup() {
    printf "\e[?1049l\e[?25h"
    clear
    exit 0
}

rain() {
    ((symbolCol = RANDOM % COLUMNS + 1))
    ((symbolSpeed = RANDOM % 9 + 1))
    ((symbolLen = RANDOM % 9 + 2))

    for (( i = 0; i <= LINES + symbolLen; i++ )); do
        symbol="${SYMBOLS:RANDOM % ${#SYMBOLS}:1}"
        color=$((RANDOM % 6 + 202))  # Orange shades (208-214)
        
        printf '\e[%d;%dH\e[38;5;%dm%s\e[0m' "$i" "$symbolCol" "$color" "$symbol"
        (( i > symbolLen )) && printf '\e[%d;%dH ' "$((i - symbolLen))" "$symbolCol"
        sleep "0.0$symbolSpeed"
    done
}

alert() {
    alert_msg=${ALERTS[$((RANDOM % ${#ALERTS[@]}))]}
    row=$((RANDOM % (LINES - 10) + 5))
    col=$(( (COLUMNS - ${#alert_msg}) / 2 ))
    
    printf '\e[s'
    printf '\e[%d;%dH\e[7;1;38;5;196m%s\e[0m' "$row" "$col" "$alert_msg"
    sleep 0.2
    printf '\e[%d;%dH%*s' "$row" "$col" "${#alert_msg}" " "
    printf '\e[u'
}

trap cleanup SIGINT SIGTERM EXIT

SYMBOLS='🎃👻💀🦇🕷️🕸️0123456789!@#$%^&*()_+[]{}|;:<>?'
ALERTS=("BOO!" "HAUNTED!" "GHOST DETECTED" "TRICK OR TREAT" "SPOOKY ALERT" "SPIRITS AWAKEN" "BEWARE!" "CURSED SYSTEM")

init_term

if [ "$1" = "--init" ]; then
    end_time=$((SECONDS + 5))
    while [ $SECONDS -lt $end_time ]; do
        (( RANDOM % 10 == 0 )) && alert
        rain &
        sleep 0.05
    done
    kill $(jobs -p) 2>/dev/null
else
    while true; do
        (( RANDOM % 20 == 0 )) && alert
        rain &
        sleep 0.1
    done
fi

