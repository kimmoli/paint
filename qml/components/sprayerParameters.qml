import QtQuick 2.0
import Sailfish.Silica 1.0

Column
{
    id: sprayerParameters

    SectionHeader
    {
        text: qsTr("Sprayer parameters")
    }

    Rectangle
    {

        color: "transparent"
        height: 300
        width: parent.width
        Canvas
        {
            id: previewCanvas
            anchors.fill: parent
            renderTarget: Canvas.FramebufferObject
            antialiasing: true

            property bool clearNow : false
            property int midX : width / 2
            property int midY : height / 2

            onPaint:
            {
                var ctx = getContext('2d')

                ctx.clearRect(0, 0, width, height);

                for (var i = densitySlider.value; i--; )
                {
                    var angle = getRandomFloat(0, Math.PI*2)
                    var radius = getRandomFloat(1, radiusSlider.value)
                    var partsize = particleSizeSlider.value
                    ctx.fillStyle = "white"
                    ctx.fillRect(midX + radius * Math.cos(angle), midY + radius * Math.sin(angle), partsize, partsize)
                }
            }
        }
    }

    Slider
    {
        id: radiusSlider
        label: qsTr("Size")
        value: currentRadius
        valueText: value*2
        minimumValue: 3
        maximumValue: 100
        stepSize: 1
        width: parent.width - 2*Theme.paddingLarge
        anchors.horizontalCenter: parent.horizontalCenter
        onValueChanged: previewCanvas.requestPaint()
    }
    Slider
    {
        id: densitySlider
        label: qsTr("Density")
        value: currentDensity
        valueText: value
        minimumValue: 10
        maximumValue: 200
        stepSize: 5
        width: parent.width - 2*Theme.paddingLarge
        anchors.horizontalCenter: parent.horizontalCenter
        onValueChanged: previewCanvas.requestPaint()
    }

    Slider
    {
        id: particleSizeSlider
        label: qsTr("particles")
        value: currentParticleSize
        valueText: value
        minimumValue: 1
        maximumValue: 10
        stepSize: 1
        width: parent.width - 2*Theme.paddingLarge
        anchors.horizontalCenter: parent.horizontalCenter
        onValueChanged: previewCanvas.requestPaint()
    }
}
