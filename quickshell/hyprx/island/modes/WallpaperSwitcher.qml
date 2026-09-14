import QtQuick
import QtQuick.Layouts
import "../.."

FocusScope {
    id: root
    property var service
    property var themeService
    signal done

    anchors.fill: parent
    focus: visible

    Keys.onLeftPressed: service.select(-1)
    Keys.onRightPressed: service.select(1)
    Keys.onReturnPressed: { service.applySelected(); done() }
    Keys.onEscapePressed: done()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            Text { text: "Wallpaper"; color: Theme.fg; font.family: Theme.uiFont; font.pixelSize: 18; font.bold: true }
            Item { Layout.fillWidth: true }
            Text { text: themeService.activeTheme; color: Theme.accent; font.family: Theme.uiFont; font.pixelSize: 12 }
        }

        Flickable {
            id: strip
            Layout.fillWidth: true
            Layout.preferredHeight: 96
            clip: true
            contentWidth: row.width
            boundsBehavior: Flickable.StopAtBounds

            Row {
                id: row
                spacing: 10
                Repeater {
                    model: service.wallpapers
                    Rectangle {
                        required property string modelData
                        required property int index
                        width: 112; height: 84; radius: 12
                        color: Theme.islandCard
                        border.width: index === service.selectedIndex ? 2 : 1
                        border.color: index === service.selectedIndex ? Theme.accent : Theme.islandBorder
                        clip: true
                        Image { anchors.fill: parent; anchors.margins: 3; source: "file://" + modelData; fillMode: Image.PreserveAspectCrop; asynchronous: true; cache: true }
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: service.selectedIndex = index
                            onDoubleClicked: { service.selectedIndex = index; service.applySelected(); root.done() }
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Text {
                text: service.wallpapers.length ? service.wallpapers[service.selectedIndex].split("/").pop().replace(/\.[^.]+$/, "") : "No wallpapers found"
                color: Theme.muted; font.family: Theme.uiFont; font.pixelSize: 12; elide: Text.ElideRight; Layout.maximumWidth: 320
            }
            Item { Layout.fillWidth: true }
            Text { text: service.wallpapers.length ? (service.selectedIndex + 1) + "/" + service.wallpapers.length + "   Enter to apply" : ""; color: Theme.muted; font.family: Theme.monoFont; font.pixelSize: 11 }
        }
    }
}
