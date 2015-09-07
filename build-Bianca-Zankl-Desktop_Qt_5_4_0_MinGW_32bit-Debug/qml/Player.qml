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
        id: playerBody
        width: 40
        height: 40
        anchors.centerIn: parent
        playing: true
        source: "../assets/img/player.gif"
    }

    CircleCollider {
        //collisionTestingOnlyMode: true
        id: playerCollider
        radius: 22
        x: radius
        y: radius
        anchors.centerIn: parent
        density: GameInfo.gamePaused ? 1000000 : 0
        friction: GameInfo.gamePaused ? 0 : 0.4
        restitution: GameInfo.gamePaused ? 0 : 0.4
        bullet: true
        linearDamping: GameInfo.gamePaused ? 1000000 : 100
        //angularDamping: 0

        // this is applied every physics update tick
        linearVelocity: Qt.point(twoAxisController.xAxis * 100, twoAxisController.yAxis * (-100))
        //force: Qt.point(twoAxisController.xAxis * 1000, twoAxisController.yAxis * 1000)
        //torque: 1000
    }

    function onContact() {
        //check mass and so on
    }
}
