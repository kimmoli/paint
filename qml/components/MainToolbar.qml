import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Item
{
    id: mainToolbar

    Row
    {
        spacing: (parent.width - children.length*Theme.iconSizeLarge )/(children.length+1)
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle { width: Theme.itemSizeMedium; height: Theme.itemSizeMedium }
        Rectangle { width: Theme.itemSizeMedium; height: Theme.itemSizeMedium }
        Rectangle { width: Theme.itemSizeMedium; height: Theme.itemSizeMedium }
        Rectangle { width: Theme.itemSizeMedium; height: Theme.itemSizeMedium }
        Rectangle { width: Theme.itemSizeMedium; height: Theme.itemSizeMedium }

        ToolbarButton
        {
            icon.source: "image://theme/icon-m-menu"

            onClicked:
            {
                showAllTools = !showAllTools
            }
        }

    }
}
