import VPlay 2.0
import QtQuick 2.0
import "../common"

SceneBase {
    id: menuScene

    // signal indicating that the selectLevelScene should be displayed
    signal startGamePressed
    // signal indicating that the controlsScene should be displayed
    signal controlsPressed

    // background
    Image {
        anchors.fill: parent
        source: "../../assets/img/BG.png"
    }

    // the "logo"
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 30
        font.pixelSize: 30
        color: "#e9e9e9"
        text: "Bacilla"
    }

    // menu
    Column {
        anchors.centerIn: parent
        spacing: 10
        MenuButton {
            text: "Play"
            onClicked: startGamePressed()
        }
        MenuButton {
            text: "Controls"
            onClicked: controlsPressed()
        }
    }
}
