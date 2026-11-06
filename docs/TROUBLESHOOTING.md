# Troubleshooting

## Quickshell won't start

**Symptom:** Black screen, no bar after login.

1. Check Quickshell is installed: `which qs`
2. Run manually to see errors: `quickshell -c ~/.config/quickshell/auralis`
3. Check Qt6 is installed: `pacman -Q qt6-declarative`
4. Check the log: `journalctl --user -u quickshell`

## Bar is missing

1. Confirm Auralis Shell is running: `pgrep -a quickshell`
2. Check `barEnabled` in `~/.config/quickshell/auralis/config/settings.json`
3. Restart the shell: `SUPER + CTRL + R`

## Hyprland won't load `hyprland.lua`

Hyprland Lua support requires **0.40+**.

```bash
hyprctl version
```

If using an older version, rename the file:
```bash
cp ~/.config/hypr/hyprland.lua ~/.config/hypr/hyprland.lua.bak
```
And manually convert to `hyprland.conf`.

## Icons are missing (question marks / boxes)

Install the Material Symbols font:

```bash
paru -S ttf-material-symbols-variable-git
fc-cache -fv
```

Then restart Quickshell.

## Audio controls don't work

Ensure PipeWire is running:

```bash
systemctl --user status pipewire wireplumber
systemctl --user start pipewire wireplumber
```

## Wi-Fi toggle does nothing

Ensure NetworkManager is running:

```bash
systemctl status NetworkManager
sudo systemctl enable --now NetworkManager
```

## No wallpaper

1. Put a JPEG or PNG in `~/Pictures/Wallpapers/`
2. Open Quick Settings → open Wallpaper Picker and select one
3. Or run: `swww img ~/Pictures/Wallpapers/yourfile.jpg`

## Brightness slider does nothing

Ensure `brightnessctl` is installed and your user has access:

```bash
sudo usermod -aG video $USER
newgrp video
```

## Settings don't persist after reboot

Check that `~/.config/quickshell/auralis/config/` is writable:

```bash
ls -la ~/.config/quickshell/auralis/config/
```

## Getting help

- Open an issue: https://github.com/auralis-desktop/auralis-desktop/issues
- Check Hyprland docs: https://wiki.hyprland.org
- Check Quickshell docs: https://quickshell.outfoxxed.me
