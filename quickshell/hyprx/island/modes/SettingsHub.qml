import QtQuick
import QtQuick.Layouts
import "../.."
import "../components"

FocusScope {
    id: root
    property var appearanceService
    property var backgroundService
    property var settingsService
    property var systemService
    property var recorderService
    property int selected: 0
    signal done
    signal openCalendar
    signal openSession
    signal openTheme
    signal openWallpaper

    readonly property var items: [
        "General", "User Interface", "Calendar", "On-Screen Display", "Display",
        "Location", "Screen Recorder", "System Monitor", "Lock Screen", "Session Menu"
    ]

    anchors.fill: parent
    focus: visible
    Keys.onEscapePressed: done()

    RowLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 12

        ColumnLayout {
            Layout.preferredWidth: 178
            Layout.fillHeight: true
            spacing: 5
            Text { text: "Settings"; color: Theme.fg; font.family: Theme.uiFont; font.pixelSize: 18; font.bold: true; Layout.bottomMargin: 6 }
            Repeater {
                model: root.items
                Rectangle {
                    required property string modelData
                    required property int index
                    Layout.fillWidth: true
                    Layout.preferredHeight: 34
                    radius: 9
                    color: index === root.selected ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.16) : "transparent"
                    Text { anchors.verticalCenter: parent.verticalCenter; anchors.left: parent.left; anchors.leftMargin: 10; text: modelData; color: index === root.selected ? Theme.fg : Theme.muted; font.family: Theme.uiFont; font.pixelSize: 12; font.bold: index === root.selected }
                    MouseArea { anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.selected = index }
                }
            }
        }

        Rectangle { Layout.preferredWidth: 1; Layout.fillHeight: true; color: Theme.islandBorder }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 12
                Text { text: root.items[root.selected]; color: Theme.fg; font.family: Theme.uiFont; font.pixelSize: 18; font.bold: true }

                // General
                ColumnLayout {
                    visible: root.selected === 0
                    spacing: 10
                    Text { text: "Core desktop behavior and session controls."; color: Theme.muted; font.family: Theme.uiFont; font.pixelSize: 12 }
                    ActionButton { label: "Lock screen"; onClicked: systemService.lock() }
                }

                // User Interface
                ColumnLayout {
                    visible: root.selected === 1
                    spacing: 10
                    Text { text: "Material"; color: Theme.muted; font.family: Theme.uiFont; font.pixelSize: 12 }
                    RowLayout {
                        spacing: 8
                        ActionButton { label: "Glossy Black"; active: appearanceService.glossyBlack; onClicked: appearanceService.setMaterial("black") }
                        ActionButton { label: "Black Frost"; active: appearanceService.blackFrost; onClicked: appearanceService.setMaterial("frost") }
                        ActionButton { label: "Liquid Glass"; active: appearanceService.transparentGlass; onClicked: appearanceService.setMaterial("glass") }
                    }
                    ActionButton { label: settingsService.animationsEnabled ? "Animations on" : "Animations off"; active: settingsService.animationsEnabled; onClicked: settingsService.setAnimationsEnabled(!settingsService.animationsEnabled) }
                    RowLayout {
                        spacing: 8
                        ActionButton { label: "Theme"; onClicked: root.openTheme() }
                        ActionButton { label: "Wallpaper"; onClicked: root.openWallpaper() }
                        ActionButton { label: backgroundService && backgroundService.bokehMode ? "Bokeh" : "Image"; active: backgroundService && backgroundService.bokehMode; onClicked: if (backgroundService) backgroundService.setMode(backgroundService.bokehMode ? "image" : "bokeh") }
                    }
                }

                ColumnLayout {
                    visible: root.selected === 2
                    spacing: 10
                    Text { text: "Open the built-in date and time view."; color: Theme.muted; font.family: Theme.uiFont; font.pixelSize: 12 }
                    ActionButton { label: "Open Calendar"; onClicked: root.openCalendar() }
                }

                ColumnLayout {
                    visible: root.selected === 3
                    spacing: 10
                    Text { text: "Volume and brightness overlays."; color: Theme.muted; font.family: Theme.uiFont; font.pixelSize: 12 }
                    ActionButton { label: settingsService.osdEnabled ? "OSD enabled" : "OSD disabled"; active: settingsService.osdEnabled; onClicked: settingsService.setOsdEnabled(!settingsService.osdEnabled) }
                }

                ColumnLayout {
                    visible: root.selected === 4
                    spacing: 10
                    Text { text: "Monitor arrangement, scale and orientation."; color: Theme.muted; font.family: Theme.uiFont; font.pixelSize: 12 }
                    ActionButton { label: "Open Display Settings"; onClicked: systemService.openDisplaySettings() }
                }

                ColumnLayout {
                    visible: root.selected === 5
                    spacing: 10
                    Text { text: "Privacy control for location-aware modules."; color: Theme.muted; font.family: Theme.uiFont; font.pixelSize: 12 }
                    ActionButton { label: settingsService.locationEnabled ? "Location on" : "Location off"; active: settingsService.locationEnabled; onClicked: settingsService.setLocationEnabled(!settingsService.locationEnabled) }
                }

                ColumnLayout {
                    visible: root.selected === 6
                    spacing: 10
                    Text { text: recorderService.recording ? "Recording in progress" : "Record the current screen to ~/Videos."; color: recorderService.recording ? Theme.accent : Theme.muted; font.family: Theme.uiFont; font.pixelSize: 12 }
                    ActionButton { label: recorderService.recording ? "Stop Recording" : "Start Recording"; active: recorderService.recording; onClicked: recorderService.toggle() }
                }

                ColumnLayout {
                    visible: root.selected === 7
                    spacing: 10
                    Text { text: "Open live CPU, memory and process monitoring."; color: Theme.muted; font.family: Theme.uiFont; font.pixelSize: 12 }
                    ActionButton { label: "Open System Monitor"; onClicked: systemService.openSystemMonitor() }
                }

                ColumnLayout {
                    visible: root.selected === 8
                    spacing: 10
                    Text { text: "Secure the current session immediately."; color: Theme.muted; font.family: Theme.uiFont; font.pixelSize: 12 }
                    ActionButton { label: "Lock Screen"; onClicked: systemService.lock() }
                }

                ColumnLayout {
                    visible: root.selected === 9
                    spacing: 10
                    Text { text: "Lock, suspend, log out, restart or shut down."; color: Theme.muted; font.family: Theme.uiFont; font.pixelSize: 12 }
                    ActionButton { label: "Open Session Menu"; onClicked: root.openSession() }
                }

                Item { Layout.fillHeight: true }
            }
        }
    }
}
