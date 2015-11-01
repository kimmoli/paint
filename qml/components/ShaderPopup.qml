import QtQuick 2.0
import Sailfish.Silica 1.0

import "../code/drawinghelpers.js" as Draw

Column
{
    id: shaderPopup
    width: parent.width
    anchors.horizontalCenter: parent.horizontalCenter

    Repeater
    {
        id: paramRepeater
        model: Shaders.get(activeShader).parameters

        Slider
        {
            id: paramSlider
            label: object.name
            valueText: value.toFixed(Draw.decimalPlaces(object.step))
            minimumValue: object.min
            maximumValue: object.max
            stepSize: object.step.toFixed(3)
            width: shaderPopup.width - 2*Theme.paddingLarge
            anchors.horizontalCenter: shaderPopup.horizontalCenter
            onValueChanged: object.now = value
            Component.onCompleted: value = object.now

            Connections
            {
                target: object
                onNowChanged: paramSlider.value = object.now
            }
        }
    }
}
