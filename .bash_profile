[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 && ! -r /tmp/no_x && -x /bin/startx ]]; then
	exec startx
fi
