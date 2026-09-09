import QtQuick
import "../tokens"

// Reusable Badge — variant: success | warning | error | info | neutral
Item {
    id: root

    property string variant: "success"
    property string label: "Badge"

    implicitWidth: labelText.implicitWidth + 20
    implicitHeight: labelText.implicitHeight + 8

    Rectangle {
        anchors.fill: parent
        radius: Spacing.radius11
        color: {
            switch (root.variant) {
            case "warning": return Colors.yellow1;
            case "error": return Colors.red1;
            case "info": return Colors.blue1;
            case "neutral": return Colors.white3;
            default: return Colors.green1;
            }
        }
    }

    Text {
        id: labelText
        anchors.centerIn: parent
        text: root.label
        font.family: Typography.fontFamily
        font.pixelSize: Typography.detailsSemibold12.pixelSize
        font.weight: Typography.detailsSemibold12.weight
        lineHeightMode: Text.FixedHeight
        lineHeight: Typography.detailsSemibold12.lineHeight
        color: {
            switch (root.variant) {
            case "warning": return Colors.yellow8;
            case "error": return Colors.red8;
            case "info": return Colors.blue8;
            case "neutral": return Colors.black4;
            default: return Colors.green8;
            }
        }
    }
}
