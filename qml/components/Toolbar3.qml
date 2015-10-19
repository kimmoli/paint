import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../code/drawinghelpers.js" as Draw

Item
{
    id: toolbar3

    property bool cropPending: false
    property int prevDrawMode: Painter.None

    Row
    {
        spacing: (parent.width - children.length*80)/(children.length+1)
        anchors.horizontalCenter: parent.horizontalCenter

        ToolbarButton
        {
            icon.source: "image://theme/icon-m-about"

            onClicked:
            {
                pageStack.push(Qt.resolvedUrl("../pages/AboutPage.qml"),
                                      { "version": painter.version,
                                        "year": "2015",
                                        "name": "Paint",
                                        "language": painter.getLanguage(),
                                        "imagelocation": "/usr/share/icons/hicolor/86x86/apps/harbour-paint.png"} )
            }
        }

        ToolbarButton
        {
            icon.source: "image://theme/icon-m-developer-mode"

            onClicked:
            {
                var saveModeWas = painter.getSetting("fileExtension", "png")

                var genSettingsDialog = pageStack.push(Qt.resolvedUrl("../pages/genSettings.qml"),
                                                       {"saveFormat": saveModeWas ,
                                                        "toolboxLocation": toolboxLocation,
                                                        "gridSpacing": gridSpacing,
                                                        "gridSnapTo": gridSnapTo,
                                                        "rememberToolSettings": rememberToolSettings,
                                                        "askSaveFilename": askSaveFilename,
                                                        "childsPlayMode": childsPlayMode})

                genSettingsDialog.accepted.connect(function()
                {
                    var newSaveMode = genSettingsDialog.saveFormat

                    if (saveModeWas !== newSaveMode)
                        showMessage(qsTr("File format") + " " + genSettingsDialog.saveFormat, 1500)
                    toolboxLocation = genSettingsDialog.toolboxLocation
                    gridSpacing = genSettingsDialog.gridSpacing
                    gridSnapTo = genSettingsDialog.gridSnapTo
                    rememberToolSettings = genSettingsDialog.rememberToolSettings
                    askSaveFilename = genSettingsDialog.askSaveFilename
                    childsPlayMode = genSettingsDialog.childsPlayMode
                    gridSettingsChanged()

                    painter.setSetting("fileExtension", genSettingsDialog.saveFormat)
                    painter.setSetting("toolboxLocation", genSettingsDialog.toolboxLocation)
                    painter.setSetting("gridSpacing", genSettingsDialog.gridSpacing)
                    painter.setSetting("gridSnapTo", genSettingsDialog.gridSnapTo ? "true" : "false")
                    painter.setSetting("rememberToolSettings", genSettingsDialog.rememberToolSettings ? "true" : "false")
                    painter.setSetting("askSaveFilename", genSettingsDialog.askSaveFilename ? "true" : "false")
                    painter.setSetting("childsPlayMode", genSettingsDialog.childsPlayMode ? "true" : "false")
                })
            }
        }

        ToolbarButton
        {
            icon.source: "image://theme/icon-m-delete"

            onClicked: startRemorse()
        }

        ToolbarButton
        {
            icon.source: "image://theme/icon-m-image"

            onClicked:
            {
                var bgSettingsDialog = pageStack.push(Qt.resolvedUrl("../pages/bgSettingsDialog.qml"), {
                                                           "currentColor": bgColor,
                                                           "useExternalImage": useImageAsBackground,
                                                           "bgImagePath": backgroundImagePath,
                                                           "bgImageRotate": backgroundImageRotate })
                bgSettingsDialog.accepted.connect(function() {
                    bgColor = bgSettingsDialog.currentColor
                    useImageAsBackground = bgSettingsDialog.useExternalImage
                    backgroundImagePath = bgSettingsDialog.bgImagePath
                    backgroundImageRotate = bgSettingsDialog.bgImageRotate
                    if (rememberToolSettings)
                    {
                        painter.setToolSetting("bgColor", bgSettingsDialog.currentColor)
                    }
                })

            }
        }

        ToolbarButton
        {
            id: saveButton
            icon.source: "image://paintIcons/icon-m-save"

            property bool pageStackBusy : pageStack.busy
            property bool doSave : false
            property string saveFileName: ""

            Timer
            {
                id: letTheBusyIndShow
                interval: 200
                onTriggered: saveButton.save(saveButton.saveFileName)
            }

            onPageStackBusyChanged:
            {
                if (!pageStackBusy && doSave && askSaveFilename)
                {
                    doSave = false
                    save(saveFileName)
                }
            }

            onClicked:
            {
                cancelPendingFunctions()
                geometryPopupVisible = false
                dimensionPopupVisible = false

                dimensionCanvas.requestPaint()
                drawingCanvas.saveActive()

                if (cropPending && drawMode === Painter.Crop)
                {
                    cropPending = false
                    drawMode = prevDrawMode
                    previewCanvas.clear()
                    busyInd.running = true
                    letTheBusyIndShow.start()
                    return
                }

                cropPending = false
                cropArea = [ 0,0,0,0 ]

                var fileName = ""
                if (askSaveFilename)
                {
                    var askFilenameDialog = pageStack.push(Qt.resolvedUrl("../pages/askFilenameDialog.qml"), {
                                                           "saveFormat": painter.getSetting("fileExtension", "png")})

                    askFilenameDialog.accepted.connect(function()
                    {
                        saveFileName = askFilenameDialog.filename
                        if (askFilenameDialog.crop)
                        {
                            cropPending = true
                            showMessage(qsTr("Mark area and click save again"), 0)
                            prevDrawMode = drawMode
                            drawMode = Painter.Crop
                        }
                        else
                        {
                            doSave = true
                            busyInd.running = true
                       }
                    })
                }
                else
                {
                    busyInd.running = true
                    saveFileName = fileName
                    letTheBusyIndShow.start()
                }
            }

            function save(fileName)
            {
                var ctx = drawingCanvas.getContext('2d')
                Draw.clear(ctx)

                for (var i=(layers.count-1) ; i >= 0; i--)
                {
                    if (layers.get(i).show)
                        ctx.drawImage(layersRep.itemAt(i), 0, 0)
                }
                if (dimensionModel.count > 0)
                    ctx.drawImage(dimensionCanvas, 0, 0)

                drawingCanvas.justPaint()

                var dataUrl1 = drawingCanvas.toDataURL()
                var dataUrl2 = "" //dimensionModel.count === 0 ? "" : dimensionCanvas.toDataURL()
                painter.saveCanvas(dataUrl1,
                                   dataUrl2,
                                   useImageAsBackground ? backgroundImagePath : (bgColor < colors.length ? colors[bgColor] : "" ),
                                   backgroundImageRotate,
                                   rotationSensor.angle,
                                   fileName,
                                   cropArea)
            }
        }
    }
}
