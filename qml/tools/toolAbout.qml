import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../components"

ToolbarButton
{
    icon.source: "image://theme/icon-m-about"

    onClicked:
    {
        pageStack.push(Qt.resolvedUrl("../pages/AboutPage.qml"),
                              { "version": painter.version,
                                "year": "2014-2017",
                                "name": "Paint",
                                "language": painter.getLanguage(),
                                "imagelocation": "/usr/share/icons/hicolor/86x86/apps/harbour-paint.png"} )
    }
}
