import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog
{
    id: bgSettingsDialog
    canAccept: true

    property int currentBg: 0

    DialogHeader
    {
        id: pageHeader
        title: qsTr("Select background")
        acceptText: acceptText
        cancelText: cancelText
    }

    Column
    {
        id: col
        width: parent.width - Theme.paddingLarge
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: pageHeader.bottom

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
                    color: (index == currentBg) ? colors[index] : "transparent"
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
                        onClicked: currentBg = index
                    }
                }
            }
        }

        TextSwitch
        {
            id: ts
            text: qsTr("None")
            checked: currentBg == colors.length
            automaticCheck: false
            onDownChanged:
            {
                if (down)
                    currentBg = colors.length
            }

        }
    }
}
