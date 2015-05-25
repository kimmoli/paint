import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Item
{
    id: toolbar1

    Row
    {
        spacing: (parent.width - children.length*80)/(children.length+1)
        anchors.horizontalCenter: parent.horizontalCenter

        ToolbarButton
        {
            icon.source: "image://theme/icon-m-edit"
            mode: Painter.Pen

            onClicked:
            {
                hideGeometryPopup()
                cancelPendingFunctions()
                drawMode = mode
            }
        }

        ToolbarButton
        {
            icon.source: "image://paintIcons/icon-m-eraser"
            mode: Painter.Eraser

            onClicked:
            {
                hideGeometryPopup()
                cancelPendingFunctions()
                drawMode = mode
            }
        }

        ToolbarButton
        {
            icon.source: "image://paintIcons/icon-m-spray"
            mode: Painter.Spray

            onClicked:
            {
                hideGeometryPopup()
                cancelPendingFunctions()
                drawMode = mode
            }
        }

        ToolbarButton
        {
            icon.source:
            {
                if (drawMode == Painter.Geometrics)
                {
                    if (geometricsMode == Painter.Line)
                        return "image://paintIcons/icon-m-geom-line"
                    if (geometricsMode == Painter.Rectangle)
                        return geometryFill ? "image://paintIcons/icon-m-geom-rectangle-filled" : "image://paintIcons/icon-m-geom-rectangle"
                    if (geometricsMode == Painter.Square)
                        return geometryFill ? "image://paintIcons/icon-m-geom-square-filled" : "image://paintIcons/icon-m-geom-square"
                    if (geometricsMode == Painter.Circle)
                        return geometryFill ? "image://paintIcons/icon-m-geom-circle-filled" : "image://paintIcons/icon-m-geom-circle"
                    if (geometricsMode == Painter.Ellipse)
                        return geometryFill ? "image://paintIcons/icon-m-geom-ellipse-filled" : "image://paintIcons/icon-m-geom-ellipse"
                    if (geometricsMode == Painter.EquilateralTriangle)
                        return geometryFill ? "image://paintIcons/icon-m-geom-etriangle-filled" : "image://paintIcons/icon-m-geom-etriangle"
                    if (geometricsMode == Painter.RightIsoscelesTriangle)
                        return geometryFill ? "image://paintIcons/icon-m-geom-ritriangle-filled" : "image://paintIcons/icon-m-geom-ritriangle"
                    if (geometricsMode == Painter.Polygon)
                        return geometryFill ? "image://paintIcons/icon-m-geom-polygon-filled" : "image://paintIcons/icon-m-geom-polygon"
                    if (geometricsMode == Painter.Polygram)
                        return geometryFill ? "image://paintIcons/icon-m-geom-polygram-filled" : "image://paintIcons/icon-m-geom-polygram"
                    if (geometricsMode == Painter.Arrow)
                        return geometryFill ? "image://paintIcons/icon-m-geom-arrow-filled" : "image://paintIcons/icon-m-geom-arrow"
                }
                else
                {
                    return "image://paintIcons/icon-m-geometrics"
                }
            }

            mode: Painter.Geometrics

            onClicked:
            {
                if (drawMode != mode)
                    showGeometryPopup()
                else
                    toggleGeometryPopup()
                cancelPendingFunctions()
                drawMode = mode
            }

            onHighlightedChanged:
            {
                if (!highlighted)
                {
                    hideGeometryPopup()
                }
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
