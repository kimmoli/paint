import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../code/drawinghelpers.js" as Draw

Item
{
    id: toolbar4

    Row
    {
        spacing: (parent.width - children.length*80)/(children.length+1)
        anchors.horizontalCenter: parent.horizontalCenter

        ToolbarButton
        {
            icon.source: "image://theme/icon-m-clipboard"
            mode: Painter.Clipboard

            onClicked:
            {
                previewCanvas.clipboardPreviewImage = false
                cropArea = [ 0,0,0,0 ]
                cancelPendingFunctions()
                drawMode = mode
                previewCanvas.requestPaint()
            }
        }

        ToolbarButton
        {
            icon.source: previewCanvas.clipboardPreviewImage ? "image://theme/icon-m-enter-accept" : "image://theme/icon-m-add"
            enabled: clipboardImage != null

            onClicked:
            {
                if (previewCanvas.clipboardPreviewImage)
                {
                    var ctx = drawingCanvas.getContext('2d')
                    Draw.drawImageData(ctx, clipboardImage, panX, panY, accelerometer.angle, pinchScale)

                    drawingCanvas.requestPaint()
                    previewCanvas.clipboardPreviewImage = false
                    previewCanvas.clear()
                }
                else
                {
                    previewCanvas.clear()
                    pinchtarget.scale = 1.0
                    panX = previewCanvas.width/2
                    panY = previewCanvas.height/2
                    previewCanvas.clipboardPreviewImage = true
                    previewCanvas.requestPaint()
                }
            }
        }
        ToolbarButton
        {
            icon.source: "image://theme/icon-m-clear"
            enabled: clipboardImage != null

            onClicked:
            {
                previewCanvas.clipboardPreviewImage = false
                previewCanvas.clear()
                clipboardImage = null
                cropArea = [ 0,0,0,0 ]
            }
        }

        ToolbarButton
        {
            icon.source: "image://theme/icon-m-levels"

            Label
            {
                anchors.centerIn: parent
                text: layers.count
                font.pixelSize: Theme.fontSizeLarge
                font.bold: true
            }

            onClicked:
            {
                cancelPendingFunctions()
                var ls = pageStack.push(Qt.resolvedUrl("../pages/layersDialog.qml"))
                ls.addNewLayer.connect(function()
                {
                    layers.insert(0, {name: "Layer " + Number(layers.count+1), show: true})
                    activeLayer++
                    console.log("new layer added")
                })
                ls.changeLayer.connect(function(index)
                {
                    changeLayer(index)
                })
                ls.moveLayer.connect(function(from, to)
                {
                    moveLayer(from, to)
                })
                ls.removeLayer.connect(function(index)
                {
                    console.log("remove layer " + index)
                    layers.remove(index)
                    if (index < activeLayer)
                        activeLayer--
                })
            }

            function changeLayer(index)
            {
                console.log("store to " + activeLayer + ", change to layer " + index)

                var l = layersRep.itemAt(activeLayer)
                var ctx = l.getContext('2d')
                ctx.drawImage(drawingCanvas, 0, 0)
                l.requestPaint()

                l = layersRep.itemAt(index)
                ctx = drawingCanvas.getContext('2d')
                Draw.clear(ctx)
                ctx.drawImage(l, 0, 0)
                drawingCanvas.justPaint()

                activeLayer = index
            }

            function moveLayer(from, to)
            {
                console.log("move from " + from + " to " + to)

                layers.move(from, to, 1)

                if (from == activeLayer)
                    activeLayer = to
                else if (to == activeLayer)
                    activeLayer = from

            }
        }
    }
}
