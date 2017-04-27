import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../components"

ToolbarButton
{
    icon.source: "image://paintIcons/icon-m-spray"
    mode: Painter.Spray

    onClicked:
    {
        cancelPendingFunctions()
        drawMode = mode
    }
}
