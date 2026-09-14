import QtQuick
import "../.."

Row {
    id: root
    property string title: ""
    property string trailing: ""
    width: parent ? parent.width : implicitWidth

    Text { text: root.title; color: Theme.fg; font.family: Theme.uiFont; font.pixelSize: 18; font.bold: true }
    Item { width: Math.max(0, root.width - 220); height: 1 }
    Text { text: root.trailing; color: Theme.muted; font.family: Theme.uiFont; font.pixelSize: 12 }
}
