import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0



Row
{
    id: geometryPopup

    property bool geometryFillToggled: false

    GeometryButton
    {
        icon.source: "image://paintIcons/icon-m-geom-line"
        mode: Painter.Line
        onClicked:
        {
            drawMode = Painter.Geometrics
            geometricsMode = mode
        }
    }

    GeometryButton
    {
        icon.source: geometryFill ? "image://paintIcons/icon-m-geom-rectangle-filled" : "image://paintIcons/icon-m-geom-rectangle"
        mode: Painter.Rectangle
        onClicked:
        {
            drawMode = Painter.Geometrics
            geometricsMode = mode
        }
    }

    GeometryButton
    {
        icon.source: geometryFill ? "image://paintIcons/icon-m-geom-square-filled" : "image://paintIcons/icon-m-geom-square"
        mode: Painter.Square
        onClicked:
        {
            drawMode = Painter.Geometrics
            geometricsMode = mode
        }
    }

    GeometryButton
    {
        icon.source: geometryFill ? "image://paintIcons/icon-m-geom-circle-filled" : "image://paintIcons/icon-m-geom-circle"
        mode: Painter.Circle
        onClicked:
        {
            drawMode = Painter.Geometrics
            geometricsMode = mode
        }
    }

    GeometryButton
    {
        icon.source: geometryFill ? "image://paintIcons/icon-m-geom-ellipse-filled" : "image://paintIcons/icon-m-geom-ellipse"
        mode: Painter.Ellipse
        onClicked:
        {
            drawMode = Painter.Geometrics
            geometricsMode = mode
        }
    }

    GeometryButton
    {
        icon.source: "image://paintIcons/icon-m-geom-fill"
        highlighted: geometryFill
        onClicked:
        {
            /* geometryFillToggled is used as workaround as highlighted iconButton does not follow icon.source
               non-highlighted follows. */

            geometryFillToggled = true
            geometryFill = !geometryFill
            geometryFillToggled = false
        }
    }
}

