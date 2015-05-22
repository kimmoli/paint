import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Item
{
    id: toolbar4

    Row
    {
        property int n: children.length-1

        spacing: (parent.width - n*64-(parent.width - n*64)/2)/(n+1)

        Item
        {
            height: 1
            width: 1.5 * parent.spacing
        }

        ToolbarButton
        {
            icon.source: "image://theme/icon-m-swipe"
        }

        ToolbarButton
        {
            icon.source: "image://theme/icon-m-close"
            enabled: insertImagePending
            onClicked: insertImageCancel()
        }

        ToolbarButton
        {
            icon.source: "image://theme/icon-m-enter-accept"
            enabled: insertImagePending
            onClicked: acceptInsertedImage()
        }

        ToolbarButton
        {
            icon.source: "image://theme/icon-m-image"
            mode: Painter.Image

            onClicked:
            {
                var imagePicker = pageStack.push("Sailfish.Pickers.ImagePickerPage");
                imagePicker.selectedContentChanged.connect(function()
                {
                    insertImagePath = imagePicker.selectedContent
                    drawMode = mode
                    previewCanvasDrawImage()
                });
            }
        }
    }
}
