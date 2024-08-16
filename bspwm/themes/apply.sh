#!/usr/bin/env bash

# Theme applier - based on archcraft's (Aditya Shakya)

THEME="$1"
PATH_BSPWM="$HOME/.config/bspwm"
THEMEDIR="$PATH_BSPWM/themes/$THEME"
source "$THEMEDIR/theme.bash"

create_file() {
  theme_file="$PATH_BSPWM/themes/.current"
  if [[ -L "$theme_file" ]]; then
    rm "${theme_file}"
  fi
  ln -sf "${PATH_BSPWM}/themes/${THEME}" "${theme_file}"
}

terminal() {
  cat >"$THEMEDIR/kitty/fonts.conf" <<-_EOF_
font_family $terminal_font_name
font_size $terminal_font_size
_EOF_

  kitten themes --reload-in=all "$kitty_theme"
}

#nvim() {
#  # TODO: nvim
#  echo $nvim_colorscheme > "$HOME/.local/share/nvim/colorscheme-file"
#}

first_run() {
  if [[ ! -f "$THEMEDIR/ready" ]]; then
    "$PATH_BSPWM/themes/first-run.sh"
  fi
}

notify() {
  dunstify -u normal "Applying Style..."
}

notify
create_file
terminal
#nvim
first_run

bspc wm -r
