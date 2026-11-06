-- Auralis: Input configuration

Hyprland.input({
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "caps:super",
    kb_rules = "",

    follow_mouse = 1,
    sensitivity = 0,
    accel_profile = "flat",

    touchpad = {
        natural_scroll = true,
        disable_while_typing = true,
        tap_to_click = true,
        drag_lock = false,
        scroll_factor = 1.0,
    },
})

Hyprland.gestures({
    workspace_swipe = true,
    workspace_swipe_fingers = 3,
    workspace_swipe_distance = 300,
    workspace_swipe_invert = true,
    workspace_swipe_min_speed_to_force = 30,
    workspace_swipe_cancel_ratio = 0.5,
    workspace_swipe_create_new = true,
})
