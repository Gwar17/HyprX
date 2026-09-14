import QtQuick

QtObject {
    id: router

    property string region: ""
    property string view: ""
    property bool pinned: false
    property string hoverRegion: ""

    property string mediaMode: "compact"
    property string notificationMode: "embedded"

    readonly property bool active: region !== ""
    readonly property bool mediaExpanded: region === "left" && view === "media" && mediaMode === "expanded"
    readonly property bool notificationsEmbedded: region === "right" && view === "notifications" && notificationMode === "embedded"
    readonly property bool notificationsFloating: region === "right" && view === "notifications" && notificationMode === "floating"

    function resetModes() {
        mediaMode = "compact"
        notificationMode = "embedded"
    }

    function open(nextRegion, nextView, shouldPin) {
        resetModes()
        region = nextRegion
        view = nextView
        pinned = shouldPin === true
    }

    function close() {
        region = ""
        view = ""
        pinned = false
        resetModes()
    }

    // Hover is deliberately tactile only. It never replaces the compact anchor.
    function hover(nextRegion) { hoverRegion = nextRegion }
    function hoverLeave(nextRegion) {
        if (!nextRegion || hoverRegion === nextRegion)
            hoverRegion = ""
    }

    function toggleMedia() {
        if (region !== "left" || view !== "media") {
            open("left", "media", true)
            mediaMode = "expanded"
            return
        }
        close()
    }

    function toggleNotifications() {
        if (region !== "right" || view !== "notifications") {
            open("right", "notifications", true)
            notificationMode = "embedded"
            return
        }
        if (notificationMode === "embedded") {
            notificationMode = "floating"
            pinned = true
            return
        }
        close()
    }

    function toggleCenter(nextView) {
        if (region === "center" && view === nextView && pinned) {
            close()
            return
        }
        open("center", nextView, true)
    }

    function toggleControl() {
        if (region === "right" && view === "control" && pinned) {
            close()
            return
        }
        open("right", "control", true)
    }

    function show(nextRegion, nextView) { open(nextRegion, nextView, true) }

    function toggle(nextView) {
        if (nextView === "media") { toggleMedia(); return }
        if (nextView === "notifications") { toggleNotifications(); return }
        if (nextView === "control") { toggleControl(); return }
        if (nextView === "clock" || nextView === "launcher" || nextView === "theme" || nextView === "wallpaper" || nextView === "power" || nextView === "settings" || nextView === "calendar") {
            toggleCenter(nextView)
        }
    }
}
