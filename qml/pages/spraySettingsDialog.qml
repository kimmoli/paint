import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog
{
    id: eraserSettingsDialog
    canAccept: true

    property int currentRadius: 0
    property int currentParticleSize: 0
    property int currentDensity: 0
    property int currentColor: 0

    property var showpage
    property var showpageComp

    property bool updateParameters: false

    onDone:
    {
        if (updateParameters && (result === DialogResult.Accepted))
        {
            currentRadius = radiusSlider.value
            currentParticleSize = particleSizeSlider.value
            currentDensity = densitySlider.value
        }
    }

    function changepage(name)
    {
        if (showpage)
            showpage.destroy()

        showpageComp = Qt.createComponent(Qt.resolvedUrl("../components/" + name + ".qml"))
        if (showpageComp.status === Component.Ready)
            finishCreation(showpageComp);
        else
            showpageComp.statusChanged.connect(finishCreation);
    }

    function finishCreation()
    {
        showpage = showpageComp.createObject(eraserSettingsDialog)
    }


    DialogHeader
    {
        id: pageHeader
        title:  qsTr("Sprayer settings")
        acceptText: acceptText
        cancelText: cancelText
    }

    Column
    {
        id: col
        width: parent.width - Theme.paddingLarge
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: pageHeader.bottom

        Row
        {
            Button
            {
                text: "colors"
                onClicked: changepage("sprayerColor.qml")

            }
            Button
            {
                text: "props"
                onClicked:
                {
                    updateParameters = true
                    changepage("sprayerParameters.qml")
                }
            }
        }
    }
}



