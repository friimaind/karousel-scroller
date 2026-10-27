import QtQuick
import QtQuick.Controls as QQC2

// Integer SpinBox that displays and accepts values as percentages (e.g. "150 %").
QQC2.SpinBox {
    id: spinBox

    readonly property string percentSuffix: " %"

    editable: true

    // The displayed text includes the suffix, so an IntValidator would reject it
    validator: RegularExpressionValidator {
        regularExpression: /^\s*\d{1,3}\s*%?\s*$/
    }

    textFromValue: (value, locale) => Number(value).toLocaleString(locale, "f", 0) + percentSuffix

    valueFromText: (text, locale) => Number.fromLocaleString(locale, text.replace("%", "").trim())
}
