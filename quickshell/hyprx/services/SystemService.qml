import QtQuick
import Quickshell
import Quickshell.Io
import "system"

Scope {
    id: service

    AudioService { id: audio }
    BrightnessService { id: brightness }
    NetworkService { id: network }
    BluetoothService { id: bluetooth }

    readonly property real volume: audio.volume
    readonly property bool muted: audio.muted
    readonly property real brightnessLevel: brightness.level
    readonly property int brightness: Math.round(brightness.level * 100)
    readonly property bool wifiEnabled: network.wifiEnabled
    readonly property bool wifiConnected: network.wifiConnected
    readonly property string ssid: {
        if (!network.wifiDevice || !network.wifiDevice.network)
            return network.wifiConnected ? "Connected" : "Disconnected"
        return network.wifiDevice.network.name || "Connected"
    }
    readonly property bool bluetoothEnabled: bluetooth.enabled
    readonly property bool bluetoothConnected: bluetooth.connected
    property bool nightMode: false

    signal osdRequested(string kind, real value, string label)

    function setVolume(value) {
        audio.setVolume(value)
        osdRequested("volume", Math.max(0, Math.min(1, value)), "Volume")
    }
    function toggleMute() {
        audio.toggleMute()
        osdRequested("volume", audio.muted ? 0 : audio.volume, audio.muted ? "Muted" : "Volume")
    }
    function setBrightness(value) {
        const normalized = value > 1 ? value / 100 : value
        brightness.setLevel(normalized)
        osdRequested("brightness", normalized, "Brightness")
    }
    function toggleWifi() { network.setWifiEnabled(!network.wifiEnabled) }
    function toggleBluetooth() { bluetooth.setEnabled(!bluetooth.enabled) }
    function toggleNight() {
        nightMode = !nightMode
        Quickshell.execDetached(nightMode ? ["hyprctl", "hyprsunset", "temperature", "4500"] : ["hyprctl", "hyprsunset", "identity"])
    }

    function lock() { Quickshell.execDetached(["hyprlock"]) }
    function suspend() { Quickshell.execDetached(["systemctl", "suspend"]) }
    function logout() { Quickshell.execDetached(["hyprctl", "dispatch", "exit"]) }
    function reboot() { Quickshell.execDetached(["systemctl", "reboot"]) }
    function poweroff() { Quickshell.execDetached(["systemctl", "poweroff"]) }
    function openDisplaySettings() { Quickshell.execDetached(["uwsm", "app", "--", "wdisplays"]) }
    function openSystemMonitor() { Quickshell.execDetached(["uwsm", "app", "--", "kitty", "--class", "hyprx-monitor", "btop"]) }
}
