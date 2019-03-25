[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 && ! -r /tmp/no_x ]]; then
	exec startx
fi
