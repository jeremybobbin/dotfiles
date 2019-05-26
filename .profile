#!/bin/sh

# Functions in .profile aren't exported by default, enter 'set -a'
set -a
# Posix compiliant sourcing abstraction
sauce() {
	pipe=/tmp/$(awk 'BEGIN { print int(srand() * rand() * srand()) }')
	mkfifo "$pipe"
	(eval "$@" > "$pipe" &)
	. "$pipe"
	command rm "$pipe"
}

# Intialize environment
source_globals() {

	[ "$XDG_CONFIG_HOME" ] ||
		XDG_CONFIG_HOME="$HOME/.config"

	rc="$XDG_CONFIG_HOME/globalsrc"

	sauce "cat $rc | 
		envsubst |
		sed -E '
			/$^/d;
			/#.*$/d;
			s/([^ \t]+)[ \t]+(.*)/export \1=\"\2\"/g'"
}

source_aliases() {
	rc="$XDG_CONFIG_HOME/aliasrc"
	sauce "cat $rc | sed -E '/^$/d; /#.*$/d; s/([^ \t]+)[ \t]+(.*)/alias \1='\''\2'\''/g'"
	# source <(cat "$XDG_CONFIG_HOME/aliasrc" | sed -E "/^$/d; /#.*$/d; s/([^ \t]+)[ \t]+(.*)/alias \1='\2'/g")
	unset rc
}

PATH=/usr/bin

[ "$XDG_CONFIG_HOME" ] ||
	XDG_CONFIG_HOME="$HOME/.config"

source_globals 

if echo "$0" | grep bash > /dev/null && [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
else
	source_aliases
fi

# Done initializing

jump() {
	cd "$(command jump "$@")" ||
		return 1
}

playtime() {
	sauce command playtime "$@"
}

if [ ! "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ] && [ ! -r "/tmp/no_x" ] && [ -x "/bin/startx" ]; then
	exec startx
fi

set +a
