import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    id: layersPage

    allowedOrientations: Orientation.All

    signal addNewLayer()
    signal changeLayer(int toLayer)
    signal moveLayer(int from, int to)
    signal removeLayer(int index)

    Column
    {
        id: headerCol
        width: parent.width
        spacing: Theme.paddingSmall

        PageHeader
        {
            title: qsTr("Layers")
        }

        Button
        {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Add new layer")
            onClicked: addNewLayer()
        }

        SectionHeader
        {
            text: qsTr("Current layers")
        }

        Label
        {
            text: qsTr("Active layer is always shown on top when editing. Layers are saved in order shown here. Only visible layers are saved.")
            wrapMode: Text.Wrap
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.secondaryColor
            width: parent.width - 4*Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item
        {
            width: 1
            height: Theme.paddingLarge
        }
    }

    SilicaListView
    {
        id: flick

        anchors.fill: parent

        header: Item
        {
            id: headerItem
            width: headerCol.width
            height: headerCol.height

            Component.onCompleted: headerCol.parent = headerItem
        }

        VerticalScrollDecorator { flickable: flick }

        model: layers

        delegate: BackgroundItem
        {
            id: layerDelegate

            width: parent.width
            height: Theme.itemSizeLarge

            RemorseItem
            {
                id: remorse
            }

            function showRemorse(idx)
            {
                remorse.execute(layerDelegate, qsTr("Deleting"), function() { removeLayer(idx) })
            }

            Row
            {
                spacing: Theme.paddingMedium
                anchors.fill: parent
                x: Theme.paddingLarge

                TextField
                {
                    text: name
                    focus: false
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width/2
                    color: activeLayer == index ? Theme.highlightColor : Theme.primaryColor
                    onFocusChanged: if (!focus) layers.setProperty(index, "name", text)
                    EnterKey.enabled: text.length > 0
                    EnterKey.iconSource: "image://theme/icon-m-enter"
                    EnterKey.onClicked: focus = false
                }
                IconButton
                {
                    icon.source: activeLayer == index ? "image://theme/icon-m-favorite-selected" : "image://theme/icon-m-favorite"
                    onClicked: if (activeLayer != index) changeLayer(index)
                }
                IconButton
                {
                    icon.source: "image://paintIcons/icon-m-visible" + ((show || (activeLayer == index)) ? "" : "-not")
                    onClicked: if (activeLayer != index) layers.setProperty(index, "show", !show)
                }
                IconButton
                {
                    icon.source: "image://theme/icon-m-up"
                    enabled: index > 0
                    onClicked:
                    {
                        moveLayer(index, index-1, 1)
                    }
                }
                IconButton
                {
                    icon.source: "image://theme/icon-m-down"
                    enabled: index < layers.count-1
                    onClicked:
                    {
                        moveLayer(index, index+1, 1)
                    }
                }
                IconButton
                {
                    icon.source: "image://theme/icon-m-delete"
                    enabled: (layers.count > 1) && (activeLayer != index)
                    onClicked: showRemorse(index)
                }
            }
        }
    }
}
