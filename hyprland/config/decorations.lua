-- Auralis: Window decorations

Hyprland.decoration({
    rounding = 12,
    active_opacity = 1.0,
    inactive_opacity = 0.95,
    fullscreen_opacity = 1.0,

    drop_shadow = true,
    shadow_range = 20,
    shadow_render_power = 3,
    shadow_color = "rgba(00000066)",
    shadow_offset = "0 4",

    blur = {
        enabled = true,
        size = 8,
        passes = 3,
        noise = 0.015,
        contrast = 0.9,
        brightness = 0.85,
        vibrancy = 0.2,
        vibrancy_darkness = 0.0,
        new_optimizations = true,
        xray = false,
        ignore_opacity = false,
        popups = true,
        popups_ignorealpha = 0.2,
    },
})
