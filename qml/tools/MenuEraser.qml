import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../components"

MenuBase
{
    ToolbarButton
    {
        icon.source: "image://paintIcons/icon-m-eraser"
        mode: Painter.Eraser
    }

    ToolbarButton
    {
        icon.source: "image://theme/icon-m-edit"
        mode: Painter.Pen
        property variant submenu: "../tools/MenuDraw.qml"
    }

    ToolbarButton
    {
        icon.source: "image://paintIcons/icon-m-erasersettings"

        onClicked:
        {
            showToolSettings()
        }
    }
}
