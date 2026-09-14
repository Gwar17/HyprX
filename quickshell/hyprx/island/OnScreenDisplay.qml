import QtQuick
import Quickshell
import ".."

PanelWindow {
    id: window
    property var systemService
    property var settingsService
    property string kind: ""
    property string label: ""
    property real level: 0
    property bool showing: false

    visible: showing && settingsService && settingsService.osdEnabled
    implicitWidth: 300
    implicitHeight: 76
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    anchors { bottom: true }
    margins { bottom: 72 }
    mask: Region { item: card }

    Connections {
        target: systemService
        function onOsdRequested(nextKind, nextValue, nextLabel) {
            window.kind = nextKind
            window.level = Math.max(0, Math.min(1, nextValue))
            window.label = nextLabel
            window.showing = true
            hideTimer.restart()
        }
    }

    Timer { id: hideTimer; interval: 1400; repeat: false; onTriggered: window.showing = false }

    Rectangle {
        id: card
        anchors.centerIn: parent
        width: 276
        height: 58
        radius: 20
        color: Theme.island
        border.width: 1
        border.color: Theme.islandBorder

        Row {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: window.kind === "brightness" ? "󰃠" : "󰕾"
                color: Theme.fg
                font.family: Theme.monoFont
                font.pixelSize: 18
            }
            Column {
                anchors.verticalCenter: parent.verticalCenter
                width: 210
                spacing: 6
                Text { text: window.label; color: Theme.fg; font.family: Theme.uiFont; font.pixelSize: 11; font.bold: true }
                Rectangle {
                    width: 210; height: 5; radius: 3; color: Theme.border
                    Rectangle { width: parent.width * window.level; height: parent.height; radius: parent.radius; color: Theme.accent }
                }
            }
        }
    }
}
