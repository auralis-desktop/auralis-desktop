// Auralis: Power menu

import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import "../components" as C
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
        anchors.fill: parent
        color:        "#000000"
        opacity:      root.visible ? 0.6 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }
        MouseArea { anchors.fill: parent; onClicked: root.visible = false }
    }

    C.Surface {
        anchors.centerIn: parent
        width:   320
        height:  _pmCol.implicitHeight + 48
        radius:  Themes.AuralisTheme.shapeExtraLarge
        elevation: 5
        bgOpacity: 0.98

        scale:   root.visible ? 1.0 : 0.8
        opacity: root.visible ? 1.0 : 0
        Behavior on scale   { NumberAnimation { duration: 220; easing.type: Easing.OutBack } }
        Behavior on opacity { NumberAnimation { duration: 180 } }

        Column {
            id: _pmCol
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 24 }
            spacing: 8
            topPadding: 8

            Text {
                text:  "Power"
                color: Themes.AuralisTheme.onSurface
                font.pixelSize: 24; font.family: Themes.AuralisTheme.fontFamily; font.weight: Font.Medium
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Item { height: 8 }

            Repeater {
                model: [
                    { label: "Lock",     icon: "lock",               cmd: "loginctl lock-session" },
                    { label: "Logout",   icon: "logout",             cmd: "hyprctl dispatch exit" },
                    { label: "Suspend",  icon: "brightness_low",     cmd: "systemctl suspend" },
                    { label: "Reboot",   icon: "restart_alt",        cmd: "systemctl reboot" },
                    { label: "Shutdown", icon: "power_settings_new", cmd: "systemctl poweroff" },
                ]
                delegate: Rectangle {
                    width:   parent.width
                    height:  52
                    radius:  Themes.AuralisTheme.shapeLarge
                    color:   modelData.label === "Shutdown" ? Themes.AuralisTheme.errorContainer
                           : modelData.label === "Reboot"   ? Themes.AuralisTheme.tertiaryContainer
                           : Themes.AuralisTheme.surfaceVariant

                    Row {
                        anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 16 }
                        spacing: 12
                        C.MdIcon {
                            name:  modelData.icon
                            size:  20
                            color: modelData.label === "Shutdown" ? Themes.AuralisTheme.onErrorContainer
                                 : modelData.label === "Reboot"   ? Themes.AuralisTheme.onTertiaryContainer
                                 : Themes.AuralisTheme.onSurface
                        }
                        Text {
                            text:  modelData.label
                            color: modelData.label === "Shutdown" ? Themes.AuralisTheme.onErrorContainer
                                 : modelData.label === "Reboot"   ? Themes.AuralisTheme.onTertiaryContainer
                                 : Themes.AuralisTheme.onSurface
                            font.pixelSize: 15; font.family: Themes.AuralisTheme.fontFamily; font.weight: Font.Medium
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    // State layer
                    Rectangle {
                        anchors.fill: parent; radius: parent.radius
                        color: Themes.AuralisTheme.onSurface
                        opacity: _pma.containsPress ? 0.15 : _pma.containsMouse ? 0.06 : 0
                        Behavior on opacity { NumberAnimation { duration: 100 } }
                    }

                    MouseArea {
                        id: _pma; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.visible = false
                            Qt.createQmlObject(
                                'import Quickshell.Io; Process { command: ["bash","-c","' + modelData.cmd + '"]; running: true }',
                                root)
                        }
                    }
                }
            }
        }
    }

    Keys.onEscapePressed: root.visible = false
}
