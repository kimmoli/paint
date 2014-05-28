import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground
{
    Image
    {
        id: im
        source: "/usr/share/icons/hicolor/86x86/apps/paint.png"
        anchors.top: parent.top
        anchors.topMargin: (parent.height - im.height - label.height - label.anchors.topMargin) / 2
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Label
    {
        id: label
        anchors.top: im.bottom
        anchors.topMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Paint"
    }
}


