// Auralis: Material 3 surface container
// elevation: 0-5 (maps to surfaceContainer variants)
// Use as background for panels and cards

import QtQuick
import "../themes" as Themes

Rectangle {
    id: root

    property int   elevation:   1
    property real  bgOpacity:   1.0
    property bool  blurBehind:  false
    property int   radius:      Themes.AuralisTheme.shapeMedium

    color:   Qt.rgba(
        _surfaceColor.r, _surfaceColor.g, _surfaceColor.b,
        bgOpacity
    )
    border.color: Themes.AuralisTheme.outlineVariant
    border.width: 0

    property color _surfaceColor: {
        switch (elevation) {
        case 0: return Themes.AuralisTheme.surface
        case 1: return Themes.AuralisTheme.surfaceContainerLow
        case 2: return Themes.AuralisTheme.surfaceContainer
        case 3: return Themes.AuralisTheme.surfaceContainerHigh
        case 4: return Themes.AuralisTheme.surfaceContainerHighest ?? Themes.AuralisTheme.surfaceContainerHigh
        default: return Themes.AuralisTheme.surfaceBright
        }
    }

    layer.enabled:          blurBehind
    layer.effect: blurBehind ? _blurComp : null

    Component {
        id: _blurComp
        // Quickshell blur effect on Wayland
        // Replace with WlrLayerShell blur property where supported
        Item {}
    }
}
