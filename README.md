# Karousel Scroller

Plasma 6 panel widget that scrolls the Karousel grid left/right.

- Click left/right arrow: scroll left/right (hold to keep scrolling)
- Click center dot: center the focused window (`karousel-grid-scroll-focused`)
- Mouse wheel down: scroll left, wheel up: scroll right
- Settings: scroll speed multiplier (default 1.0, range 0.1 to 10)

It invokes Karousel's KWin shortcuts `karousel-grid-scroll-left` / `karousel-grid-scroll-right`
via D-Bus (`org.kde.kglobalaccel`). Step size is Karousel's "manual scroll step" setting.

## Install / update

    kpackagetool6 -t Plasma/Applet -i karousel-scroller   # first install
    kpackagetool6 -t Plasma/Applet -u karousel-scroller   # update
    systemctl --user restart plasma-plasmashell           # reload after update

## Test the D-Bus call manually

    dbus-send --session --type=method_call --dest=org.kde.kglobalaccel /component/kwin \
      org.kde.kglobalaccel.Component.invokeShortcut string:karousel-grid-scroll-right
