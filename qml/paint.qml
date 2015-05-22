
import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

ApplicationWindow
{

    property var colors : [ "#ff0080", "#ff0000", "#ff8000", "#ffff00", "#00ff00",
                             "#00ff80", "#00ffff", "#0000ff", "#8000ff", "#ff00ff",
                             "#000000", "#ffffff" ] // also black and white

    property string dialogAcceptText : qsTr("Accept")
    property string dialogCancelText : qsTr("Cancel")

    property int drawMode : Painter.Pen
    property int geometricsMode : Painter.Line

    property bool geometryPopupVisible: false
    property bool dimensionPopupVisible: false
    property bool geometryFill: false

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
    property int textFontNameIndex: 0
    property string textFontName: painter.getFontName(textFontNameIndex)
    property string textFont: (textFontBold ? "bold " : "") + (textFontItalic ? "italic " : "") + textFontSize + "px " + textFontName
    property bool textEditPending: false
    property string thisTextEntry : ""
    property int bgColor: colors.length
    property string toolboxLocation : "toolboxTop"
    property bool useImageAsBackground: false
    property string backgroundImagePath: "/usr/share/icons/hicolor/86x86/apps/harbour-paint.png"
    property bool backgroundImageRotate : false
    property real dimensionScale: 1.0
    property int selectedDimension: 0
    property string iconMove : "/usr/share/harbour-paint/qml/icons/icon-m-move.png"
    property bool dimensionMoveMode: false
    property int dimensionMoveEnd: 0
    property int gridSpacing: 50
    property bool gridSnapTo: false
    property bool gridVisible: false
    property bool isColorWheel: false
    property bool rememberToolSettings: false
    property string insertImagePath: ""
    property bool insertImagePending: false
    property real insertImageScale: 1.0
    property real insertImageX: 0.0
    property real insertImageY: 0.0
    property bool askSaveFilename: false

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
            /* Get general settings */
            toolboxLocation = painter.getSetting("toolboxLocation", "toolboxTop")
            gridSpacing = painter.getSetting("gridSpacing", 50)
            gridSnapTo = (painter.getSetting("gridSnapTo", "false") === "true")
            rememberToolSettings = (painter.getSetting("rememberToolSettings", "false") === "true")
            askSaveFilename = (painter.getSetting("askSaveFilename", "false") === "true")

            /* Get fonts */
            for (var i=0 ; i<painter.getNumberOfFonts(); i++)
            {
                console.log("font " + i + " is " + painter.getFontName(i))
                fontList.append( {"number": i, "name": painter.getFontName(i) } )
            }

            /* Get tool settings */
            drawColor = painter.getToolSetting("drawColor", 0)
            drawThickness = painter.getToolSetting("drawThickness", 3)
            eraserThickness = painter.getToolSetting("eraserThickness", 15)
            sprayerRadius = painter.getToolSetting("sprayerRadius", 20)
            sprayerDensity = painter.getToolSetting("sprayerDensity", 50)
            sprayerParticleSize = painter.getToolSetting("sprayerParticleSize", 3)
            sprayerColor = painter.getToolSetting("sprayerColor", 0)
            textColor = painter.getToolSetting("textColor", 0)
            textFontSize = painter.getToolSetting("textFontSize", 40)
            textFontNameIndex = painter.getToolSetting("textFontNameIndex", 0)
            textFontBold = (painter.getToolSetting("textFontBold", 0) === 1)
            textFontItalic = (painter.getToolSetting("textFontItalic", 0) === 1)
            bgColor = painter.getToolSetting("bgColor", colors.length)
        }
    }

    ListModel
    {
        id: dimensionModel
    }

    ListModel
    {
        id: fontList
    }
}


