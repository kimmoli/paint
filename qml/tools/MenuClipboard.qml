import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../components"
import "../code/drawinghelpers.js" as Draw

MenuBase
{
    ToolbarButton
    {
        icon.source: clipboardPastePending ? "image://theme/icon-m-enter-accept" : "image://theme/icon-m-add"
        enabled: clipboardImage != null

        onClicked:
        {
            if (clipboardPastePending)
            {
                var ctx = drawingCanvas.getContext('2d')
                Draw.drawImageData(ctx, clipboardImage, panX, panY, accelerometer.angle, pinchScale)

                drawingCanvas.requestPaint()
                clipboardPastePending = false
                previewCanvas.clear()
            }
            else
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
    }
}
