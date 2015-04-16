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
    property string language

    id: page

    ListModel
    {
        id: buttonhelp
    }

    Component.onCompleted:
    {
        console.log("Language " + language)
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
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-ellipse", "helptext": qsTr("Draw ellipse")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-ellipse-filled", "helptext": qsTr("Draw filled ellipse")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-fill", "helptext": qsTr("Fill mode toggle")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-texttool", "helptext": qsTr("Text tool (cancel text)")})
        buttonhelp.append( {"image": "image://theme/icon-m-enter-accept", "helptext": qsTr("Accept current text")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-dimensiontool", "helptext": qsTr("Dimensioning tool")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-grid", "helptext": qsTr("Grid")})
        buttonhelp.append( {"image": "image://theme/icon-m-about", "helptext": qsTr("About Paint")})
        buttonhelp.append( {"image": "image://theme/icon-m-developer-mode", "helptext": qsTr("Change settings")})
        buttonhelp.append( {"image": "image://theme/icon-m-delete", "helptext": qsTr("Clear drawing")})
        buttonhelp.append( {"image": "image://theme/icon-m-image", "helptext": qsTr("Change background")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-save", "helptext": qsTr("Save snapshot")})

        if (translationcredits.text == "translation credit placeholder")
        {
            translationcredits.textFormat = Text.RichText
            translationcredits.text = "Help translating<br>www.transifex.com/projects/p/paint"
        }
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
                text: "(C) " + year + " kimmoli"
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label
            {
                text: qsTr("Version: ") + version
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label
            {
                id: translationcredits
                width: parent.width - 2* Theme.paddingLarge
                text: qsTr("translation credit placeholder")
                color: Theme.primaryColor
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeMedium
                anchors.horizontalCenter: parent.horizontalCenter
                visible: language !== "en" && language !== "fi"
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
                    spacing: 25
                    x: 25
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



