import QtQuick 2.0
import VPlay 2.0
import ".."

EntityBase {
    id: opponent
    entityType: "opponent"

    // access the image and both colliders from outside of this class
    property alias opponentBody: opponentBody
    property alias opponentCollider: opponentCollider
    property alias opponentCoreCollider: opponentCoreCollider

    // the opponentSpawn creates opponents with a specific position, movement direction,
    // mass, rotation and speed
    property int core: 5
    property double mass: 10
    property int speed
    property int sceneWidth
    property int sceneHeight
    property string direction
    property int opponentId: 0

    // keep track of the current amount of opponents on the scene
    onEntityCreated: {
        GameInfo.opponentId +=1;
        opponentId = GameInfo.opponentId;
        GameInfo.opponentCount += 1;
    }
    onEntityDestroyed: GameInfo.opponentCount -= 1

    // the size of the player depends on the mass
    AnimatedImage {
        width: mass
        height: mass
        id: opponentBody
        anchors.centerIn: parent
        playing: true
        source: "../../assets/img/Opponent.gif"
    }

    // the main collider to detect collisions
    // the collider is always the size of the image or mass
    CircleCollider {
        sensor: true
        id: opponentCollider
        radius: mass/2
        x: radius
        y: radius
        anchors.centerIn: parent
    }

    // this collider is the core or heart of the character and is a small circle in the center of the body
    // this is used to determine whether half of the body is covered or not
    CircleCollider {
        collisionTestingOnlyMode: true
        id: opponentCoreCollider
        radius: core/2
        x: radius
        y: radius
        anchors.centerIn: parent

        fixture.onBeginContact: {
            var collidedEntity = other.parent.parent.parent;
            var collidedEntityId = collidedEntity.entityId;

            // check if it hit a player and signal a contact
            if (collidedEntityId.substring(0, 6) === "player") {
                collidedEntity.onContact(opponent);
            }
        }
    }

    // moves from the right side of the scene to the left and gets destroyed
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

    // moves from the left side of the scene to the right and gets destroyed
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

    // moves from the bottom of the scene to the top and gets destroyed
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

    // moves from the right top of the scene to the bottom and gets destroyed
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

    // destroys the opponent entitiy
    function die() {
        opponent.destroy()
    }
}
