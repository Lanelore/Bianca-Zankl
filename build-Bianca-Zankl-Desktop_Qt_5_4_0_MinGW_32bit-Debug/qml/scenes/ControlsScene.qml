import VPlay 2.0
import QtQuick 2.0
import "../common"
import ".."

SceneBase {
    id:controlsScene

    // background
    Image {
        anchors.fill: parent
        source: "../../assets/img/BG.png"
    }

    // back button to leave scene
    MenuButton {
        text: "Back"
        // anchor the button to the gameWindowAnchorItem to be on the edge of the screen on any device
        anchors.right: controlsScene.right
        anchors.rightMargin: 10
        anchors.top: controlsScene.top
        anchors.topMargin: 10
        onClicked: backButtonPressed()
    }

    // menu
    Column {
        anchors.centerIn: parent
        spacing: 10

        // controls / settings
        Text {
            font.pixelSize: 20
            text: "Settings"
            color: "black"
        }

        MenuButton {
            width: 150
            text: GameInfo.visibleControls ? "Controls visible" : "Controls invisible"
            textColor: GameInfo.visibleControls ? "green" : "black"
            opacity: 1
            onClicked: {
                GameInfo.visibleControls ^= true
            }
        }

        MenuButton {
            width: 150
            text: settings.musicEnabled ? "Music enabled" : "Music disabled"
            textColor: settings.musicEnabled ? "green" : "black"
            opacity: 1
            onClicked:  {
                settings.musicEnabled ^= true
            }
        }

        MenuButton {
            width: 150
            text: settings.soundEnabled ? "Sound enabled" : "Sound disabled"
            textColor: settings.soundEnabled ? "green" : "black"
            opacity: 1
            onClicked: {
                settings.soundEnabled ^= true
            }
        }
    }
}
