import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Item
{
    id: toolbar3

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
                                                        "askSaveFilename": askSaveFilename})

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
                    gridSettingsChanged()

                    painter.setSetting("fileExtension", genSettingsDialog.saveFormat)
                    painter.setSetting("toolboxLocation", genSettingsDialog.toolboxLocation)
                    painter.setSetting("gridSpacing", genSettingsDialog.gridSpacing)
                    painter.setSetting("gridSnapTo", genSettingsDialog.gridSnapTo ? "true" : "false")
                    painter.setSetting("rememberToolSettings", genSettingsDialog.rememberToolSettings ? "true" : "false")
                    painter.setSetting("askSaveFilename", genSettingsDialog.askSaveFilename ? "true" : "false")
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
            icon.source: "image://paintIcons/icon-m-save"

            onClicked:
            {
                var fileName = ""
                if (askSaveFilename)
                {
                    var askFilenameDialog = pageStack.push(Qt.resolvedUrl("../pages/askFilenameDialog.qml"), {
                                                           "saveFormat": painter.getSetting("fileExtension", "png")})

                    askFilenameDialog.accepted.connect(function()
                    {
                        save(askFilenameDialog.filename)
                    })
                }
                else
                {
                    save(fileName)
                }
            }

            function save(fileName)
            {
                fileName = painter.saveCanvas(drawingCanvas.toDataURL(),
                                                  dimensionModel.count === 0 ? "" : dimensionCanvas.toDataURL(),
                                                  useImageAsBackground ? backgroundImagePath : (bgColor < colors.length ? colors[bgColor] : "" ),
                                                  backgroundImageRotate,
                                                  rotationSensor.angle,
                                                  fileName)
                if (fileName === "")
                    fileName = qsTr("Save failed...")
                showMessage(fileName, 0)
            }
        }
    }
}
