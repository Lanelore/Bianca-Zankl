import VPlay 2.0
import QtQuick 2.0

Item {
    width: spriteSequence.width
    height: spriteSequence.height

    SpriteSequenceVPlay {
        id: spriteSequence
        anchors.centerIn: parent

        SpriteVPlay {
            name: "running"

            frameCount: 3
            frameRate: 4

            frameWidth: 368
            frameHeight: 90
            source: "../../assets/img/landSprite.png"

        }
    }

    function reset() {
        spriteSequence.running = true
    }

    function stop() {
        spriteSequence.running = false
    }
}

