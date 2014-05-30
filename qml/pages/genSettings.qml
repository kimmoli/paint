import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog
{
    id: genSettingsDialog
    canAccept: true

    property string saveFormat : "NaN"

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
        title:  buttonhelptext[6]
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

        TextSwitch
        {
            id: tsJpg
            text: "JPG"
            checked: saveFormat === "jpg"
            automaticCheck: false
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
            onDownChanged:
            {
                if (down)
                    saveFormat = "png"
            }
        }

    }
}
