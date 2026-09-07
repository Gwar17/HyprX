import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

ShellRoot {
    id: root
    property string mode: "launcher"
    property bool shown: false

    IpcHandler {
        target: "hyprx"
        function launcher(): void { root.mode = "launcher"; root.shown = !root.shown }
        function control(): void { root.mode = "control"; root.shown = !root.shown }
        function files(): void { root.mode = "files"; root.shown = !root.shown }
        function clipboard(): void { root.mode = "clipboard"; root.shown = !root.shown }
        function wallpaper(): void { root.mode = "wallpaper"; root.shown = !root.shown }
        function hide(): void { root.shown = false }
    }

    FloatingWindow {
        id: popup
        visible: root.shown
        width: root.mode === "control" ? 440 : 520
        height: root.mode === "control" ? 440 : 390
        color: "transparent"
        Rectangle {
            anchors.fill: parent; radius: 22; color: "#ee0b0b0d"; border.color: "#28282c"
            ColumnLayout {
                anchors.fill: parent; anchors.margins: 18; spacing: 12
                Text { text: root.mode.charAt(0).toUpperCase() + root.mode.slice(1); color: "#eeeeee"; font.family: "Inter Variable"; font.pixelSize: 20; font.bold: true }
                TextField {
                    id: search; visible: root.mode !== "control"; Layout.fillWidth: true
                    placeholderText: root.mode === "wallpaper" ? "Wallpaper path or search…" : "Search…"
                    color: "#eeeeee"; font.family: "Inter Variable"
                    background: Rectangle { radius: 14; color: "#151517"; border.color: "#28282c" }
                    Keys.onReturnPressed: {
                        if (root.mode === "launcher") run.command = ["sh","-lc", text + " >/dev/null 2>&1 &"]
                        else if (root.mode === "files") run.command = ["sh","-lc", "xdg-open \"$(find $HOME -type f 2>/dev/null | grep -iF -- " + JSON.stringify(text) + " | head -1)\""]
                        else if (root.mode === "wallpaper") run.command = ["hyprx-wallpaper", text]
                        run.running = true; root.shown = false
                    }
                }
                ColumnLayout {
                    visible: root.mode === "control"; Layout.fillWidth: true; spacing: 10
                    Text { text: "Quick controls"; color: "#909095"; font.family: "Inter Variable" }
                    RowLayout {
                        Repeater { model: ["Wi-Fi", "Bluetooth", "Night", "Lock"]
                            delegate: Rectangle { width: 92; height: 58; radius: 16; color: "#151517"; Text { anchors.centerIn: parent; text: modelData; color: "#eeeeee"; font.family: "Inter Variable" } }
                        }
                    }
                    Text { text: "Volume and brightness use your hardware keys."; color: "#909095"; font.family: "Inter Variable" }
                }
                Text { visible: root.mode === "launcher"; text: "Type a command and press Enter"; color: "#909095"; font.family: "Inter Variable" }
                Text { visible: root.mode === "files"; text: "Search your home directory and press Enter"; color: "#909095"; font.family: "Inter Variable" }
                Text { visible: root.mode === "clipboard"; text: "Clipboard history: use cliphist list | fuzzel for now; native list is the next UI module."; wrapMode: Text.WordWrap; Layout.fillWidth: true; color: "#909095"; font.family: "Inter Variable" }
                Text { visible: root.mode === "wallpaper"; text: "Paste an image path and press Enter, or Super+Shift+W for random."; wrapMode: Text.WordWrap; Layout.fillWidth: true; color: "#909095"; font.family: "Inter Variable" }
                Item { Layout.fillHeight: true }
            }
        }
    }
    Process { id: run }
}
