// Auralis: Quick Settings panel
// Slides in from top-right

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
    anchors.right:   true
    anchors.bottom:  true

    implicitWidth: Services.Settings.quickSettings.width ?? 380

    // Backdrop
    Rectangle {
        anchors.fill: parent
        color:        "transparent"
        MouseArea { anchors.fill: parent; onClicked: root.visible = false }
    }

    // Panel
    C.Surface {
        id: _panel
        width:   parent.width
        anchors.top:    parent.top
        anchors.topMargin: Services.Settings.barHeight + 8
        anchors.right:  parent.right
        anchors.rightMargin: 8
        height:  Math.min(_col.implicitHeight + 32, parent.height - Services.Settings.barHeight - 24)
        radius:  Themes.AuralisTheme.shapeExtraLarge
        elevation: 4
        bgOpacity: 0.96
        clip:    true

        x:       root.visible ? 0 : width + 16
        Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }

        // Scroll if content taller than panel
        Flickable {
            anchors.fill: parent
            contentHeight: _col.implicitHeight + 32
            clip: true

            Column {
                id: _col
                anchors { left: parent.left; right: parent.right; top: parent.top; margins: 16 }
                spacing: 12
                topPadding: 8

                // ── Toggle tiles row 1: WiFi + Bluetooth ──────────────────
                Row {
                    width: parent.width
                    spacing: 8

                    _QsTile {
                        width:  (parent.width - 8) / 2
                        iconName: Services.NetworkService.signalIcon()
                        label:    Services.NetworkService.ssid || "Wi-Fi"
                        sublabel: Services.NetworkService.connected ? "Connected" : "Off"
                        active:   Services.NetworkService.wifiEnabled
                        onToggled: Services.NetworkService.toggleWifi()
                    }

                    _QsTile {
                        width:  (parent.width - 8) / 2
                        iconName: Services.BluetoothService.icon()
                        label:    "Bluetooth"
                        sublabel: Services.BluetoothService.deviceName || (Services.BluetoothService.enabled ? "On" : "Off")
                        active:   Services.BluetoothService.enabled
                        onToggled: Services.BluetoothService.toggle()
                    }
                }

                // ── Toggle tiles row 2: DND + Night Light ─────────────────
                Row {
                    width: parent.width
                    spacing: 8

                    _QsTile {
                        width:  (parent.width - 8) / 2
                        iconName: Services.NotificationService.dnd ? "do_not_disturb_on" : "notifications"
                        label:    "Do Not Disturb"
                        sublabel: Services.NotificationService.dnd ? "On" : "Off"
                        active:   Services.NotificationService.dnd
                        onToggled: Services.NotificationService.toggleDnd()
                    }

                    _QsTile {
                        width:  (parent.width - 8) / 2
                        iconName: "nightlight"
                        label:    "Night Light"
                        sublabel: _nlActive ? "On" : "Off"
                        active:   _nlActive
                        property bool _nlActive: false
                        onToggled: {
                            _nlActive = !_nlActive
                            Qt.createQmlObject(
                                'import Quickshell.Io; Process { command: ["bash","-c","hyprctl keyword decoration:screen_shader ' +
                                (_nlActive ? "~/.config/hypr/shaders/nightlight.glsl" : "''") + '"]; running: true }',
                                root)
                        }
                    }
                }

                // ── Volume ────────────────────────────────────────────────
                _SliderRow {
                    iconName: Services.AudioService.volumeIcon()
                    value:    Services.AudioService.volume
                    onMoved:  Services.AudioService.setVolume(value)
                    onIconClicked: Services.AudioService.toggleMute()
                    label: Math.round(Services.AudioService.volume * 100) + "%"
                }

                // ── Microphone ────────────────────────────────────────────
                _SliderRow {
                    iconName: Services.AudioService.micMuted ? "mic_off" : "mic"
                    value:    Services.AudioService.micVolume
                    onMoved:  Services.AudioService.setMicVolume(value)
                    onIconClicked: Services.AudioService.toggleMicMute()
                    label: Math.round(Services.AudioService.micVolume * 100) + "%"
                }

                // ── Brightness ────────────────────────────────────────────
                _SliderRow {
                    id: _brightRow
                    iconName: "brightness_5"
                    value:    _brightness
                    onMoved:  _setBrightness(value)
                    label:    Math.round(_brightness * 100) + "%"

                    property real _brightness: 0.5

                    Component.onCompleted: _readBrightness()

                    function _readBrightness() {
                        Qt.createQmlObject(
                            'import Quickshell.Io; Process { ' +
                            'command: ["bash","-c","brightnessctl g 2>/dev/null | tr -d \'\\n\'"]; ' +
                            'stdout: StdioCollector { onStreamFinished: { ' +
                            'var max=255; parent.parent._brightness=parseInt(content.trim())/max } } ' +
                            'running: true }', root)
                    }

                    function _setBrightness(v) {
                        _brightness = v
                        Qt.createQmlObject(
                            'import Quickshell.Io; Process { command: ["brightnessctl","s",' +
                            '"' + Math.round(v * 100) + '%"]; running: true }', root)
                    }
                }

                // ── Battery info ──────────────────────────────────────────
                Row {
                    width:   parent.width
                    spacing: 12
                    visible: Services.BatteryService.present

                    C.MdIcon {
                        name:  Services.BatteryService.icon()
                        size:  20
                        color: Services.BatteryService.color() || Themes.AuralisTheme.onSurface
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2
                        Text {
                            text:  "Battery"
                            color: Themes.AuralisTheme.onSurface
                            font.pixelSize: 14; font.family: Themes.AuralisTheme.fontFamily; font.weight: Font.Medium
                        }
                        Text {
                            text:  Services.BatteryService.percentage + "% — " + Services.BatteryService.status
                            color: Themes.AuralisTheme.onSurfaceVariant
                            font.pixelSize: 12; font.family: Themes.AuralisTheme.fontFamily
                        }
                    }
                }

                // ── Media player ──────────────────────────────────────────
                _MediaWidget { visible: Services.MprisService.title !== "" }

                // ── Settings shortcut ─────────────────────────────────────
                C.MdButton {
                    variant:  "tonal"
                    label:    "All Settings"
                    iconName: "settings"
                    width:    parent.width
                    onClicked: {
                        root.visible = false
                        Qt.createQmlObject(
                            'import Quickshell.Io; Process { command: ["qs","ipc","call","auralis","toggleSettings"]; running: true }',
                            root)
                    }
                }
            }
        }
    }

    // ── Sub-components ───────────────────────────────────────────────────────
    component _QsTile: Rectangle {
        property string iconName: ""
        property string label:    ""
        property string sublabel: ""
        property bool   active:   false
        signal toggled()

        height: 72
        radius: Themes.AuralisTheme.shapeLarge
        color:  active ? Themes.AuralisTheme.primaryContainer
                       : Themes.AuralisTheme.surfaceVariant

        Behavior on color { ColorAnimation { duration: 200 } }

        Column {
            anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 16 }
            spacing: 2
            C.MdIcon {
                name:  iconName
                size:  20
                color: active ? Themes.AuralisTheme.onPrimaryContainer : Themes.AuralisTheme.onSurfaceVariant
            }
            Text {
                text:  label
                color: active ? Themes.AuralisTheme.onPrimaryContainer : Themes.AuralisTheme.onSurface
                font.pixelSize: 13; font.family: Themes.AuralisTheme.fontFamily; font.weight: Font.Medium
            }
            Text {
                text:  sublabel
                color: active ? Themes.AuralisTheme.onPrimaryContainer : Themes.AuralisTheme.onSurfaceVariant
                font.pixelSize: 11; font.family: Themes.AuralisTheme.fontFamily
            }
        }

        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: parent.toggled() }
    }

    component _SliderRow: Row {
        property string iconName: ""
        property real   value:    0.5
        property string label:    ""
        signal moved(real value)
        signal iconClicked()

        width:   parent?.width ?? 300
        spacing: 12
        anchors.left: parent?.left
        anchors.right: parent?.right

        C.MdIcon {
            name:  iconName
            size:  20
            color: Themes.AuralisTheme.onSurface
            anchors.verticalCenter: parent.verticalCenter
            MouseArea { anchors.fill: parent; onClicked: parent.parent.iconClicked() }
        }

        C.MdSlider {
            value:  parent.value
            Layout.fillWidth: true
            width:  parent.width - 96
            anchors.verticalCenter: parent.verticalCenter
            onMoved: parent.moved(v)
        }

        Text {
            text:  label
            color: Themes.AuralisTheme.onSurfaceVariant
            font.pixelSize: 12; font.family: Themes.AuralisTheme.fontFamily
            width: 36
            horizontalAlignment: Text.AlignRight
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    component _MediaWidget: Rectangle {
        width:   parent?.width ?? 300
        height:  72
        radius:  Themes.AuralisTheme.shapeLarge
        color:   Themes.AuralisTheme.surfaceContainerHigh
        clip:    true

        Row {
            anchors { fill: parent; margins: 12 }
            spacing: 12

            // Album art
            Rectangle {
                width:  48; height: 48
                radius: 8
                color:  Themes.AuralisTheme.surfaceVariant
                anchors.verticalCenter: parent.verticalCenter
                Image {
                    anchors.fill: parent
                    source:  Services.MprisService.artUrl ? "file://" + Services.MprisService.artUrl : ""
                    fillMode: Image.PreserveAspectCrop
                    layer.enabled: true
                }
            }

            Column {
                width:   parent.width - 48 - 80 - 24
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2
                Text {
                    text:  Services.MprisService.title || "Unknown"
                    color: Themes.AuralisTheme.onSurface
                    font.pixelSize: 13; font.family: Themes.AuralisTheme.fontFamily; font.weight: Font.Medium
                    elide: Text.ElideRight; width: parent.width
                }
                Text {
                    text:  Services.MprisService.artist || ""
                    color: Themes.AuralisTheme.onSurfaceVariant
                    font.pixelSize: 11; font.family: Themes.AuralisTheme.fontFamily
                    elide: Text.ElideRight; width: parent.width
                }
            }

            Row {
                spacing: 4
                anchors.verticalCenter: parent.verticalCenter

                Repeater {
                    model: [
                        { icon: "skip_previous", action: () => Services.MprisService.previous() },
                        { icon: Services.MprisService.playing ? "pause" : "play_arrow",
                          action: () => Services.MprisService.playPause() },
                        { icon: "skip_next",     action: () => Services.MprisService.next() }
                    ]
                    delegate: Item {
                        width: 32; height: 32
                        Rectangle {
                            anchors.fill: parent; radius: 16
                            color: Themes.AuralisTheme.primary
                            opacity: _mma.containsMouse ? 0.15 : 0
                        }
                        C.MdIcon { name: modelData.icon; size: 18; anchors.centerIn: parent; color: Themes.AuralisTheme.onSurface }
                        MouseArea { id: _mma; anchors.fill: parent; hoverEnabled: true; onClicked: modelData.action() }
                    }
                }
            }
        }
    }
}
