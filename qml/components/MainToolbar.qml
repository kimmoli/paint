import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../tools"

Item
{
    id: mainToolbar
    width: parent.width

    property alias submenusource: submenuloader.source

    Loader
    {
        id: submenuloader
        width: parent.width
        height: parent.height
    }

    ToolbarButton
    {
        anchors.right: parent.right
        hideAllTools: false

        icon.source: "image://theme/icon-m-menu"

        onClicked:
        {
            showAllTools = !showAllTools
        }
    }
}
