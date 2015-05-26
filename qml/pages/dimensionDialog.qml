import QtQuick 2.0
import Sailfish.Silica 1.0

/* Canvas get borked if closing dialog with vkb visible. */

Dialog
{
    id: dimensionDialog

    allowedOrientations: Orientation.All

    canAccept: (Number(ti.text.replace(",","."))>0)

    property real currentDimensionScale : 1.0
    property real currentDimension: 0
    property variant d

    Component.onCompleted:
    {
        d = dimensionModel.get(selectedDimension)
        currentDimension = Math.sqrt(Math.pow(Math.abs(d["x1"]-d["x0"]), 2) + Math.pow(Math.abs(d["y1"]-d["y0"]), 2))
    }

    onDone:
    {
        if (result === DialogResult.Accepted)
        {
            currentDimensionScale = currentDimension / Number(ti.text.replace(",","."))
        }
    }

    Label
    {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        color: ti.focus ? "yellow" : "transparent"
        font.pixelSize: Theme.fontSizeMedium
        font.bold: true
        text: qsTr("Warning: Do not cancel now")
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
            acceptText: qsTr("Dimensioning")
            Timer
            {
                interval: 2500
                running: true
                onTriggered: dialogHeader.acceptText = dialogHeader.defaultAcceptText
            }
        }

        Column
        {
            id: col
            width: parent.width - Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: dialogHeader.bottom

            SectionHeader
            {
                text: qsTr("Scale all dimensions")
            }
            Label
            {
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                text: qsTr("Reference length %1").arg(currentDimension.toFixed(2))
            }
            Label
            {
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                text: qsTr("Currently scaled length %1").arg(Number(currentDimension / currentDimensionScale).toFixed(2))
            }

            TextField
            {
                id: ti
                width: parent.width
                focus: true
                placeholderText: qsTr("Enter true length")
                text: Number(currentDimension / currentDimensionScale).toFixed(2)
                validator: RegExpValidator { regExp: /\d+([,|\.]?\d+)?/ }

                EnterKey.iconSource: "image://theme/icon-m-enter-accept"
                EnterKey.enabled: Number(text.replace(",","."))>0
                EnterKey.onClicked:
                {
                    ti.focus = false
                }
                inputMethodHints: Qt.ImhDigitsOnly
            }
        }
    }
}
