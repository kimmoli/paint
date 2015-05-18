import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Item
{
    id: toolbar3

    Row
    {
        property int n: children.length-1

        spacing: (parent.width - n*64-(parent.width - n*64)/2)/(n+1)

        Item
        {
            height: 1
            width: 1.5 * parent.spacing
        }

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
                                                        "rememberToolSettings": rememberToolSettings})

                genSettingsDialog.accepted.connect(function()
                {
                    var newSaveMode = genSettingsDialog.saveFormat

                    if (saveModeWas !== newSaveMode)
                        showMessage(qsTr("File format") + " " + genSettingsDialog.saveFormat, 1500)
                    toolboxLocation = genSettingsDialog.toolboxLocation
                    gridSpacing = genSettingsDialog.gridSpacing
                    gridSnapTo = genSettingsDialog.gridSnapTo
                    rememberToolSettings = genSettingsDialog.rememberToolSettings
                    gridSettingsChanged()

                    painter.setSetting("fileExtension", genSettingsDialog.saveFormat)
                    painter.setSetting("toolboxLocation", genSettingsDialog.toolboxLocation)
                    painter.setSetting("gridSpacing", genSettingsDialog.gridSpacing)
                    painter.setSetting("gridSnapTo", genSettingsDialog.gridSnapTo ? "true" : "false")
                    painter.setSetting("rememberToolSettings", genSettingsDialog.rememberToolSettings ? "true" : "false")
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
                var fileName = painter.saveCanvas(canvas.toDataURL(),
                                                  dimensionModel.count === 0 ? "" : dimensionCanvas.toDataURL(),
                                                  useImageAsBackground ? backgroundImagePath : "",
                                                  backgroundImageRotate,
                                                  rotationSensor.angle)
                if (fileName === "")
                    fileName = qsTr("Save failed...")
                showMessage(fileName, 0)
            }
        }
    }
}
