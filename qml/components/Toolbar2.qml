import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Row
{
    id: toolbar2

    Component.onCompleted: drawMode = Painter.None

    IconButton
    {
        icon.source: "image://theme/icon-m-keyboard" /* Todo: better icon? */
        anchors.bottom: parent.bottom
        highlighted: drawMode === Painter.Text

        onClicked:
        {
            var textEntryDialog = pageStack.push(Qt.resolvedUrl("../pages/textEntryDialog.qml"),
                                                 { "currentColor": textColor,
                                                   "currentSize": textFontSize })

            textEntryDialog.accepted.connect(function()
            {
                thisTextEntry = textEntryDialog.newText
                textColor = textEntryDialog.currentColor
                textFontSize = textEntryDialog.currentSize
                console.log("You entered " + thisTextEntry)
                if (thisTextEntry.length>0)
                    drawMode = Painter.Text
                else
                    drawMode = Painter.None
            })
        }
    }
}
