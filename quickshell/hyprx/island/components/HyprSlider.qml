import QtQuick
import QtQuick.Controls
import "../.."

Slider {
    id: root
    from: 0
    to: 1
    background: Rectangle {
        x: root.leftPadding
        y: root.topPadding + root.availableHeight / 2 - height / 2
        width: root.availableWidth
        height: 5
        radius: 3
        color: Theme.border
        Rectangle { width: root.visualPosition * parent.width; height: parent.height; radius: parent.radius; color: Theme.accent }
    }
    handle: Rectangle {
        x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
        y: root.topPadding + root.availableHeight / 2 - height / 2
        implicitWidth: 16; implicitHeight: 16; radius: 8; color: Theme.fg; border.color: Theme.accent
    }
}
