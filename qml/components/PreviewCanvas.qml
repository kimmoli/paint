import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../code/drawinghelpers.js" as Draw

Canvas
{
    id: previewCanvas
    z: 11
    anchors.fill: drawingCanvas
    antialiasing: true
    opacity: 1.0
    
    property real downX
    property real downY
    
    property bool clearNow : false
    
    function clear()
    {
        clearNow = true
        requestPaint()
    }
    
    onPaint:
    {
        var ctx = getContext('2d')
        var d
        
        ctx.clearRect(0, 0, width, height);
        if (clearNow)
        {
            clearNow = false
            return
        }
        
        ctx.lineJoin = ctx.lineCap = 'round';
        
        switch (drawMode)
        {
        case Painter.Image:
            if (insertImagePending && insertImagePath.length>0)
            {
                if (drawingCanvas.areaPressed)
                    Draw.drawInsertedImage(ctx, insertImagePath,
                                           panX + drawingCanvas.areagMouseX - previewCanvas.downX,
                                           panY + drawingCanvas.areagMouseY - previewCanvas.downY,
                                           insertedImage.width * pinchScale, insertedImage.height * pinchScale,
                                           accelerometer.angle)
                else
                    Draw.drawInsertedImage(ctx, insertImagePath,
                                           panX, panY,
                                           insertedImage.width * pinchScale, insertedImage.height * pinchScale,
                                           accelerometer.angle)
            }
            break;
            
        case Painter.Geometrics:
            switch(geometricsMode)
            {
            case Painter.Line :
                Draw.drawLine(ctx, downX, downY, drawingCanvas.areagMouseX, drawingCanvas.areagMouseY, drawThickness, colors[drawColor])
                break;
            case Painter.Circle :
                Draw.drawCircle(ctx, downX, downY, drawingCanvas.areagMouseX, drawingCanvas.areagMouseY, drawThickness, colors[drawColor], geometryFill)
                break;
            case Painter.Rectangle :
                Draw.drawRectangle(ctx, downX, downY, drawingCanvas.areagMouseX, drawingCanvas.areagMouseY, drawThickness, colors[drawColor], geometryFill)
                break;
            case Painter.Ellipse :
                Draw.drawEllipse(ctx, downX, downY, drawingCanvas.areagMouseX, drawingCanvas.areagMouseY, drawThickness, colors[drawColor], geometryFill)
                break;
            case Painter.Square :
                Draw.drawSquare(ctx, downX, downY, drawingCanvas.areagMouseX, drawingCanvas.areagMouseY, drawThickness, colors[drawColor], geometryFill)
                break;
                
            default:
                break;
            }
            break;
            
        case Painter.Text:
            if (textEditPending && thisTextEntry.length>0)
            {
                if (drawingCanvas.areaPressed)
                    Draw.drawText(ctx, thisTextEntry, panX + drawingCanvas.areagMouseX - previewCanvas.downX,
                                  panY + drawingCanvas.areagMouseY - previewCanvas.downY,
                                  colors[textColor],
                                  (textFontBold ? "bold " : "") + (textFontItalic ? "italic " : "") + Math.floor(textFontSize*pinchScale) + "px " + textFontName,
                                  accelerometer.angle)
                else
                    Draw.drawText(ctx, thisTextEntry, panX, panY,
                                  colors[textColor],
                                  (textFontBold ? "bold " : "") + (textFontItalic ? "italic " : "") + Math.floor(textFontSize*pinchScale) + "px " + textFontName,
                                  accelerometer.angle)
            }
            break;
            
        case Painter.Dimensioning:
            if (dimensionMoveMode)
            {
                /* Draw the one we are moving */
                d=dimensionModel.get(selectedDimension)
                Draw.drawDimensionLine(ctx, downX, downY, drawingCanvas.areagMouseX, drawingCanvas.areagMouseY,
                                       d["fontColor"], d["font"], d["fontSize"], d["lineColor"], d["lineThickness"],
                                       colors, dimensionScale)
            }
            else
            {
                if (drawingCanvas.areaPressed)
                {
                    /* Draw the new one */
                    Draw.drawDimensionLine(ctx, downX, downY, drawingCanvas.areagMouseX, drawingCanvas.areagMouseY,
                                           textColor, textFont, textFontSize, drawColor, drawThickness,
                                           colors, dimensionScale)
                }
                if ((dimensionPopupVisible || drawingCanvas.areaPressed) && dimensionModel.count > 0)
                {
                    /* Draw the selected one */
                    d=dimensionModel.get(selectedDimension)
                    Draw.drawDimensionLine(ctx, d["x0"], d["y0"], d["x1"], d["y1"],
                                           d["fontColor"], d["font"], d["fontSize"], d["lineColor"], d["lineThickness"],
                                           colors, dimensionScale)
                }
            }
            break;
            
        default:
            break;
        }
    }
}
