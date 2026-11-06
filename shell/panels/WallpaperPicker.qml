// Auralis: Wallpaper picker

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

    onVisibleChanged: if (visible) Services.WallpaperService.scan()

    Rectangle { anchors.fill: parent; color: "#000000"; opacity: root.visible ? 0.5 : 0; Behavior on opacity { NumberAnimation { duration: 200 } }; MouseArea { anchors.fill: parent; onClicked: root.visible = false } }

    C.Surface {
        anchors.centerIn: parent
        width:   Math.min(parent.width - 64, 720)
        height:  Math.min(parent.height - 128, 560)
        radius:  Themes.AuralisTheme.shapeExtraLarge
        elevation: 4
        bgOpacity: 0.98
        clip:    true

        scale:   root.visible ? 1.0 : 0.9
        opacity: root.visible ? 1.0 : 0
        Behavior on scale   { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: 180 } }

        Column {
            anchors { fill: parent; margins: 20 }
            spacing: 12

            Row {
                width: parent.width
                Text { text: "Wallpapers"; color: Themes.AuralisTheme.onSurface; font.pixelSize: 20; font.family: Themes.AuralisTheme.fontFamily; font.weight: Font.Medium; anchors.verticalCenter: parent.verticalCenter }
                Item { width: 1; height: 1; Layout.fillWidth: true }
                C.MdIcon { name: "close"; size: 20; color: Themes.AuralisTheme.onSurface; anchors.verticalCenter: parent.verticalCenter; MouseArea { anchors.fill: parent; onClicked: root.visible = false } }
            }

            GridView {
                width:       parent.width
                height:      parent.height - 48
                cellWidth:   160
                cellHeight:  100
                clip:        true
                model:       Services.WallpaperService.wallpapers

                delegate: Item {
                    width:  152
                    height: 92

                    Rectangle {
                        anchors { fill: parent; margins: 4 }
                        radius:  Themes.AuralisTheme.shapeMedium
                        color:   Themes.AuralisTheme.surfaceVariant
                        clip:    true
                        border.color: modelData === Services.WallpaperService.current
                                      ? Themes.AuralisTheme.primary : "transparent"
                        border.width: 2

                        Image {
                            anchors.fill: parent
                            source:   "file://" + modelData
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            smooth:   true
                        }

                        Rectangle {
                            anchors.fill: parent; radius: parent.radius
                            color: Themes.AuralisTheme.primary
                            opacity: _wma.containsMouse ? 0.15 : 0
                            Behavior on opacity { NumberAnimation { duration: 100 } }
                        }

                        MouseArea {
                            id: _wma
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape:  Qt.PointingHandCursor
                            onClicked:    Services.WallpaperService.setWallpaper(modelData)
                        }
                    }
                }
            }
        }
    }

    Keys.onEscapePressed: root.visible = false
}
