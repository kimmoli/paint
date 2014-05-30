import QtQuick 2.0
import Sailfish.Silica 1.0

Row
{
    id: toolBox
    z:8
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    height: 80

    signal showMessage(string message)

    IconButton
    {
        icon.source: buttonimage[0]
        anchors.verticalCenter: parent.verticalCenter
        onClicked:
        {
            console.log(buttonhelptext[0])
            pageStack.push(Qt.resolvedUrl("AboutPage.qml"),
                                  { "version": myclass.version,
                                    "year": "2014",
                                    "name": "Paint",
                                    "imagelocation": "/usr/share/icons/hicolor/86x86/apps/harbour-paint.png"} )
        }
    }
    IconButton
    {
        icon.source: buttonimage[1]
        anchors.verticalCenter: parent.verticalCenter
        onClicked:
        {
            console.log(buttonhelptext[1])
            clearRequest = true
            canvas.requestPaint()
        }
    }
    IconButton
    {
        icon.source: buttonimage[2]
        anchors.verticalCenter: parent.verticalCenter
        onClicked:
        {
            console.log(buttonhelptext[2])
            var bgSettingsDialog = pageStack.push(Qt.resolvedUrl("bgSettingsDialog.qml"), {
                                                       "currentBg": bgColor })
            bgSettingsDialog.accepted.connect(function() {
                bgColor = bgSettingsDialog.currentBg
            })

        }
    }
    IconButton
    {
        icon.source: buttonimage[3]
        anchors.verticalCenter: parent.verticalCenter
        onClicked:
        {
            console.log(buttonhelptext[3])
            var penSettingsDialog = pageStack.push(Qt.resolvedUrl("penSettingsDialog.qml"), {
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
        icon.source: buttonimage[4]
        anchors.verticalCenter: parent.verticalCenter
        onPressAndHold:
        {
            console.log("long press toggle file format")
            if (myclass.getSaveMode() === "png")
            {
                myclass.setSaveMode("jpg")
                showMessage(qsTr("Save format") + " JPG")
            }
            else
            {
                myclass.setSaveMode("png")
                showMessage(qsTr("Save format") + " PNG")
            }
        }
        onClicked:
        {
            console.log(buttonhelptext[4])
            toolBox.opacity = 0.0
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
            showMessage(fileName)
        }
    }
}
