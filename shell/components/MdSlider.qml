// Auralis: Material 3 slider

import QtQuick
import QtQuick.Controls
import "../themes" as Themes

Item {
    id: root

    property real  value:    0.5
    property real  from:     0.0
    property real  to:       1.0
    property int   steps:    0       // 0 = continuous
    property bool  vertical: false

    signal moved(real v)

    implicitWidth:  vertical ? 40 : 200
    implicitHeight: vertical ? 200 : 40

    // Track
    Rectangle {
        id: _track
        width:   vertical ? 4 : parent.width
        height:  vertical ? parent.height : 4
        radius:  2
        anchors.centerIn: parent
        color:   Themes.AuralisTheme.surfaceVariant

        // Active portion
        Rectangle {
            width:   vertical ? parent.width
                              : _thumb.x + _thumb.width / 2
            height:  vertical ? parent.height - _thumb.y - _thumb.height / 2
                              : parent.height
            radius:  parent.radius
            color:   Themes.AuralisTheme.primary
            anchors.left: parent.left
            anchors.bottom: parent.bottom
        }
    }

    // Thumb
    Rectangle {
        id: _thumb
        width:   20
        height:  20
        radius:  10
        color:   Themes.AuralisTheme.primary
        anchors.verticalCenter: vertical ? undefined : _track.verticalCenter
        anchors.horizontalCenter: vertical ? _track.horizontalCenter : undefined

        property real fraction: (root.value - root.from) / (root.to - root.from)

        x: vertical ? 0 : _track.x + fraction * (_track.width - width)
        y: vertical ? _track.y + (1 - fraction) * (_track.height - height) : 0

        // Shadow
        layer.enabled: true
        layer.effect: null

        Behavior on x { NumberAnimation { duration: 0 } }
        Behavior on y { NumberAnimation { duration: 0 } }

        // Hover indicator
        Rectangle {
            anchors.centerIn: parent
            width:   parent.width + 16
            height:  parent.height + 16
            radius:  width / 2
            color:   Themes.AuralisTheme.primary
            opacity: _ma.containsMouse ? 0.12 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
    }

    MouseArea {
        id: _ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape:  Qt.SizeHorCursor

        onPositionChanged: if (pressed) _update(mouseX, mouseY)
        onPressed:         _update(mouseX, mouseY)

        function _update(mx, my) {
            var frac
            if (vertical)
                frac = 1 - Math.max(0, Math.min(1, (my - _thumb.height / 2) / (_track.height - _thumb.height)))
            else
                frac = Math.max(0, Math.min(1, (mx - _thumb.width / 2) / (_track.width - _thumb.width)))

            var v = root.from + frac * (root.to - root.from)
            if (root.steps > 0) {
                var step = (root.to - root.from) / root.steps
                v = Math.round(v / step) * step
            }
            root.value = v
            root.moved(v)
        }
    }
}
