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

    DialogHeader
    {
        id: pageHeader
        title: qsTr("Select background")
        acceptText: acceptText
        cancelText: cancelText
    }

    Column
    {
        id: col
        width: parent.width - Theme.paddingLarge
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: pageHeader.bottom

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
                        console.log("Selected file " + mediaFiles[0])
                        bgImagePath = mediaFiles[0];
                    })
                }
            }
        }

        Row
        {
            visible: useExternalImage
            spacing: Theme.itemSizeLarge

            Rectangle
            {
                id: previewPlaceHolder
                width: 2* Theme.itemSizeLarge
                height: 2* Theme.itemSizeLarge
                x: Theme.itemSizeLarge

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
                    fillMode: Thumbnail.PreserveAspectFit

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
            IconButton
            {
                icon.source: "image://theme/icon-m-rotate"
                anchors.verticalCenter: previewPlaceHolder.verticalCenter
                onClicked:
                {
                    if (image.fillMode === Thumbnail.PreserveAspectFit)
                        image.fillMode = Thumbnail.RotateFit
                    else
                        image.fillMode = Thumbnail.PreserveAspectFit

                }

            }
        }
    }
}

