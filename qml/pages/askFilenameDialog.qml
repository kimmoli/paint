import QtQuick 2.0
import Sailfish.Silica 1.0

/* Canvas get borked if closing dialog with vkb visible. */

Dialog
{
    id: askFilenameDialog

    allowedOrientations: Orientation.All

    canAccept: ti.focus === false
    backNavigation: ti.focus === false

    property string filename : ""
    property string saveFormat : ""

    onDone:
    {
        if (result === DialogResult.Accepted)
        {
            /* todo: add checks that filename is valid */
            filename = ti.text
        }
    }

    Timer
    {
        id: vkbClose
        interval: 500
        onTriggered: askFilenameDialog.accept()
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
                text: qsTr("Enter filename") + "(." + saveFormat + ")"
            }

            TextField
            {
                id: ti
                width: parent.width
                focus: true
                placeholderText: qsTr("Enter filename")
                EnterKey.iconSource: "image://theme/icon-m-enter-accept"
                EnterKey.onClicked:
                {
                    ti.focus = false
                    vkbClose.start()
                }
                onTextChanged: fileExistsNotification.visible = painter.fileExists(ti.text)
            }
            Label
            {
                id: fileExistsNotification
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("File already exists")
                visible: false
            }
        }
    }
}
