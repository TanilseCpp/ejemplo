pragma Singleton
import QtQuick

// Design tokens — Typography
// Inter, scale Title/Headlines/Body/Details in Bold/Semibold/Regular.
// Each entry carries pixelSize, weight and lineHeight (px) exactly as documented
// in the Figma text styles. Components should bind Text.font.* and
// lineHeightMode: Text.FixedHeight / lineHeight: <token>.lineHeight to these.
QtObject {
    readonly property string fontFamily: "Inter"

    readonly property FontStyle titleBold32: FontStyle {
        pixelSize: 32
        weight: Font.Bold
        lineHeight: 42
    }

    readonly property FontStyle headlineBold24: FontStyle {
        pixelSize: 24
        weight: Font.Bold
        lineHeight: 32
    }

    readonly property FontStyle headlineBold20: FontStyle {
        pixelSize: 20
        weight: Font.Bold
        lineHeight: 28
    }

    readonly property FontStyle bodyBold16: FontStyle {
        pixelSize: 16
        weight: Font.Bold
        lineHeight: 22
    }

    readonly property FontStyle bodyRegular14: FontStyle {
        pixelSize: 14
        weight: Font.Normal
        lineHeight: 19
    }

    readonly property FontStyle bodySemibold14: FontStyle {
        pixelSize: 14
        weight: Font.DemiBold
        lineHeight: 19
    }

    readonly property FontStyle bodyBold14: FontStyle {
        pixelSize: 14
        weight: Font.Bold
        lineHeight: 19
    }

    readonly property FontStyle detailsRegular12: FontStyle {
        pixelSize: 12
        weight: Font.Normal
        lineHeight: 16
    }

    readonly property FontStyle detailsSemibold12: FontStyle {
        pixelSize: 12
        weight: Font.DemiBold
        lineHeight: 16
    }

    readonly property FontStyle detailsBold12: FontStyle {
        pixelSize: 12
        weight: Font.Bold
        lineHeight: 16
    }
}
