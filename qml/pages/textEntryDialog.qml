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
        }

        Column
        {
            id: col
            width: parent.width - Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: dialogHeader.bottom

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
                onTextChanged: previewCanvas.requestPaint()
            }
            Rectangle
            {

                color: "transparent"
                height: 150
                width: parent.width
                Canvas
                {
                    id: previewCanvas
                    anchors.fill: parent
                    renderTarget: Canvas.FramebufferObject
                    antialiasing: true

                    property bool clearNow : false
                    property int midX : width / 2
                    property int midY : height * 0.75

                    onPaint:
                    {
                        var ctx = getContext('2d')

                        ctx.clearRect(0, 0, width, height);
                        ctx.fillStyle = colors[textColor]
                        ctx.font = textFont
                        ctx.textAlign = "center"
                        ctx.fillText(ti.text, midX, midY)
                    }
                }
            }
            IconButton
            {
                icon.source: "image://paintIcons/icon-m-textsettings"
                anchors.right: parent.right

                onClicked:
                {
                    var SettingsDialog = pageStack.push(Qt.resolvedUrl("../pages/textSettingsDialog.qml"),
                                                         { "currentColor": textColor,
                                                           "currentSize": textFontSize,
                                                           "isBold": textFontBold,
                                                           "isItalic": textFontItalic })

                    SettingsDialog.accepted.connect(function()
                    {
                        textColor = SettingsDialog.currentColor
                        textFontSize = SettingsDialog.currentSize
                        textFontBold = SettingsDialog.isBold
                        textFontItalic = SettingsDialog.isItalic
                        previewCanvas.requestPaint()
                    })
                }
            }
        }
    }
}
