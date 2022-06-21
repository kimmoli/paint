import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

IconButton
{
    id: idUndoButton
    enabled: ( (cStep+1) > 0 ) ? true : false

    property int mode: Painter.None

    highlighted: drawMode === mode

    anchors.bottom: parent.bottom
    icon.source: "../icons/icon-m-undo.svg"
    icon.width: Theme.iconSizeMedium
    icon.height: Theme.iconSizeMedium

    height: parent.height
    rotation: rotationSensor.angle
    Behavior on rotation { SmoothedAnimation { duration: 500 } }
    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: Theme.fontSizeSmall
        text: cStep + 1
        scale: 1/1.5
    }

    /*
    onClicked: {
        toolThicknessVisible = false
        toolImageVisible = false
        toolColorsPenVisible = false
        toolColorsPageVisible = false
        toolLineCapVisible = false
        freeDrawCanvas.undo_draw()
    }*/
    /*onPressAndHold: {
        toolThicknessVisible = false
        toolImageVisible = false
        toolColorsPenVisible = false
        toolColorsPageVisible = false
        toolSaveVisible = false
        remorse.execute( parent, qsTr("Clear drawing?"), function() {
            freeDrawCanvas.clear_canvas()
        })
    }*/
}
