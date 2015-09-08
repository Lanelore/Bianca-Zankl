import VPlay 2.0
import QtQuick 2.0
import "../common"

SceneBase {
    id: gameOverScene

    // background
    Image {
        anchors.fill: parent
        source: "../../assets/img/BG.png"
    }

    // back button to leave scene
    MenuButton {
        text: "Back"
        // anchor the button to the gameWindowAnchorItem to be on the edge of the screen on any device
        anchors.right: gameOverScene.right
        anchors.rightMargin: 10
        anchors.top: gameOverScene.top
        anchors.topMargin: 10
        onClicked: {
            gameScene.reset()
            backButtonPressed()
        }
    }

    Text {
        font.pixelSize: 20
        text: "Game Over"
        color: "black"
        anchors.centerIn: parent
    }
}

