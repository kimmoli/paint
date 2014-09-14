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
            currentThickness = thicknessSlider.value
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
            acceptText: qsTr("Pen settings")
            Timer
            {
                interval: 2500
                running: true
                onTriggered: dialogHeader.acceptText = dialogHeader.defaultAcceptText
            }
        }

        Column
        {
            id: col
            width: parent.width - Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: dialogHeader.bottom

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

            Rectangle
            {
                color: "transparent"
                height: 80
                width: parent.width

                Rectangle
                {
                    height: thicknessSlider.value
                    width: parent.width - 170
                    color: colors[currentColor]
                    anchors.centerIn: parent
                }
            }

            Slider
            {
                id: thicknessSlider
                value: currentThickness
                valueText: value
                minimumValue: 1
                maximumValue: 25
                stepSize: 1
                width: parent.width - 2*Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
            }

        }
    }
}
