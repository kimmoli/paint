import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../components"

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
