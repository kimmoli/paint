import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.Thumbnailer 1.0

Dialog
{
    id: bgSettingsDialog
    canAccept: true

    property int currentBg: 0
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

            Grid
            {
                id: colorSelector
                columns: 4
                Repeater
                {
                    model: colors
                    Rectangle
                    {
                        width: col.width/colorSelector.columns
                        height: col.width/colorSelector.columns
                        radius: 10
                        color: (index == currentBg) ? colors[index] : "transparent"
                        Rectangle
                        {
                            width: parent.width - 20
                            height: parent.height - 20
                            radius: 5
                            color: colors[index]
                            anchors.centerIn: parent
                        }
                        BackgroundItem
                        {
                            anchors.fill: parent
                            onClicked:
                            {
                                useExternalImage = false
                                currentBg = index
                            }
                        }
                    }
                }
            }

            TextSwitch
            {
                id: ts
                text: qsTr("None")
                checked: (currentBg === colors.length) && !useExternalImage
                automaticCheck: false
                onDownChanged:
                {
                    if (down)
                    {
                        useExternalImage = false
                        currentBg = colors.length
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
                    checked: (currentBg === colors.length) && useExternalImage
                    automaticCheck: false
                    onDownChanged:
                    {
                        if (down)
                        {
                            useExternalImage = true
                            currentBg = colors.length
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
                    width: 2* Theme.itemSizeLarge
                    height: 2* Theme.itemSizeLarge
                    color: "transparent"

                    Rectangle
                    {
                        width: (540/960) * 2* Theme.itemSizeLarge
                        height: 2* Theme.itemSizeLarge
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

