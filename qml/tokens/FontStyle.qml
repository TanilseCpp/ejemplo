import QtQuick

// A single typography entry: pixelSize/weight for font.*, plus lineHeight for
// lineHeightMode: Text.FixedHeight. Its own type (instead of an anonymous
// QtObject) so qmllint can statically verify usages like
// Typography.bodyRegular14.pixelSize instead of flagging them as unknown.
QtObject {
    property int pixelSize: 14
    property int weight: Font.Normal
    property int lineHeight: 19
}
