import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Column
{
    id: geometryPopup

    property bool geometryFillToggled: false

    Row // Row 1
    {
        spacing: (parent.width - children.length*80)/(children.length+1)
        anchors.horizontalCenter: parent.horizontalCenter

        GeometryButton
        {
            icon.source: geometryFill ? "image://paintIcons/icon-m-geom-etriangle-filled" : "image://paintIcons/icon-m-geom-etriangle"
            mode: Painter.EquilateralTriangle
        }

        GeometryButton
        {
            icon.source: geometryFill ? "image://paintIcons/icon-m-geom-ritriangle-filled" : "image://paintIcons/icon-m-geom-ritriangle"
            mode: Painter.RightIsoscelesTriangle
        }
    }

    Row // Row 2
    {
        spacing: (parent.width - children.length*80)/(children.length+1)
        anchors.horizontalCenter: parent.horizontalCenter

        GeometryButton
        {
            icon.source: "image://paintIcons/icon-m-geom-line"
            mode: Painter.Line
        }

        GeometryButton
        {
            icon.source: geometryFill ? "image://paintIcons/icon-m-geom-rectangle-filled" : "image://paintIcons/icon-m-geom-rectangle"
            mode: Painter.Rectangle
        }

        GeometryButton
        {
            icon.source: geometryFill ? "image://paintIcons/icon-m-geom-square-filled" : "image://paintIcons/icon-m-geom-square"
            mode: Painter.Square
        }

        GeometryButton
        {
            icon.source: geometryFill ? "image://paintIcons/icon-m-geom-circle-filled" : "image://paintIcons/icon-m-geom-circle"
            mode: Painter.Circle
        }

        GeometryButton
        {
            icon.source: geometryFill ? "image://paintIcons/icon-m-geom-ellipse-filled" : "image://paintIcons/icon-m-geom-ellipse"
            mode: Painter.Ellipse
        }

        GeometryButton
        {
            icon.source: "image://paintIcons/icon-m-geom-fill"
            highlighted: geometryFill
            mode: geometricsMode
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

}
