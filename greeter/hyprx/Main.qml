import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    width: 1920; height: 1080
    color: "#09090b"

    Image { anchors.fill: parent; source: "background.png"; fillMode: Image.PreserveAspectCrop }
    Rectangle { anchors.fill: parent; color: "#88000000" }

    Column {
        anchors.centerIn: parent
        width: 360
        spacing: 16
        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "HyprX"; color: "white"; font.pixelSize: 42; font.weight: Font.DemiBold }
        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "ONE ISLAND. EVERYTHING YOU NEED."; color: "#a8a8b3"; font.pixelSize: 11; font.letterSpacing: 2 }
        Item { width: 1; height: 14 }
        Rectangle {
            width: parent.width; height: 48; radius: 14; color: "#dd0b0b0d"; border.color: "#28282d"
            TextInput { id: user; anchors.fill: parent; anchors.margins: 14; color: "white"; font.pixelSize: 14; verticalAlignment: TextInput.AlignVCenter; text: userModel.lastUser; selectByMouse: true }
        }
        Rectangle {
            width: parent.width; height: 48; radius: 14; color: "#dd0b0b0d"; border.color: password.activeFocus ? "#5f87d7" : "#28282d"
            TextInput { id: password; anchors.fill: parent; anchors.margins: 14; color: "white"; font.pixelSize: 14; verticalAlignment: TextInput.AlignVCenter; echoMode: TextInput.Password; focus: true; onAccepted: sddm.login(user.text, password.text, session.index) }
        }
        Row {
            width: parent.width; spacing: 10
            ComboBox { id: session; width: 230; height: 42; model: sessionModel; textRole: "name"; currentIndex: sessionModel.lastIndex }
            Button { width: 120; height: 42; text: "Log in"; onClicked: sddm.login(user.text, password.text, session.index) }
        }
        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "More than a desktop. A state of flow."; color: "#8a8a94"; font.pixelSize: 11 }
    }

    Row {
        anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: 24; spacing: 8
        Button { text: "Restart"; onClicked: sddm.reboot() }
        Button { text: "Shut down"; onClicked: sddm.powerOff() }
    }
}
