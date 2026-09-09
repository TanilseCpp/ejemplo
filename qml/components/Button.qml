pragma ComponentBehavior: Bound
import QtQuick
import "../tokens"

// Reusable Button — type: primary | secondary | tertiary
//                   size: small | medium | big
//                   state: default | hover | pressed | disabled | loader (loader is primary-only)
Item {
    id: root

    property string type: "primary"       // primary | secondary | tertiary
    property string size: "medium"        // small | medium | big
    // NOTE: "state" is Item's own built-in property (used by States/Transitions) —
    // it is NOT redeclared here, just assigned a default, so it stays a plain
    // read/write string: default | hover | pressed | disabled | loader.
    state: "default"
    property string text: "Button"
    property bool showIcon: false
    property url icon: "../icons/connect.svg"

    signal clicked()

    readonly property bool isLoader: state === "loader" && type === "primary"
    readonly property bool isDisabled: state === "disabled"
    readonly property bool interactive: !isDisabled && !isLoader

    // Real interaction drives the visual state unless the caller forces
    // "disabled" or "loader" — hover/pressed still come from the mouse.
    readonly property string effectiveState: {
        if (isDisabled) return "disabled";
        if (isLoader) return "loader";
        if (mouseArea.pressed) return "pressed";
        if (mouseArea.containsMouse) return "hover";
        return "default";
    }

    readonly property var typography: {
        if (size === "small") return Typography.detailsBold12;
        if (size === "big") return Typography.bodyBold16;
        return Typography.bodyBold14;
    }

    implicitWidth: 160
    implicitHeight: label.implicitHeight + Spacing.padding3 * 2

    Rectangle {
        id: background
        anchors.fill: parent
        radius: Spacing.radius3
        border.width: root.type === "secondary" ? 1 : 0
        border.color: {
            if (root.type !== "secondary") return "transparent";
            switch (root.effectiveState) {
            case "hover":
            case "pressed": return Colors.black3;
            case "disabled": return Colors.white5;
            default: return Colors.white6;
            }
        }
        color: {
            if (root.type === "primary") {
                switch (root.effectiveState) {
                case "hover": return Colors.green5;
                case "pressed":
                case "loader": return Colors.green7;
                case "disabled": return Colors.white6;
                default: return Colors.green6;
                }
            }
            if (root.type === "secondary") {
                switch (root.effectiveState) {
                case "hover": return Colors.white3;
                case "pressed": return Colors.white4;
                case "disabled": return Colors.white2;
                default: return Colors.white1;
                }
            }
            // tertiary
            switch (root.effectiveState) {
            case "hover": return Colors.white3;
            case "pressed": return Colors.white4;
            default: return Colors.white1;
            }
        }
    }

    Row {
        anchors.centerIn: parent
        spacing: Spacing.padding3
        visible: !root.isLoader

        Image {
            source: root.icon
            width: 16
            height: 16
            visible: root.showIcon
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: label
            text: root.text
            font.family: Typography.fontFamily
            font.pixelSize: root.typography.pixelSize
            font.weight: root.typography.weight
            lineHeightMode: Text.FixedHeight
            lineHeight: root.typography.lineHeight
            anchors.verticalCenter: parent.verticalCenter
            color: {
                if (root.type === "primary") {
                    return root.effectiveState === "disabled" ? Colors.black3 : Colors.white1;
                }
                if (root.type === "tertiary" && root.effectiveState === "disabled") {
                    return Colors.black3;
                }
                return Colors.black4;
            }
        }
    }

    Row {
        anchors.centerIn: parent
        spacing: 4
        visible: root.isLoader

        Repeater {
            model: 3
            delegate: Rectangle {
                id: dot
                required property int index

                width: 6
                height: 6
                radius: 3
                color: Colors.white1
                opacity: 0.4

                SequentialAnimation on opacity {
                    running: root.isLoader
                    loops: Animation.Infinite
                    PauseAnimation { duration: dot.index * 150 }
                    NumberAnimation { to: 1.0; duration: 300 }
                    NumberAnimation { to: 0.4; duration: 300 }
                    PauseAnimation { duration: (2 - dot.index) * 150 }
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: root.interactive
        enabled: root.interactive
        cursorShape: root.interactive ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.clicked()
    }
}
