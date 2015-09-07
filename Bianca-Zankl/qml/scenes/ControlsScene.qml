import VPlay 2.0
import QtQuick 2.0
import "../common"

SceneBase {
    id:controlsScene

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

    // credits
    Text {
        text: "Controls"
        color: "white"
        anchors.centerIn: parent
    }
}

