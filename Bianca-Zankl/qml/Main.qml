import VPlay 2.0
import QtQuick 2.0
import "scenes"
import "common"

GameWindow {
    id: window
    width: 1024
    height: 768

    onActiveChanged: {
        settings.setValue("soundEnabled", true)
        settings.soundEnabled= true
        settings.musicEnabled = true
    }

    // you get free licenseKeys as a V-Play customer or in your V-Play Trial
    // with a licenseKey, you get the best development experience:
    //  * No watermark shown
    //  * No license reminder every couple of minutes
    //  * No fading V-Play logo
    // you can generate one from http://v-play.net/license/trial, then enter it below:
    // licenseKey: "A4E2F0BA4B13D37151FE743AEEBDD97981CD2F654D2A3D6F2DB9511330E3D823E4B0005071F07D3C808ED2294CC13FFF7E412EE149EAAE44FB90CFBFB068B393014AC35CD5D1FF76AF41F3DE9F2B02A6CC290852DFA944D833F975989D3982B3C6DFB2E52E75991BF623AC4D9C0FF374FB7783A8010F76A81F4A7D20FD9DCF24B1D2EEF4082D9B5AE6C2C47D66436E053FD490F68D206A5A033730C185F2614E54E2FBA7E0442B1E6D8E3D7C771D10CDE2DD2B37BC63DCB49E6554105D6654FD2E0D449F2ABA20B96B445D007E4236786E9771DE292E2FDEAB349DBD3C20B8131F3C9E97E23663A4D3A860E48B8955A984EBA63C55CFFF46476ADDB28F8E01CF5068159FAA2144E3F90DEFAD30972CF75E59D4D66411313509775AED321AF9E268393DD4B978225D373646FBAA60A81A"

    // create and remove entities at runtime
    EntityManager {
        id: entityManager
        entityContainer: gameScene
    }

    // menu scene
    MenuScene {
        id: menuScene
        // listen to the button signals of the scene and change the state according to it
        onStartGamePressed: {
            window.state = "game";
            gameScene.countdown = 3;
        }
        onControlsPressed: window.state = "controls"
        // the menu scene is our start scene, so if back is pressed there we ask the user if he wants to quit the application
        onBackButtonPressed: {
            nativeUtils.displayMessageBox(qsTr("Really quit the game?"), "", 2);
        }
        // listen to the return value of the MessageBox
        Connections {
            target: nativeUtils
            onMessageBoxFinished: {
                if(accepted)
                    Qt.quit()
            }
        }
    }

    GameOverScene {
        id: gameOverScene
        onBackButtonPressed: window.state = "menu"
    }

    // controls scene
    ControlsScene {
        id: controlsScene
        onBackButtonPressed: window.state = "menu"
    }

    // game scene to play a level
    GameScene {
        id: gameScene
        onGameOver: {
            window.state = "gameOver"
        }
        onBackButtonPressed: window.state = "menu"
    }

    // menuScene is our first scene, so set the state to menu initially
    state: "menu"
    activeScene: menuScene

    // state machine, takes care reversing the PropertyChanges when changing the state, like changing the opacity back to 0
    states: [
        State {
            name: "menu"
            PropertyChanges {target: menuScene; opacity: 1}
            PropertyChanges {target: window; activeScene: menuScene}
        }, 
        State {
            name: "gameOver"
            PropertyChanges {target: gameOverScene; opacity: 1}
            PropertyChanges {target: window; activeScene: gameOverScene}
        },
        State {
            name: "controls"
            PropertyChanges {target: controlsScene; opacity: 1}
            PropertyChanges {target: window; activeScene: controlsScene}
        },
        State {
            name: "game"
            PropertyChanges {target: gameScene; opacity: 1}
            PropertyChanges {target: window; activeScene: gameScene}
        }
    ]
}
