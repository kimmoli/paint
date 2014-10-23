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
            toolSettingsButton.icon.source = "image://paintIcons/icon-m-toolsettings"
            hideGeometryPopup()
            if (textEditPending)
                textEditCancel()
            drawMode = Painter.Pen
        }
    }

    IconButton
    {
        icon.source: "image://paintIcons/icon-m-eraser"
        anchors.bottom: parent.bottom
        highlighted: drawMode === Painter.Eraser

        onClicked:
        {
            toolSettingsButton.icon.source = "image://paintIcons/icon-m-erasersettings"
            hideGeometryPopup()
            if (textEditPending)
                textEditCancel()
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
            toolSettingsButton.icon.source = "image://paintIcons/icon-m-toolsettings"
            hideGeometryPopup()
            if (textEditPending)
                textEditCancel()
            drawMode = Painter.Spray
        }
    }

    IconButton
    {
        icon.source: "image://paintIcons/icon-m-geometrics"
        anchors.bottom: parent.bottom
        highlighted: drawMode === Painter.Geometrics

        onClicked:
        {
            toolSettingsButton.icon.source = "image://paintIcons/icon-m-toolsettings"
            if (drawMode != Painter.Geometrics)
                showGeometryPopup()
            else
                toggleGeometryPopup()
            if (textEditPending)
                textEditCancel()
            drawMode = Painter.Geometrics
        }
    }


    IconButton
    {
        id: toolSettingsButton
        icon.source:
        {
            if (drawMode == Painter.Text)
                return "image://paintIcons/icon-m-textsettings"
            if (drawMode == Painter.Eraser)
                return "image://paintIcons/icon-m-erasersettings"
            return "image://paintIcons/icon-m-toolsettings"
        }
        anchors.bottom: parent.bottom

        onClicked:
        {
            showToolSettings()
        }
    }


}
