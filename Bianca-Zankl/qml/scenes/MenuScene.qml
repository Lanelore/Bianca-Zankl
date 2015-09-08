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



    // menu
    Column {
        anchors.centerIn: parent
        spacing: 10

        // the "logo"
        Text {
            font.pixelSize: 29
            color: "black"
            text: "Bacillus"
        }
        MenuButton {
            width: 100
            text: "Play"
            onClicked: startGamePressed()
        }
        MenuButton {
            width: 100
            text: "Controls"
            onClicked: controlsPressed()
        }
    }
}
