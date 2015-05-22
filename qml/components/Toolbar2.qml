import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Item
{
    id: toolbar2

    Row
    {
        property int n: children.length-1

        spacing: (parent.width - n*64-(parent.width - n*64)/2)/(n+1)

        Item
        {
            height: 1
            width: 1.5 * parent.spacing
        }

        ToolbarButton
        {
            icon.source: "image://paintIcons/icon-m-texttool"
            mode: Painter.Text

            onClicked:
            {
                hideDimensionPopup()
                toolSettingsButton.icon.source = "image://paintIcons/icon-m-textsettings"
                drawMode = mode
                if (textEditPending)
                    textEditCancel()
            }
        }

        ToolbarButton
        {
            icon.source: "image://theme/icon-m-enter-accept"
            enabled: textEditPending

            onClicked: textEditAccept()
        }

        ToolbarButton
        {
            icon.source: "image://paintIcons/icon-m-dimensiontool"
            mode: Painter.Dimensioning

            onClicked:
            {
                toolSettingsButton.icon.source = "image://paintIcons/icon-m-toolsettings"
                if (drawMode != mode)
                    showDimensionPopup()
                else
                    toggleDimensionPopup()
                if (textEditPending)
                    textEditCancel()
                drawMode = mode
                previewCanvas.requestPaint()
            }

            onHighlightedChanged:
                if (!highlighted)
                {
                    hideDimensionPopup()
                }
        }

        ToolbarButton
        {
            icon.source: "image://paintIcons/icon-m-grid"

            onClicked: toggleGridVisibility()
        }

        ToolbarButton
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

            onClicked:
            {
                showToolSettings()
            }
        }
    }
}
