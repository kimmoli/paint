import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

IconButton
{
    property int mode: Painter.None

    highlighted: drawMode === mode
    icon.width: Theme.iconSizeMedium
    icon.height: Theme.iconSizeMedium

    rotation: rotationSensor.angle
    Behavior on rotation { SmoothedAnimation { duration: 500 } }

    onClicked:
    {
        console.log("clicked")
    }
}
