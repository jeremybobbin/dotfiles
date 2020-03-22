#!/bin/bash
case $- in
	*i*) ;;
	*) return;;
esac

# EDITOR could be vim or nvim
if command -v dvtm > /dev/null 2>&1 && command -v abduco > /dev/null 2>&1; then
	if [ -z "$ABDUCO_SESSION" ] && [ -z "$DVTM" ]; then
		exec abduco -A dvtm-session dvtm -s "$DVTM_STATUS_FIFO"
	fi
fi


jump() {
	cd "$(command jump "$@")" ||
		return 1
}

playtime() {
	cd / || return 1
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
shopt -s direxpand
shopt -s expand_aliases
shopt -s extglob
shopt -s globstar
#shopt -s progcomp_alias


 # Infinite history.
export HISTSIZE=
export HISTFILESIZE=

# But ignore commands prefixed with a ' '
export HISTCONTROL="ignorespace${HISTCONTROL:+:$HISTCONTROL}"

if (command -v ssh-agent && ! pgrep -u "$USER" ssh-agent) > /dev/null 2>&1 ; then
    ssh-agent | sed -E '/^echo/d' > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi

if [ -r '/etc/bash_completion' ]; then
	. /etc/bash_completion
fi

if [ ! "$SSH_AUTH_SOCK" ]; then
    . "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
