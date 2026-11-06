// Auralis: Dashboard -- time, media, system, calendar

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

    Rectangle {
        anchors.fill: parent; color: "#000000"
        opacity: root.visible ? 0.5 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }
        MouseArea { anchors.fill: parent; onClicked: root.visible = false }
    }

    // Dashboard card -- left side
    C.Surface {
        id: _dash
        width:   420
        anchors.left:       parent.left
        anchors.leftMargin: 16
        anchors.top:        parent.top
        anchors.topMargin:  Services.Settings.barHeight + 8
        anchors.bottom:     parent.bottom
        anchors.bottomMargin: 16
        radius:    Themes.AuralisTheme.shapeExtraLarge
        elevation: 4
        bgOpacity: 0.96
        clip:      true

        x:       root.visible ? 0 : -width - 32
        Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

        Flickable {
            anchors.fill: parent
            contentHeight: _dcol.implicitHeight + 32
            clip: true

            Column {
                id: _dcol
                anchors { left: parent.left; right: parent.right; top: parent.top; margins: 20 }
                spacing: 16
                topPadding: 8

                // ── Clock ─────────────────────────────────────────────────
                Column {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 4

                    Text {
                        id: _bigClock
                        anchors.horizontalCenter: parent.horizontalCenter
                        text:  Qt.formatTime(new Date(), "HH:mm")
                        color: Themes.AuralisTheme.onSurface
                        font.pixelSize: 64; font.family: Themes.AuralisTheme.fontFamily; font.weight: Font.Light
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text:  Qt.formatDate(new Date(), "dddd, MMMM d")
                        color: Themes.AuralisTheme.onSurfaceVariant
                        font.pixelSize: 16; font.family: Themes.AuralisTheme.fontFamily
                    }
                    Timer {
                        interval: 1000; running: true; repeat: true
                        onTriggered: _bigClock.text = Qt.formatTime(new Date(), "HH:mm")
                    }
                }

                // ── System info ───────────────────────────────────────────
                GridLayout {
                    width:   parent.width
                    columns: 2
                    rowSpacing: 8
                    columnSpacing: 8

                    _InfoCard { icon: "memory";  label: "RAM";  value: _ramUsage }
                    _InfoCard { icon: "speed";   label: "CPU";  value: _cpuUsage }
                    _InfoCard {
                        icon:  Services.BatteryService.icon()
                        label: "Battery"
                        value: Services.BatteryService.present ? Services.BatteryService.percentage + "%" : "N/A"
                        visible: Services.BatteryService.present
                    }
                    _InfoCard {
                        icon:  Services.NetworkService.signalIcon()
                        label: "Network"
                        value: Services.NetworkService.ssid || (Services.NetworkService.connected ? "Connected" : "Offline")
                    }
                }

                // ── Media player ──────────────────────────────────────────
                C.Surface {
                    width:   parent.width
                    height:  120
                    radius:  Themes.AuralisTheme.shapeLarge
                    elevation: 2
                    visible: Services.MprisService.title !== ""

                    Row {
                        anchors { fill: parent; margins: 16 }
                        spacing: 16

                        Rectangle {
                            width: 88; height: 88; radius: 12
                            color: Themes.AuralisTheme.surfaceVariant
                            anchors.verticalCenter: parent.verticalCenter
                            Image {
                                anchors.fill: parent
                                source: Services.MprisService.artUrl ? "file://" + Services.MprisService.artUrl : ""
                                fillMode: Image.PreserveAspectCrop
                            }
                        }

                        Column {
                            width:   parent.width - 88 - 16
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 4

                            Text {
                                text:  Services.MprisService.title || "Nothing playing"
                                color: Themes.AuralisTheme.onSurface
                                font.pixelSize: 15; font.family: Themes.AuralisTheme.fontFamily; font.weight: Font.Medium
                                elide: Text.ElideRight; width: parent.width
                            }
                            Text {
                                text:  Services.MprisService.artist || ""
                                color: Themes.AuralisTheme.onSurfaceVariant
                                font.pixelSize: 12; font.family: Themes.AuralisTheme.fontFamily
                                elide: Text.ElideRight; width: parent.width
                            }

                            // Progress
                            Item { height: 4 }
                            Rectangle {
                                width: parent.width; height: 4; radius: 2
                                color: Themes.AuralisTheme.surfaceVariant
                                Rectangle {
                                    width: Services.MprisService.duration > 0
                                           ? parent.width * (Services.MprisService.position / Services.MprisService.duration)
                                           : 0
                                    height: parent.height; radius: parent.radius
                                    color: Themes.AuralisTheme.primary
                                    Behavior on width { NumberAnimation { duration: 500 } }
                                }
                            }

                            Row {
                                spacing: 8
                                Repeater {
                                    model: [
                                        { i: "skip_previous", a: () => Services.MprisService.previous() },
                                        { i: Services.MprisService.playing ? "pause" : "play_arrow", a: () => Services.MprisService.playPause() },
                                        { i: "skip_next",     a: () => Services.MprisService.next() },
                                    ]
                                    delegate: Item {
                                        width: 28; height: 28
                                        C.MdIcon { name: modelData.i; size: 18; anchors.centerIn: parent; color: Themes.AuralisTheme.onSurface }
                                        MouseArea { anchors.fill: parent; onClicked: modelData.a() }
                                    }
                                }
                            }
                        }
                    }
                }

                // ── Shortcuts ─────────────────────────────────────────────
                Text {
                    text:  "Quick launch"
                    color: Themes.AuralisTheme.onSurfaceVariant
                    font.pixelSize: 12; font.family: Themes.AuralisTheme.fontFamily; font.weight: Font.Medium
                }

                Flow {
                    width: parent.width
                    spacing: 8

                    Repeater {
                        model: [
                            { label: "Terminal",  icon: "terminal",  exec: "kitty" },
                            { label: "Files",     icon: "folder",    exec: "nautilus" },
                            { label: "Browser",   icon: "language",  exec: "firefox" },
                            { label: "Settings",  icon: "settings",  exec: "" },
                        ]
                        delegate: Rectangle {
                            width:  (parent.width - 8 * 3) / 4
                            height: 60
                            radius: Themes.AuralisTheme.shapeLarge
                            color:  Themes.AuralisTheme.surfaceVariant

                            Column {
                                anchors.centerIn: parent; spacing: 4
                                C.MdIcon { name: modelData.icon; size: 20; color: Themes.AuralisTheme.onSurface; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: modelData.label; color: Themes.AuralisTheme.onSurface; font.pixelSize: 11; font.family: Themes.AuralisTheme.fontFamily; anchors.horizontalCenter: parent.horizontalCenter }
                            }

                            MouseArea {
                                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.visible = false
                                    if (modelData.exec) {
                                        Qt.createQmlObject('import Quickshell.Io; Process { command: ["bash","-c","' + modelData.exec + ' &"]; running: true }', root)
                                    } else {
                                        Qt.createQmlObject('import Quickshell.Io; Process { command: ["qs","ipc","call","auralis","toggleSettings"]; running: true }', root)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // ── System metrics (polled) ───────────────────────────────────────────────
    property string _ramUsage: "–"
    property string _cpuUsage: "–"

    Timer {
        interval: 5000; running: true; repeat: true
        onTriggered: _pollSystem()
    }

    function _pollSystem() {
        Qt.createQmlObject(
            'import Quickshell.Io; Process { ' +
            'command: ["bash","-c","free -m | awk \'/^Mem/{printf \"%d/%d MB\", $3, $2}\'"]; ' +
            'stdout: StdioCollector { onStreamFinished: root._ramUsage = content.trim() } ' +
            'running: true }', root)
        Qt.createQmlObject(
            'import Quickshell.Io; Process { ' +
            'command: ["bash","-c","grep cpu /proc/stat | awk \'NR==1{u=$2+$3+$4; t=u+$5+$6+$7+$8; printf \"%d%%\", u*100/t}\'"]; ' +
            'stdout: StdioCollector { onStreamFinished: root._cpuUsage = content.trim() } ' +
            'running: true }', root)
    }

    Component.onCompleted: _pollSystem()

    component _InfoCard: C.Surface {
        property string icon:  ""
        property string label: ""
        property string value: ""

        Layout.fillWidth: true
        height: 52
        radius: Themes.AuralisTheme.shapeLarge
        elevation: 1

        Row {
            anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 12 }
            spacing: 10
            C.MdIcon { name: icon; size: 18; color: Themes.AuralisTheme.primary; anchors.verticalCenter: parent.verticalCenter }
            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2
                Text { text: label; color: Themes.AuralisTheme.onSurfaceVariant; font.pixelSize: 11; font.family: Themes.AuralisTheme.fontFamily }
                Text { text: value; color: Themes.AuralisTheme.onSurface; font.pixelSize: 13; font.family: Themes.AuralisTheme.fontFamily; font.weight: Font.Medium }
            }
        }
    }

    Keys.onEscapePressed: root.visible = false
}
