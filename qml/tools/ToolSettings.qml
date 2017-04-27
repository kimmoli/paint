import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../components"

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
