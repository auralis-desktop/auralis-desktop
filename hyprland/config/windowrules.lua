-- Auralis: Window rules

-- Floating windows
Hyprland.windowrulev2("float", "class:^(pavucontrol)$")
Hyprland.windowrulev2("float", "class:^(nm-connection-editor)$")
Hyprland.windowrulev2("float", "class:^(blueman-manager)$")
Hyprland.windowrulev2("float", "class:^(file-roller)$")
Hyprland.windowrulev2("float", "class:^(imv)$")
Hyprland.windowrulev2("float", "class:^(mpv)$")
Hyprland.windowrulev2("float", "class:^(org.gnome.Calculator)$")
Hyprland.windowrulev2("float", "title:^(Picture-in-Picture)$")
Hyprland.windowrulev2("float", "class:^(xdg-desktop-portal-gtk)$")
Hyprland.windowrulev2("float", "class:^(polkit-gnome-authentication-agent-1)$")

-- Sizes for floating windows
Hyprland.windowrulev2("size 800 600",  "class:^(pavucontrol)$")
Hyprland.windowrulev2("size 700 500",  "class:^(nm-connection-editor)$")
Hyprland.windowrulev2("size 600 500",  "class:^(blueman-manager)$")

-- Center floating windows
Hyprland.windowrulev2("center", "class:^(pavucontrol)$")
Hyprland.windowrulev2("center", "class:^(nm-connection-editor)$")
Hyprland.windowrulev2("center", "class:^(blueman-manager)$")
Hyprland.windowrulev2("center", "class:^(xdg-desktop-portal-gtk)$")

-- Opacity
Hyprland.windowrulev2("opacity 0.95 0.90", "class:^(kitty)$")
Hyprland.windowrulev2("opacity 0.95 0.90", "class:^(code)$")

-- No blur for video players (performance)
Hyprland.windowrulev2("noblur", "class:^(mpv)$")
Hyprland.windowrulev2("noblur", "class:^(vlc)$")

-- Quickshell panels: always on top, no border
Hyprland.windowrulev2("float",       "class:^(quickshell)$")
Hyprland.windowrulev2("noborder",    "class:^(quickshell)$")
Hyprland.windowrulev2("noshadow",    "class:^(quickshell)$")
Hyprland.windowrulev2("noanim",      "class:^(quickshell)$,title:^(auralis-bar)$")
Hyprland.windowrulev2("pin",         "class:^(quickshell)$")

-- Picture in picture
Hyprland.windowrulev2("keepaspectratio",   "title:^(Picture-in-Picture)$")
Hyprland.windowrulev2("pin",               "title:^(Picture-in-Picture)$")

-- Idle inhibit for fullscreen / games
Hyprland.windowrulev2("idleinhibit fullscreen", "class:.*")
