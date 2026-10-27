import QtQuick
import QtQuick.Shapes

// Monochrome "< • >" glyph used in compact mode: left arrow, dot, right arrow.
// Coordinates are relative to the item size, so it scales to any panel thickness.
Item {
    id: glyph

    property color color: "white"

    readonly property real heightToWidthRatio: 0.5
    readonly property real strokeWidth: height * 0.16
    readonly property real chevronDepth: width * 0.18
    readonly property real chevronInset: strokeWidth / 2
    readonly property real dotDiameter: height * 0.3

    implicitWidth: 48
    implicitHeight: implicitWidth * heightToWidthRatio

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            id: leftChevron

            strokeColor: glyph.color
            strokeWidth: glyph.strokeWidth
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            startX: glyph.chevronInset + glyph.chevronDepth
            startY: glyph.chevronInset
            PathLine { x: glyph.chevronInset; y: glyph.height / 2 }
            PathLine { x: glyph.chevronInset + glyph.chevronDepth; y: glyph.height - glyph.chevronInset }
        }

        ShapePath {
            strokeColor: leftChevron.strokeColor
            strokeWidth: leftChevron.strokeWidth
            fillColor: leftChevron.fillColor
            capStyle: leftChevron.capStyle
            joinStyle: leftChevron.joinStyle

            startX: glyph.width - glyph.chevronInset - glyph.chevronDepth
            startY: glyph.chevronInset
            PathLine { x: glyph.width - glyph.chevronInset; y: glyph.height / 2 }
            PathLine { x: glyph.width - glyph.chevronInset - glyph.chevronDepth; y: glyph.height - glyph.chevronInset }
        }
    }

    Rectangle {
        anchors.centerIn: parent
        width: glyph.dotDiameter
        height: width
        radius: width / 2
        color: glyph.color
    }
}
