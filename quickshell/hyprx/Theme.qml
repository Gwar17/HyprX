pragma Singleton
import QtQuick

QtObject {
    // Active palette. The island shell itself intentionally stays neutral black.
    property color bg: "#11111b"
    property color surface: "#181825"
    property color fg: "#cdd6f4"
    property color muted: "#6c7086"
    property color accent: "#89b4fa"
    property color border: "#313244"

    readonly property color island: "#ee09090b"
    readonly property color islandCard: "#ee111114"
    readonly property color islandBorder: "#2a2a2f"
    readonly property string uiFont: "Inter Variable"
    readonly property string monoFont: "JetBrainsMono Nerd Font Mono"
    readonly property int radius: 20
    readonly property int cardRadius: 12
    readonly property int animationFast: 150
    readonly property int animationNormal: 200
    readonly property int islandMorphDuration: 360

    function applyPalette(p) {
        if (!p) return
        bg = p.bg; surface = p.surface; fg = p.fg; muted = p.muted; accent = p.accent; border = p.border
    }
}
