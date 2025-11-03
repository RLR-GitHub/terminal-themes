#!/usr/bin/env sh
# Universal Matrix Script Wrapper
# This ensures compatibility across different Unix-like systems
# including Ubuntu/Debian where /bin/sh is dash, not bash

# Script information
VERSION="3.0.0"
SCRIPT_NAME="$(basename "$0")"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Function to find the actual matrix script
find_matrix_script() {
    # Check common locations
    for location in \
        "$HOME/.local/bin/matrix" \
        "$HOME/matrix.sh" \
        "/usr/local/bin/matrix" \
        "/usr/bin/matrix" \
        "$SCRIPT_DIR/matrix" \
        "$SCRIPT_DIR/../themes/bash/matrix-*.sh"
    do
        if [ -f "$location" ] && [ -r "$location" ]; then
            echo "$location"
            return 0
        fi
    done
    
    # Check if a theme-specific script exists
    if [ -n "$RORY_THEME" ]; then
        for location in \
            "$HOME/.local/share/rory-terminal/themes/matrix-${RORY_THEME}.sh" \
            "$SCRIPT_DIR/../themes/bash/matrix-${RORY_THEME}.sh"
        do
            if [ -f "$location" ] && [ -r "$location" ]; then
                echo "$location"
                return 0
            fi
        done
    fi
    
    return 1
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to display error and exit
die() {
    echo "Error: $1" >&2
    exit 1
}

# Main execution
main() {
    # Find the matrix script
    MATRIX_SCRIPT=$(find_matrix_script)
    
    if [ -z "$MATRIX_SCRIPT" ]; then
        die "Matrix script not found. Please run the installer first:
    curl -fsSL https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/installers/install.sh | bash"
    fi
    
    # Check if script is readable
    if [ ! -r "$MATRIX_SCRIPT" ]; then
        die "Cannot read matrix script: $MATRIX_SCRIPT"
    fi
    
    # Determine the best shell to use
    if command_exists bash; then
        # Preferred: Use bash if available
        exec bash "$MATRIX_SCRIPT" "$@"
    elif command_exists zsh; then
        # Fallback 1: Use zsh if available
        echo "Warning: Running with zsh instead of bash. Some features may differ." >&2
        exec zsh "$MATRIX_SCRIPT" "$@"
    elif [ -n "$BASH" ] && [ -x "$BASH" ]; then
        # Fallback 2: Use $BASH environment variable if set
        exec "$BASH" "$MATRIX_SCRIPT" "$@"
    elif [ -x /bin/bash ]; then
        # Fallback 3: Try /bin/bash directly
        exec /bin/bash "$MATRIX_SCRIPT" "$@"
    elif [ -x /usr/bin/bash ]; then
        # Fallback 4: Try /usr/bin/bash directly
        exec /usr/bin/bash "$MATRIX_SCRIPT" "$@"
    elif [ -x /usr/local/bin/bash ]; then
        # Fallback 5: Try /usr/local/bin/bash directly
        exec /usr/local/bin/bash "$MATRIX_SCRIPT" "$@"
    else
        # Last resort: Try with sh, but warn about compatibility
        echo "Warning: bash not found! Running with sh - some features will not work correctly." >&2
        echo "Please install bash: sudo apt-get install bash (on Ubuntu/Debian)" >&2
        
        # Check if the script has bash-specific features
        if grep -q '#!/bin/bash' "$MATRIX_SCRIPT" || \
           grep -q '\[\[' "$MATRIX_SCRIPT" || \
           grep -q '((' "$MATRIX_SCRIPT" || \
           grep -q 'RANDOM' "$MATRIX_SCRIPT"; then
            die "This script requires bash features that are not available in sh.
Please install bash first."
        fi
        
        # Try to run with sh as last resort
        exec sh "$MATRIX_SCRIPT" "$@"
    fi
}

# Run main function
main "$@"
