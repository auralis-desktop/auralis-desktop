# Installation Guide

## System requirements

| Requirement | Minimum |
|---|---|
| OS | Arch Linux or Arch-based |
| Hyprland | 0.40+ |
| Quickshell | 0.3+ |
| Qt | 6.6+ |
| GPU | Vulkan-capable recommended |
| RAM | 512 MB free (shell idle ~80 MB) |

## Quick install

```bash
git clone https://github.com/auralis-desktop/auralis-desktop.git
cd auralis
./install.sh
```

## Manual install

### 1. Install Hyprland

```bash
sudo pacman -S hyprland
```

### 2. Install Quickshell (AUR)

```bash
paru -S quickshell
# or: yay -S quickshell
```

### 3. Install dependencies

```bash
sudo pacman -S qt6-base qt6-declarative qt6-wayland qt6-svg \
  pipewire pipewire-pulse wireplumber \
  networkmanager bluez bluez-utils \
  brightnessctl playerctl grim slurp wl-clipboard \
  xdg-desktop-portal-hyprland noto-fonts ttf-jetbrains-mono-nerd jq

paru -S swww bibata-cursor-theme ttf-material-symbols-variable-git hyprpolkitagent
```

### 4. Copy configuration files

```bash
# Backup existing configs
cp -ra ~/.config/hypr ~/.config/hypr.bak 2>/dev/null || true
cp -ra ~/.config/quickshell ~/.config/quickshell.bak 2>/dev/null || true

# Install Hyprland config
mkdir -p ~/.config/hypr/config
cp hyprland/hyprland.lua ~/.config/hypr/
cp hyprland/config/*.lua ~/.config/hypr/config/

# Install shell
mkdir -p ~/.config/quickshell/auralis
cp -ra shell/. ~/.config/quickshell/auralis/
```

### 5. Start Hyprland

Log out and select Hyprland at your display manager, or run:

```bash
Hyprland
```

## Updating

```bash
cd auralis
git pull
./install.sh
```

## Uninstalling

```bash
./installer/uninstall.sh
```

This removes only Auralis files. Your backups are in `~/.auralis-backup/`.

## Restoring a backup

```bash
ls ~/.auralis-backup/          # list backups
cp -ra ~/.auralis-backup/TIMESTAMP/. ~/
```

## Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).
