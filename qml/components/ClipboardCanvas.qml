import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Canvas
{
    anchors.centerIn: parent
    visible: false

    onPaint:
    {
        if (drawMode == Painter.Clipboard && clipboardImage != null)
        {
            var ctx = getContext('2d')
            ctx.drawImage(clipboardImage, 0, 0)
        }
    }
}
