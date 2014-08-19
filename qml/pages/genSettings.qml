import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog
{
    id: genSettingsDialog
    canAccept: true

    property string saveFormat : "NaN"
    property string toolboxLocation : "NaN"
    property int gridSpacing : 50
    property bool gridSnapTo : false

    onAccepted:
    {
        gridSpacing = gridSpacingSlider.value
        gridSnapTo = gridSnapSwitch.checked
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
                text: qsTr("General settings")
                font.pixelSize: Theme.fontSizeLarge
            }

            SectionHeader
            {
                text: qsTr("File format")
            }

            Row
            {
                width: parent.width

                TextSwitch
                {
                    id: tsJpg
                    text: "JPG"
                    checked: saveFormat === "jpg"
                    automaticCheck: false
                    width: parent.width/2
                    onDownChanged:
                    {
                        if (down)
                            saveFormat = "jpg"

                    }
                }
                TextSwitch
                {
                    id: tsPng
                    text: "PNG"
                    checked: saveFormat === "png"
                    automaticCheck: false
                    width: parent.width/2
                    onDownChanged:
                    {
                        if (down)
                            saveFormat = "png"
                    }
                }
            }

            SectionHeader
            {
                text: qsTr("Toolbox location")
            }

            Row
            {
                width: parent.width

                TextSwitch
                {
                    id: tsTop
                    text: qsTr("Top")
                    checked: toolboxLocation === "toolboxTop"
                    automaticCheck: false
                    width: parent.width/2
                    onDownChanged:
                    {
                        if (down)
                            toolboxLocation = "toolboxTop"

                    }
                }
                TextSwitch
                {
                    id: tsBot
                    text: qsTr("Bottom")
                    checked: toolboxLocation === "toolboxBottom"
                    automaticCheck: false
                    width: parent.width/2
                    onDownChanged:
                    {
                        if (down)
                            toolboxLocation = "toolboxBottom"
                    }
                }
            }

            SectionHeader
            {
                text: qsTr("Grid settings")
            }


            TextSwitch
            {
                id: gridSnapSwitch
                text: qsTr("Snap to Grid")
                checked: gridSnapTo
                width: parent.width
            }

            Slider
            {
                id: gridSpacingSlider
                label: qsTr("Grid spacing")
                width: parent.width
                value: gridSpacing
                valueText: value
                minimumValue: 20
                maximumValue: 100
                stepSize: 1
            }


        }
    }
}
