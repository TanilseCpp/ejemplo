pragma Singleton
import QtQuick

// Design tokens — Spacing & Radius
// Base scale: 0, 2, 4, 8, 12, 16, 20, 24, 32, 40, 48, 56 (indices 0..11).
// Figma names the same numeric scale differently depending on where it's applied
// (gap-N, Padding-N, Radius-N) — the three groups below mirror that so component
// code reads the same as the Figma property panel.
QtObject {
    readonly property var scale: [0, 2, 4, 8, 12, 16, 20, 24, 32, 40, 48, 56]

    // gap-0 .. gap-11 — spacing between flex children
    readonly property int gap0: 0
    readonly property int gap1: 2
    readonly property int gap2: 4
    readonly property int gap3: 8
    readonly property int gap4: 12
    readonly property int gap5: 16
    readonly property int gap6: 20
    readonly property int gap7: 24
    readonly property int gap8: 32
    readonly property int gap9: 40
    readonly property int gap10: 48
    readonly property int gap11: 56

    // Padding-0 .. Padding-11 — internal padding
    readonly property int padding0: 0
    readonly property int padding1: 2
    readonly property int padding2: 4
    readonly property int padding3: 8
    readonly property int padding4: 12
    readonly property int padding5: 16
    readonly property int padding6: 20
    readonly property int padding7: 24
    readonly property int padding8: 32
    readonly property int padding9: 40
    readonly property int padding10: 48
    readonly property int padding11: 56

    // Radius-0 .. Radius-11 — corner radius
    readonly property int radius0: 0
    readonly property int radius1: 2
    readonly property int radius2: 4
    readonly property int radius3: 8
    readonly property int radius4: 12
    readonly property int radius5: 16
    readonly property int radius6: 20
    readonly property int radius7: 24
    readonly property int radius8: 32
    readonly property int radius9: 40
    readonly property int radius10: 48
    readonly property int radius11: 56

    // One-off radii used by specific screen containers (outside the base scale,
    // as authored in Figma: the outer framed card, its inner panels wrapper, and
    // the "Tip" box inside Panel — Estado del sistema).
    readonly property int radiusCard: 36
    readonly property int radiusPanelsWrapper: 28
    readonly property int radiusTipBox: 14
    readonly property int radiusNetworkList: 10
    readonly property int radiusHeaderCard: 16
}
