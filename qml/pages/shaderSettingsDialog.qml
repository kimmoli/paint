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
                    anchors.fill: parent

                    property var source: Image
                    {
                        source: "../icons/sample-image.png"
                    }
                    property var mask: Image
                    {
                        source: "../icons/sample-mask.png"
                    }

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
                valueText: value.toFixed(2)
                minimumValue: object.min
                maximumValue: object.max
                stepSize: 0.01
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

                    if (vertexShader.length > 0)
                        msg += ", vertexShader"

                    if (parameters.count > 0)
                    {
                        msg += ", Parameters: "
                        for (var i = 0; i < parameters.count ; i++)
                            msg += ", " + parameters.get(i).name + " (" + parameters.get(i).now.toFixed(2) + ")"
                    }

                    return msg
                }

                font.pixelSize: Theme.fontSizeExtraSmall
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.top: namelabel.bottom
                color: activeShader == index ? Theme.highlightColor : Theme.primaryColor
            }

            onClicked:
            {
                activeShader = index
            }
        }
    }
}

