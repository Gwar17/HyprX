import QtQuick
import QtQuick.Layouts
import "../.."
import "../components"

FocusScope {
    id: root
    property var systemService
    property var mediaService
    property int selectedIndex: 0
    signal done
    anchors.fill: parent
    focus: visible

    function activate() {
        if (selectedIndex === 0) systemService.toggleWifi()
        else if (selectedIndex === 1) systemService.toggleBluetooth()
        else if (selectedIndex === 2) systemService.toggleNight()
        else if (selectedIndex === 3) systemService.toggleMute()
        else if (selectedIndex === 6) mediaService.playPause()
    }

    Keys.onEscapePressed: done()
    Keys.onUpPressed: selectedIndex = Math.max(0, selectedIndex - 2)
    Keys.onDownPressed: selectedIndex = Math.min(6, selectedIndex + 2)
    Keys.onLeftPressed: {
        if (selectedIndex === 4) systemService.setVolume(systemService.volume - 0.03)
        else if (selectedIndex === 5) systemService.setBrightness(systemService.brightness - 5)
        else selectedIndex = Math.max(0, selectedIndex - 1)
    }
    Keys.onRightPressed: {
        if (selectedIndex === 4) systemService.setVolume(systemService.volume + 0.03)
        else if (selectedIndex === 5) systemService.setBrightness(systemService.brightness + 5)
        else selectedIndex = Math.min(6, selectedIndex + 1)
    }
    Keys.onReturnPressed: activate()
    Keys.onEnterPressed: activate()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 13

        RowLayout {
            Layout.fillWidth: true
            Text { text: "Control Center"; color: Theme.fg; font.family: Theme.uiFont; font.pixelSize: 19; font.bold: true }
            Item { Layout.fillWidth: true }
            ActionButton { label: "Lock"; implicitWidth: 58; implicitHeight: 32; onClicked: systemService.lock() }
        }

        GridLayout {
            columns: 2; columnSpacing: 10; rowSpacing: 10; Layout.fillWidth: true
            ActionButton { Layout.fillWidth: true; label: systemService.wifiEnabled ? "Wi-Fi · " + systemService.ssid : "Wi-Fi off"; active: systemService.wifiEnabled; selected: root.selectedIndex === 0; onClicked: { root.selectedIndex = 0; systemService.toggleWifi() } }
            ActionButton { Layout.fillWidth: true; label: systemService.bluetoothEnabled ? "Bluetooth on" : "Bluetooth off"; active: systemService.bluetoothEnabled; selected: root.selectedIndex === 1; onClicked: { root.selectedIndex = 1; systemService.toggleBluetooth() } }
            ActionButton { Layout.fillWidth: true; label: systemService.nightMode ? "Night mode" : "Night mode off"; active: systemService.nightMode; selected: root.selectedIndex === 2; onClicked: { root.selectedIndex = 2; systemService.toggleNight() } }
            ActionButton { Layout.fillWidth: true; label: systemService.muted ? "Muted" : "Sound on"; active: !systemService.muted; selected: root.selectedIndex === 3; onClicked: { root.selectedIndex = 3; systemService.toggleMute() } }
        }

        Rectangle {
            Layout.fillWidth: true; Layout.preferredHeight: 64; radius: 12; color: "transparent"
            border.width: root.selectedIndex === 4 ? 1 : 0; border.color: Theme.accent
            ColumnLayout {
                anchors.fill: parent; anchors.margins: 8; spacing: 2
                RowLayout { Layout.fillWidth: true; Text { text: "Volume"; color: Theme.fg; font.family: Theme.uiFont; font.pixelSize: 12 } Item { Layout.fillWidth: true } Text { text: Math.round(systemService.volume * 100) + "%"; color: Theme.muted; font.family: Theme.monoFont; font.pixelSize: 11 } }
                HyprSlider { Layout.fillWidth: true; value: systemService.volume; onPressedChanged: if (pressed) root.selectedIndex = 4; onMoved: systemService.setVolume(value) }
            }
        }
        Rectangle {
            Layout.fillWidth: true; Layout.preferredHeight: 64; radius: 12; color: "transparent"
            border.width: root.selectedIndex === 5 ? 1 : 0; border.color: Theme.accent
            ColumnLayout {
                anchors.fill: parent; anchors.margins: 8; spacing: 2
                RowLayout { Layout.fillWidth: true; Text { text: "Brightness"; color: Theme.fg; font.family: Theme.uiFont; font.pixelSize: 12 } Item { Layout.fillWidth: true } Text { text: systemService.brightness + "%"; color: Theme.muted; font.family: Theme.monoFont; font.pixelSize: 11 } }
                HyprSlider { Layout.fillWidth: true; from: 1; to: 100; value: systemService.brightness; onPressedChanged: if (pressed) root.selectedIndex = 5; onMoved: systemService.setBrightness(value) }
            }
        }

        Rectangle {
            Layout.fillWidth: true; Layout.fillHeight: true; radius: 16; color: Theme.surface
            border.width: root.selectedIndex === 6 ? 1.5 : 1; border.color: root.selectedIndex === 6 ? Theme.accent : Theme.border
            RowLayout {
                anchors.fill: parent; anchors.margins: 12; spacing: 12
                Rectangle { Layout.preferredWidth: 58; Layout.preferredHeight: 58; radius: 12; color: Theme.bg; clip: true; Image { anchors.fill: parent; source: mediaService.artUrl; fillMode: Image.PreserveAspectCrop; visible: mediaService.available } }
                ColumnLayout { Layout.fillWidth: true; Text { text: mediaService.title; color: Theme.fg; font.family: Theme.uiFont; font.bold: true; elide: Text.ElideRight; Layout.fillWidth: true } Text { text: mediaService.artist || "Nothing playing"; color: Theme.muted; font.family: Theme.uiFont; font.pixelSize: 11; elide: Text.ElideRight; Layout.fillWidth: true } }
                ActionButton { label: mediaService.status === "Playing" ? "󰏤" : "󰐊"; implicitWidth: 44; implicitHeight: 36; selected: root.selectedIndex === 6; onClicked: { root.selectedIndex = 6; mediaService.playPause() } }
            }
        }
    }
}
