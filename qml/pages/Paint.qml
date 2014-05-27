import QtQuick 2.0
import Sailfish.Silica 1.0


Page
{
    id: page

    width: 540
    height: 960

    property string drawColor: "white"
    property int drawThickness: 2
    property bool clearRequest: false

    Row
    {
        id: toolBox
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        height: 64

        IconButton
        {
            icon.source: "image://theme/icon-m-about"
            onClicked:
            {
                console.log("About button")
                pageStack.push(Qt.resolvedUrl("AboutPage.qml"),
                                      { "version": myclass.version,
                                        "year": "2014",
                                        "name": "Paint",
                                        "imagelocation": "/usr/share/icons/hicolor/86x86/apps/paint.png"} )
            }
        }
        IconButton
        {
            icon.source: "image://theme/icon-m-clear"
            onClicked:
            {
                console.log("Clear button")
                clearRequest = true
                canvas.requestPaint()
            }
        }
        IconButton
        {
            icon.source: "image://theme/icon-m-edit"
            onClicked:
            {
                console.log("Pen settings button")
                drawColor = (drawColor == "red" ? "white" : "red")
            }
        }
        IconButton
        {
            icon.source: "image://theme/icon-m-imaging"
            onClicked:
            {
                console.log("snapshot button")
                toolBox.opacity = 0.0
                toolBoxVisibility.start()
            }
        }
        Behavior on opacity
        {
            FadeAnimation {}
        }
        Timer
        {
            id: toolBoxVisibility
            interval: 1000
            onTriggered:  toolBox.opacity = 1.0
        }
    }

    Canvas
    {
        id: canvas
        width: page.width
        anchors.bottom: page.bottom
        height: page.height - toolBox.height
        renderTarget: Canvas.FramebufferObject
        antialiasing: true


        property real lastX
        property real lastY
        property color color: drawColor

        onPaint:
        {
            console.log("onPaint")

            var ctx = getContext('2d')

            if (clearRequest)
            {
                ctx.clearRect(0,0,canvas.width, canvas.height);
                clearRequest = false
            }
            else
            {
                ctx.lineWidth = drawThickness
                ctx.strokeStyle = canvas.color
                ctx.beginPath()
                ctx.moveTo(lastX, lastY)
                lastX = area.mouseX
                lastY = area.mouseY
                ctx.lineTo(lastX, lastY)
            }
            ctx.stroke()
        }


        MouseArea
        {
            id: area
            anchors.fill: canvas
            onPressed:
            {
                canvas.lastX = mouseX
                canvas.lastY = mouseY
                console.log("X " + mouseX + " Y " + mouseY)
            }
            onPositionChanged:
            {
                canvas.requestPaint()
            }
        }
    }
}
