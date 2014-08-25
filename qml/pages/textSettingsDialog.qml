import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog
{
    id: textSettingsDialog
    canAccept: true

    property int currentColor: 0
    property int currentSize: 40
    property bool isBold: false
    property bool isItalic: false
    property int fontNameIndex: 0

    onDone:
    {
        if (result === DialogResult.Accepted)
        {
            currentSize = sizeSlider.value
            isBold = tsBold.checked
            isItalic = tsItalic.checked
        }
    }

    SilicaFlickable
    {
        id: flick

        anchors.fill: parent
        contentHeight: dialogHeader.height + col.height
        width: parent.width

        VerticalScrollDecorator { flickable: flick }

        DialogHeader
        {
            id: dialogHeader
        }


        Column
        {
            id: col
            width: parent.width - Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: dialogHeader.bottom

            SectionHeader
            {
                text: qsTr("Text settings")
                font.pixelSize: Theme.fontSizeLarge
            }

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
                text: qsTr("Font size")
            }

            Slider
            {
                id: sizeSlider
                value: currentSize
                valueText: value
                minimumValue: 10
                maximumValue: 100
                stepSize: 1
                width: parent.width - 2*Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row
            {
                width: parent.width

                TextSwitch
                {
                    id: tsBold
                    text: qsTr("Bold")
                    checked: isBold
                    width: parent.width/2
                }
                TextSwitch
                {
                    id: tsItalic
                    text: qsTr("Italic")
                    checked: isItalic
                    width: parent.width/2
                }
            }

            SectionHeader
            {
                text: qsTr("Font")
            }

            Repeater
            {
                model: fontList
                TextSwitch
                {
                    text: fontList.get(index)["name"]
                    width: parent.width
                    automaticCheck: false
                    checked: index === fontNameIndex
                    onClicked: fontNameIndex = index
                }
            }

        }
    }
}
