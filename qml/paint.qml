
import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

ApplicationWindow
{

    property var colors : [ "#ff0080", "#ff0000", "#ff8000", "#ffff00", "#00ff00",
                             "#00ff80", "#00ffff", "#0000ff", "#8000ff", "#ff00ff",
                             "#000000", "#ffffff" ] // also black and white

    property string acceptText : qsTr("Accept")
    property string cancelText : qsTr("Cancel")

    property int drawMode : Painter.Pen
    property int geometricsMode : Painter.Line

    property bool geometryPopupVisible: false

    property int drawColor: 0
    property int drawThickness: 3
    property int eraserThickness: 15
    property int sprayerRadius: 20
    property int sprayerDensity: 50
    property int sprayerParticleSize: 3
    property int sprayerColor: 0
    property int textColor: 0
    property int textFontSize: 40
    property bool textFontBold : false
    property bool textFontItalic : false
    property string textFont: (textFontBold ? "bold " : "") + (textFontItalic ? "italic " : "") + textFontSize + "px Arial"
    property bool textEditPending: false
    property string thisTextEntry : ""
    property int bgColor: colors.length
    property string toolboxLocation : "toolboxTop"
    property bool useImageAsBackground: false
    property string backgroundImagePath: "/usr/share/icons/hicolor/86x86/apps/harbour-paint.png"
    property bool backgroundImageRotate : false
    property real dimensionScale: 1.0

    /*****************************************************/

    initialPage: Qt.resolvedUrl("pages/Paint.qml")

    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    function getRandomFloat(min, max)
    {
      return Math.random() * (max - min) + min;
    }

    Painter
    {
        id: painter
        Component.onCompleted:
        {
            toolboxLocation = painter.getToolboxLocation()
        }
    }

}


