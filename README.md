# Karousel Scroller

A KDE Plasma 6 panel widget to scroll the [Karousel](https://github.com/peterfajdiga/karousel) tiling grid, Pager style.

| Control | Action |
| --- | --- |
| Left / right arrow click | Scroll left / right (hold to keep scrolling) |
| Center dot click | Center the focused window |
| Mouse wheel down / up | Scroll left / right |

**Compact mode** (optional): a single icon. The mouse wheel scrolls, a click centers the focused window.

**Settings:** scroll speed multiplier (default `1.0`, range `0.1` to `10`). It sets how many Karousel
scroll steps are triggered per wheel notch or per click. The size of a single step is Karousel's own
"manual scroll step" setting. The mouse wheel direction can be inverted (arrow buttons are not affected).
The widget length (along the panel, 25% to 400%) and thickness (across the panel, 30% to 100%) are
configurable.

## Requirements

- KDE Plasma 6
- [Karousel](https://github.com/peterfajdiga/karousel) installed and enabled as a KWin script

## Installation

**From the KDE Store:** right click on the panel > *Add Widgets* > *Get New Widgets*, search for
"Karousel Scroller".

**From a release:** download the `.plasmoid` file from the
[releases page](https://github.com/friimaind/karousel-scroller/releases), then:

    kpackagetool6 -t Plasma/Applet -i karousel-scroller-<version>.plasmoid

**From source:**

    git clone https://github.com/friimaind/karousel-scroller.git
    kpackagetool6 -t Plasma/Applet -i karousel-scroller

## How it works

The widget invokes Karousel's KWin global shortcuts over D-Bus (`org.kde.kglobalaccel`):

- `karousel-grid-scroll-left`
- `karousel-grid-scroll-right`
- `karousel-grid-scroll-focused`

If the widget does nothing, check that Karousel responds to the same call:

    dbus-send --session --type=method_call --dest=org.kde.kglobalaccel /component/kwin \
      org.kde.kglobalaccel.Component.invokeShortcut string:karousel-grid-scroll-right

## Development

Update an installed copy after changing the code:

    kpackagetool6 -t Plasma/Applet -u .
    systemctl --user restart plasma-plasmashell

Run it in a standalone window to see QML errors:

    plasmawindowed friimaind.karouselscroller

## Releasing

1. Bump `KPlugin.Version` in `metadata.json`.
2. Build the package: `./scripts/build-plasmoid.sh` (output in `dist/`).
3. Create a GitHub release and attach the `.plasmoid` file.
4. Upload the same `.plasmoid` to the KDE Store product page.

## License

[GPL-3.0](LICENSE)
