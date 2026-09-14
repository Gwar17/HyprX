import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "../.."

FocusScope {
    id: root
    property var service
    property int selectedIndex: 0
    property var results: service.filtered(search.text)
    signal done

    anchors.fill: parent
    focus: visible

    onResultsChanged: selectedIndex = Math.min(selectedIndex, Math.max(0, results.length - 1))

    Keys.onDownPressed: selectedIndex = Math.min(results.length - 1, selectedIndex + 1)
    Keys.onUpPressed: selectedIndex = Math.max(0, selectedIndex - 1)
    Keys.onEscapePressed: done()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 10

        TextField {
            id: search
            Layout.fillWidth: true
            focus: true
            placeholderText: "Search applications..."
            color: Theme.fg
            font.family: Theme.uiFont
            font.pixelSize: 14
            leftPadding: 14; rightPadding: 14
            background: Rectangle { radius: 13; color: Theme.surface; border.color: search.activeFocus ? Theme.accent : Theme.border }
            Keys.onDownPressed: root.selectedIndex = Math.min(root.results.length - 1, root.selectedIndex + 1)
            Keys.onUpPressed: root.selectedIndex = Math.max(0, root.selectedIndex - 1)
            Keys.onReturnPressed: {
                if (root.results.length) {
                    root.service.launch(root.results[root.selectedIndex])
                    root.done()
                }
            }
            Keys.onEscapePressed: root.done()
        }

        ListView {
            id: list
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 4
            model: root.results
            currentIndex: root.selectedIndex
            onCurrentIndexChanged: if (currentIndex >= 0) root.selectedIndex = currentIndex

            delegate: Rectangle {
                required property var modelData
                required property int index
                width: ListView.view.width; height: 52; radius: 12
                color: index === root.selectedIndex ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.16) : "transparent"
                border.color: index === root.selectedIndex ? Theme.accent : "transparent"

                RowLayout {
                    anchors.fill: parent; anchors.margins: 8; spacing: 10
                    Image { source: Quickshell.iconPath(modelData.icon, true); Layout.preferredWidth: 34; Layout.preferredHeight: 34; fillMode: Image.PreserveAspectFit }
                    ColumnLayout {
                        Layout.fillWidth: true; spacing: 1
                        Text { text: modelData.name; color: Theme.fg; font.family: Theme.uiFont; font.pixelSize: 13; font.bold: true; elide: Text.ElideRight; Layout.fillWidth: true }
                        Text { text: modelData.genericName || modelData.comment || ""; color: Theme.muted; font.family: Theme.uiFont; font.pixelSize: 11; elide: Text.ElideRight; Layout.fillWidth: true }
                    }
                }
                MouseArea {
                    anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                    onEntered: root.selectedIndex = index
                    onClicked: { root.service.launch(modelData); root.done() }
                }
            }
        }
    }
}
