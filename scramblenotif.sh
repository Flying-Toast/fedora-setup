#!/bin/bash

NEXTPATH="$HOME/.local/share/scramble_notif/next_scramble"

savescram() {
	java -jar ~/.local/share/scramble_notif/tnoodle-cli.jar scramble > "$NEXTPATH"
}

if [ ! -f "$NEXTPATH" ]
then
	savescram
fi

notify-send -a "3x3 scramble" "$(cat "$NEXTPATH")" -u critical
rm "$NEXTPATH"
savescram
