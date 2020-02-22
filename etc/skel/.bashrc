#!/bin/bash
case $- in
	*i*) ;;
	*) return;;
esac

# EDITOR could be vim or nvim
if command -v "$EDITOR" &>/dev/null && [ -z "$VIMRUNTIME" ]; then
	[ "$EDITOR" = 'nvim' ] && exec "$EDITOR" -c ':terminal'
	[ "$EDITOR" = 'vim'  ] && exec "$EDITOR" --servername "$$" -c ':terminal ++curwin'
	for cmd in e vsp Explore; do
		alias $cmd="vimctl -e $cmd"
	done
fi


cd() {
	builtin cd "$@" || return 1
	vimctl -e "cd $@" || :
}

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

if  command -v ssh-agent 2> /dev/null && ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent | sed -E '/^echo/d' > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi

if [ -r '/etc/bash_completion' ]; then
	. /etc/bash_completion
fi

if [ ! "$SSH_AUTH_SOCK" ]; then
    . "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
