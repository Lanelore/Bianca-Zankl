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
    signal contact()

    property alias opponentBody: opponentBody
    property alias opponentCollider: opponentCollider
    property alias opponentCoreCollider: opponentCoreCollider
    property int core: 5
    property int size: 25
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
        /*
             // handle the collision
             fixture.onBeginContact: {

                 var fixture = other;
                 var body = other.parent;
                 var component = other.parent.parent;

                 var otherEntity = component.parent;
                 var otherEntityId = component.parent.entityId;
                 var otherEntityParent = otherEntity.parent;

                 // destroy the bullet if it collided with anything but lake or powerup
                 if (otherEntityId.substring(0, 3) !== "lak" && otherEntityId.substring(0, 3) !== "pow") {
                     singleBullet.destroy();

                     entityManager.createEntityFromUrlWithProperties(
                                 Qt.resolvedUrl("Splat.qml"), {
                                     "z": 1,
                                     "x": singleBullet.x,
                                     "y": singleBullet.y,
                                     "rotation": singleBullet.rotation
                                 }
                                 );

                     // check if it hit a player
                     if (otherEntityId.substring(0, 4) === "tank") {
                         //if (otherEntityParent.entityId.substring(0, 6) === "player") {

                         // call damage method on playerred/playerblue
                         otherEntityParent.onDamageWithBulletType(bulletType);
                     }
                 }
             }
             */
    }

    function onContact() {
        //check mass and so on
    }

    MovementAnimation {
        id: leftMovement
        target: opponent
        property: "x"
        minPropertyValue: -size/2
        velocity: speed
        running: true
        onLimitReached: {
            opponent.destroy()
        }
    }
}
