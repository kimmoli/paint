import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

IconButton
{
    property int mode: Painter.None

    anchors.bottom: parent.bottom
    highlighted: (drawMode === Painter.Geometrics) && (geometricsMode === mode) && !geometryFillToggled
    rotation: rotationSensor.angle
    Behavior on rotation { SmoothedAnimation { duration: 500 } }
}
