import QtQuick 2.0
import VPlay 2.0
import "."

EntityBase {
    id: player
    entityId: "player"
    entityType: "player"

    property var player: player
    signal contact()

    // make the twoAxisController acessible from outside
    property alias controller: twoAxisController
    property alias playerBody: playerBody
    property alias playerCollider: playerCollider

    TwoAxisController {
        id: twoAxisController
    }

    AnimatedImage {
        width: 25
        height: 25
        id: playerBody
        anchors.centerIn: parent
        playing: true
        source: "../assets/img/player.gif"
    }

    CircleCollider {
        //collisionTestingOnlyMode: true
        id: playerCollider
        radius: playerBody.width/2
        x: radius
        y: radius
        anchors.centerIn: parent
        density: GameInfo.gamePaused ? 1000000 : 0
        friction: GameInfo.gamePaused ? 0 : 0.4
        restitution: GameInfo.gamePaused ? 0 : 0.4
        bullet: true
        linearDamping: GameInfo.gamePaused ? 1000000 : 100

        // this is applied every physics update tick
        linearVelocity: Qt.point(twoAxisController.xAxis * 100, twoAxisController.yAxis * (-100))
    }

    function onContact() {
        //check mass and so on
    }

    function updatePosition() {
        if (player.x > field.width){
            player.x = 0
        }else if (player.x < 0){
            player.x = field.width
        }
        if(player.y > field.height){
            player.y = 0
        }else if (player.y < 0){
            player.y = field.height
        }
    }
}
