import QtQuick
import QtQuick.Window

Window {
    id: root

    width: 1920
    height: 1080

    minimumWidth: 1000
    minimumHeight: 700

    visible: true

    title: "Configuración WiFi"

    WifiConfigScreen {
        id: wifiScreen

        x: 0
        y: 0
        width: parent.width
    }
}
