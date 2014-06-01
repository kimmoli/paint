import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog
{
    id: eraserSettingsDialog
    canAccept: true

    property int currentThickness: 0

    onDone:
    {
        if (result === DialogResult.Accepted)
        {
            currentThickness = thicknessSlider.value
        }
    }


    DialogHeader
    {
        id: pageHeader
        title:  qsTr("Eraser settings")
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
            text: qsTr("Eraser size")
        }

        Rectangle
        {
            color: "transparent"
            height: 300
            width: parent.width

            Rectangle
            {
                height: thicknessSlider.value
                width: thicknessSlider.value
                radius: thicknessSlider.value/2
                color: "white"
                anchors.centerIn: parent
            }
        }

        Slider
        {
            id: thicknessSlider
            value: currentThickness
            valueText: value
            minimumValue: 3
            maximumValue: 100
            stepSize: 1
            width: parent.width - 2*Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
        }

    }
}
