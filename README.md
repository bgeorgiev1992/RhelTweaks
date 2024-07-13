# Rhel Workstation 9 Post-Installation Tweaks

## Rhel9-PostInstall.sh
This script automates post-installation setup for Fedora 40. It includes tasks such as system updates, installation of essential software, and configuration of system settings.

**Features:**

- Delete and Disable Bash History: Clears and disables bash history to enhance security.
- Change Hostname: Allows the user to change the system hostname.
- Speed Up DNF: Configures DNF for faster package downloads and updates.
- System Update: Cleans, updates, upgrades, and synchronizes system packages.
- Firmware Update: Updates system firmware using fwupdmgr.
- Install RPM Fusion Repositories: Adds free and non-free RPM Fusion repositories for additional software packages.
- Install Media Codecs: Installs the complete gstreamer stack, ffmpeg, h264.
- Install Full Mesa Stack: Adds support for Vulkan and DirectX.
- Install Archive Formats: Adds support for zip and rar.
- Install Fonts: Installs Roboto and Cascadia.
- Install and Add Support for RubyGems
- Options to Install: Google Chrome and Sublime Text.
- Install Various Software via Flatpak: Installs software like Deezer, GIMP, Inkscape, Planify, and Poedit via Flatpak.

**Usage:**

Clone this repository. Make Fedora40-PostInstall.sh executable and run.

```bash
git clone https://github.com/bgeorgiev1992/FedoraTweaks.git
cd RhelTweaks
chmod +x Rhel9-PostInstall.sh
./Rhel9-PostInstall.sh
```

The script will prompt you for confirmation before executing each task. You can respond with y (yes) or n (no) to proceed with or skip each step.

## Attention:

**Please be aware that this script is used at your own risk. I do not assume responsibility or provide warranties for any damage to your system that may occur as a result of using this script. It is recommended to proceed with caution and ensure you have backups in place before executing any commands.**
