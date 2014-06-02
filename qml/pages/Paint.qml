import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0
import "../components"


Page
{
    id: page

    width: 540
    height: 960

    state: toolboxLocation

    onStateChanged: geometryCanvas.clear()

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
            target: canvas
            anchors.top: undefined
            anchors.bottom: toolBox.top
        }
    } ]

    Messagebox
    {
        id: messagebox
    }

    Toolbox
    {
        id: toolBox

        anchors.top: page.top
        onShowMessage: messagebox.showMessage(message, delay)
        onShowGeometryPopup: geometryPopupVisible = true
    }

    GeometryPopup
    {
        z:1
        id: geometryPopup

        anchors.top: toolBox.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        visible: geometryPopupVisible && (drawMode === Painter.Geometrics)
        onVisibleChanged: z = visible ? 19 : 1
        onHideMe: geometryPopupVisible = false
    }
    Rectangle
    {
        color: "black"
        anchors.fill: geometryPopup
        visible: geometryPopup.visible
        z: geometryPopup.z-1
    }


    Rectangle
    {
        id: bg
        anchors.fill: (toolBox.opacity == 0.0) ? page : canvas
        color: bgColor < colors.length ? colors[bgColor] : "transparent"
        z:7
    }

    function drawLine(ctx, x0,y0,x1,y1)
    {
        ctx.lineWidth = drawThickness
        ctx.strokeStyle = colors[drawColor]

        ctx.beginPath();
        ctx.moveTo(x0, y0);
        ctx.lineTo(x1, y1);
        ctx.stroke();
        ctx.closePath();
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

    Canvas
    {
        id: geometryCanvas
        z: 10
        anchors.fill: canvas
        renderTarget: Canvas.FramebufferObject
        antialiasing: true

        property real downX
        property real downY
        property color color: colors[drawColor]

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

            switch(geometricsMode)
            {
                case Painter.Line :
                    drawLine(ctx, downX, downY, area.mouseX, area.mouseY)
                    break;
                case Painter.Circle :
                    drawCircle(ctx, downX, downY, area.mouseX, area.mouseY, false)
                    break;
                case Painter.CircleFilled :
                    drawCircle(ctx, downX, downY, area.mouseX, area.mouseY, true)
                    break;
                case Painter.Rectangle :
                    drawRectangle(ctx, downX, downY, area.mouseX, area.mouseY, false)
                    break;
                case Painter.RectangleFilled :
                    drawRectangle(ctx, downX, downY, area.mouseX, area.mouseY, true)
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

        anchors.top: toolBox.bottom
        width: page.width
        height: page.height - toolBox.height
        renderTarget: Canvas.FramebufferObject
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

            switch (drawMode)
            {
                case Painter.Eraser :
                case Painter.Pen :
                    if (drawMode === Painter.Eraser)
                        ctx.globalCompositeOperation = 'destination-out'
                    ctx.lineWidth = (drawMode === Painter.Eraser) ? eraserThickness : drawThickness
                    ctx.strokeStyle = colors[drawColor]
                    ctx.lineJoin = ctx.lineCap = 'round';
                    ctx.beginPath()
                    ctx.moveTo(lastX, lastY)
                    lastX = area.mouseX
                    lastY = area.mouseY
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
                        drawLine(ctx, geometryCanvas.downX, geometryCanvas.downY, area.mouseX, area.mouseY)
                        break;
                    case Painter.Circle :
                        drawCircle(ctx, geometryCanvas.downX, geometryCanvas.downY, area.mouseX, area.mouseY, false)
                        break;
                    case Painter.CircleFilled :
                        drawCircle(ctx, geometryCanvas.downX, geometryCanvas.downY, area.mouseX, area.mouseY, true)
                        break;
                    case Painter.Rectangle :
                        drawRectangle(ctx, geometryCanvas.downX, geometryCanvas.downY, area.mouseX, area.mouseY, false)
                        break;
                    case Painter.RectangleFilled :
                        drawRectangle(ctx, geometryCanvas.downX, geometryCanvas.downY, area.mouseX, area.mouseY, true)
                        break;

                    default:
                        console.error("Unimplemented feature")
                        break;
                    }

                    break;

                default:
                    console.error("Unimplemented feature")
                    break;
            }
            lastX = area.mouseX
            lastY = area.mouseY
        }

        MouseArea
        {
            id: area
            anchors.fill: canvas
            onPressed:
            {
                geometryPopupVisible = false

                canvas.lastX = mouseX
                canvas.lastY = mouseY
                if (drawMode === Painter.Geometrics)
                {
                    geometryCanvas.downX = mouseX
                    geometryCanvas.downY = mouseY
                }
                else
                {
                    canvas.lastX = mouseX
                    canvas.lastY = mouseY
                }
            }

            onReleased:
            {
                if (drawMode === Painter.Geometrics)
                {
                    canvas.requestPaint()
                    geometryCanvas.clear()
                }
            }

            onPositionChanged:
            {
                if (drawMode === Painter.Geometrics)
                    geometryCanvas.requestPaint()
                else
                    canvas.requestPaint()
            }
        }
    }
}
