import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

IconButton
{
    property int mode: Painter.NotSet
    property bool hideAllTools: true

    highlighted: drawMode === mode
    icon.width: Theme.iconSizeMedium
    icon.height: Theme.iconSizeMedium
    anchors.verticalCenter: parent.verticalCenter

    rotation: rotationSensor.angle
    Behavior on rotation { SmoothedAnimation { duration: 500 } }

    onClicked:
    {
        if (mode !== Painter.NotSet)
        {
            if (drawMode === mode)
                drawMode = Painter.None
            else
                drawMode = mode
        }

        if (typeof submenu !== "undefined" && submenu != "")
        {
            mainToolBar.submenusource = submenu
        }

        if (hideAllTools)
            showAllTools = false
    }
}
