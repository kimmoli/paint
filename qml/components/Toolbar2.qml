import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Row
{
    id: toolbar2

    IconButton
    {
        icon.source: "image://theme/icon-m-keyboard" /* Todo: better icon? */
        anchors.bottom: parent.bottom
        highlighted: drawMode === Painter.Text

        onClicked:
        {
            drawMode = Painter.Text
        }
    }

    Rectangle
    {
        color: "transparent"
        width: 80
        height: width
    }

    Rectangle
    {
        color: "transparent"
        width: 80
        height: width
    }

    Rectangle
    {
        color: "transparent"
        width: 80
        height: width
    }


    IconButton
    {
        icon.source: "image://paintIcons/icon-m-toolsettings" /* Todo: better icon? */
        anchors.bottom: parent.bottom

        onClicked:
        {
            var SettingsDialog

            switch (drawMode)
            {
                case Painter.Text :
                    SettingsDialog = pageStack.push(Qt.resolvedUrl("../pages/textSettingsDialog.qml"),
                                                                 { "currentColor": textColor })

                    SettingsDialog.accepted.connect(function() {
                        textColor = SettingsDialog.currentColor
                    })

                    break;

                default :
                    break;
            }
        }
    }
}
