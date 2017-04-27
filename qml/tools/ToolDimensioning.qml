import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../components"

ToolbarButton
{
    icon.source: "image://paintIcons/icon-m-dimensiontool"
    mode: Painter.Dimensioning

    onClicked:
    {
        if (drawMode != mode)
        {
            drawingCanvas.saveActive()
            dimensionPopupVisible = true
        }
        else
        {
            dimensionPopupVisible = !dimensionPopupVisible
        }

        cancelPendingFunctions()
        drawMode = mode

        if (!dimensionPopupVisible)
            dimensionMoveMode = false

        previewCanvas.requestPaint()
        dimensionCanvas.requestPaint()
    }

    onHighlightedChanged: if (!highlighted) dimensionPopupVisible = false
}
