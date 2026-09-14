import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Scope {
    id: service

    property var notifications: []
    property var latest: null
    property bool toastVisible: false
    property bool doNotDisturb: false

    function dismiss(notification) {
        if (!notification) return
        notifications = notifications.filter(n => n !== notification)
        notification.dismiss()
    }
    function clearAll() {
        const copy = notifications.slice()
        notifications = []
        for (const n of copy) n.dismiss()
    }

    NotificationServer {
        id: server
        keepOnReload: true
        actionsSupported: true
        imageSupported: true
        bodyImagesSupported: true
        inlineReplySupported: true

        onNotification: notification => {
            notification.tracked = true
            service.notifications = [notification].concat(service.notifications.filter(n => n !== notification))
            service.latest = notification
            notification.closed.connect(function() {
                service.notifications = service.notifications.filter(n => n !== notification)
                if (service.latest === notification) service.latest = null
            })
            if (!service.doNotDisturb) {
                service.toastVisible = true
                toastTimer.restart()
            }
        }
    }

    Timer {
        id: toastTimer
        interval: 4500
        repeat: false
        onTriggered: service.toastVisible = false
    }
}
