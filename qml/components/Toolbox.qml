import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Row
{
    id: toolBox

    anchors.horizontalCenter: parent.horizontalCenter
    height: 80
    width: parent.width

    property var toolbar
    property var popup

    property int toolbarNumber : 1
    property int maxToolbars: 3

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

    function startRemorse()
    {
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

    function changeToolBar(number)
    {
        if (toolbar)
            toolbar.destroy()

        var toolbarComp = Qt.createComponent(Qt.resolvedUrl("../components/Toolbar" + number + ".qml"))
        toolbar = toolbarComp.createObject(toolBox)
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

    Component.onCompleted: changeToolBar(toolbarNumber)

    RemorsePopup
    {
        id: remorse
        z: 21
        opacity: 1.0
        anchors.verticalCenter: parent.verticalCenter
    }

    IconButton
    {
        icon.source: "image://theme/icon-m-repeat"
        icon.scale: 0.6
        anchors.verticalCenter: parent.verticalCenter
        rotation: rotationSensor.angle
        Behavior on rotation { SmoothedAnimation { duration: 500 } }

        onClicked:
        {
            hideGeometryPopup()
            hideDimensionPopup()
            dimensionMoveMode = false

            toolbarNumber = (toolbarNumber >= maxToolbars) ? 1 : (++toolbarNumber)
            changeToolBar(toolbarNumber)
        }
    }
    Rectangle
    {
        height: 1
        width: 16
        color: "transparent"
    }
}
