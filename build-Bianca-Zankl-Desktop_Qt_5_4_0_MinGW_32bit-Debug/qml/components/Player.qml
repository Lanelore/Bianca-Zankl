import QtQuick 2.0
import VPlay 2.0
import ".."

EntityBase {
    id: player
    entityId: "player"
    entityType: "player"

    // make the twoAxisController, the player image and the two colliders acessible from outside
    property alias controller: twoAxisController
    property alias playerBody: playerBody
    property alias playerCollider: playerCollider
    property alias playerCoreCollider: playerCoreCollider

    // core radius, current mass, starting mass, entityId and mass of the last encountered opponent
    // and bonus points after reaching the max size
    property int core: 5
    property double mass: resetMass
    property double resetMass: 20
    property double bonus: 0
    property int lastOpponentId: 0

    // signals a contact between the player and an opponent
    signal contact(var other)

    // make sure the player is visible after hiding him at his death
    onEnabledChanged: player.visible = true

    // enables the character's movement
    TwoAxisController {
        id: twoAxisController
    }

    // sound effect: player eating an opponent
    SoundEffectVPlay {
        volume: 0.1
        id: gulpSound
        // an ogg file is not playable on windows, because the extension is not supported!
        source: "../../assets/snd/Gulp.wav"
    }

    //sound effect: player getting eaten by an opponent
    SoundEffectVPlay {
        volume: 0.2
        id: swallowSound
        // an ogg file is not playable on windows, because the extension is not supported!
        source: "../../assets/snd/Swallow.wav"
    }

    // the player's visual representation, size depends on the current mass
    // only playing when the he is moved across the screen
    AnimatedImage {
        width: mass
        height: mass
        id: playerBody
        anchors.centerIn: parent
        playing: false
        source: "../../assets/img/Player.gif"
    }

    // outer collider for tracking contacts, size depends on the current mass
    // determines the physical behaviour like density or friction depending on the current game status
    CircleCollider {
        sensor: true
        id: playerCollider
        radius: mass/2
        x: radius
        y: radius
        anchors.centerIn: parent
        density: GameInfo.gamePaused ? 1000000 : 0
        friction: GameInfo.gamePaused ? 0 : 0.4
        restitution: GameInfo.gamePaused ? 0 : 0.4
        linearDamping: GameInfo.gamePaused ? 1000000 : 100

        // this is applied every physics update tick
        // the player moves with the help of the twoAxisController
        linearVelocity: Qt.point(twoAxisController.xAxis * 100, twoAxisController.yAxis * (-100))

        // revert the player to the dynamic state after freezing him during for the reset
        onBodyTypeChanged: playerCollider.bodyType = Body.Dynamic
    }

    // this collider is the core or heart of the character and is a small circle in the center of the body
    // this is used to determine whether half of the body is covered or not
    CircleCollider {
        collisionTestingOnlyMode: true
        id: playerCoreCollider
        radius: core/2
        x: radius
        y: radius
        anchors.centerIn: parent

        fixture.onBeginContact: {
            var collidedEntity = other.parent.parent.parent;
            var collidedEntityId = collidedEntity.entityId;

            // check if it hit an opponent and signal a contact
            if (collidedEntityId.substring(0, 8) === "opponent") {
                onContact(collidedEntity);
            }
        }
    }

    // handle the collision between the player and the opponent and "destroy" one of them depending on their mass
    function onContact(other) {
        // make sure this is a new opponent and not just an accidental second signal
        // compare the current opponent's mass and entityId with the values from the last opponent
        var sameOpponent = (lastOpponentId === other.opponentId) ? true : false;

        // if the player is bigger and it is a new opponent
        if((player.mass > other.mass) && !sameOpponent){
            // play the sound of eating an opponent and remember this one
            gulpSound.play()
            lastOpponentId = other.opponentId;

            // if the player has more mass then the desired size
            // count the other points as bonus points
            // the aquired mass depends on the opponent's size and has to be lower than 5
            // delete the opponent
            if (player.mass >= GameInfo.maxMass){
                if (other.mass * GameInfo.massGain > GameInfo.maxGain) {
                    player.bonus += GameInfo.maxGain;
                }else{
                    player.bonus += other.mass * GameInfo.massGain;
                }
            }else if (other.mass * GameInfo.massGain > GameInfo.maxGain) {
                player.mass += GameInfo.maxGain;
            }else{
                player.mass += other.mass * GameInfo.massGain;
                player.bonus += other.mass * GameInfo.massGain;
            }
            if (player.mass > GameInfo.maxMass){
                player.mass = GameInfo.maxMass;
            }
            other.die();

        }else if (player.mass <= other.mass){
            // if the player is smaller than the opponent
            // play the sound of getting eaten and end the game
            swallowSound.play()
            endGame();
        }
    }

    // update the position after leaving the scene
    // reappear at the other side of the scene
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

    // end the game by pausing, hiding the player, saving his score and wait for a short time
    function endGame(){
        GameInfo.gamePaused = true;
        player.visible = false;
        GameInfo.score = Math.round((player.mass - player.resetMass + player.bonus) * 10);
        endGameTimer.start();
    }

    // signale gameOver after a small period of time
    // change to the gameOverScene with the help of the state machine in the Main
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
