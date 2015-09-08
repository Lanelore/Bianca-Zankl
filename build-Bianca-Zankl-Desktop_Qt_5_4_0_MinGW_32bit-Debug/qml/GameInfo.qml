pragma Singleton
import QtQuick 2.0
import VPlay 2.0

Item {
    id: gameInfo

    //statistic
    property bool gameOver: false  //indicates a gameover and shows gameovermessage
    property bool gamePaused: true //freezes the animations, the controls, the opponent and the powerupspawn
    //in the beginning while countdown is running and at the gameOver window

    property real damping: 2

    //menu layout
    property color red: "red"
    property color blue: "blue"
    property int border: 4
    property int radius: 50
    property double lighterColor: 1.7       //lighter colors are 70% lighter than normal colors
    property double pacity: 0.3             //because opacity is already taken


    // Controller parameters
    readonly property int onTouchUpdateCounterThreshold: 0 // change this to about 6 to prevent the cannon from changing the angle when shooting

    readonly property int controlType2AngleRange: 50
    readonly property int controlType2Width: 240
    readonly property int controlType2Height: 80

    readonly property int controlType1Width: 180
    readonly property int controlType1Height: 180

    readonly property double maximumPlayerVelocity: 1.4

    // Controller modes
    property bool easyMode: true
    property int swipeTouchPointLimit: 10

    //property string currentLevel: ""

    property bool visibleControls: true          // if the test level is selected, show the control graphic
}
