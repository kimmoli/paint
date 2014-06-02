import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog
{
    id: genSettingsDialog
    canAccept: true

    property string saveFormat : "NaN"
    property string toolboxLocation : "NaN"

    DialogHeader
    {
        id: pageHeader
        title:  qsTr("General settings")
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

    }
}
