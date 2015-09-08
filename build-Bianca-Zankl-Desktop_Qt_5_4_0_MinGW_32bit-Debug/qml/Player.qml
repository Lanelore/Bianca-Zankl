import QtQuick 2.0
import VPlay 2.0
import "."

EntityBase {
    id: player
    entityId: "player"
    entityType: "player"

    property var player: player
    signal contact(var other)

    // make the twoAxisController acessible from outside
    property alias controller: twoAxisController
    property alias playerBody: playerBody
    property alias playerCollider: playerCollider
    property alias playerCoreCollider: playerCoreCollider
    property double size: 20
    property int core: 5
    property double mass: 10

    onMassChanged: {
        size = mass / GameInfo.massValue

        if (mass > 100){
            GameInfo.victory = true
            endGame()
        }
    }

    onEnabledChanged: {
        mass = size * GameInfo.massValue
        player.visible = true
    }

    TwoAxisController {
        id: twoAxisController
    }

    AnimatedImage {
        width: size
        height: size
        id: playerBody
        anchors.centerIn: parent
        playing: false
        source: "../assets/img/Player.gif"
    }

    CircleCollider {
        //collisionTestingOnlyMode: true
        sensor: true
        id: playerCollider
        radius: size/2
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

        onBodyTypeChanged: {
            playerCollider.bodyType = Body.Dynamic;
        }
    }

    CircleCollider {
        collisionTestingOnlyMode: true
        id: playerCoreCollider
        radius: core/2
        x: radius
        y: radius
        anchors.centerIn: parent

        fixture.onBeginContact: {
            // handle the collision and make the image semi-transparent

            var collidedEntity = other.parent.parent.parent;
            var collidedEntityId = collidedEntity.entityId;

            // check if it hit a player
            if (collidedEntityId.substring(0, 8) === "opponent") {
                // call damage method on playerred/playerblue
                onContact(collidedEntity);
            }
        }
    }

    function onContact(other) {
        //check mass and so on

        if(player.mass > other.mass){
            player.mass += other.mass/10;
            console.debug("Delete: " + other.entityId)
            other.die();
        }else{
            console.debug("end Game")
            endGame();
        }
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

    function endGame(){
        GameInfo.gamePaused = true;
        player.visible = false;
        GameInfo.score = mass;
        endGameTimer.start();
    }

    Timer {
        id: endGameTimer
        interval: 1200
        running: false
        repeat: false
        onTriggered: {
            gameOver()
        }
    }
}
