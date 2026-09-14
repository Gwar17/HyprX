import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: service

    property var themeService
    property var wallpapers: []
    property int selectedIndex: 0

    function refresh() {
        if (!themeService)
            return
        listProcess.exec(["bash", "-lc",
            "dir=\"$HOME/Pictures/Wallpapers/$1\"; [ -d \"$dir\" ] || exit 0; " +
            "find \"$dir\" -maxdepth 1 -type f \\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \\) -print | sort",
            "hyprx-wallpapers", themeService.activeTheme])
    }

    function select(delta) {
        if (!wallpapers.length)
            return
        selectedIndex = (selectedIndex + delta + wallpapers.length) % wallpapers.length
    }

    function applySelected() {
        if (!wallpapers.length)
            return
        Quickshell.execDetached(["hyprx-wallpaper", wallpapers[selectedIndex]])
    }

    Process {
        id: listProcess
        stdout: StdioCollector {
            onStreamFinished: {
                service.wallpapers = text.split("\n").filter(p => p.length > 0)
                service.selectedIndex = 0
            }
        }
    }

    Connections {
        target: service.themeService
        function onThemeApplied() { service.refresh() }
        function onActiveThemeChanged() { service.refresh() }
    }

    Component.onCompleted: refresh()
}
