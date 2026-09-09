import QtQuick
import QtQuick.Layouts
import "../tokens"

// Reusable NetworkRow ("Desplegable - Red") — state: default | expandido | conectado
// Expandable row: header (network name + signal/lock/chevron) that reveals a
// password field with Conectar / Cancelar actions.
Item {
    id: root

    // NOTE: "state" is Item's own built-in property — assigned a default here,
    // not redeclared, so it stays a plain read/write string.
    state: "default"
    property string networkName: "PRISMA_COFFEE_5G"

    signal connected(string networkName, string password)
    signal cancelled()
    signal headerClicked()

    readonly property bool isExpanded: state === "expandido"
    readonly property bool isConnected: state === "conectado"
    property bool connecting: false

    implicitWidth: 844
    implicitHeight: column.implicitHeight

    Column {
        id: column
        width: parent.width

        Rectangle {
            id: header
            width: parent.width
            height: headerRow.implicitHeight + Spacing.padding5 * 2
            color: root.isExpanded ? Colors.white2 : Colors.white1

            RowLayout {
                id: headerRow
                anchors.fill: parent
                anchors.margins: Spacing.padding5
                spacing: Spacing.padding4

                Image {
                    Layout.preferredWidth: 16
                    Layout.preferredHeight: 11
                    visible: root.isConnected
                    fillMode: Image.PreserveAspectFit
                    source: "../icons/checkmark-connected.svg"
                }

                Image {
                    Layout.preferredWidth: 16
                    Layout.preferredHeight: 16
                    fillMode: Image.PreserveAspectFit
                    source: (root.isExpanded || root.isConnected)
                            ? "../icons/network-active.svg"
                            : "../icons/network-default.svg"
                }

                Text {
                    Layout.fillWidth: true
                    text: root.networkName
                    font.family: Typography.fontFamily
                    font.pixelSize: Typography.bodySemibold14.pixelSize
                    font.weight: Typography.bodySemibold14.weight
                    lineHeightMode: Text.FixedHeight
                    lineHeight: Typography.bodySemibold14.lineHeight
                    color: Colors.black6
                    elide: Text.ElideRight
                }

                Image {
                    Layout.preferredWidth: 13
                    Layout.preferredHeight: 13
                    fillMode: Image.PreserveAspectFit
                    source: "../icons/lock.svg"
                }

                Image {
                    Layout.preferredWidth: 18
                    Layout.preferredHeight: 18
                    fillMode: Image.PreserveAspectFit
                    source: "../icons/signal-full.svg"
                }

                Image {
                    Layout.preferredWidth: 16
                    Layout.preferredHeight: 16
                    fillMode: Image.PreserveAspectFit
                    source: root.isExpanded ? "../icons/chevron-up.svg" : "../icons/chevron-down.svg"
                }
            }

            MouseArea {
                anchors.fill: parent
                enabled: !root.isConnected && !root.connecting
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.state = root.isExpanded ? "default" : "expandido";
                    root.headerClicked();
                }
            }
        }

        Rectangle {
            width: parent.width
            visible: root.isExpanded
            height: visible ? expandedColumn.implicitHeight + Spacing.padding5 * 2 : 0
            color: Colors.white2

            Column {
                id: expandedColumn
                x: Spacing.padding9
                y: Spacing.padding5
                width: parent.width - Spacing.padding9 * 2
                spacing: Spacing.gap6

                Input {
                    id: passwordInput
                    width: parent.width
                    placeholder: "Ingrese la contraseña de la red"
                    showHelperText: state === "error"
                    helperText: "Ingresá la contraseña para continuar."
                }

                Row {
                    width: parent.width
                    spacing: Spacing.gap6

                    Button {
                        width: (parent.width - Spacing.gap6) / 2
                        type: "primary"
                        size: "big"
                        state: root.connecting ? "loader" : "default"
                        text: "Conectar"
                        showIcon: true
                        icon: "../icons/connect.svg"
                        onClicked: {
                            if (root.connecting) return;
                            if (passwordInput.text.length === 0) {
                                passwordInput.state = "error";
                                return;
                            }
                            root.connecting = true;
                            connectTimer.start();
                        }
                    }

                    Button {
                        width: (parent.width - Spacing.gap6) / 2
                        type: "secondary"
                        size: "big"
                        enabled: !root.connecting
                        text: "Cancelar"
                        onClicked: {
                            connectTimer.stop();
                            root.connecting = false;
                            passwordInput.text = "";
                            passwordInput.state = "default";
                            root.state = "default";
                            root.cancelled();
                        }
                    }
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 1
            color: Colors.white5
        }
    }

    // Simulates the connection attempt so the Button's "loader" state (three
    // animated dots, node 22401:144 in Figma) actually gets a chance to show
    // before the row flips to "conectado".
    Timer {
        id: connectTimer
        interval: 1200
        onTriggered: {
            root.connecting = false;
            root.state = "conectado";
            root.connected(root.networkName, passwordInput.text);
        }
    }
}
