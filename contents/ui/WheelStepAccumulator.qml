import QtQuick

// Converts raw wheel deltas into whole scroll steps. Fractional remainders are
// kept, so touchpads and multipliers below 1 still behave smoothly.
QtObject {
    id: accumulator

    readonly property int angleDeltaPerNotch: 120

    property real multiplier: 1.0
    property real pendingSteps: 0

    // Positive steps mean "wheel up", negative steps mean "wheel down"
    signal stepsReady(int steps)

    function addAngleDelta(angleDelta) {
        if (angleDelta === 0) {
            return
        }
        discardPendingStepsOnDirectionChange(angleDelta)
        pendingSteps += angleDelta / angleDeltaPerNotch * multiplier
        emitWholeSteps()
    }

    function discardPendingStepsOnDirectionChange(angleDelta) {
        if (Math.sign(angleDelta) !== Math.sign(pendingSteps)) {
            pendingSteps = 0
        }
    }

    function emitWholeSteps() {
        const wholeSteps = Math.trunc(pendingSteps)
        if (wholeSteps === 0) {
            return
        }
        pendingSteps -= wholeSteps
        stepsReady(wholeSteps)
    }
}
