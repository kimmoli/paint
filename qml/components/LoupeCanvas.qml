import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../code/drawinghelpers.js" as Draw

Canvas
{
    id: loupeCanvas
    antialiasing: true

    Behavior on opacity { FadeAnimation {} }

    Component.onCompleted:
    {
        width = Math.min(parent.width, parent.height)/2 - 2*Theme.paddingLarge
        height = width
        x = Theme.paddingLarge
        y = Theme.paddingLarge
        requestPaint()
    }

    onPaint:
    {
        var ctx = getContext('2d')

        Draw.drawRectangle(ctx, 0, 0, width-1, height-1, 1, "black", true)

        var ctxd = drawingCanvas.getContext('2d')

        // zoom x2.5
        ctx.drawImage(ctxd.getImageData(
                      drawingCanvas.areagMouseX-width/5,
                      drawingCanvas.areagMouseY-height/5,
                      width/2.5,
                      height/2.5),
                      0,
                      0,
                      width,
                      height)

        Draw.drawLine(ctx, width/2, 0, width/2, height, 1, "red")
        Draw.drawLine(ctx, 0, height/2, width, height/2, 1, "red")
    }
}
