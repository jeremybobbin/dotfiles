#!/bin/bash
case $- in
	*i*) ;;
	*) return;;
esac

installed() {
	for p; do
		command -v "$p" > /dev/null 2>&1 || return 1
	done
}

# abduco/dvtm session
if installed abduco dvtm && [ -z "$ABDUCO_SESSION" ] && [ -z "$DVTM" ]; then
	if [ -z "$SSH_CILENT" ] ; then
		exec abduco -A dvtm-session dvtm -c "$DVTM_CMD_FIFO" -s "$DVTM_STATUS_FIFO"
	elif [ -n "$FORCE_DVTM"]; then
		exec abduco -A dvtm-ssh-session dvtm -c "$DVTM_CMD_FIFO" -s "$DVTM_STATUS_FIFO"
	else
		exec abduco -A ssh-session
	fi
fi

PS1="$(ps1)"
TAB="$(printf '\t')"
eval "$(sed -E "/^$/d; /#.*$/d; s/([^ $TAB]+)[ $TAB]+(.*)/alias \1='\2'/g" "$XDG_CONFIG_HOME/aliasrc")"

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

if installed ssh-agent && ! pgrep -u "$USER" ssh-agent > /dev/null 2>&1; then
	ssh-agent | sed -E '/^echo/d' > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi

if [ -r '/usr/share/bash_completion' ]; then
	. /usr/share/bash-completion/bash_completion
fi

if [ ! "$SSH_AUTH_SOCK" ]; then
	. "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
