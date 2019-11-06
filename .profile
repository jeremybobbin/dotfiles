#!/bin/sh


COLORS_TTY=$XDG_CACHE_HOME/wal/colors-tty.sh

appendpath() {
	case ":$PATH:" in
		*:"$1":*)
			;;
		*)
			PATH="${PATH:+$PATH:}$1"
	esac
}

is_tty() {
	case "$(tty)" in
		/dev/tty*) return 0;;
		*) return 1
	esac
}


set -a
XDG_CONFIG_HOME="$HOME/.config"
XDG_CACHE_HOME="$HOME/.cache"
XDG_DATA_HOME="$HOME/.local/share"
XDG_BIN_HOME="$HOME/.local/bin"
XDG_DATA_DIRS="$XDG_DATA_HOME:/usr/local/share/:/usr/share/"
XDG_CONFIG_DIRS='/etc/xdg'

AUDIO_PLAYER='mpv'
MUSIC_PLAYER='ncmpcpp'
IRC_CLIENT='weechat'
BROWSER='surf'
EDITOR='nvim'
EMAIL_CLIENT='neomutt'
PDF_VIEWER='zathura'
TERMINAL='st'
TERM=$TERMINAL
VIDEO_PLAYER='mpv'

HOME_PAGE='https://www.google.com'
BLUETOOTH_DEVICE='AirPods'

RUSTC_WRAPPER=""
CARGO_CFG_COLOR='always'
RUST_SRC_PATH="$(/usr/bin/rustc --print sysroot)/lib/rustlib/src/rust/src/"

TZ='US/Pacific'
_JAVA_AWT_WM_NONREPARENTING=1

[ -r "$COLORS_TTY" ] && . "$COLORS_TTY"

if [ "$XDG_CONFIG_HOME/pathrc" -nt "$XDG_CACHE_HOME/jeros/path" ]; then
	appendpath "$XDG_BIN_HOME"
	for path in $(envsubst < "$XDG_CONFIG_HOME/pathrc")
	do
		appendpath "$path"
	done
	echo "$PATH" > $XDG_CACHE_HOME/jeros/path
else
	PATH=$(cat $XDG_CACHE_HOME/jeros/path)
fi
set +a


if echo "$0" | grep bash > /dev/null && [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
fi

if [ ! "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ] && [ "$(tty)" = "/dev/tty1" ] && [ -x "/usr/bin/startx" ]; then
	exec startx
elif is_tty; then
	remap tty
fi
