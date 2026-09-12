import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../.."

FocusScope {
    id: root
    property var service
    property int focusIndex: 0
    property var filteredThemes: {
        const q = search.text.trim().toLowerCase()
        return q ? service.themes.filter(t => t.name.toLowerCase().indexOf(q) >= 0) : service.themes
    }
    signal done
    focus: visible
    function applyFocused() { if (filteredThemes.length) { service.apply(filteredThemes[focusIndex].name); done() } }
    onFilteredThemesChanged: focusIndex = Math.min(focusIndex, Math.max(0, filteredThemes.length - 1))
    Keys.onLeftPressed: focusIndex = Math.max(0, focusIndex - 1)
    Keys.onRightPressed: focusIndex = Math.min(filteredThemes.length - 1, focusIndex + 1)
    Keys.onReturnPressed: applyFocused()
    Keys.onEscapePressed: done()

    ColumnLayout {
        anchors.fill: parent; anchors.margins: 16; spacing: 9
        RowLayout {
            Layout.fillWidth: true
            TextField {
                id: search; Layout.preferredWidth: 260; Layout.preferredHeight: 32
                placeholderText: "Search themes..."; color: Theme.fg; font.family: Theme.uiFont; font.pixelSize: 12
                leftPadding: 12; rightPadding: 12
                background: Rectangle { radius: 10; color: Theme.islandCard; border.width: 1; border.color: search.activeFocus ? Theme.accent : Theme.islandBorder }
                Keys.onLeftPressed: root.focusIndex = Math.max(0, root.focusIndex - 1)
                Keys.onRightPressed: root.focusIndex = Math.min(root.filteredThemes.length - 1, root.focusIndex + 1)
                Keys.onReturnPressed: root.applyFocused()
            }
            Item { Layout.fillWidth: true }
            Text { text: service.activeTheme; color: Theme.muted; font.family: Theme.uiFont; font.pixelSize: 11 }
        }
        Flickable {
            Layout.fillWidth: true; Layout.preferredHeight: 92; contentWidth: cards.width; clip: true; boundsBehavior: Flickable.StopAtBounds
            Row {
                id: cards; spacing: 10
                Repeater {
                    model: root.filteredThemes
                    Rectangle {
                        required property var modelData; required property int index
                        width: 112; height: 84; radius: Theme.cardRadius; color: Theme.islandCard; clip: true
                        border.width: index === root.focusIndex ? 2 : 1
                        border.color: index === root.focusIndex ? Theme.accent : Theme.islandBorder
                        scale: mouse.pressed ? 0.98 : 1
                        Behavior on scale { NumberAnimation { duration: Theme.animationFast } }
                        Column {
                            anchors.centerIn: parent; spacing: 8
                            Row {
                                anchors.horizontalCenter: parent.horizontalCenter; spacing: 5
                                Repeater { model: [modelData.bg, modelData.surface, modelData.accent, modelData.fg]
                                    Rectangle { width: 14; height: 14; radius: 7; color: modelData; border.width: 1; border.color: "#333338" }
                                }
                            }
                            Text { anchors.horizontalCenter: parent.horizontalCenter; text: modelData.name; color: Theme.fg; font.family: Theme.uiFont; font.pixelSize: 11 }
                        }
                        MouseArea { id: mouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onEntered: root.focusIndex = index; onClicked: root.focusIndex = index; onDoubleClicked: { root.focusIndex = index; root.applyFocused() } }
                    }
                }
            }
        }
        RowLayout {
            Layout.fillWidth: true
            Text { text: root.filteredThemes.length ? root.filteredThemes[root.focusIndex].name : "No matching themes"; color: Theme.muted; font.family: Theme.uiFont; font.pixelSize: 11 }
            Item { Layout.fillWidth: true }
            Text { text: root.filteredThemes.length ? (root.focusIndex + 1) + "/" + root.filteredThemes.length + "   Enter to apply" : ""; color: Theme.muted; font.family: Theme.monoFont; font.pixelSize: 10 }
        }
    }
}
