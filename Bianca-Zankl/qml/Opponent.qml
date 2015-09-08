import QtQuick 2.0
import VPlay 2.0
import "."
import "../qml"

EntityBase {
    id: opponent
    entityType: "opponent"

    //property var opponent: opponent

    property alias opponentBody: opponentBody
    property alias opponentCollider: opponentCollider
    property alias opponentCoreCollider: opponentCoreCollider
    property int core: 5
    property double mass: 10
    property int speed
    property int sceneWidth
    property int sceneHeight
    property string direction

    onEntityCreated: {
        GameInfo.opponentCount += 1
        console.debug(GameInfo.opponentCount)
    }
    onEntityDestroyed: GameInfo.opponentCount -= 1

    AnimatedImage {
        width: mass
        height: mass
        id: opponentBody
        anchors.centerIn: parent
        playing: true
        source: "../assets/img/Opponent.gif"
    }

    x: start.x
    y: start.y

    CircleCollider {
        //collisionTestingOnlyMode: true
        sensor: true
        id: opponentCollider
        radius: mass/2
        x: radius
        y: radius
        anchors.centerIn: parent
    }

    CircleCollider {
        collisionTestingOnlyMode: true
        id: opponentCoreCollider
        radius: core/2
        x: radius
        y: radius
        anchors.centerIn: parent

        fixture.onBeginContact: {
            // handle the collision and make the image semi-transparent

            var collidedEntity = other.parent.parent.parent;
            var collidedEntityId = collidedEntity.entityId;

            // check if it hit a player
            if (collidedEntityId.substring(0, 6) === "player") {
                // call damage method on playerred/playerblue
                collidedEntity.onContact(opponent);
            }
        }
    }

    function die() {
        opponent.destroy()
    }

    MovementAnimation {
        id: leftMovement
        target: opponent
        property: "x"
        minPropertyValue: -mass/2
        velocity: -speed
        running: (direction == "left") ? true : false
        onLimitReached: {
            opponent.destroy()
        }
    }

    MovementAnimation {
        id: rightMovement
        target: opponent
        property: "x"
        maxPropertyValue: sceneWidth + mass/2
        velocity: speed
        running: (direction == "right") ? true : false
        onLimitReached: {
            opponent.destroy()
        }
    }

    MovementAnimation {
        id: upMovement
        target: opponent
        property: "y"
        minPropertyValue: -mass/2
        velocity: -speed
        running: (direction == "up") ? true : false
        onLimitReached: {
            opponent.destroy()
        }
    }

    MovementAnimation {
        id: downMovement
        target: opponent
        property: "y"
        maxPropertyValue: sceneHeight + mass/2
        velocity: speed
        running: (direction == "down") ? true : false
        onLimitReached: {
            opponent.destroy()
        }
    }
}
