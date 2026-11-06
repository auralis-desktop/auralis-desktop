// Auralis: Material 3 button variants
// variant: "filled" | "tonal" | "outlined" | "text" | "elevated"

import QtQuick
import QtQuick.Controls
import "../themes" as Themes

Item {
    id: root

    property string label:    ""
    property string iconName: ""
    property string variant:  "filled"
    property bool   enabled:  true
    property int    radius:   Themes.AuralisTheme.shapeFull

    signal clicked()

    implicitWidth:  _row.implicitWidth + 48
    implicitHeight: 40

    // Background
    Rectangle {
        id: _bg
        anchors.fill: parent
        radius:       root.radius
        color:        _bgColor()
        border.color: variant === "outlined" ? Themes.AuralisTheme.outline : "transparent"
        border.width: variant === "outlined" ? 1 : 0

        // State layer (hover / pressed)
        Rectangle {
            anchors.fill: parent
            radius:       parent.radius
            color:        _stateColor()
            opacity:      _mouseArea.containsPress ? 0.12 :
                          _mouseArea.containsMouse ? 0.08 : 0
            Behavior on opacity { NumberAnimation { duration: 100 } }
        }
    }

    Row {
        id: _row
        anchors.centerIn: parent
        spacing: iconName ? 8 : 0

        MdIcon {
            name:  iconName
            size:  18
            color: _contentColor()
            visible: iconName !== ""
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text:  label
            color: _contentColor()
            font.family: Themes.AuralisTheme.fontFamily
            font.pixelSize: 14
            font.weight: Font.Medium
            visible: label !== ""
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: _mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape:  Qt.PointingHandCursor
        enabled:      root.enabled
        onClicked:    root.clicked()
    }

    Behavior on opacity { NumberAnimation { duration: 150 } }
    opacity: root.enabled ? 1.0 : 0.38

    function _bgColor() {
        switch (variant) {
        case "filled":   return Themes.AuralisTheme.primary
        case "tonal":    return Themes.AuralisTheme.secondaryContainer
        case "elevated": return Themes.AuralisTheme.surfaceContainerLow
        default:         return "transparent"
        }
    }

    function _contentColor() {
        switch (variant) {
        case "filled":   return Themes.AuralisTheme.onPrimary
        case "tonal":    return Themes.AuralisTheme.onSecondaryContainer
        case "elevated": return Themes.AuralisTheme.primary
        case "outlined": return Themes.AuralisTheme.primary
        default:         return Themes.AuralisTheme.primary
        }
    }

    function _stateColor() { return _contentColor() }
}
