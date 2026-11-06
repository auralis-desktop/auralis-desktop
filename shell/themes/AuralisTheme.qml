// Auralis: Theme singleton -- Material 3 color roles + design tokens
// Access via `theme` from anywhere in the shell

pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    // ── Settings read-back ───────────────────────────────────────────────────
    property string mode: "dark"   // "light" | "dark"
    property bool   dynamicColor: true
    property color  accentSeed:   "#7965D9"

    // Loaded from tokens.json at startup via Settings service
    onModeChanged: _load()

    function _load() {
        // In production this reads tokens.json; here we inline defaults
        _applyPalette(mode === "dark" ? _dark : _light)
    }

    function _applyPalette(p) {
        primary            = p.primary
        onPrimary          = p.onPrimary
        primaryContainer   = p.primaryContainer
        onPrimaryContainer = p.onPrimaryContainer
        secondary          = p.secondary
        onSecondary        = p.onSecondary
        secondaryContainer = p.secondaryContainer
        onSecondaryContainer = p.onSecondaryContainer
        tertiary           = p.tertiary
        onTertiary         = p.onTertiary
        tertiaryContainer  = p.tertiaryContainer
        onTertiaryContainer = p.onTertiaryContainer
        error              = p.error
        onError            = p.onError
        errorContainer     = p.errorContainer
        onErrorContainer   = p.onErrorContainer
        background         = p.background
        onBackground       = p.onBackground
        surface            = p.surface
        onSurface          = p.onSurface
        surfaceVariant     = p.surfaceVariant
        onSurfaceVariant   = p.onSurfaceVariant
        outline            = p.outline
        outlineVariant     = p.outlineVariant
        surfaceContainer   = p.surfaceContainer
        surfaceContainerHigh = p.surfaceContainerHigh
        surfaceContainerLow  = p.surfaceContainerLow
        surfaceBright      = p.surfaceBright
        surfaceDim         = p.surfaceDim
    }

    // ── Color roles ───────────────────────────────────────────────────────────
    property color primary:            "#CFBCFF"
    property color onPrimary:          "#381E72"
    property color primaryContainer:   "#4F378B"
    property color onPrimaryContainer: "#E9DDFF"
    property color secondary:          "#CCC2DC"
    property color onSecondary:        "#332D41"
    property color secondaryContainer: "#4A4458"
    property color onSecondaryContainer: "#E8DEF8"
    property color tertiary:           "#EFB8C8"
    property color onTertiary:         "#492532"
    property color tertiaryContainer:  "#633B48"
    property color onTertiaryContainer: "#FFD8E4"
    property color error:              "#F2B8B5"
    property color onError:            "#601410"
    property color errorContainer:     "#8C1D18"
    property color onErrorContainer:   "#F9DEDC"
    property color background:         "#1C1B1F"
    property color onBackground:       "#E6E1E5"
    property color surface:            "#1C1B1F"
    property color onSurface:          "#E6E1E5"
    property color surfaceVariant:     "#49454F"
    property color onSurfaceVariant:   "#CAC4D0"
    property color outline:            "#938F99"
    property color outlineVariant:     "#49454F"
    property color surfaceContainer:        "#211F26"
    property color surfaceContainerHigh:    "#2B2930"
    property color surfaceContainerLow:     "#1D1B20"
    property color surfaceBright:           "#3B383E"
    property color surfaceDim:              "#141218"

    // ── Shape ────────────────────────────────────────────────────────────────
    property int shapeExtraSmall: 4
    property int shapeSmall:      8
    property int shapeMedium:     12
    property int shapeLarge:      16
    property int shapeExtraLarge: 28
    property int shapeFull:       9999

    // ── Motion ───────────────────────────────────────────────────────────────
    property real animationSpeed:   1.0
    property int  durationShort:    150
    property int  durationMedium:   300
    property int  durationLong:     500

    // ── Surfaces ──────────────────────────────────────────────────────────────
    property real transparency:  0.85
    property bool blurEnabled:   true
    property int  blurStrength:  8
    property real shadowIntensity: 0.6

    // ── Typography ────────────────────────────────────────────────────────────
    property string fontFamily:     "Noto Sans"
    property string fontFamilyMono: "JetBrains Mono"

    // Computed helpers
    function alpha(c, a) { return Qt.rgba(c.r, c.g, c.b, a) }
    function surface1() { return Qt.rgba(primary.r * 0.05 + surface.r * 0.95,
                                         primary.g * 0.05 + surface.g * 0.95,
                                         primary.b * 0.05 + surface.b * 0.95, 1.0) }

    property var _dark: ({
        primary:            "#CFBCFF", onPrimary:          "#381E72",
        primaryContainer:   "#4F378B", onPrimaryContainer: "#E9DDFF",
        secondary:          "#CCC2DC", onSecondary:        "#332D41",
        secondaryContainer: "#4A4458", onSecondaryContainer: "#E8DEF8",
        tertiary:           "#EFB8C8", onTertiary:         "#492532",
        tertiaryContainer:  "#633B48", onTertiaryContainer: "#FFD8E4",
        error:              "#F2B8B5", onError:            "#601410",
        errorContainer:     "#8C1D18", onErrorContainer:   "#F9DEDC",
        background:         "#1C1B1F", onBackground:       "#E6E1E5",
        surface:            "#1C1B1F", onSurface:          "#E6E1E5",
        surfaceVariant:     "#49454F", onSurfaceVariant:   "#CAC4D0",
        outline:            "#938F99", outlineVariant:     "#49454F",
        surfaceContainer:        "#211F26",
        surfaceContainerHigh:    "#2B2930",
        surfaceContainerLow:     "#1D1B20",
        surfaceBright:           "#3B383E",
        surfaceDim:              "#141218"
    })

    property var _light: ({
        primary:            "#6750A4", onPrimary:          "#FFFFFF",
        primaryContainer:   "#EADDFF", onPrimaryContainer: "#21005D",
        secondary:          "#625B71", onSecondary:        "#FFFFFF",
        secondaryContainer: "#E8DEF8", onSecondaryContainer: "#1D192B",
        tertiary:           "#7D5260", onTertiary:         "#FFFFFF",
        tertiaryContainer:  "#FFD8E4", onTertiaryContainer: "#31111D",
        error:              "#B3261E", onError:            "#FFFFFF",
        errorContainer:     "#F9DEDC", onErrorContainer:   "#410E0B",
        background:         "#FFFBFE", onBackground:       "#1C1B1F",
        surface:            "#FFFBFE", onSurface:          "#1C1B1F",
        surfaceVariant:     "#E7E0EC", onSurfaceVariant:   "#49454F",
        outline:            "#79747E", outlineVariant:     "#CAC4D0",
        surfaceContainer:        "#F3EDF7",
        surfaceContainerHigh:    "#ECE6F0",
        surfaceContainerLow:     "#F7F2FA",
        surfaceBright:           "#FFFBFE",
        surfaceDim:              "#DDD8E1"
    })

    Component.onCompleted: _load()
}
