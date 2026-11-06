// Auralis: Notification Center panel

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
    implicitWidth:   380

    Rectangle {
        anchors.fill: parent
        color:        "transparent"
        MouseArea { anchors.fill: parent; onClicked: root.visible = false }
    }

    C.Surface {
        width:  parent.width - 16
        anchors.top:         parent.top
        anchors.topMargin:   Services.Settings.barHeight + 8
        anchors.right:       parent.right
        anchors.rightMargin: 8
        height:  Math.min(_col.implicitHeight + 32, parent.height - Services.Settings.barHeight - 24)
        radius:  Themes.AuralisTheme.shapeExtraLarge
        elevation: 4
        bgOpacity: 0.96
        clip:    true

        Column {
            id: _col
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 16 }
            spacing: 8
            topPadding: 8

            // Header
            Row {
                width: parent.width

                Text {
                    text:  "Notifications"
                    color: Themes.AuralisTheme.onSurface
                    font.pixelSize: 18; font.family: Themes.AuralisTheme.fontFamily; font.weight: Font.Medium
                    anchors.verticalCenter: parent.verticalCenter
                }
                Item { width: 1; height: 1; Layout.fillWidth: true; anchors.horizontalCenter: undefined }
                Item { Layout.fillWidth: true; height: 1 }

                C.MdButton {
                    variant:  "text"
                    label:    "Clear all"
                    visible:  Services.NotificationService.notifications.length > 0
                    onClicked: Services.NotificationService.dismissAll()
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            // DND switch
            Row {
                width: parent.width
                spacing: 12
                C.MdIcon { name: "do_not_disturb_on"; size: 20; color: Themes.AuralisTheme.onSurface; anchors.verticalCenter: parent.verticalCenter }
                Text {
                    text: "Do Not Disturb"
                    color: Themes.AuralisTheme.onSurface
                    font.pixelSize: 14; font.family: Themes.AuralisTheme.fontFamily
                    anchors.verticalCenter: parent.verticalCenter
                    Layout.fillWidth: true
                }
                Item { Layout.fillWidth: true; height: 1 }
                C.MdSwitch {
                    checked:  Services.NotificationService.dnd
                    onToggled: Services.NotificationService.dnd = v
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            // Notification list
            Repeater {
                model: Services.NotificationService.notifications
                delegate: _NotifCard { notif: modelData }
            }

            // Empty state
            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                visible:  Services.NotificationService.notifications.length === 0
                spacing:  8
                topPadding: 24
                bottomPadding: 24

                C.MdIcon { name: "notifications_off"; size: 40; color: Themes.AuralisTheme.onSurfaceVariant; anchors.horizontalCenter: parent.horizontalCenter }
                Text {
                    text:  "No notifications"
                    color: Themes.AuralisTheme.onSurfaceVariant
                    font.pixelSize: 14; font.family: Themes.AuralisTheme.fontFamily
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    // Notification card component
    component _NotifCard: C.Surface {
        property var notif
        radius:    Themes.AuralisTheme.shapeLarge
        elevation: 2
        bgOpacity: 1.0

        Column {
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 12 }
            spacing: 4

            Row {
                width: parent.width
                spacing: 8

                // App icon / initial
                Rectangle {
                    width:  32; height: 32; radius: 16
                    color:  Themes.AuralisTheme.primaryContainer
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        anchors.centerIn: parent
                        text:  (notif?.appName || "?")[0].toUpperCase()
                        color: Themes.AuralisTheme.onPrimaryContainer
                        font.pixelSize: 14; font.weight: Font.Bold
                    }
                }

                Column {
                    width:  parent.width - 32 - 32 - 16
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2
                    Text {
                        text:  notif?.summary || ""
                        color: Themes.AuralisTheme.onSurface
                        font.pixelSize: 13; font.family: Themes.AuralisTheme.fontFamily; font.weight: Font.Medium
                        elide: Text.ElideRight; width: parent.width
                    }
                    Text {
                        text:  notif?.appName || ""
                        color: Themes.AuralisTheme.onSurfaceVariant
                        font.pixelSize: 11; font.family: Themes.AuralisTheme.fontFamily
                    }
                }

                C.MdIcon {
                    name:  "close"; size: 16
                    color: Themes.AuralisTheme.onSurfaceVariant
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea { anchors.fill: parent; onClicked: Services.NotificationService.dismiss(notif?.id) }
                }
            }

            Text {
                text:  notif?.body || ""
                color: Themes.AuralisTheme.onSurfaceVariant
                font.pixelSize: 12; font.family: Themes.AuralisTheme.fontFamily
                wrapMode: Text.WordWrap
                width:   parent.width
                visible: text !== ""
                maximumLineCount: 3
                elide: Text.ElideRight
            }
        }

        implicitHeight: _notifCol.implicitHeight + 24
        Column { id: _notifCol; visible: false }
    }
}
