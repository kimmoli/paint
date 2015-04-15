import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.Thumbnailer 1.0
import "../components"

Dialog
{
    id: bgSettingsDialog

    allowedOrientations: Orientation.All

    canAccept: true

    property int currentColor: 0
    property bool useExternalImage: false
    property string bgImagePath : ""
    property bool bgImageRotate : false


    SilicaFlickable
    {
        id: flick

        anchors.fill: parent
        contentHeight: dialogHeader.height + col.height
        width: parent.width

        VerticalScrollDecorator { flickable: flick }

        DialogHeader
        {
            id: dialogHeader
            acceptText: qsTr("Select background")
            Timer
            {
                interval: 2500
                running: true
                onTriggered: dialogHeader.acceptText = dialogHeader.defaultAcceptText
            }
        }

        Column
        {
            id: col
            width: parent.width - Theme.paddingLarge
            anchors.top: dialogHeader.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Theme.paddingSmall

            SectionHeader
            {
                text: qsTr("Select color")
            }

            ColorSelector
            {
                id: colSelector
                previewColor: currentColor === colors.length ? "#000000" : colors[currentColor]
                isPortrait: bgSettingsDialog.isPortrait
            }

            TextSwitch
            {
                id: ts
                text: qsTr("None")
                checked: (currentColor === colors.length) && !useExternalImage
                automaticCheck: false
                onDownChanged:
                {
                    if (down)
                    {
                        useExternalImage = false
                        currentColor = colors.length
                        colSelector.isColorWheel = false
                    }
                }
            }


            Row
            {
                width: parent.width
                spacing: width - tsEf.width - ibEf.width

                TextSwitch
                {
                    id: tsEf
                    text: qsTr("Image")
                    checked: (currentColor === colors.length) && useExternalImage
                    automaticCheck: false
                    onDownChanged:
                    {
                        if (down)
                        {
                            useExternalImage = true
                            currentColor = colors.length
                            colSelector.isColorWheel = false
                        }
                    }
                }

                IconButton
                {
                    id: ibEf
                    icon.source: "image://theme/icon-m-right"
                    visible: useExternalImage
                    enabled: useExternalImage
                    anchors.verticalCenter: tsEf.verticalCenter
                    onClicked:
                    {
                        var imageSelectDialog = pageStack.push(Qt.resolvedUrl("../pages/MediaSelector.qml"),
                                                               {"mode": "image",
                                                                "datesort": true,
                                                                "multiple": false})

                        imageSelectDialog.accepted.connect(function()
                        {
                            var mediaFiles = imageSelectDialog.selectedFiles
                            bgImagePath = mediaFiles[0]
                            bgImageRotate = false
                        })
                    }
                }
            }

            Row
            {
                visible: useExternalImage
                spacing: Theme.paddingLarge
                x: Theme.paddingLarge

                Rectangle
                {
                    id: previewPlaceHolder
                    width: 2 * Theme.itemSizeLarge
                    height: 2 * Theme.itemSizeLarge
                    color: "transparent"

                    Rectangle
                    {
                        width: 1.125 * Theme.itemSizeLarge
                        height: 2 * Theme.itemSizeLarge
                        color: "transparent"
                        anchors.centerIn: previewPlaceHolder

                        Thumbnail
                        {
                            id: image
                            source: bgImagePath
                            height: parent.height
                            width: parent.width
                            sourceSize.height: parent.height
                            sourceSize.width: parent.width
                            anchors.centerIn: parent
                            clip: true
                            smooth: true
                            mimeType: "image"
                            fillMode: bgImageRotate ? Thumbnail.RotateFit : Thumbnail.PreserveAspectFit

                            states:
                                [
                                State
                                {
                                    name: 'loaded'; when: image.status == Thumbnail.Ready
                                    PropertyChanges { target: image; opacity: 1; }
                                },
                                State
                                {
                                    name: 'loading'; when: image.status != Thumbnail.Ready
                                    PropertyChanges { target: image; opacity: 0; }
                                }
                            ]

                            Behavior on opacity
                            {
                                FadeAnimation {}
                            }
                        }
                    }
                }
                IconButton
                {
                    icon.source: "image://theme/icon-m-rotate"
                    icon.rotation: bgImageRotate ? 0 : 90
                    anchors.verticalCenter: previewPlaceHolder.verticalCenter
                    onClicked: bgImageRotate = !bgImageRotate
                }
            }
        }
    }
}

