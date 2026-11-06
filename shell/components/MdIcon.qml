// Auralis: Material Symbols icon
// Uses the Material Symbols font (variable font, outlined style)
// name: icon name e.g. "volume_up", "wifi", "close"

import QtQuick
import "../themes" as Themes

Text {
    id: root

    property string name:   "star"
    property int    size:   20
    property color  color:  Themes.AuralisTheme.onSurface
    property bool   filled: false

    text:     String.fromCodePoint(_codepoint(name))
    font.family: "Material Symbols Outlined"
    font.pixelSize: size
    font.variationSettings: filled ? "'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' " + size
                                   : "'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' " + size
    color:    root.color
    renderType: Text.NativeRendering

    // Minimal codepoint table -- extend as needed
    // Full set: https://fonts.google.com/icons
    function _codepoint(n) {
        var map = {
            "close":              0xe5cd, "settings":           0xe8b8,
            "search":             0xe8b6, "home":               0xe88a,
            "launch":             0xe895, "apps":               0xe5c3,
            "menu":               0xe5d2, "arrow_back":         0xe5c4,
            "arrow_forward":      0xe5c8, "chevron_left":       0xe5cb,
            "chevron_right":      0xe5cc, "expand_more":        0xe5cf,
            "expand_less":        0xe5ce, "more_vert":          0xe5d4,
            "check":              0xe5ca, "add":                0xe145,
            "remove":             0xe15b, "delete":             0xe872,
            "edit":               0xe3c9, "favorite":           0xe87d,
            "star":               0xe838, "info":               0xe88e,
            "warning":            0xe002, "error":              0xe000,
            "done":               0xe876, "refresh":            0xe5d5,
            "volume_off":         0xe04f, "volume_mute":        0xe04e,
            "volume_down":        0xe04d, "volume_up":          0xe050,
            "mic":                0xe029, "mic_off":            0xe02b,
            "wifi":               0xe63e, "wifi_off":           0xe648,
            "wifi_1_bar":         0xe0bb, "wifi_2_bar":         0xe0bc,
            "wifi_find":          0xebaa, "signal_wifi_off":    0xe648,
            "bluetooth":          0xe1a7, "bluetooth_connected":0xe1a8,
            "bluetooth_disabled": 0xe1a9, "battery_full":       0xe1a4,
            "battery_6_bar":      0xebdc, "battery_4_bar":      0xebda,
            "battery_3_bar":      0xebd9, "battery_2_bar":      0xebd8,
            "battery_1_bar":      0xebd7, "battery_alert":      0xe19c,
            "battery_charging_full": 0xe1a3, "battery_unknown": 0xe1a6,
            "brightness_5":       0xe3d4, "brightness_7":       0xe3d6,
            "nightlight":         0xf03e, "do_not_disturb_on":  0xe612,
            "notifications":      0xe7f4, "notifications_off":  0xe7f6,
            "notifications_active":0xe7f7, "circle":            0xef4a,
            "play_arrow":         0xe037, "pause":              0xe034,
            "stop":               0xe047, "skip_next":          0xe044,
            "skip_previous":      0xe045, "shuffle":            0xe043,
            "repeat":             0xe040, "music_note":         0xe405,
            "album":              0xe019, "queue_music":        0xe03d,
            "power_settings_new": 0xe8ac, "lock":               0xe897,
            "logout":             0xe9ba, "restart_alt":        0xf053,
            "brightness_low":     0xe1ac, "wb_sunny":           0xe430,
            "dark_mode":          0xe51c, "light_mode":         0xe518,
            "palette":            0xe40a, "format_paint":       0xe243,
            "tune":               0xe429, "display_settings":   0xeb97,
            "keyboard":           0xe312, "mouse":              0xe323,
            "monitor":            0xef5b, "wallpaper":          0xe1bc,
            "image":              0xe3f4, "photo":              0xe410,
            "folder":             0xe2c7, "folder_open":        0xe2c8,
            "open_in_new":        0xe89e, "link":               0xe157,
            "code":               0xe86f, "terminal":           0xeb8e,
            "help":               0xe887, "help_outline":       0xe8fd,
            "open_in_browser":    0xe89d, "language":           0xe894,
            "person":             0xe7fd, "group":              0xe7ef,
            "schedule":           0xe8b5, "today":              0xe8df,
            "event":              0xe878, "timer":              0xe425,
            "speed":              0xe9e4, "memory":             0xe322,
            "storage":            0xe1db, "computer":           0xe30a,
        }
        return map[n] || 0xe8b8  // fallback: settings icon
    }
}
