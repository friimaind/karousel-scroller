import QtQuick
import org.kde.plasma.plasma5support as P5Support

// Triggers Karousel scroll actions by invoking its KWin global shortcuts over D-Bus.
Item {
    id: controller

    readonly property string scrollLeftShortcut: "karousel-grid-scroll-left"
    readonly property string scrollRightShortcut: "karousel-grid-scroll-right"
    readonly property string centerFocusedWindowShortcut: "karousel-grid-scroll-focused"

    function centerFocusedWindow() {
        invokeShortcutRepeatedly(centerFocusedWindowShortcut, 1)
    }

    function scrollLeft(steps) {
        invokeShortcutRepeatedly(scrollLeftShortcut, steps)
    }

    function scrollRight(steps) {
        invokeShortcutRepeatedly(scrollRightShortcut, steps)
    }

    function invokeShortcutRepeatedly(shortcutName, repetitions) {
        if (repetitions < 1) {
            return
        }
        const singleInvocation = buildInvokeShortcutCommand(shortcutName)
        const invocations = Array(repetitions).fill(singleInvocation)
        shellRunner.run(invocations.join("; "))
    }

    function buildInvokeShortcutCommand(shortcutName) {
        return "dbus-send --session --type=method_call"
            + " --dest=org.kde.kglobalaccel /component/kwin"
            + " org.kde.kglobalaccel.Component.invokeShortcut"
            + " string:" + shortcutName
    }

    P5Support.DataSource {
        id: shellRunner

        property int commandSequence: 0

        engine: "executable"
        connectedSources: []

        onNewData: (sourceName, data) => disconnectSource(sourceName)

        function run(command) {
            // The engine ignores a source that is already connected, so a unique
            // trailing comment lets identical commands run back to back.
            commandSequence++
            connectSource(command + " # " + commandSequence)
        }
    }
}
