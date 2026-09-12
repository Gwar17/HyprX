import QtQuick
import Quickshell
import ".."
import "modes"

PanelWindow {
    id: window
    property var router
    property var themeService
    property var wallpaperService
    property var appService
    property var mediaService
    property var systemService
    property var notificationService
    property date now: new Date()

    function modeWidth() {
        switch (router.mode) {
        case "control": return 560; case "notifications": return 560; case "launcher": return 620;
        case "power": return 620; case "theme": return 660; case "wallpaper": return 660; default: return 640;
        }
    }
    function modeHeight() {
        switch (router.mode) {
        case "control": return 430; case "notifications": return 500; case "launcher": return 430;
        case "power": return 190; case "theme": return 210; case "wallpaper": return 210; default: return 180;
        }
    }

    visible: true
    implicitWidth: 700
    implicitHeight: 540
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    anchors { top: true }
    margins { top: 8 }
    mask: Region { item: surface }

    Timer { interval: 1000; repeat: true; running: true; onTriggered: window.now = new Date() }
    Connections { target: router; function onExpandedChanged() { if (router.expanded) focusDelay.restart() } }
    Timer { id: focusDelay; interval: 120; repeat: false; onTriggered: content.forceActiveFocus() }

    Rectangle {
        id: surface
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: router.expanded ? window.modeWidth() : 124
        height: router.expanded ? window.modeHeight() : 34
        radius: router.expanded ? 20 : 17
        color: Theme.island
        border.width: 1
        border.color: Theme.islandBorder
        clip: true

        Behavior on width { NumberAnimation { duration: Theme.islandMorphDuration; easing.type: Easing.InOutCubic } }
        Behavior on height { NumberAnimation { duration: Theme.islandMorphDuration; easing.type: Easing.InOutCubic } }
        Behavior on radius { NumberAnimation { duration: Theme.islandMorphDuration; easing.type: Easing.InOutCubic } }

        MouseArea { anchors.fill: parent; enabled: !router.expanded; cursorShape: Qt.PointingHandCursor; onClicked: router.open("media") }

        Text {
            anchors.centerIn: parent
            text: Qt.formatTime(window.now, "hh:mm")
            color: "#f5f5f7"
            font.family: Theme.uiFont
            font.pixelSize: 13
            font.weight: Font.DemiBold
            opacity: router.expanded ? 0 : 1
            Behavior on opacity { NumberAnimation { duration: 140 } }
        }

        FocusScope {
            id: content
            anchors.fill: parent
            visible: opacity > 0.01
            opacity: router.expanded ? 1 : 0
            focus: router.expanded
            Keys.onEscapePressed: router.close()
            Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

            ClockMedia { anchors.fill: parent; visible: router.mode === "media"; mediaService: window.mediaService; onDone: router.close() }
            Launcher { anchors.fill: parent; visible: router.mode === "launcher"; service: window.appService; onDone: router.close() }
            ThemeSwitcher { anchors.fill: parent; visible: router.mode === "theme"; service: window.themeService; onDone: router.close() }
            WallpaperSwitcher { anchors.fill: parent; visible: router.mode === "wallpaper"; service: window.wallpaperService; themeService: window.themeService; onDone: router.close() }
            ControlCenter { anchors.fill: parent; visible: router.mode === "control"; systemService: window.systemService; mediaService: window.mediaService; onDone: router.close() }
            Notifications { anchors.fill: parent; visible: router.mode === "notifications"; service: window.notificationService; onDone: router.close() }
            SessionPower { anchors.fill: parent; visible: router.mode === "power"; onDone: router.close() }
        }
    }
}
