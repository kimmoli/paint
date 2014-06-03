import QtQuick 2.1
import Sailfish.Silica 1.0
import org.nemomobile.thumbnailer 1.0
import harbour.paint.Filemodel 1.0

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
    property variant _audiosFilter: ["*.mp3", "*.aac", "*.m4a", "*.wav", "*.ogg"]
    property variant _videosFilter: ["*.avi", "*.mov", "*.mkv", "*.mp4"]
    property string _mode: "image"
    property int _marqueeIndex: -1

    onStatusChanged: {
        if (status == DialogStatus.Opened) {
            initialize()
        }
    }

    function initialize(sorting) {
        if (_mode === "image") {
            filemodel.filter = _imagesFilter
        }
        else if (_mode === "video") {
            filemodel.filter = _videosFilter
        }
        else if (_mode === "music") {
            filemodel.filter = _audiosFilter
        }

        filemodel.sorting = sorting || datesort

        filemodel.showRecursive([_mode, "sdcard"])
    }

    function fileSelect(selection) {
        var value = page.selectedFiles
        var exists = value.indexOf(selection)
        if (exists != -1) {
            value.splice(exists, 1)
        }
        else if (page.selectedFiles.length < 20) {
            value.splice(0, 0, selection)
        }
        page.selectedFiles = value

        page.canAccept = page.selectedFiles.length > 0
    }

    function fileSingle(selection) {
        page.selectedFiles = [selection]

        page.canAccept = page.selectedFiles.length > 0
    }

    Filemodel {
        id: filemodel
    }

    DialogHeader {
        id: header
        title: page.selectedFiles.length > 0 ? (_mode === "image" ? (multiple ? qsTr("Images selected: %n", "Media selection page title text", page.selectedFiles.length) : qsTr("Image selected", "Media selection page title text"))
                                                                  : (_mode === "music") ? (multiple ? qsTr("Audio selected: %n", "Media selection page title text", page.selectedFiles.length) : qsTr("Audio selected", "Media selection page title text"))
                                                                                        : (multiple ? qsTr("Video selected: %n", "Media selection page title text", page.selectedFiles.length) : qsTr("Video selected", "Media selection page title text")))
                        : (_mode === "image" ? qsTr("Images", "Media selection page title text")
                                             : (_mode === "music") ? qsTr("Audio", "Media selection page title text")
                                                                   : qsTr("Video", "Media selection page title text"))
    }

    Loader {
        id: viewLoader
        anchors {
            fill: parent
            topMargin: header.height
        }
        sourceComponent: _mode === "music" ? listComponent : gridComponent
    }

    Component {
        id: listComponent
        SilicaListView {
            model: filemodel
            delegate: listDelegate
            clip: true

            VerticalScrollDecorator {}
        }
    }

    Component {
        id: gridComponent
        SilicaGridView {
            model: filemodel
            delegate: gridDelegate
            cellWidth: page.isPortrait ? page.width / 3 : page.width / 5
            cellHeight: cellWidth
            clip: true

            VerticalScrollDecorator {}
        }
    }

    Component {
        id: listDelegate
        BackgroundItem {
            id: item
            width: parent.width
            height: Theme.itemSizeSmall
            highlighted: down || page.selectedFiles.indexOf(model.path) != -1
            property int marqueeOffset: 0

            Component.onDestruction: {
                if (page._marqueeIndex == index) {
                    page._marqueeIndex = -1
                    marqueeTimer.stop()
                }
            }

            Image {
                id: icon
                source: "image://theme/icon-m-" + (model.dir ? "folder" : "music")
                cache: true
                asynchronous: false
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingSmall
            }

            Item {
                height: file.height
                anchors {
                    left: icon.right
                    right: parent.right
                    margins: Theme.paddingLarge
                    verticalCenter: parent.verticalCenter
                }
                clip: true

                Label {
                    id: file
                    text: model.name
                    x: page._marqueeIndex == index ? marqueeOffset : 0
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: Theme.fontSizeSmall
                    color: item.highlighted ? Theme.highlightColor : Theme.primaryColor
                }

                Timer {
                    id: marqueeTimer
                    interval: 10
                    running: false
                    repeat: true
                    onTriggered: {
                        if (file.width > file.parent.width) {
                            if (file.width + marqueeOffset > file.parent.width) {
                                marqueeOffset -= 1
                            }
                            else {
                                marqueeTimer.stop()
                            }
                        }
                        else {
                            marqueeTimer.stop()
                        }
                    }
                }
            }

            onClicked: {
                page._marqueeIndex = index
                marqueeOffset = 0
                marqueeTimer.start()
                if (model.dir) {
                    //TODO: implement folder switching
                    //filesModel.path = model.path
                }
                else {
                    if (page.selectedFiles.length > 1) {
                        fileSelect(model.path)
                    }
                    else {
                        fileSingle(model.path)
                    }
                }
            }
            onPressAndHold: {
                if (multiple)
                    fileSelect(model.path)
                else
                    fileSingle(model.path)
            }
        }
    }

    Component {
        id: gridDelegate
        Item {
            id: item
            width: GridView.view.cellWidth - 1
            height: GridView.view.cellHeight - 1
            property bool highlighted: mArea.pressed || page.selectedFiles.indexOf(model.path) != -1
            property int marqueeOffset: 0

            Thumbnail {
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

                states: [
                    State {
                        name: 'loaded'; when: image.status == Thumbnail.Ready
                        PropertyChanges { target: image; opacity: 1; }
                    },
                    State {
                        name: 'loading'; when: image.status != Thumbnail.Ready
                        PropertyChanges { target: image; opacity: 0; }
                    }
                ]

                Behavior on opacity {
                    FadeAnimation {}
                }
            }
            Rectangle {
                anchors.fill: parent
                color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
                visible: item.highlighted
            }
            Rectangle {
                id: rec
                color: Theme.secondaryHighlightColor
                height: Theme.fontSizeExtraSmall
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                Item {
                    anchors {
                        fill: parent
                        margins: 2
                    }
                    clip: true
                    Label {
                        id: label
                        anchors.verticalCenter: parent.verticalCenter
                        x: width > parent.width ? ( page._marqueeIndex == index ? marqueeOffset : 0) : (parent.width - width) / 2
                        font.pixelSize: Theme.fontSizeExtraSmall
                        text: model.base
                        wrapMode: Text.NoWrap
                        truncationMode: TruncationMode.Fade

                        color: Theme.primaryColor
                    }

                    Timer {
                        id: marqueeTimer
                        interval: 10
                        running: false
                        repeat: true
                        onTriggered: {
                            if (label.width > label.parent.width) {
                                if (label.width + marqueeOffset > label.parent.width) {
                                    marqueeOffset -= 1
                                }
                                else {
                                    marqueeTimer.stop()
                                }
                            }
                            else {
                                marqueeTimer.stop()
                            }
                        }
                    }
                }
            }

            MouseArea {
                id: mArea
                anchors.fill: parent
                onClicked: {
                    page._marqueeIndex = index
                    marqueeOffset = 0
                    marqueeTimer.start()
                    if (page.selectedFiles.length > 1) {
                        fileSelect(model.path)
                    }
                    else {
                        fileSingle(model.path)
                    }
                }
                onPressAndHold: {
                    if (multiple)
                        fileSelect(model.path)
                    else
                        fileSingle(model.path)
                }
            }
        }
    }
}
