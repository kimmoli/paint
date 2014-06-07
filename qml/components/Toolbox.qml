import QtQuick 2.0
import Sailfish.Silica 1.0

Row
{
    id: toolBox

    anchors.horizontalCenter: parent.horizontalCenter
    height: 80
    width: parent.width

    property var toolbar
    property var popup

    property int toolbarNumber : 1
    property int maxToolbars: 3

    signal showMessage(string message, int delay)
    signal showGeometryPopup()
    signal toggleGeometryPopup()
    signal hideGeometryPopup()
    signal showDimensionPopup()
    signal toggleDimensionPopup()
    signal hideDimensionPopup()

    signal textEditAccept()
    signal textEditCancel()
    signal textSettingsChanged()


    function startRemorse()
    {
        remorse.execute(qsTr("Clearing"), function()
        {
            canvas.clear()

            /* Clear also all dimensions created */
            dimensionModel.clear()
            dimensionCanvas.clear()
        })
    }

    function changeToolBar(number)
    {
        if (toolbar)
            toolbar.destroy()

        var toolbarComp = Qt.createComponent(Qt.resolvedUrl("../components/Toolbar" + number + ".qml"))
        toolbar = toolbarComp.createObject(toolBox)
    }

    Behavior on opacity
    {
        FadeAnimation {}
    }

    Component.onCompleted: changeToolBar(toolbarNumber)

    RemorsePopup
    {
        id: remorse
        z: 21
        opacity: 1.0
        anchors.verticalCenter: parent.verticalCenter
    }

    IconButton
    {
        icon.source: "image://theme/icon-m-repeat"
        icon.scale: 0.6
        anchors.verticalCenter: parent.verticalCenter

        onClicked:
        {
            hideGeometryPopup()
            hideDimensionPopup()

            toolbarNumber = (toolbarNumber >= maxToolbars) ? 1 : (++toolbarNumber)
            changeToolBar(toolbarNumber)
        }
    }
    Rectangle
    {
        height: 1
        width: 16
        color: "transparent"
    }
}
