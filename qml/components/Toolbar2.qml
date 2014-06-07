import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Row
{
    id: toolbar2

    IconButton
    {
        icon.source: "image://paintIcons/icon-m-texttool"
        anchors.bottom: parent.bottom
        highlighted: drawMode === Painter.Text

        onClicked:
        {
            toolSettingsButton.icon.source = "image://paintIcons/icon-m-textsettings"
            drawMode = Painter.Text
            if (textEditPending)
                textEditCancel()
        }
    }

    IconButton
    {
        icon.source: "image://theme/icon-m-enter-accept"
        anchors.bottom: parent.bottom
        enabled: textEditPending

        onClicked: textEditAccept()
    }

    IconButton
    {
        icon.source: "image://paintIcons/icon-m-dimensiontool"
        anchors.bottom: parent.bottom
        highlighted: drawMode === Painter.Dimensioning

        onClicked:
        {
            toolSettingsButton.icon.source = "image://paintIcons/icon-m-toolsettings"
            drawMode = Painter.Dimensioning
        }
    }

    IconButton
    {
        icon.source: "image://theme/icon-m-right"
        anchors.bottom: parent.bottom
        enabled: (drawMode === Painter.Dimensioning) && (dimensionModel.count > 0)

        onClicked:
        {
            var d = dimensionModel.get(0)
            var seglen = Math.sqrt(Math.pow(Math.abs(d["x1"]-d["x0"]), 2) + Math.pow(Math.abs(d["y1"]-d["y0"]), 2))

            var dimensionsDialog = pageStack.push(Qt.resolvedUrl("../pages/dimensionDialog.qml"),
                                                  { "currentDimensionScale": dimensionScale,
                                                    "currentDimension": seglen })

            dimensionsDialog.accepted.connect(function()
            {
                dimensionScale = dimensionsDialog.currentDimensionScale
                console.log("New scale is " + dimensionScale)
                dimensionCanvas.requestPaint()
            })

        }
    }

    IconButton
    {
        id: toolSettingsButton
        icon.source: "image://paintIcons/icon-m-toolsettings"
        anchors.bottom: parent.bottom

        onClicked:
        {
            var SettingsDialog

            switch (drawMode)
            {
            case Painter.Text:
                SettingsDialog = pageStack.push(Qt.resolvedUrl("../pages/textSettingsDialog.qml"),
                                                     { "currentColor": textColor,
                                                       "currentSize": textFontSize,
                                                       "isBold": textFontBold,
                                                       "isItalic": textFontItalic })

                SettingsDialog.accepted.connect(function()
                {
                    textColor = SettingsDialog.currentColor
                    textFontSize = SettingsDialog.currentSize
                    textFontBold = SettingsDialog.isBold
                    textFontItalic = SettingsDialog.isItalic
                    textSettingsChanged()
                })
                break;
            case Painter.Dimensioning:
                SettingsDialog = pageStack.push(Qt.resolvedUrl("../pages/penSettingsDialog.qml"),
                                                       { "currentColor": drawColor,
                                                         "currentThickness": drawThickness })

                SettingsDialog.accepted.connect(function() {
                    drawColor = SettingsDialog.currentColor
                    drawThickness = SettingsDialog.currentThickness
                })
                break;
            default:
                break;
            }

        }
    }

}
