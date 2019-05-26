#!/bin/sh
echo $- | grep -v 'i' && return

source_globals
source_aliases

PS1=$(ps1)
export PS1

# Disable ctrl-s and ctrl-q.
stty -ixon

# Unknown command defaults to cd <command>
shopt -s autocd 

# Infinite history.
HISTSIZE= HISTFILESIZE=

# Sources tab delimited aliases
#source <(cat "$XDG_CONFIG_HOME/aliasrc" | sed -E "/^$/d; /#.*$/d; s/([^ \t]+)[ \t]+(.*)/alias \1='\2'/g")

# if root, or if SUID bit is set, run loadkeys, else run as sudo
if [ -x /bin/loadkeys ]; then
	loadkeys "$XDG_CONFIG_HOME/ttymaps.kmap"
else
	sudo auto_loadkeys "$USER"
fi
