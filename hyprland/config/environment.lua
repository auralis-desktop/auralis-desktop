-- Auralis: Environment variables
-- Wayland / Qt / Electron / XDG

Hyprland.env("XCURSOR_SIZE", "24")
Hyprland.env("XCURSOR_THEME", "Bibata-Modern-Classic")
Hyprland.env("QT_QPA_PLATFORM", "wayland")
Hyprland.env("QT_QPA_PLATFORMTHEME", "qt6ct")
Hyprland.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
Hyprland.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
Hyprland.env("GDK_BACKEND", "wayland,x11,*")
Hyprland.env("SDL_VIDEODRIVER", "wayland")
Hyprland.env("CLUTTER_BACKEND", "wayland")
Hyprland.env("XDG_CURRENT_DESKTOP", "Hyprland")
Hyprland.env("XDG_SESSION_TYPE", "wayland")
Hyprland.env("XDG_SESSION_DESKTOP", "Hyprland")
Hyprland.env("MOZ_ENABLE_WAYLAND", "1")
Hyprland.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
Hyprland.env("NIXOS_OZONE_WL", "1")
