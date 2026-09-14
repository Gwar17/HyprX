import QtQuick
import Quickshell.Networking

QtObject {
    id: service

    readonly property var devices: Networking.devices.values

    readonly property var wiredDevices:
        devices.filter(device => device.type === DeviceType.Wired)

    readonly property var wifiDevices:
        devices.filter(device => device.type === DeviceType.Wifi)

    readonly property var primaryDevice: choosePrimaryDevice()
    readonly property var wifiDevice: chooseWifiDevice()

    readonly property bool connected:
        devices.some(device => device.connected)

    readonly property bool wiredAvailable:
        wiredDevices.length > 0

    readonly property bool wiredConnected:
        wiredDevices.some(device => device.connected)

    readonly property bool wifiAvailable:
        wifiDevices.length > 0

    readonly property bool wifiConnected:
        wifiDevices.some(device => device.connected)

    readonly property bool wifiHardwareEnabled:
        Networking.wifiHardwareEnabled

    readonly property bool wifiEnabled:
        Networking.wifiEnabled

    readonly property var connectivity:
        Networking.connectivity

    readonly property var wifiNetworks:
        wifiDevice ? wifiDevice.networks.values : []

    function choosePrimaryDevice() {
        for (let i = 0; i < wiredDevices.length; ++i) {
            if (wiredDevices[i].connected)
                return wiredDevices[i]
        }

        for (let i = 0; i < wifiDevices.length; ++i) {
            if (wifiDevices[i].connected)
                return wifiDevices[i]
        }

        if (wiredDevices.length)
            return wiredDevices[0]

        if (wifiDevices.length)
            return wifiDevices[0]

        return null
    }

    function chooseWifiDevice() {
        for (let i = 0; i < wifiDevices.length; ++i) {
            if (wifiDevices[i].connected)
                return wifiDevices[i]
        }

        return wifiDevices.length ? wifiDevices[0] : null
    }

    function setWifiEnabled(enabled) {
        Networking.wifiEnabled = enabled
    }

    function setWifiScanning(enabled) {
        if (wifiDevice)
            wifiDevice.scannerEnabled = enabled
    }

    function connectNetwork(network, psk) {
        if (!network)
            return

        if (psk && psk.length > 0)
            network.connectWithPsk(psk)
        else
            network.connect()
    }

    function disconnectNetwork(network) {
        if (network)
            network.disconnect()
    }

    function disconnectDevice(device) {
        if (device)
            device.disconnect()
    }

    function checkConnectivity() {
        if (Networking.canCheckConnectivity)
            Networking.checkConnectivity()
    }
}