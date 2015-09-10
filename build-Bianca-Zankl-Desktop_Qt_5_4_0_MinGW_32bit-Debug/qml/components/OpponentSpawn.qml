import QtQuick 2.0
import VPlay 2.0
import ".."

EntityBase {
    id: opponentSpawn
    entityType: "opponentSpawn"

    // the opponentSpawn needs to know the current screen size to spawn the opponents at the right positions
    property int sceneHeight: 768
    property int sceneWidth: 1024
    property int timeMin: 100         // wait at least timeMin sec
    property int timeSpan: 1900       // spawn after waiting between timeMin and timeMin + timeSpan seconds
    property int limit: Math.ceil(Math.random() * (timeSpan) + timeMin);        // calculate a random amount of seconnds

    Timer {
        id: timer
        interval: limit     // wait a random amount of seconds
        running: GameInfo.gamePaused ? false : true     // stop spawning if the game is paused
        repeat: true

        onTriggered: {
            // calculate the next waiting time span
            limit = Math.ceil(Math.random() * (timeSpan) + timeMin);

            // check if there is enough room for another opponent and spawn it
            if(GameInfo.opponentCount < GameInfo.maxOpponents){
                spawnOpponent()
            }
        }
    }

    function spawnOpponent(){
        // chose one of 4 moving directions
        var directions = 4;
        var randomDirection = Math.ceil(Math.random() * (directions));

        // chose a random mass between massMin and massMin + massSpan
        var massMin = 10; var massSpan = player.mass * 1.5;
        var mass = Math.ceil(Math.random() * (massSpan) + massMin);

        // chose a random speed between speedMin and speedMin + speedSpan
        var speedMin = 20; var speedSpan = 80;
        var speed = Math.ceil(Math.random() * (speedSpan) + speedMin);

        // chose a random rotation between 1 and 360 degrees
        var rotation = Math.ceil(Math.random() * 360);

        var direction;
        var startX;
        var startY;

        // save the direction and pick the according starting position at the right edge of the scene
        if(randomDirection==1){
            direction = "up";
            startY = sceneHeight + mass/2;
            startX = Math.ceil(Math.random() * (sceneWidth - mass) + mass/2);
        }
        if(randomDirection==2){
            direction = "right";
            startX = -mass/2;
            startY = Math.ceil(Math.random() * (sceneHeight - mass) + mass/2);
        }
        if(randomDirection==3){
            direction = "down";
            startY = -mass/2;
            startX = Math.ceil(Math.random() * (sceneWidth - mass) + mass/2);
        }
        if(randomDirection==4){
            direction = "left";
            startX = sceneWidth + mass/2;
            startY = Math.ceil(Math.random() * (sceneHeight - mass) + mass/2);
        }

        // create the entity in the scene
        entityManager.createEntityFromUrlWithProperties(
                    Qt.resolvedUrl("Opponent.qml"), {
                        "z": 1,
                        "x": startX,
                        "y": startY,
                        "sceneWidth": sceneWidth,
                        "sceneHeight": sceneHeight,
                        "speed": speed,
                        "mass": mass,
                        "direction": direction,
                        "rotation": rotation
                    }
                    );
    }
}
