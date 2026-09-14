import QtQuick
import Quickshell.Bluetooth

QtObject {
    id: service

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool available: adapter !== null
    readonly property bool enabled: available && adapter.enabled
    readonly property bool discovering: available && adapter.discovering

    readonly property var devices:
        available ? adapter.devices.values : []

    readonly property var connectedDevices:
        devices.filter(device => device.connected)

    readonly property bool connected:
        connectedDevices.length > 0

    function setEnabled(value) {
        if (available)
            adapter.enabled = value
    }

    function setDiscovering(value) {
        if (available)
            adapter.discovering = value
    }

    function connectDevice(device) {
        if (device)
            device.connect()
    }

    function disconnectDevice(device) {
        if (device)
            device.disconnect()
    }

    function pairDevice(device) {
        if (device)
            device.pair()
    }

    function cancelPair(device) {
        if (device)
            device.cancelPair()
    }

    function forgetDevice(device) {
        if (device)
            device.forget()
    }
}