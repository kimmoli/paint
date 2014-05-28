import QtQuick 2.0
import Sailfish.Silica 1.0


Page
{
    id: page

    width: 540
    height: 960

    property int drawColor: 0
    property int drawThickness: 0
    property bool clearRequest: false
    property int bgColor: colors.length

    Rectangle
    {
        id: messageBox
        z: 10
        width: 400
        height: 200
        radius: 40
        opacity: 0.0
        anchors.centerIn: parent
        color: Theme.secondaryHighlightColor

        property alias message: messageBoxText.text

        onMessageChanged:
        {
            messageBox.opacity = 0.95
            messageBoxVisibility.start()
        }

        Label
        {
            id: messageBoxText
            text: ""
            anchors.centerIn: parent
        }
        Behavior on opacity
        {
            FadeAnimation {}
        }
        Timer
        {
            id: messageBoxVisibility
            interval: 3500
            onTriggered: messageBox.opacity = 0.0
        }
    }

    Row
    {
        id: toolBox
        z:8
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        height: 80

        IconButton
        {
            icon.source: buttonimage[0]
            anchors.verticalCenter: parent.verticalCenter
            onClicked:
            {
                console.log(buttonhelptext[0])
                pageStack.push(Qt.resolvedUrl("AboutPage.qml"),
                                      { "version": myclass.version,
                                        "year": "2014",
                                        "name": "Paint",
                                        "imagelocation": "/usr/share/icons/hicolor/86x86/apps/paint.png"} )
            }
        }
        IconButton
        {
            icon.source: buttonimage[1]
            anchors.verticalCenter: parent.verticalCenter
            onClicked:
            {
                console.log(buttonhelptext[1])
                clearRequest = true
                canvas.requestPaint()
            }
        }
        IconButton
        {
            icon.source: buttonimage[2]
            anchors.verticalCenter: parent.verticalCenter
            onClicked:
            {
                console.log(buttonhelptext[2])
                var bgSettingsDialog = pageStack.push(Qt.resolvedUrl("bgSettingsDialog.qml"), {
                                                           "currentBg": bgColor })
                bgSettingsDialog.accepted.connect(function() {
                    bgColor = bgSettingsDialog.currentBg
                })

            }
        }
        IconButton
        {
            icon.source: buttonimage[3]
            anchors.verticalCenter: parent.verticalCenter
            onClicked:
            {
                console.log(buttonhelptext[3])
                var penSettingsDialog = pageStack.push(Qt.resolvedUrl("penSettingsDialog.qml"), {
                                                           "currentColor": drawColor,
                                                           "currentThickness": drawThickness })
                penSettingsDialog.accepted.connect(function() {
                    drawColor = penSettingsDialog.currentColor
                    drawThickness = penSettingsDialog.currentThickness
                })
            }
        }
        IconButton
        {
            icon.source: buttonimage[4]
            anchors.verticalCenter: parent.verticalCenter
            onClicked:
            {
                console.log(buttonhelptext[4])
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
            onTriggered:
            {
                var fileName = myclass.saveScreenshot()
                toolBox.opacity = 1.0
                messageBox.message = fileName
            }
        }
    }

    Rectangle
    {
        id: bg
        anchors.fill: (toolBox.opacity == 0.0) ? page : canvas
        color: bgColor < colors.length ? colors[bgColor] : "transparent"
        z:7
    }

    Canvas
    {
        id: canvas
        z: 9
        width: page.width
        anchors.bottom: page.bottom
        height: page.height - toolBox.height
        renderTarget: Canvas.FramebufferObject
        antialiasing: true


        property real lastX
        property real lastY
        property color color: colors[drawColor]

        onPaint:
        {
            var ctx = getContext('2d')

            if (clearRequest)
            {
                ctx.clearRect(0,0,canvas.width, canvas.height);
                clearRequest = false
            }
            else
            {
                ctx.lineWidth = thicknesses[drawThickness]
                ctx.strokeStyle = canvas.color
                ctx.lineJoin = ctx.lineCap = 'round';
                ctx.beginPath()
                ctx.moveTo(lastX, lastY)
                lastX = area.mouseX
                lastY = area.mouseY
                ctx.lineTo(lastX, lastY)
                ctx.stroke()
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
