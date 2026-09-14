import QtQuick
import QtQuick.Layouts
import "../.."
import "../components"

FocusScope {
    id: root
    property var systemService
    property var recorderService
    signal done
    signal openSettings
    signal openNotifications
    signal openSession

    anchors.fill: parent
    focus: visible
    Keys.onEscapePressed: done()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            Text { text: "Control Center"; color: Theme.fg; font.family: Theme.uiFont; font.pixelSize: 18; font.bold: true }
            Item { Layout.fillWidth: true }
            ActionButton { label: "Lock"; implicitWidth: 58; implicitHeight: 32; onClicked: systemService.lock() }
        }

        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 8
            columnSpacing: 8
            ActionButton { Layout.fillWidth: true; label: systemService.wifiEnabled ? "Wi-Fi · " + systemService.ssid : "Wi-Fi off"; active: systemService.wifiEnabled; onClicked: systemService.toggleWifi() }
            ActionButton { Layout.fillWidth: true; label: systemService.bluetoothEnabled ? "Bluetooth on" : "Bluetooth off"; active: systemService.bluetoothEnabled; onClicked: systemService.toggleBluetooth() }
            ActionButton { Layout.fillWidth: true; label: systemService.muted ? "Muted" : "Sound"; active: !systemService.muted; onClicked: systemService.toggleMute() }
            ActionButton { Layout.fillWidth: true; label: systemService.nightMode ? "Night mode" : "Night mode off"; active: systemService.nightMode; onClicked: systemService.toggleNight() }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            Text { text: "Volume"; color: Theme.muted; font.family: Theme.uiFont; font.pixelSize: 11; Layout.preferredWidth: 66 }
            HyprSlider { Layout.fillWidth: true; value: systemService.volume; onMoved: systemService.setVolume(value) }
        }
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            Text { text: "Brightness"; color: Theme.muted; font.family: Theme.uiFont; font.pixelSize: 11; Layout.preferredWidth: 66 }
            HyprSlider { Layout.fillWidth: true; value: systemService.brightnessLevel; onMoved: systemService.setBrightness(value) }
        }

        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 8
            columnSpacing: 8
            ActionButton { Layout.fillWidth: true; label: "Notifications"; onClicked: root.openNotifications() }
            ActionButton { Layout.fillWidth: true; label: "Settings"; onClicked: root.openSettings() }
            ActionButton { Layout.fillWidth: true; label: recorderService.recording ? "Stop recording" : "Screen recorder"; active: recorderService.recording; onClicked: recorderService.toggle() }
            ActionButton { Layout.fillWidth: true; label: "Session Menu"; onClicked: root.openSession() }
        }
    }
}
