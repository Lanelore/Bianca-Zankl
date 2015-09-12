import VPlay 2.0
import QtQuick 2.0
import "../common"
import "../components"
import ".."

SceneBase {
    id:gameScene

    // countdown shown at level start
    property int countdown: 0
    // access the player from outside this class
    property var player: gameController.player
    // switch to the gameOverScene with the help of the state machine in the Main
    signal gameOver
    // reset the game scene with the help of the gameController reset function
    function reset(){
        gameController.reset()
    }

    // physics world for collision detection
    PhysicsWorld {
        id: world
        debugDrawVisible: false
        updatesPerSecondForPhysics: 10
    }

    // background
    Image {
        anchors.fill: parent
        source: "../../assets/img/BG.png"
    }

    // back button to leave scene
    MenuButton {
        z: 3
        text: "Back"
        // anchor the button to the gameWindowAnchorItem to be on the top right of the scene
        anchors.right: gameScene.right
        anchors.rightMargin: 10
        anchors.top: gameScene.top
        anchors.topMargin: 10
        onClicked: {
            reset()
            backButtonPressed()
            countdown = 0;
        }
    }

    // text displaying either the countdown or ""
    Text {
        anchors.centerIn: parent
        color: "#69c64c"
        font.pixelSize: countdown > 0 ? 160 : 0
        text: countdown > 0 ? countdown : ""
        z: 3
    }

    // text displaying the current score
    Text {
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        color: "#69c64c"
        font.pixelSize: 20
        text: Math.round((player.mass - player.resetMass + player.bonus) * 10)
        z: 3
        font.bold: true
    }

    // if the countdown is greater than 0, this timer is triggered every second, decreasing the countdown (until it hits 0 again)
    Timer {
        repeat: true
        running: countdown > 0 ? true : false
        onTriggered: {
            countdown--
            if(countdown==0) GameInfo.gamePaused = false
        }
    }

    // place the 4 Borders around the main playing field
    Border {
        id: borderLeft
        width: 100
        anchors {
            right: parent.left
            top: parent.top
            bottom: parent.bottom
        }
    }

    Border {
        id: borderRight
        width: 100
        anchors {
            left: parent.right
            bottom: parent.bottom
            top: parent.top
        }
    }

    Border {
        id: borderTop
        height: 100
        anchors {
            left: parent.left
            right: parent.right
            bottom:parent.top
        }
    }

    Border {
        id: borderBottom
        height: 100
        width: parent.width
        x: 0
        y: parent.height
    }

    // creates the gameController and the player in the gameScene
    GameController {
        id: gameController
        width: gameScene.width
        height: gameScene.height
        x: 0
        y: 0
        z: 2
    }

    // creates an opponent which spawns random opponents
    OpponentSpawn {
        id: opponentSpawn
        x: 0
        y: 0
        sceneWidth: parent.width
        sceneHeight: parent.height
    }
}
