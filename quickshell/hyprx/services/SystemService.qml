import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: service

    property real volume: 0.5
    property bool muted: false
    property int brightness: 50
    property bool wifiEnabled: false
    property string ssid: "Disconnected"
    property bool bluetoothEnabled: false
    property bool nightMode: false

    function refresh() {
        query.exec(["bash", "-lc",
            "v=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null || true); " +
            "vol=$(printf '%s' \"$v\" | awk '{print $2}'); [ -n \"$vol\" ] || vol=0; " +
            "case \"$v\" in *MUTED*) mute=1;; *) mute=0;; esac; " +
            "b=$(brightnessctl -m 2>/dev/null | awk -F, '{gsub(/%/,\"\",$4); print $4}' | head -1); [ -n \"$b\" ] || b=0; " +
            "wifi=$(nmcli -t -f WIFI g 2>/dev/null || printf disabled); [ \"$wifi\" = enabled ] && w=1 || w=0; " +
            "ssid=$(nmcli -t -f ACTIVE,SSID dev wifi 2>/dev/null | sed -n 's/^yes://p' | head -1); [ -n \"$ssid\" ] || ssid=Disconnected; " +
            "bt=$(bluetoothctl show 2>/dev/null | awk '/Powered:/{print $2; exit}'); [ \"$bt\" = yes ] && bt=1 || bt=0; " +
            "night=$(cat \"${XDG_CONFIG_HOME:-$HOME/.config}/hyprx/night-mode\" 2>/dev/null || printf 0); " +
            "printf '%s\\t%s\\t%s\\t%s\\t%s\\t%s\\t%s\\n' \"$vol\" \"$mute\" \"$b\" \"$w\" \"$ssid\" \"$bt\" \"$night\""])
    }

    function setVolume(value) {
        volume = Math.max(0, Math.min(1, value))
        Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", Math.round(volume * 100) + "%"])
    }
    function toggleMute() { Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]); refreshSoon.restart() }
    function setBrightness(value) {
        brightness = Math.max(1, Math.min(100, Math.round(value)))
        Quickshell.execDetached(["brightnessctl", "set", brightness + "%"])
    }
    function toggleWifi() { Quickshell.execDetached(["nmcli", "radio", "wifi", wifiEnabled ? "off" : "on"]); refreshSoon.restart() }
    function toggleBluetooth() { Quickshell.execDetached(["bluetoothctl", "power", bluetoothEnabled ? "off" : "on"]); refreshSoon.restart() }
    function toggleNight() {
        nightMode = !nightMode
        const cmd = nightMode ? "hyprctl hyprsunset temperature 4500" : "hyprctl hyprsunset identity"
        action.exec(["bash", "-lc", "mkdir -p \"${XDG_CONFIG_HOME:-$HOME/.config}/hyprx\"; " + cmd + " >/dev/null 2>&1 || true; printf '%s\n' " + (nightMode ? "1" : "0") + " > \"${XDG_CONFIG_HOME:-$HOME/.config}/hyprx/night-mode\""])
        refreshSoon.restart()
    }
    function lock() { Quickshell.execDetached(["hyprlock"]) }

    Process { id: action }

    Process {
        id: query
        stdout: StdioCollector {
            onStreamFinished: {
                const p = text.trim().split("\t")
                if (p.length < 7) return
                service.volume = Number(p[0]) || 0
                service.muted = p[1] === "1"
                service.brightness = Number(p[2]) || 0
                service.wifiEnabled = p[3] === "1"
                service.ssid = p[4] || "Disconnected"
                service.bluetoothEnabled = p[5] === "1"
                service.nightMode = p[6] === "1"
            }
        }
    }

    Timer { interval: 2500; repeat: true; running: true; onTriggered: service.refresh() }
    Timer { id: refreshSoon; interval: 350; repeat: false; onTriggered: service.refresh() }
    Component.onCompleted: refresh()
}
