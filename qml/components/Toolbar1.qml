import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Item
{
    id: toolbar1

    Row
    {
        spacing: (parent.width - 5*64-(parent.width - 5*64)/2)/6

        Item
        {
            height: 1
            width: 1.5 * parent.spacing
        }

        IconButton
        {
            icon.source: "image://theme/icon-m-edit"
            anchors.bottom: parent.bottom
            highlighted: drawMode === Painter.Pen
            rotation: rotationSensor.angle
            Behavior on rotation { SmoothedAnimation { duration: 500 } }

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
            rotation: rotationSensor.angle
            Behavior on rotation { SmoothedAnimation { duration: 500 } }

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
            rotation: rotationSensor.angle
            Behavior on rotation { SmoothedAnimation { duration: 500 } }

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
            rotation: rotationSensor.angle
            Behavior on rotation { SmoothedAnimation { duration: 500 } }

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

            onHighlightedChanged:
                if (!highlighted)
                {
                    hideGeometryPopup()
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
            rotation: rotationSensor.angle
            Behavior on rotation { SmoothedAnimation { duration: 500 } }

            onClicked:
            {
                showToolSettings()
            }
        }
    }
}
