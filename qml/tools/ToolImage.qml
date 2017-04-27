import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../components"

ToolbarButton
{
    icon.source: "image://paintIcons/icon-m-addimage"
    mode: Painter.Image

    onClicked:
    {
        if (insertImagePending)
        {
            insertImageCancel()
        }
        else
        {
            cancelPendingFunctions()
            var imagePicker = pageStack.push("Sailfish.Pickers.ImagePickerPage", { "allowedOrientations" : Orientation.All });
            imagePicker.selectedContentChanged.connect(function()
            {
                insertImagePath = "image://paintImage/" + imagePicker.selectedContent
                drawMode = mode
                previewCanvasDrawImage()
            });
        }
    }
}
