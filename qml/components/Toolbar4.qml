import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Item
{
    id: toolbar3

    Row
    {
        spacing: (parent.width - 5*64-(parent.width - 5*64)/2)/6

        Item
        {
            height: 1
            width: 1.5 * parent.spacing
        }

        IconButton
        {
            icon.source: "image://theme/icon-m-close"
            anchors.bottom: parent.bottom
            rotation: rotationSensor.angle
            Behavior on rotation { SmoothedAnimation { duration: 500 } }

            onClicked: insertImageCancel()
        }

        IconButton
        {
            icon.source: "image://theme/icon-m-cloud-upload"
            anchors.bottom: parent.bottom
            rotation: rotationSensor.angle
            Behavior on rotation { SmoothedAnimation { duration: 500 } }

            onClicked: if (insertImageScale < 5.0)
                           insertImageScale += 0.05
        }

        IconButton
        {
            icon.source: "image://theme/icon-m-cloud-download"
            anchors.bottom: parent.bottom
            rotation: rotationSensor.angle
            Behavior on rotation { SmoothedAnimation { duration: 500 } }

            onClicked: if (insertImageScale > 0.1)
                           insertImageScale -= 0.05
        }
        IconButton
        {
            icon.source: "image://theme/icon-m-dialpad"
            anchors.bottom: parent.bottom
            rotation: rotationSensor.angle
            Behavior on rotation { SmoothedAnimation { duration: 500 } }

            onClicked: acceptInsertedImage()
        }
        IconButton
        {
            icon.source: "image://theme/icon-m-favorite"
            anchors.bottom: parent.bottom
            highlighted: drawMode === Painter.Image
            rotation: rotationSensor.angle
            Behavior on rotation { SmoothedAnimation { duration: 500 } }

            onClicked:
            {
                var imagePicker = pageStack.push("Sailfish.Pickers.ImagePickerPage");
                imagePicker.selectedContentChanged.connect(function()
                {
                    insertImagePath = imagePicker.selectedContent
                    drawMode = Painter.Image
                    previewCanvasDrawImage()
                });
            }
        }
    }
}
