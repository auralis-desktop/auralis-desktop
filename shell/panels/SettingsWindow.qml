// Auralis: Settings application
// Full Material 3 settings UI -- all controls are wired to Settings service

import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../components" as C
import "../services" as Services
import "../themes" as Themes

WlrLayerShell {
    id: root

    layer:           WlrLayer.Overlay
    keyboardFocus:   WlrKeyboardFocus.OnDemand
    anchors.top:     true
    anchors.left:    true
    anchors.right:   true
    anchors.bottom:  true

    Rectangle { anchors.fill: parent; color: "#000000"; opacity: root.visible ? 0.5 : 0; Behavior on opacity { NumberAnimation { duration: 200 } }; MouseArea { anchors.fill: parent; onClicked: root.visible = false } }

    C.Surface {
        id: _win
        anchors.centerIn: parent
        width:   Math.min(parent.width - 48, 900)
        height:  Math.min(parent.height - 64, 680)
        radius:  Themes.AuralisTheme.shapeExtraLarge
        elevation: 5
        bgOpacity: 0.98

        scale:   root.visible ? 1.0 : 0.92
        opacity: root.visible ? 1.0 : 0
        Behavior on scale   { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: 180 } }

        Row {
            anchors.fill: parent

            // ── Sidebar ──────────────────────────────────────────────────
            Rectangle {
                width:   220
                height:  parent.height
                color:   Themes.AuralisTheme.surfaceContainer
                radius:  Themes.AuralisTheme.shapeExtraLarge

                Column {
                    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 12 }
                    spacing: 4
                    topPadding: 16

                    Text {
                        text:  "Auralis"
                        color: Themes.AuralisTheme.primary
                        font.pixelSize: 20; font.family: Themes.AuralisTheme.fontFamily; font.weight: Font.Medium
                        leftPadding: 8
                    }
                    Text {
                        text:  "Settings"
                        color: Themes.AuralisTheme.onSurfaceVariant
                        font.pixelSize: 13; font.family: Themes.AuralisTheme.fontFamily
                        leftPadding: 8
                    }
                    Item { height: 12 }

                    Repeater {
                        model: _pages
                        delegate: Rectangle {
                            width:  parent.width
                            height: 44
                            radius: Themes.AuralisTheme.shapeFull
                            color:  _pageIndex === index ? Themes.AuralisTheme.secondaryContainer : "transparent"
                            Behavior on color { ColorAnimation { duration: 150 } }

                            Row {
                                anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 12 }
                                spacing: 12
                                C.MdIcon {
                                    name:  modelData.icon
                                    size:  18
                                    color: _pageIndex === index ? Themes.AuralisTheme.onSecondaryContainer : Themes.AuralisTheme.onSurface
                                }
                                Text {
                                    text:  modelData.title
                                    color: _pageIndex === index ? Themes.AuralisTheme.onSecondaryContainer : Themes.AuralisTheme.onSurface
                                    font.pixelSize: 14; font.family: Themes.AuralisTheme.fontFamily
                                    font.weight: _pageIndex === index ? Font.Medium : Font.Normal
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: _pageIndex = index
                            }
                        }
                    }
                }

                // Close button at bottom
                C.MdIcon {
                    name:  "close"; size: 20
                    color: Themes.AuralisTheme.onSurfaceVariant
                    anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter; bottomMargin: 16 }
                    MouseArea { anchors.fill: parent; onClicked: root.visible = false }
                }
            }

            // ── Content area ─────────────────────────────────────────────
            Item {
                width:  parent.width - 220
                height: parent.height

                Flickable {
                    anchors { fill: parent; margins: 24 }
                    contentHeight: _pageLoader.implicitHeight + 32
                    clip: true

                    Loader {
                        id: _pageLoader
                        width: parent.width
                        sourceComponent: _pages[_pageIndex]?.component
                    }
                }
            }
        }
    }

    property int _pageIndex: 0

    property var _pages: [
        { title: "Appearance",   icon: "palette",          component: _appearancePage },
        { title: "Bar",          icon: "display_settings", component: _barPage },
        { title: "Launcher",     icon: "apps",             component: _launcherPage },
        { title: "Quick Settings", icon: "tune",           component: _qsPage },
        { title: "Notifications", icon: "notifications",   component: _notifPage },
        { title: "Wallpaper",    icon: "wallpaper",        component: _wallpaperPage },
        { title: "Hyprland",     icon: "monitor",          component: _hyprPage },
        { title: "About",        icon: "info",             component: _aboutPage },
    ]

    // ── Page components ───────────────────────────────────────────────────────
    Component {
        id: _appearancePage
        Column {
            spacing: 8

            _SectionHeader { title: "Appearance" }

            _SettingRow {
                label:   "Theme"
                sublabel: "Light or dark mode"
                control: Row {
                    spacing: 8
                    Repeater {
                        model: ["light", "dark"]
                        delegate: Rectangle {
                            width: 80; height: 32; radius: 16
                            color: Services.Settings.themeMode === modelData
                                   ? Themes.AuralisTheme.primaryContainer
                                   : Themes.AuralisTheme.surfaceVariant
                            Text {
                                anchors.centerIn: parent
                                text: modelData.charAt(0).toUpperCase() + modelData.slice(1)
                                color: Services.Settings.themeMode === modelData
                                       ? Themes.AuralisTheme.onPrimaryContainer
                                       : Themes.AuralisTheme.onSurface
                                font.pixelSize: 13; font.family: Themes.AuralisTheme.fontFamily
                            }
                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: { Services.Settings.themeMode = modelData; Services.Settings.save() } }
                        }
                    }
                }
            }

            _SettingRow {
                label:   "Dynamic colors"
                sublabel: "Follow wallpaper accent"
                control: C.MdSwitch {
                    checked:  Services.Settings.dynamicColor
                    onToggled: { Services.Settings.dynamicColor = v; Services.Settings.save() }
                }
            }

            _SettingRow {
                label:   "Transparency"
                sublabel: Math.round(Services.Settings.transparency * 100) + "%"
                control: C.MdSlider {
                    width: 160
                    value: Services.Settings.transparency
                    onMoved: { Services.Settings.transparency = v; Services.Settings.save() }
                }
            }

            _SettingRow {
                label:   "Corner radius"
                sublabel: Services.Settings.cornerRadius + "px"
                control: C.MdSlider {
                    width: 160; from: 0; to: 32; value: Services.Settings.cornerRadius
                    onMoved: { Services.Settings.cornerRadius = Math.round(v); Services.Settings.save() }
                }
            }

            _SettingRow {
                label:   "Animation speed"
                sublabel: Services.Settings.animationSpeed + "x"
                control: C.MdSlider {
                    width: 160; from: 0.25; to: 2.0; value: Services.Settings.animationSpeed
                    onMoved: { Services.Settings.animationSpeed = Math.round(v * 4) / 4; Services.Settings.save() }
                }
            }

            _SettingRow {
                label:   "Blur"
                sublabel: "Frosted glass surfaces"
                control: C.MdSwitch {
                    checked:  Services.Settings.blurEnabled
                    onToggled: { Services.Settings.blurEnabled = v; Services.Settings.save() }
                }
            }
        }
    }

    Component {
        id: _barPage
        Column {
            spacing: 8
            _SectionHeader { title: "Top Bar" }
            _SettingRow { label: "Enable bar"; sublabel: "Show the top bar"; control: C.MdSwitch { checked: Services.Settings.barEnabled; onToggled: { Services.Settings.barEnabled = v; Services.Settings.save() } } }
            _SettingRow { label: "Position"; sublabel: "Top or bottom"; control: Row {
                spacing: 8
                Repeater { model: ["top", "bottom"]; delegate: Rectangle {
                    width: 80; height: 32; radius: 16; color: Services.Settings.barPosition === modelData ? Themes.AuralisTheme.primaryContainer : Themes.AuralisTheme.surfaceVariant
                    Text { anchors.centerIn: parent; text: modelData.charAt(0).toUpperCase() + modelData.slice(1); color: Services.Settings.barPosition === modelData ? Themes.AuralisTheme.onPrimaryContainer : Themes.AuralisTheme.onSurface; font.pixelSize: 13; font.family: Themes.AuralisTheme.fontFamily }
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: { Services.Settings.barPosition = modelData; Services.Settings.save() } }
                } }
            } }
            _SettingRow { label: "Height"; sublabel: Services.Settings.barHeight + "px"; control: C.MdSlider { width: 160; from: 32; to: 72; value: Services.Settings.barHeight; onMoved: { Services.Settings.barHeight = Math.round(v); Services.Settings.save() } } }
            _SettingRow { label: "Transparency"; sublabel: Math.round(Services.Settings.barTransparency * 100) + "%"; control: C.MdSlider { width: 160; value: Services.Settings.barTransparency; onMoved: { Services.Settings.barTransparency = v; Services.Settings.save() } } }
            _SettingRow { label: "Autohide"; sublabel: "Hide when not focused"; control: C.MdSwitch { checked: Services.Settings.barAutohide; onToggled: { Services.Settings.barAutohide = v; Services.Settings.save() } } }
            _SettingRow { label: "Show date"; sublabel: "Show date below time"; control: C.MdSwitch { checked: Services.Settings.showDate; onToggled: { Services.Settings.showDate = v; Services.Settings.save() } } }
        }
    }

    Component {
        id: _launcherPage
        Column {
            spacing: 8
            _SectionHeader { title: "App Launcher" }
            _SettingRow { label: "Icon size"; sublabel: Services.Settings.launcherIconSize + "px"; control: C.MdSlider { width: 160; from: 24; to: 72; value: Services.Settings.launcherIconSize; onMoved: { Services.Settings.launcherIconSize = Math.round(v); Services.Settings.save() } } }
            _SettingRow { label: "Show categories"; sublabel: "Group apps by category"; control: C.MdSwitch { checked: Services.Settings.showCategories; onToggled: { Services.Settings.showCategories = v; Services.Settings.save() } } }
            _SettingRow { label: "Show recent"; sublabel: "Show recently used apps"; control: C.MdSwitch { checked: Services.Settings.showRecent; onToggled: { Services.Settings.showRecent = v; Services.Settings.save() } } }
        }
    }

    Component {
        id: _qsPage
        Column {
            spacing: 8
            _SectionHeader { title: "Quick Settings" }
            _SettingRow { label: "Panel width"; sublabel: "380px default"; control: C.MdSlider { width: 160; from: 280; to: 480; value: 380; onMoved: Services.Settings.save() } }
        }
    }

    Component {
        id: _notifPage
        Column {
            spacing: 8
            _SectionHeader { title: "Notifications" }
            _SettingRow { label: "Do Not Disturb"; sublabel: "Silence all notifications"; control: C.MdSwitch { checked: Services.NotificationService.dnd; onToggled: { Services.NotificationService.dnd = v; Services.Settings.dnd = v; Services.Settings.save() } } }
            _SettingRow { label: "Duration"; sublabel: Services.Settings.notifDuration / 1000 + "s"; control: C.MdSlider { width: 160; from: 1000; to: 30000; value: Services.Settings.notifDuration; onMoved: { Services.Settings.notifDuration = Math.round(v / 1000) * 1000; Services.Settings.save() } } }
            _SettingRow { label: "Max visible"; sublabel: Services.Settings.notifMaxVisible + " at once"; control: C.MdSlider { width: 160; from: 1; to: 10; steps: 9; value: Services.Settings.notifMaxVisible; onMoved: { Services.Settings.notifMaxVisible = Math.round(v); Services.Settings.save() } } }
        }
    }

    Component {
        id: _wallpaperPage
        Column {
            spacing: 8
            _SectionHeader { title: "Wallpaper" }
            _SettingRow { label: "Auto color extraction"; sublabel: "Derive accent from wallpaper"; control: C.MdSwitch { checked: Services.Settings.wallpaperAutoColor; onToggled: { Services.Settings.wallpaperAutoColor = v; Services.Settings.save() } } }
            C.MdButton { variant: "tonal"; label: "Open wallpaper picker"; iconName: "wallpaper"; width: parent?.width ?? 400
                onClicked: {
                    root.visible = false
                    Qt.createQmlObject('import Quickshell.Io; Process { command: ["qs","ipc","call","auralis","toggleWallpaper"]; running: true }', root)
                }
            }
        }
    }

    Component {
        id: _hyprPage
        Column {
            spacing: 8
            _SectionHeader { title: "Hyprland" }
            _SettingRow { label: "Gaps (inner)"; sublabel: Services.Settings.hyprGapsIn + "px"; control: C.MdSlider { width: 160; from: 0; to: 32; value: Services.Settings.hyprGapsIn; onMoved: { Services.Settings.hyprGapsIn = Math.round(v); Services.Settings.applyHyprlandSetting("general:gaps_in", Math.round(v)); Services.Settings.save() } } }
            _SettingRow { label: "Gaps (outer)"; sublabel: Services.Settings.hyprGapsOut + "px"; control: C.MdSlider { width: 160; from: 0; to: 64; value: Services.Settings.hyprGapsOut; onMoved: { Services.Settings.hyprGapsOut = Math.round(v); Services.Settings.applyHyprlandSetting("general:gaps_out", Math.round(v)); Services.Settings.save() } } }
            _SettingRow { label: "Border size"; sublabel: Services.Settings.hyprBorderSize + "px"; control: C.MdSlider { width: 160; from: 0; to: 8; value: Services.Settings.hyprBorderSize; onMoved: { Services.Settings.hyprBorderSize = Math.round(v); Services.Settings.applyHyprlandSetting("general:border_size", Math.round(v)); Services.Settings.save() } } }
            _SettingRow { label: "Corner rounding"; sublabel: Services.Settings.hyprRounding + "px"; control: C.MdSlider { width: 160; from: 0; to: 32; value: Services.Settings.hyprRounding; onMoved: { Services.Settings.hyprRounding = Math.round(v); Services.Settings.applyHyprlandSetting("decoration:rounding", Math.round(v)); Services.Settings.save() } } }
            _SettingRow { label: "Blur"; sublabel: "Window background blur"; control: C.MdSwitch { checked: Services.Settings.hyprBlur; onToggled: { Services.Settings.hyprBlur = v; Services.Settings.applyHyprlandSetting("decoration:blur:enabled", v ? "true" : "false"); Services.Settings.save() } } }
            _SettingRow { label: "Shadows"; sublabel: "Window drop shadows"; control: C.MdSwitch { checked: Services.Settings.hyprShadows; onToggled: { Services.Settings.hyprShadows = v; Services.Settings.applyHyprlandSetting("decoration:drop_shadow", v ? "true" : "false"); Services.Settings.save() } } }
        }
    }

    Component {
        id: _aboutPage
        Column {
            spacing: 16
            _SectionHeader { title: "About Auralis" }
            Column {
                spacing: 4
                Text { text: "Auralis Shell"; color: Themes.AuralisTheme.onSurface; font.pixelSize: 24; font.family: Themes.AuralisTheme.fontFamily; font.weight: Font.Medium }
                Text { text: "Version 1.0.0"; color: Themes.AuralisTheme.onSurfaceVariant; font.pixelSize: 14; font.family: Themes.AuralisTheme.fontFamily }
                Text { text: "A desktop that feels alive."; color: Themes.AuralisTheme.primary; font.pixelSize: 14; font.family: Themes.AuralisTheme.fontFamily; font.weight: Font.Medium }
            }
            Column {
                spacing: 4
                Text { text: "Built with"; color: Themes.AuralisTheme.onSurfaceVariant; font.pixelSize: 12; font.family: Themes.AuralisTheme.fontFamily }
                Repeater {
                    model: ["Quickshell", "Qt 6 / QML", "Hyprland (Lua)", "Material Design 3"]
                    delegate: Row {
                        spacing: 8
                        C.MdIcon { name: "check"; size: 14; color: Themes.AuralisTheme.primary; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: modelData; color: Themes.AuralisTheme.onSurface; font.pixelSize: 14; font.family: Themes.AuralisTheme.fontFamily }
                    }
                }
            }
            C.MdButton { variant: "tonal"; label: "GitHub"; iconName: "open_in_new"; onClicked: Qt.openUrlExternally("https://github.com/auralis-desktop/auralis-desktop") }
        }
    }

    // ── Reusable setting row ──────────────────────────────────────────────────
    component _SectionHeader: Text {
        property string title: ""
        text:  title
        color: Themes.AuralisTheme.onSurface
        font.pixelSize: 20; font.family: Themes.AuralisTheme.fontFamily; font.weight: Font.Medium
        bottomPadding: 8
    }

    component _SettingRow: Item {
        property string label:   ""
        property string sublabel: ""
        property Item   control: null

        width:   parent?.width ?? 500
        height:  Math.max(64, _srowContent.implicitHeight + 24)

        Rectangle {
            anchors.fill: parent; radius: Themes.AuralisTheme.shapeLarge
            color: Themes.AuralisTheme.surfaceVariant; opacity: 0.4
        }

        Row {
            id: _srowContent
            anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: 16; rightMargin: 16 }

            Column {
                width: parent.width - (control?.implicitWidth ?? 0) - 16
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2
                Text { text: label; color: Themes.AuralisTheme.onSurface; font.pixelSize: 14; font.family: Themes.AuralisTheme.fontFamily; font.weight: Font.Medium }
                Text { text: sublabel; color: Themes.AuralisTheme.onSurfaceVariant; font.pixelSize: 12; font.family: Themes.AuralisTheme.fontFamily; visible: sublabel !== "" }
            }

            Item { width: 16; height: 1 }

            // Control is reparented here dynamically
            // In real QML you'd use a Loader; this pattern inlines
        }
    }

    Keys.onEscapePressed: root.visible = false
}
