import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

IconButton
{
    property int mode: Painter.None
    property bool autohide: true

    anchors.bottom: parent.bottom
    icon.width: Theme.iconSizeMedium
    icon.height: Theme.iconSizeMedium

    highlighted: (drawMode === Painter.Geometrics) && (geometricsMode === mode) && !geometryFillToggled
    rotation: rotationSensor.angle
    Behavior on rotation { SmoothedAnimation { duration: 500 } }
    onClicked:
    {
        drawMode = Painter.Geometrics
        geometricsMode = mode
        geometryPopupVisible = !autohide
    }
}
