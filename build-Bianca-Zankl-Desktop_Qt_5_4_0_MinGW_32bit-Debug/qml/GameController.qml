import QtQuick 2.0
import VPlay 2.0
import "."

EntityBase {
    id: gameController
    entityId: "gameController"
    entityType: "gameController"
    property var gameController: gameController
    z: 10

    Rectangle {
        // Object properties
        id: field
        color: "transparent"
        width: parent.width
        height: parent.height
        x: parent.x
        y: parent.y

        property alias player: player
        property alias field: field

        Image {
            id: controlImage
            source: "../assets/img/Control.png"
            opacity: GameInfo.visibleControls ? GameInfo.pacity : 0
            x: resetX
            y: resetY
            z: 2
            width: 70
            height: 70
            property int resetX: 10
            property int resetY: 10
        }

        Player{
            id: player
            z: 1
            x: parent.width/2
            y: parent.height/2
        }

        MultiPointTouchArea {
            enabled: GameInfo.gamePaused ? false : true
            anchors.fill: parent

            property int referencePointX: 0
            property int referencePointY: 0
            property bool didRegisterReferencePoint: false;
            property real lastTime: 0
            property real touchStartTime: 0
            property int onTouchUpdatedCounter: 0
            property variant playerTwoAxisController: player.getComponent("TwoAxisController")
            property real oldPosX: 0.0
            property real oldPosY: 0.0
            property real newPosX: 0.0
            property real newPosY: 0.0

            touchPoints: [
                TouchPoint {id: fieldPoint}
            ]

            onUpdated: {
                player.playerCollider.linearDamping=0
                player.playerBody.playing=true

                onTouchUpdatedCounter += 1

                newPosX = ((fieldPoint.x - referencePointX + controlImage.width / 2) / (controlImage.width / 2) - 1)
                newPosY = ((fieldPoint.y - referencePointY + controlImage.height / 2) / (controlImage.height / 2) - 1)
                var distance = Math.sqrt((newPosX*newPosX) + (newPosY*newPosY)) //distance from center of the circle - radius

                // if no referencePoint is loaded yet, get one!
                if (didRegisterReferencePoint == false) {
                    // save new reference point
                    referencePointX = fieldPoint.x;
                    referencePointY = fieldPoint.y;

                    // check if this reference point is within the playerMovementImage, if so then use the center of the playermovementimage as the new reference point
                    if (referencePointX >= controlImage.x && referencePointX <= controlImage.x + controlImage.width &&
                            referencePointY >= controlImage.y && referencePointY <= controlImage.y + controlImage.height) {
                        referencePointX = controlImage.x + controlImage.width / 2
                        referencePointY = controlImage.y + controlImage.height / 2
                    }

                    updateControlImagePosition()
                    return;
                }

                if (distance >1) {
                    //angle is used to find a reference point at the border of the circular pad
                    var angle = (Math.atan2(newPosX, newPosY) * 180 / Math.PI) -180
                    angle = angle * (-1)
                    angle -= 90

                    //find a new reference point at the border of the circular pad
                    var newX= (controlImage.width/2) * Math.cos((angle)*Math.PI/180) + referencePointX
                    var newY= (controlImage.height/2) * Math.sin((angle)*Math.PI/180) + referencePointY

                    //calculate the difference between the border reference point and the point outside of the pad
                    var diffX = fieldPoint.x - newX
                    var diffY = fieldPoint.y - newY

                    //translate the pad in the new direction within the half of the field
                    if((referencePointX + diffX) <= controlImage.width / 2){
                        referencePointX = controlImage.width / 2
                    }else if((referencePointX + diffX) >= (parent.width - controlImage.width/2)){
                        referencePointX = parent.width - controlImage.width/2
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

                updateControlImagePosition()

                // now do the actual control of the character
                player.playerCollider.linearDamping=0
                player.playerBody.playing=true

                newPosY = newPosY * -1

                if (newPosX > 1) newPosX = 1
                if (newPosY > 1) newPosY = 1
                if (newPosX < -1) newPosX = -1
                if (newPosY < -1) newPosY = -1

                // If the player is not touching the control area, slowly stop the body!
                if(player.playerBody.playing==false) damping()

                // update the movement
                updateMovement()
            }

            function updateControlImagePosition() {
                // move image to reference point
                var newX = referencePointX - controlImage.width / 2;
                var newY = referencePointY - controlImage.height / 2;

                newX = Math.max(0, newX);
                newX = Math.min(parent.width - controlImage.width, newX);

                newY = Math.max(0, newY);
                newY = Math.min(parent.height - controlImage.height, newY);

                controlImage.x = newX;
                controlImage.y = newY;

                didRegisterReferencePoint = true;
            }

            // slows down the character when releasing the finger from tablet
            function damping(){
                player.playerCollider.linearDamping=GameInfo.damping
            }

            // updates the speed/direction of the character
            function updateMovement(){
                // store the x and y values before they'll be altered
                oldPosX=newPosX
                oldPosY=newPosY

                // Adjust the speed
                newPosX = newPosX * GameInfo.maximumPlayerVelocity
                newPosY = newPosY * GameInfo.maximumPlayerVelocity

                /* normalise the speed! when driving diagonally the x and y speed is both 1
                    when driving horizontally only either x or y is 1, which results in slower horizontal/vercial speed than diagonal speed
                    so shrink x and y about the same ratio down so that their maximum speed will be 1 (or whatever specified) */

                // calculate the distance from the center ( = speed)
                var velocity = Math.sqrt(newPosX * newPosX + newPosY * newPosY)
                var maxVelocity = GameInfo.maximumPlayerVelocity

                if (velocity > maxVelocity) {
                    // velocity is too high! shrink it down
                    var shrinkFactor = maxVelocity / velocity
                    newPosX = newPosX * shrinkFactor
                    newPosY = newPosY * shrinkFactor
                }

                // now update the twoAxisController with the calculated values
                playerTwoAxisController.xAxis = newPosX
                playerTwoAxisController.yAxis = newPosY
            }

            onPressed: {
                touchStartTime = new Date().getTime()
                didRegisterReferencePoint = false;
            }

            onReleased: {
                // reset touchUpdateCounter
                onTouchUpdatedCounter = 0

                // set playing to false
                player.playerBody.playing=false

                // slow down character till it stops
                damping()
            }
        }
    }

    function calcAngle(touchX, touchY) {
        return -180 / Math.PI * Math.atan2(touchY, touchX)
    }

    function reset(){
        GameInfo.gamePaused = true
        player.mass = 10;
        GameInfo.score = player.mass;
        player.x = parent.width/2;
        player.y = parent.height/2;
        player.playerCollider.bodyType = Body.Static;
        controlImage.x = controlImage.resetX;
        controlImage.y = controlImage.resetY;
    }
}
