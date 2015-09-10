import VPlay 2.0
import QtQuick 2.0
import "scenes"
import "common"

GameWindow {
    id: window
    width: 1024
    height: 768

    // you get free licenseKeys as a V-Play customer or in your V-Play Trial
    // with a licenseKey, you get the best development experience:
    //  * No watermark shown
    //  * No license reminder every couple of minutes
    //  * No fading V-Play logo
    // you can generate one from http://v-play.net/license/trial, then enter it below:
    // licenseKey: "2E811F9902367394DB130E686E978AE195399F9926EADA78CC8B31D2FAB2ACECE0626032BE6B54F53156DF8BDD48DE2F45359A6AA3062DF52AF0F2C7DE44AEEDD898B07E8A123B3D3F15B45541267DEACACE41346E266554470BD5CE87A9BC668F2E54B9ACA9AC7C6DF8DB0436CC446EAAB927B6559DC40D6F4FC9935A5A4FF3A805D74FBF24AC0B91D4DF63861246997845C461D25A342454D8025285FBFD86D013E889CFC47411AF3ABE20C485B50249C94A67136A29E2497FF4967535299B05AE2721B6832C74A0D8BDC68C078749262CAB9A72FE40F3F765459D2D3B0ABE489379BC7E0BCC54487654CAF1D6DFC3EE30CC6ECFDEC150434153611FF876B1333F4589EE5790274F063F0CABA47EBCA86E181313631EECD901E25B9CDB0E6CA795DAB0539197B7CBA076F337E55BBB"

    // create and remove entities at runtime in the gameScene
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
            gameScene.countdown = 3;    // starts the main countdown, the game unpauses after reaching 0
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

    // game over scene after dying in the game
    GameOverScene {
        id: gameOverScene
        onBackButtonPressed: window.state = "menu"
    }

    // controls scene with settings
    ControlsScene {
        id: controlsScene
        onBackButtonPressed: window.state = "menu"
    }

    // game scene to play a level
    GameScene {
        id: gameScene
        onGameOver: window.state = "gameOver"
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
