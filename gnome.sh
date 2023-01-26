#!/bin/bash

# gnome extensions:
ENABLED_EXTENSIONS="'launch-new-instance@gnome-shell-extensions.gcampax.github.com'" # comma separated
mkdir -p ~/.local/share/gnome-shell/extensions
for EXTENSION in $(ls ./gnome-extensions/)
do
	cp -r ./gnome-extensions/$EXTENSION ~/.local/share/gnome-shell/extensions/
	ENABLED_EXTENSIONS="$ENABLED_EXTENSIONS,'$EXTENSION'"
done
dconf write /org/gnome/shell/enabled-extensions "[$ENABLED_EXTENSIONS]"

# wallpaper
WALLPAPER_NAME="onedark.png"
cp wallpaper/$WALLPAPER_NAME ~/Pictures
dconf write /org/gnome/desktop/background/picture-uri "'file://$HOME/Pictures/$WALLPAPER_NAME'"
dconf write /org/gnome/desktop/background/picture-uri-dark "'file://$HOME/Pictures/$WALLPAPER_NAME'"
dconf write /org/gnome/desktop/screensaver/picture-uri "'file://$HOME/Pictures/$WALLPAPER_NAME'"

# terminal
TERM_BASE="/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "[='=]")"
dconf write $TERM_BASE/use-system-font false
dconf write $TERM_BASE/font "'DejaVu Sans Mono 12'"
dconf write $TERM_BASE/audible-bell false
dconf write $TERM_BASE/scrollbar-policy "'never'"
dconf write $TERM_BASE/use-theme-colors false
dconf write $TERM_BASE/foreground-color "'#ABB2BF'"
dconf write $TERM_BASE/background-color "'#282C34'"
dconf write $TERM_BASE/palette "['rgb(92,99,112)', 'rgb(224,108,117)', 'rgb(152,195,121)', 'rgb(209,154,102)', 'rgb(97,175,239)', 'rgb(198,120,221)', 'rgb(86,182,194)', 'rgb(171,178,191)', 'rgb(92,99,112)', 'rgb(224,108,117)', 'rgb(152,195,121)', 'rgb(209,154,102)', 'rgb(97,175,239)', 'rgb(198,120,221)', 'rgb(86,182,194)', 'rgb(171,178,191)']"

# tweaks
dconf write /org/gnome/desktop/input-sources/xkb-options "['lv3:ralt_switch', 'caps:escape']"
dconf write /org/gnome/desktop/interface/enable-hot-corners false
dconf write /org/gnome/desktop/peripherals/touchpad/click-method "'areas'"

# gnome settings
dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
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
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/binding "'<Primary><Shift><Alt>t'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/command "'gnome-terminal --full-screen --working-directory=workspace'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/name "'Fullscreen Terminal'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding "'<Primary><Alt>t'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command "'gnome-terminal --working-directory=workspace'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name "'Terminal'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"
dconf write /org/gnome/settings-daemon/plugins/media-keys/www "['<Super>f']"
dconf write /org/gnome/settings-daemon/plugins/media-keys/email "['<Super>g']"
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
dconf write /desktop/ibus/panel/emoji/unicode-hotkey "@as []"
dconf write /desktop/ibus/panel/emoji/hotkey "@as []"
