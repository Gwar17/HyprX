import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: service

    readonly property string material: live.material
    readonly property bool glossyBlack: material === "black"
    readonly property bool blackFrost: material === "frost"
    readonly property bool transparentGlass: material === "glass"

    function validMaterial(value) {
        return value === "black" || value === "frost" || value === "glass"
    }

    function setMaterial(value) {
        if (validMaterial(value))
            live.material = value
    }

    PersistentProperties {
        id: live
        reloadableId: "hyprxAppearance"
        property string material: "frost"

        onMaterialChanged: {
            if (!service.validMaterial(material)) {
                material = "frost"
                return
            }

            if (state.material !== material)
                state.material = material
        }
    }

    FileView {
        id: stateFile
        path: Quickshell.statePath("appearance.json")
        watchChanges: true

        onFileChanged: reload()

        onLoaded: {
            if (service.validMaterial(state.material)) {
                if (live.material !== state.material)
                    live.material = state.material
            } else {
                state.material = live.material
            }
        }

        onLoadFailed: {
            state.material = live.material
            writeAdapter()
        }

        onAdapterUpdated: writeAdapter()

        JsonAdapter {
            id: state
            property string material: "frost"
        }
    }
}