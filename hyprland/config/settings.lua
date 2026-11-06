-- Auralis: General settings

Hyprland.general({
    gaps_in = 6,
    gaps_out = 12,
    border_size = 2,
    -- Colors are set via decorations / theme system
    col_active_border = "rgba(7965D9ff) rgba(4FC3F7ff) 45deg",
    col_inactive_border = "rgba(2A2D3Eff)",
    layout = "dwindle",
    resize_on_border = true,
    allow_tearing = false,
})

Hyprland.misc({
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    mouse_move_enables_dpms = true,
    key_press_enables_dpms = true,
    animate_manual_resizes = true,
    animate_mouse_windowdragging = true,
    enable_swallow = true,
    swallow_regex = "^(kitty|alacritty|foot)$",
    focus_on_activate = false,
    new_window_takes_over_fullscreen = 2,
})

Hyprland.dwindle({
    pseudotile = true,
    preserve_split = true,
    smart_split = true,
    smart_resizing = true,
})

Hyprland.master({
    new_status = "slave",
    new_on_top = false,
    mfact = 0.55,
})
