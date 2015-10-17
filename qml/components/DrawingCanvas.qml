import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../code/drawinghelpers.js" as Draw

Canvas
{
    id: drawingCanvas
    z: 9

    property var _start: 0
    
    Component.onCompleted:
    {
        width = parent.width
        height = parent.height
        tileSize = Qt.size(width/10, height/10)
        requestPaint()
    }

    antialiasing: true
    
    property real lastX
    property real lastY
    property real angle
    property real radius
    
    property bool clearNow : false

    property alias areaPressed: area.pressed
    property alias areaPressedAndHolded: area.pressedAndHolded
    property alias areagMouseX: area.gMouseX
    property alias areagMouseY: area.gMouseY
    
    function clear()
    {
        clearNow = true
        requestPaint()
    }

    function setOptions()
    {
        var ctx = getContext('2d')

        ctx.lineJoin = ctx.lineCap = 'round';
        ctx.globalCompositeOperation = 'source-over'

        switch (drawMode)
        {
        case Painter.Eraser :
        case Painter.Pen :
            if (drawMode === Painter.Eraser)
                ctx.globalCompositeOperation = 'destination-out'
            ctx.lineWidth = (drawMode === Painter.Eraser) ? eraserThickness : drawThickness
            ctx.strokeStyle = colors[drawColor]
            break;

        default:
            break;
        }
    }
    
    onPaint:
    {
        var ctx = getContext('2d')
        
        if (clearNow)
        {
            Draw.clear(ctx)
            clearNow = false
            return
        }
        
        switch (drawMode)
        {
        case Painter.Eraser :
        case Painter.Pen :
            ctx.beginPath()
            ctx.moveTo(lastX, lastY)
            lastX = area.gMouseX
            lastY = area.gMouseY
            ctx.lineTo(lastX, lastY)
            ctx.stroke()
            break;
            
        case Painter.Spray :
            for (var i = sprayerDensity; i--; )
            {
                angle = getRandomFloat(0, Math.PI*2)
                radius = getRandomFloat(1, sprayerRadius)
                ctx.fillStyle = colors[sprayerColor]
                ctx.fillRect(lastX + radius * Math.cos(angle), lastY + radius * Math.sin(angle), sprayerParticleSize, sprayerParticleSize)
            }
            break;
            
        case Painter.Geometrics :
            switch(geometricsMode)
            {
            case Painter.Line :
                Draw.drawLine(ctx, previewCanvas.downX, previewCanvas.downY, area.gMouseX, area.gMouseY, drawThickness, colors[drawColor])
                break;
            case Painter.Circle :
                Draw.drawCircle(ctx, previewCanvas.downX, previewCanvas.downY, area.gMouseX, area.gMouseY, drawThickness, colors[drawColor], geometryFill)
                break;
            case Painter.Rectangle :
                Draw.drawRectangle(ctx, previewCanvas.downX, previewCanvas.downY, area.gMouseX, area.gMouseY, drawThickness, colors[drawColor], geometryFill)
                break;
            case Painter.Ellipse:
                Draw.drawEllipse(ctx, previewCanvas.downX, previewCanvas.downY, area.gMouseX, area.gMouseY, drawThickness, colors[drawColor], geometryFill)
                break;
            case Painter.Square:
                Draw.drawSquare(ctx, previewCanvas.downX, previewCanvas.downY, area.gMouseX, area.gMouseY, drawThickness, colors[drawColor], geometryFill)
                break;
            case Painter.EquilateralTriangle:
                Draw.drawEquilateralTriangle(ctx, previewCanvas.downX, previewCanvas.downY, area.gMouseX, area.gMouseY, drawThickness, colors[drawColor], geometryFill)
                break;
            case Painter.RightIsoscelesTriangle:
                Draw.drawRightIsoscelesTriangle(ctx, previewCanvas.downX, previewCanvas.downY, area.gMouseX, area.gMouseY, drawThickness, colors[drawColor], geometryFill)
                break;
            case Painter.Polygon:
                Draw.drawPolygon(ctx, polyVertices, previewCanvas.downX, previewCanvas.downY, area.gMouseX, area.gMouseY, drawThickness, colors[drawColor], geometryFill)
                break;
            case Painter.Polygram:
                Draw.drawPolygram(ctx, polyVertices, previewCanvas.downX, previewCanvas.downY, area.gMouseX, area.gMouseY, drawThickness, colors[drawColor], geometryFill)
                break;
            case Painter.Arrow:
                Draw.drawArrow(ctx, previewCanvas.downX, previewCanvas.downY, area.gMouseX, area.gMouseY, drawThickness, colors[drawColor], geometryFill)
                break;

            default:
                console.error("Unimplemented feature")
                break;
            }
            
            break;
            
        case Painter.Text:
            if (!textEditPending && thisTextEntry.length>0)
            {
                if (textBalloonize)
                {
                    Draw.drawBalloonText(ctx, thisTextEntry, panX, panY,
                                         colors[textColor],
                                         (textFontBold ? "bold " : "") + (textFontItalic ? "italic " : "") + Math.floor(textFontSize*pinchScale) + "px " + textFontName,
                                         Math.floor(textFontSize*pinchScale),
                                         colors[drawColor],
                                         accelerometer.angle, textBalloonize)
                }
                else
                {
                    Draw.drawText(ctx, thisTextEntry, panX, panY,
                                  colors[textColor],
                                  (textFontBold ? "bold " : "") + (textFontItalic ? "italic " : "") + Math.floor(textFontSize*pinchScale) + "px " + textFontName,
                                  accelerometer.angle)
                }
                thisTextEntry = ""
            }
            break;
            
        case Painter.Image:
            if (!insertImagePending && insertImagePath.length>0)
            {
                Draw.drawInsertedImage(ctx, insertImagePath,
                                       panX, panY,
                                       insertedImage.width * pinchScale, insertedImage.height * pinchScale,
                                       accelerometer.angle)
                unloadImage(insertImagePath)
                insertImagePath = ""
            }
            break;

        case Painter.Clipboard:
            break;
            
        default:
            console.error("Unimplemented feature")
            break;
        }
        lastX = area.gMouseX
        lastY = area.gMouseY
    }
    
    PinchArea
    {
        id: pincharea
        anchors.fill: drawingCanvas
        
        pinch.target: pinchtarget
        pinch.dragAxis: Pinch.NoDrag
        pinch.minimumRotation: 0
        pinch.maximumRotation: 0
        pinch.minimumScale: 0.1
        pinch.maximumScale: 5.0
        /* Enabled pincharea only when it is needed */
        enabled: textEditPending || insertImagePending
        
        MouseArea
        {
            id: area
            anchors.fill: parent
            
            property real gMouseX: 0.0
            property real gMouseY: 0.0
            property bool pressedAndHolded: false
            
            onPressAndHold:
            {
                geometryPopupVisible = false
                dimensionPopupVisible = false
                pressedAndHolded = true
            }
            onPressed:
            {
                if (showFps)
                    _start = new Date().getTime()

                if (gridVisible && gridSnapTo)
                {
                    area.gMouseX = (Math.floor( ( mouseX - ( gridSpacing / 2 )) / gridSpacing ) * gridSpacing ) + gridSpacing
                    area.gMouseY = (Math.floor( ( mouseY - ( gridSpacing / 2 )) / gridSpacing ) * gridSpacing ) + gridSpacing
                }
                else
                {
                    area.gMouseX = Math.round(mouseX)
                    area.gMouseY = Math.round(mouseY)
                }
                
                drawingCanvas.lastX = gMouseX
                drawingCanvas.lastY = gMouseY

                drawingCanvas.setOptions()
                
                switch (drawMode)
                {
                case Painter.Geometrics:
                case Painter.Text:
                case Painter.Image:
                case Painter.Crop:
                case Painter.Clipboard:
                    previewCanvas.downX = gMouseX
                    previewCanvas.downY = gMouseY
                    break;

                case Painter.Dimensioning:
                    if (dimensionMoveMode)
                    {
                        var d=dimensionModel.get(selectedDimension)
                        
                        /* Select nearest dimension end to move */
                        var distance0 = Math.sqrt(Math.pow(Math.abs(mouseX-d["x0"]), 2) + Math.pow(Math.abs(mouseY-d["y0"]), 2))
                        var distance1 = Math.sqrt(Math.pow(Math.abs(mouseX-d["x1"]), 2) + Math.pow(Math.abs(mouseY-d["y1"]), 2))
                        
                        if (distance0 > distance1)
                            dimensionMoveEnd = 0
                        else
                            dimensionMoveEnd = 1
                        
                        previewCanvas.downX = d[String("x%1").arg(dimensionMoveEnd)]
                        previewCanvas.downY = d[String("y%1").arg(dimensionMoveEnd)]
                        
                        // This will hide this dimension from dimensionCanvas
                        // as it is drawn to previewCanvas
                        dimensionCanvas.requestPaint()
                        previewCanvas.requestPaint()
                    }
                    else
                    {
                        previewCanvas.downX = gMouseX
                        previewCanvas.downY = gMouseY
                    }
                    break;
                    
                default:
                    break;
                }
            }
            
            onReleased:
            {
                pressedAndHolded = false
                if (gridVisible && gridSnapTo)
                {
                    area.gMouseX = (Math.floor( ( mouseX - ( gridSpacing / 2 )) / gridSpacing ) * gridSpacing ) + gridSpacing
                    area.gMouseY = (Math.floor( ( mouseY - ( gridSpacing / 2 )) / gridSpacing ) * gridSpacing ) + gridSpacing
                }
                else
                {
                    area.gMouseX = Math.round(mouseX)
                    area.gMouseY = Math.round(mouseY)
                }
                
                switch (drawMode)
                {
                case Painter.Dimensioning:
                    dimensionPopupVisible = true
                    
                    if (dimensionMoveMode)
                    {
                        dimensionModel.setProperty ( selectedDimension, String("x%1").arg(dimensionMoveEnd === 0 ? 1 : 0) , area.gMouseX)
                        dimensionModel.setProperty ( selectedDimension, String("y%1").arg(dimensionMoveEnd === 0 ? 1 : 0) , area.gMouseY)
                    }
                    else
                    {
                        dimensionModel.append( {"x0": previewCanvas.downX,
                                                  "y0": previewCanvas.downY,
                                                  "x1": area.gMouseX,
                                                  "y1": area.gMouseY,
                                                  "font": textFont,
                                                  "fontSize": textFontSize,
                                                  "fontColor": textColor,
                                                  "lineColor": drawColor,
                                                  "lineThickness": drawThickness})
                        /* Make the newest dimension line selected */
                        selectedDimension = dimensionModel.count - 1
                    }
                    previewCanvas.requestPaint()
                    dimensionCanvas.requestPaint()
                    
                    break;
                    
                case Painter.Geometrics:
                    drawingCanvas.requestPaint()
                    previewCanvas.clear()
                    break;
                    
                case Painter.Image:
                case Painter.Text:
                    panX += area.gMouseX - previewCanvas.downX
                    panY += area.gMouseY - previewCanvas.downY
                    previewCanvas.requestPaint()
                    break;

                case Painter.Clipboard:
                    if (previewCanvas.clipboardPreviewImage)
                    {
                        panX += area.gMouseX - previewCanvas.downX
                        panY += area.gMouseY - previewCanvas.downY
                    }
                    else
                    {
                        cropArea = [ Math.min(previewCanvas.downX, area.gMouseX),
                                     Math.min(previewCanvas.downY, area.gMouseY),
                                     Math.abs(previewCanvas.downX - area.gMouseX),
                                     Math.abs(previewCanvas.downY - area.gMouseY) ]
                        var ctx = drawingCanvas.getContext('2d')
                        clipboardImage = ctx.getImageData(cropArea[0], cropArea[1], cropArea[2], cropArea[3])
                    }
                    break;

                case Painter.Crop:
                    cropArea = [ Math.min(previewCanvas.downX, area.gMouseX),
                                 Math.min(previewCanvas.downY, area.gMouseY),
                                 Math.abs(previewCanvas.downX - area.gMouseX),
                                 Math.abs(previewCanvas.downY - area.gMouseY) ]
                    break;
                    
                default:
                    break;
                }
            }
            
            onPositionChanged:
            {
                if (showFps)
                {
                    calculatedFps = Math.round(1000/(new Date().getTime() - _start))
                    _start = new Date().getTime()
                }

                if (gridVisible && gridSnapTo)
                {
                    area.gMouseX = (Math.floor( ( mouseX - ( gridSpacing / 2 )) / gridSpacing ) * gridSpacing ) + gridSpacing
                    area.gMouseY = (Math.floor( ( mouseY - ( gridSpacing / 2 )) / gridSpacing ) * gridSpacing ) + gridSpacing
                }
                else
                {
                    area.gMouseX = Math.round(mouseX)
                    area.gMouseY = Math.round(mouseY)
                }

                switch (drawMode)
                {
                case Painter.Eraser:
                case Painter.Pen:
                    drawingCanvas.markDirty(Qt.rect(lastX, lastY, area.gMouseX, area.gMouseY))
                    break;

                case Painter.Text:
                case Painter.Geometrics:
                case Painter.Dimensioning:
                    previewCanvas.requestPaint()
                    break;

                case Painter.Crop:
                case Painter.Clipboard:
                    cropArea = [ Math.min(previewCanvas.downX, area.gMouseX),
                                 Math.min(previewCanvas.downY, area.gMouseY),
                                 Math.abs(previewCanvas.downX - area.gMouseX),
                                 Math.abs(previewCanvas.downY - area.gMouseY) ]
                    previewCanvas.requestPaint()
                    break;

                case Painter.Image:
                    /* Do nothing */
                    break;
                    
                default:
                    drawingCanvas.requestPaint()
                    break;
                }
            }
        }
    }
}
