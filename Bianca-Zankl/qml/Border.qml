import QtQuick 2.0
import VPlay 2.0

EntityBase {
    id: borderID
    entityId: "border"
    entityType: "border"
    z: 2000

    Rectangle {
        z: 2000
        anchors.fill: parent
        color: "black"
        visible: true // set to 'true' for debugging
    }
}
