import QtQuick
import Quickshell

QtObject {
    id: service

    function filtered(query) {
        const q = (query || "").trim().toLowerCase()
        const apps = DesktopEntries.applications.values || []
        if (!q)
            return apps.slice(0, 80)
        return apps.filter(app => {
            const haystack = [app.name, app.genericName, app.comment, (app.keywords || []).join(" ")].join(" ").toLowerCase()
            return haystack.indexOf(q) >= 0
        }).slice(0, 80)
    }

    function launch(app) {
        if (app)
            app.execute()
    }
}
