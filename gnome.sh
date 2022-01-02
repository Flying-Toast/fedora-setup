#!/bin/bash

# terminal
TERM_BASE="/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "[='=]")"
dconf write $TERM_BASE/default-size-columns 84
dconf write $TERM_BASE/use-system-font false
dconf write $TERM_BASE/font "'DejaVu Sans Mono 12'"
dconf write $TERM_BASE/audible-bell false
dconf write $TERM_BASE/scrollbar-policy "'never'"
dconf write $TERM_BASE/use-theme-colors false
dconf write $TERM_BASE/foreground-color "'#d0d0d0'"
dconf write $TERM_BASE/background-color "'#151515'"
dconf write $TERM_BASE/palette "['#151515', '#ac4142', '#90a959', '#f4bf75', '#6a9fb5', '#aa759f', '#75b5aa', '#d0d0d0', '#505050', '#d28445', '#202020', '#303030', '#b0b0b0', '#e0e0e0', '#8f5536', '#f5f5f5']"

# tweaks
dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita-dark'"
dconf write /org/gnome/shell/enabled-extensions "['launch-new-instance@gnome-shell-extensions.gcampax.github.com']"
dconf write /org/gnome/desktop/input-sources/xkb-options "['lv3:ralt_switch', 'caps:escape']"
dconf write /org/gnome/desktop/interface/enable-hot-corners false
dconf write /org/gnome/desktop/peripherals/touchpad/click-method "'areas'"

# gnome settings
dconf write /org/gnome/desktop/search-providers/disabled "['org.gnome.Software.desktop']"
dconf write /org/gnome/desktop/privacy/remember-recent-files false
dconf write /org/gnome/desktop/privacy/recent-files-max-age 1
dconf write /org/gnome/settings-daemon/plugins/media-keys/home "['<Super>e']"
dconf write /org/gnome/desktop/wm/keybindings/switch-applications "@as []"
dconf write /org/gnome/desktop/wm/keybindings/switch-applications-backward "@as []"
dconf write /org/gnome/desktop/wm/keybindings/switch-windows "['<Alt>Tab']"
dconf write /org/gnome/desktop/wm/keybindings/switch-windows-backward "['<Shift><Alt>Tab']"
dconf write /org/gnome/settings-daemon/plugins/media-keys/window-screenshot-clip "@as []"
dconf write /org/gnome/settings-daemon/plugins/media-keys/area-screenshot-clip "@as []"
dconf write /org/gnome/settings-daemon/plugins/media-keys/screenshot-clip "@as []"
dconf write /org/gnome/settings-daemon/plugins/media-keys/window-screenshot "@as []"
dconf write /org/gnome/settings-daemon/plugins/media-keys/area-screenshot "@as []"
dconf write /org/gnome/settings-daemon/plugins/media-keys/screenshot "@as []"
dconf write /org/gnome/desktop/wm/keybindings/show-desktop "['<Super>d']"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding "'<Primary><Alt>t'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command "'gnome-terminal'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name "'Terminal'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
dconf write /org/gnome/settings-daemon/plugins/color/night-light-enabled true
dconf write /org/gnome/settings-daemon/plugins/color/night-light-temperature "uint32 3873"
dconf write /org/gnome/shell/favorite-apps "@as []"
dconf write /org/gnome/desktop/peripherals/touchpad/tap-to-click true
dconf write /org/gtk/settings/file-chooser/clock-format "'12h'"
dconf write /org/gnome/desktop/interface/clock-format "'12h'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/max-screencast-length "uint32 0"

# geary
dconf write /org/gnome/Geary/autoselect false
dconf write /org/gnome/Geary/startup-notifications true

# other
dconf write /org/gnome/nautilus/icon-view/default-zoom-level "'standard'"
dconf write /org/gtk/settings/file-chooser/sort-directories-first true
dconf write /org/gnome/gnome-screenshot/last-save-directory "'file://$HOME/workspace'"
dconf write /org/gnome/desktop/notifications/show-in-lock-screen false
