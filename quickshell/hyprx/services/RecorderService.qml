import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: service
    property bool recording: false
    property string outputPath: ""

    function start() {
        if (recording)
            return
        const stamp = Qt.formatDateTime(new Date(), "yyyyMMdd-hhmmss")
        outputPath = "~/Videos/HyprX-" + stamp + ".mp4"
        startProcess.exec(["bash", "-lc", "mkdir -p \"$HOME/Videos\"; pkill -x wf-recorder >/dev/null 2>&1 || true; wf-recorder -f \"$HOME/Videos/HyprX-" + stamp + ".mp4\" >/dev/null 2>&1 &"])
        recording = true
    }

    function stop() {
        if (!recording)
            return
        Quickshell.execDetached(["pkill", "-INT", "wf-recorder"])
        recording = false
    }

    function toggle() { recording ? stop() : start() }

    Process { id: startProcess }
}
