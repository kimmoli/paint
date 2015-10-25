import QtQuick 2.0
import Sailfish.Silica 1.0

ShaderEffectSource
{
    id: root

    property var source
    property int size
    property int sourceX
    property int sourceY
    property bool enabled: true

    property var fragmentShader

    width: size
    height: size

    sourceItem: source
    sourceRect: Qt.rect(sourceX-size/2, sourceY-size/2, size, size)

    ShaderEffect
    {
        property var source: root

        anchors.fill: parent
        smooth: false
        fragmentShader: root.fragmentShader
    }
}
