import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0



Row
{
    id: dimensionPopup

    IconButton
    {
        icon.source: "image://theme/icon-m-left"
        anchors.bottom: parent.bottom
        enabled: dimensionModel.count > 1
        onClicked:
        {
            dimensionMoveMode = false
            selectedDimension = (selectedDimension > 0) ? --selectedDimension : dimensionModel.count-1
            dimensionCanvas.requestPaint()
        }
    }

    IconButton
    {
        icon.source: "image://theme/icon-m-right"
        anchors.bottom: parent.bottom
        enabled: dimensionModel.count > 1
        onClicked:
        {
            dimensionMoveMode = false
            selectedDimension = (selectedDimension < dimensionModel.count-1) ? ++selectedDimension : 0
            dimensionCanvas.requestPaint()
        }
    }

    IconButton
    {
        icon.source: "image://theme/icon-m-edit"
        anchors.bottom: parent.bottom
        enabled: dimensionModel.count > 0
        onClicked:
        {
            dimensionMoveMode = false
            var dimensionsDialog = pageStack.push(Qt.resolvedUrl("../pages/dimensionDialog.qml"),
                                                  { "currentDimensionScale": dimensionScale })

            dimensionsDialog.accepted.connect(function()
            {
                dimensionScale = dimensionsDialog.currentDimensionScale
                dimensionCanvas.requestPaint()
            })
        }
    }
    IconButton
    {
        icon.source: "image://paintIcons/icon-m-move"
        anchors.bottom: parent.bottom
        enabled: dimensionModel.count > 0
        highlighted: dimensionMoveMode
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
        onClicked:
        {
            dimensionMoveMode = false
            dimensionModel.remove(selectedDimension)
            if (selectedDimension > dimensionModel.count-1 && selectedDimension > 0)
                selectedDimension = dimensionModel.count-1
            dimensionCanvas.requestPaint()
        }
    }
}
