import QtQuick 2.0
import Sailfish.Silica 1.0

Row
{
    id: toolBox
    z:8
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    height: 80

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
        icon.rotation: showTooldrawer ? 180 : 0
        anchors.verticalCenter: parent.verticalCenter

        Behavior on icon.rotation
        {
            NumberAnimation { duration: 250 }
        }

        onClicked:
        {
            console.log(buttonhelptext[3])
            showTooldrawer = !showTooldrawer
        }
    }

    IconButton
    {
        icon.source: buttonimage[1]
        anchors.verticalCenter: parent.verticalCenter
        onClicked:
        {
            console.log(buttonhelptext[1])
            remorse.execute(qsTr("Clearing"), function()
            {
                clearRequest = true
                canvas.requestPaint()
            })
        }
    }

    IconButton
    {
        icon.source: buttonimage[4]
        anchors.verticalCenter: parent.verticalCenter
        onClicked:
        {
            console.log(buttonhelptext[4])
            var penSettingsDialog = pageStack.push(Qt.resolvedUrl("../pages/penSettingsDialog.qml"), {
                                                       "currentColor": drawColor,
                                                       "currentThickness": drawThickness })
            penSettingsDialog.accepted.connect(function() {
                drawColor = penSettingsDialog.currentColor
                drawThickness = penSettingsDialog.currentThickness
            })
        }
    }

    IconButton
    {
        icon.source: buttonimage[5]
        anchors.verticalCenter: parent.verticalCenter
        onClicked:
        {
            console.log(buttonhelptext[5])
            toolBox.opacity = 0.0
            showTooldrawer = false
            toolBoxVisibility.start()
        }
    }
    Behavior on opacity
    {
        FadeAnimation {}
    }
    Timer
    {
        id: toolBoxVisibility
        interval: 1000
        onTriggered:
        {
            var fileName = myclass.saveScreenshot()
            toolBox.opacity = 1.0
            showMessage(fileName, 0)
        }
    }
}
