import QtQuick
import Quickshell

QtObject {
    id: service

    readonly property var applications: DesktopEntries.applications.values || []

    function filtered(query) {
        const text = (query || "").trim().toLowerCase()

        if (!text)
            return applications.slice(0, 80)

        return applications.filter(app => {
            const fields = [
                app.name || "",
                app.genericName || "",
                app.comment || "",
                (app.keywords || []).join(" ")
            ]

            return fields.join(" ").toLowerCase().indexOf(text) >= 0
        }).slice(0, 80)
    }

    function launch(app) {
        if (!app)
            return

        const command = app.command

        if (!command || !command.length)
            return

        Quickshell.execDetached(
            ["uwsm", "app", "--"].concat(command)
        )
    }
}