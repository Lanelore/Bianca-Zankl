pragma Singleton
import QtQuick 2.0
import VPlay 2.0

Item {
    id: gameInfo

    // states
    property double score: 0            // the player's score depending on how many opponents he defeated
    property bool gamePaused: true      // freezes the animations, the controls, the opponent and the powerupspawn
                                        // in the beginning while countdown is running and at the gameOver window
    // display
    property double pacity: 0.3         // the opacity of the control image in the gameController
    property bool visibleControls: true // show the control image depending on the player's settings

    // gameController
    readonly property double maximumPlayerVelocity: 1.4     // the player's maximum speed
    property real damping: 2                                // slows the player down when there's no input

    // opponents
    property int opponentCount: 0       // keeps track of the current amount of opponents on the field
    property int maxOpponents: 10       // maxiumum opponents on the field at the same time
    property int opponentId: 0          // make sure every opponent has a unique id

    // mass
    property int maxMass: 80            // the main character's maximum size
    property double massGain: 0.05      // the percentage of mass the character gains after eating an opponent
    property double maxGain: 5          // the maximum mass earned from eating an opponent
}
