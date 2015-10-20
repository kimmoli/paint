import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Item
{
    id: toolbar2

    Row
    {
        spacing: (parent.width - children.length*80)/(children.length+1)
        anchors.horizontalCenter: parent.horizontalCenter

        ToolbarButton
        {
            icon.source: "image://paintIcons/icon-m-texttool"
            mode: Painter.Text

            onClicked:
            {
                if (textEditPending)
                {
                    textEditCancel()
                }
                else
                {
                    cancelPendingFunctions()
                    var textEntryDialog = pageStack.push(Qt.resolvedUrl("../pages/textEntryDialog.qml"))

                    textEntryDialog.accepted.connect(function()
                    {
                        thisTextEntry = textEntryDialog.newText
                        if (thisTextEntry.length>0)
                        {
                            drawMode = mode
                            previewCanvasDrawText()
                        }
                    })
                }
            }
        }

        ToolbarButton
        {
            icon.source: "image://paintIcons/icon-m-addimage"
            mode: Painter.Image

            onClicked:
            {
                if (insertImagePending)
                {
                    insertImageCancel()
                }
                else
                {
                    cancelPendingFunctions()
                    var imagePicker = pageStack.push("Sailfish.Pickers.ImagePickerPage", { "allowedOrientations" : Orientation.All });
                    imagePicker.selectedContentChanged.connect(function()
                    {
                        insertImagePath = "image://paintImage/" + imagePicker.selectedContent
                        drawMode = mode
                        previewCanvasDrawImage()
                    });
                }
            }
        }

        ToolbarButton
        {
            icon.source: "image://theme/icon-m-enter-accept"
            enabled: textEditPending || insertImagePending

            onClicked:
            {
                if (textEditPending)
                    textEditAccept()
                else if (insertImagePending)
                    insertImageAccept()
            }
        }

        ToolbarButton
        {
            icon.source: "image://paintIcons/icon-m-dimensiontool"
            mode: Painter.Dimensioning

            onClicked:
            {
                if (drawMode != mode)
                {
                    drawingCanvas.saveActive()
                    dimensionPopupVisible = true
                }
                else
                {
                    dimensionPopupVisible = !dimensionPopupVisible
                }

                cancelPendingFunctions()
                drawMode = mode

                if (!dimensionPopupVisible)
                    dimensionMoveMode = false

                previewCanvas.requestPaint()
                dimensionCanvas.requestPaint()
            }

            onHighlightedChanged: if (!highlighted) dimensionPopupVisible = false
        }

        ToolbarButton
        {
            icon.source: "image://paintIcons/icon-m-grid"

            onClicked: toggleGridVisibility()
        }

        ToolbarButton
        {
            id: toolSettingsButton
            icon.source:
            {
                if (drawMode == Painter.Text)
                    return "image://paintIcons/icon-m-textsettings"
                if (drawMode == Painter.Eraser)
                    return "image://paintIcons/icon-m-erasersettings"
                return "image://paintIcons/icon-m-toolsettings"
            }

            onClicked:
            {
                showToolSettings()
            }
        }
    }
}
