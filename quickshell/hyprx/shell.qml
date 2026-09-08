import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import QtQuick.Controls
import Quickshell.Services.Notifications

ShellRoot {
    id: root
    
    property var latestNotification: null
    property var notifications: []
    property bool notificationPopupVisible: false

    NotificationServer {
	id: notificationServer

	keepOnReload: true

	onNotification: notification => {
		notification.tracked = true
		root.latestNotification = notification
		root.notifications = [notification].concat(root.notifications)
		root.notificationPopupVisible = true	
		notificationTimer.restart()
	}

     }

     Timer {
	 id: notificationTimer
	 interval: 5000
	 repeat: false

	 onTriggered: {
	     root.notificationPopupVisible = false

	 }
     }


     FloatingWindow {
	 id: notificationPopup
     	 visible: root.notificationPopupVisible && root.latestNotification !== null
	 width: 380
	 height: 120
	 color: "transparent"

	 Rectangle {
	     anchors.fill: parent
    	     radius: 18
	     color: "#ee0b0b0d"
	     border.color: "#28282c"

	     ColumnLayout {
		 anchors.fill: parent
    		 anchors.margins: 16
		 spacing: 6

		 Text {
		     text: root.latestNotification ? root.latestNotification.appName : ""
    		     color: "#909095"
		     font.family: "Inter Variable"
		     font.pixelSize: 12
		 }		     
		
                 Text {
		     text: root.latestNotification ? root.latestNotification.summary : ""
		     color: "#eeeeee"
		     font.family: "Inter Variable"
		     font.pixelSize: 16
		     font.bold: true
		     Layout.fillWidth: true
		     elide: Text.ElideRight
		 }

		 Text {
		     text: root.latestNotification ? root.latestNotification.body : ""
		     color: "#eeeeee"
		     font.family: "Inter Variable"
		     font.pixelSize: 13
		     Layout.fillWidth: true
		     wrapMode: Text.WordWrap
	         } 
	      }
           }
        }   

     property string mode: "launcher"
     property bool shown: false
     
     function toggleMode(nextMode) {
        if (root.shown && root.mode === nextMode) {
	    root.shown = false
    	} else {
    	    root.mode = nextMode
	    root.shown = true
        }	    
    }	
    
    IpcHandler {
	target: "hyprx"

        function launcher(): void { root.toggleMode("launcher") }
        function control(): void { root.toggleMode("control") }
        function files(): void { root.toggleMode("files") }
        function clipboard(): void { root.toggleMode("clipboard") }
        function wallpaper(): void { root.toggleMode("wallpaper") }
     function  notifications(): void { root.toggleMode("notifications") }
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
     visible:  root.mode  !== "Control" &&  root.mode !== "notifications";
				    Layout.fillWidth: true
     placeholderText: root.mode === "Wallpaper" ? "Wallpaper path  or  search..." : "Search..."
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
		ColumnLayout {
		    visible: root.mode === "notifications"
      Layout.fillWidth: true
		    spacing: 8
		    Text {
		    text: "Clear all"
		    color: "#909095"
		    font.family: "Inter Variable"
		    MouseArea {
			    anchors.fill: parent
			    onClicked: {
				    for (let i = notificationServer.trackedNotifications.values.length - 1; i >= 0; --i) {
					    notificationServer.trackedNotifications.values[i].dismiss()
				    }
			    }
		    }
	    }


		    Repeater {
			model: notificationServer.trackedNotifications

      delegate: Rectangle {
			    required property var modelData


      Layout.fillWidth: true
			    height: 72
			    radius: 12
      color: "#151517"
      border.color: "#28282c"


      MouseArea {
	     anchors.fill: parent
	     onClicked: modelData.dismiss()

      }	     
     
     
      Column {
	   anchors.fill: parent
	   anchors.margins: 10
	   spacing: 4

      Text {
	  text: modelData.summary
	  color: "#eeeeee"
	  font.family: "Inter Variable"
	  font.bold: true 
	}
			    
      Text {	
          text: modelData.body
	  color: "#909095"
	  font.family: "Inter Variable"
	  elide: Text.ElideRight
	  width: parent.width 
        }
      } 
    } 
  } 
}

				
						
                Text { visible: root.mode === "wallpaper"; text: "Paste an image path and press Enter, or Super+Shift+W for random."; wrapMode: Text.WordWrap; Layout.fillWidth: true; color: "#909095"; font.family: "Inter Variable" }
                Item { Layout.fillHeight: true }
            }
        }
    }
    Process { id: run }
}
