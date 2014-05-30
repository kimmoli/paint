import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog
{
    id: penSettingsDialog
    canAccept: true

    property int currentColor: 0
    property int currentThickness: 0

    onDone:
    {
        if (result === DialogResult.Accepted)
        {
            console.log("dialog accepted")
        }
    }

    DialogHeader
    {
        id: pageHeader
        title:  buttonhelptext[4]
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

        SectionHeader
        {
            text: qsTr("Pen width")
        }

        Repeater
        {
            model: thicknesses

            Row
            {
                spacing: col.width - ts.width - 250
                TextSwitch
                {
                    id: ts
                    text: thicknesses[index]
                    checked: index == currentThickness
                    automaticCheck: false
                    onDownChanged:
                    {
                        if (down)
                            currentThickness = index
                    }
                }
                Rectangle
                {
                    height: thicknesses[index]
                    width: 250
                    color: colors[currentColor]
                    anchors.verticalCenter: ts.verticalCenter
                }
            }
        }
    }
}
