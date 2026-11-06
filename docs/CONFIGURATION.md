# Configuration

Auralis is configured through a single JSON file and the in-shell settings UI.

## Settings file

Path: `~/.config/quickshell/auralis/config/settings.json`

The settings UI writes this file automatically. You can also edit it by hand
and reload Quickshell (`SUPER + CTRL + R`).

### Appearance

```json
"appearance": {
  "themeMode":       "dark",     // "light" | "dark"
  "dynamicColor":    true,       // follow wallpaper accent
  "transparency":    0.85,       // 0.0 – 1.0
  "blur":            true,
  "blurStrength":    8,          // 1 – 20
  "shadowIntensity": 0.6,
  "cornerRadius":    12,         // px
  "animationSpeed":  1.0,        // multiplier
  "density":         "comfortable"
}
```

### Bar

```json
"bar": {
  "enabled":      true,
  "position":     "top",         // "top" | "bottom"
  "height":       48,            // px
  "transparency": 0.85,
  "autohide":     false,
  "clockFormat":  "HH:mm",       // Qt date format
  "showDate":     true
}
```

### Notifications

```json
"notifications": {
  "dnd":         false,
  "duration":    5000,           // ms
  "position":    "top-right",
  "maxVisible":  5
}
```

### Hyprland

These are applied live via `hyprctl keyword`.

```json
"hyprland": {
  "gapsIn":     6,
  "gapsOut":    12,
  "borderSize": 2,
  "rounding":   12,
  "blur":       true,
  "shadows":    true
}
```

## Hyprland Lua modules

Each file in `~/.config/hypr/config/` controls one aspect:

| File | Controls |
|---|---|
| `environment.lua` | Wayland env vars |
| `monitors.lua` | Monitor layout |
| `input.lua` | Keyboard, mouse, touchpad |
| `settings.lua` | Gaps, borders, misc |
| `decorations.lua` | Blur, shadows, rounding |
| `animations.lua` | Motion curves and timing |
| `keybinds.lua` | All keyboard shortcuts |
| `windowrules.lua` | Per-app rules |
| `workspaces.lua` | Workspace names and layout |
| `startup.lua` | Autostart programs |

## Adding a keybind

Edit `~/.config/hypr/config/keybinds.lua`:

```lua
Hyprland.bind("SUPER", "T", "exec", "your-app")
```

Reload: `hyprctl reload` or `SUPER + SHIFT + R`.

## Changing the monitor layout

Edit `~/.config/hypr/config/monitors.lua`:

```lua
Hyprland.monitor("DP-1",   "2560x1440@165", "0x0",    "1")
Hyprland.monitor("HDMI-A-1","1920x1080@60", "2560x0", "1")
```

Run `hyprctl monitors` to list your monitors.
