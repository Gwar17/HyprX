import QtQuick
import QtQuick.Layouts
import "../.."
import "../components"

FocusScope {
    id: root
    property var mediaService
    signal done
    anchors.fill: parent
    focus: visible

    Keys.onLeftPressed: mediaService.previous()
    Keys.onRightPressed: mediaService.next()
    Keys.onSpacePressed: mediaService.playPause()
    Keys.onReturnPressed: mediaService.playPause()
    Keys.onEscapePressed: done()

    property date now: new Date()
    Timer { interval: 1000; repeat: true; running: true; onTriggered: root.now = new Date() }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 16

        Rectangle {
            Layout.preferredWidth: 92; Layout.preferredHeight: 92; radius: 16; color: Theme.surface; clip: true
            Image { anchors.fill: parent; source: mediaService.artUrl; fillMode: Image.PreserveAspectCrop; visible: mediaService.available && mediaService.artUrl.length > 0 }
            Text { anchors.centerIn: parent; visible: !mediaService.available || !mediaService.artUrl.length; text: "♪"; color: Theme.accent; font.pixelSize: 36 }
        }

        ColumnLayout {
            Layout.fillWidth: true; spacing: 5
            Text { text: mediaService.title; color: Theme.fg; font.family: Theme.uiFont; font.pixelSize: 16; font.bold: true; elide: Text.ElideRight; Layout.fillWidth: true }
            Text { text: mediaService.artist || mediaService.album || "No active MPRIS player"; color: Theme.muted; font.family: Theme.uiFont; font.pixelSize: 12; elide: Text.ElideRight; Layout.fillWidth: true }
            RowLayout {
                spacing: 8
                ActionButton { label: "󰒮"; implicitWidth: 44; implicitHeight: 36; onClicked: mediaService.previous() }
                ActionButton { label: mediaService.status === "Playing" ? "󰏤" : "󰐊"; implicitWidth: 48; implicitHeight: 36; active: mediaService.status === "Playing"; onClicked: mediaService.playPause() }
                ActionButton { label: "󰒭"; implicitWidth: 44; implicitHeight: 36; onClicked: mediaService.next() }
            }
        }

        Rectangle { Layout.preferredWidth: 1; Layout.fillHeight: true; Layout.topMargin: 8; Layout.bottomMargin: 8; color: Theme.border }

        ColumnLayout {
            Layout.preferredWidth: 145; spacing: 2
            Text { text: Qt.formatTime(root.now, "hh:mm"); color: Theme.fg; font.family: Theme.monoFont; font.pixelSize: 30; font.bold: true; Layout.alignment: Qt.AlignHCenter }
            Text { text: Qt.formatDate(root.now, "dddd"); color: Theme.accent; font.family: Theme.uiFont; font.pixelSize: 12; Layout.alignment: Qt.AlignHCenter }
            Text { text: Qt.formatDate(root.now, "dd MMMM yyyy"); color: Theme.muted; font.family: Theme.uiFont; font.pixelSize: 11; Layout.alignment: Qt.AlignHCenter }
        }
    }
}
