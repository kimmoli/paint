import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Row
{
    id: toolbar2

    IconButton
    {
        icon.source: buttonimage[0]
        anchors.bottom: parent.bottom

        onClicked:
        {
            console.log(buttonhelptext[0])
            pageStack.push(Qt.resolvedUrl("../pages/AboutPage.qml"),
                                  { "version": painter.version,
                                    "year": "2014",
                                    "name": "Paint",
                                    "imagelocation": "/usr/share/icons/hicolor/86x86/apps/harbour-paint.png"} )
        }
    }
    IconButton
    {
        icon.source: buttonimage[6]
        anchors.bottom: parent.bottom

        onClicked:
        {
            console.log(buttonhelptext[6])
            var genSettingsDialog = pageStack.push(Qt.resolvedUrl("../pages/genSettings.qml"), {"saveFormat": painter.getSaveMode()} )

            genSettingsDialog.accepted.connect(function()
            {
                painter.setSaveMode(genSettingsDialog.saveFormat)
                showMessage(qsTr("File format") + " " + genSettingsDialog.saveFormat, 1500)
            })
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
                canvas.clear()
            })
        }
    }

    IconButton
    {
        icon.source: buttonimage[2]
        anchors.bottom: parent.bottom

        onClicked:
        {
            console.log(buttonhelptext[2])
            var bgSettingsDialog = pageStack.push(Qt.resolvedUrl("../pages/bgSettingsDialog.qml"), {
                                                       "currentBg": bgColor })
            bgSettingsDialog.accepted.connect(function() {
                bgColor = bgSettingsDialog.currentBg

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
