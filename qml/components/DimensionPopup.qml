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
            selectedDimension = (selectedDimension > 0) ? --selectedDimension : dimensionModel.count-1
            dimensionCanvas.requestPaint()
            console.log("Selected dimension", selectedDimension)
        }
    }

    IconButton
    {
        icon.source: "image://theme/icon-m-right"
        anchors.bottom: parent.bottom
        enabled: dimensionModel.count > 1
        onClicked:
        {
            selectedDimension = (selectedDimension < dimensionModel.count-1) ? ++selectedDimension : 0
            dimensionCanvas.requestPaint()
            console.log("Selected dimension", selectedDimension)
        }
    }

    IconButton
    {
        icon.source: "image://theme/icon-m-edit"
        anchors.bottom: parent.bottom
        enabled: dimensionModel.count > 0
        onClicked:
        {
            var dimensionsDialog = pageStack.push(Qt.resolvedUrl("../pages/dimensionDialog.qml"),
                                                  { "currentDimensionScale": dimensionScale })

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
        icon.source: "image://theme/icon-m-dismiss"
        anchors.bottom: parent.bottom
        enabled: dimensionModel.count > 0
        onClicked:
        {
            dimensionModel.remove(selectedDimension)
            dimensionCanvas.requestPaint()
        }
    }
}
