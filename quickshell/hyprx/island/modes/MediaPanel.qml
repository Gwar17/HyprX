import QtQuick
import QtQuick.Layouts
import "../.."
import "../components"

FocusScope {
    id: root
    property var mediaService
    property bool expanded: false
    signal done
    anchors.fill: parent
    focus: visible

    Keys.onLeftPressed: mediaService.previous()
    Keys.onRightPressed: mediaService.next()
    Keys.onSpacePressed: mediaService.togglePlaying()
    Keys.onEscapePressed: done()

    RowLayout {
        anchors.fill: parent
        anchors.margins: expanded ? 18 : 10
        spacing: 14

        Rectangle {
            Layout.preferredWidth: expanded ? 96 : 30
            Layout.preferredHeight: expanded ? 96 : 30
            radius: expanded ? 18 : 9
            color: Theme.surface
            clip: true
            Image {
                anchors.fill: parent
                source: mediaService.artwork
                fillMode: Image.PreserveAspectCrop
                visible: mediaService.available && mediaService.artwork.length > 0
            }
            Text {
                anchors.centerIn: parent
                visible: !mediaService.available || mediaService.artwork.length === 0
                text: "♪"
                color: Theme.accent
                font.pixelSize: expanded ? 36 : 16
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: expanded ? 5 : 0
            Text {
                Layout.fillWidth: true
                text: mediaService.title
                color: Theme.fg
                font.family: Theme.uiFont
                font.pixelSize: expanded ? 16 : 12
                font.bold: true
                elide: Text.ElideRight
            }
            Text {
                Layout.fillWidth: true
                visible: expanded
                text: mediaService.artist || mediaService.album || "No active player"
                color: Theme.muted
                font.family: Theme.uiFont
                font.pixelSize: 12
                elide: Text.ElideRight
            }
            RowLayout {
                visible: expanded
                spacing: 8
                ActionButton { label: "󰒮"; implicitWidth: 42; implicitHeight: 34; onClicked: mediaService.previous() }
                ActionButton { label: mediaService.playing ? "󰏤" : "󰐊"; implicitWidth: 48; implicitHeight: 34; active: mediaService.playing; onClicked: mediaService.togglePlaying() }
                ActionButton { label: "󰒭"; implicitWidth: 42; implicitHeight: 34; onClicked: mediaService.next() }
            }
        }
    }
}
