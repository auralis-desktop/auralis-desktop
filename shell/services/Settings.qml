// Auralis: Settings service
// Reads/writes ~/.config/quickshell/auralis/config/settings.json
// Exposes live properties; other services bind to them

pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    // ── File path ─────────────────────────────────────────────────────────────
    readonly property string settingsPath:
        StandardPaths.writableLocation(StandardPaths.AppConfigLocation)
        + "/auralis/config/settings.json"

    // ── Appearance ────────────────────────────────────────────────────────────
    property string themeMode:       "dark"
    property bool   dynamicColor:    true
    property color  accentColor:     "#7965D9"
    property real   transparency:    0.85
    property bool   blurEnabled:     true
    property int    blurStrength:    8
    property real   shadowIntensity: 0.6
    property int    cornerRadius:    12
    property real   animationSpeed:  1.0
    property string density:         "comfortable"

    // ── Bar ───────────────────────────────────────────────────────────────────
    property bool   barEnabled:     true
    property string barPosition:    "top"
    property int    barHeight:      48
    property real   barTransparency: 0.85
    property bool   barAutohide:    false
    property string clockFormat:    "HH:mm"
    property bool   showDate:       true
    property string workspaceStyle: "dots"

    // ── Launcher ──────────────────────────────────────────────────────────────
    property string launcherStyle:    "grid"
    property int    launcherWidth:    560
    property int    launcherIconSize: 48
    property bool   showCategories:   true
    property bool   showRecent:       true

    // ── Notifications ─────────────────────────────────────────────────────────
    property bool   dnd:                false
    property int    notifDuration:      5000
    property string notifPosition:      "top-right"
    property int    notifMaxVisible:    5

    // ── Wallpaper ─────────────────────────────────────────────────────────────
    property string wallpaperPath:    "~/Pictures/Wallpapers"
    property string wallpaperCurrent: ""
    property bool   wallpaperAutoColor: true

    // ── Hyprland ──────────────────────────────────────────────────────────────
    property int    hyprGapsIn:   6
    property int    hyprGapsOut:  12
    property int    hyprBorderSize: 2
    property int    hyprRounding: 12
    property bool   hyprBlur:     true
    property bool   hyprShadows:  true

    // ── Persistence ──────────────────────────────────────────────────────────
    property var _data: ({})

    function load() {
        var file = Qt.resolvedUrl("file://" + settingsPath)
        // Use FileView for safe read
        _loader.path = settingsPath
        _loader.reload()
    }

    function save() {
        var obj = {
            version: "1.0.0",
            appearance: {
                themeMode, dynamicColor, accentColor: accentColor.toString(),
                transparency, blur: blurEnabled, blurStrength,
                shadowIntensity, cornerRadius, animationSpeed, density
            },
            bar: {
                enabled: barEnabled, position: barPosition, height: barHeight,
                transparency: barTransparency, autohide: barAutohide,
                clockFormat, showDate, workspaceStyle
            },
            launcher: {
                style: launcherStyle, width: launcherWidth,
                iconSize: launcherIconSize, showCategories, showRecent
            },
            notifications: {
                dnd, duration: notifDuration, position: notifPosition,
                maxVisible: notifMaxVisible
            },
            wallpaper: {
                path: wallpaperPath, current: wallpaperCurrent,
                autoColor: wallpaperAutoColor
            },
            hyprland: {
                gapsIn: hyprGapsIn, gapsOut: hyprGapsOut,
                borderSize: hyprBorderSize, rounding: hyprRounding,
                blur: hyprBlur, shadows: hyprShadows
            }
        }
        _writer.text = JSON.stringify(obj, null, 2)
        _writer.write()
    }

    // Apply a Hyprland setting live via hyprctl
    function applyHyprlandSetting(key, value) {
        hyprctlProcess.command = ["hyprctl", "keyword", key, String(value)]
        hyprctlProcess.startDetached()
    }

    FileView {
        id: _loader
        path: root.settingsPath
        onTextChanged: {
            try {
                var obj = JSON.parse(text)
                if (obj.appearance) {
                    root.themeMode       = obj.appearance.themeMode      ?? root.themeMode
                    root.dynamicColor    = obj.appearance.dynamicColor   ?? root.dynamicColor
                    root.transparency    = obj.appearance.transparency   ?? root.transparency
                    root.blurEnabled     = obj.appearance.blur           ?? root.blurEnabled
                    root.blurStrength    = obj.appearance.blurStrength   ?? root.blurStrength
                    root.shadowIntensity = obj.appearance.shadowIntensity ?? root.shadowIntensity
                    root.cornerRadius    = obj.appearance.cornerRadius   ?? root.cornerRadius
                    root.animationSpeed  = obj.appearance.animationSpeed ?? root.animationSpeed
                    root.density         = obj.appearance.density        ?? root.density
                }
                if (obj.bar) {
                    root.barEnabled     = obj.bar.enabled      ?? root.barEnabled
                    root.barPosition    = obj.bar.position     ?? root.barPosition
                    root.barHeight      = obj.bar.height       ?? root.barHeight
                    root.barTransparency = obj.bar.transparency ?? root.barTransparency
                    root.barAutohide    = obj.bar.autohide     ?? root.barAutohide
                    root.clockFormat    = obj.bar.clockFormat  ?? root.clockFormat
                    root.showDate       = obj.bar.showDate     ?? root.showDate
                    root.workspaceStyle = obj.bar.workspaceStyle ?? root.workspaceStyle
                }
                if (obj.notifications) {
                    root.dnd             = obj.notifications.dnd      ?? root.dnd
                    root.notifDuration   = obj.notifications.duration ?? root.notifDuration
                    root.notifPosition   = obj.notifications.position ?? root.notifPosition
                    root.notifMaxVisible = obj.notifications.maxVisible ?? root.notifMaxVisible
                }
                if (obj.wallpaper) {
                    root.wallpaperPath     = obj.wallpaper.path      ?? root.wallpaperPath
                    root.wallpaperCurrent  = obj.wallpaper.current   ?? root.wallpaperCurrent
                    root.wallpaperAutoColor = obj.wallpaper.autoColor ?? root.wallpaperAutoColor
                }
                if (obj.hyprland) {
                    root.hyprGapsIn    = obj.hyprland.gapsIn    ?? root.hyprGapsIn
                    root.hyprGapsOut   = obj.hyprland.gapsOut   ?? root.hyprGapsOut
                    root.hyprBorderSize = obj.hyprland.borderSize ?? root.hyprBorderSize
                    root.hyprRounding  = obj.hyprland.rounding  ?? root.hyprRounding
                    root.hyprBlur      = obj.hyprland.blur      ?? root.hyprBlur
                    root.hyprShadows   = obj.hyprland.shadows   ?? root.hyprShadows
                }
            } catch(e) {
                console.warn("Auralis Settings: failed to parse settings.json:", e)
            }
        }
    }

    FileView {
        id: _writer
        path: root.settingsPath
    }

    Process {
        id: hyprctlProcess
        running: false
    }

    Component.onCompleted: load()
}
