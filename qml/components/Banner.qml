import QtQuick
import QtQuick.Layouts
import "../tokens"

// Reusable Banner — variant: success | warning | error | info
Item {
    id: root

    property string variant: "success"
    property string title: "Título del banner"
    property string description: "Descripción breve del mensaje del banner."
    property bool showDescription: true
    property string timestamp: "Hoy, 10:24"
    property bool showTimestamp: true
    property bool showIcon: true
    property url icon: ""

    implicitWidth: 458
    implicitHeight: Math.max(48, contentColumn.implicitHeight) + Spacing.padding4 * 2

    readonly property color accentColor: {
        switch (root.variant) {
        case "warning": return Colors.yellow8;
        case "error": return Colors.red8;
        case "info": return Colors.blue8;
        default: return Colors.green6;
        }
    }

    readonly property var gradientStops: {
        switch (root.variant) {
        case "warning": return [
            Qt.rgba(255/255, 251/255, 230/255, 1),
            Qt.rgba(255/255, 246/255, 197/255, 1)
        ];
        case "error": return [
            Qt.rgba(252/255, 233/255, 232/255, 1),
            Qt.rgba(248/255, 204/255, 202/255, 1)
        ];
        case "info": return [
            Qt.rgba(233/255, 240/255, 252/255, 1),
            Qt.rgba(204/255, 221/255, 247/255, 1)
        ];
        default: return [
            Qt.rgba(233/255, 242/255, 235/255, 1),
            Qt.rgba(212/255, 234/255, 218/255, 1)
        ];
        }
    }

    readonly property color borderColor: {
        switch (root.variant) {
        case "warning": return Colors.yellow2;
        case "error": return Colors.red2;
        case "info": return Colors.blue2;
        default: return Colors.green2;
        }
    }

    readonly property url defaultIcon: {
        switch (root.variant) {
        case "warning": return "../icons/alert-yellow.svg";
        case "error": return "../icons/alert-red.svg";
        case "info": return "../icons/info-blue.svg";
        default: return "../icons/status-check.svg";
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: Spacing.radius4
        border.width: 1
        border.color: root.borderColor
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: root.gradientStops[0] }
            GradientStop { position: 1.0; color: root.gradientStops[1] }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: Spacing.padding4
        spacing: 10

        Image {
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            visible: root.showIcon
            fillMode: Image.PreserveAspectFit
            source: root.icon.toString().length ? root.icon : root.defaultIcon
        }

        Column {
            id: contentColumn
            Layout.fillWidth: true
            spacing: 2

            Text {
                width: parent.width
                text: root.title
                font.family: Typography.fontFamily
                font.pixelSize: Typography.bodySemibold14.pixelSize
                font.weight: Typography.bodySemibold14.weight
                lineHeightMode: Text.FixedHeight
                lineHeight: Typography.bodySemibold14.lineHeight
                color: root.accentColor
                elide: Text.ElideRight
            }

            Text {
                width: parent.width
                visible: root.showDescription
                text: root.description
                font.family: Typography.fontFamily
                font.pixelSize: Typography.detailsRegular12.pixelSize
                font.weight: Typography.detailsRegular12.weight
                lineHeightMode: Text.FixedHeight
                lineHeight: Typography.detailsRegular12.lineHeight
                color: root.accentColor
                wrapMode: Text.WordWrap
            }
        }

        Text {
            id: timestampText
            visible: root.showTimestamp
            text: root.timestamp
            font.family: Typography.fontFamily
            font.pixelSize: Typography.detailsSemibold12.pixelSize
            font.weight: Typography.detailsSemibold12.weight
            lineHeightMode: Text.FixedHeight
            lineHeight: Typography.detailsSemibold12.lineHeight
            color: root.accentColor
        }
    }
}
