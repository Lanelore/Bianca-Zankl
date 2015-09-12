import QtQuick 2.0
import VPlay 2.0
import ".."

EntityBase {
    id: gameController
    entityId: "gameController"
    entityType: "gameController"
    z: 10

    // make the player and the field accessible from the outside
    property alias player: player
    property alias field: field

    // this field is the size of the screen
    // it contains the MultiPointTouchArea with the same dimensions,
    // the controlImage used to show and calculate the controls and the player
    Rectangle {
        id: field
        color: "transparent"
        width: parent.width
        height: parent.height
        x: parent.x
        y: parent.y

        // this image is used to calculate the player's movement and visualizes the controller
        Image {
            id: controlImage
            source: "../../assets/img/Control.png"
            opacity: GameInfo.visibleControls ? GameInfo.pacity : 0
            x: resetX
            y: resetY
            z: 2
            width: 70
            height: 70

            // the controller can be moved around freely and needs to be reset after leaving the scene
            property int resetX: 10
            property int resetY: 10
        }

        // add the calculated movement to the player
        Player{
            id: player
            z: 1
            x: parent.width/2
            y: parent.height/2
        }

        // the MultiPointTouchArea covers the whole screen and is disabled when the game is paused
        MultiPointTouchArea {
            enabled: GameInfo.gamePaused ? false : true
            anchors.fill: parent

            // the referencePoint is the center of the circular controller pad
            property int referencePointX: 0
            property int referencePointY: 0

            // after releasing the mouse or finger, a new reference point is needed
            property bool didRegisterReferencePoint: false

            // access the player's controller to add the calculated movement
            property variant playerTwoAxisController: player.getComponent("TwoAxisController")

            // newPos is a point calculated from the center of the pad
            // the values are converted and vary around 1 (= border of the circular pad)
            // it is used to calculate the player's velocity
            property real newPosX: 0.0
            property real newPosY: 0.0

            touchPoints: [
                TouchPoint {id: fieldPoint}
            ]

            onUpdated: {
                // if the player is being moved, play his animation and don't slow him down
                player.playerCollider.linearDamping = 0
                player.playerBody.playing = true

                // calculate the difference between the current field point and the reference point
                // add the radius and divide by the radius
                // the result is a value around 1.; if it's bigger, the point was outside of the circle
                // a smaller value means it was inside
                // these two values are used to calculate a distance to the center of the circle
                newPosX = ((fieldPoint.x - referencePointX + controlImage.width / 2) / (controlImage.width / 2) - 1)
                newPosY = ((fieldPoint.y - referencePointY + controlImage.height / 2) / (controlImage.height / 2) - 1)
                var distance = Math.sqrt((newPosX*newPosX) + (newPosY*newPosY))

                // if no reference point is loaded yet, get one
                if (didRegisterReferencePoint == false) {
                    // save new reference point
                    referencePointX = fieldPoint.x;
                    referencePointY = fieldPoint.y;

                    // note that there is a reference point
                    didRegisterReferencePoint = true;

                    // reposition the control image
                    updateControlImagePosition()
                    return;
                }

                // if the new point is outside of the movement circle
                if (distance > 1) {
                    // angle is used to find a reference point at the border of the circular pad
                    // calculate the angle between two points (zero and newPos) and convert it in degrees and the right coordinate system
                    var angle = (Math.atan2(newPosX, newPosY) * 180 / Math.PI) -180
                    angle = angle * (-1)
                    angle -= 90

                    // find a new reference point at the border of the circular pad
                    // start from the old referencePoint and pick a new point with radius distance in the right direction
                    var newX = (controlImage.width/2) * Math.cos((angle)*Math.PI/180) + referencePointX
                    var newY = (controlImage.height/2) * Math.sin((angle)*Math.PI/180) + referencePointY

                    // calculate the difference between the circle border reference point and the point outside of the pad
                    var diffX = fieldPoint.x - newX
                    var diffY = fieldPoint.y - newY

                    // calculate the new moved center of the cicular pad
                    // make sure the new reference point leaves enough space (radius) for the circular pad or image
                    // leave at least radius distance to each border
                    if((referencePointX + diffX) <= controlImage.width / 2){
                        referencePointX = controlImage.width / 2
                    }else if((referencePointX + diffX) >= (parent.width - controlImage.width / 2)){
                        referencePointX = parent.width - controlImage.width / 2
                    }else{
                        referencePointX += diffX
                    }
                    if((referencePointY + diffY) <= controlImage.height / 2){
                        referencePointY = controlImage.height / 2
                    }else if((referencePointY + diffY) >= (parent.height - controlImage.height/2)){
                        referencePointY = parent.height - controlImage.height/2
                    }else{
                        referencePointY += diffY
                    }
                }

                // reposition the control image according to the mouse or finger movement
                updateControlImagePosition()

                newPosY = newPosY * -1

                // clamp the values between -1 and 1
                if (newPosX > 1) newPosX = 1
                if (newPosY > 1) newPosY = 1
                if (newPosX < -1) newPosX = -1
                if (newPosY < -1) newPosY = -1

                // update the movement
                updateMovement()
            }

            function updateControlImagePosition() {
                // referencePoint is the center, subtract the radius to get the top left corner of the image
                var newX = referencePointX - controlImage.width / 2;
                var newY = referencePointY - controlImage.height / 2;

                // the value has to be positive to have the image inside of the field
                // the value has to be small enough to be inside of the field, leave at least the width of the image
                newX = Math.max(0, newX);
                newX = Math.min(parent.width - controlImage.width, newX);

                newY = Math.max(0, newY);
                newY = Math.min(parent.height - controlImage.height, newY);

                // assign the new position
                controlImage.x = newX;
                controlImage.y = newY;
            }

            // slows down the character after removing the finger from the tablet / releasing the mouse
            function damping(){
                player.playerCollider.linearDamping = GameInfo.damping;
            }

            // updates the speed and direction of the character
            function updateMovement(){
                // calculate the distance from the center ( = speed) with the pythagoras
                var velocity = Math.sqrt(newPosX * newPosX + newPosY * newPosY)
                var maxVelocity = GameInfo.maximumPlayerVelocity

                if (velocity > maxVelocity) {
                    // velocity is too high, shrink it down
                    // alter the points for the right velocity
                    var shrinkFactor = maxVelocity / velocity
                    newPosX = newPosX * shrinkFactor
                    newPosY = newPosY * shrinkFactor
                }

                // now update the twoAxisController with the calculated values
                // the twoAxisController moves the player with this input
                playerTwoAxisController.xAxis = newPosX
                playerTwoAxisController.yAxis = newPosY
            }

            // the user released the mouse or lifted the finger
            // the next input will be a new touch with a new referene point
            onReleased: {
                didRegisterReferencePoint = false

                // stop the player's animation
                player.playerBody.playing=false

                // slow down character till it stops
                damping()
            }
        }
    }

    // reset the gameController and the player after leaving with the back button
    function reset(){
        // remove all created opponents
        var toRemoveEntityTypes = ["opponent"];
        entityManager.removeEntitiesByFilter(toRemoveEntityTypes);

        // pause the game and delete the score
        GameInfo.gamePaused = true;
        GameInfo.score = 0;
        GameInfo.opponentId = 0;

        // reset the player's values and stop his movement
        player.bonus = 0;
        player.mass = player.resetMass;
        player.lastOpponentId = 0;
        player.x = parent.width/2;
        player.y = parent.height/2;
        player.playerCollider.bodyType = Body.Static;

        // reposition the control image
        controlImage.x = controlImage.resetX;
        controlImage.y = controlImage.resetY;
    }
}
