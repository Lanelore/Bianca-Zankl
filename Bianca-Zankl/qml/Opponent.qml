import QtQuick 2.0
import VPlay 2.0
import "levels"
import ".."
import "../qml"


EntityBase {
    id: opponent
    entityId: "opponent"
    entityType: "opponent"

    property var opponent: opponent

    property alias opponentBody: opponentBody
    property alias opponentCollider: opponentCollider
    property alias opponentCoreCollider: opponentCoreCollider
    property int core: 5
    property double size: 25
    property double mass
    property int speed
    property int sceneWidth
    property int sceneHeight

    onEntityCreated: {
        mass = size * GameInfo.massValue
    }

    AnimatedImage {
        width: size
        height: size
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
        radius: size/2
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
        minPropertyValue: -size/2
        velocity: speed
        running: false
        onLimitReached: {
            opponent.destroy()
        }
    }
}
