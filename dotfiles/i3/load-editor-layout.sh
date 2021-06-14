#!/usr/bin/env bash

set -o pipefail
set -o xtrace
set -o errexit

dir="$(
  zoxide query --list --score \
    | rofi -dmenu -p 'dir' -no-custom \
    | sed -E 's/^ *[0-9]+ +(.*)$/\1/g'
)"

i3-msg "append_layout $EDITOR_LAYOUT_JSON"

kitty --directory "$dir" --detach --class kitty-top &
kitty --directory "$dir" --detach --class kitty-bottom &
kitty --directory "$dir" --detach --class kitty-left &
wait
i3-msg '[class="kitty-left"] focus'
