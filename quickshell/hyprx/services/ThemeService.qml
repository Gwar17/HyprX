import QtQuick
import Quickshell
import Quickshell.Io
import ".."

Scope {
    id: service

    property var themes: []
    property string activeTheme: "Catppuccin"
    property int selectedIndex: 0

    signal themeApplied(string name)

    function refresh() {
        listProcess.exec(["bash", "-lc",
            "set -e; base=\"${XDG_CONFIG_HOME:-$HOME/.config}/hyprx/themes\"; " +
            "active=$(cat \"${XDG_CONFIG_HOME:-$HOME/.config}/hyprx/current-theme.txt\" 2>/dev/null || printf Catppuccin); " +
            "printf 'ACTIVE\\t%s\\n' \"$active\"; " +
            "for d in \"$base\"/*; do [ -f \"$d/hyprx.env\" ] || continue; " +
            "unset HYPRX_BG HYPRX_SURFACE HYPRX_FG HYPRX_MUTED HYPRX_ACCENT HYPRX_BORDER; . \"$d/hyprx.env\"; " +
            "printf 'THEME\\t%s\\t%s\\t%s\\t%s\\t%s\\t%s\\t%s\\n' \"$(basename \"$d\")\" \"$HYPRX_BG\" \"$HYPRX_SURFACE\" \"$HYPRX_FG\" \"$HYPRX_MUTED\" \"$HYPRX_ACCENT\" \"$HYPRX_BORDER\"; done"])
    }

    function paletteFor(name) {
        for (let i = 0; i < themes.length; ++i)
            if (themes[i].name === name)
                return themes[i]
        return themes.length ? themes[0] : null
    }

    function apply(name) {
        const p = paletteFor(name)
        if (p) {
            activeTheme = name
            selectedIndex = Math.max(0, themes.findIndex(t => t.name === name))
            Theme.applyPalette(p)
        }
        applyProcess.exec(["hyprx-theme", name])
    }

    function select(delta) {
        if (!themes.length)
            return
        selectedIndex = (selectedIndex + delta + themes.length) % themes.length
    }

    Process {
        id: listProcess
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")
                let found = []
                let current = service.activeTheme
                for (const line of lines) {
                    const p = line.split("\t")
                    if (p[0] === "ACTIVE")
                        current = p[1] || current
                    else if (p[0] === "THEME" && p.length >= 8)
                        found.push({name:p[1], bg:p[2], surface:p[3], fg:p[4], muted:p[5], accent:p[6], border:p[7]})
                }
                service.themes = found
                service.activeTheme = current
                service.selectedIndex = Math.max(0, found.findIndex(t => t.name === current))
                Theme.applyPalette(service.paletteFor(current))
            }
        }
    }

    Process {
        id: applyProcess
        stdout: StdioCollector {
            onStreamFinished: service.themeApplied(service.activeTheme)
        }
    }

    Component.onCompleted: refresh()
}
