#!/bin/bash
# Classic Matrix Theme - Original Black & Green

init_term() {
    printf '\e[?1049h\e[?25l'
    shopt -s checkwinsize; (:;:)
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
        color=$((RANDOM % 6 + 82))  # Green shades (256-color mode)
        
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
    printf '\e[%d;%dH\e[7;1;31m%s\e[0m' "$row" "$col" "$alert_msg"
    sleep 0.2
    printf '\e[%d;%dH%*s' "$row" "$col" "${#alert_msg}" " "
    printf '\e[u'
}

trap cleanup SIGINT SIGTERM EXIT

SYMBOLS='0123456789!@#$%^&*()-_=+[]{}|;:,.<>?ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝ'
ALERTS=("BREACH DETECTED" "NODE COMPROMISED" "SYSTEM ALERT" "HACK IN PROGRESS" "FIREWALL BREACHED" "INTRUSION DETECTED" "CODE RED" "ACCESS DENIED")

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

