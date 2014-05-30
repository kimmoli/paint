import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle
{
    id: messagebox
    z: 10
    width: 400
    height: 200
    radius: 40
    opacity: 0.0
    anchors.centerIn: parent
    color: Theme.secondaryHighlightColor

    property alias message: messageboxText.text

    onMessageChanged:
    {
        messagebox.opacity = 0.95
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

