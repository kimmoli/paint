import QtQuick 2.0
import Sailfish.Silica 1.0

/* Canvas get borked if closing dialog with vkb visible. */

Dialog
{
    id: textEntryDialog
    canAccept: ti.focus === false

    property string newText : ""

    onDone:
    {
        if (result === DialogResult.Accepted)
        {
            newText = ti.text
        }
    }

    Timer
    {
        id: vkbClose
        interval: 500
        onTriggered: textEntryDialog.accept()
    }

    DialogHeader
    {
        id: pageHeader
        title:  qsTr("Text entry")
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
            text: qsTr("Enter some text")
        }

        TextField
        {
            id: ti
            width: parent.width
            focus: true
            placeholderText: qsTr("Enter some text")
            EnterKey.iconSource: "image://theme/icon-m-enter-accept"
            EnterKey.onClicked:
            {
                ti.focus = false
                vkbClose.start()
            }
        }
    }
}
