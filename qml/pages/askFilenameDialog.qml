import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog
{
    id: askFilenameDialog

    allowedOrientations: Orientation.All

    canAccept: ti.text.length > 0

    property string filename : ""
    property string saveFormat : ""
    property bool crop : false

    onDone:
    {
        if (result === DialogResult.Accepted)
        {
            /* todo: add checks that filename is valid */
            filename = ti.text
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
                text: qsTr("Enter filename") + " (." + saveFormat + ")"
            }

            TextField
            {
                id: ti
                width: parent.width
                focus: true
                placeholderText: qsTr("Enter filename")
                EnterKey.iconSource: "image://theme/icon-m-enter-accept"
                EnterKey.onClicked: askFilenameDialog.accept()
                onTextChanged: fileExistsNotification.opacity = painter.fileExists(ti.text) ? 0.4 : 0.0

                Rectangle
                {
                    id: fileExistsNotification
                    anchors.fill: parent
                    color: "red"
                    opacity: 0
                    Behavior on opacity { NumberAnimation { duration: 200 } }
                }
                Label
                {
                    anchors.top: fileExistsNotification.bottom
                    anchors.left: fileExistsNotification.left
                    color: Theme.highlightColor
                    text: qsTr("File already exists")
                    opacity: fileExistsNotification.opacity * 3
                    font.bold: true
                }
            }

            IconTextSwitch
            {
                icon.source: "image://theme/icon-m-crop"
                text: qsTr("Crop before saving")
                onCheckedChanged: crop = checked
            }

        }
    }
}
