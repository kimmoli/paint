import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

Row
{
    id: toolbar1

    IconButton
    {
        icon.source: "image://theme/icon-m-edit"
        anchors.bottom: parent.bottom
        highlighted: drawMode === Painter.Pen

        onClicked:
        {
            hideGeometryPopup()
            drawMode = Painter.Pen
        }
    }

    IconButton
    {
        icon.source: "image://paintIcons/icon-m-eraser"
        anchors.bottom: parent.bottom
        highlighted: drawMode === Painter.Eraser

        onClicked:
        {
            hideGeometryPopup()
            drawMode = Painter.Eraser
        }
    }

    IconButton
    {
        icon.source: "image://paintIcons/icon-m-spray"
        anchors.bottom: parent.bottom
        highlighted: drawMode === Painter.Spray

        onClicked:
        {
            hideGeometryPopup()
            drawMode = Painter.Spray
        }
    }

    IconButton
    {
        icon.source: "image://paintIcons/icon-m-geometrics"
        anchors.bottom: parent.bottom
        highlighted: drawMode === Painter.Geometrics

        onClicked:
        {
            if (drawMode != Painter.Geometrics)
                showGeometryPopup()
            else
                toggleGeometryPopup()
            drawMode = Painter.Geometrics
        }
    }


    IconButton
    {
        icon.source: "image://paintIcons/icon-m-toolsettings"
        anchors.bottom: parent.bottom

        onClicked:
        {
            var SettingsDialog

            switch (drawMode)
            {
                case Painter.Eraser :
                    SettingsDialog = pageStack.push(Qt.resolvedUrl("../pages/eraserSettingsDialog.qml"),
                                                           { "currentThickness": eraserThickness })

                    SettingsDialog.accepted.connect(function() {
                        eraserThickness = SettingsDialog.currentThickness
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
                    })

                    break;

                default :
                    break;
            }
        }
    }


}
