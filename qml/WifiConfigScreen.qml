pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import "../tokens"
import "../components"

// Configuración de red WiFi — assembles the full screen from the component kit.
//
// Business state is exposed as three top-level booleans (radioWifiOk,
// wifiConnectionOk, internetOk). Everything else — the 3 Banners, the
// StatusBadge aggregation rule, and the Redes disponibles panel's empty state —
// reacts to them automatically:
//   StatusBadge = success if the 3 are OK, error if the 3 fail, warning otherwise.
Item {
    id: root

    implicitWidth: 1920
    // Height is intrinsic — it grows with mainColumn's content (e.g. when a
    // NetworkRow expands) instead of being pinned to a fixed viewport.
    implicitHeight: mainColumn.height + Spacing.padding9 * 2
    // Item does not auto-bind width/height to the implicit* values the way
    // Text/Image do — that has to be done explicitly, otherwise this Item
    // (and anything anchored to it, like the background) stays at height 0
    // even though implicitHeight computes correctly.
    width: implicitWidth
    height: implicitHeight

    property bool radioWifiOk: true
    property bool wifiConnectionOk: true
    property bool internetOk: true

    readonly property int failCount: (radioWifiOk ? 0 : 1) + (wifiConnectionOk ? 0 : 1) + (internetOk ? 0 : 1)
    readonly property string aggregatedStatus: failCount === 0 ? "success" : (failCount === 3 ? "error" : "warning")

    property ListModel networksModel: ListModel {
        ListElement { networkName: "PRISMA_COFFEE_5G" }
        ListElement { networkName: "PRISMA_COFFEE" }
        ListElement { networkName: "Tostadores_Invitados" }
        ListElement { networkName: "Oficina_Principal" }
    }

    property string activeNetwork: ""
    property string connectedNetwork: ""
    property bool scanning: false

    function collapseOthers(exceptName) {
        for (let i = 0; i < networkRepeater.count; i++) {
            // qmllint disable missing-property
            // Repeater.itemAt() is statically typed as the generic Item, but
            // every item here is always the NetworkRow declared as this
            // Repeater's delegate below, which does have networkName/state.
            const row = networkRepeater.itemAt(i);
            if (row && row.networkName !== exceptName && row.state !== "conectado")
                row.state = "default";
            // qmllint enable missing-property
        }
    }

    // root's own height is now intrinsic/dynamic (it shrinks when every
    // NetworkRow is collapsed), so anchors.fill: parent alone would leave the
    // rest of the actual window unpainted whenever content is shorter than
    // the window — e.g. after a resize, or the launcher's initial window
    // size. Binding to the containing Window's real size (falling back to
    // root's own size if there isn't one, e.g. when previewed as a plain
    // component) guarantees the #f9f9f9 background always covers the full
    // visible area, regardless of how much the content above has shrunk.
    Rectangle {
        width: root.Window.window ? root.Window.window.width : root.width
        height: root.Window.window ? root.Window.window.height : root.height
        color: "#f9f9f9"
    }

    ColumnLayout {
        id: mainColumn
        // Only pinned horizontally + to the top — height is left intrinsic
        // (ColumnLayout auto-binds its own height to implicitHeight when it
        // isn't otherwise constrained) so it can grow downward with content.
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: Spacing.padding9
        spacing: Spacing.gap6

        // ---- Header --------------------------------------------------
        // Figma caps both the header and the framed card at max-w-[1604px]
        // and centers them — without this cap they stretch edge to edge on
        // wide windows, throwing off the panel proportions inside the card.
        Rectangle {
            Layout.fillWidth: true
            Layout.maximumWidth: 1604
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: headerRow.implicitHeight + Spacing.padding7 * 2
            radius: Spacing.radiusHeaderCard
            color: Colors.white1
            border.width: 1
            border.color: Colors.white5

            RowLayout {
                id: headerRow
                anchors.fill: parent
                anchors.margins: Spacing.padding7

                ColumnLayout {
                    spacing: Spacing.gap2

                    Text {
                        text: "Configuración de red WiFi"
                        font.family: Typography.fontFamily
                        font.pixelSize: Typography.headlineBold24.pixelSize
                        font.weight: Typography.headlineBold24.weight
                        lineHeightMode: Text.FixedHeight
                        lineHeight: Typography.headlineBold24.lineHeight
                        color: Colors.black6
                    }

                    Text {
                        text: "Conecte su equipo a una red WiFi disponible."
                        font.family: Typography.fontFamily
                        font.pixelSize: Typography.bodyRegular14.pixelSize
                        font.weight: Typography.bodyRegular14.weight
                        lineHeightMode: Text.FixedHeight
                        lineHeight: Typography.bodyRegular14.lineHeight
                        color: Colors.black4
                    }
                }

                Item { Layout.fillWidth: true }

                StatusBadge {
                    status: root.aggregatedStatus
                }
            }
        }

        // ---- Framed card (panels wrapper) -----------------------------
        Rectangle {
            id: framedCard
            Layout.fillWidth: true
            Layout.maximumWidth: 1604
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: panelsWrapper.height + Spacing.padding5 * 2
            radius: Spacing.radiusCard
            color: Colors.white1
            layer.enabled: true

            // Approximate shadow: shadow-[0px_14px_36px_rgba(0,0,0,0.14)]
            Rectangle {
                anchors.fill: parent
                anchors.topMargin: 6
                radius: parent.radius
                color: "#000000"
                opacity: 0.10
                z: -1
            }

            Rectangle {
                id: panelsWrapper
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Spacing.padding5
                height: panelsRow.height + Spacing.padding5 * 2
                radius: Spacing.radiusPanelsWrapper
                color: Colors.white3
                border.width: 1
                border.color: Colors.white5

                RowLayout {
                    id: panelsRow
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: Spacing.padding5
                    spacing: Spacing.gap6

                    // ---- Panel — Redes disponibles ------------------
                    // Figma's "Available Networks Panel" row uses items-start —
                    // this panel has no self-stretch of its own, so it always sits
                    // at its own natural (top-aligned) height, whether it ends up
                    // shorter or taller than "Panel — Estado del sistema" next to it.
                    Rectangle {
                        Layout.preferredWidth: 852
                        Layout.fillWidth: true
                        Layout.preferredHeight: redesColumn.height + Spacing.padding7 * 2
                        Layout.alignment: Qt.AlignTop
                        radius: Spacing.radius7
                        color: Colors.white1
                        border.width: 1
                        border.color: Colors.white5

                        ColumnLayout {
                            id: redesColumn
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: Spacing.padding7
                            spacing: Spacing.gap5

                            RowLayout {
                                Layout.fillWidth: true

                                ColumnLayout {
                                    spacing: 0

                                    Text {
                                        text: "Redes disponibles"
                                        font.family: Typography.fontFamily
                                        font.pixelSize: Typography.headlineBold20.pixelSize
                                        font.weight: Typography.headlineBold20.weight
                                        lineHeightMode: Text.FixedHeight
                                        lineHeight: Typography.headlineBold20.lineHeight
                                        color: Colors.black6
                                    }

                                    Text {
                                        text: "Seleccione una red para conectarse."
                                        font.family: Typography.fontFamily
                                        font.pixelSize: Typography.bodyRegular14.pixelSize
                                        font.weight: Typography.bodyRegular14.weight
                                        lineHeightMode: Text.FixedHeight
                                        lineHeight: Typography.bodyRegular14.lineHeight
                                        color: Colors.black4
                                    }
                                }

                                Item { Layout.fillWidth: true }

                                // "Escanear redes" — not one of Button's 3 documented
                                // types (its own light-grey chip), so it's implemented
                                // inline rather than distorting the Button component.
                                Rectangle {
                                    Layout.preferredWidth: scanRow.implicitWidth + Spacing.padding5 * 2
                                    Layout.preferredHeight: scanRow.implicitHeight + Spacing.padding3 * 2
                                    radius: Spacing.radius3
                                    color: root.scanning ? Colors.white4 : Colors.white2
                                    border.width: 1
                                    border.color: root.scanning ? Colors.black3 : Colors.white5

                                    Row {
                                        id: scanRow
                                        anchors.centerIn: parent
                                        spacing: Spacing.padding3

                                        Image {
                                            width: 15
                                            height: 15
                                            anchors.verticalCenter: parent.verticalCenter
                                            source: "../icons/scan.svg"
                                        }

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: root.scanning ? "Escaneando..." : "Escanear redes"
                                            font.family: Typography.fontFamily
                                            font.pixelSize: Typography.detailsBold12.pixelSize
                                            font.weight: Typography.detailsBold12.weight
                                            lineHeightMode: Text.FixedHeight
                                            lineHeight: Typography.detailsBold12.lineHeight
                                            color: Colors.black4
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        enabled: !root.scanning && root.radioWifiOk
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            root.scanning = true;
                                            scanTimer.start();
                                        }
                                    }

                                    Timer {
                                        id: scanTimer
                                        interval: 1500
                                        onTriggered: root.scanning = false
                                    }
                                }
                            }

                            Rectangle {
                                // Radio-off / scanning keep Figma's fixed 386px empty
                                // state; the normal list grows with its rows (including
                                // an expanded NetworkRow) instead of clipping them.
                                Layout.fillWidth: true
                                Layout.preferredHeight: (root.radioWifiOk && !root.scanning)
                                    ? normalListColumn.height
                                    : 386
                                radius: Spacing.radiusNetworkList
                                color: Colors.white1
                                // The border is drawn as a separate overlay below,
                                // after all children — NetworkRow/ListItem fill this
                                // Rectangle edge-to-edge with an opaque background,
                                // which would otherwise paint over (hide) a border
                                // set directly on this base Rectangle.

                                // Radio off — empty state
                                ColumnLayout {
                                    anchors.centerIn: parent
                                    visible: !root.radioWifiOk
                                    spacing: Spacing.gap2

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "El WiFi está desactivado"
                                        font.family: Typography.fontFamily
                                        font.pixelSize: Typography.bodySemibold14.pixelSize
                                        font.weight: Typography.bodySemibold14.weight
                                        color: Colors.black3
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Activa el radio WiFi para ver las redes disponibles."
                                        font.family: Typography.fontFamily
                                        font.pixelSize: Typography.detailsRegular12.pixelSize
                                        font.weight: Typography.detailsRegular12.weight
                                        color: Colors.black3
                                    }
                                }

                                // Scanning state
                                ColumnLayout {
                                    anchors.centerIn: parent
                                    visible: root.radioWifiOk && root.scanning
                                    spacing: Spacing.gap4

                                    Row {
                                        Layout.alignment: Qt.AlignHCenter
                                        spacing: 4

                                        Repeater {
                                            model: 3
                                            delegate: Rectangle {
                                                id: dot
                                                required property int index

                                                width: 6
                                                height: 6
                                                radius: 3
                                                color: Colors.green6
                                                opacity: 0.4

                                                SequentialAnimation on opacity {
                                                    running: root.scanning
                                                    loops: Animation.Infinite
                                                    PauseAnimation { duration: dot.index * 150 }
                                                    NumberAnimation { to: 1.0; duration: 300 }
                                                    NumberAnimation { to: 0.4; duration: 300 }
                                                    PauseAnimation { duration: (2 - dot.index) * 150 }
                                                }
                                            }
                                        }
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Buscando redes cercanas..."
                                        font.family: Typography.fontFamily
                                        font.pixelSize: Typography.bodyRegular14.pixelSize
                                        font.weight: Typography.bodyRegular14.weight
                                        color: Colors.black4
                                    }
                                }

                                // Normal list
                                ColumnLayout {
                                    id: normalListColumn
                                    anchors.top: parent.top
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    visible: root.radioWifiOk && !root.scanning
                                    spacing: 0

                                    Repeater {
                                        id: networkRepeater
                                        model: root.networksModel

                                        delegate: NetworkRow {
                                            required property var model

                                            Layout.fillWidth: true
                                            networkName: model.networkName

                                            onHeaderClicked: {
                                                if (state === "expandido")
                                                    root.collapseOthers(networkName);
                                            }
                                            onConnected: function(name, password) {
                                                root.connectedNetwork = name;
                                                root.collapseOthers(name);
                                            }
                                            onCancelled: {}
                                        }
                                    }

                                    ListItem {
                                        Layout.fillWidth: true
                                        label: "Otros..."
                                        showSecondaryText: false
                                        showChevron: true
                                        icon: "../icons/network-default.svg"
                                        hoverEnabled: false
                                    }
                                }

                                // Stroke overlay — see note above.
                                Rectangle {
                                    anchors.fill: parent
                                    radius: Spacing.radiusNetworkList
                                    color: "transparent"
                                    border.width: 1
                                    border.color: Colors.white5
                                }
                            }

                            Row {
                                // Figma only shows this footer note for the Default
                                // and Escaneando states — not when the radio is off.
                                visible: root.radioWifiOk
                                spacing: Spacing.padding3

                                Image {
                                    width: 13
                                    height: 13
                                    anchors.verticalCenter: parent.verticalCenter
                                    source: "../icons/lock.svg"
                                }

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "La red seleccionada requiere contraseña."
                                    font.family: Typography.fontFamily
                                    font.pixelSize: Typography.detailsSemibold12.pixelSize
                                    font.weight: Typography.detailsSemibold12.weight
                                    color: Colors.black4
                                }
                            }
                        }
                    }

                    // ---- Panel — Estado del sistema -----------------
                    // Both side panels now report their own real natural height
                    // (via Layout.preferredHeight) instead of only Redes
                    // disponibles driving the row: whichever panel is actually
                    // taller sets panelsRow's height. Only this panel has
                    // Layout.fillHeight (self-stretch in the Figma source) —
                    // it stretches to match Redes disponibles when that one is
                    // taller; Redes disponibles itself never had self-stretch,
                    // so it always sits at its own natural height either way.
                    // Either direction, nothing gets clipped anymore.
                    Rectangle {
                        Layout.preferredWidth: 626
                        Layout.fillWidth: true
                        Layout.preferredHeight: estadoColumn.height + Spacing.padding7 * 2
                        Layout.fillHeight: true
                        radius: Spacing.radius7
                        color: "transparent"

                        ColumnLayout {
                            id: estadoColumn
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: Spacing.padding7
                            spacing: Spacing.gap5

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0

                                RowLayout {
                                    Layout.fillWidth: true
                                    Layout.bottomMargin: Spacing.padding4
                                    spacing: Spacing.gap3

                                    Image {
                                        Layout.preferredWidth: 26
                                        Layout.preferredHeight: 26
                                        source: "../icons/status-shield.svg"
                                    }

                                    Text {
                                        text: "Estado del sistema"
                                        font.family: Typography.fontFamily
                                        font.pixelSize: Typography.headlineBold20.pixelSize
                                        font.weight: Typography.headlineBold20.weight
                                        lineHeightMode: Text.FixedHeight
                                        lineHeight: Typography.headlineBold20.lineHeight
                                        color: Colors.black6
                                    }
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 1
                                    color: Colors.white6
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: tipText.implicitHeight + Spacing.padding4 * 2
                                radius: Spacing.radiusTipBox
                                color: Colors.white5

                                Text {
                                    id: tipText
                                    anchors.fill: parent
                                    anchors.margins: Spacing.padding5
                                    anchors.leftMargin: Spacing.padding5
                                    anchors.rightMargin: Spacing.padding5
                                    text: "<b>Consejo:</b> Escanee las redes disponibles, seleccione su red e ingrese la contraseña para conectarse."
                                    textFormat: Text.StyledText
                                    wrapMode: Text.WordWrap
                                    font.family: Typography.fontFamily
                                    font.pixelSize: Typography.bodyRegular14.pixelSize
                                    font.weight: Typography.bodyRegular14.weight
                                    lineHeightMode: Text.FixedHeight
                                    lineHeight: Typography.bodyRegular14.lineHeight
                                    color: Colors.black6
                                }
                            }

                            Banner {
                                Layout.fillWidth: true
                                variant: root.radioWifiOk ? "success" : "error"
                                title: root.radioWifiOk ? "Radio WiFi activado" : "Radio WiFi desactivado"
                                description: root.radioWifiOk
                                    ? "El adaptador inalámbrico está habilitado y funcionando correctamente."
                                    : "El adaptador inalámbrico está deshabilitado."
                            }

                            Banner {
                                Layout.fillWidth: true
                                variant: root.wifiConnectionOk ? "success" : "error"
                                title: root.wifiConnectionOk ? "Conexión WiFi establecida" : "Conexión WiFi no establecida"
                                description: root.wifiConnectionOk
                                    ? "El adaptador se conectó correctamente a la red seleccionada."
                                    : "No hay conexión activa con ninguna red."
                            }

                            Banner {
                                Layout.fillWidth: true
                                variant: root.internetOk ? "success" : "error"
                                title: root.internetOk ? "Conexión a Internet establecida" : "Sin conexión a Internet"
                                description: root.internetOk
                                    ? "El sistema tiene acceso saliente a internet."
                                    : "El sistema no tiene acceso saliente a internet."
                            }
                        }
                    }
                }
            }
        }
    }
}
