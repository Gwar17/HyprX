import QtQuick
import Quickshell.Services.Pipewire

QtObject {
    id: service

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property bool available: sink !== null && sink.audio !== null

    readonly property real volume:
        available ? sink.audio.volume : 0

    readonly property bool muted:
        available ? sink.audio.muted : false

    readonly property string name:
        sink ? (sink.description || sink.nickname || sink.name || "") : ""

    function setVolume(value) {
        if (!available)
            return

        sink.audio.volume = Math.max(0, Math.min(1, value))
    }

    function toggleMute() {
        if (available)
            sink.audio.muted = !sink.audio.muted
    }

    property PwObjectTracker sinkTracker: PwObjectTracker {
        objects: [service.sink]
    }
}