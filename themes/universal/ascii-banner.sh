#!/bin/bash
# ASCII Banner for Rory's Matrix Terminal

# Function to display the banner with theme-specific colors
display_banner() {
    local theme="${1:-hacker}"
    
    # Define color codes based on theme
    case "$theme" in
        halloween)
            local color1="\e[38;5;208m"  # Orange
            local color2="\e[38;5;214m"  # Light orange
            ;;
        christmas)
            local color1="\e[38;5;196m"  # Red
            local color2="\e[38;5;46m"   # Green
            ;;
        easter)
            local color1="\e[38;5;213m"  # Pink
            local color2="\e[38;5;87m"   # Light blue
            ;;
        hacker)
            local color1="\e[38;5;46m"   # Bright green
            local color2="\e[38;5;82m"   # Light green
            ;;
        matrix)
            local color1="\e[38;5;46m"   # Green
            local color2="\e[38;5;40m"   # Darker green
            ;;
        ascii)
            local color1="\e[38;5;141m"  # Purple
            local color2="\e[38;5;51m"   # Cyan
            ;;
        *)
            local color1="\e[38;5;201m"  # Magenta/Pink
            local color2="\e[38;5;51m"   # Cyan
            ;;
    esac
    
    local reset="\e[0m"
    
    # Clear screen and position cursor
    clear
    echo -e "\n"
    
    # Display ASCII art banner
    echo -e "${color1}  >${reset}                                                                           "
    echo -e "                                                                              "
    echo -e "  ${color1}######${reset}     ${color1}######${reset}    ${color1}######${reset}   ${color1}#${reset}    ${color1}#${reset}      "
    echo -e "  ${color1}#${reset}     ${color1}#${reset}   ${color1}#${reset}     ${color1}#${reset}   ${color1}#${reset}     ${color1}#${reset}  ${color1}#${reset}    ${color1}#${reset}      "
    echo -e "  ${color1}#${reset}     ${color1}#${reset}   ${color1}#${reset}     ${color1}#${reset}   ${color1}#${reset}     ${color1}#${reset}  ${color2}#${reset}  ${color2}#${reset}       "
    echo -e "  ${color1}######${reset}    ${color1}#${reset}     ${color1}#${reset}   ${color1}######${reset}    ${color2}##${reset}         "
    echo -e "  ${color1}#${reset}   ${color1}#${reset}     ${color1}#${reset}     ${color1}#${reset}   ${color1}#${reset}   ${color1}#${reset}      ${color2}#${reset}          "
    echo -e "  ${color1}#${reset}    ${color1}#${reset}    ${color1}#${reset}     ${color1}#${reset}   ${color1}#${reset}    ${color1}#${reset}     ${color2}#${reset}          "
    echo -e "  ${color1}#${reset}     ${color1}#${reset}   ${color1}######${reset}    ${color1}#${reset}     ${color1}#${reset}    ${color2}#${reset}          "
    echo -e "                                                                              "
    echo -e "\n${reset}"
}

# Export the function for use in other scripts
export -f display_banner
