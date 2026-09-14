import QtQuick
import Quickshell
import ".."

PanelWindow {
    id: window
    property var service

    visible: service && service.toastVisible && service.latest !== null
    implicitWidth: 420
    implicitHeight: card.implicitHeight + 24
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    anchors { top: true; right: true }
    margins { top: 18; right: 18 }
    mask: Region { item: card }

    NovaNotificationCard {
        id: card
        anchors.top: parent.top
        anchors.right: parent.right
        width: 390
        notification: window.service ? window.service.latest : null
        onDismissRequested: {
            window.service.dismiss(notification)
            window.service.toastVisible = false
        }
    }
}
