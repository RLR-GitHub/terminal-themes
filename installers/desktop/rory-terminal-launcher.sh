#!/bin/bash
# Rory Terminal Launcher - Auto-detects terminal emulator and launches appropriately

set -e

# Configuration
RORY_TERMINAL_DIR="${RORY_TERMINAL_DIR:-/opt/rory-terminal}"
THEME_MANAGER="${RORY_TERMINAL_DIR}/core/option1-starship/theme-manager.sh"
MATRIX_DEFAULT="${RORY_TERMINAL_DIR}/themes/bash/matrix-hacker.sh"
THEME_SELECTOR_PY="$(dirname "$0")/theme-selector.py"
THEME_SELECTOR_ZENITY="$(dirname "$0")/theme-selector-zenity.sh"

# Default values
ACTION=""
THEME=""
COMMAND=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --matrix)
            ACTION="matrix"
            shift
            ;;
        --settings)
            ACTION="settings"
            shift
            ;;
        --themes)
            ACTION="themes"
            shift
            ;;
        --theme)
            THEME="$2"
            shift 2
            ;;
        --command)
            COMMAND="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Function to detect terminal emulator
detect_terminal() {
    # Check if we're already in a terminal
    if [ -t 0 ] && [ -t 1 ]; then
        echo "existing"
        return 0
    fi
    
    # Try to detect installed terminal emulators in order of preference
    local terminals=(
        "gnome-terminal"
        "konsole"
        "xfce4-terminal"
        "mate-terminal"
        "lxterminal"
        "terminator"
        "alacritty"
        "kitty"
        "tilix"
        "xterm"
        "urxvt"
        "st"
    )
    
    for terminal in "${terminals[@]}"; do
        if command -v "$terminal" &> /dev/null; then
            echo "$terminal"
            return 0
        fi
    done
    
    echo "none"
    return 1
}

# Function to launch in detected terminal
launch_in_terminal() {
    local terminal="$1"
    local cmd="$2"
    
    case "$terminal" in
        gnome-terminal)
            gnome-terminal -- bash -c "$cmd; exec bash"
            ;;
        konsole)
            konsole -e bash -c "$cmd; exec bash"
            ;;
        xfce4-terminal)
            xfce4-terminal -e "bash -c '$cmd; exec bash'" --hold
            ;;
        mate-terminal)
            mate-terminal -e "bash -c '$cmd; exec bash'"
            ;;
        lxterminal)
            lxterminal -e bash -c "$cmd; exec bash"
            ;;
        terminator)
            terminator -e "bash -c '$cmd; exec bash'"
            ;;
        alacritty)
            alacritty -e bash -c "$cmd; exec bash"
            ;;
        kitty)
            kitty bash -c "$cmd; exec bash"
            ;;
        tilix)
            tilix -e "bash -c '$cmd; exec bash'"
            ;;
        xterm)
            xterm -hold -e bash -c "$cmd"
            ;;
        urxvt)
            urxvt -hold -e bash -c "$cmd"
            ;;
        st)
            st -e bash -c "$cmd; read -p 'Press Enter to close...'"
            ;;
        existing)
            # We're already in a terminal, just run the command
            bash -c "$cmd"
            ;;
        *)
            # Fallback to xterm if available
            if command -v xterm &> /dev/null; then
                xterm -hold -e bash -c "$cmd"
            else
                echo "No terminal emulator found!"
                exit 1
            fi
            ;;
    esac
}

# Function to show GUI theme selector
show_theme_selector() {
    # Try Python GUI first
    if [ -f "$THEME_SELECTOR_PY" ] && command -v python3 &> /dev/null; then
        python3 "$THEME_SELECTOR_PY"
        return 0
    fi
    
    # Try Zenity
    if [ -f "$THEME_SELECTOR_ZENITY" ] && command -v zenity &> /dev/null; then
        bash "$THEME_SELECTOR_ZENITY"
        return 0
    fi
    
    # Try kdialog for KDE
    if command -v kdialog &> /dev/null; then
        local theme=$(kdialog --combobox "Select a theme:" "halloween" "christmas" "easter" "hacker" "matrix" --default "hacker")
        if [ -n "$theme" ]; then
            launch_action "themes" "$theme"
        fi
        return 0
    fi
    
    # Try yad
    if command -v yad &> /dev/null; then
        local theme=$(echo -e "halloween\nchristmas\neaster\nhacker\nmatrix" | yad --list --column="Theme" --title="Rory Terminal Themes" --text="Select a theme:" --height=300)
        if [ -n "$theme" ]; then
            theme=$(echo "$theme" | cut -d'|' -f1)
            launch_action "themes" "$theme"
        fi
        return 0
    fi
    
    # Fallback: Launch terminal with theme manager
    local terminal=$(detect_terminal)
    launch_in_terminal "$terminal" "$THEME_MANAGER list"
}

# Function to launch specific action
launch_action() {
    local action="$1"
    local theme="${2:-$THEME}"
    local terminal=$(detect_terminal)
    
    case "$action" in
        matrix)
            local matrix_script="$MATRIX_DEFAULT"
            if [ -n "$theme" ]; then
                matrix_script="${RORY_TERMINAL_DIR}/themes/bash/matrix-${theme}.sh"
            fi
            
            if [ -f "$matrix_script" ]; then
                launch_in_terminal "$terminal" "$matrix_script"
            else
                echo "Matrix script not found: $matrix_script"
                exit 1
            fi
            ;;
        settings)
            # Open configuration file in default editor
            local config_file="${HOME}/.config/rory-terminal/config.json"
            if [ -f "$config_file" ]; then
                if command -v xdg-open &> /dev/null; then
                    xdg-open "$config_file"
                else
                    launch_in_terminal "$terminal" "${EDITOR:-nano} $config_file"
                fi
            else
                launch_in_terminal "$terminal" "$THEME_MANAGER --help"
            fi
            ;;
        themes)
            if [ -n "$theme" ]; then
                launch_in_terminal "$terminal" "$THEME_MANAGER set $theme"
            else
                show_theme_selector
            fi
            ;;
        *)
            # Default action: open theme manager
            if [ -n "$COMMAND" ]; then
                launch_in_terminal "$terminal" "$COMMAND"
            else
                launch_in_terminal "$terminal" "$THEME_MANAGER"
            fi
            ;;
    esac
}

# Main execution
main() {
    # Check if Rory Terminal is installed
    if [ ! -d "$RORY_TERMINAL_DIR" ]; then
        # Try user installation
        RORY_TERMINAL_DIR="${HOME}/.local/share/rory-terminal"
        if [ ! -d "$RORY_TERMINAL_DIR" ]; then
            echo "Rory Terminal not found!"
            echo "Please install using:"
            echo "  curl -fsSL https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.sh | bash"
            
            # Show notification if possible
            if command -v notify-send &> /dev/null; then
                notify-send "Rory Terminal" "Not installed. Please run the installer." -i dialog-error
            fi
            exit 1
        fi
    fi
    
    # Update paths based on installation directory
    THEME_MANAGER="${RORY_TERMINAL_DIR}/core/option1-starship/theme-manager.sh"
    MATRIX_DEFAULT="${RORY_TERMINAL_DIR}/themes/bash/matrix-hacker.sh"
    
    # Launch the appropriate action
    launch_action "$ACTION"
}

# Run main function
main "$@"
