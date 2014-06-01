
import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

ApplicationWindow
{

    property var colors : [ "#ff0080", "#ff0000", "#ff8000", "#ffff00", "#00ff00",
                             "#00ff80", "#00ffff", "#0000ff", "#8000ff", "#ff00ff",
                             "#000000", "#ffffff" ] // also black and white

    property var thicknesses : [ 2, 5, 10, 15 ]

    property string acceptText : qsTr("Accept")
    property string cancelText : qsTr("Cancel")

    property bool showTooldrawer: false

    property int drawMode : Painter.Pen
    property int geometricsMode : Painter.Line

    property bool geometryPopupVisible: false


    /*****************************************************/

    initialPage: Qt.resolvedUrl("pages/Paint.qml")

    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    Painter
    {
        id: painter
    }

}


