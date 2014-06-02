/*
    Generic about page (C) 2014 Kimmo Lindholm
*/

import QtQuick 2.0
import Sailfish.Silica 1.0


Page
{
    property string name
    property string year
    property string version
    property string imagelocation

    id: page

    ListModel
    {
        id: buttonhelp
    }

    Component.onCompleted:
    {
        buttonhelp.append( {"image": "image://theme/icon-m-repeat", "helptext": qsTr("Change toolbar")})
        buttonhelp.append( {"image": "image://theme/icon-m-edit", "helptext": qsTr("Draw freehand line")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-eraser", "helptext": qsTr("Eraser")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-spray", "helptext": qsTr("Sprayer")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geometrics", "helptext": qsTr("Draw geometric shape")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-toolsettings", "helptext": qsTr("Change color, width")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-line", "helptext": qsTr("Draw line")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-rectangle", "helptext": qsTr("Draw rectangle")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-rectangle-filled", "helptext": qsTr("Draw filled rectangle")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-circle", "helptext": qsTr("Draw circle")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-circle-filled", "helptext": qsTr("Draw filled circle")})
        buttonhelp.append( {"image": "image://theme/icon-m-about", "helptext": qsTr("About Paint")})
        buttonhelp.append( {"image": "image://theme/icon-m-developer-mode", "helptext": qsTr("Change settings")})
        buttonhelp.append( {"image": "image://theme/icon-m-delete", "helptext": qsTr("Clear drawing")})
        buttonhelp.append( {"image": "image://theme/icon-m-image", "helptext": qsTr("Change bacground")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-save", "helptext": qsTr("Save snapshot")})
    }

    SilicaFlickable
    {
        anchors.fill: parent

        contentHeight: column.height

        Column
        {
            id: column

            width: page.width
            spacing: Theme.paddingSmall
            PageHeader
            {
                title: qsTr("About ") + name
            }
            Label
            {
                x: Theme.paddingLarge
                text: name
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle
            {
                visible: imagelocation.length > 0
                anchors.horizontalCenter: parent.horizontalCenter
                height: 120
                width: 120
                color: "transparent"

                Image
                {
                    visible: imagelocation.length > 0
                    source: imagelocation
                    anchors.centerIn: parent
                }
            }

            Label
            {
                x: Theme.paddingLarge
                text: "(C) " + year + " kimmoli"
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label
            {
                x: Theme.paddingLarge
                text: qsTr("Version: ") + version
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label
            {
                x: Theme.paddingLarge
                text: qsTr("Swedish translation by eson57")
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                anchors.horizontalCenter: parent.horizontalCenter
            }
            SectionHeader
            {
                text: qsTr("Help")
            }

            Repeater
            {
                model: buttonhelp
                Row
                {
                    spacing: 50
                    x: 40
                    Image
                    {
                        id: bim
                        source: image
                    }
                    Label
                    {
                        text: helptext
                        anchors.verticalCenter: bim.verticalCenter
                    }

                }
            }
        }
    }
}



