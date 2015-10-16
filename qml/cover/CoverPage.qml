import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground
{
    Column
    {
        anchors.top: parent.top
        anchors.topMargin: (parent.height - im.height - label.height - label.anchors.topMargin) / 2
        width: parent.width
        spacing: Theme.paddingMedium

        Image
        {
            id: im
            source: "/usr/share/icons/hicolor/86x86/apps/harbour-paint.png"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Label
        {
            id: label
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Paint"
        }
        Image
        {
            id: childsplay
            visible: childsPlayMode
            source: "image://theme/icon-m-device-lock"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}


