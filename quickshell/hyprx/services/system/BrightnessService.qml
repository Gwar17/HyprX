import QtQuick
import Quickshell.Io

QtObject {
    id: service

    property real level: 0
    property bool available: false

    property int currentValue: -1
    property int maximumValue: -1

    function updateLevel() {
        available = currentValue >= 0 && maximumValue > 0

        if (available)
            level = Math.max(0, Math.min(1, currentValue / maximumValue))
    }

    function refresh() {
        currentProcess.exec([
            "brightnessctl",
            "get"
        ])

        maximumProcess.exec([
            "brightnessctl",
            "max"
        ])
    }

    function setLevel(value) {
        const clamped = Math.max(0, Math.min(1, value))

        writeProcess.exec([
            "brightnessctl",
            "set",
            Math.round(clamped * 100) + "%"
        ])
    }

    function increase(step) {
        const amount = Math.max(1, Math.round((step || 0.05) * 100))

        writeProcess.exec([
            "brightnessctl",
            "set",
            amount + "%+"
        ])
    }

    function decrease(step) {
        const amount = Math.max(1, Math.round((step || 0.05) * 100))

        writeProcess.exec([
            "brightnessctl",
            "set",
            amount + "%-"
        ])
    }

    Process {
        id: currentProcess

        stdout: StdioCollector {
            onStreamFinished: {
                const value = parseInt(text.trim())
                service.currentValue = isNaN(value) ? -1 : value
                service.updateLevel()
            }
        }
    }

    Process {
        id: maximumProcess

        stdout: StdioCollector {
            onStreamFinished: {
                const value = parseInt(text.trim())
                service.maximumValue = isNaN(value) ? -1 : value
                service.updateLevel()
            }
        }
    }

    Process {
        id: writeProcess
        onExited: service.refresh()
    }

    Component.onCompleted: refresh()
}