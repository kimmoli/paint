import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    id: shadersPage

    allowedOrientations: Orientation.All

    Column
    {
        id: headerCol
        width: parent.width
        spacing: Theme.paddingSmall

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
                text: qsTr("Original")
                anchors.right: previewImage.horizontalCenter
                anchors.rightMargin: Theme.paddingMedium
                anchors.bottom: previewImage.top
                anchors.bottomMargin: Theme.paddingSmall
            }
            Label
            {
                text: qsTr("Processed")
                anchors.left: previewImage.horizontalCenter
                anchors.leftMargin: Theme.paddingMedium
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
                    property var source: Image
                    {
                        source: "../icons/sample-image.png"
                    }
                    property var mask: Image
                    {
                        source: "../icons/sample-mask.png"
                    }
                    property var param1: shaderParam1
                    property var param2: shaderParam2
                    property var param3: shaderParam3
                    anchors.fill: parent
                    fragmentShader: Shaders.getFragmentShader(activeShader)
                    vertexShader: Shaders.getVertexShader(activeShader)
                }
            }
        }
        Repeater
        {
            enabled: Shaders.getParameters(activeShader).length > 0
            model: Shaders.getParameters(activeShader).length/4

            Slider
            {
                id: paramSlider
                label: Shaders.getParameters(activeShader)[index+0]
                value: Shaders.getParameters(activeShader)[index+3]
                valueText: value.toFixed(2)
                minimumValue: Shaders.getParameters(activeShader)[index+1]
                maximumValue: Shaders.getParameters(activeShader)[index+2]
                stepSize: 0.01
                width: parent.width - 2*Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                onValueChanged: shaderParam1 = value
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

        header: Item
        {
            id: headerItem
            width: parent.width
            height: headerCol.height

            Component.onCompleted: headerCol.parent = headerItem
        }

        VerticalScrollDecorator { flickable: flick }

        model: Shaders

        delegate: BackgroundItem
        {
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
                    else
                        msg = "ERROR! No fragment shader!"

                    if (vertexShader.length > 0)
                        msg += ", vertexShader"

                    if (parameters.length > 0)
                        msg += ", adjustable: " + parameters[0]

                    for (var i = 4; i < parameters.length ; i=i+4)
                        msg += ", " + parameters[i]

                    return msg
                }

                font.pixelSize: Theme.fontSizeExtraSmall
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.top: namelabel.bottom
                color: activeShader == index ? Theme.highlightColor : Theme.primaryColor
            }

            onClicked: activeShader = index
        }
    }
}

