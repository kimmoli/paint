import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Item
{
    id: toolBox

    anchors.horizontalCenter: parent.horizontalCenter
    height: 80
    width: parent.width

    property var toolbar
    property var popup

    property int toolbarNumber : 1
    property int maxToolbars: 4

    signal showMessage(string message, int delay)
    signal showGeometryPopup()
    signal toggleGeometryPopup()
    signal hideGeometryPopup()
    signal showDimensionPopup()
    signal toggleDimensionPopup()
    signal hideDimensionPopup()

    signal textEditAccept()
    signal textEditCancel()
    signal textSettingsChanged()

    signal toggleGridVisibility()
    signal gridSettingsChanged()

    signal previewCanvasDrawImage()
    signal insertImageAccept()
    signal insertImageCancel()

    function startRemorse()
    {
        toolBox.opacity = 0.0
        hideDimensionPopup()
        hideGeometryPopup()
        remorse.execute(qsTr("Clearing"), function()
        {
            canvas.clear()
            previewCanvas.clear()

            if (textEditPending)
                textEditCancel()

            /* Clear also all dimensions created */
            dimensionModel.clear()
            dimensionCanvas.clear()
        })
    }

    function showToolSettings()
    {
        var SettingsDialog

        switch (drawMode)
        {
        case Painter.Eraser :
            SettingsDialog = pageStack.push(Qt.resolvedUrl("../pages/eraserSettingsDialog.qml"),
                                                   { "currentThickness": eraserThickness })

            SettingsDialog.accepted.connect(function() {
                eraserThickness = SettingsDialog.currentThickness
                if (rememberToolSettings)
                {
                    painter.setToolSetting("eraserThickness", eraserThickness)
                }
            })

            break;

        case Painter.Spray :
            SettingsDialog = pageStack.push(Qt.resolvedUrl("../pages/spraySettingsDialog.qml"),
                                                   { "currentRadius": sprayerRadius,
                                                     "currentParticleSize": sprayerParticleSize,
                                                     "currentDensity": sprayerDensity,
                                                     "currentColor": sprayerColor})

            SettingsDialog.accepted.connect(function() {
                sprayerRadius = SettingsDialog.currentRadius
                sprayerParticleSize = SettingsDialog.currentParticleSize
                sprayerDensity = SettingsDialog.currentDensity
                sprayerColor = SettingsDialog.currentColor
                if (rememberToolSettings)
                {
                    painter.setToolSetting("sprayerRadius", sprayerRadius)
                    painter.setToolSetting("sprayerParticleSize", sprayerParticleSize)
                    painter.setToolSetting("sprayerDensity", sprayerDensity)
                    painter.setToolSetting("sprayerColor", sprayerColor)
                }
            })

            break;

        case Painter.Geometrics:
        case Painter.Pen :
            SettingsDialog = pageStack.push(Qt.resolvedUrl("../pages/penSettingsDialog.qml"),
                                                   { "currentColor": drawColor,
                                                     "currentThickness": drawThickness })

            SettingsDialog.accepted.connect(function() {
                drawColor = SettingsDialog.currentColor
                drawThickness = SettingsDialog.currentThickness
                if (rememberToolSettings)
                {
                    painter.setToolSetting("drawColor", drawColor)
                    painter.setToolSetting("drawThickness", drawThickness)
                }
            })

            break;

        case Painter.Text:
            SettingsDialog = pageStack.push(Qt.resolvedUrl("../pages/textSettingsDialog.qml"),
                                                 { "currentColor": textColor,
                                                   "currentSize": textFontSize,
                                                   "isBold": textFontBold,
                                                   "isItalic": textFontItalic,
                                                   "fontNameIndex": textFontNameIndex})

            SettingsDialog.accepted.connect(function()
            {
                textColor = SettingsDialog.currentColor
                textFontSize = SettingsDialog.currentSize
                textFontBold = SettingsDialog.isBold
                textFontItalic = SettingsDialog.isItalic
                textFontNameIndex = SettingsDialog.fontNameIndex
                textSettingsChanged()
                if (rememberToolSettings)
                {
                    painter.setToolSetting("textColor", textColor)
                    painter.setToolSetting("textFontSize", textFontSize)
                    painter.setToolSetting("textFontBold", textFontBold)
                    painter.setToolSetting("textFontItalic", textFontItalic)
                    painter.setToolSetting("textFontNameIndex", textFontNameIndex)
                }
            })
            break;
        case Painter.Dimensioning:
            SettingsDialog = pageStack.push(Qt.resolvedUrl("../pages/penSettingsDialog.qml"),
                                                   { "currentColor": drawColor,
                                                     "currentThickness": drawThickness })

            SettingsDialog.accepted.connect(function() {
                drawColor = SettingsDialog.currentColor
                drawThickness = SettingsDialog.currentThickness
                if (rememberToolSettings)
                {
                    painter.setToolSetting("drawColor", drawColor)
                    painter.setToolSetting("drawThickness", drawThickness)
                }
            })
            break;
        default:
            break;
        }
    }

    Behavior on opacity
    {
        FadeAnimation {}
    }

    RemorsePopup
    {
        id: remorse
        z: 21
        opacity: 1.0
        anchors.centerIn: parent
        rotation: rotationSensor.angle
        width: Math.abs(rotation) == 90 ? parent.height : parent.width
        onCanceled: toolBox.opacity = 1.0
        onTriggered: toolBox.opacity = 1.0
    }

    PathView
    {
        id: toolboxView
        anchors.fill: parent
        preferredHighlightBegin: 1/4
        preferredHighlightEnd: 2/4
        offset: 2.0
        model: ListModel
        {
            ListElement { name: "Toolbar3.qml" }
            ListElement { name: "Toolbar4.qml" }
            ListElement { name: "Toolbar1.qml" }
            ListElement { name: "Toolbar2.qml" }
        }
        delegate: Loader
        {
            width: toolboxView.width
            height: toolboxView.height
            source: Qt.resolvedUrl(name)
        }
        path: Path
        {
            startX: - (toolboxView.width / 2)
            startY: toolboxView.height / 2
            PathLine
            {
                x: (toolboxView.model.count * toolboxView.width) - (toolboxView.width / 2)
                y: toolboxView.height / 2
            }
        }
    }
}
