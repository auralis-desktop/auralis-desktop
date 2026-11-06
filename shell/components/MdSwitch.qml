// Auralis: Material 3 switch

import QtQuick
import "../themes" as Themes

Item {
    id: root

    property bool checked: false
    signal toggled(bool v)

    implicitWidth:  52
    implicitHeight: 32

    // Track
    Rectangle {
        id: _track
        anchors.fill:   parent
        radius:         height / 2
        color:          root.checked ? Themes.AuralisTheme.primary
                                     : Themes.AuralisTheme.surfaceVariant
        border.color:   root.checked ? "transparent"
                                     : Themes.AuralisTheme.outline
        border.width:   2

        Behavior on color { ColorAnimation { duration: 150 } }
    }

    // Thumb
    Rectangle {
        id: _thumb
        width:   root.checked ? 24 : 16
        height:  width
        radius:  width / 2
        anchors.verticalCenter: parent.verticalCenter
        color:   root.checked ? Themes.AuralisTheme.onPrimary
                              : Themes.AuralisTheme.outline
        x:       root.checked ? parent.width - width - 4 : 4

        Behavior on x     { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
        Behavior on width { NumberAnimation { duration: 100 } }
        Behavior on color { ColorAnimation  { duration: 150 } }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape:  Qt.PointingHandCursor
        onClicked: {
            root.checked = !root.checked
            root.toggled(root.checked)
        }
    }
}
