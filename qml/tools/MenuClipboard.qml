import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../components"
import "../code/drawinghelpers.js" as Draw

MenuBase
{
    ToolbarButton
    {
        icon.source: "image://theme/icon-m-scale"
        mode: Painter.Clipboard

        onClicked:
        {
            cancelPendingFunctions()
            cropArea = [ 0,0,0,0 ]
            drawMode = mode
            previewCanvas.requestPaint()
        }
    }

    ToolbarButton
    {
        icon.source: "image://theme/icon-m-add"
        enabled: clipboardImage != null

        onClicked:
        {
            insertImagePath = clipboardCanvas.toDataURL()

            cancelPendingFunctions()
            drawMode = Painter.Clipboard
            previewCanvas.clear()
            pinchtarget.scale = 1.0
            panX = previewCanvas.width/2
            panY = previewCanvas.height/2
            clipboardPastePending = true
            previewCanvas.requestPaint()
        }
    }

    ToolbarButton
    {
        icon.source: "image://theme/icon-m-enter-accept"
        enabled: clipboardImage != null && clipboardPastePending

        onClicked:
        {
            var ctx = drawingCanvas.getContext('2d')
            Draw.drawImageData(ctx, clipboardImage, panX, panY, accelerometer.angle, pinchScale)

            drawingCanvas.requestPaint()
            clipboardPastePending = false
            previewCanvas.clear()
        }
    }

    ToolbarButton
    {
        icon.source: "image://theme/icon-m-reset"
        enabled: clipboardImage != null && clipboardPastePending

        onClicked:
        {
            clipboardPastePending = false
            previewCanvas.clear()
        }
    }

    Image
    {
        source: insertImagePath
        visible: clipboardImage != null
        width: Theme.itemSizeMedium
        height: Theme.itemSizeMedium
        fillMode: Image.PreserveAspectFit
    }
}
