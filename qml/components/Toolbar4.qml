import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../code/drawinghelpers.js" as Draw

Item
{
    id: toolbar4

    Row
    {
        spacing: (parent.width - children.length*80)/(children.length+1)
        anchors.horizontalCenter: parent.horizontalCenter

        ToolbarButton
        {
            icon.source: "image://theme/icon-m-clipboard"
            mode: Painter.Clipboard

            onClicked:
            {
                previewCanvas.clipboardPreviewImage = false
                cropArea = [ 0,0,0,0 ]
                cancelPendingFunctions()
                drawMode = mode
                previewCanvas.requestPaint()
            }
        }

        ToolbarButton
        {
            icon.source: previewCanvas.clipboardPreviewImage ? "image://theme/icon-m-enter-accept" : "image://theme/icon-m-add"
            enabled: clipboardImage != null

            onClicked:
            {
                if (previewCanvas.clipboardPreviewImage)
                {
                    var ctx = drawingCanvas.getContext('2d')
                    Draw.drawImageData(ctx, clipboardImage, panX, panY, accelerometer.angle)

                    drawingCanvas.requestPaint()
                    previewCanvas.clipboardPreviewImage = false
                    previewCanvas.clear()
                }
                else
                {
                    previewCanvas.clear()
                    panX = previewCanvas.width/2
                    panY = previewCanvas.height/2
                    previewCanvas.clipboardPreviewImage = true
                    previewCanvas.requestPaint()
                }
            }
        }
        ToolbarButton
        {
            icon.source: "image://theme/icon-m-clear"
            enabled: clipboardImage != null

            onClicked:
            {
                previewCanvas.clipboardPreviewImage = false
                previewCanvas.clear()
                clipboardImage = null
                cropArea = [ 0,0,0,0 ]
            }
        }

    }
}
