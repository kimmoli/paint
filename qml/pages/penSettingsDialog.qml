import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0
import "../components"

import "../code/drawinghelpers.js" as Draw

Dialog
{
    id: penSettingsDialog

    allowedOrientations: Orientation.All

    canAccept: true

    property int currentColor: 0
    property int currentThickness: 0

    onDone:
    {
        if (result === DialogResult.Accepted && currentThickness > 0)
        {
            currentThickness = thicknessSlider.value
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
            acceptText: qsTr("Pen settings")
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
                text: qsTr("Select color")
            }

            ColorSelector
            {
                previewColor: colors[currentColor]
                onPreviewColorChanged:
                {
                    if (drawMode == Painter.Pen)
                        penPreviewCanvas.requestPaint()
                    else
                        previewLine.color = previewColor
                }
                isPortrait: penSettingsDialog.isPortrait
            }

            SectionHeader
            {
                text: qsTr("Pen width")
                visible: currentThickness > 0
            }

            Canvas
            {
                id: penPreviewCanvas
                height: Theme.itemSizeLarge
                width: parent.width
                visible: drawMode == Painter.Pen

                property var brush: "image://paintBrush/" + Brushes.getName(penStyle) + "?" + colors[currentColor]

                onPaint:
                {
                    if (!isImageLoaded(brush))
                    {
                        loadImage(brush)
                    }

                    var ctx = getContext('2d')
                    Draw.clear(ctx)

                    Draw.drawBrush(ctx, width/2 - Theme.itemSizeHuge, 0, width/2 + Theme.itemSizeHuge, 0, brush, 1+(thicknessSlider.value/16))
                }
            }

            Rectangle
            {
                color: "transparent"
                height: Theme.itemSizeMedium
                width: parent.width
                visible: drawMode != Painter.Pen

                Rectangle
                {
                    id: previewLine
                    height: thicknessSlider.value
                    width: parent.width - (2 * Theme.itemSizeMedium)
                    color: colors[currentColor]
                    anchors.centerIn: parent
                }
            }

            Slider
            {
                id: thicknessSlider
                visible: currentThickness > 0
                value: currentThickness
                valueText: value
                minimumValue: 1
                maximumValue: Theme.itemSizeExtraSmall
                stepSize: 1
                width: parent.width - 2*Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                onValueChanged: if (drawMode == Painter.Pen) penPreviewCanvas.requestPaint()
            }

            SectionHeader
            {
                text: qsTr("Brush style")
                visible: drawMode == Painter.Pen
            }

            Repeater
            {
                model: (drawMode == Painter.Pen) ? Brushes : 0

                Item
                {
                    width: parent.width
                    height: Theme.itemSizeMedium

                    Row
                    {
                        height: parent.height
                        spacing: Theme.paddingMedium

                        Switch
                        {
                            checked: index == penStyle
                            automaticCheck: false
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Item
                        {
                            height: parent.height
                            width: height
                            Image
                            {
                                source: "image://paintBrush/" + name + "?" + colors[currentColor]
                                anchors.centerIn: parent
                                scale: Theme.itemSizeSmall/width
                            }
                        }
                        Label
                        {
                            text: name
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    BackgroundItem
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            penStyle = index
                            penPreviewCanvas.requestPaint()
                        }
                    }
                }
            }
        }
    }
}
