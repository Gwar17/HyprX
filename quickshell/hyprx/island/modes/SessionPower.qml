import QtQuick
import QtQuick.Layouts
import Quickshell
import "../.."
import "../components"

FocusScope {
    id: root
    property int selectedIndex: 0
    property bool confirm: false
    property var actions: [
        {label:"Lock", command:["hyprlock"], destructive:false},
        {label:"Suspend", command:["systemctl","suspend"], destructive:false},
        {label:"Log out", command:["hyprctl","dispatch","exit"], destructive:true},
        {label:"Restart", command:["systemctl","reboot"], destructive:true},
        {label:"Shut down", command:["systemctl","poweroff"], destructive:true}
    ]
    signal done
    anchors.fill: parent
    focus: visible

    function activate() {
        const a = actions[selectedIndex]
        if (a.destructive && !confirm) { confirm = true; return }
        Quickshell.execDetached(a.command)
        done()
    }

    Keys.onLeftPressed: { confirm = false; selectedIndex = Math.max(0, selectedIndex - 1) }
    Keys.onRightPressed: { confirm = false; selectedIndex = Math.min(actions.length - 1, selectedIndex + 1) }
    Keys.onReturnPressed: activate()
    Keys.onEscapePressed: { if (confirm) confirm = false; else done() }

    ColumnLayout {
        anchors.fill: parent; anchors.margins: 18; spacing: 16
        Text { text: confirm ? "Confirm " + actions[selectedIndex].label.toLowerCase() + "?" : "Session"; color: confirm ? Theme.accent : Theme.fg; font.family: Theme.uiFont; font.pixelSize: 18; font.bold: true }
        RowLayout {
            Layout.fillWidth: true; Layout.fillHeight: true; spacing: 10
            Repeater {
                model: root.actions
                ActionButton {
                    required property var modelData
                    required property int index
                    Layout.fillWidth: true; Layout.fillHeight: true
                    label: (root.confirm && index === root.selectedIndex) ? "Confirm" : modelData.label
                    selected: index === root.selectedIndex
                    onClicked: { root.selectedIndex = index; root.activate() }
                }
            }
        }
        Text { Layout.alignment: Qt.AlignRight; text: root.confirm ? "Enter confirm · Esc cancel" : "← → select · Enter"; color: Theme.muted; font.family: Theme.monoFont; font.pixelSize: 11 }
    }
}
