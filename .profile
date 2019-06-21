#!/bin/sh

COLORS_TTY=$XDG_CACHE_HOME/wal/colors-tty.sh

set -a
PATH=/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$HOME/.local/bin

XDG_CONFIG_HOME="$HOME/.config"
XDG_CACHE_HOME="$HOME/.cache"
XDG_DATA_HOME="$HOME/.local/share"
XDG_BIN_HOME="$HOME/.local/bin"
XDG_DATA_DIRS="$XDG_DATA_HOME:/usr/local/share/:/usr/share/"
XDG_CONFIG_DIRS="/etc/xdg"

TERMINAL="st"
EDITOR="nvim"
BROWSER="surf"
PDF_VIEWER="zathura"
AUDIO_PLAYER="mpv"
VIDEO_PLAYER="mpv"
EMAIL_CLIENT="mutt"
HOME_PAGE="https://www.google.com"

BLUETOOTH_DEVICE="AirPods"

RUSTC_WRAPPER="sccache"
CARGO_CFG_COLOR="always"
RUST_SRC_PATH=`/usr/bin/rustc --print sysroot`/lib/rustlib/src/rust/src/

PATH=`path`

[ -r "$COLORS_TTY" ] && source "$COLORS_TTY"

set +a

if [ ! "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ] && [ ! -r "/tmp/no_x" ] && [ -x "/bin/startx" ]; then
	exec startx
fi

if echo "$0" | grep bash > /dev/null && [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
fi
