import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Item
{
    id: toolbar1

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
            icon.source: "image://theme/icon-m-edit"
            mode: Painter.Pen

            onClicked:
            {
                toolSettingsButton.icon.source = "image://paintIcons/icon-m-toolsettings"
                hideGeometryPopup()
                if (textEditPending)
                    textEditCancel()
                drawMode = mode
            }
        }

        ToolbarButton
        {
            icon.source: "image://paintIcons/icon-m-eraser"
            mode: Painter.Eraser

            onClicked:
            {
                toolSettingsButton.icon.source = "image://paintIcons/icon-m-erasersettings"
                hideGeometryPopup()
                if (textEditPending)
                    textEditCancel()
                drawMode = mode
            }
        }

        ToolbarButton
        {
            icon.source: "image://paintIcons/icon-m-spray"
            mode: Painter.Spray

            onClicked:
            {
                toolSettingsButton.icon.source = "image://paintIcons/icon-m-toolsettings"
                hideGeometryPopup()
                if (textEditPending)
                    textEditCancel()
                drawMode = mode
            }
        }

        ToolbarButton
        {
            icon.source: "image://paintIcons/icon-m-geometrics"
            mode: Painter.Geometrics

            onClicked:
            {
                toolSettingsButton.icon.source = "image://paintIcons/icon-m-toolsettings"
                if (drawMode != mode)
                    showGeometryPopup()
                else
                    toggleGeometryPopup()
                if (textEditPending)
                    textEditCancel()
                drawMode = mode
            }

            onHighlightedChanged:
                if (!highlighted)
                {
                    hideGeometryPopup()
                }
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
