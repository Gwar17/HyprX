import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: service

    readonly property string mode: live.mode
    readonly property bool imageMode: mode === "image"
    readonly property bool bokehMode: mode === "bokeh"

    function validMode(value) {
        return value === "image" || value === "bokeh"
    }

    function setMode(value) {
        if (validMode(value))
            live.mode = value
    }

    PersistentProperties {
        id: live
        reloadableId: "hyprxBackground"
        property string mode: "image"

        onModeChanged: {
            if (!service.validMode(mode)) {
                mode = "image"
                return
            }

            if (state.mode !== mode)
                state.mode = mode
        }
    }

    FileView {
        id: stateFile
        path: Quickshell.statePath("background.json")
        watchChanges: true

        onFileChanged: reload()

        onLoaded: {
            if (service.validMode(state.mode)) {
                if (live.mode !== state.mode)
                    live.mode = state.mode
            } else {
                state.mode = live.mode
            }
        }

        onLoadFailed: {
            state.mode = live.mode
            writeAdapter()
        }

        onAdapterUpdated: writeAdapter()

        JsonAdapter {
            id: state
            property string mode: "image"
        }
    }
}