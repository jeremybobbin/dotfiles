#!/bin/sh
echo $- | grep -v 'i' && return

jump() {
	cd "$(command jump "$@")" ||
		return 1
}

playtime() {
	# Prevents something
	cd / ||
		return 1
	sauce command playtime "$@"
}

sauce() {
	local pipe=$(mktemp -u)
	mkfifo "$pipe"
	(eval "$@" > "$pipe" &)
	. "$pipe"
	command rm -R "$pipe"
}

source_aliases() {
	local rc="$XDG_CONFIG_HOME/aliasrc"
	sauce "cat $rc | sed -E '/^$/d; /#.*$/d; s/([^ \t]+)[ \t]+(.*)/alias \1='\''\2'\''/g'"
}

PS1=$(ps1)
source_aliases
stty -ixon # Disable ctrl-s and ctrl-q.
shopt -s autocd # Unknown command defaults to cd <command>
HISTSIZE= HISTFILESIZE= # Infinite history.

# if root, or if SUID bit is set, run loadkeys, else run as sudo
#if [ -x /bin/loadkeys ]; then
	#loadkeys "$XDG_CONFIG_HOME/ttymaps.kmap"
#else
	#sudo auto_loadkeys "$USER"
#fi
