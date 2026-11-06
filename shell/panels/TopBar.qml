// Auralis: Top bar panel
// Anchored to top edge, full width, 48px tall

import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../components" as C
import "../services" as Services
import "../themes" as Themes

WlrLayerShell {
    id: root

    layer:      WlrLayer.Top
    anchors.top:   true
    anchors.left:  true
    anchors.right: true
    exclusiveZone: Services.Settings.barHeight
    visible:       Services.Settings.barEnabled

    implicitHeight: Services.Settings.barHeight

    // Bar background
    C.Surface {
        anchors.fill: parent
        elevation:    2
        bgOpacity:    Services.Settings.barTransparency
        radius:       0

        RowLayout {
            anchors.fill:    parent
            anchors.leftMargin:  8
            anchors.rightMargin: 8
            spacing: 4

            // ── Left: launcher + workspaces + window title ─────────────────
            RowLayout {
                spacing: 4
                Layout.fillWidth: false

                // App launcher button
                _BarButton {
                    iconName: "apps"
                    tooltip:  "App Launcher"
                    onClicked: Qt.createQmlObject(
                        'import Quickshell.Io; Process { command: ["qs","ipc","call","auralis","toggleLauncher"]; running: true }',
                        root)
                }

                // Workspace dots
                Row {
                    spacing: 6
                    anchors.verticalCenter: parent.verticalCenter

                    Repeater {
                        model: Math.max(Services.HyprlandService.workspaces.length, 9)
                        delegate: Item {
                            width:  14
                            height: 14
                            anchors.verticalCenter: parent.verticalCenter

                            property int wsId: modelData?.id ?? (index + 1)
                            property bool isActive: wsId === Services.HyprlandService.activeWorkspace

                            Rectangle {
                                anchors.centerIn: parent
                                width:   isActive ? 10 : 6
                                height:  width
                                radius:  width / 2
                                color:   isActive ? Themes.AuralisTheme.primary
                                                  : Themes.AuralisTheme.onSurfaceVariant

                                Behavior on width { NumberAnimation { duration: 150 } }
                                Behavior on color { ColorAnimation  { duration: 150 } }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape:  Qt.PointingHandCursor
                                onClicked:    Services.HyprlandService.switchTo(wsId)
                            }
                        }
                    }
                }

                // Active window title
                Text {
                    text:  Services.HyprlandService.activeWindow || ""
                    color: Themes.AuralisTheme.onSurface
                    font.pixelSize: 13
                    font.family:    Themes.AuralisTheme.fontFamily
                    elide:  Text.ElideRight
                    width:  Math.min(implicitWidth, 280)
                    anchors.verticalCenter: parent.verticalCenter
                    visible: text !== ""
                    leftPadding: 8
                }
            }

            Item { Layout.fillWidth: true }

            // ── Center: clock ─────────────────────────────────────────────
            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 0

                Text {
                    id: _clock
                    anchors.horizontalCenter: parent.horizontalCenter
                    text:  Qt.formatDateTime(new Date(), Services.Settings.clockFormat)
                    color: Themes.AuralisTheme.onSurface
                    font.pixelSize: 14
                    font.weight:    Font.Medium
                    font.family:    Themes.AuralisTheme.fontFamily
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text:    Qt.formatDate(new Date(), "ddd d MMM")
                    color:   Themes.AuralisTheme.onSurfaceVariant
                    font.pixelSize: 11
                    font.family:    Themes.AuralisTheme.fontFamily
                    visible: Services.Settings.showDate
                }

                Timer {
                    interval: 1000
                    running:  true
                    repeat:   true
                    onTriggered: _clock.text = Qt.formatDateTime(new Date(), Services.Settings.clockFormat)
                }
            }

            Item { Layout.fillWidth: true }

            // ── Right: system tray ────────────────────────────────────────
            RowLayout {
                spacing: 2
                Layout.fillWidth: false

                // Network
                _BarButton {
                    iconName: Services.NetworkService.signalIcon()
                    tooltip:  Services.NetworkService.ssid || (Services.NetworkService.connected ? "Connected" : "Disconnected")
                    onClicked: _openQS()
                }

                // Bluetooth
                _BarButton {
                    iconName: Services.BluetoothService.icon()
                    tooltip:  Services.BluetoothService.deviceName || (Services.BluetoothService.enabled ? "Bluetooth on" : "Bluetooth off")
                    visible:  Services.BluetoothService.enabled || Services.BluetoothService.connected
                    onClicked: _openQS()
                }

                // Volume
                _BarButton {
                    iconName: Services.AudioService.volumeIcon()
                    tooltip:  Math.round(Services.AudioService.volume * 100) + "%"
                    onClicked: _openQS()
                }

                // Battery
                _BarButton {
                    iconName: Services.BatteryService.icon()
                    tooltip:  Services.BatteryService.percentage + "% " + Services.BatteryService.status
                    visible:  Services.BatteryService.present
                    textLabel: Services.BatteryService.percentage + "%"
                    onClicked: _openQS()
                }

                // Notifications bell
                _BarButton {
                    iconName: Services.NotificationService.dnd ? "notifications_off"
                            : Services.NotificationService.unreadCount > 0 ? "notifications_active"
                            : "notifications"
                    tooltip:  Services.NotificationService.dnd ? "Do Not Disturb" :
                              Services.NotificationService.unreadCount + " notifications"
                    onClicked: Qt.createQmlObject(
                        'import Quickshell.Io; Process { command: ["qs","ipc","call","auralis","toggleNotifications"]; running: true }',
                        root)
                }

                // Quick settings button
                _BarButton {
                    iconName: "settings"
                    tooltip:  "Quick Settings"
                    onClicked: _openQS()
                }
            }
        }
    }

    function _openQS() {
        Qt.createQmlObject(
            'import Quickshell.Io; Process { command: ["qs","ipc","call","auralis","toggleQuickSettings"]; running: true }',
            root)
    }

    // ── Private bar button component ─────────────────────────────────────────
    component _BarButton: Item {
        property string iconName:  ""
        property string tooltip:   ""
        property string textLabel: ""
        signal clicked()

        implicitWidth:  textLabel ? 56 : 36
        implicitHeight: 36

        Rectangle {
            anchors.centerIn: parent
            width:   parent.width
            height:  parent.height
            radius:  Themes.AuralisTheme.shapeSmall
            color:   Themes.AuralisTheme.primary
            opacity: _ma.containsPress ? 0.18 : _ma.containsMouse ? 0.08 : 0
            Behavior on opacity { NumberAnimation { duration: 100 } }
        }

        Row {
            anchors.centerIn: parent
            spacing: 4

            C.MdIcon {
                name:  iconName
                size:  16
                color: Themes.AuralisTheme.onSurface
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text:       textLabel
                color:      Themes.AuralisTheme.onSurface
                font.pixelSize: 12
                font.family:    Themes.AuralisTheme.fontFamily
                visible:    textLabel !== ""
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Tooltip
        Rectangle {
            id: _tip
            visible:    _ma.containsMouse && tooltip !== ""
            anchors.top: parent.bottom
            anchors.topMargin: 4
            anchors.horizontalCenter: parent.horizontalCenter
            width:   _tipText.implicitWidth + 16
            height:  _tipText.implicitHeight + 8
            radius:  4
            color:   Themes.AuralisTheme.surfaceContainerHigh
            z:       100
            Text {
                id: _tipText
                anchors.centerIn: parent
                text:  tooltip
                color: Themes.AuralisTheme.onSurface
                font.pixelSize: 11
                font.family:    Themes.AuralisTheme.fontFamily
            }
        }

        MouseArea {
            id: _ma
            anchors.fill: parent
            hoverEnabled: true
            cursorShape:  Qt.PointingHandCursor
            onClicked:    parent.clicked()
        }
    }
}
