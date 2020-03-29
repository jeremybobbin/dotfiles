#!/bin/sh
# Dotfile todos:
#TODO Deployment method: curl jer.cx/deploy | sh
#	1. creates user "jer" as (wheel/sudo/adm)
#	2. prompts for password
#	3. installs dependencies
#	4. (optionally) adds machine to VPN
#TODO Source script: curl jer.cx/source | sh
#	1. installs dependencies
#	2. binds keys
#TODO Logging
#TODO Configure XDG-Open
#TODO URL Preparser for XDG-Open(foo.org/bar.pdf -> curl $URL | $PDF_VIEWER -)
#TODO Get rid of 'subcommand' OR turn it into a compiler
#TODO Jewish conspiracy
#TODO Bash tab-complete for 'subcommand' dependents
#TODO Move all scripts to ~/.local/src


prependpath() {
	for i in $*; do
		case ":$PATH:" in
			*:"$i":*) ;;
			*) PATH=$i${PATH+":$PATH"};;
		esac
	done
}

isatty() {
	case "$(tty)" in
		/dev/tty*) return 0;;
		*) return 1
	esac
}


set -a
XDG_BIN_HOME="$HOME/.local/bin"
XDG_CACHE_HOME="$HOME/.cache"
XDG_CONFIG_DIRS='/etc/xdg'
XDG_CONFIG_HOME="$HOME/.config"
XDG_DATA_DIRS="$XDG_DATA_HOME:/usr/local/share/:/usr/share/"
XDG_DATA_HOME="$HOME/.local/share"

AUDIO_PLAYER='mpv'
BROWSER='surf'
EDITOR='nvim'
EMAIL_CLIENT='neomutt'
IRC_CLIENT='weechat'
MUSIC_PLAYER='ncmpcpp'
PDF_VIEWER='zathura'
TERMINAL='st'

BLUETOOTH_DEVICE='AirPods'
DEFAULT_MAILBOX='lambda'
HOME_PAGE='https://www.google.com'
TERM=$TERMINAL
VIDEO_PLAYER='mpv'

DVTM_CMD_FIFO="$(mktemp -u)"
DVTM_STATUS_FIFO="$(mktemp -u)"
DWM_CMD_FIFO="$(mktemp -u)"
DWM_STATUS_FIFO="$(mktemp -u)"

TZ='US/Pacific'
_JAVA_AWT_WM_NONREPARENTING=1

CARGO_CFG_COLOR='always'
RUSTC_WRAPPER=""

COLORS_TTY=$XDG_CACHE_HOME/wal/colors-tty.sh

[ -x '/usr/bin/rustc' ] &&
	RUST_SRC_PATH="$(/usr/bin/rustc --print sysroot)/lib/rustlib/src/rust/src/"

[ -r "$COLORS_TTY" ] && . "$COLORS_TTY"

prependpath "
/usr/bin/
/usr/sbin/
/usr/local/bin
/usr/local/sbin
$HOME/.yarn/bin
$HOME/.cargo/bin
$HOME/.local/bin
/tmp/bin
"

set +a

if [ ! "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ] && [ "$(tty)" = "/dev/tty1" ] && [ -x "/usr/bin/startx" ]; then
	exec startx
elif isatty; then
	remap tty
fi

case "$0" in
	*bash) . ~/.bashrc;;
esac
