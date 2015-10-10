import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSensors 5.0 as Sensors
import harbour.paint.PainterClass 1.0

import "../components"
import "../code/drawinghelpers.js" as Draw

Page
{
    id: page

    anchors.fill: parent

    Component.onCompleted:
    {
        var toolbarHintCounter = painter.getSetting("toolbarHintCounter", 0)
        if (toolbarHintCounter < 3)
        {
            painter.setSetting("toolbarHintCounter", ++toolbarHintCounter)
            toolbarInteractionHint.start()
        }
    }

    function checkPinchHint(tool)
    {
        var pinchHintCounter = painter.getSetting(tool + "PinchHintCounter", 0)
        if (pinchHintCounter < 2)
        {
            painter.setSetting(tool + "PinchHintCounter", ++pinchHintCounter)
            pinchHint.start()
            pinchHintSlave.start()
        }
    }

    Sensors.Accelerometer
    {
        id: accelerometer
        dataRate: 25
        active: textEditPending || insertImagePending

        property double angle: 0.0
        property double x: 0.0
        property double y: 0.0

        onReadingChanged:
        {
            x = (x*6 + reading.x) / 7
            y = (y*6 + reading.y) / 7

            var a

            if ( (Math.atan(y / Math.sqrt(y * y + x * x))) >= 0 )
                a = -(Math.acos(x / Math.sqrt(y * y + x * x)) - (Math.PI/2) )
            else
                a = Math.PI + (Math.acos(x / Math.sqrt(y * y + x * x)) - (Math.PI/2) )

            if (gridVisible && gridSnapTo)
                angle = a - ((a + Math.PI/72) % (Math.PI/36)) + Math.PI/72
            else
                angle = a

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

    Item
    {
        state: toolboxLocation
        onStateChanged: previewCanvas.clear()

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
            AnchorChanges
            {
                target: toolbarHintLabel
                anchors.top: undefined
                anchors.bottom: toolBox.top
            }
            PropertyChanges
            {
                target: toolbarHintLabel
                invert: false
            }
        } ]
    }

    Messagebox
    {
        id: messagebox
        rotation: rotationSensor.angle
    }

    Rectangle
    {
        id: toolBoxBackground
        z: 14

        anchors.top: page.top
        width: page.width
        height: toolBox.height + (geometryPopup.opacity != 0 ? geometryPopup.height : 0) + (dimensionPopup.opacity != 0 ? dimensionPopup.height : 0)
        color: Theme.highlightDimmerColor
        opacity: Math.max(0.0, toolBox.opacity - 0.15)

        MouseArea
        {
            // block missed presses from drawing on canvas behind
            anchors.fill: parent
        }
    }

    Toolbox
    {
        id: toolBox
        z: 15

        opacity: drawingCanvas.areaPressedAndHolded || pageStack.busy ? 0.0 : 1.0
        anchors.top: page.top
        onShowMessage: messagebox.showMessage(message, delay)
        onPreviewCanvasDrawText: { checkPinchHint("text"); insertNewText(); }
        onTextEditAccept: textAccept()
        onTextEditCancel: textCancel()
        onTextSettingsChanged: previewCanvas.requestPaint()
        onToggleGridVisibility: { gridVisible = !gridVisible; gridCanvas.requestPaint(); }
        onGridSettingsChanged: gridCanvas.requestPaint()
        onPreviewCanvasDrawImage: { checkPinchHint("image"); insertNewImage(); }
        onInsertImageAccept: acceptInsertedImage()
        onInsertImageCancel: cancelInsertedImage()
    }

    InteractionHintLabel
    {
        id: toolbarHintLabel
        text: qsTr("Swipe to change toolbar")
        anchors.top: toolBox.bottom
        invert: true
        opacity: toolbarInteractionHint.running ? 1.0 : 0.0
        Behavior on opacity { FadeAnimation { duration: 500 } }
    }

    TouchInteractionHint
    {
        id: toolbarInteractionHint
        z: 999
        direction: TouchInteraction.Right
        anchors.verticalCenter: toolBox.verticalCenter
        loops: 4
    }

    InteractionHintLabel
    {
        id: pinchHintLabel
        z: 999
        text: qsTr("Pinch to zoom")
        anchors.centerIn: page
        rotation: rotationSensor.angle
        Behavior on rotation { SmoothedAnimation { duration: 500 } }
        opacity: pinchHint.running ? 1.0 : 0.0
        Behavior on opacity { FadeAnimation { duration: 500 } }
    }

    TouchInteractionHint
    {
        id: pinchHint
        z: 999
        direction: TouchInteraction.Up
        anchors.horizontalCenter: parent.horizontalCenter
        loops: 3
    }

    TouchInteractionHint
    {
        id: pinchHintSlave
        z: 999
        direction: TouchInteraction.Down
        anchors.horizontalCenter: parent.horizontalCenter
        loops: 3
    }

    GeometryPopup
    {
        id: geometryPopup

        anchors.top: toolBox.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: (geometryPopupVisible && (drawMode === Painter.Geometrics)) ? 1.0 : 0.0
        Behavior on opacity { FadeAnimation {} }
        z: opacity != 0 ? 15 : 0
    }
    DimensionPopup
    {
        id: dimensionPopup

        anchors.top: toolBox.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: (dimensionPopupVisible && (drawMode === Painter.Dimensioning)) ? 1.0 : 0.0
        onOpacityChanged:
            if ((opacity == 0.0 || opacity == 1.0) && (drawMode !== Painter.Dimensioning))
            {
                dimensionMoveMode = false
                dimensionCanvas.requestPaint()
            }
        Behavior on opacity { FadeAnimation {} }
        z: opacity != 0 ? 15 : 0
    }

    Rectangle
    {
        id: bg
        z: 6
        anchors.fill: page
        color: bgColor < colors.length ? colors[bgColor] : "transparent"
        onColorChanged: gridCanvas.requestPaint()
    }

    Image
    {
        id: bgImg
        visible: useImageAsBackground
        z: 7
        source: backgroundImagePath
        height: backgroundImageRotate ? bg.width : bg.height
        width: backgroundImageRotate ? bg.height : bg.width
        anchors.centerIn: bg
        clip: true
        smooth: true
        rotation: backgroundImageRotate ? 90 : 0
        fillMode: Image.PreserveAspectFit
    }

    function textAccept()
    {
        textEditPending = false
        previewCanvas.clear()
        drawingCanvas.requestPaint()
    }

    function textCancel()
    {
        thisTextEntry = ""
        textEditPending = false
        previewCanvas.clear()
    }

    function acceptInsertedImage()
    {
        insertImagePending = false;
        previewCanvas.clear()
        drawingCanvas.requestPaint()
    }

    function cancelInsertedImage()
    {
        insertImagePending = false;
        previewCanvas.clear()
    }

    function insertNewText()
    {
        pinchtarget.scale = 1.0
        panX = width/2
        panY = height/2
        textEditPending = true
        previewCanvas.requestPaint()
    }

    function insertNewImage()
    {
        drawingCanvas.loadImage(insertImagePath)
        // Calculate scale so the image fits, and center it on screen
        pinchtarget.scale = Math.min(1.0, width/Math.max(insertedImage.width, insertedImage.height))
        panX = width/2
        panY = height/2
        insertImagePending = true
        previewCanvas.requestPaint()
    }

    SequentialAnimation
    {
         id: textEditActiveAnimation
         running: (textEditPending || dimensionPopupVisible) && !drawingCanvas.areaPressed
         loops: Animation.Infinite

         NumberAnimation { target: previewCanvas; property: "opacity"; to: 0.6; duration: 500; easing.type: Easing.InOutCubic }
         NumberAnimation { target: previewCanvas; property: "opacity"; to: 1.0; duration: 500; easing.type: Easing.InOutCubic }

         onRunningChanged:
         {
             if (!running)
                 previewCanvas.opacity = 1.0
         }
    }

    Image
    {
        // Dummy image to get image width and height
        id: insertedImage
        visible: false
        source: insertImagePath
    }

    Item
    {
        // Dummy item to get pinch scale
        id: pinchtarget
        onScaleChanged: pinchScale = scale
    }

    GridCanvas
    {
        id: gridCanvas
    }

    DimensionCanvas
    {
        id: dimensionCanvas
    }

    PreviewCanvas
    {
        id: previewCanvas
    }

    DrawingCanvas
    {
        id: drawingCanvas
    }

    LoupeCanvas
    {
        id: loupeCanvas
        opacity: drawMode == Painter.Dimensioning && drawingCanvas.areaPressed ? 1.0 : 0.0
        z: opacity !== 0.0 ? 16 : 0
    }
}
