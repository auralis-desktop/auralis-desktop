-- Auralis: Keybindings
-- SUPER = Windows/Meta key

local SUPER = "SUPER"
local SUPER_SHIFT = "SUPER SHIFT"
local SUPER_CTRL = "SUPER CTRL"
local SUPER_ALT = "SUPER ALT"

-- ── Applications ────────────────────────────────────────────────────────────
Hyprland.bind(SUPER, "Return",    "exec", "kitty")
Hyprland.bind(SUPER, "E",         "exec", "nautilus")
Hyprland.bind(SUPER, "B",         "exec", "firefox")
Hyprland.bind(SUPER, "C",         "exec", "code")

-- Auralis Shell panels (via Quickshell IPC)
Hyprland.bind(SUPER, "Space",     "exec", "qs ipc call auralis toggleLauncher")
Hyprland.bind(SUPER, "N",         "exec", "qs ipc call auralis toggleNotifications")
Hyprland.bind(SUPER, "S",         "exec", "qs ipc call auralis toggleSettings")
Hyprland.bind(SUPER, "D",         "exec", "qs ipc call auralis toggleDashboard")
Hyprland.bind(SUPER, "Comma",     "exec", "qs ipc call auralis toggleQuickSettings")

-- ── Window management ───────────────────────────────────────────────────────
Hyprland.bind(SUPER, "Q",         "killactive")
Hyprland.bind(SUPER, "F",         "fullscreen", "0")
Hyprland.bind(SUPER_SHIFT, "F",   "fullscreen", "1")
Hyprland.bind(SUPER, "V",         "togglefloating")
Hyprland.bind(SUPER, "P",         "pseudo")
Hyprland.bind(SUPER, "J",         "togglesplit")
Hyprland.bind(SUPER, "G",         "togglegroup")
Hyprland.bind(SUPER_SHIFT, "G",   "moveoutofgroup")

-- ── Focus movement ──────────────────────────────────────────────────────────
Hyprland.bind(SUPER, "Left",      "movefocus", "l")
Hyprland.bind(SUPER, "Right",     "movefocus", "r")
Hyprland.bind(SUPER, "Up",        "movefocus", "u")
Hyprland.bind(SUPER, "Down",      "movefocus", "d")
Hyprland.bind(SUPER, "H",         "movefocus", "l")
Hyprland.bind(SUPER, "L",         "movefocus", "r")
Hyprland.bind(SUPER, "K",         "movefocus", "u")

-- ── Window movement ─────────────────────────────────────────────────────────
Hyprland.bind(SUPER_SHIFT, "Left",  "movewindow", "l")
Hyprland.bind(SUPER_SHIFT, "Right", "movewindow", "r")
Hyprland.bind(SUPER_SHIFT, "Up",    "movewindow", "u")
Hyprland.bind(SUPER_SHIFT, "Down",  "movewindow", "d")
Hyprland.bind(SUPER_SHIFT, "H",     "movewindow", "l")
Hyprland.bind(SUPER_SHIFT, "L",     "movewindow", "r")
Hyprland.bind(SUPER_SHIFT, "K",     "movewindow", "u")
Hyprland.bind(SUPER_SHIFT, "J",     "movewindow", "d")

-- ── Resize with mouse ───────────────────────────────────────────────────────
Hyprland.bindm(SUPER, "mouse:272",  "movewindow")
Hyprland.bindm(SUPER, "mouse:273",  "resizewindow")

-- ── Workspace switching ─────────────────────────────────────────────────────
for i = 1, 9 do
    Hyprland.bind(SUPER,       tostring(i), "workspace",           tostring(i))
    Hyprland.bind(SUPER_SHIFT, tostring(i), "movetoworkspace",     tostring(i))
    Hyprland.bind(SUPER_CTRL,  tostring(i), "movetoworkspacesilent", tostring(i))
end
Hyprland.bind(SUPER, "0",           "workspace",       "10")
Hyprland.bind(SUPER_SHIFT, "0",     "movetoworkspace", "10")

-- ── Workspace scroll ────────────────────────────────────────────────────────
Hyprland.bind(SUPER, "mouse_down",  "workspace", "e+1")
Hyprland.bind(SUPER, "mouse_up",    "workspace", "e-1")
Hyprland.bind(SUPER, "bracketright","workspace", "e+1")
Hyprland.bind(SUPER, "bracketleft", "workspace", "e-1")

-- ── Special workspaces ──────────────────────────────────────────────────────
Hyprland.bind(SUPER, "Minus",       "togglespecialworkspace", "scratchpad")
Hyprland.bind(SUPER_SHIFT, "Minus", "movetoworkspace",        "special:scratchpad")

-- ── Screenshots ─────────────────────────────────────────────────────────────
Hyprland.bind("",             "Print",     "exec", "grim -g \"$(slurp)\" - | wl-copy")
Hyprland.bind(SUPER,          "Print",     "exec", "grim - | wl-copy")
Hyprland.bind(SUPER_SHIFT,    "S",         "exec", "grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png")

-- ── Media / brightness ──────────────────────────────────────────────────────
Hyprland.bindel("", "XF86AudioRaiseVolume",  "exec", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
Hyprland.bindel("", "XF86AudioLowerVolume",  "exec", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
Hyprland.bind("",   "XF86AudioMute",         "exec", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
Hyprland.bind("",   "XF86AudioMicMute",      "exec", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")
Hyprland.bind("",   "XF86AudioPlay",         "exec", "playerctl play-pause")
Hyprland.bind("",   "XF86AudioNext",         "exec", "playerctl next")
Hyprland.bind("",   "XF86AudioPrev",         "exec", "playerctl previous")
Hyprland.bindel("", "XF86MonBrightnessUp",   "exec", "brightnessctl set 5%+")
Hyprland.bindel("", "XF86MonBrightnessDown", "exec", "brightnessctl set 5%-")

-- ── Session ──────────────────────────────────────────────────────────────────
Hyprland.bind(SUPER_SHIFT, "Q",   "exec", "qs ipc call auralis openPowerMenu")
Hyprland.bind(SUPER_SHIFT, "R",   "exec", "hyprctl reload")
Hyprland.bind(SUPER_CTRL,  "R",   "exec", "qs reload")
