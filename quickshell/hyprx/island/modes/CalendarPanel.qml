import QtQuick
import QtQuick.Layouts
import "../.."

FocusScope {
    id: root
    property date now: new Date()
    signal done
    anchors.fill: parent
    focus: visible
    Keys.onEscapePressed: done()

    Timer { interval: 1000; repeat: true; running: true; onTriggered: root.now = new Date() }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 8
        Text { text: Qt.formatDate(root.now, "dddd"); color: Theme.accent; font.family: Theme.uiFont; font.pixelSize: 16; font.bold: true }
        Text { text: Qt.formatDate(root.now, "dd MMMM yyyy"); color: Theme.fg; font.family: Theme.uiFont; font.pixelSize: 28; font.bold: true }
        Text { text: Qt.formatTime(root.now, "hh:mm:ss"); color: Theme.muted; font.family: Theme.monoFont; font.pixelSize: 18 }
        Item { Layout.fillHeight: true }
        Text { text: "Calendar"; color: Theme.muted; font.family: Theme.uiFont; font.pixelSize: 12 }
    }
}
