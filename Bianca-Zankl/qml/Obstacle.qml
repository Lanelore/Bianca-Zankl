import QtQuick 2.0
import VPlay 2.0
import "."

EntityBase {
    id: obstacle
    entityType: "obstacle"
    entityId: "obstacle"

    property alias obstacleBody: obstacleBody
    property alias circleCollider: circleCollider

    Image {
        id: obstacleBody
        width: 50
        height: 50
        //rotation: 0
        anchors.centerIn: parent
        source: "../assets/img/Opponent.gif"
    }

    CircleCollider {
        id: circleCollider

        radius: obstacleBody.width/2
        x: radius
        y: radius

        // the image and the physics will use this size
        anchors.centerIn: parent

        //density: 100000000
        bodyType: Body.Static

        fixture.onBeginContact: {
            // handle the collision and make the image semi-transparent

            var collidedEntity = other.parent.parent.parent;
            var collidedEntityId = collidedEntity.entityId;

            // check if it hit a player
            if (collidedEntityId.substring(0, 6) === "player") {
                // call damage method on playerred/playerblue
                collidedEntity.onContact();
            }
        }
    }
}
