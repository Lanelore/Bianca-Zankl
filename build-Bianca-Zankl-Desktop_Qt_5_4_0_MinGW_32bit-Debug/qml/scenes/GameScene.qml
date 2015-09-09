import VPlay 2.0
import QtQuick 2.0
import "../common"
import "../components"
import ".."

SceneBase {
    id:gameScene
    // score
    property int score: 0
    // countdown shown at level start
    property int countdown: 0
    // flag indicating if game is running
    property bool gameRunning: countdown == 0
    property var player: gameController.player

    signal gameOver

    function reset(){
        gameController.reset()
    }

    // physics world for collision detection
    PhysicsWorld {
        id: world
        debugDrawVisible: false
        updatesPerSecondForPhysics: 10
        //z: 1110
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
        // anchor the button to the gameWindowAnchorItem to be on the edge of the screen on any device
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
        font.pixelSize: countdown > 0 ? 160 : 18
        text: countdown > 0 ? countdown : ""
        z: 3
        onEnabledChanged: {
            //GameInfo.gamePaused = true;
            //countdown = 3
        }
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

    // place the 4 Borders around the playing field
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

    GameController {
        id: gameController
        width: gameScene.width
        height: gameScene.height
        x: 0
        y: 0
        z: 2
    }

    OpponentSpawn {
        id: opponentSpawn
        x: 0
        y: 0
        sceneWidth: parent.width
        sceneHeight: parent.height
    }
}
