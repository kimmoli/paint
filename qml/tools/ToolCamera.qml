import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.paint.PainterClass 1.0
import org.nemomobile.dbus 1.0

import "../components"

ToolbarButton
{
    icon.source: "image://theme/icon-m-camera"

    onClicked:
    {
        jollaCamera.call("showViewfinder", "hello")
    }

    DBusInterface
    {
        id: jollaCamera
        service: "com.jolla.camera"
        path: "/"
        iface: "com.jolla.camera.ui"
    }
}
