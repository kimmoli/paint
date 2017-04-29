import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../components"
import "../code/drawinghelpers.js" as Draw

MenuBase
{
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

    Label
    {
        text: layers.get(activeLayer).name
        visible: layers.count > 1
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: Theme.fontSizeMedium
        font.bold: true
        truncationMode: TruncationMode.Fade
        rotation: rotationSensor.angle == 180 ? 180 : 0
        width: Math.min(paintedWidth, Theme.itemSizeHuge )
    }

    Item
    {
        width: Theme.itemSizeMedium
        height: Theme.itemSizeMedium
        anchors.verticalCenter: parent.verticalCenter

        Image
        {
            source: "image://paintIcons/icon-m-visible" + (layers.get(activeLayer).show ? "" : "-not")
            visible: layers.count > 1
            anchors.centerIn: parent
            width: Theme.itemSizeSmall
            height: Theme.itemSizeSmall
            rotation: rotationSensor.angle
            Behavior on rotation { SmoothedAnimation { duration: 500 } }
        }
    }
}
