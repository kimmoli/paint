import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle
{
    width: parent.width
    height: editColorRow.height + (isColorWheel ? colorWheelPlaceHolder.height : colorSelector.height)
    color: "transparent"

    property bool isColorWheel: false
    property string previewColor: "#000000"
    property bool isPortrait: true

    onIsPortraitChanged:
        if (isColorWheel)
            colorWheelCanvas.requestPaint()

    Row
    {
        id: editColorRow
        width: parent.width

        TextSwitch
        {
            id: tsColorWheel
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Edit color %1").arg(previewColor)
            automaticCheck: false
            checked: isColorWheel
            width: parent.width*(isPortrait ? 3/4 : 6/7)-Theme.paddingLarge
            enabled: currentColor < colors.length

            onClicked:
            {
                isColorWheel = !isColorWheel

                if (isColorWheel)
                {
                    previewColor = colors[currentColor]
                    colorWheelRect.color = colors[currentColor]
                }
                else
                {
                    colorSelectorRepeater.model = colors
                    colorCursor.visible = false
                }
            }
        }
        Rectangle
        {
            id: colorWheelRect
            anchors.verticalCenter: parent.verticalCenter
            visible: isColorWheel
            width: parent.width*(isPortrait ? 1/4 : 1/7)
            height: parent.height - Theme.paddingLarge
            radius: 5
        }
    }

    Grid
    {
        anchors.top: editColorRow.bottom
        id: colorSelector
        visible: !isColorWheel
        columns: Math.floor(parent.width/((540-Theme.paddingLarge)/4))

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
                    onClicked:
                    {
                        currentColor = index
                        previewColor = colors[currentColor]
                    }
                }
            }
        }
    }

    Rectangle
    {
        id: colorWheelPlaceHolder
        visible: isColorWheel

        anchors.top: editColorRow.bottom

        color: "transparent"
        width: Math.min((540-Theme.paddingLarge), parent.width)
        height: width*(3/4)

        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle
        {
            id: colorCursor
            visible: false
            x: 50
            y: 50
            width: 10
            height: 10
            z: 2
            color: "transparent"
            border.color: "White"
            border.width: 2
            radius: width*0.5
        }


        Canvas
        {
            id: colorWheelCanvas
            anchors.fill: parent
            antialiasing: true
            renderStrategy: Canvas.Immediate

            onPaint:
            {
                var ctx = getContext('2d')

                var border = 20

                ctx.clearRect(0, 0, width, height);

                /* RGB gradient */
                var grd = ctx.createLinearGradient(0, 0, width-2*border, 0);
                grd.addColorStop(0,   "red");
                grd.addColorStop(1/6, "magenta");
                grd.addColorStop(2/6, "blue");
                grd.addColorStop(3/6, "cyan");
                grd.addColorStop(4/6, "lime");
                grd.addColorStop(5/6, "yellow");
                grd.addColorStop(1,   "red");
                ctx.fillStyle = grd;
                ctx.fillRect(0, 0, width-2*border, height);

                /* Brightness gradient on top of RGB gradient */
                var grd2 = ctx.createLinearGradient(0,0,0,height);
                grd2.addColorStop(0,   "white");
                grd2.addColorStop(2/5, "transparent");
                grd2.addColorStop(3/5, "transparent");
                grd2.addColorStop(1,   "black");
                ctx.fillStyle = grd2;
                ctx.fillRect(0, 0, width-2*border, height);

                /* Grey-scale gradient at right edge */
                var grd3 = ctx.createLinearGradient(0,0,0,height);
                grd3.addColorStop(0,   "white");
                grd3.addColorStop(border/height, "white")
                grd3.addColorStop((height-border)/height, "black")
                grd3.addColorStop(1,   "black");
                ctx.fillStyle = grd3;
                ctx.fillRect(width-2*border, 0, 2*border, height);

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

            function rgbToHexInverse(r, g, b)
            {
                if (r > 255 || g > 255 || b > 255)
                    throw "Invalid color component"
                return (((255-r) << 16) | ((255-g) << 8) | (255-b)).toString(16)
            }


            preventStealing: true

            onPositionChanged: getColorAtPosition()
            onPressed:
            {
                colorCursor.visible = true
                getColorAtPosition()
            }

            function getColorAtPosition()
            {
                if (mouseX > 0 && mouseY > 0 && mouseX < width-1 && mouseY < height-1)
                {
                    var ctx = colorWheelCanvas.getContext('2d')
                    var p = ctx.getImageData(mouseX, mouseY, 1, 1).data;
                    var hex = "#" + ("000000" + rgbToHex(p[0], p[1], p[2])).slice(-6)

                    /* Just set them all ... */
                    colorWheelRect.color = hex
                    colors[currentColor] = hex
                    previewColor = hex

                    colorCursor.x = (mouseX) - 5
                    colorCursor.y = (mouseY) - 5
                    colorCursor.border.color = "#" + ("000000" + rgbToHexInverse(p[0], p[1], p[2])).slice(-6)
                }
            }

        }
    }
}
