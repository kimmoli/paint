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

    function showMessage(message, delay)
    {
        messageboxText.text = message
        messagebox.opacity = 1.0
        messageboxVisibility.interval = (delay>0) ? delay : 3000
        messageboxVisibility.restart()
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
        interval: 3000
        onTriggered: messagebox.opacity = 0.0
    }
    BackgroundItem
    {
        anchors.fill: parent
        onClicked:
        {
            messageboxVisibility.stop()
            messagebox.opacity = 0.0
        }
    }
}

