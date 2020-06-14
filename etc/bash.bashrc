#!/bin/bash
case $- in
	*i*) ;;
	*) return;;
esac

installed() {
	command -v "$p" > /dev/null 2>&1 || return 1
}

if [ "$0" = "/bin/bash" ] && [ -x "$HOME/.local/bin/bash" ]; then
	exec "$HOME/.local/bin/bash" "$@"
fi

# abduco/dvtm session
if installed abduco && [ -z "$ABDUCO_SESSION" ]; then
	if [ -z "$SSH_CLIENT" ]; then
		exec abduco -A local $0
	else
		exec abduco -A remote $0
	fi
fi

if installed dvtm && [ -z "$DVTM" ]; then
	exec dvtm -c "$DVTM_CMD_FIFO" -s "$DVTM_STATUS_FIFO"
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

if [ -r '/usr/share/bash-completion' ]; then
	. /usr/share/bash-completion/bash_completion
fi

if [ ! "$SSH_AUTH_SOCK" ]; then
	. "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
