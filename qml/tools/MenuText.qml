import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../components"

MenuBase
{
    ToolbarButton
    {
        icon.source: "image://paintIcons/icon-m-texttool"
        mode: Painter.Text

        onClicked:
        {
            if (textEditPending)
            {
                textEditCancel()
            }

            cancelPendingFunctions()
            var textEntryDialog = pageStack.push(Qt.resolvedUrl("../pages/textEntryDialog.qml"))

            textEntryDialog.accepted.connect(function()
            {
                thisTextEntry = textEntryDialog.newText
                if (thisTextEntry.length>0)
                {
                    drawMode = mode
                    previewCanvasDrawText()
                }
            })
        }
    }

    ToolbarButton
    {
        icon.source: "image://paintIcons/icon-m-textsettings"

        onClicked:
        {
            showToolSettings()
        }
    }

    ToolbarButton
    {
        icon.source: "image://theme/icon-m-enter-accept"
        enabled: textEditPending

        onClicked:
        {
            textEditAccept()
        }
    }

    ToolbarButton
    {
        icon.source: "image://theme/icon-m-reset"
        enabled: textEditPending

        onClicked:
        {
            textEditCancel()
        }
    }

}
