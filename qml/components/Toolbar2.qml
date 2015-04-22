import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Item
{
    id: toolbar2

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
            icon.source: "image://paintIcons/icon-m-texttool"
            anchors.bottom: parent.bottom
            highlighted: drawMode === Painter.Text
            rotation: rotationSensor.angle
            Behavior on rotation { SmoothedAnimation { duration: 500 } }

            onClicked:
            {
                hideDimensionPopup()
                toolSettingsButton.icon.source = "image://paintIcons/icon-m-textsettings"
                drawMode = Painter.Text
                if (textEditPending)
                    textEditCancel()
            }
        }

        IconButton
        {
            icon.source: "image://theme/icon-m-enter-accept"
            anchors.bottom: parent.bottom
            enabled: textEditPending
            rotation: rotationSensor.angle
            Behavior on rotation { SmoothedAnimation { duration: 500 } }

            onClicked: textEditAccept()
        }

        IconButton
        {
            icon.source: "image://paintIcons/icon-m-dimensiontool"
            anchors.bottom: parent.bottom
            highlighted: drawMode === Painter.Dimensioning
            rotation: rotationSensor.angle
            Behavior on rotation { SmoothedAnimation { duration: 500 } }

            onClicked:
            {
                toolSettingsButton.icon.source = "image://paintIcons/icon-m-toolsettings"
                if (drawMode != Painter.Dimensioning)
                    showDimensionPopup()
                else
                    toggleDimensionPopup()
                if (textEditPending)
                    textEditCancel()
                drawMode = Painter.Dimensioning
                previewCanvas.requestPaint()
            }

            onHighlightedChanged:
                if (!highlighted)
                {
                    hideDimensionPopup()
                }
        }

        IconButton
        {
            icon.source: "image://paintIcons/icon-m-grid"
            anchors.bottom: parent.bottom
            rotation: rotationSensor.angle
            Behavior on rotation { SmoothedAnimation { duration: 500 } }

            onClicked: toggleGridVisibility()
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
