import QtQuick 2.0
import VPlay 2.0

EntityBase {
    id: borderID
    entityId: "border"
    entityType: "border"
    z: 10

    Rectangle {
        anchors.fill: parent
        color: "black"
        visible: true // set to 'true' for debugging
    }

    BoxCollider {
        anchors.fill: parent
        collisionTestingOnlyMode: true
        bodyType: Body.Static

        fixture.onContactChanged: {
            // handle the collision and make the image semi-transparent
            var collidedEntity = other.parent.parent.parent;
            var collidedEntityId = collidedEntity.entityId;




            // check if it hit a player
            if (collidedEntityId.substring(0, 6) === "player") {
            console.debug ("Collided with Entitiy: " + collidedEntityId);
                collidedEntity.updatePosition();
            }

        }
    }


}
