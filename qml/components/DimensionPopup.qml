import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Row
{
    id: dimensionPopup
    spacing: (parent.width - children.length*80)/(children.length+1)
    anchors.horizontalCenter: parent.horizontalCenter

    IconButton
    {
        icon.source: "image://theme/icon-m-left"
        anchors.bottom: parent.bottom
        enabled: dimensionModel.count > 1
        rotation: rotationSensor.angle
        Behavior on rotation { SmoothedAnimation { duration: 500 } }
        onClicked:
        {
            dimensionMoveMode = false
            selectedDimension = (selectedDimension > 0) ? --selectedDimension : dimensionModel.count-1
            dimensionCanvas.requestPaint()
            previewCanvas.requestPaint()
        }
    }

    IconButton
    {
        icon.source: "image://theme/icon-m-right"
        anchors.bottom: parent.bottom
        enabled: dimensionModel.count > 1
        rotation: rotationSensor.angle
        Behavior on rotation { SmoothedAnimation { duration: 500 } }
        onClicked:
        {
            dimensionMoveMode = false
            selectedDimension = (selectedDimension < dimensionModel.count-1) ? ++selectedDimension : 0
            dimensionCanvas.requestPaint()
            previewCanvas.requestPaint()
        }
    }

    IconButton
    {
        icon.source: "image://theme/icon-m-edit"
        anchors.bottom: parent.bottom
        enabled: dimensionModel.count > 0
        rotation: rotationSensor.angle
        Behavior on rotation { SmoothedAnimation { duration: 500 } }
        onClicked:
        {
            dimensionMoveMode = false
            var dimensionsDialog = pageStack.push(Qt.resolvedUrl("../pages/dimensionDialog.qml"),
                                                  { "currentDimensionScale": dimensionScale })

            dimensionsDialog.accepted.connect(function()
            {
                dimensionScale = dimensionsDialog.currentDimensionScale
                dimensionCanvas.requestPaint()
                previewCanvas.requestPaint()
            })
        }
    }
    IconButton
    {
        icon.source: "image://paintIcons/icon-m-move"
        anchors.bottom: parent.bottom
        enabled: dimensionModel.count > 0
        highlighted: dimensionMoveMode
        rotation: rotationSensor.angle
        Behavior on rotation { SmoothedAnimation { duration: 500 } }
        onClicked:
        {
            dimensionMoveMode = !dimensionMoveMode
        }
    }

    IconButton
    {
        icon.source: "image://theme/icon-m-dismiss"
        anchors.bottom: parent.bottom
        enabled: dimensionModel.count > 0
        rotation: rotationSensor.angle
        Behavior on rotation { SmoothedAnimation { duration: 500 } }
        onClicked:
        {
            dimensionMoveMode = false
            dimensionModel.remove(selectedDimension)
            if (selectedDimension > dimensionModel.count-1 && selectedDimension > 0)
                selectedDimension = dimensionModel.count-1
            dimensionCanvas.requestPaint()
            previewCanvas.requestPaint()
        }
    }

    ToolbarButton
    {
        id: toolSettingsButton
        icon.source: "image://paintIcons/icon-m-textsettings"
        onClicked:
        {
            var TextSettingsDialog = pageStack.push(Qt.resolvedUrl("../pages/textSettingsDialog.qml"),
                                                 { "currentColor": textColor,
                                                   "currentSize": textFontSize,
                                                   "isBold": textFontBold,
                                                   "isItalic": textFontItalic,
                                                   "fontNameIndex": textFontNameIndex})

            TextSettingsDialog.accepted.connect(function()
            {
                textColor = TextSettingsDialog.currentColor
                textFontSize = TextSettingsDialog.currentSize
                textFontBold = TextSettingsDialog.isBold
                textFontItalic = TextSettingsDialog.isItalic
                textFontNameIndex = TextSettingsDialog.fontNameIndex
                textSettingsChanged()
                if (rememberToolSettings)
                {
                    painter.setToolSetting("textColor", textColor)
                    painter.setToolSetting("textFontSize", textFontSize)
                    painter.setToolSetting("textFontBold", textFontBold)
                    painter.setToolSetting("textFontItalic", textFontItalic)
                    painter.setToolSetting("textFontNameIndex", textFontNameIndex)
                }
            })
        }
    }

}
