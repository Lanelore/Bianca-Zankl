import QtQuick 2.0
import VPlay 2.0

EntityBase {
    id: borderID
    entityId: "border"
    entityType: "border"
    z: 10

    // the border is a black rectangle made to cover the areas outside of the gameScene window
    // they cover the opponents and reposition the player
    Rectangle {
        anchors.fill: parent
        color: "black"
        visible: true
    }

    BoxCollider {
        anchors.fill: parent
        collisionTestingOnlyMode: true
        bodyType: Body.Static

        fixture.onContactChanged: {
            // handle the collision
            var collidedEntity = other.parent.parent.parent;
            var collidedEntityId = collidedEntity.entityId;

            // check if it hit the player and update the position
            if (collidedEntityId.substring(0, 6) === "player") {
                collidedEntity.updatePosition();
            }

        }
    }
}
