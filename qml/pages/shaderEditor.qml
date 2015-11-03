import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    id: shaderEditor

    allowedOrientations: Orientation.All

    property bool changed: false
    property int index: 0

    /* Prevent accidental page-navigation when editing */
    backNavigation: !area.focus
    canNavigateForward: !area.focus

    Component.onCompleted: area.text = Shaders.get(index).fragmentShader
    Component.onDestruction: painter.setHighlightTarget(null)

    SilicaFlickable
    {
        id: flick
        anchors.fill: parent
        contentHeight: col.height

        VerticalScrollDecorator { flickable: flick }

        Column
        {
            id: col
            width: shaderEditor.width
            Label
            {
                id: dh
                text: Shaders.get(index).name + (changed ? "*" : "")
                width: parent.width - 2*Theme.horizontalPageMargin
                anchors.horizontalCenter: parent.horizontalCenter
                truncationMode: TruncationMode.Fade
                color: Theme.highlightColor
                height: Theme.itemSizeLarge
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                font.pixelSize: Theme.fontSizeLarge
                font.family: Theme.fontFamilyHeading
                font.bold: changed
            }

            TextArea
            {
                id: area
                width: shaderEditor.width
                height: Math.max(shaderEditor.height - dh.height, implicitHeight)

                wrapMode: Text.WrapAnywhere
                font.pixelSize: Theme.fontSizeTiny
                font.family: "Monospace"

                selectionMode: TextEdit.SelectCharacters
                readOnly: true
                background: null
                onTextChanged: if (!readOnly) changed = true
                onReadOnlyChanged: cursorPosition = 0

                Component.onCompleted: painter.setHighlightTarget(area._editor)
            }
        }

    }
}
