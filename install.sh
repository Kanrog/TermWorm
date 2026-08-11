#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting Web Terminal (ttyd) and Mainsail shortcut installation..."

# 1. Prepare system and install ttyd
echo "Running system pre-checks..."

# Automatically fix broken or interrupted package management states without user prompts
sudo DEBIAN_FRONTEND=noninteractive dpkg --configure -a

echo "Installing ttyd..."
# Detect system architecture to download the correct binary
ARCH=$(uname -m)
case $ARCH in
    x86_64) TTYD_ARCH="x86_64" ;;
    aarch64) TTYD_ARCH="aarch64" ;;
    armv7l) TTYD_ARCH="armhf" ;;
    armv6l) TTYD_ARCH="armhf" ;;
    *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

echo "Downloading ttyd for $TTYD_ARCH..."
sudo curl -sLo /usr/bin/ttyd "https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.${TTYD_ARCH}"
sudo chmod +x /usr/bin/ttyd

# 2. Create the systemd service for ttyd
echo "Creating systemd service for ttyd..."
SERVICE_FILE="/tmp/ttyd-mainsail.service"

# This runs ttyd on port 7681 and drops you directly into a bash shell
cat <<EOF > $SERVICE_FILE
[Unit]
Description=ttyd web terminal
After=network.target

[Service]
ExecStart=/usr/bin/ttyd -W -p 7681 bash
Restart=always
User=$USER
Group=$USER

[Install]
WantedBy=multi-user.target
EOF

sudo mv $SERVICE_FILE /etc/systemd/system/ttyd.service
sudo systemctl daemon-reload
sudo systemctl enable ttyd.service
sudo systemctl start ttyd.service

# 3. Create the Mainsail navigation button
echo "Configuring Mainsail sidebar..."

# Standard KIAUH and modern Moonraker/Mainsail setups use this path
THEME_DIR="$HOME/printer_data/config/.theme"

if [ ! -d "$THEME_DIR" ]; then
    echo "Creating .theme directory at $THEME_DIR"
    mkdir -p "$THEME_DIR"
fi

NAVI_FILE="$THEME_DIR/navi.json"

# Grab the primary local IP address of the Klipper host automatically
LOCAL_IP=$(hostname -I | awk '{print $1}')

cat <<EOF > "$NAVI_FILE"
[
  {
    "title": "Linux Terminal",
    "href": "http://${LOCAL_IP}:7681",
    "target": "_blank",
    "position": 35,
    "icon": "M4,2H20A2,2 0 0,1 22,4V20A2,2 0 0,1 20,22H4C2.89,22 2,21.1 2,20V4C2,2.89 2.89,2 4,2M11,12.59L7.41,9L6,10.41L11,15.41L12.41,14L11,12.59M13,16V18H19V16H13Z"
  }
]
EOF

echo "Installation complete!"
echo "Refresh your Mainsail browser tab. You should see a new Linux Terminal icon in the sidebar."