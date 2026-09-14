import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: service

    readonly property bool osdEnabled: live.osdEnabled
    readonly property bool locationEnabled: live.locationEnabled
    readonly property bool animationsEnabled: live.animationsEnabled
    readonly property bool secondsInClock: live.secondsInClock

    function setOsdEnabled(value) { live.osdEnabled = value }
    function setLocationEnabled(value) { live.locationEnabled = value }
    function setAnimationsEnabled(value) { live.animationsEnabled = value }
    function setSecondsInClock(value) { live.secondsInClock = value }

    PersistentProperties {
        id: live
        reloadableId: "hyprxSettings"
        property bool osdEnabled: true
        property bool locationEnabled: false
        property bool animationsEnabled: true
        property bool secondsInClock: false
    }
}
