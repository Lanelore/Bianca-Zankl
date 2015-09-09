pragma Singleton
import QtQuick 2.0
import VPlay 2.0

Item {
    id: gameInfo

    // states
    property double score: 0
    property bool victory: false
    property bool gamePaused: true      //freezes the animations, the controls, the opponent and the powerupspawn
                                        //in the beginning while countdown is running and at the gameOver window
    // display
    property double pacity: 0.3
    property bool visibleControls: true          // if the test level is selected, show the control graphic

    // Controller parameters
    readonly property int onTouchUpdateCounterThreshold: 0 // change this to about 6 to prevent the cannon from changing the angle when shooting
    readonly property double maximumPlayerVelocity: 1.4
    property real damping: 2

    // opponents
    property int opponentCount: 0
    property int maxOpponents: 10
}
