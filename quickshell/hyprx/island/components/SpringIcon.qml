import QtQuick
import "../.."

Rectangle {
    id: root
    property string icon: ""
    property string label: ""
    property bool active: false
    signal clicked
    signal held

    implicitWidth: label.length ? 92 : 34
    implicitHeight: 30
    radius: 10
    color: active || mouse.containsMouse ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.14) : "transparent"
    scale: mouse.pressed ? 0.90 : (mouse.containsMouse ? 1.08 : 1.0)

    Behavior on scale {
        SpringAnimation { spring: 4.8; damping: 0.34; epsilon: 0.001 }
    }
    Behavior on color { ColorAnimation { duration: Theme.animationFast } }

    Row {
        anchors.centerIn: parent
        spacing: 6
        Text { text: root.icon; color: root.active ? Theme.accent : Theme.fg; font.family: Theme.monoFont; font.pixelSize: 14 }
        Text { visible: root.label.length > 0; text: root.label; color: Theme.fg; font.family: Theme.uiFont; font.pixelSize: 11; font.bold: true }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
        onPressAndHold: root.held()
    }
}
