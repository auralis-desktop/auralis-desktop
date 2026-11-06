-- Auralis: Monitor configuration
-- Uses preferred mode with automatic layout

-- Primary monitor: auto-detect preferred resolution and refresh rate
Hyprland.monitor("", "preferred", "auto", "1")

-- Example for a specific monitor (uncomment and adjust as needed):
-- Hyprland.monitor("DP-1", "2560x1440@165", "0x0", "1")
-- Hyprland.monitor("HDMI-A-1", "1920x1080@60", "2560x0", "1")

-- Laptop built-in display
-- Hyprland.monitor("eDP-1", "1920x1200@60", "auto", "1.25")
