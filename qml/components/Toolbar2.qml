import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Row
{
    id: toolbar2

    IconButton
    {
        icon.source: "image://theme/icon-m-about"
        anchors.bottom: parent.bottom

        onClicked:
        {
            pageStack.push(Qt.resolvedUrl("../pages/AboutPage.qml"),
                                  { "version": painter.version,
                                    "year": "2014",
                                    "name": "Paint",
                                    "imagelocation": "/usr/share/icons/hicolor/86x86/apps/harbour-paint.png"} )
        }
    }
    IconButton
    {
        icon.source: "image://theme/icon-m-developer-mode"
        anchors.bottom: parent.bottom

        onClicked:
        {
            var saveModeWas = painter.getSaveMode()
            var genSettingsDialog = pageStack.push(Qt.resolvedUrl("../pages/genSettings.qml"),
                                                   {"saveFormat": saveModeWas ,
                                                    "toolboxLocation": toolboxLocation })

            genSettingsDialog.accepted.connect(function()
            {
                var newSaveMode = genSettingsDialog.saveFormat
                painter.setSaveMode(newSaveMode)
                if (saveModeWas !== newSaveMode)
                    showMessage(qsTr("File format") + " " + genSettingsDialog.saveFormat, 1500)
                toolboxLocation = genSettingsDialog.toolboxLocation
                painter.setToolboxLocation(genSettingsDialog.toolboxLocation)
            })
        }
    }

    IconButton
    {
        icon.source: "image://theme/icon-m-delete"
        anchors.verticalCenter: parent.verticalCenter
        onClicked: startRemorse()
    }

    IconButton
    {
        icon.source: "image://theme/icon-m-image"
        anchors.bottom: parent.bottom

        onClicked:
        {
            var bgSettingsDialog = pageStack.push(Qt.resolvedUrl("../pages/bgSettingsDialog.qml"), {
                                                       "currentBg": bgColor,
                                                       "useExternalImage": useImageAsBackground,
                                                       "bgImagePath": backgroundImagePath,
                                                      "bgImageRotate": backgroundImageRotate })
            bgSettingsDialog.accepted.connect(function() {
                bgColor = bgSettingsDialog.currentBg
                useImageAsBackground = bgSettingsDialog.useExternalImage
                backgroundImagePath = bgSettingsDialog.bgImagePath
                backgroundImageRotate = bgSettingsDialog.bgImageRotate
            })

        }
    }

    IconButton
    {
        icon.source: "image://paintIcons/icon-m-save"
        anchors.verticalCenter: parent.verticalCenter
        onClicked:
        {
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
            var fileName = painter.saveScreenshot()
            toolBox.opacity = 1.0
            showMessage(fileName, 0)
        }
    }
}
