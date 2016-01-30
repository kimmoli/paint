import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Column
{
    id: geometryPopup

    property bool geometryFillToggled: false

    Row // polygon/polygram vertices
    {
        anchors.horizontalCenter: parent.horizontalCenter
        visible: geometricsMode == Painter.Polygon || geometricsMode == Painter.Polygram

        IconButton
        {
            icon.source: "image://theme/icon-m-down"
            rotation: rotationSensor.angle
            Behavior on rotation { SmoothedAnimation { duration: 500 } }
            onClicked: if (polyVertices > 4) polyVertices--
        }
        Label
        {
            text: polyVertices
            width: Theme.itemSizeMedium
            height: Theme.itemSizeMedium
            anchors.verticalCenter: parent.verticalCenter
            font.bold: true
            font.pixelSize: Theme.fontSizeLarge
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            rotation: rotationSensor.angle
            Behavior on rotation { SmoothedAnimation { duration: 500 } }
        }
        IconButton
        {
            icon.source: "image://theme/icon-m-up"
            rotation: rotationSensor.angle
            Behavior on rotation { SmoothedAnimation { duration: 500 } }
            onClicked: if (polyVertices < 13) polyVertices++
        }
    }

    Row // Row 1
    {
        spacing: (parent.width - children.length*Theme.iconSizeLarge )/(children.length+1)
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

        GeometryButton
        {
            icon.source: geometryFill ? "image://paintIcons/icon-m-geom-polygon-filled" : "image://paintIcons/icon-m-geom-polygon"
            mode: Painter.Polygon
            autohide: false
        }

        GeometryButton
        {
            icon.source: geometryFill ? "image://paintIcons/icon-m-geom-polygram-filled" : "image://paintIcons/icon-m-geom-polygram"
            mode: Painter.Polygram
            autohide: false
        }

        GeometryButton
        {
            icon.source: geometryFill ? "image://paintIcons/icon-m-geom-arrow-filled" : "image://paintIcons/icon-m-geom-arrow"
            mode: Painter.Arrow
        }

        GeometryButton
        {
            icon.source: geometryFill ? "image://paintIcons/icon-m-geom-freehand-closed-filled" : "image://paintIcons/icon-m-geom-freehand-closed"
            mode: Painter.FreehandClosed
        }
    }

    Row // Row 2
    {
        spacing: (parent.width - children.length*Theme.iconSizeLarge )/(children.length+1)
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
            autohide: false
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
