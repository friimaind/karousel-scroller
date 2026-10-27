import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    readonly property bool isVerticalPanel: Plasmoid.formFactor === PlasmaCore.Types.Vertical
    readonly property real speedMultiplier: Plasmoid.configuration.scrollSpeedMultiplier
    readonly property int stepsPerClick: Math.max(1, Math.round(speedMultiplier))
    // By default wheel up scrolls right; inverting flips the sign of the wheel delta
    readonly property int wheelDirectionSign: Plasmoid.configuration.invertWheelDirection ? -1 : 1
    readonly property real arrowCellAspectRatio: 1.6
    readonly property real centerCellAspectRatio: 1.0
    readonly property int cellSpacing: 2
    readonly property int cellCount: 3
    // Widget length relative to the panel thickness, for horizontal and vertical panels
    readonly property real horizontalLengthRatio: 2 * arrowCellAspectRatio + centerCellAspectRatio
    readonly property real verticalLengthRatio: 2 / arrowCellAspectRatio + 1 / centerCellAspectRatio
    readonly property real totalSpacing: (cellCount - 1) * cellSpacing

    preferredRepresentation: fullRepresentation
    toolTipMainText: i18n("Karousel Scroller")
    toolTipSubText: i18n("Arrows or mouse wheel: scroll. Dot: center the focused window")

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

        // Only listens to the wheel: clicks are handled by the buttons
        acceptedButtons: Qt.NoButton

        Layout.preferredWidth: root.isVerticalPanel ? -1 : height * root.horizontalLengthRatio + root.totalSpacing
        Layout.preferredHeight: root.isVerticalPanel ? width * root.verticalLengthRatio + root.totalSpacing : -1

        onWheel: wheel => wheelAccumulator.addAngleDelta(wheel.angleDelta.y * root.wheelDirectionSign)

        GridLayout {
            anchors.fill: parent
            columns: root.isVerticalPanel ? 1 : root.cellCount
            rowSpacing: root.cellSpacing
            columnSpacing: root.cellSpacing

            PanelButton {
                Layout.fillWidth: true
                Layout.fillHeight: true
                iconName: root.isVerticalPanel ? "go-up" : "go-previous"
                autoRepeat: true
                onActionRequested: karousel.scrollLeft(root.stepsPerClick)
            }

            PanelButton {
                // Fixed size along the panel direction, the arrows take the rest
                Layout.preferredWidth: root.isVerticalPanel ? -1 : height * root.centerCellAspectRatio
                Layout.preferredHeight: root.isVerticalPanel ? width / root.centerCellAspectRatio : -1
                Layout.fillWidth: root.isVerticalPanel
                Layout.fillHeight: !root.isVerticalPanel
                iconName: "media-record"
                iconSizeRatio: 0.35
                onActionRequested: karousel.centerFocusedWindow()
            }

            PanelButton {
                Layout.fillWidth: true
                Layout.fillHeight: true
                iconName: root.isVerticalPanel ? "go-down" : "go-next"
                autoRepeat: true
                onActionRequested: karousel.scrollRight(root.stepsPerClick)
            }
        }
    }
}
