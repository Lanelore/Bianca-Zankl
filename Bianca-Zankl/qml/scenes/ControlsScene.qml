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
            color: "#69c64c"
        }

        MenuButton {
            width: 150
            text: GameInfo.visibleControls ? "Controls visible" : "Controls invisible"
            textColor: GameInfo.visibleControls ? "#69c64c" : "#a7ff5f"
            color: GameInfo.visibleControls ? "#a7ff5f" : "#69c64c"
            onClicked: {
                GameInfo.visibleControls ^= true
            }
        }

        MenuButton {
            width: 150
            text: settings.musicEnabled ? "Music enabled" : "Music disabled"
            textColor: settings.musicEnabled ? "#69c64c" : "#a7ff5f"
            color: settings.musicEnabled ? "#a7ff5f" : "#69c64c"
            onClicked:  {
                settings.musicEnabled ^= true
            }
        }

        MenuButton {
            width: 150
            text: settings.soundEnabled ? "Sound enabled" : "Sound disabled"
            textColor: settings.soundEnabled ? "#69c64c" : "#a7ff5f"
            color: settings.soundEnabled ? "#a7ff5f" : "#69c64c"
            onClicked: {
                settings.soundEnabled ^= true
            }
        }
    }

    // controls / settings
    Text {
        font.pixelSize: 6
        text: "Bianca Zankl\nhttp://www.freesfx.co.uk/\nhttps://www.youtube.com/watch?v=E49uHVCLY0Q"
        color: "#69c64c"
        anchors.left: controlsScene.left
        anchors.leftMargin: 10
        anchors.bottom: controlsScene.bottom
        anchors.bottomMargin: 10
    }
}
