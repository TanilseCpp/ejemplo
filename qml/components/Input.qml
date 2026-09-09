import QtQuick
import "../tokens"

// Reusable Input — state: default | focus | error | disabled
// A real editable field: default/focus are derived automatically from
// whether the field has content/focus, but can be forced (e.g. "error").
Item {
    id: root

    // NOTE: "state" is Item's own built-in property (used by States/Transitions) —
    // it is NOT redeclared here, just assigned a default, so it stays a plain
    // read/write string: default | focus | error | disabled.
    state: "default"
    property string placeholder: "Ingrese la contraseña de la red"
    property bool showIcon: true
    property url icon: ""
    property bool showHelperText: false
    property string helperText: "Texto de ayuda"
    property bool passwordMode: true

    property alias text: textInput.text

    readonly property bool isDisabled: state === "disabled"
    readonly property bool isError: state === "error"
    readonly property bool hasContent: textInput.text.length > 0
    property bool passwordVisible: false

    implicitWidth: 309
    implicitHeight: fieldColumn.implicitHeight

    Column {
        id: fieldColumn
        width: parent.width
        spacing: Spacing.padding2

        Rectangle {
            id: field
            width: parent.width
            height: 42
            radius: Spacing.radius3
            border.width: 1
            border.color: root.isDisabled ? Colors.white4 : (root.isError ? Colors.red6 : Colors.white5)
            color: root.isDisabled ? Colors.white2 : (root.isError ? Colors.red1 : Colors.white1)

            Row {
                anchors.fill: parent
                anchors.leftMargin: Spacing.padding5
                anchors.rightMargin: Spacing.padding5
                spacing: Spacing.padding3

                TextInput {
                    id: textInput
                    width: parent.width - (root.showIcon ? 16 + Spacing.padding3 : 0)
                    anchors.verticalCenter: parent.verticalCenter
                    enabled: !root.isDisabled
                    echoMode: (root.passwordMode && !root.passwordVisible) ? TextInput.Password : TextInput.Normal
                    font.family: Typography.fontFamily
                    font.pixelSize: Typography.bodyRegular14.pixelSize
                    font.weight: Typography.bodyRegular14.weight
                    color: root.isDisabled ? Colors.black3 : Colors.black6
                    clip: true
                    selectByMouse: true

                    onActiveFocusChanged: {
                        if (!root.isError && !root.isDisabled)
                            root.state = activeFocus ? "focus" : "default";
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.placeholder
                        visible: !textInput.text.length && !textInput.activeFocus
                        font.family: Typography.fontFamily
                        font.pixelSize: Typography.bodyRegular14.pixelSize
                        font.weight: Typography.bodyRegular14.weight
                        color: root.isDisabled ? Colors.black3 : Colors.white6
                    }
                }

                Image {
                    width: 16
                    height: 16
                    anchors.verticalCenter: parent.verticalCenter
                    visible: root.showIcon
                    fillMode: Image.PreserveAspectFit
                    source: {
                        if (root.icon.toString().length) return root.icon;
                        return root.passwordVisible
                            ? "../icons/eye-hidden.svg"
                            : "../icons/eye-visible.svg";
                    }

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -4
                        enabled: !root.isDisabled && root.passwordMode
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.passwordVisible = !root.passwordVisible
                    }
                }
            }
        }

        Text {
            width: parent.width
            visible: root.showHelperText
            text: root.helperText
            font.family: Typography.fontFamily
            font.pixelSize: Typography.detailsRegular12.pixelSize
            font.weight: Typography.detailsRegular12.weight
            color: root.isError ? Colors.red6 : Colors.black4
        }
    }
}
