#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting TermWorm uninstallation..."

# 1. Stop and disable the systemd service
echo "Stopping and disabling ttyd service..."
sudo systemctl stop ttyd.service || true
sudo systemctl disable ttyd.service || true

# 2. Remove the service file and reload systemd
echo "Removing systemd service file..."
sudo rm -f /etc/systemd/system/ttyd.service
sudo systemctl daemon-reload

# 3. Remove the UI button
echo "Removing web interface UI button..."
THEME_DIR="$HOME/printer_data/config/.theme"
NAVI_FILE="$THEME_DIR/navi.json"

if [ -f "$NAVI_FILE" ]; then
    rm "$NAVI_FILE"
    echo "Removed $NAVI_FILE"
else
    echo "navi.json not found, skipping."
fi

# 4. Remove the ttyd binary file
echo "Removing ttyd binary..."
sudo rm -f /usr/bin/ttyd

# 5. Remove the bash alias from .bashrc if present
BASHRC="$HOME/.bashrc"
if [ -f "$BASHRC" ]; then
    sed -i '/# TermWorm shortcut/d' "$BASHRC"
    sed -i '/termworm-remove/d' "$BASHRC"
    echo "Removed 'termworm-remove' alias from bash profile."
fi

echo -e "\n\033[1;33m========================================================\033[0m"
echo -e "\033[1;33m 🐛 TermWorm Uninstallation Complete!                   \033[0m"
echo -e "\033[1;33m========================================================\033[0m"
echo -e " Refresh your web interface browser tab (\033[1mCtrl + F5\033[0m)."
echo -e " The Linux Terminal icon has been removed from your sidebar."
echo -e "\033[1;33m========================================================\033[0m\n"