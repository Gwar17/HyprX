import QtQuick

QtObject {
    id: router
    property string mode: "media"
    property bool expanded: false
    property real morph: 0

    function open(nextMode) {
        mode = nextMode
        expanded = true
    }
    function toggle(nextMode) {
        if (expanded && mode === nextMode)
            expanded = false
        else
            open(nextMode)
    }
    function close() { expanded = false }
}
