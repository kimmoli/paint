import QtQuick 2.0
import Sailfish.Silica 1.0

PullDownMenu
{
    MenuItem
    {
        text: qsTr("Restore system palette")
        onClicked: colors = systemColors.slice()
    }
    MenuItem
    {
        text: qsTr("Load palette")
        onClicked:
        {
            var loadedColors = []
            for (var j=0 ; j<12 ; j++)
                loadedColors[j] = painter.getUserColor(j, colors[j])
            colors = loadedColors.slice()
        }
    }
    MenuItem
    {
        text: qsTr("Save palette")
        onClicked:
        {
            for (var j=0 ; j<12 ; j++)
                painter.setUserColor(j, colors[j])
        }
    }
}
