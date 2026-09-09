import QtQuick
import QtQuick.Layouts
import "../tokens"

// Reusable ListItem — state: default | hover | selected | disabled
Item {
    id: root

    // NOTE: "state" is Item's own built-in property — assigned a default here,
    // not redeclared, so it stays a plain read/write string.
    state: "default"
    property string label: "Elemento de lista"
    property string secondaryText: "Detalle"
    property bool showSecondaryText: true
    property bool showIcon: true
    property url icon: "../icons/network-default.svg"
    property bool showChevron: true
    // Some usages (e.g. the static "Otros..." row) should stay flat and never
    // show a hover treatment, even though they're still clickable.
    property bool hoverEnabled: true

    signal clicked()

    readonly property bool isDisabled: state === "disabled"
    readonly property bool isSelected: state === "selected"
    readonly property bool interactive: !isDisabled

    readonly property string effectiveState: {
        if (isDisabled) return "disabled";
        if (isSelected) return "selected";
        if (root.hoverEnabled && mouseArea.containsMouse) return "hover";
        return "default";
    }

    implicitWidth: 400
    implicitHeight: 51

    Rectangle {
        anchors.fill: parent
        border.width: root.effectiveState === "selected" ? 1 : 0
        border.color: Colors.blue6
        color: {
            switch (root.effectiveState) {
            case "selected": return Colors.blue1;
            case "hover": return Colors.white2;
            default: return Colors.white1;
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: Spacing.padding5
        spacing: Spacing.padding4

        Image {
            Layout.preferredWidth: 16
            Layout.preferredHeight: 16
            visible: root.showIcon
            fillMode: Image.PreserveAspectFit
            source: root.icon
        }

        Text {
            Layout.fillWidth: true
            text: root.label
            font.family: Typography.fontFamily
            font.pixelSize: Typography.bodyRegular14.pixelSize
            font.weight: Typography.bodyRegular14.weight
            lineHeightMode: Text.FixedHeight
            lineHeight: Typography.bodyRegular14.lineHeight
            color: root.isDisabled ? Colors.black3 : Colors.black6
            elide: Text.ElideRight
        }

        Text {
            id: secondaryLabel
            visible: root.showSecondaryText
            text: root.secondaryText
            font.family: Typography.fontFamily
            font.pixelSize: Typography.detailsRegular12.pixelSize
            font.weight: Typography.detailsRegular12.weight
            lineHeightMode: Text.FixedHeight
            lineHeight: Typography.detailsRegular12.lineHeight
            color: Colors.black4
        }

        Image {
            Layout.preferredWidth: 16
            Layout.preferredHeight: 16
            visible: root.showChevron
            fillMode: Image.PreserveAspectFit
            source: "../icons/chevron-down.svg"
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: root.interactive && root.hoverEnabled
        enabled: root.interactive
        cursorShape: root.interactive ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.clicked()
    }
}
