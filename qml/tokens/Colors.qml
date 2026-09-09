pragma Singleton
import QtQuick

// Design tokens — Color
// 5 families x 10 steps, extracted from the Figma file's "10 — Color" documentation
// and the "Color" Figma variables collection. Values are the source of truth: never
// hardcode a hex value in a component, reference these properties instead.
QtObject {
    // Black and White — neutral ramp (text, backgrounds, borders)
    readonly property color white1: "#ffffff"
    readonly property color white2: "#f8f8f8"
    readonly property color white3: "#f3f3f3"
    readonly property color white4: "#efefef"
    readonly property color white5: "#ececec"
    readonly property color white6: "#c9c9c9"
    readonly property color black3: "#919191"
    readonly property color black4: "#5e5e5e"
    readonly property color black5: "#2e2e2e"
    readonly property color black6: "#000000"

    // Green — primary action / success
    readonly property color green1: "#e8f3ee"
    readonly property color green2: "#c8e3d6"
    readonly property color green3: "#9dcdb5"
    readonly property color green4: "#6fb693"
    readonly property color green5: "#43a072"
    readonly property color green6: "#1a8b53"
    readonly property color green7: "#167647"
    readonly property color green8: "#12633b"
    readonly property color green9: "#0f4f2f"
    readonly property color green10: "#0c3f25"

    // Blue — active state / focus / info
    readonly property color blue1: "#e9f0fc"
    readonly property color blue2: "#cadcf7"
    readonly property color blue3: "#a0c0f0"
    readonly property color blue4: "#73a3ea"
    readonly property color blue5: "#4987e3"
    readonly property color blue6: "#216ddd"
    readonly property color blue7: "#1c5dbc"
    readonly property color blue8: "#174d9d"
    readonly property color blue9: "#133e7e"
    readonly property color blue10: "#0f3163"

    // Red — error
    readonly property color red1: "#fce9e8"
    readonly property color red2: "#f8cac8"
    readonly property color red3: "#f3a09d"
    readonly property color red4: "#ed746f"
    readonly property color red5: "#e74b43"
    readonly property color red6: "#e2231a"
    readonly property color red7: "#c01e16"
    readonly property color red8: "#a01912"
    readonly property color red9: "#81140f"
    readonly property color red10: "#66100c"

    // Yellow — warning
    readonly property color yellow1: "#fffbe6"
    readonly property color yellow2: "#fff6c2"
    readonly property color yellow3: "#ffee91"
    readonly property color yellow4: "#ffe65e"
    readonly property color yellow5: "#ffdf2e"
    readonly property color yellow6: "#ffd800"
    readonly property color yellow7: "#d9b800"
    readonly property color yellow8: "#b59900"
    readonly property color yellow9: "#917b00"
    readonly property color yellow10: "#736100"
}
