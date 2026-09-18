<p align="center">
  <img src="worm-logo.svg" alt="TermWorm Logo">
</p>

# TermWorm

**An on-demand, embedded Linux terminal for Klipper and Mainsail/Fluidd.**

TermWorm bridges the gap between your 3D printer's web interface and the host operating system. With a single command, it installs a lightweight web terminal emulator (`ttyd`) and automatically injects a native shortcut button right into your Mainsail or Fluidd sidebar. 

---

## 💡 The "Setup-Sidekick" Workflow

TermWorm is designed as an **on-demand utility tool** rather than a permanent production daemon. The intended lifecycle for the tool is:

1. **Bootstrap Normally:** Use KIAUH or a premade system image to get Klipper, Moonraker, and your web interface up and running (which requires your initial SSH connection).
2. **Deploy TermWorm:** Run the one-line installer to drop the web terminal and quick-removal alias onto your host.
3. **Streamline Your Build:** Use the embedded terminal directly inside your browser for heavy setup tasks:
   * **Grabbing USB IDs:** Quickly copying serial paths like `/dev/serial/by-id/...` directly into your `printer.cfg`.
   * **CAN Bus Configuration:** Bringing up network interfaces, flashing toolhead boards, and scanning for UUIDs without switching windows.
   * **Editing System Files:** Modifying host systemd services, network configurations, or managing system packages.
   * **Quick Diagnostics:** Running `htop`, checking logs, or testing macros on the fly.
4. **Clean Exit:** Once your printer is fully dialed in and calibrated, type `termworm-remove` right in the terminal to completely wipe the utility off the host, securing your system for daily printing.

---

## 🔒 Why No Passwords? (And Why TermWorm is Built This Way)

A common question is: *“Why doesn’t TermWorm ask for a password like a regular SSH login?”*

The short answer is that **TermWorm is a temporary setup utility, not a permanent portal.** However, the technical constraints come down to how the underlying terminal engine (`ttyd`) works:

* **No Dynamic Linux Authentication:** `ttyd` streams a command-line shell directly over a web socket. While it supports a single global static password, it cannot hook into Linux's system authentication (PAM) to dynamically verify individual host usernames and passwords the way standard SSH does.
* **Avoiding Bloat:** To build true host-credential authentication into a tool like this, TermWorm would have to stop being a lightweight shell script. It would require building a custom backend (in Python, Node.js, or Go) to manage user sessions, cookies, secure middleware, and multi-service daemon states.

Instead of turning a simple, elegant helper script into a bloated web application, **TermWorm embraces simplicity.** It assumes you are on a trusted local network during your initial build, helps you get everything configured effortlessly, and provides a single command to clean itself up when you are done.

---

## ⚠️ Security Warning
* This tool is designed strictly for **trusted, local networks (LAN) only** while actively building or configuring your machine.
* **DO NOT** expose your printer or port `7681` to the internet via router port-forwarding, tunneling services (like ngrok or Cloudflare), or public IPs.
* Anyone who can access your Mainsail/Fluidd web interface on your network will have full command-line access to your printer's host OS while the tool is installed. 

---

## 🚀 One-Line Installation

SSH into your Klipper host and run the following command:

```bash
curl -sSL https://raw.githubusercontent.com/Kanrog/TermWorm/main/install.sh | bash
```

Once the script finishes, **refresh your browser tab** (`Ctrl + F5`). You will see a new "Linux Terminal" icon in your sidebar. 

## 🔄 Updating TermWorm

To update TermWorm to the latest version, simply run the one-line installation command again. The script will automatically download the newest `ttyd` binary and overwrite your existing configuration files. 

**Note:** Because the script does not interrupt currently running sessions, you must either reboot your printer host or manually run `sudo systemctl restart ttyd.service` to load the updated version into memory.

## 🗑️ Uninstallation

When you are finished configuring your printer and want to secure your host, simply type the built-in shortcut alias right inside your terminal:

```bash
termworm-remove
```

Alternatively, you can run the uninstallation script remotely via SSH:

```bash
curl -sSL https://raw.githubusercontent.com/Kanrog/TermWorm/main/uninstall.sh | bash
```