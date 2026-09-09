import QtQuick
import "../tokens"

// Reusable StatusBadge — status: success | warning | error
// Reflects the aggregated state of the 3 system alerts (see WifiConfigScreen):
//   success -> all 3 OK · warning -> at least 1 failing · error -> all 3 failing
Item {
    id: root

    property string status: "success"

    readonly property var copy: {
        switch (root.status) {
        case "warning": return {
            title: "WiFi: Advertencia",
            description: "Una de las conexiones presenta un problema"
        };
        case "error": return {
            title: "WiFi: Sin conexión",
            description: "Todas las conexiones están fuera de línea"
        };
        default: return {
            title: "WiFi: Activado",
            description: "El adaptador está habilitado"
        };
        }
    }

    readonly property color iconBg: {
        switch (root.status) {
        case "warning": return Colors.yellow6;
        case "error": return Colors.red6;
        default: return Colors.green6;
        }
    }

    readonly property color titleColor: {
        switch (root.status) {
        case "warning": return Colors.yellow8;
        case "error": return Colors.red7;
        default: return Colors.green7;
        }
    }

    implicitWidth: row.implicitWidth + Spacing.padding5 * 2
    implicitHeight: 40 + Spacing.padding4 * 2

    Rectangle {
        anchors.fill: parent
        radius: Spacing.radius4
        color: Colors.white1
        border.width: 1
        border.color: Colors.white5
    }

    Row {
        id: row
        anchors.fill: parent
        anchors.margins: Spacing.padding4
        anchors.leftMargin: Spacing.padding5
        anchors.rightMargin: Spacing.padding5
        spacing: Spacing.padding4

        Rectangle {
            width: 40
            height: 40
            radius: 20
            color: root.iconBg
            anchors.verticalCenter: parent.verticalCenter

            Image {
                anchors.centerIn: parent
                width: 26
                height: 26
                source: "../icons/wifi.svg"
            }
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: Spacing.gap1

            Text {
                text: root.copy.title
                font.family: Typography.fontFamily
                font.pixelSize: Typography.bodySemibold14.pixelSize
                font.weight: Typography.bodySemibold14.weight
                lineHeightMode: Text.FixedHeight
                lineHeight: Typography.bodySemibold14.lineHeight
                color: root.titleColor
            }

            Text {
                text: root.copy.description
                font.family: Typography.fontFamily
                font.pixelSize: Typography.detailsRegular12.pixelSize
                font.weight: Typography.detailsRegular12.weight
                lineHeightMode: Text.FixedHeight
                lineHeight: Typography.detailsRegular12.lineHeight
                color: Colors.black6
            }
        }
    }
}
