-- Auralis: Startup / autostart

local function exec(cmd)
    Hyprland.exec("once", cmd)
end

-- Authentication agent
exec("systemctl --user start hyprpolkitagent")

-- D-Bus / portals
exec("/usr/lib/xdg-desktop-portal-hyprland")
exec("/usr/lib/xdg-desktop-portal --replace")

-- PipeWire audio
exec("systemctl --user start pipewire pipewire-pulse wireplumber")

-- Network
exec("systemctl --user start NetworkManager")

-- Bluetooth
exec("systemctl --user start bluetooth")

-- Cursor
exec("hyprctl setcursor Bibata-Modern-Classic 24")

-- Wallpaper (set initial wallpaper via swww or hyprpaper)
exec("swww-daemon")
exec("sleep 1 && swww img ~/.config/hypr/wallpapers/default.jpg --transition-type fade --transition-duration 1")

-- Auralis Shell
exec("quickshell -c ~/.config/quickshell/auralis")

-- Notification daemon (handled by Auralis Shell; fallback)
-- exec("dunst")

-- Idle / screen lock
exec("hypridle")

-- Clipboard manager
exec("wl-paste --type text --watch cliphist store")
exec("wl-paste --type image --watch cliphist store")
