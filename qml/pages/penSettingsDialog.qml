import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

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

            ColorSelector
            {
                previewColor: colors[currentColor]
                onPreviewColorChanged: previewLine.color = previewColor
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
                    id: previewLine
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
