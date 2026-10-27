import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: page

    // Bound automatically by Plasma to the "scrollSpeedMultiplier" config entry
    property real cfg_scrollSpeedMultiplier
    property real cfg_scrollSpeedMultiplierDefault
    property alias cfg_invertWheelDirection: invertWheelCheckBox.checked
    property bool cfg_invertWheelDirectionDefault

    // SpinBox only handles integers: values are stored scaled by this factor
    readonly property int decimalScale: 10
    readonly property int decimalDigits: 1
    readonly property real minimumMultiplier: 0.1
    readonly property real maximumMultiplier: 10.0

    Kirigami.FormLayout {
        QQC2.SpinBox {
            id: multiplierSpinBox

            Kirigami.FormData.label: i18n("Scroll speed multiplier:")

            from: Math.round(page.minimumMultiplier * page.decimalScale)
            to: Math.round(page.maximumMultiplier * page.decimalScale)
            stepSize: 1
            editable: true
            value: Math.round(page.cfg_scrollSpeedMultiplier * page.decimalScale)

            validator: DoubleValidator {
                bottom: page.minimumMultiplier
                top: page.maximumMultiplier
                decimals: page.decimalDigits
            }

            textFromValue: (scaledValue, locale) =>
                Number(scaledValue / page.decimalScale).toLocaleString(locale, "f", page.decimalDigits)

            valueFromText: (text, locale) =>
                Math.round(Number.fromLocaleString(locale, text) * page.decimalScale)

            onValueModified: page.cfg_scrollSpeedMultiplier = value / page.decimalScale
        }

        QQC2.Label {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            font: Kirigami.Theme.smallFont
            text: i18n("Number of Karousel scroll steps per wheel notch (or per click, rounded, minimum 1). The size of a single step is set in Karousel's own settings.")
        }

        QQC2.CheckBox {
            id: invertWheelCheckBox

            Kirigami.FormData.label: i18n("Mouse wheel:")
            text: i18n("Invert scroll direction")
        }

        QQC2.Label {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            font: Kirigami.Theme.smallFont
            text: i18n("Default: wheel down scrolls left, wheel up scrolls right. The arrow buttons are not affected.")
        }
    }
}
