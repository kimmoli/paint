import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSensors 5.0 as Sensors
import harbour.paint.PainterClass 1.0
import harbour.paint.Thumbnailer 1.0
import "../components"


Page
{
    id: page

    anchors.fill: parent

    state: toolboxLocation
    onStateChanged: previewCanvas.clear()

    Sensors.Accelerometer
    {
        id: accelerometer
        dataRate: 25
        active: textEditPending

        property double angle: 0.0
        property double x: 0.0
        property double y: 0.0

        Behavior on x { NumberAnimation { duration: 100 } }
        Behavior on y { NumberAnimation { duration: 100 } }

        onReadingChanged:
        {
            x = reading.x
            y = reading.y

            if ( (Math.atan(y / Math.sqrt(y * y + x * x))) >= 0 )
                angle = -(Math.acos(x / Math.sqrt(y * y + x * x)) - (Math.PI/2) )
            else
                angle = Math.PI + (Math.acos(x / Math.sqrt(y * y + x * x)) - (Math.PI/2) )

            previewCanvas.requestPaint()
        }

    }

    Sensors.OrientationSensor
    {
        id: rotationSensor
        active: true
        property int angle: reading.orientation ? _getOrientation(reading.orientation) : 0
        function _getOrientation(value)
        {
            switch (value)
            {
                case 2:
                    return 180
                case 3:
                    return -90
                case 4:
                    return 90
                default:
                    return 0
            }
        }
    }

    states: [
        /* Default state is toolboxTop */
    State
    {
        name: "toolboxBottom"
        AnchorChanges
        {
            target: toolBox
            anchors.top: undefined
            anchors.bottom: page.bottom
        }
        AnchorChanges
        {
            target: geometryPopup
            anchors.top: undefined
            anchors.bottom: toolBox.top
        }
        AnchorChanges
        {
            target: dimensionPopup
            anchors.top: undefined
            anchors.bottom: toolBox.top
        }
        AnchorChanges
        {
            target: toolBoxBackground
            anchors.top: undefined
            anchors.bottom: page.bottom
        }
        PropertyChanges
        {
            target: toolBoxBackgroundEffect
            direction: OpacityRamp.BottomToTop
        }
    } ]

    Messagebox
    {
        id: messagebox
    }

    Rectangle
    {
        id: toolBoxBackground
        z: 14

        anchors.top: page.top
        width: page.width
        height: Theme.paddingLarge + toolBox.height + (geometryPopup.visible ? geometryPopup.height : 0) + (dimensionPopup.visible ? dimensionPopup.height : 0)
        color: Theme.secondaryHighlightColor
    }

    OpacityRampEffect
    {

        id: toolBoxBackgroundEffect
        z: 14
        clampMax: toolBox.opacity > 0.5 ? 0.65 : 0.0
        slope: 2.0
        offset: 0.6
        direction: OpacityRamp.TopToBottom
        sourceItem: toolBoxBackground

        Behavior on clampMax
        {
            FadeAnimation {}
        }
    }

    Toolbox
    {
        id: toolBox
        z: 15

        anchors.top: page.top
        onShowMessage: messagebox.showMessage(message, delay)
        onToggleGeometryPopup: geometryPopupVisible = !geometryPopupVisible
        onShowGeometryPopup: geometryPopupVisible = true
        onHideGeometryPopup: geometryPopupVisible = false
        onToggleDimensionPopup: { dimensionPopupVisible = !dimensionPopupVisible; dimensionCanvas.requestPaint(); }
        onShowDimensionPopup: { dimensionPopupVisible = true; dimensionCanvas.requestPaint(); }
        onHideDimensionPopup: { dimensionPopupVisible = false; dimensionCanvas.requestPaint(); }
        onTextEditAccept: textAccept()
        onTextEditCancel: textCancel()
        onTextSettingsChanged: previewCanvas.requestPaint()
        onToggleGridVisibility: { gridVisible = !gridVisible; gridCanvas.requestPaint(); }
        onGridSettingsChanged: gridCanvas.requestPaint()
    }

    GeometryPopup
    {
        id: geometryPopup
        z: 0

        anchors.top: toolBox.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        visible: geometryPopupVisible && (drawMode === Painter.Geometrics)
        onVisibleChanged: z = visible ? 15 : 0
    }
    DimensionPopup
    {
        id: dimensionPopup
        z: 0

        anchors.top: toolBox.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        visible: dimensionPopupVisible && (drawMode === Painter.Dimensioning)
        onVisibleChanged: z = visible ? 15 : 0
    }

    Rectangle
    {
        id: bg
        z: 6
        anchors.fill: page
        color: bgColor < colors.length ? colors[bgColor] : "transparent"
        onColorChanged: gridCanvas.requestPaint()
    }

    Thumbnail
    {
        id: bgImg
        visible: useImageAsBackground
        z: 7
        source: backgroundImagePath
        height: bg.height
        width: bg.width
        sourceSize.height: bg.height
        sourceSize.width: bg.width
        anchors.centerIn: bg
        clip: true
        smooth: true
        mimeType: "image"
        fillMode: backgroundImageRotate ? Thumbnail.RotateFit : Thumbnail.PreserveAspectFit


        states:
            [
            State
            {
                name: 'loaded'; when: image.status == Thumbnail.Ready
                PropertyChanges { target: image; opacity: 1; }
            },
            State
            {
                name: 'loading'; when: image.status != Thumbnail.Ready
                PropertyChanges { target: image; opacity: 0; }
            }
        ]

        Behavior on opacity
        {
            FadeAnimation {}
        }
    }

    Canvas
    {
        id: gridCanvas
        z: 8
        anchors.fill: canvas
        antialiasing: true

        property bool clearNow : false

        function clear()
        {
            clearNow = true
            requestPaint()
        }

        onPaint:
        {
            var ctx = getContext('2d')

            ctx.clearRect(0, 0, width, height);
            if (clearNow)
            {
                clearNow = false
                return
            }

            if (!gridVisible)
                return

            ctx.lineWidth = 1

            ctx.strokeStyle = bgColor < colors.length ? inverse(colors[bgColor]) : "#ffffff"

            for (var y = 0 ; y < height; y = y + gridSpacing)
            {
                ctx.beginPath()
                ctx.moveTo(0, y)
                ctx.lineTo(width, y)
                ctx.stroke()
                ctx.closePath()
            }

            for (var x = 0 ; x < width; x = x + gridSpacing)
            {
                ctx.beginPath()
                ctx.moveTo(x, 0)
                ctx.lineTo(x, height)
                ctx.stroke()
                ctx.closePath()
            }
        }
    }

    function inverse(hex)
    {
      if (hex.length !== 7 || hex.indexOf('#') !== 0)
          return "#ffffff"
      return "#" + pad((255 - parseInt(hex.substring(1, 3), 16)).toString(16)) + pad((255 - parseInt(hex.substring(3, 5), 16)).toString(16)) + pad((255 - parseInt(hex.substring(5, 7), 16)).toString(16))
    }

    function pad(num)
    {
      if (num.length < 2)
        return "0" + num
      else
        return num
    }

    function drawLine(ctx, x0,y0,x1,y1)
    {
        ctx.lineWidth = drawThickness
        ctx.strokeStyle = colors[drawColor]

        ctx.beginPath()
        ctx.moveTo(x0, y0)
        ctx.lineTo(x1, y1)
        ctx.stroke()
        ctx.closePath()
    }

    function drawCircle(ctx, x0,y0,x1,y1, fill)
    {
        ctx.lineWidth = drawThickness
        ctx.strokeStyle = colors[drawColor]
        ctx.fillStyle  = colors[drawColor]

        var radius = Math.max(Math.abs(x1-x0),Math.abs(y1-y0))

        ctx.beginPath()
        ctx.arc(x0, y0, radius, 0, Math.PI*2, true)
        if (fill)
            ctx.fill()
        ctx.stroke()
        ctx.closePath()
    }

    function drawEllipse(ctx, x0, y0, x1, y1, fill)
    {

        var x = Math.min(x0, x1),
            y = Math.min(y0, y1),
            w = Math.abs(x1-x0),
            h = Math.abs(y1-y0);

        var kappa = .5522848
        var ox = (w / 2) * kappa // control point offset horizontal
        var oy = (h / 2) * kappa // control point offset vertical
        var xe = x + w           // x-end
        var ye = y + h           // y-end
        var xm = x + w / 2       // x-middle
        var ym = y + h / 2       // y-middle

        ctx.lineWidth = drawThickness
        ctx.strokeStyle = colors[drawColor]
        ctx.fillStyle  = colors[drawColor]

        ctx.beginPath();
        ctx.moveTo(x, ym);
        ctx.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y);
        ctx.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym);
        ctx.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye);
        ctx.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
        ctx.closePath();
        if (fill)
            ctx.fill()
        ctx.stroke();
    }

    function drawRectangle(ctx, x0,y0,x1,y1, fill)
    {
        ctx.lineWidth = drawThickness
        ctx.strokeStyle = colors[drawColor]
        ctx.fillStyle  = colors[drawColor]

        var x = Math.min(x0, x1),
            y = Math.min(y0, y1),
            w = Math.abs(x1-x0),
            h = Math.abs(y1-y0);

        if (h==0 || w==0)
            return;

        if (fill)
            ctx.fillRect(x, y, w, h);
        else
            ctx.strokeRect(x, y, w, h);
    }

    function drawText(ctx, txt, x, y)
    {
        ctx.save()
        ctx.translate(x, y)
        ctx.rotate( accelerometer.angle )
        ctx.fillStyle = colors[textColor]
        ctx.font = textFont
        ctx.textAlign = "center"
        ctx.textBaseline = "middle"
        ctx.fillText(txt, 0, 0)
        ctx.restore()
    }

    function textAccept()
    {
        textEditPending = false
        previewCanvas.clear()
        canvas.requestPaint()
    }
    function textCancel()
    {
        thisTextEntry = ""
        textEditPending = false
        previewCanvas.clear()
    }

    function drawDimensionLine(ctx, x0, y0, x1, y1, fontColor, font, fontSize, lineColor, lineThickness, selected)
    {
        var headlen = 15
        var angle = Math.atan2(y1-y0, x1-x0)

        var seglen = Math.sqrt(Math.pow(Math.abs(x1-x0), 2) + Math.pow(Math.abs(y1-y0), 2))
        var mx = x0+seglen/2*Math.cos(angle)
        var my = y0+seglen/2*Math.sin(angle)

        var scaled = seglen / dimensionScale
        var text = scaled.toFixed(1).toString()
        ctx.font = font
        var textlen = ctx.measureText(text).width
        var fits = (textlen < (seglen-2*headlen))

        ctx.lineWidth = lineThickness
        ctx.strokeStyle = colors[lineColor]

        ctx.beginPath()
        ctx.moveTo(x0, y0)
        ctx.lineTo(x0+headlen*Math.cos(angle-Math.PI/6),y0+headlen*Math.sin(angle-Math.PI/6))
        ctx.moveTo(x0, y0)
        ctx.lineTo(x0+headlen*Math.cos(angle+Math.PI/6),y0+headlen*Math.sin(angle+Math.PI/6))
        ctx.moveTo(x0, y0)
        if (fits)
        {
            ctx.lineTo(x0+(seglen-textlen-lineThickness)/2*Math.cos(angle), y0+(seglen-textlen-lineThickness)/2*Math.sin(angle))
            ctx.moveTo(x0+(textlen+lineThickness+(seglen-textlen)/2)*Math.cos(angle), y0+(textlen+lineThickness+(seglen-textlen)/2)*Math.sin(angle))
        }
        ctx.lineTo(x1, y1)
        ctx.lineTo(x1-headlen*Math.cos(angle-Math.PI/6),y1-headlen*Math.sin(angle-Math.PI/6))
        ctx.moveTo(x1, y1)
        ctx.lineTo(x1-headlen*Math.cos(angle+Math.PI/6),y1-headlen*Math.sin(angle+Math.PI/6))
        ctx.stroke()
        ctx.closePath()

        ctx.save()
        ctx.translate(mx, my)
        ctx.rotate(((angle > Math.PI/2)||(angle < -Math.PI/2)) ? Math.PI+angle : angle)
        if (selected)
        {
            ctx.save()
            ctx.lineWidth = 3
            ctx.strokeRect(-textlen/2, fits ? -fontSize/2 : -15-fontSize, textlen+lineThickness, fontSize)
            ctx.restore()
        }
        ctx.fillStyle = colors[fontColor]
        ctx.font = font
        ctx.textAlign = "center"
        ctx.textBaseline = "middle"
        ctx.fillText(text, 0, fits ? fontSize/3 : -20 )
        ctx.restore()
    }

    Canvas
    {
        id: dimensionCanvas
        z: 10
        anchors.fill: canvas
        antialiasing: true

        property bool clearNow : false

        function clear()
        {
            clearNow = true
            requestPaint()
        }

        onPaint:
        {
            var ctx = getContext('2d')

            ctx.lineJoin = ctx.lineCap = 'round';

            ctx.clearRect(0, 0, width, height);
            if (clearNow)
            {
                clearNow = false
                return
            }
            /* This redraws all dimension lines from listmodel */
            for (var i=0 ; i<dimensionModel.count; i++)
            {
                var d=dimensionModel.get(i)

                if (!((i === selectedDimension) && dimensionMoveMode && area.pressed))
                    drawDimensionLine(ctx, d["x0"], d["y0"], d["x1"], d["y1"], d["fontColor"], d["font"], d["fontSize"], d["lineColor"], d["lineThickness"], (i === selectedDimension) && dimensionPopupVisible)
            }
        }
    }

    SequentialAnimation
    {
             id: textEditActiveAnimation
             running: textEditPending
             loops: Animation.Infinite

             NumberAnimation { target: previewCanvas; property: "opacity"; to: 0.6; duration: 500; easing.type: Easing.InOutCubic }
             NumberAnimation { target: previewCanvas; property: "opacity"; to: 1.0; duration: 500; easing.type: Easing.InOutCubic }

             onRunningChanged:
             {
                 if (!running)
                     previewCanvas.opacity = 1.0
             }
    }

    Canvas
    {
        id: previewCanvas
        z: 11
        anchors.fill: canvas
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

            ctx.clearRect(0, 0, width, height);
            if (clearNow)
            {
                clearNow = false
                return
            }
            ctx.lineJoin = ctx.lineCap = 'round';

            switch (drawMode)
            {
            case Painter.Geometrics:
                switch(geometricsMode)
                {
                    case Painter.Line :
                        drawLine(ctx, downX, downY, area.gMouseX, area.gMouseY)
                        break;
                    case Painter.Circle :
                        drawCircle(ctx, downX, downY, area.gMouseX, area.gMouseY, geometryFill)
                        break;
                    case Painter.Rectangle :
                        drawRectangle(ctx, downX, downY, area.gMouseX, area.gMouseY, geometryFill)
                        break;
                    case Painter.Ellipse :
                        drawEllipse(ctx, downX, downY, area.gMouseX, area.gMouseY, geometryFill)
                        break;

                    default:
                        break;
                }
                break;
            case Painter.Text:
                if (thisTextEntry.length>0)
                    drawText(ctx, thisTextEntry, area.gMouseX, area.gMouseY)
                break;

            case Painter.Dimensioning:
                drawDimensionLine(ctx, downX, downY, area.gMouseX, area.gMouseY, textColor, textFont, textFontSize, drawColor, drawThickness, dimensionMoveMode)
                break;

            default:
                break;
            }
        }
    }


    Canvas
    {
        id: canvas
        z: 9

        anchors.fill: page
        antialiasing: true

        property real lastX
        property real lastY
        property real angle
        property real radius

        property bool clearNow : false

        function clear()
        {
            clearNow = true
            requestPaint()
        }

        onPaint:
        {
            var ctx = getContext('2d')

            if (clearNow)
            {
                ctx.clearRect(0, 0, width, height);
                clearNow = false
                return
            }

            ctx.lineJoin = ctx.lineCap = 'round';

            switch (drawMode)
            {
                case Painter.Eraser :
                case Painter.Pen :
                    if (drawMode === Painter.Eraser)
                        ctx.globalCompositeOperation = 'destination-out'
                    ctx.lineWidth = (drawMode === Painter.Eraser) ? eraserThickness : drawThickness
                    ctx.strokeStyle = colors[drawColor]
                    ctx.beginPath()
                    ctx.moveTo(lastX, lastY)
                    lastX = area.gMouseX
                    lastY = area.gMouseY
                    ctx.lineTo(lastX, lastY)
                    ctx.stroke()
                    ctx.globalCompositeOperation = 'source-over'
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
                        drawLine(ctx, previewCanvas.downX, previewCanvas.downY, area.gMouseX, area.gMouseY)
                        break;
                    case Painter.Circle :
                        drawCircle(ctx, previewCanvas.downX, previewCanvas.downY, area.gMouseX, area.gMouseY, geometryFill)
                        break;
                    case Painter.Rectangle :
                        drawRectangle(ctx, previewCanvas.downX, previewCanvas.downY, area.gMouseX, area.gMouseY, geometryFill)
                        break;
                    case Painter.Ellipse:
                        drawEllipse(ctx, previewCanvas.downX, previewCanvas.downY, area.gMouseX, area.gMouseY, geometryFill)
                        break;

                    default:
                        console.error("Unimplemented feature")
                        break;
                    }

                    break;

                case Painter.Text:
                    if (!textEditPending && thisTextEntry.length>0)
                    {
                        drawText(ctx, thisTextEntry, area.gMouseX, area.gMouseY)
                        thisTextEntry = ""
                    }
                    break;

                default:
                    console.error("Unimplemented feature")
                    break;
            }
            lastX = area.gMouseX
            lastY = area.gMouseY
        }

        MouseArea
        {
            id: area
            anchors.fill: canvas

            property real gMouseX: 0.0
            property real gMouseY: 0.0

            onPressAndHold:
            {
                geometryPopupVisible = false
                dimensionPopupVisible = false
                toolBox.opacity = 0.0
            }
            onPressed:
            {
                if (gridVisible && gridSnapTo)
                {
                    // =PYÖRISTÄ.KERR.ALAS((A1-$C$1/2)/($C$1);1)*$C$1+$C$1
                    area.gMouseX = (Math.floor( ( mouseX - ( gridSpacing / 2 )) / gridSpacing ) * gridSpacing ) + gridSpacing
                    area.gMouseY = (Math.floor( ( mouseY - ( gridSpacing / 2 )) / gridSpacing ) * gridSpacing ) + gridSpacing
                }
                else
                {
                    area.gMouseX = mouseX
                    area.gMouseY = mouseY
                }

                canvas.lastX = gMouseX
                canvas.lastY = gMouseY

                switch (drawMode)
                {
                case Painter.Geometrics:
                    previewCanvas.downX = gMouseX
                    previewCanvas.downY = gMouseY
                    break;

                case Painter.Dimensioning:
                    if (dimensionMoveMode)
                    {
                        var d=dimensionModel.get(selectedDimension)

                        if (d["y0"] > d["y1"])
                        {
                            if (mouseY > (d["y0"] + d["y1"])/2)
                            {
                                dimensionMoveEnd = 1
                            }
                            else
                            {
                                dimensionMoveEnd = 0
                            }
                        }
                        else
                        {
                            if (mouseY > (d["y0"] + d["y1"])/2)
                            {
                                dimensionMoveEnd = 0
                            }
                            else
                            {
                                dimensionMoveEnd = 1
                            }
                        }

                        previewCanvas.downX = d[String("x%1").arg(dimensionMoveEnd)]
                        previewCanvas.downY = d[String("y%1").arg(dimensionMoveEnd)]

                        // This will hide this dimension from dimensionCanvas
                        // as it is drawn to previewCanvas
                        dimensionCanvas.requestPaint()
                    }
                    else
                    {
                        previewCanvas.downX = gMouseX
                        previewCanvas.downY = gMouseY
                    }
                    break;

                case Painter.Text:
                    previewCanvas.downX = gMouseX
                    previewCanvas.downY = gMouseY

                    if (!textEditPending)
                    {
                        var textEntryDialog = pageStack.push(Qt.resolvedUrl("../pages/textEntryDialog.qml"))

                        textEntryDialog.accepted.connect(function()
                        {
                            thisTextEntry = textEntryDialog.newText
                            if (thisTextEntry.length>0)
                            {
                                textEditPending = true
                                previewCanvas.requestPaint()
                            }
                        })
                    }
                    else
                        previewCanvas.requestPaint()

                    break;

                default:
                    break;
                }
            }

            onReleased:
            {

                if (gridVisible && gridSnapTo)
                {
                    area.gMouseX = (Math.floor( ( mouseX - ( gridSpacing / 2 )) / gridSpacing ) * gridSpacing ) + gridSpacing
                    area.gMouseY = (Math.floor( ( mouseY - ( gridSpacing / 2 )) / gridSpacing ) * gridSpacing ) + gridSpacing
                }
                else
                {
                    area.gMouseX = mouseX
                    area.gMouseY = mouseY
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
                    }
                    previewCanvas.clear()
                    dimensionCanvas.requestPaint()

                    break;

                case Painter.Geometrics:

                    geometryPopupVisible = true

                    canvas.requestPaint()
                    previewCanvas.clear()
                    break;

                default:
                    break;
                }
                toolBox.opacity = 1.0
            }

            onPositionChanged:
            {

                if (gridVisible && gridSnapTo)
                {
                    area.gMouseX = (Math.floor( ( mouseX - ( gridSpacing / 2 )) / gridSpacing ) * gridSpacing ) + gridSpacing
                    area.gMouseY = (Math.floor( ( mouseY - ( gridSpacing / 2 )) / gridSpacing ) * gridSpacing ) + gridSpacing
                }
                else
                {
                    area.gMouseX = mouseX
                    area.gMouseY = mouseY
                }

                switch (drawMode)
                {
                case Painter.Text:
                case Painter.Geometrics:
                case Painter.Dimensioning:
                    previewCanvas.requestPaint()
                    break;
                default:
                    canvas.requestPaint()
                    break;
                }
            }
        }
    }
}
