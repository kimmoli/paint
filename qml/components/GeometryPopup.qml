import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0



Row
{
    id: geometryPopup

    property bool geometryFillToggled: false

    IconButton
    {
        icon.source: "image://paintIcons/icon-m-geom-line"
        anchors.bottom: parent.bottom
        highlighted: (drawMode === Painter.Geometrics) && (geometricsMode === Painter.Line)
        rotation: rotationSensor.angle
        Behavior on rotation { SmoothedAnimation { duration: 500 } }
        onClicked:
        {
            drawMode = Painter.Geometrics
            geometricsMode = Painter.Line
        }
    }

    IconButton
    {
        icon.source: geometryFill ? "image://paintIcons/icon-m-geom-rectangle-filled" : "image://paintIcons/icon-m-geom-rectangle"
        anchors.bottom: parent.bottom
        highlighted: (drawMode === Painter.Geometrics) && (geometricsMode === Painter.Rectangle) && !geometryFillToggled
        rotation: rotationSensor.angle
        Behavior on rotation { SmoothedAnimation { duration: 500 } }
        onClicked:
        {
            drawMode = Painter.Geometrics
            geometricsMode = Painter.Rectangle
        }
    }

    IconButton
    {
        icon.source: geometryFill ? "image://paintIcons/icon-m-geom-circle-filled" : "image://paintIcons/icon-m-geom-circle"
        anchors.bottom: parent.bottom
        highlighted: (drawMode === Painter.Geometrics) && (geometricsMode === Painter.Circle) && !geometryFillToggled
        rotation: rotationSensor.angle
        Behavior on rotation { SmoothedAnimation { duration: 500 } }
        onClicked:
        {
            drawMode = Painter.Geometrics
            geometricsMode = Painter.Circle
        }
    }

    IconButton
    {
        icon.source: geometryFill ? "image://paintIcons/icon-m-geom-ellipse-filled" : "image://paintIcons/icon-m-geom-ellipse"
        anchors.bottom: parent.bottom
        highlighted: (drawMode === Painter.Geometrics) && (geometricsMode === Painter.Ellipse) && !geometryFillToggled
        rotation: rotationSensor.angle
        Behavior on rotation { SmoothedAnimation { duration: 500 } }
        onClicked:
        {
            drawMode = Painter.Geometrics
            geometricsMode = Painter.Ellipse
        }
    }

    IconButton
    {
        icon.source: "image://paintIcons/icon-m-geom-fill"
        anchors.bottom: parent.bottom
        highlighted: geometryFill
        rotation: rotationSensor.angle
        Behavior on rotation { SmoothedAnimation { duration: 500 } }
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

