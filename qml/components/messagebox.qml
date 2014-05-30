import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle
{
    id: messagebox
    z: 10
    width: parent.width
    height: Theme.itemSizeSmall
    opacity: 0.0
    anchors.centerIn: parent
    color: Theme.highlightBackgroundColor

    function showMessage(message)
    {
        messageboxText.text = message
        messagebox.opacity = 1.0
        messageboxVisibility.start()
    }

    Label
    {
        id: messageboxText
        text: ""
        anchors.centerIn: parent
    }
    Behavior on opacity
    {
        FadeAnimation {}
    }
    Timer
    {
        id: messageboxVisibility
        interval: 3500
        onTriggered: messagebox.opacity = 0.0
    }
}

