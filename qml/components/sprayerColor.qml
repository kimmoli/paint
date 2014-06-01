import QtQuick 2.0
import Sailfish.Silica 1.0

Column
{
    id: sprayerColor

    SectionHeader
    {
        text: qsTr("Select color")
    }

    Grid
    {
        id: colorSelector
        columns: 4
        Repeater
        {
            model: colors
            Rectangle
            {
                width: col.width/colorSelector.columns
                height: col.width/colorSelector.columns
                radius: 10
                color: (index == currentColor) ? colors[index] : "transparent"
                Rectangle
                {
                    width: parent.width - 20
                    height: parent.height - 20
                    radius: 5
                    color: colors[index]
                    anchors.centerIn: parent
                }
                BackgroundItem
                {
                    anchors.fill: parent
                    onClicked: currentColor = index
                }
            }
        }
    }
}
