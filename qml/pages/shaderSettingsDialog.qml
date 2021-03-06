import QtQuick 2.0
import Sailfish.Silica 1.0

import "../code/drawinghelpers.js" as Draw

Page
{
    id: shadersPage

    allowedOrientations: Orientation.All

    Column
    {
        id: headerCol
        width: parent.width
        spacing: Theme.paddingSmall
        clip: true

        PageHeader
        {
            title: qsTr("Shaders")
        }

        Label
        {
            text: qsTr("Shaders have fragment shader and optional vertex shader. blaa.")
            wrapMode: Text.Wrap
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.secondaryColor
            width: parent.width - 4*Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
        }

        /* Sample image author: Axel Jacobs (Photographer)
         * Under Creative Commons Attribution-Share Alike 2.0 Generic license
         * https://commons.wikimedia.org/wiki/File:HDRI_Sample_Scene_Balls_%28JPEG-HDR%29.jpg
         */
        Item
        {
            width: parent.width
            height: previewImage.height + 2*Theme.paddingLarge
            Label
            {
                text: Shaders.get(activeShader).name
                anchors.horizontalCenter: previewImage.horizontalCenter
                anchors.bottom: previewImage.top
                anchors.bottomMargin: Theme.paddingSmall
            }

            Image
            {
                source: "../icons/sample-image.png"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
            }

            Item
            {
                id: previewImage
                width: 480
                height: 360
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom

                ShaderEffect
                {
                    id: previewShader
                    anchors.fill: parent

                    property var source: Image { source: "../icons/sample-image.png" }
                    property var mask: Image { source: "../icons/sample-mask.png" }

                    property var imageSource: Image { source: Shaders.get(activeShader).imageSource }
                    property var imageSourceWidth: imageSource.width
                    property var imageSourceHeight: imageSource.height

                    property var param1: Shaders.get(activeShader).parameters.count > 0 ? Shaders.get(activeShader).parameters.get(0).now : 0.5
                    property var param2: Shaders.get(activeShader).parameters.count > 1 ? Shaders.get(activeShader).parameters.get(1).now : 0.5
                    property var param3: Shaders.get(activeShader).parameters.count > 2 ? Shaders.get(activeShader).parameters.get(2).now : 0.5

                    fragmentShader: Shaders.get(activeShader).fragmentShader
                    vertexShader: Shaders.get(activeShader).vertexShader
                }
            }
        }
        Repeater
        {
            id: paramRepeater
            model: Shaders.get(activeShader).parameters

            Slider
            {
                id: paramSlider
                label: object.name
                valueText: value.toFixed(Draw.decimalPlaces(object.step))
                minimumValue: object.min
                maximumValue: object.max
                stepSize: object.step.toFixed(3)
                width: headerCol.width - 2*Theme.paddingLarge
                anchors.horizontalCenter: headerCol.horizontalCenter
                onValueChanged: object.now = value
                Component.onCompleted: value = object.now
            }
        }

        SectionHeader
        {
            text: qsTr("Shader log output")
            visible: previewShader.log.length > 0
        }
        Label
        {
            text: previewShader.log
            font.pixelSize: Theme.fontSizeSmall
            x: Theme.horizontalPageMargin
            width: parent.width - 2*Theme.horizontalPageMargin
            wrapMode: Text.WordWrap
        }
        SectionHeader
        {
            text: qsTr("Select a shader")
        }
    }

    SilicaListView
    {
        id: flick

        anchors.fill: parent

        Component.onCompleted: positionViewAtBeginning()

        header: Item {
            id: headerItem
            width: parent.width
            height: headerCol.height

            Component.onCompleted: headerCol.parent = headerItem
        }

        VerticalScrollDecorator { flickable: flick }

        model: Shaders

        delegate: BackgroundItem {
            id: shaderDelegate

            width: flick.width
            height: Theme.itemSizeMedium

            Label
            {
                id: namelabel
                text: name
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                color: activeShader == index ? Theme.highlightColor : Theme.primaryColor
            }
            Label
            {
                text:
                {
                    var msg

                    if (fragmentShader.length > 0)
                        msg = "fragmentShader"

                    if (vertexShader.length > 0)
                        msg += ", vertexShader"

                    if (parameters.count > 0)
                    {
                        msg += ", Parameters: "
                        for (var i = 0; i < parameters.count ; i++)
                            msg += ", " + parameters.get(i).name +
                                    " (" + parameters.get(i).now.toFixed(Draw.decimalPlaces(parameters.get(i).step)) + ")"
                    }

                    return msg
                }

                font.pixelSize: Theme.fontSizeExtraSmall
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.top: namelabel.bottom
                anchors.right: parent.right
                anchors.rightMargin: Theme.horizontalPageMargin
                truncationMode: TruncationMode.Fade
                color: activeShader == index ? Theme.highlightColor : Theme.primaryColor
            }

            onClicked:
            {
                activeShader = index
                scrolltimer.start()
            }

            onPressAndHold:
            {
                pageStack.push(Qt.resolvedUrl("shaderEditor.qml"), { index: index })
            }
        }
        Timer
        {
            id: scrolltimer
            interval: 250
            onTriggered: flick.scrollToTop()
        }
    }
}

