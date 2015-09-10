import VPlay 2.0
import QtQuick 2.0
import QtMultimedia 5.0
import "../common"
import ".."

SceneBase {
    id: menuScene

    // signal indicating that the gameScene should be displayed
    signal startGamePressed
    // signal indicating that the controlsScene should be displayed
    signal controlsPressed

    // music loops in every scene, can be muted in the controlsScene
    BackgroundMusic {
        loops: SoundEffect.Infinite
        volume: 0.5
        id: ambienceMusic
        // an ogg file is not playable on windows, because the extension is not supported!
        source: "../../assets/snd/Blue_Skies.wav"
    }

    // background
    Image {
        anchors.fill: parent
        source: "../../assets/img/Menu.png"
    }

    // main menu
    Column {
        anchors.centerIn: parent
        spacing: 10
        // the "logo"
        Text {
            font.pixelSize: 29
            color: "#69c64c"
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
