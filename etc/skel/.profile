#!/bin/sh
# Dotfile todos:
#TODO Deployment method: `curl jer.sh/deploy | sh`
#TODO `curl jer.sh/root | sh`
#	1. creates user "jer" as (wheel/sudo/adm)
#	2. (optionally) adds machine to VPN
#
#TODO `curl jer.sh/basic | sh` - binds keys, sets locale & environment
#TODO Logging
#TODO Jewish conspiracy
#TODO Bash tab-completion for bins/*
#TODO Standardize options & help menu for bins/*
#	Issues: say we want to update all initcpio's with Debian's `update-initramfs`
#		- "Standard":  update-initramfs -u -k all
#		- GNU:         update-initramfs -ukall
#		- Long Opts:   update-initramfs --update --kernal all
#
#TODO pdksh: Implement tab-completion
#TODO netbsd-ncurses: rebase with upstream
#TODO src: +noemutt, isync, msmtp
#TODO src: +ubase
#TODO NeoMutt: replace tcl configure scripts with sh
#TODO NeoMutt: swap out file browser with $FILEBROWSER
#TODO NeoMutt: consider swapping configuration with Lua
#TODO Lua: reimplement parser in (Berkley)YACC(like it once was)
#TODO src: +byacc, maybe also bsdmake
#TODO give var/lib/overrides/* a POSIX-complient PKGBUILD style
#TODO "Plan9 plumbing"-like alternative(or frontend) to XDG-Open
#TODO {consume,produce} should pass around file paths(potentially also URLs)
#TODO DVTM: port src/st/st.c to src/dvtm/vt.c for better rendering
#TODO sbase: `cp -af sl1 sl2`(sl[12] point to the same file) should not err
#TODO vis: vis-surround
#TODO vis: client-server architecture
#TODO deploy: rename to pkj(packajer)
#TODO pkj: only install {st,dmenu,dwm,surf} if Xlib is installed
#TODO compile all dependencies with TCC
#TODO support/orders: not extensible - it should just be a frontend for curl & jq


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
LD_LIBRARY_PATH="$HOME/.local/lib"

XDG_BIN_HOME="$HOME/.local/bin"
XDG_CACHE_HOME="$HOME/.cache"
XDG_CONFIG_DIRS='/etc/xdg'
XDG_CONFIG_HOME="$HOME/.config"
XDG_DATA_DIRS="$XDG_DATA_HOME:/usr/local/share/:/usr/share/"
XDG_DATA_HOME="$HOME/.local/share"

AUDIO_PLAYER='mpv'
BROWSER='surf'
EDITOR='vis'
EMAIL_CLIENT='neomutt'
FILE_BROWSER='nnn'
IRC_CLIENT='weechat'
MUSIC_PLAYER='ncmpcpp'
PDF_VIEWER='zathura'
TERMINAL='st'

BLUETOOTH_DEVICE='AirPods'
DEFAULT_MAILBOX='lambda'
HOME_PAGE='https://www.google.com'
TERM=xterm-256color
VIDEO_PLAYER='mpv'

CARGO_CFG_COLOR='always'
ESCDELAY=0
_JAVA_AWT_WM_NONREPARENTING=1
RUSTC_WRAPPER=""
TZ='US/Pacific'

DVTM_CMD_FIFO="$(mktemp -u)"
DVTM_STATUS_FIFO="$(mktemp -u)"
DWM_CMD_FIFO="$(mktemp -u)"
DWM_STATUS_FIFO="$(mktemp -u)"

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
	LD_BACKUP="$LD_LIBRARY_PATH" exec startx
elif isatty; then
	remap tty
fi

case "$0" in
	*bash) . ~/.bashrc;;
esac
