import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog
{
    id: bgSettingsDialog
    canAccept: true

    property int currentBg: 0
    property bool useExternalImage: false

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
                        thumbnailImage.source = mediaFiles[0];
                    })
                }
            }
        }

        Image
        {
            id: thumbnailImage
            visible: useExternalImage
            source: "image://theme/icon-l-dismiss"
            height: 2* Theme.itemSizeLarge
            width: 2* Theme.itemSizeLarge
            sourceSize.height: 2* Theme.itemSizeLarge
            sourceSize.width: 2* Theme.itemSizeLarge

            clip: true
            fillMode: Image.PreserveAspectCrop
            smooth: false
            asynchronous: true
            cache: true
        }
    }
}

