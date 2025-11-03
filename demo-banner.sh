#!/bin/bash
# Quick demo script to show the ASCII banner

# Source the banner script
source themes/universal/ascii-banner.sh

# Show banner for each theme
themes=("halloween" "christmas" "easter" "hacker" "matrix")

for theme in "${themes[@]}"; do
    clear
    echo "Theme: $theme"
    echo "Press Enter to see the banner..."
    read
    display_banner "$theme"
    echo "Press Enter for next theme..."
    read
done

echo "That's all the themes! The banner adapts its colors to match each theme."
