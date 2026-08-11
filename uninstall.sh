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

# 3. Remove the Mainsail UI button
echo "Removing Mainsail UI button..."
THEME_DIR="$HOME/printer_data/config/.theme"
NAVI_FILE="$THEME_DIR/navi.json"

if [ -f "$NAVI_FILE" ]; then
    rm "$NAVI_FILE"
    echo "Removed $NAVI_FILE"
else
    echo "navi.json not found, skipping."
fi

# 4. Uninstall ttyd via the package manager
echo "Removing ttyd package..."
sudo apt-get remove -y ttyd
# Clean up any unused dependencies left behind
sudo apt-get autoremove -y

echo "Uninstallation complete!"
echo "Refresh your Mainsail browser tab and the Linux Terminal icon will be gone."