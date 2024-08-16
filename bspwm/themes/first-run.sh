#!/bin/env bash
# to be ran the first time after apply theme

# Source theme
THEMEDIR="$HOME/.config/bspwm/themes/.current"
PATH_ROFI="$THEMEDIR/rofi"
source ".current/theme.bash"

# Create file to not run this again
create_file() {
  if [[ ! -f "$THEMEDIR/ready}" ]]; then
    touch "$THEMEDIR/ready"
  else
    exit 1
  fi
}

## Apply
rofi() {
  border_color="$(pastel color $accent | pastel format rgb-float | tr -d '[:alpha:]','(',')' | sed 's/ /,/g')"
  altbackground="$(pastel color $background | pastel lighten $light_value | pastel format hex)"

  # modify screenshots scripts
  sed -i -e "s/border=.*/border='$border_color'/g" \
    "$THEMEDIR/scripts/rofi_screenshot" \
    "$THEMEDIR/scripts/bspscreenshot"

  # apply default theme fonts
  sed -i -e "s/font:.*/font: \"$rofi_font\";/g" "${PATH_ROFI}/shared/fonts.rasi"

  # rewrite colors file
  cat >"${PATH_ROFI}/shared/colors.rasi" <<-EOF
		* {
		    background:     ${background};
		    background-alt: ${altbackground};
		    foreground:     ${foreground};
		    selected:       ${accent};
		    active:         ${color2};
		    urgent:         ${color1};
		}
	EOF
}

dunst() {
  # modify dunst config
  sed -i "${THEMEDIR}/dunstrc" \
    -e "s/width = .*/width = $dunst_width/g" \
    -e "s/height = .*/height = $dunst_height/g" \
    -e "s/offset = .*/offset = $dunst_offset/g" \
    -e "s/origin = .*/origin = $dunst_origin/g" \
    -e "s/font = .*/font = $dunst_font/g" \
    -e "s/frame_width = .*/frame_width = $dunst_border/g" \
    -e "s/separator_height = .*/separator_height = $dunst_separator/g" \
    -e "s/line_height = .*/line_height = $dunst_separator/g"

  # modify colors
  sed -i '/urgency_low/Q' "${THEMEDIR}/dunstrc"
  cat >>"${THEMEDIR}/dunstrc" <<-_EOF_
		[urgency_low]
		timeout = 2
		background = "${background}"
		foreground = "${foreground}"
		frame_color = "${accent}"

		[urgency_normal]
		timeout = 5
		background = "${background}"
		foreground = "${foreground}"
		frame_color = "${accent}"

		[urgency_critical]
		timeout = 0
		background = "${background}"
		foreground = "${color1}"
		frame_color = "${color1}"
	_EOF_
}

create_file
rofi
dunst
