import QtQuick
import "../.."

Rectangle {
    id: root
    property string label: ""
    property bool active: false
    property bool selected: false
    signal clicked

    implicitWidth: 92
    implicitHeight: 42
    radius: 12
    color: active ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.18) : Theme.surface
    border.width: selected || active ? 1.5 : 1
    border.color: selected || active ? Theme.accent : Theme.border
    scale: mouse.pressed ? 0.97 : 1

    Behavior on scale { NumberAnimation { duration: Theme.animationFast } }
    Behavior on border.color { ColorAnimation { duration: Theme.animationFast } }
    Behavior on color { ColorAnimation { duration: Theme.animationFast } }

    Text {
        anchors.centerIn: parent
        text: root.label
        color: root.active ? Theme.accent : Theme.fg
        font.family: Theme.uiFont
        font.pixelSize: 13
        font.weight: Font.Medium
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
