import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    readonly property bool isVerticalPanel: Plasmoid.formFactor === PlasmaCore.Types.Vertical
    readonly property bool isCompactMode: Plasmoid.configuration.compactMode
    readonly property real speedMultiplier: Plasmoid.configuration.scrollSpeedMultiplier
    readonly property int stepsPerClick: Math.max(1, Math.round(speedMultiplier))
    // By default wheel up scrolls right; inverting flips the sign of the wheel delta
    readonly property int wheelDirectionSign: Plasmoid.configuration.invertWheelDirection ? -1 : 1
    readonly property real lengthScale: Plasmoid.configuration.widgetLengthPercent / 100
    readonly property real thicknessScale: Plasmoid.configuration.widgetThicknessPercent / 100

    readonly property real arrowCellAspectRatio: 1.6
    readonly property real centerCellAspectRatio: 1.0
    readonly property int cellSpacing: 2
    readonly property int visibleCellCount: isCompactMode ? 1 : 3
    readonly property real totalSpacing: (visibleCellCount - 1) * cellSpacing

    preferredRepresentation: fullRepresentation
    toolTipMainText: i18n("Karousel Scroller")
    toolTipSubText: isCompactMode
        ? i18n("Mouse wheel: scroll. Click: center the focused window")
        : i18n("Arrows or mouse wheel: scroll. Dot: center the focused window")

    // Widget length relative to its thickness, along the panel direction
    function lengthToThicknessRatio() {
        if (isCompactMode) {
            return isVerticalPanel ? 1 / centerCellAspectRatio : centerCellAspectRatio
        }
        if (isVerticalPanel) {
            return 2 / arrowCellAspectRatio + 1 / centerCellAspectRatio
        }
        return 2 * arrowCellAspectRatio + centerCellAspectRatio
    }

    function scrollByWheelSteps(steps) {
        if (steps > 0) {
            karousel.scrollRight(steps)
        } else {
            karousel.scrollLeft(-steps)
        }
    }

    KarouselController {
        id: karousel
    }

    WheelStepAccumulator {
        id: wheelAccumulator

        multiplier: root.speedMultiplier
        onStepsReady: steps => root.scrollByWheelSteps(steps)
    }

    fullRepresentation: MouseArea {
        id: wheelArea

        readonly property real panelThickness: root.isVerticalPanel ? width : height
        readonly property real barThickness: panelThickness * root.thicknessScale
        readonly property real preferredLength: barThickness * root.lengthToThicknessRatio() * root.lengthScale + root.totalSpacing
        // In full mode the center cell stays square when enlarging and shrinks with the arrows when reducing
        readonly property real centerCellLength: barThickness * Math.min(1, root.lengthScale)

        // Only listens to the wheel: clicks are handled by the buttons
        acceptedButtons: Qt.NoButton

        Layout.preferredWidth: root.isVerticalPanel ? -1 : preferredLength
        Layout.preferredHeight: root.isVerticalPanel ? preferredLength : -1

        onWheel: wheel => wheelAccumulator.addAngleDelta(wheel.angleDelta.y * root.wheelDirectionSign)

        GridLayout {
            anchors.centerIn: parent
            width: root.isVerticalPanel ? wheelArea.barThickness : parent.width
            height: root.isVerticalPanel ? parent.height : wheelArea.barThickness
            columns: root.isVerticalPanel ? 1 : root.visibleCellCount
            rowSpacing: root.cellSpacing
            columnSpacing: root.cellSpacing

            PanelButton {
                visible: !root.isCompactMode
                Layout.fillWidth: true
                Layout.fillHeight: true
                iconName: root.isVerticalPanel ? "go-up" : "go-previous"
                autoRepeat: true
                onActionRequested: karousel.scrollLeft(root.stepsPerClick)
            }

            PanelButton {
                id: centerButton

                // Full mode: fixed size along the panel, the arrows take the rest.
                // Compact mode: the only cell, filling the whole widget.
                Layout.preferredWidth: root.isVerticalPanel ? -1 : wheelArea.centerCellLength * root.centerCellAspectRatio
                Layout.preferredHeight: root.isVerticalPanel ? wheelArea.centerCellLength / root.centerCellAspectRatio : -1
                Layout.fillWidth: root.isVerticalPanel || root.isCompactMode
                Layout.fillHeight: !root.isVerticalPanel || root.isCompactMode
                iconName: "media-record"
                iconSizeRatio: root.isCompactMode ? 0.75 : 0.35
                customContent: root.isCompactMode ? compactGlyphComponent : null
                onActionRequested: karousel.centerFocusedWindow()

                Component {
                    id: compactGlyphComponent

                    CompactGlyph {
                        width: centerButton.contentSize
                        height: width * heightToWidthRatio
                        color: centerButton.contentColor
                    }
                }
            }

            PanelButton {
                visible: !root.isCompactMode
                Layout.fillWidth: true
                Layout.fillHeight: true
                iconName: root.isVerticalPanel ? "go-down" : "go-next"
                autoRepeat: true
                onActionRequested: karousel.scrollRight(root.stepsPerClick)
            }
        }
    }
}
