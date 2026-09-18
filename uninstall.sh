#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting TermWorm uninstallation..."

# 1. Remove the UI button (Searches all home directories)
echo "Removing web interface UI button..."
for NAVI_FILE in /home/*/printer_data/config/.theme/navi.json "$HOME/printer_data/config/.theme/navi.json"; do
    if [ -f "$NAVI_FILE" ]; then
        sudo rm -f "$NAVI_FILE"
        echo "Removed $NAVI_FILE"
    fi
done

# 2. Remove the bash alias from .bashrc across all user profiles
echo "Cleaning up shell aliases..."
for BASHRC in /home/*/.bashrc "$HOME/.bashrc"; do
    if [ -f "$BASHRC" ]; then
        sudo sed -i '/# TermWorm shortcut/d' "$BASHRC"
        sudo sed -i '/termworm-remove/d' "$BASHRC"
    fi
done

# 3. Remove the ttyd binary file
echo "Removing ttyd binary..."
sudo rm -f /usr/bin/ttyd

# 4. Disable systemd service and remove the file
echo "Removing systemd service configuration..."
sudo systemctl disable ttyd.service || true
sudo rm -f /etc/systemd/system/ttyd.service
sudo systemctl daemon-reload

echo -e "\n\033[1;33m========================================================\033[0m"
echo -e "\033[1;33m 🐛 TermWorm Uninstallation Complete!                   \033[0m"
echo -e "\033[1;33m========================================================\033[0m"
echo -e " Refresh your web interface browser tab (\033[1mCtrl + F5\033[0m)."
echo -e " The Linux Terminal icon has been removed from your sidebar."
echo -e " (This terminal session will now close.)"
echo -e "\033[1;33m========================================================\033[0m\n"

# 5. Stop the service last (this will instantly kill the session if run from inside TermWorm)
sudo systemctl stop ttyd.service || true