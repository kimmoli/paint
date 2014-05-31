import QtQuick 2.0
import Sailfish.Silica 1.0

Row
{
    id: toolbar1

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
            var fileName = painter.saveScreenshot()
            toolBox.opacity = 1.0
            showMessage(fileName, 0)
        }
    }
}
