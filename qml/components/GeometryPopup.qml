import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Row
{
    id: geometryPopup

    IconButton
    {
        icon.source: "image://paintIcons/icon-m-geom-line"
        anchors.bottom: parent.bottom
        highlighted: (drawMode === Painter.Geometrics) && (geometricsMode === Painter.Line)

        onClicked:
        {
            console.log("Geometrics mode select")
            drawMode = Painter.Geometrics
            geometricsMode = Painter.Line
            geometryPopup.visible = false
        }
    }

    IconButton
    {
        icon.source: "image://paintIcons/icon-m-geom-rectangle"
        anchors.bottom: parent.bottom
        highlighted: (drawMode === Painter.Geometrics) && (geometricsMode === Painter.Rectangle)

        onClicked:
        {
            console.log("Geometrics mode select")
            drawMode = Painter.Geometrics
            geometricsMode = Painter.Rectangle
            geometryPopup.visible = false
        }
    }

    IconButton
    {
        icon.source: "image://paintIcons/icon-m-geom-circle"
        anchors.bottom: parent.bottom
        highlighted: (drawMode === Painter.Geometrics) && (geometricsMode === Painter.Circle)

        onClicked:
        {
            console.log("Geometrics mode select")
            drawMode = Painter.Geometrics
            geometricsMode = Painter.Circle
            geometryPopup.visible = false
        }
    }

}
