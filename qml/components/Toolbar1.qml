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

        onClicked: drawMode = Painter.Pen
    }

    IconButton
    {
        icon.source: "image://paintIcons/icon-m-eraser"
        anchors.bottom: parent.bottom
        highlighted: drawMode === Painter.Eraser

        onClicked: drawMode = Painter.Eraser
    }

    IconButton
    {
        icon.source: "image://paintIcons/icon-m-spray"
        anchors.bottom: parent.bottom
        highlighted: drawMode === Painter.Spray

        onClicked: drawMode = Painter.Spray
    }

    IconButton
    {
        icon.source: "image://paintIcons/icon-m-geometrics"
        anchors.bottom: parent.bottom
        highlighted: drawMode === Painter.Geometrics

        onClicked:
        {
            drawMode = Painter.Geometrics
            showGeometryPopup()
        }
    }


    IconButton
    {
        icon.source: "image://paintIcons/icon-m-toolsettings"
        anchors.bottom: parent.bottom

        onClicked:
        {
            var SettingsDialog

            switch (drawMode)
            {
                case Painter.Eraser : /* TODO: Own dialogs */
                case Painter.Spray :
                case Painter.Geometrics:

                case Painter.Pen :
                    SettingsDialog = pageStack.push(Qt.resolvedUrl("../pages/penSettingsDialog.qml"),
                                                           { "currentColor": drawColor,
                                                             "currentThickness": drawThickness })

                    SettingsDialog.accepted.connect(function() {
                        drawColor = SettingsDialog.currentColor
                        drawThickness = SettingsDialog.currentThickness
                    })

                    break;

                default :
                    break;
            }
        }
    }


}
