import QtQuick 2.0
import Sailfish.Silica 1.0

Row
{
    id: toolBox
    z:8
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    height: 80
    width: parent.width

    signal showMessage(string message, int delay)

    RemorsePopup
    {
        id: remorse
        z: 11
        opacity: 1.0
        anchors.verticalCenter: parent.verticalCenter
    }

    IconButton
    {
        icon.source: buttonimage[3]
        anchors.verticalCenter: parent.verticalCenter

        Behavior on icon.rotation
        {
            NumberAnimation { duration: 250 }
        }

        onClicked:
        {
            console.log(buttonhelptext[3])
            var x = Qt.createComponent(Qt.resolvedUrl("../components/Toolbar1.qml"))
            x.createObject(toolBox)

        }
    }


}
