import QtQuick
import QtQuick.Layouts
import "../.."
import "../../notifications"
import "../components"

FocusScope {
    id: root
    property var service
    property int selectedIndex: 0
    signal done
    anchors.fill: parent
    focus: visible

    Keys.onEscapePressed: done()
    Keys.onUpPressed: selectedIndex = Math.max(0, selectedIndex - 1)
    Keys.onDownPressed: selectedIndex = Math.min(service.notifications.length - 1, selectedIndex + 1)
    Keys.onDeletePressed: if (service.notifications.length) service.dismiss(service.notifications[selectedIndex])
    Keys.onBackspacePressed: if (service.notifications.length) service.dismiss(service.notifications[selectedIndex])

    ColumnLayout {
        anchors.fill: parent; anchors.margins: 16; spacing: 10
        RowLayout {
            Layout.fillWidth: true
            Text { text: "Notifications"; color: Theme.fg; font.family: Theme.uiFont; font.pixelSize: 19; font.bold: true }
            Item { Layout.fillWidth: true }
            ActionButton { label: service.doNotDisturb ? "DND on" : "DND off"; active: service.doNotDisturb; implicitWidth: 74; implicitHeight: 32; onClicked: service.doNotDisturb = !service.doNotDisturb }
            ActionButton { label: "Clear"; implicitWidth: 58; implicitHeight: 32; onClicked: service.clearAll() }
        }

        Item {
            Layout.fillWidth: true; Layout.fillHeight: true
            ListView {
                id: list
                anchors.fill: parent; spacing: 6; clip: true
                model: service.notifications
                currentIndex: root.selectedIndex
                delegate: NovaNotificationCard {
                    required property var modelData
                    required property int index
                    width: ListView.view.width
                    notification: modelData
                    compact: true
                    border.width: index === root.selectedIndex ? 2 : (notification && notification.urgency === 2 ? 2 : 1)
                    onDismissRequested: service.dismiss(modelData)
                    MouseArea { anchors.fill: parent; acceptedButtons: Qt.NoButton; hoverEnabled: true; onEntered: root.selectedIndex = index }
                }
            }
            Text { anchors.centerIn: parent; visible: service.notifications.length === 0; text: "No notifications"; color: Theme.muted; font.family: Theme.uiFont }
        }
    }
}
