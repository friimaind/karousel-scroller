import QtQuick
import org.kde.kirigami as Kirigami

// A Pager-like cell showing a single icon.
// Emits actionRequested on press and, when autoRepeat is enabled,
// keeps emitting it while the button is held down.
MouseArea {
    id: button

    property alias iconName: buttonIcon.source
    property alias iconFallback: buttonIcon.fallback
    property real iconSizeRatio: 0.6
    property bool autoRepeat: false

    readonly property int holdInitialDelayMs: 400
    readonly property int holdRepeatIntervalMs: 100

    readonly property real idleFillOpacity: 0.1
    readonly property real idleBorderOpacity: 0.3
    readonly property real hoverFillOpacity: 0.4

    signal actionRequested()

    hoverEnabled: true

    onPressed: handlePress()
    onReleased: stopRepeating()
    onCanceled: stopRepeating()

    function handlePress() {
        actionRequested()
        if (autoRepeat) {
            startRepeating()
        }
    }

    function startRepeating() {
        holdRepeatTimer.interval = holdInitialDelayMs
        holdRepeatTimer.restart()
    }

    function stopRepeating() {
        holdRepeatTimer.stop()
    }

    function withOpacity(baseColor, opacity) {
        return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, opacity)
    }

    function currentFillColor() {
        if (pressed) {
            return Kirigami.Theme.highlightColor
        }
        if (containsMouse) {
            return withOpacity(Kirigami.Theme.highlightColor, hoverFillOpacity)
        }
        return withOpacity(Kirigami.Theme.textColor, idleFillOpacity)
    }

    Timer {
        id: holdRepeatTimer

        repeat: true

        onTriggered: {
            // After the first (longer) delay, keep firing at the faster repeat rate
            interval = button.holdRepeatIntervalMs
            button.actionRequested()
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: Kirigami.Units.cornerRadius / 2
        color: button.currentFillColor()
        border.width: 1
        border.color: button.containsMouse
            ? Kirigami.Theme.highlightColor
            : button.withOpacity(Kirigami.Theme.textColor, button.idleBorderOpacity)
    }

    Kirigami.Icon {
        id: buttonIcon

        anchors.centerIn: parent
        width: Math.min(parent.width, parent.height) * button.iconSizeRatio
        height: width
        color: button.pressed ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
        isMask: true
    }
}
