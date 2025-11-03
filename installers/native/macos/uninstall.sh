#!/bin/bash
# Uninstall Rory Terminal from macOS

echo "Uninstalling Rory Terminal..."

# Remove files
sudo rm -rf /usr/local/share/rory-terminal
sudo rm -rf /usr/local/etc/rory-terminal
sudo rm -f /usr/local/bin/rory-theme
sudo rm -f /usr/local/bin/rory-matrix
sudo rm -f /usr/local/bin/rory-terminal-uninstall

# Remove from shell configs
for config in ~/.bashrc ~/.zshrc; do
    if [[ -f "$config" ]]; then
        sed -i.bak '/# Rory Terminal/d' "$config"
        sed -i.bak '/rory-/d' "$config"
        rm -f "${config}.bak"
    fi
done

# Remove config directory
rm -rf ~/.config/rory-terminal

echo "Uninstall complete!"
echo "You may need to restart your terminal for changes to take effect."

