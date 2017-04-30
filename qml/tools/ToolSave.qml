import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../components"

ToolbarButton
{
    id: saveButton
    icon.source: "image://paintIcons/icon-m-save"

    property bool pageStackBusy : pageStack.busy
    property bool doSave : false
    property string saveFileName: ""
    property bool cropPending: false

    Timer
    {
        id: letTheBusyIndShow
        interval: 200
        onTriggered: saveButton.save(saveButton.saveFileName)
    }

    onPageStackBusyChanged:
    {
        if (!pageStackBusy && doSave && askSaveFilename)
        {
            doSave = false
            save(saveFileName)
        }
    }

    onClicked:
    {
        cancelPendingFunctions()
        geometryPopupVisible = false
        dimensionPopupVisible = false
        shaderPopupVisible = false

        dimensionCanvas.requestPaint()
        drawingCanvas.saveActive()

        if (cropPending && drawMode === Painter.Crop)
        {
            cropPending = false
            drawMode = prevDrawMode
            previewCanvas.clear()
            busyInd.running = true
            letTheBusyIndShow.start()
            return
        }

        cropPending = false
        cropArea = [ 0,0,0,0 ]

        var fileName = ""
        if (askSaveFilename)
        {
            var askFilenameDialog = pageStack.push(Qt.resolvedUrl("../pages/askFilenameDialog.qml"), {
                                                   "saveFormat": painter.getSetting("fileExtension", "png")})

            askFilenameDialog.accepted.connect(function()
            {
                saveFileName = askFilenameDialog.filename
                if (askFilenameDialog.crop)
                {
                    cropPending = true
                    showMessage(qsTr("Mark area and click save again"), 0)
                    prevDrawMode = drawMode
                    drawMode = Painter.Crop
                }
                else
                {
                    doSave = true
                    busyInd.running = true
               }
            })
        }
        else
        {
            busyInd.running = true
            saveFileName = fileName
            letTheBusyIndShow.start()
        }
    }

    function save(fileName)
    {
        var ctx = drawingCanvas.getContext('2d')
        Draw.clear(ctx)

        for (var i=(layers.count-1) ; i >= 0; i--)
        {
            if (layers.get(i).show)
                ctx.drawImage(layersRep.itemAt(i), 0, 0)
        }
        if (dimensionModel.count > 0)
            ctx.drawImage(dimensionCanvas, 0, 0)

        drawingCanvas.justPaint()

        var dataUrl1 = drawingCanvas.toDataURL()

        painter.saveCanvas(dataUrl1,
                           useImageAsBackground ? backgroundImagePath : (bgColor < colors.length ? colors[bgColor] : "" ),
                           backgroundImageRotate,
                           rotationSensor.angle,
                           fileName,
                           cropArea)
    }
}
