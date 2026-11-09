import QtQuick
import org.kde.kirigami as Kirigami

// A Pager-like cell showing a single icon.
// Emits actionRequested on press and, when autoRepeat is enabled,
// keeps emitting it while the button is held down.
MouseArea {
    id: button

    property alias iconName: buttonIcon.source
    property real iconSizeRatio: 0.6
    // Monochrome built-in icons are tinted with the text color; user-chosen icons keep their own colors
    property bool iconIsMask: true
    // When false the cell is drawn only on hover/press, like a plain panel icon
    property bool showBackground: true
    // Optional item drawn instead of the theme icon (e.g. a custom glyph)
    property Component customContent: null

    readonly property color contentColor: pressed ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
    readonly property real contentSize: Math.min(width, height) * iconSizeRatio
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
        if (!showBackground) {
            return "transparent"
        }
        return withOpacity(Kirigami.Theme.textColor, idleFillOpacity)
    }

    function currentBorderColor() {
        if (containsMouse) {
            return Kirigami.Theme.highlightColor
        }
        if (!showBackground) {
            return "transparent"
        }
        return withOpacity(Kirigami.Theme.textColor, idleBorderOpacity)
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
        border.color: button.currentBorderColor()
    }

    Kirigami.Icon {
        id: buttonIcon

        visible: button.customContent === null
        anchors.centerIn: parent
        width: button.contentSize
        height: width
        color: button.contentColor
        isMask: button.iconIsMask
    }

    Loader {
        anchors.centerIn: parent
        active: button.customContent !== null
        sourceComponent: button.customContent
    }
}
