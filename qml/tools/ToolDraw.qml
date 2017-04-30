import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../components"

ToolbarButton
{
    icon.source: "image://theme/icon-m-edit"
    mode: Painter.Pen

    onClicked:
    {
        cancelPendingFunctions()
    }
}
