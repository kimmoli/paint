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

    rotation: rotationSensor.angle
    Behavior on rotation { SmoothedAnimation { duration: 500 } }

    Image {
        opacity: (idUndoButton.enabled) ? 1 : 0.4
        anchors.centerIn: parent
        source: "image://theme/icon-m-delete"
        mirror:  true
        scale: 0.45
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
