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
            drawMode = Painter.Geometrics
            geometricsMode = Painter.Line
        }
    }

    IconButton
    {
        icon.source: "image://paintIcons/icon-m-geom-rectangle"
        anchors.bottom: parent.bottom
        highlighted: (drawMode === Painter.Geometrics) && (geometricsMode === Painter.Rectangle)

        onClicked:
        {
            drawMode = Painter.Geometrics
            geometricsMode = Painter.Rectangle
        }
    }

    IconButton
    {
        icon.source: "image://paintIcons/icon-m-geom-rectangle-filled"
        anchors.bottom: parent.bottom
        highlighted: (drawMode === Painter.Geometrics) && (geometricsMode === Painter.RectangleFilled)

        onClicked:
        {
            drawMode = Painter.Geometrics
            geometricsMode = Painter.RectangleFilled
        }
    }


    IconButton
    {
        icon.source: "image://paintIcons/icon-m-geom-circle"
        anchors.bottom: parent.bottom
        highlighted: (drawMode === Painter.Geometrics) && (geometricsMode === Painter.Circle)

        onClicked:
        {
            drawMode = Painter.Geometrics
            geometricsMode = Painter.Circle
        }
    }

    IconButton
    {
        icon.source: "image://paintIcons/icon-m-geom-circle-filled"
        anchors.bottom: parent.bottom
        highlighted: (drawMode === Painter.Geometrics) && (geometricsMode === Painter.CircleFilled)

        onClicked:
        {
            drawMode = Painter.Geometrics
            geometricsMode = Painter.CircleFilled
        }
    }

}

