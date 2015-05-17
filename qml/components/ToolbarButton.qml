import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

IconButton
{
    property int mode: Painter.None

    highlighted: drawMode === mode
    anchors.bottom: parent.bottom
    rotation: rotationSensor.angle
    Behavior on rotation { SmoothedAnimation { duration: 500 } }
}
