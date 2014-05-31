import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0
import "../components"


Page
{
    id: page

    width: 540
    height: 960

    property int drawColor: 0
    property int drawThickness: 0
    property bool clearRequest: false
    property int bgColor: colors.length

    Messagebox
    {
        id: messagebox
    }

    Toolpanel
    {
        id: toolPanel
        onShowMessage: messagebox.showMessage(message, delay)
    }

    Toolbox
    {
        id: toolBox
        onShowMessage: messagebox.showMessage(message, delay)
        anchors.top: toolPanel.bottom
    }

    Rectangle
    {
        id: bg
        anchors.fill: (toolBox.opacity == 0.0) ? page : canvas
        color: bgColor < colors.length ? colors[bgColor] : "transparent"
        z:7
    }

    function getRandomFloat(min, max) {
      return Math.random() * (max - min) + min;
    }

    Canvas
    {
        id: canvas
        z: 9
        width: page.width
        anchors.top: toolBox.bottom
        height: page.height - toolBox.height
        renderTarget: Canvas.FramebufferObject
        antialiasing: true

        property real lastX
        property real lastY
        property color color: colors[drawColor]
        property int density: 50
        property real angle
        property real radius

        onPaint:
        {
            var ctx = getContext('2d')

            if (clearRequest)
            {
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                clearRequest = false
            }
            else switch (drawMode)
            {
                case Painter.Pen :
                    ctx.lineWidth = thicknesses[drawThickness]
                    ctx.strokeStyle = canvas.color
                    ctx.lineJoin = ctx.lineCap = 'round';
                    ctx.beginPath()
                    ctx.moveTo(lastX, lastY)
                    lastX = area.mouseX
                    lastY = area.mouseY
                    ctx.lineTo(lastX, lastY)
                    ctx.stroke()
                    break;
                case Painter.Eraser :
                    radius = 10*thicknesses[drawThickness]
                    ctx.strokeStyle = canvas.color
                    ctx.clearRect(lastX - radius/2, lastY - radius/2, radius/2, radius/2);
                    lastX = area.mouseX
                    lastY = area.mouseY
                    break;
                case Painter.Spray :
                    for (var i = density; i--; )
                    {
                        angle = getRandomFloat(0, Math.PI*2)
                        radius = getRandomFloat(0, 10*thicknesses[drawThickness])
                        ctx.strokeStyle = canvas.color
                        ctx.fillRect(lastX + radius * Math.cos(angle), lastY + radius * Math.sin(angle), 1, 1)
                    }
                    lastX = area.mouseX
                    lastY = area.mouseY
                    break;
                default:
                    break;
            }
        }

        MouseArea
        {
            id: area
            anchors.fill: canvas
            onPressed:
            {
                canvas.lastX = mouseX
                canvas.lastY = mouseY
            }
            onPositionChanged:
            {
                canvas.requestPaint()
            }
        }
    }

    Component.onDestruction: canvas.destroy()

}
