import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../code/drawinghelpers.js" as Draw

Canvas
{
    id: loupeCanvas
    antialiasing: true
    tileSize: Qt.size(100, 100)

    property bool dodge: false

    Behavior on x { NumberAnimation { duration: 500; easing.type: Easing.InOutCubic } }
    Behavior on opacity { FadeAnimation {} }

    onXChanged:
    {
        if (dodge)
            if (x === Theme.paddingLarge || x === Theme.paddingLarge + parent.width/2)
                dodge = false
    }

    onDodgeChanged:
    {
        if (dodge && x === Theme.paddingLarge)
            x = Theme.paddingLarge + parent.width/2
        else if (dodge && x === Theme.paddingLarge + parent.width/2)
            x = Theme.paddingLarge
    }

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

        Draw.drawRectangle(ctx, 0, 0, width, height, 1, "black", true)

        var drawingCtx = drawingCanvas.getContext('2d')
        ctx.drawImage(drawingCtx.getImageData(drawingCanvas.areagMouseX-width/5, drawingCanvas.areagMouseY-height/5,
                      width/2.5, height/2.5), 0, 0, width, height)

        var dimensionCtx = dimensionCanvas.getContext('2d')
        ctx.drawImage(dimensionCtx.getImageData(drawingCanvas.areagMouseX-width/5, drawingCanvas.areagMouseY-height/5,
                      width/2.5, height/2.5), 0, 0, width, height)

        var previewCtx = previewCanvas.getContext('2d')
        ctx.drawImage(previewCtx.getImageData(drawingCanvas.areagMouseX-width/5, drawingCanvas.areagMouseY-height/5,
                      width/2.5, height/2.5), 0, 0, width, height)

        Draw.drawLine(ctx, width/2, 0, width/2, height, 1, "red")
        Draw.drawLine(ctx, 0, height/2, width, height/2, 1, "red")
    }
}
