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
                cancelPendingFunctions()
                cropArea = [ 0,0,0,0 ]
                drawMode = mode
                previewCanvas.requestPaint()
            }
        }

        ToolbarButton
        {
            icon.source: clipboardPastePending ? "image://theme/icon-m-enter-accept" : "image://theme/icon-m-add"
            enabled: clipboardImage != null

            onClicked:
            {
                if (clipboardPastePending)
                {
                    var ctx = drawingCanvas.getContext('2d')
                    Draw.drawImageData(ctx, clipboardImage, panX, panY, accelerometer.angle, pinchScale)

                    drawingCanvas.requestPaint()
                    clipboardPastePending = false
                    previewCanvas.clear()
                }
                else
                {
                    cancelPendingFunctions()
                    drawMode = Painter.Clipboard
                    previewCanvas.clear()
                    pinchtarget.scale = 1.0
                    panX = previewCanvas.width/2
                    panY = previewCanvas.height/2
                    clipboardPastePending = true
                    previewCanvas.requestPaint()
                }
            }
        }

        ToolbarButton
        {
            icon.source: "image://theme/icon-m-page-down"
            enabled: (layers.count > 1) && (activeLayer < (layers.count-1))

            onClicked:
            {
                levelsButton.changeLayer(activeLayer+1)
            }
        }

        ToolbarButton
        {
            icon.source: "image://theme/icon-m-page-up"
            enabled: (layers.count > 1) && (activeLayer > 0)

            onClicked:
            {
                levelsButton.changeLayer(activeLayer-1)
            }
        }

        ToolbarButton
        {
            id: levelsButton
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
                    layers.remove(index)
                    if (index < activeLayer)
                        activeLayer--
                })
            }

            function changeLayer(index)
            {
                drawingCanvas.saveActive()

                var l = layersRep.itemAt(index)
                var ctx = drawingCanvas.getContext('2d')
                Draw.clear(ctx)
                ctx.drawImage(l, 0, 0)
                drawingCanvas.justPaint()

                activeLayer = index
            }

            function moveLayer(from, to)
            {
                layers.move(from, to, 1)

                if (from == activeLayer)
                    activeLayer = to
                else if (to == activeLayer)
                    activeLayer = from

            }
        }
    }
}
