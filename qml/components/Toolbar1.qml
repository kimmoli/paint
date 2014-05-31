import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Row
{
    id: toolbar1

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

        onPressAndHold:
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
        icon.source: "image://paintIcons/icon-m-eraser"
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
        icon.source: "image://paintIcons/icon-m-spray"
        anchors.bottom: parent.bottom
        highlighted: drawMode === Painter.Spray

        onClicked:
        {
            console.log("spray mode select")
            drawMode = Painter.Spray
        }
    }

}
