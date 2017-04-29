import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../components"

MenuBase
{
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
                if (geometricsMode == Painter.FreehandClosed)
                    return geometryFill ? "image://paintIcons/icon-m-geom-freehand-closed-filled" : "image://paintIcons/icon-m-geom-freehand-closed"
            }
            else
            {
                return "image://paintIcons/icon-m-geometrics"
            }
        }

        mode: Painter.Geometrics

        onClicked:
        {
            cancelPendingFunctions(1)

            if (drawMode != mode)
                geometryPopupVisible = true
            else
                geometryPopupVisible = !geometryPopupVisible
            drawMode = mode
        }

        onHighlightedChanged:
        {
            if (!highlighted)
            {
                geometryPopupVisible = false
            }
        }
    }

    ToolbarButton
    {
        icon.source: "image://paintIcons/icon-m-toolsettings"

        onClicked:
        {
            showToolSettings()
        }
    }
}
