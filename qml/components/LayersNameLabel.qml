import QtQuick 2.0
import Sailfish.Silica 1.0

Item
{
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: Theme.paddingMedium
    anchors.bottomMargin: -Theme.paddingMedium
    height: layerNameLabelBg.height

    Label
    {
        id: layerNameLabel
        text: layers.get(activeLayer).name
        font.pixelSize: Theme.fontSizeMedium
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
        truncationMode: TruncationMode.Fade
        rotation: rotationSensor.angle == 180 ? 180 : 0
        width: Math.min(paintedWidth, Screen.width -layerNameIcon1.width -layerNameIcon2.width - 6 * Theme.paddingMedium )
        z: 1
    }
    Image
    {
        id: layerNameIcon1
        source: "image://theme/icon-m-levels"
        anchors.verticalCenter: layerNameLabel.verticalCenter
        anchors.right: layerNameLabel.left
        anchors.rightMargin: Theme.paddingMedium
        rotation: rotationSensor.angle
        Behavior on rotation { SmoothedAnimation { duration: 500 } }
        z: 1
    }
    Image
    {
        id: layerNameIcon2
        source: "image://paintIcons/icon-m-visible" + (layers.get(activeLayer).show ? "" : "-not")
        anchors.verticalCenter: layerNameLabel.verticalCenter
        anchors.left: layerNameLabel.right
        anchors.leftMargin: Theme.paddingMedium
        rotation: rotationSensor.angle
        Behavior on rotation { SmoothedAnimation { duration: 500 } }
        z: 1
    }
    Rectangle
    {
        id: layerNameLabelBg
        anchors.left: layerNameIcon1.left
        anchors.right: layerNameIcon2.right
        anchors.top: layerNameLabel.top
        anchors.bottom: layerNameLabel.bottom
        anchors.margins: -Theme.paddingMedium
        color: Theme.highlightDimmerColor
        opacity: Math.max(0.0, toolBox.opacity - 0.15)
        z: 0
    }
}
