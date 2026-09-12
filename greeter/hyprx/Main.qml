import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root

    width: 3840
    height: 2160
    color: "#07090d"

    property bool liveMode: config.boolValue("live")

    Image {
        id: background
        anchors.fill: parent
        source: "background.png"
        fillMode: Image.PreserveAspectCrop
        smooth: true
    }

    // Atmospheric darkening for readable controls.
    Rectangle {
        anchors.fill: parent
        color: "#30000000"
    }

    // Subtle animated aurora glow.
    Item {
        anchors.fill: parent
        visible: root.liveMode
        opacity: 0.22

        Rectangle {
            id: auroraOne
            width: parent.width * 0.70
            height: parent.height * 0.42
            x: -parent.width * 0.10
            y: parent.height * 0.02
            radius: height / 2
            rotation: -7
            color: "#245f756b"

            SequentialAnimation on x {
                loops: Animation.Infinite
                NumberAnimation {
                    to: root.width * 0.10
                    duration: 15000
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    to: -root.width * 0.10
                    duration: 15000
                    easing.type: Easing.InOutSine
                }
            }

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation { to: 0.38; duration: 7000 }
                NumberAnimation { to: 0.14; duration: 7000 }
            }
        }

        Rectangle {
            id: auroraTwo
            width: parent.width * 0.62
            height: parent.height * 0.32
            x: parent.width * 0.42
            y: parent.height * 0.08
            radius: height / 2
            rotation: 8
            color: "#28506a86"

            SequentialAnimation on x {
                loops: Animation.Infinite
                NumberAnimation {
                    to: root.width * 0.30
                    duration: 18000
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    to: root.width * 0.42
                    duration: 18000
                    easing.type: Easing.InOutSine
                }
            }

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation { to: 0.28; duration: 9000 }
                NumberAnimation { to: 0.10; duration: 9000 }
            }
        }
    }

    // Sparse star field.
    Repeater {
        model: 34

        Rectangle {
            required property int index

            width: index % 7 === 0 ? 3 : 2
            height: width
            radius: width / 2

            x: ((index * 347) % 3700) / 3840 * root.width
            y: ((index * 191) % 820) / 2160 * root.height

            color: "white"
            opacity: root.liveMode ? 0.35 : 0.28

            SequentialAnimation on opacity {
                running: root.liveMode
                loops: Animation.Infinite

                NumberAnimation {
                    to: 0.85
                    duration: 1600 + (index % 5) * 430
                }

                NumberAnimation {
                    to: 0.18
                    duration: 1800 + (index % 4) * 510
                }
            }
        }
    }

    // Occasional shooting star.
    Rectangle {
        id: shootingStar

        visible: root.liveMode
        width: 130
        height: 2
        radius: 1
        color: "#d8ffffff"
        opacity: 0
        rotation: -28
        x: root.width * 0.76
        y: root.height * 0.16

        SequentialAnimation {
            running: root.liveMode
            loops: Animation.Infinite

            PauseAnimation { duration: 11500 }

            ParallelAnimation {
                NumberAnimation {
                    target: shootingStar
                    property: "x"
                    from: root.width * 0.78
                    to: root.width * 0.60
                    duration: 950
                    easing.type: Easing.OutQuad
                }

                NumberAnimation {
                    target: shootingStar
                    property: "y"
                    from: root.height * 0.12
                    to: root.height * 0.24
                    duration: 950
                    easing.type: Easing.OutQuad
                }

                SequentialAnimation {
                    NumberAnimation {
                        target: shootingStar
                        property: "opacity"
                        from: 0
                        to: 0.85
                        duration: 180
                    }

                    NumberAnimation {
                        target: shootingStar
                        property: "opacity"
                        to: 0
                        duration: 770
                    }
                }
            }

            PauseAnimation { duration: 17000 }
        }
    }

    // Slow lake mist.
    Rectangle {
        id: mist
        visible: root.liveMode

        width: root.width * 1.22
        height: root.height * 0.13
        x: -root.width * 0.10
        y: root.height * 0.67

        radius: height / 2
        color: "#14d9e5e8"
        opacity: 0.20

        SequentialAnimation on x {
            loops: Animation.Infinite

            NumberAnimation {
                to: -root.width * 0.02
                duration: 18000
                easing.type: Easing.InOutSine
            }

            NumberAnimation {
                to: -root.width * 0.10
                duration: 18000
                easing.type: Easing.InOutSine
            }
        }
    }

    // Very subtle lake reflection movement.
    Rectangle {
        id: reflection
        visible: root.liveMode

        width: root.width * 0.42
        height: 2
        x: root.width * 0.29
        y: root.height * 0.76

        radius: 1
        color: "#30ffffff"

        SequentialAnimation on width {
            loops: Animation.Infinite

            NumberAnimation {
                to: root.width * 0.50
                duration: 6000
                easing.type: Easing.InOutSine
            }

            NumberAnimation {
                to: root.width * 0.42
                duration: 6000
                easing.type: Easing.InOutSine
            }
        }
    }

    // HyprX identity and login controls.
    Column {
        id: loginPanel

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: root.height * 0.07

        width: Math.min(root.width * 0.30, 560)
        spacing: 16

        Text {
            anchors.horizontalCenter: parent.horizontalCenter

            text: "HYPRX"
            color: "#f5f7fa"
            font.pixelSize: 48
            font.weight: Font.DemiBold
            font.letterSpacing: 8
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter

            text: "ONE ISLAND. EVERYTHING YOU NEED."
            color: "#aab0ba"
            font.pixelSize: 11
            font.letterSpacing: 2.4
        }

        Item {
            width: 1
            height: 18
        }

        Rectangle {
            width: parent.width
            height: 52
            radius: 16

            color: "#c20b0d11"
            border.color: user.activeFocus ? "#687989" : "#343940"
            border.width: 1

            TextInput {
                id: user

                anchors.fill: parent
                anchors.leftMargin: 18
                anchors.rightMargin: 18

                color: "#f5f7fa"
                selectionColor: "#657786"
                selectedTextColor: "white"

                font.pixelSize: 14
                verticalAlignment: TextInput.AlignVCenter
                text: userModel.lastUser
                selectByMouse: true

                Keys.onTabPressed: password.forceActiveFocus()
            }
        }

        Rectangle {
            width: parent.width
            height: 52
            radius: 16

            color: "#c20b0d11"
            border.color: password.activeFocus ? "#687989" : "#343940"
            border.width: 1

            TextInput {
                id: password

                anchors.fill: parent
                anchors.leftMargin: 18
                anchors.rightMargin: 18

                color: "#f5f7fa"
                selectionColor: "#657786"
                selectedTextColor: "white"

                font.pixelSize: 14
                verticalAlignment: TextInput.AlignVCenter
                echoMode: TextInput.Password
                focus: true

                onAccepted: {
                    sddm.login(user.text, password.text, session.index)
                }
            }
        }

        Row {
            width: parent.width
            spacing: 12

            ComboBox {
                id: session

                width: parent.width - loginButton.width - parent.spacing
                height: 46

                model: sessionModel
                textRole: "name"
                currentIndex: sessionModel.lastIndex
            }

            Button {
                id: loginButton

                width: 128
                height: 46
                text: "Log in"

                onClicked: {
                    sddm.login(user.text, password.text, session.index)
                }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter

            text: "More than a desktop. A state of flow."
            color: "#9097a0"
            font.pixelSize: 11
        }
    }

    Row {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 28

        spacing: 10

        Button {
            text: "Restart"
            onClicked: sddm.reboot()
        }

        Button {
            text: "Shut down"
            onClicked: sddm.powerOff()
        }
    }

    Text {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 30

        text: root.liveMode ? "LIVE" : "STILL"
        color: "#809099a3"
        font.pixelSize: 10
        font.letterSpacing: 2
    }
}
