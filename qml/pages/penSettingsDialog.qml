import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog
{
    id: penSettingsDialog
    canAccept: true

    property int currentColor: 0
    property int currentThickness: 0
    property bool isColorWheel: false
    property string colorWheelColor: "#000000"
    property bool paintIt: false
    property bool paintedIt: false

    onDone:
    {
        if (result === DialogResult.Accepted)
        {
            currentThickness = thicknessSlider.value
        }
    }


    SilicaFlickable
    {
        id: flick

        anchors.fill: parent
        contentHeight: dialogHeader.height + col.height
        width: parent.width

        VerticalScrollDecorator { flickable: flick }

        DialogHeader
        {
            id: dialogHeader
            acceptText: qsTr("Pen settings")
            Timer
            {
                interval: 2500
                running: true
                onTriggered: dialogHeader.acceptText = dialogHeader.defaultAcceptText
            }
        }

        Column
        {
            id: col
            width: parent.width - Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: dialogHeader.bottom

            SectionHeader
            {
                text: qsTr("Select color")
            }

            TextSwitch
            {
                id: tsColorWheel
                text: qsTr("Edit color")
                automaticCheck: false
                checked: isColorWheel
                width: parent.width
                onClicked:
                {
                    isColorWheel = !isColorWheel
                    if (!paintIt && isColorWheel && !paintedIt)
                    {
                        paintIt = true;
                        colorWheelCanvas.requestPaint()
                        colorWheelColor = colors[currentColor]
                        colorWheelRect.color = colors[currentColor]
                    }
                    if (!isColorWheel)
                    {
                        colorSelectorRepeater.model = colors
                    }
                }
            }

            Grid
            {
                id: colorSelector
                visible: !isColorWheel
                columns: 4

                Repeater
                {
                    id: colorSelectorRepeater
                    model: colors
                    Rectangle
                    {
                        width: col.width/colorSelector.columns
                        height: col.width/colorSelector.columns
                        radius: 10
                        color: (index == currentColor) ? colors[index] : "transparent"
                        Rectangle
                        {
                            width: parent.width - 20
                            height: parent.height - 20
                            radius: 5
                            color: colors[index]
                            anchors.centerIn: parent
                        }
                        BackgroundItem
                        {
                            anchors.fill: parent
                            onClicked: currentColor = index
                        }
                    }
                }
            }

            Rectangle
            {
                id: colorWheelRect
                visible: isColorWheel

                color: colorWheelColor
                height: parent.width*(3/4)
                width: height
                radius: height*0.5

                anchors.horizontalCenter: parent.horizontalCenter

                Canvas
                {
                    id: colorWheelCanvas
                    anchors.fill: parent
                    renderTarget: Canvas.FramebufferObject
                    antialiasing: true

                    property bool clearNow : false
                    property int midX : width / 2
                    property int midY : height / 2

                    onPaint:
                    {
                        if (!paintIt)
                            return

                        paintedIt = true

                        var ctx = getContext('2d')

                        ctx.clearRect(0, 0, width, height);

                        var cx = width / 2
                        var cy = height / 2
                        var radius = width  / 2.3
                        var hue, sat, value
                        var i = 0, x, y, rx, ry, d
                        var f, g, p, u, v, w, rgb

                        var imageData = ctx.createImageData(width, height)
                        var pixels = imageData.data

                        /* This bastard takes ages to draw :( */

                        for (y = 0; y < height; y = y + 1)
                        {
                            for (x = 0; x < width; x = x + 1, i = i + 4)
                            {
                                rx = x - cx;
                                ry = y - cy;
                                d = rx * rx + ry * ry;
                                if (d < radius * radius)
                                {
                                    hue = 6 * (Math.atan2(ry, rx) + Math.PI) / (2 * Math.PI);
                                    sat = Math.sqrt(d) / radius;
                                    g = Math.floor(hue);
                                    f = hue - g;
                                    u = 255 * (1 - sat);
                                    v = 255 * (1 - sat * f);
                                    w = 255 * (1 - sat * (1 - f));
                                    pixels[i] = [255, v, u, u, w, 255, 255][g];
                                    pixels[i + 1] = [w, 255, 255, v, u, u, w][g];
                                    pixels[i + 2] = [u, u, w, 255, 255, v, u][g];
                                    pixels[i + 3] = 255;
                                }
                            }
                        }

                      ctx.putImageData(imageData, 0, 0);
                    }
                }

                MouseArea
                {
                    id: area
                    anchors.fill: colorWheelCanvas

                    function rgbToHex(r, g, b)
                    {
                        if (r > 255 || g > 255 || b > 255)
                            throw "Invalid color component"
                        return ((r << 16) | (g << 8) | b).toString(16)
                    }

                    onPressed:
                    {
                        var ctx = colorWheelCanvas.getContext('2d')
                        var p = ctx.getImageData(mouseX, mouseY, 1, 1).data;
                        var hex = "#" + ("000000" + rgbToHex(p[0], p[1], p[2])).slice(-6)
                        console.log("color at " + mouseX + "x" + mouseY + " is " + hex)

                        /* Just set them all ... */
                        colorWheelColor = hex
                        colorWheelRect.color = colorWheelColor
                        colors[currentColor] = colorWheelColor
                        previewLine.color = colorWheelColor
                    }
                }
            }

            SectionHeader
            {
                text: qsTr("Pen width")
            }

            Rectangle
            {
                color: "transparent"
                height: 80
                width: parent.width

                Rectangle
                {
                    id: previewLine
                    height: thicknessSlider.value
                    width: parent.width - 170
                    color: colors[currentColor]
                    anchors.centerIn: parent
                }
            }

            Slider
            {
                id: thicknessSlider
                value: currentThickness
                valueText: value
                minimumValue: 1
                maximumValue: 25
                stepSize: 1
                width: parent.width - 2*Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
