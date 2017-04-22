/*
    Generic about page (C) 2014 Kimmo Lindholm
*/

import QtQuick 2.0
import Sailfish.Silica 1.0


Page
{
    id: page

    allowedOrientations: Orientation.All

    property string name
    property string year
    property string version
    property string imagelocation
    property string language

    ListModel
    {
        id: buttonhelp
    }

    Component.onCompleted:
    {
        buttonhelp.append( {"image": "",                                                 "helptext": qsTr("Drawing toolbar")})
        buttonhelp.append( {"image": "image://theme/icon-m-edit",                        "helptext": qsTr("Draw freehand line")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-eraser",                 "helptext": qsTr("Eraser")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-spray",                  "helptext": qsTr("Sprayer")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geometrics",             "helptext": qsTr("Draw geometric shape")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-toolsettings",           "helptext": qsTr("Change color, width")})
        buttonhelp.append( {"image": "",                                                 "helptext": qsTr("Geometrics")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-line",              "helptext": qsTr("Draw line")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-rectangle",         "helptext": qsTr("Draw rectangle")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-rectangle-filled",  "helptext": qsTr("Draw filled rectangle")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-square",            "helptext": qsTr("Draw square")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-square-filled",     "helptext": qsTr("Draw filled square")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-circle",            "helptext": qsTr("Draw circle")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-circle-filled",     "helptext": qsTr("Draw filled circle")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-ellipse",           "helptext": qsTr("Draw ellipse")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-ellipse-filled",    "helptext": qsTr("Draw filled ellipse")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-etriangle",         "helptext": qsTr("Draw equilateral triangle")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-etriangle-filled",  "helptext": qsTr("Draw filled e-triangle")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-ritriangle",        "helptext": qsTr("Draw right isosceles triangle")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-ritriangle-filled", "helptext": qsTr("Draw filled ri-triangle")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-polygon",           "helptext": qsTr("Draw regular polygon")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-polygon-filled",    "helptext": qsTr("Draw filled regular polygon")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-polygram",          "helptext": qsTr("Draw regular polygram")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-polygram-filled",   "helptext": qsTr("Draw filled regular polygram")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-arrow",             "helptext": qsTr("Draw thick arrow")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-arrow-filled",      "helptext": qsTr("Draw filled thick arrow")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-geom-fill",              "helptext": qsTr("Fill mode toggle")})
        buttonhelp.append( {"image": "",                                                 "helptext": qsTr("More tools toolbar")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-texttool",               "helptext": qsTr("Add/cancel text")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-addimage",               "helptext": qsTr("Add/cancel image")})
        buttonhelp.append( {"image": "image://theme/icon-m-enter-accept",                "helptext": qsTr("Accept current text/image")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-dimensiontool",          "helptext": qsTr("Dimensioning tool")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-grid",                   "helptext": qsTr("Grid")})
        buttonhelp.append( {"image": "",                                                 "helptext": qsTr("File toolbar")})
        buttonhelp.append( {"image": "image://theme/icon-m-about",                       "helptext": qsTr("About Paint")})
        buttonhelp.append( {"image": "image://theme/icon-m-developer-mode",              "helptext": qsTr("Change settings")})
        buttonhelp.append( {"image": "image://theme/icon-m-delete",                      "helptext": qsTr("Clear drawing")})
        buttonhelp.append( {"image": "image://theme/icon-m-image",                       "helptext": qsTr("Change background")})
        buttonhelp.append( {"image": "image://paintIcons/icon-m-save",                   "helptext": qsTr("Save snapshot")})
        buttonhelp.append( {"image": "",                                                 "helptext": qsTr("Clipboard and layers toolbar")})
        buttonhelp.append( {"image": "image://theme/icon-m-clipboard",                   "helptext": qsTr("Clipboard")})
        buttonhelp.append( {"image": "image://theme/icon-m-add",                         "helptext": qsTr("Paste from clipboard")})
        buttonhelp.append( {"image": "image://theme/icon-m-enter-accept",                "helptext": qsTr("Accept current paste")})
        buttonhelp.append( {"image": "image://theme/icon-m-page-down",                   "helptext": qsTr("Layer down")})
        buttonhelp.append( {"image": "image://theme/icon-m-page-up",                     "helptext": qsTr("Layer up")})
        buttonhelp.append( {"image": "image://theme/icon-m-levels",                      "helptext": qsTr("Configure layers")})
        buttonhelp.append( {"image": "",                                                 "helptext": qsTr("Shader toolbar")})
        buttonhelp.append( {"image": "image://theme/icon-m-toy",                         "helptext": qsTr("Shader mode enable")})
        buttonhelp.append( {"image": "image://theme/icon-m-enter-accept",                "helptext": qsTr("Accept current shading")})
        buttonhelp.append( {"image": "image://theme/icon-m-display",                     "helptext": qsTr("Apply shader fullscreen")})
        buttonhelp.append( {"image": "image://theme/icon-s-developer",                   "helptext": qsTr("Show shader popup")})
        buttonhelp.append( {"image": "image://theme/icon-m-developer-mode",              "helptext": qsTr("Configure shaders")})

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
                anchors.horizontalCenter: parent.horizontalCenter
                height: Theme.iconSizeExtraLarge
                width: Theme.iconSizeExtraLarge
                color: "transparent"

                Image
                {
                    source: imagelocation
                    anchors.centerIn: parent
                    height: Theme.iconSizeLauncher
                    width: Theme.iconSizeLauncher
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
                Item
                {
                    height: Theme.iconSizeSmallPlus
                    width: parent.width - x*2
                    x: Theme.paddingLarge

                    Image
                    {
                        id: bim
                        source: image
                        width: Theme.iconSizeSmallPlus
                        height: Theme.iconSizeSmallPlus
                        anchors.left: parent.left
                    }
                    Label
                    {
                        text: helptext
                        anchors.verticalCenter: bim.verticalCenter
                        anchors.left: bim.right
                        anchors.leftMargin: Theme.paddingSmall
                    }
                }
            }
        }
    }
}
