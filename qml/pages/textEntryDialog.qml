import QtQuick 2.0
import Sailfish.Silica 1.0

import "../code/drawinghelpers.js" as Draw

/* Canvas get borked if closing dialog with vkb visible. */

Dialog
{
    id: textEntryDialog

    allowedOrientations: Orientation.All

    property string newText : ""

    onDone:
    {
        if (result === DialogResult.Accepted)
        {
            newText = ti.text
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
                }
                onTextChanged: previewCanvas.requestPaint()
            }

            Rectangle
            {

                color: "transparent"
                height: textFontSize * 2.4
                width: parent.width

                Canvas
                {
                    id: previewCanvas
                    anchors.fill: parent
                    antialiasing: true

                    property bool clearNow : false
                    property int midX : width / 2
                    property int midY : textFontSize

                    onPaint:
                    {
                        var ctx = getContext('2d')

                        Draw.clear(ctx)

                        if (textBalloonize)
                        {
                            Draw.drawBalloonText(ctx, ti.text, midX, midY, colors[textColor], textFont, textFontSize, colors[drawColor], 0, textBalloonize)
                        }
                        else
                        {
                            Draw.drawText(ctx, ti.text, midX, midY, colors[textColor], textFont, 0)
                        }
                    }
                }
            }

            Row
            {
                anchors.right: parent.right
                spacing: Theme.paddingSmall

                IconButton
                {
                    icon.source: "image://theme/icon-m-sms"
                    highlighted: textBalloonize
                    onClicked:
                    {
                        textBalloonize = ++textBalloonize % 3
                        previewCanvas.requestPaint()
                    }
                    icon.mirror: textBalloonize === 2
                }

                IconButton
                {
                    icon.source: "image://paintIcons/icon-m-toolsettings"
                    enabled: textBalloonize
                    opacity: textBalloonize ? 1.0 : 0.6
                    onClicked:
                    {
                        var SettingsDialog = pageStack.push(Qt.resolvedUrl("../pages/penSettingsDialog.qml"),
                                                               { "currentColor": drawColor,
                                                                 "currentThickness": 0 })

                        SettingsDialog.accepted.connect(function()
                        {
                            drawColor = SettingsDialog.currentColor
                            previewCanvas.requestPaint()
                            if (rememberToolSettings)
                            {
                                painter.setToolSetting("drawColor", drawColor)
                            }
                        })
                    }

                }

                IconButton
                {
                    icon.source: "image://paintIcons/icon-m-textsettings"

                    onClicked:
                    {
                        var SettingsDialog = pageStack.push(Qt.resolvedUrl("../pages/textSettingsDialog.qml"),
                                                             { "currentColor": textColor,
                                                               "currentSize": textFontSize,
                                                               "isBold": textFontBold,
                                                               "isItalic": textFontItalic,
                                                               "fontNameIndex": textFontNameIndex })

                        SettingsDialog.accepted.connect(function()
                        {
                            textColor = SettingsDialog.currentColor
                            textFontSize = SettingsDialog.currentSize
                            textFontBold = SettingsDialog.isBold
                            textFontItalic = SettingsDialog.isItalic
                            textFontNameIndex = SettingsDialog.fontNameIndex
                            previewCanvas.requestPaint()
                            if (rememberToolSettings)
                            {
                                painter.setToolSetting("textColor", textColor)
                                painter.setToolSetting("textFontSize", textFontSize)
                                painter.setToolSetting("textFontBold", textFontBold)
                                painter.setToolSetting("textFontItalic", textFontItalic)
                                painter.setToolSetting("textFontNameIndex", textFontNameIndex)
                            }
                        })
                    }
                }
            }
        }
    }
}
