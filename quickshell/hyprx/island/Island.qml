import QtQuick
import QtQuick.Layouts
import Quickshell
import ".."
import "components"
import "modes"

Scope {
    id: root
    property var router
    property var themeService
    property var wallpaperService
    property var appearanceService
    property var backgroundService
    property var settingsService
    property var recorderService
    property var appService
    property var mediaService
    property var systemService
    property var notificationService
    property date now: new Date()

    function materialColor() {
        if (!appearanceService) return Theme.island
        if (appearanceService.glossyBlack) return "#f409090b"
        if (appearanceService.transparentGlass) return "#a014161c"
        return "#e51a1c21"
    }
    function materialBorder() {
        return appearanceService && appearanceService.transparentGlass ? "#66ffffff" : Theme.islandBorder
    }
    function duration() { return settingsService && !settingsService.animationsEnabled ? 0 : Theme.islandMorphDuration }

    Timer { interval: 1000; repeat: true; running: true; onTriggered: root.now = new Date() }

    PanelWindow {
        id: leftWindow
        visible: true
        implicitWidth: 500
        implicitHeight: 270
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        anchors { top: true; left: true }
        margins { top: 8; left: 12 }
        mask: Region { item: leftSurface }

        Rectangle {
            id: leftSurface
            anchors.top: parent.top
            anchors.left: parent.left
            width: router.region === "left" ? 430 : 184
            height: router.region === "left" ? 214 : 38
            radius: router.region === "left" ? 24 : 19
            color: root.materialColor()
            border.width: 1
            border.color: root.materialBorder()
            clip: true

            Behavior on width { NumberAnimation { duration: root.duration(); easing.type: Easing.InOutCubic } }
            Behavior on height { NumberAnimation { duration: root.duration(); easing.type: Easing.InOutCubic } }
            Behavior on radius { NumberAnimation { duration: root.duration(); easing.type: Easing.InOutCubic } }

            Item {
                anchors.fill: parent
                opacity: router.region === "left" ? 0 : 1
                visible: opacity > 0.01
                Behavior on opacity { NumberAnimation { duration: 140 } }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 5
                    anchors.rightMargin: 8
                    spacing: 5
                    SpringIcon {
                        icon: "♪"
                        label: mediaService.available ? mediaService.title : "Media"
                        Layout.fillWidth: true
                        onClicked: router.toggleMedia()
                        onHeld: router.toggleMedia()
                    }
                }
            }

            MediaPanel {
                anchors.fill: parent
                visible: router.region === "left" && router.view === "media"
                opacity: visible ? 1 : 0
                mediaService: root.mediaService
                expanded: true
                onDone: router.close()
                Behavior on opacity { NumberAnimation { duration: 180 } }
            }
        }
    }

    PanelWindow {
        id: centerWindow
        visible: true
        implicitWidth: 720
        implicitHeight: 560
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        anchors { top: true }
        margins { top: 8 }
        mask: Region { item: centerSurface }

        Rectangle {
            id: centerSurface
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: router.region === "center" ? centerWidth() : 232
            height: router.region === "center" ? centerHeight() : 38
            radius: router.region === "center" ? 24 : 19
            color: root.materialColor()
            border.width: 1
            border.color: root.materialBorder()
            clip: true

            function centerWidth() {
                if (router.view === "settings") return 660
                if (router.view === "launcher") return 620
                if (router.view === "theme" || router.view === "wallpaper") return 660
                if (router.view === "power") return 620
                return 420
            }
            function centerHeight() {
                if (router.view === "settings") return 460
                if (router.view === "launcher") return 430
                if (router.view === "theme" || router.view === "wallpaper") return 210
                if (router.view === "power") return 190
                return 190
            }

            Behavior on width { NumberAnimation { duration: root.duration(); easing.type: Easing.InOutCubic } }
            Behavior on height { NumberAnimation { duration: root.duration(); easing.type: Easing.InOutCubic } }
            Behavior on radius { NumberAnimation { duration: root.duration(); easing.type: Easing.InOutCubic } }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 6
                anchors.rightMargin: 6
                visible: router.region !== "center"
                opacity: visible ? 1 : 0
                SpringIcon {
                    icon: "󰥔"
                    label: Qt.formatTime(root.now, settingsService && settingsService.secondsInClock ? "hh:mm:ss" : "hh:mm")
                    Layout.fillWidth: true
                    onClicked: router.toggle("calendar")
                    onHeld: router.toggle("calendar")
                }
                SpringIcon {
                    icon: "󰀻"
                    label: "Launcher"
                    Layout.fillWidth: true
                    onClicked: router.toggle("launcher")
                    onHeld: router.toggle("launcher")
                }
            }

            Launcher { anchors.fill: parent; visible: router.region === "center" && router.view === "launcher"; service: root.appService; onDone: router.close() }
            ThemeSwitcher { anchors.fill: parent; visible: router.region === "center" && router.view === "theme"; service: root.themeService; onDone: router.close() }
            WallpaperSwitcher { anchors.fill: parent; visible: router.region === "center" && router.view === "wallpaper"; service: root.wallpaperService; themeService: root.themeService; onDone: router.close() }
            SessionPower { anchors.fill: parent; visible: router.region === "center" && router.view === "power"; onDone: router.close() }
            CalendarPanel { anchors.fill: parent; visible: router.region === "center" && router.view === "calendar"; onDone: router.close() }
            SettingsHub {
                anchors.fill: parent
                visible: router.region === "center" && router.view === "settings"
                appearanceService: root.appearanceService
                backgroundService: root.backgroundService
                settingsService: root.settingsService
                systemService: root.systemService
                recorderService: root.recorderService
                onDone: router.close()
                onOpenCalendar: router.show("center", "calendar")
                onOpenSession: router.show("center", "power")
                onOpenTheme: router.show("center", "theme")
                onOpenWallpaper: router.show("center", "wallpaper")
            }
        }
    }

    PanelWindow {
        id: rightWindow
        visible: true
        implicitWidth: 760
        implicitHeight: 720
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        anchors { top: true; right: true }
        margins { top: 8; right: 12 }
        mask: Region { item: rightSurface }

        Rectangle {
            id: rightSurface
            anchors.top: parent.top
            anchors.right: parent.right
            width: router.region === "right" ? (router.notificationsFloating ? 680 : 520) : 218
            height: router.region === "right" ? (router.notificationsFloating ? 620 : 410) : 38
            radius: router.region === "right" ? 24 : 19
            color: root.materialColor()
            border.width: 1
            border.color: root.materialBorder()
            clip: true

            Behavior on width { NumberAnimation { duration: root.duration(); easing.type: Easing.InOutCubic } }
            Behavior on height { NumberAnimation { duration: root.duration(); easing.type: Easing.InOutCubic } }
            Behavior on radius { NumberAnimation { duration: root.duration(); easing.type: Easing.InOutCubic } }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 5
                anchors.rightMargin: 5
                visible: router.region !== "right"
                SpringIcon {
                    icon: "󰒓"
                    label: "Control"
                    Layout.fillWidth: true
                    onClicked: router.toggleControl()
                    onHeld: router.toggleControl()
                }
                SpringIcon {
                    icon: notificationService.notifications.length ? "󰂚" : "󰂜"
                    label: notificationService.notifications.length ? String(notificationService.notifications.length) : ""
                    active: notificationService.notifications.length > 0
                    onClicked: router.toggleNotifications()
                    onHeld: router.toggleNotifications()
                }
            }

            ControlCenter {
                anchors.fill: parent
                visible: router.region === "right" && router.view === "control"
                systemService: root.systemService
                recorderService: root.recorderService
                onDone: router.close()
                onOpenSettings: router.show("center", "settings")
                onOpenNotifications: router.show("right", "notifications")
                onOpenSession: router.show("center", "power")
            }

            Notifications {
                anchors.fill: parent
                visible: router.region === "right" && router.view === "notifications"
                service: root.notificationService
                onDone: router.close()
                onFloatRequested: {
                    if (router.notificationMode === "embedded") router.notificationMode = "floating"
                    else router.notificationMode = "embedded"
                }
            }
        }
    }
}
