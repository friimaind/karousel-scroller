import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.iconthemes as KIconThemes

KCM.SimpleKCM {
    id: page

    // Bound automatically by Plasma to the "scrollSpeedMultiplier" config entry
    property real cfg_scrollSpeedMultiplier
    property real cfg_scrollSpeedMultiplierDefault
    property alias cfg_invertWheelDirection: invertWheelCheckBox.checked
    property bool cfg_invertWheelDirectionDefault
    property alias cfg_compactMode: compactModeCheckBox.checked
    property bool cfg_compactModeDefault
    property string cfg_compactIcon
    property string cfg_compactIconDefault
    property alias cfg_showButtonBackground: showBackgroundCheckBox.checked
    property bool cfg_showButtonBackgroundDefault
    property alias cfg_widgetLengthPercent: lengthSpinBox.value
    property int cfg_widgetLengthPercentDefault
    property alias cfg_widgetThicknessPercent: thicknessSpinBox.value
    property int cfg_widgetThicknessPercentDefault

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

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Size")
        }

        QQC2.CheckBox {
            id: compactModeCheckBox

            Kirigami.FormData.label: i18n("Layout:")
            text: i18n("Compact mode (single icon)")
        }

        QQC2.Label {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            font: Kirigami.Theme.smallFont
            text: i18n("Shows a single button: the mouse wheel scrolls, a click centers the focused window.")
        }

        QQC2.Button {
            id: compactIconButton

            readonly property int previewSize: Kirigami.Units.iconSizes.large
            readonly property bool hasCustomIcon: page.cfg_compactIcon !== ""

            Kirigami.FormData.label: i18n("Compact icon:")
            enabled: compactModeCheckBox.checked
            implicitWidth: previewSize + Kirigami.Units.largeSpacing * 2
            implicitHeight: implicitWidth
            Accessible.name: i18n("Choose the compact mode icon")

            onClicked: compactIconMenu.opened ? compactIconMenu.close() : compactIconMenu.open()

            Kirigami.Icon {
                visible: compactIconButton.hasCustomIcon
                anchors.centerIn: parent
                width: compactIconButton.previewSize
                height: width
                source: page.cfg_compactIcon
            }

            CompactGlyph {
                visible: !compactIconButton.hasCustomIcon
                anchors.centerIn: parent
                width: compactIconButton.previewSize
                height: width * heightToWidthRatio
                color: Kirigami.Theme.textColor
            }

            KIconThemes.IconDialog {
                id: compactIconDialog

                onIconNameChanged: {
                    if (iconName !== "") {
                        page.cfg_compactIcon = iconName
                    }
                }
            }

            QQC2.Menu {
                id: compactIconMenu

                y: compactIconButton.height

                QQC2.MenuItem {
                    text: i18n("Choose…")
                    icon.name: "document-open-folder"
                    onClicked: compactIconDialog.open()
                }

                QQC2.MenuItem {
                    text: i18n("Reset to default (< • >)")
                    icon.name: "edit-clear"
                    enabled: compactIconButton.hasCustomIcon
                    onClicked: page.cfg_compactIcon = ""
                }
            }
        }

        QQC2.Label {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            font: Kirigami.Theme.smallFont
            text: i18n("Pick an icon from your icon theme or an image file (PNG, SVG) to match the rest of your panel.")
        }

        QQC2.CheckBox {
            id: showBackgroundCheckBox

            Kirigami.FormData.label: i18n("Appearance:")
            text: i18n("Show button background")
        }

        QQC2.Label {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            font: Kirigami.Theme.smallFont
            text: i18n("When disabled, buttons look like plain panel icons and are highlighted only on hover.")
        }

        PercentSpinBox {
            id: lengthSpinBox

            Kirigami.FormData.label: i18n("Length:")
            from: 25
            to: 400
            stepSize: 5
        }

        PercentSpinBox {
            id: thicknessSpinBox

            Kirigami.FormData.label: i18n("Thickness:")
            from: 30
            to: 100
            stepSize: 5
        }

        QQC2.Label {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            font: Kirigami.Theme.smallFont
            text: i18n("Length is measured along the panel, thickness across it (as a share of the panel thickness). The mouse wheel works on the whole widget area.")
        }
    }
}
