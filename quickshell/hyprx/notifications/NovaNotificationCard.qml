import QtQuick
import QtQuick.Layouts
import Quickshell
import ".."

Rectangle {
    id: root
    property var notification
    property bool compact: false
    signal dismissRequested

    implicitWidth: 390
    implicitHeight: content.implicitHeight + 28
    radius: compact ? 16 : 24
    color: Qt.rgba(Theme.bg.r, Theme.bg.g, Theme.bg.b, compact ? 0.82 : 0.72)
    border.width: notification && notification.urgency === 2 ? 2 : 1
    border.color: notification && notification.urgency === 2 ? "#ef4444" : Theme.accent

    Behavior on color { ColorAnimation { duration: Theme.animationNormal } }
    Behavior on border.color { ColorAnimation { duration: Theme.animationNormal } }

    ColumnLayout {
        id: content
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 14
        spacing: 9

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Rectangle {
                Layout.preferredWidth: 46
                Layout.preferredHeight: 46
                radius: 13
                color: Theme.surface
                clip: true
                Image {
                    anchors.fill: parent
                    anchors.margins: 5
                    source: notification && notification.image ? notification.image : (notification && notification.appIcon ? Quickshell.iconPath(notification.appIcon, true) : "")
                    fillMode: Image.PreserveAspectFit
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                Text { text: notification ? (notification.appName || "Notification") : ""; color: Theme.muted; font.family: Theme.uiFont; font.pixelSize: 10; elide: Text.ElideRight; Layout.fillWidth: true }
                Text { text: notification ? notification.summary : ""; color: Theme.fg; font.family: Theme.uiFont; font.pixelSize: 14; font.bold: true; textFormat: Text.PlainText; wrapMode: Text.Wrap; Layout.fillWidth: true }
                Text { text: notification ? notification.body : ""; color: Theme.fg; opacity: 0.82; font.family: Theme.uiFont; font.pixelSize: 12; textFormat: Text.PlainText; wrapMode: Text.Wrap; visible: text.length > 0; Layout.fillWidth: true }
            }

            Rectangle {
                Layout.preferredWidth: 26
                Layout.preferredHeight: 26
                radius: 7
                color: closeMouse.containsMouse ? Theme.accent : "transparent"
                Text { anchors.centerIn: parent; text: "×"; color: closeMouse.containsMouse ? Theme.bg : Theme.muted; font.pixelSize: 18 }
                MouseArea { id: closeMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.dismissRequested() }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            visible: notification && notification.actions && notification.actions.length > 0
            spacing: 6
            Repeater {
                model: notification ? notification.actions : []
                Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.preferredHeight: 30
                    radius: 8
                    color: actionMouse.containsMouse ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.35) : Theme.surface
                    border.color: actionMouse.containsMouse ? Theme.accent : Theme.border
                    Text { anchors.centerIn: parent; text: modelData.text; color: Theme.fg; font.family: Theme.uiFont; font.pixelSize: 11; elide: Text.ElideRight; width: parent.width - 12; horizontalAlignment: Text.AlignHCenter }
                    MouseArea { id: actionMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: modelData.invoke() }
                }
            }
        }
    }
}
