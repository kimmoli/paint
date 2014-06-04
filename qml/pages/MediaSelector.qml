import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.paint.Filemodel 1.0
import harbour.paint.Thumbnailer 1.0

Dialog  /* Todo: Cleanup, this is just an image selector here */
{
    id: page
    objectName: "mediaSelector"

    canAccept: false

    function accept() {
        if (canAccept) {
            _dialogDone(DialogResult.Accepted)
        }
        else {
            negativeFeedback()
        }

        // Attempt to navigate even if it will fail, so that feedback can be generated
        pageStack.navigateForward()
    }

    property bool cantAcceptReally: pageStack._forwardFlickDifference > 0 && pageStack._preventForwardNavigation
    onCantAcceptReallyChanged: {
        if (cantAcceptReally)
            negativeFeedback()
    }

    function negativeFeedback() {
        //banner.notify(qsTr("You should select files to send!", "Media page cant accept feedback"))
        console.log("You should select files to send!", "Media page cant accept feedback")
    }

    property bool multiple: false
    property bool filesystem: false
    property bool datesort: false
    property bool canChangeType: true

    property variant selectedFiles: []

    property variant _imagesFilter: ["*.jpg", "*.jpeg", "*.gif", "*.png", "*.bmp"]
    property string _mode: "image"
    property int _marqueeIndex: -1

    onStatusChanged: {
        if (status == DialogStatus.Opened) {
            initialize()
        }
    }

    function initialize(sorting)
    {
        filemodel.filter = _imagesFilter

        filemodel.sorting = sorting || datesort

        filemodel.showRecursive([_mode, "sdcard"])
    }

    function fileSelect(selection)
    {
        var value = page.selectedFiles
        var exists = value.indexOf(selection)
        if (exists != -1)
        {
            value.splice(exists, 1)
        }
        else if (page.selectedFiles.length < 20)
        {
            value.splice(0, 0, selection)
        }
        page.selectedFiles = value

        page.canAccept = page.selectedFiles.length > 0
    }

    function fileSingle(selection)
    {
        page.selectedFiles = [selection]

        page.canAccept = page.selectedFiles.length > 0
    }

    Filemodel
    {
        id: filemodel
    }

    DialogHeader
    {
        id: header
        title: page.selectedFiles.length > 0 ? qsTr("Image selected") : qsTr("Select image")
    }

    Loader
    {
        id: viewLoader
        anchors
        {
            fill: parent
            topMargin: header.height
        }
        sourceComponent: gridComponent
    }

    Component
    {
        id: gridComponent
        SilicaGridView
        {
            model: filemodel
            delegate: gridDelegate
            cellWidth: page.isPortrait ? page.width / 3 : page.width / 5
            cellHeight: cellWidth
            clip: true

            VerticalScrollDecorator {}
        }
    }

    Component
    {
        id: gridDelegate
        Item
        {
            id: item
            width: GridView.view.cellWidth - 1
            height: GridView.view.cellHeight - 1
            property bool highlighted: mArea.pressed || page.selectedFiles.indexOf(model.path) != -1
            property int marqueeOffset: 0

            Thumbnail
            {
                id: image
                source: model.path
                height: parent.height
                width: parent.width
                sourceSize.height: parent.height
                sourceSize.width: parent.width
                anchors.centerIn: parent
                clip: true
                smooth: true
                mimeType: model.mime

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
            Rectangle
            {
                anchors.fill: parent
                color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
                visible: item.highlighted
            }
            Rectangle
            {
                id: rec
                color: Theme.secondaryHighlightColor
                height: Theme.fontSizeExtraSmall
                anchors
                {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                Item
                {
                    anchors.fill: parent
                    anchors.margins: 2

                    clip: true
                    Label
                    {
                        id: label
                        anchors.verticalCenter: parent.verticalCenter
                        x: width > parent.width ? ( page._marqueeIndex == index ? marqueeOffset : 0) : (parent.width - width) / 2
                        font.pixelSize: Theme.fontSizeExtraSmall
                        text: model.base
                        wrapMode: Text.NoWrap
                        truncationMode: TruncationMode.Fade

                        color: Theme.primaryColor
                    }

                    Timer
                    {
                        id: marqueeTimer
                        interval: 10
                        running: false
                        repeat: true
                        onTriggered:
                        {
                            if (label.width > label.parent.width)
                            {
                                if (label.width + marqueeOffset > label.parent.width)
                                {
                                    marqueeOffset -= 1
                                }
                                else
                                {
                                    marqueeTimer.stop()
                                }
                            }
                            else
                            {
                                marqueeTimer.stop()
                            }
                        }
                    }
                }
            }

            MouseArea
            {
                id: mArea
                anchors.fill: parent
                onClicked:
                {
                    page._marqueeIndex = index
                    marqueeOffset = 0
                    marqueeTimer.start()
                    if (page.selectedFiles.length > 1)
                    {
                        fileSelect(model.path)
                    }
                    else
                    {
                        fileSingle(model.path)
                    }
                }
                onPressAndHold:
                {
                    if (multiple)
                        fileSelect(model.path)
                    else
                        fileSingle(model.path)
                }
            }
        }
    }
}
