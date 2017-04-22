import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0

import "../code/drawinghelpers.js" as Draw

Item
{
    id: toolbar5

    Row
    {
        spacing: (parent.width - children.length*Theme.iconSizeLarge )/(children.length+1)
        anchors.horizontalCenter: parent.horizontalCenter

        ToolbarButton
        {
            icon.source: "image://theme/icon-m-toy"
            mode: Painter.Shader

            onClicked:
            {
                cancelPendingFunctions()
                drawMode = mode
            }
        }

        ToolbarButton
        {
            icon.source: "image://theme/icon-m-enter-accept"
            enabled: shaderEditPending && drawMode == Painter.Shader

            onClicked:
            {
                if (shaderEditPending)
                    shaderEditAccept()
            }
        }

        ToolbarButton
        {
            icon.source: "image://theme/icon-m-display"
            enabled: drawMode == Painter.Shader
            highlighted: drawMode == Painter.Shader && shaderSelectAll

            onClicked:
            {
                shaderSelectAll = !shaderSelectAll
                var ctx = previewCanvas.getContext('2d')
                Draw.clear(ctx)
                shaderEditPending = shaderSelectAll
                if (shaderSelectAll)
                    Draw.drawRectangle(ctx, 0, 0, Screen.width, Screen.height, 0, "white", true)
                previewCanvas.justPaint()
            }
        }

        ToolbarButton
        {
            icon.source: "image://theme/icon-s-developer"
            enabled: Shaders.get(activeShader).parameters.count > 0 && drawMode == Painter.Shader

            onClicked:
            {
                shaderPopupVisible = !shaderPopupVisible
            }
        }

        ToolbarButton
        {
            icon.source: "image://theme/icon-m-developer-mode"
            enabled: drawMode == Painter.Shader

            onClicked:
            {
                pageStack.push(Qt.resolvedUrl("../pages/shaderSettingsDialog.qml"))
            }
        }


    }
}
