import QtQuick 2.0
import Sailfish.Silica 1.0
import paint.Myclass 1.0

Page
{
    id: page

    SilicaFlickable
    {
        anchors.fill: parent

        PullDownMenu
        {
            MenuItem
            {
                text: "About..."
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"),
                                          { "version": myclass.version,
                                              "year": "2014",
                                              "name": "paint",
                                              "imagelocation": "/usr/share/icons/hicolor/86x86/apps/paint.png"} )
            }
        }

        contentHeight: column.height

        Column
        {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader
            {
                title: "Paint"
            }
            Label
            {
                x: Theme.paddingLarge
                text: "Hello you"
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }
        }
    }

    Myclass
    {
        id: myclass
    }
}


