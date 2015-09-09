import QtQuick 2.0
import VPlay 2.0
import ".."

EntityBase {
    id: opponentSpawn
    entityType: "opponentSpawn"

    property int sceneHeight: 768
    property int sceneWidth: 1024
    property int timeMin: 100         // wait at least timeMin sec
    property int timeSpan: 1900       // spawn between timeMin and timeMin + timeSpan sec
    property int limit: Math.ceil(Math.random() * (timeSpan) + timeMin);

    Timer {
        id: timer
        interval: limit;
        running: GameInfo.gamePaused ? false : true;
        repeat: true;

        onTriggered: {
            //spawn items at random times
            limit = Math.ceil(Math.random() * (timeSpan) + timeMin);

            if(GameInfo.opponentCount < GameInfo.maxOpponents){
                spawnOpponent()
            }
        }
    }

    function spawnOpponent(){
        var directions = 4;
        var randomDirection = Math.ceil(Math.random() * (directions));

        var massMin = 10; var massSpan = player.mass * 1.5;
        var mass = Math.ceil(Math.random() * (massSpan) + massMin);

        var speedMin = 20; var speedSpan = 80;
        var speed = Math.ceil(Math.random() * (speedSpan) + speedMin);

        var direction;
        var startX;
        var startY;

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

        entityManager.createEntityFromUrlWithProperties(
                    Qt.resolvedUrl("Opponent.qml"), {
                        "z": 1,
                        "x": startX,
                        "y": startY,
                        "sceneWidth": sceneWidth,
                        "sceneHeight": sceneHeight,
                        "speed": speed,
                        "mass": mass,
                        "direction": direction
                    }
                    );
    }
}
