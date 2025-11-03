#!/bin/bash
# Zenity-based theme selector for systems without Python/Tkinter

# Configuration
RORY_TERMINAL_DIR="${RORY_TERMINAL_DIR:-/opt/rory-terminal}"
THEME_MANAGER="${RORY_TERMINAL_DIR}/core/option1-starship/theme-manager.sh"

# Check installation
if [ ! -d "$RORY_TERMINAL_DIR" ]; then
    RORY_TERMINAL_DIR="${HOME}/.local/share/rory-terminal"
    if [ ! -d "$RORY_TERMINAL_DIR" ]; then
        zenity --error --text="Rory Terminal not found!\nPlease install first."
        exit 1
    fi
fi

# Update paths
THEME_MANAGER="${RORY_TERMINAL_DIR}/core/option1-starship/theme-manager.sh"

# Get current theme
CURRENT_THEME="hacker"
if [ -f "${HOME}/.config/rory-terminal/current-theme" ]; then
    CURRENT_THEME=$(cat "${HOME}/.config/rory-terminal/current-theme" 2>/dev/null)
fi

# Show theme selector
SELECTED_THEME=$(zenity --list \
    --title="Rory Terminal Theme Selector" \
    --text="Select your cyberpunk terminal theme:" \
    --radiolist \
    --column="Select" \
    --column="Theme ID" \
    --column="Theme" \
    --column="Description" \
    --hide-column=2 \
    --width=600 \
    --height=400 \
    $([ "$CURRENT_THEME" == "halloween" ] && echo "TRUE" || echo "FALSE") "halloween" "🎃 Halloween" "Spooky orange matrix rain" \
    $([ "$CURRENT_THEME" == "christmas" ] && echo "TRUE" || echo "FALSE") "christmas" "🎄 Christmas" "Festive red and green" \
    $([ "$CURRENT_THEME" == "easter" ] && echo "TRUE" || echo "FALSE") "easter" "🐰 Easter" "Pastel rainbow colors" \
    $([ "$CURRENT_THEME" == "hacker" ] && echo "TRUE" || echo "FALSE") "hacker" "💻 Hacker" "Bright green cyberpunk" \
    $([ "$CURRENT_THEME" == "matrix" ] && echo "TRUE" || echo "FALSE") "matrix" "🟢 Matrix" "Classic Matrix green")

# Check if user cancelled
if [ -z "$SELECTED_THEME" ]; then
    exit 0
fi

# Apply theme
if zenity --question --text="Apply $SELECTED_THEME theme?"; then
    # Show progress
    (
        echo "10"; echo "# Applying $SELECTED_THEME theme..."
        "$THEME_MANAGER" set "$SELECTED_THEME" 2>&1
        echo "100"; echo "# Theme applied!"
    ) | zenity --progress \
        --title="Applying Theme" \
        --text="Applying theme..." \
        --auto-close \
        --auto-kill
    
    # Show success
    zenity --info --text="$SELECTED_THEME theme applied!\nOpen a new terminal to see the changes."
fi
