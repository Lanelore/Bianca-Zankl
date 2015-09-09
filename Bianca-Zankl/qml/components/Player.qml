import QtQuick 2.0
import VPlay 2.0
import ".."

EntityBase {
    id: player
    entityId: "player"
    entityType: "player"

    // make the twoAxisController acessible from outside
    property var player: player
    property alias controller: twoAxisController
    property alias playerBody: playerBody
    property alias playerCollider: playerCollider
    property alias playerCoreCollider: playerCoreCollider
    property int core: 5
    property double mass: resetMass
    property double resetMass: 20
    property string lastOpponent: ""
    property int lastMass: 0

    signal contact(var other)

    onMassChanged: {
        if (mass > 100){  // biggest opponent in game
            GameInfo.victory = true
            victorySound.play()
            endGame()
        }
    }

    onEnabledChanged: {
        player.visible = true
    }

    TwoAxisController {
        id: twoAxisController
    }

    SoundEffectVPlay {
        volume: 0.3
        id: victorySound
        // an ogg file is not playable on windows, because the extension is not supported!
        source: "../../assets/snd/Victory.wav"
    }

    SoundEffectVPlay {
        volume: 0.1
        id: gulpSound
        // an ogg file is not playable on windows, because the extension is not supported!
        source: "../../assets/snd/Gulp.wav"
    }

    SoundEffectVPlay {
        volume: 0.2
        id: swallowSound
        // an ogg file is not playable on windows, because the extension is not supported!
        source: "../../assets/snd/Swallow.wav"
    }

    AnimatedImage {
        width: mass
        height: mass
        id: playerBody
        anchors.centerIn: parent
        playing: false
        source: "../../assets/img/Player.gif"
    }

    CircleCollider {
        //collisionTestingOnlyMode: true
        sensor: true
        id: playerCollider
        radius: mass/2
        x: radius
        y: radius
        anchors.centerIn: parent
        density: GameInfo.gamePaused ? 1000000 : 0
        friction: GameInfo.gamePaused ? 0 : 0.4
        restitution: GameInfo.gamePaused ? 0 : 0.4
        bullet: true
        linearDamping: GameInfo.gamePaused ? 1000000 : 100

        // this is applied every physics update tick
        linearVelocity: Qt.point(twoAxisController.xAxis * 100, twoAxisController.yAxis * (-100))

        onBodyTypeChanged: {
            playerCollider.bodyType = Body.Dynamic;
        }
    }

    CircleCollider {
        collisionTestingOnlyMode: true
        id: playerCoreCollider
        radius: core/2
        x: radius
        y: radius
        anchors.centerIn: parent

        fixture.onBeginContact: {
            // handle the collision and make the image semi-transparent

            var collidedEntity = other.parent.parent.parent;
            var collidedEntityId = collidedEntity.entityId;

            // check if it hit a player
            if (collidedEntityId.substring(0, 8) === "opponent") {
                // call damage method on playerred/playerblue
                onContact(collidedEntity);
            }
        }
    }

    function onContact(other) {
        //check mass and so on
        var sameOpponent = false;
        if ((other.entityId === lastOpponent) && (other.mass === lastMass)){
            sameOpponent = true;
        }
        if((player.mass > other.mass) && !sameOpponent){
            gulpSound.play()
            lastOpponent = other.entityId;
            lastMass = other.mass;
            if (other.mass/20 > 5) {
                player.mass += 3;
                console.debug("gain" + 3);
            }else{
                player.mass += other.mass/20;
                console.debug("gain" + other.mass/20);
            }
            other.die();
        }else if (player.mass <= other.mass){
            swallowSound.play()
            endGame();
        }
    }

    function updatePosition() {
        if (player.x > field.width){
            player.x = 0
        }else if (player.x < 0){
            player.x = field.width
        }
        if(player.y > field.height){
            player.y = 0
        }else if (player.y < 0){
            player.y = field.height
        }
    }

    function endGame(){
        GameInfo.gamePaused = true;
        player.visible = false;
        GameInfo.score = (mass - resetMass) * 10;
        endGameTimer.start();
    }

    Timer {
        id: endGameTimer
        interval: 1200
        running: false
        repeat: false
        onTriggered: {
            gameOver()
        }
    }
}
