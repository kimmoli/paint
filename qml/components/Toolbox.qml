import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Item
{
    id: toolBox

    ListModel
    {
        id: menuModel
        ListElement { name: "../tools/ToolAbout.qml";        submenu: "" }
        ListElement { name: "../tools/ToolBackground.qml";   submenu: "" }
        ListElement { name: "../tools/ToolClear.qml";        submenu: "" }
        ListElement { name: "../tools/ToolClipboard.qml";    submenu: "../tools/MenuClipboard.qml" }
        ListElement { name: "../tools/ToolDimensioning.qml"; submenu: "../tools/MenuDimensioning.qml" }
        ListElement { name: "../tools/ToolDraw.qml";         submenu: "../tools/MenuDraw.qml" }
        ListElement { name: "../tools/ToolEraser.qml";       submenu: "../tools/MenuEraser.qml" }
        ListElement { name: "../tools/ToolGeometrics.qml";   submenu: "../tools/MenuGeometrics.qml" }
        ListElement { name: "../tools/ToolGrid.qml";         submenu: "" }
        ListElement { name: "../tools/ToolImage.qml";        submenu: "../tools/MenuImage.qml" }
        ListElement { name: "../tools/ToolLayers.qml";       submenu: "../tools/MenuLayers.qml" }
        ListElement { name: "../tools/ToolSave.qml";         submenu: "" }
        ListElement { name: "../tools/ToolSettings.qml";     submenu: "" }
        ListElement { name: "../tools/ToolShader.qml";       submenu: "../tools/MenuShader.qml" }
        ListElement { name: "../tools/ToolSpray.qml";        submenu: "../tools/MenuSpray.qml" }
        ListElement { name: "../tools/ToolText.qml";         submenu: "../tools/MenuText.qml" }
        ListElement { name: "../tools/ToolCamera.qml";       submenu: "" }
    }

    anchors.horizontalCenter: parent.horizontalCenter
    height: mainToolBar.height + toolboxView.height
    width: parent.width

    property bool showAllTools: false
    property bool hide: false

    signal showMessage(string message, int delay)

    signal previewCanvasDrawText()
    signal textEditAccept()
    signal textEditCancel()
    signal textSettingsChanged()

    signal toggleGridVisibility()
    signal gridSettingsChanged()

    signal previewCanvasDrawImage()
    signal insertImageAccept()
    signal insertImageCancel()

    signal clipboardPasteCancel()
    signal colorChanged()

    signal shaderEditAccept()
    signal shaderEditCancel()

    function startRemorse()
    {
        dimensionPopupVisible = false
        geometryPopupVisible = false
        shaderPopupVisible = false
        cancelPendingFunctions()

        remorse.execute(qsTr("Clearing"), function()
        {
            drawingCanvas.clear()
            previewCanvas.clear()

            /* Clear also all dimensions created */
            dimensionModel.clear()
            dimensionCanvas.clear()

            /* Delete all layers and create one new */
            activeLayer = 0
            layers.clear()
            layers.append({name: "Layer 1", show: true})
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
                                                     "currentThickness": drawThickness,
                                                     "currentPenStyle": penStyle,
                                                     "brushContinuous": brushContinuous})

            SettingsDialog.accepted.connect(function() {
                drawColor = SettingsDialog.currentColor
                drawThickness = SettingsDialog.currentThickness
                penStyle = SettingsDialog.currentPenStyle
                brushContinuous = SettingsDialog.brushContinuous
                colorChanged()

                if (rememberToolSettings)
                {
                    painter.setToolSetting("drawColor", drawColor)
                    painter.setToolSetting("drawThickness", drawThickness)
                    painter.setToolSetting("penStyle", penStyle)
                    painter.setToolSetting("brushContinuous", brushContinuous ? 1 : 0)
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

    function cancelPendingFunctions()
    {
        if (textEditPending)
            textEditCancel()
        if (insertImagePending)
            insertImageCancel()
        if (clipboardPastePending || (clipboardImage != null))
            clipboardPasteCancel()
        if (shaderEditPending)
            shaderEditCancel()
    }

    RemorsePopup
    {
        id: remorse
        z: 21
        opacity: 1.0
        anchors.centerIn: parent
        rotation: rotationSensor.angle
        width: Math.abs(rotationSensor.angle) == 90 ? parent.height : parent.width
        Behavior on rotation { SmoothedAnimation { duration: 500 } }
        Behavior on width { SmoothedAnimation { duration: 500 } }

        Rectangle
        {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: Theme.itemSizeLarge
            width: Theme.itemSizeMedium
            height: width
            radius: width/2
            color: Qt.rgba(0, 0, 0, 0.6)

            IconButton
            {
                icon.source: "image://theme/icon-m-delete"
                anchors.centerIn: parent
                onClicked:
                {
                    remorse._execute()
                    remorse._timeout = 0
                    remorse._close()
                }
            }
        }
    }

    SilicaGridView
    {
        id: toolboxView
        width: parent.width
        height: showAllTools ? Theme.itemSizeMedium * Math.ceil(menuModel.count/6) : 0
        cellWidth: width/6
        cellHeight: Theme.itemSizeMedium
        clip: true

        anchors.bottom: mainToolBar.top

        Behavior on height { NumberAnimation { duration: 200 } }

        model: menuModel
        delegate: Loader
        {
            width: parent.cellWidth
            height: parent.cellHeight
            source: Qt.resolvedUrl(name)
        }
    }

    MainToolbar
    {
        id: mainToolBar
        clip: true
        height: hide ? 0 : Theme.itemSizeMedium

        anchors.bottom: parent.bottom
    }

    Rectangle
    {
        z: -1
        anchors.fill: parent

        color: Theme.highlightDimmerColor
        opacity: 0.85

        MouseArea
        {
            anchors.fill: parent
        }
    }

}
