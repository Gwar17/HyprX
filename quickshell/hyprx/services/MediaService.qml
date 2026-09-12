import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: service

    property bool available: false
    property string status: "Stopped"
    property string title: "Nothing playing"
    property string artist: ""
    property string album: ""
    property string artUrl: ""

    function refresh() { query.exec(["bash", "-lc", "status=$(playerctl status 2>/dev/null || true); meta=$(playerctl metadata --format '{{title}}\\t{{artist}}\\t{{album}}\\t{{mpris:artUrl}}' 2>/dev/null || true); printf '%s\\t%s\\n' \"$status\" \"$meta\""]) }
    function previous() { Quickshell.execDetached(["playerctl", "previous"]); refreshSoon.restart() }
    function playPause() { Quickshell.execDetached(["playerctl", "play-pause"]); refreshSoon.restart() }
    function next() { Quickshell.execDetached(["playerctl", "next"]); refreshSoon.restart() }

    Process {
        id: query
        stdout: StdioCollector {
            onStreamFinished: {
                const p = text.trim().split("\t")
                service.status = p[0] || "Stopped"
                service.available = p.length > 1 && (p[1] || p[2] || p[3])
                service.title = p[1] || "Nothing playing"
                service.artist = p[2] || ""
                service.album = p[3] || ""
                service.artUrl = p[4] || ""
            }
        }
    }

    Timer { interval: 1500; repeat: true; running: true; onTriggered: service.refresh() }
    Timer { id: refreshSoon; interval: 180; repeat: false; onTriggered: service.refresh() }
    Component.onCompleted: refresh()
}
