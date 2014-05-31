import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

DockedPanel
{
    id: toolpanel
    z: 11

    signal showMessage(string message, int delay)

    open: showTooldrawer

    width: parent.width
    height: Theme.itemSizeExtraLarge + Theme.paddingLarge

    dock: Dock.Top
    Row
    {
        anchors.centerIn: parent
        height: parent.height

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
            icon.source: "image://theme/icon-m-edit"
            anchors.bottom: parent.bottom
            highlighted: drawMode === Painter.Pen

            onClicked:
            {
                console.log("pen mode select")
                drawMode = Painter.Pen
            }
        }

        IconButton
        {
            icon.source: "image://theme/icon-m-ambience"
            anchors.bottom: parent.bottom
            highlighted: drawMode === Painter.Spray

            onClicked:
            {
                console.log("spray mode select")
                drawMode = Painter.Spray
            }
        }

        IconButton
        {
            icon.source: "image://theme/icon-m-edit"
            icon.rotation: 180
            anchors.bottom: parent.bottom
            highlighted: drawMode === Painter.Eraser

            onClicked:
            {
                console.log("eraser mode select")
                drawMode = Painter.Eraser
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



//        Switch
//        {
//            icon.source: "image://theme/icon-m-repeat"
//            anchors.bottom: parent.bottom
//            anchors.bottomMargin: 8
//        }

//        Switch
//        {
//            icon.source: "image://theme/icon-m-share"
//            anchors.bottom: parent.bottom
//            anchors.bottomMargin: 8
//        }
    }
}
