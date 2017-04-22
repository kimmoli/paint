import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

ApplicationWindow
{
    id: window

    property var colors : [ "#ff0080", "#ff0000", "#ff8000", "#ffff00", "#00ff00",
                             "#00ff80", "#00ffff", "#0000ff", "#8000ff", "#ff00ff",
                             "#000000", "#ffffff" ] // also black and white

    property string dialogAcceptText : qsTr("Accept")
    property string dialogCancelText : qsTr("Cancel")

    property int vkbCloseInterval: 1000

    property int drawMode : Painter.Pen
    property int geometricsMode : Painter.Line

    property bool geometryPopupVisible: false
    property bool dimensionPopupVisible: false
    property bool shaderPopupVisible: false
    property bool geometryFill: false

    property int drawColor: 0
    property int drawThickness: 3
    property int penStyle: 0
    property bool brushContinuous: false
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
    property real textEntryX: 0.0
    property real textEntryY: 0.0
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
    property real pinchScale: 1.0
    property real panX: 0.0
    property real panY: 0.0
    property bool askSaveFilename: false
    property int polyVertices: 5
    property int textBalloonize: 0
    property bool showFps: false
    property int calculatedFps: 0
    property bool childsPlayMode: false

    property var cropArea: [ 0,0,0,0 ]

    property var clipboardImage: null
    property bool clipboardPastePending: false

    property var shaderEditPending: false
    property int activeShader: 0
    property bool shaderSelectAll: false

    property int activeLayer: 0
    property var pointData: []

    /*****************************************************/

    initialPage: Qt.resolvedUrl("pages/Paint.qml")

    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    function getRandomFloat(min, max)
    {
      return Math.random() * (max - min) + min;
    }

    onChildsPlayModeChanged:
    {
        helper.setGestureOverride(childsPlayMode)
        showChilsPlayModeIcon.running = childsPlayMode
    }

    Timer
    {
        id: showChilsPlayModeIcon
        interval: 10000
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
            childsPlayMode = (painter.getSetting("childsPlayMode", "false") === "true")

            /* Get fonts */
            for (var i=0 ; i<painter.getNumberOfFonts(); i++)
            {
                fontList.append( {"number": i, "name": painter.getFontName(i) } )
            }

            /* Get tool settings */
            drawColor = painter.getToolSetting("drawColor", 0)
            drawThickness = painter.getToolSetting("drawThickness", 3)
            penStyle = painter.getToolSetting("penStyle", 0)
            brushContinuous = (painter.getToolSetting("brushContinuous", 0) === 1)
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
            /* Show FPS only on devel version */
            showFps = (painter.version.indexOf("devel") > -1)
            layers.append({name: "Layer 1", show: true})
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

    ListModel
    {
        id: layers
    }
}
