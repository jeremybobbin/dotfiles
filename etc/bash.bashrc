#!/bin/bash
case $- in
	*i*) ;;
	*) return;;
esac

installed() {
	command -v "$1" > /dev/null 2>&1 || return 1
}

if [ "$0" = "/bin/bash" ] && [ -x "$HOME/.local/bin/bash" ]; then
	exec "$HOME/.local/bin/bash" "$@"
fi

# abduco/dvtm session
if installed abduco && [ -z "$ABDUCO_SESSION" ]; then
	if [ -z "$SSH_CLIENT" ]; then
		exec abduco -A local "${0#-}"
	else
		exec abduco -A remote "${0#-}"
	fi
fi

if installed dvtm && [ -z "$DVTM" ] && echo "$TERM" | grep -q '256color$'; then
	exec dvtm -c "$DVTM_CMD_FIFO" -s "$DVTM_STATUS_FIFO"
fi

PS1="$(ps1)"
TAB="$(printf '\t')"

stty -ixon # Disable ctrl-s and ctrl-q.
shopt -s autocd # Unknown command defaults to cd <command>
shopt -s direxpand
shopt -s expand_aliases
shopt -s extglob
shopt -s globstar
#shopt -s progcomp_alias

# Infinite history.
export HISTSIZE=2147483647
export HISTFILESIZE=ignoreboth:erasedups

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

mail_mode() {
	alias all='mlist ~/.mail/*/Inbox | thread | mseq -S'
	alias new='mlist -s ~/.mail/*/Inbox | full-thread ~/.mail/jer ~/.mail/lambda |
		mseq -S && mseq -C $ && mseq -f | mseq -S'
	alias v='mless' # view
	alias p='mscan | less' # preview
	alias d='mseq -r .= | grep "Inbox" | mflag -S | xargs rm && new'
}

no_mode() {
	unalias new all j k v p d
}

prompt_command() {
	LAST="$(history 1 | cut -c8-)"
	printf "\e]2;%s\a\e]1;%s\a" "$LAST" "$LAST"
}

PROMPT_COMMAND=prompt_command

alias o="$XDG_BIN_HOME/open"
alias la='/bin/ls --color=auto -ahN --group-directories-first'
alias lc='/bin/ls --color=always -hN --group-directories-first'
alias ll='/bin/ls --color=auto -lhN --group-directories-first'
alias ls='/bin/ls --color=auto --group-directories-first -hN'
alias lt='/bin/ls --color=auto -thN'
alias _='xargs'
alias rm='trash'
alias sp='. ~/.profile'
alias sbrc='. ~/.bashrc'
alias ebp='e ~/.bash_profile'
alias ebrc='e ~/.bashrc'
alias eirc='e ~/.inputrc'
alias ep='e ~/.profile'
alias evrc='e ~/.vimrc'
alias evrcd='e ~/.vim'
alias exp='e ~/.xprofile'
alias exrc='e ~/.xinitrc'
alias emrc='e ~/.config/neomutt/neomuttrc'
alias exhk='e ~/.config/sxhkd/sxhkdrc'
alias earc='e ~/.config/aliasrc'
alias sc='systemctl'
alias scu='systemctl --user'
alias scue='systemctl --user enable'
alias scur='systemctl --user restart'
alias ssc='sudo systemctl'
alias ssce='sudo systemctl enable'
alias sscr='sudo systemctl restart'
alias cb='xclip -selection c'
alias pcb='xclip -selection p'
alias scb='xclip -selection s'
alias cb='xclip -selection c'
alias pcb='xclip -selection p'
alias scb='xclip -selection s'
alias cbimg='xclip -selection c -t image -o'
alias pcbimg='xclip -selection p -t image -o'
alias scbimg='xclip -selection s -t image -o'
alias c2p='cb -o  | pcb'
alias c2s='cb -o  | scb'
alias p2c='pcb -o | cb'
alias p2s='pcb -o | scb'
alias s2c='pcb -o | cb'
alias s2p='pcb -o | pcb'
alias g='git'
alias se='sudo -E $EDITOR'
alias n='nnn'
alias z='zathura'
alias mk='make'
alias smki='sudo make install'
alias rh='runhaskell'
alias rec='ffmpeg -video_size 1920x1080 -framerate 20 -f x11grab -i :0.0+0,0 -f pulse -ac 2 -i default "$HOME/Media/Video/ScreenCast/$(date +%s).mp4"'
alias pm='pulsemixer'
alias catc='highlight --out-format=ansi '
alias diff='diff --color=auto'
alias diffc='/bin/diff --color=always'
alias grep='/bin/grep --color=auto '
alias grepc='/bin/grep --color=always '
alias ip='ip -c'
alias less='less -R'
alias pacman='pacman --color auto'
alias pacmanc='pacman --color always'
alias yay='yay --color=auto'
alias yayc='yay --color=always'
alias mpv='mpv --input-ipc-server="/tmp/mpv_$(date +%s%N)"'
alias note='v "~/Notes/Self/$(date +%F)"'
alias p8='ping 8.8.8.8'
alias p42='ping 4.2.2.2'
alias t8='traceroute 8.8.8.8'
alias t42='traceroute 4.2.2.2'
alias ipash='ip address show'
alias ipb='ip -br'
alias ipbash='ip -br address show'
alias ipblish='ip -br link show'
alias ipbrosh='ip link show'
alias iplish='ip link show'
alias iprosh='ip route show'
alias mutt='neomutt'
alias m='neomutt'
alias dpn='echo 6502886100'
alias ldpn='echo 6504795530'
alias vps='echo 45.77.215.144'
alias cch='cd ~/.cache'
alias cfg='cd ~/.config'
alias dl='cd ~/Downloads'
alias doc='cd ~/Media/Documents'
alias img='cd ~/Media/Images'
alias mda='cd ~/Media'
alias msc='cd ~/Media/Audio/Music'
alias nts='cd ~/Notes'
alias prj='cd ~/Projects'
alias ulb='cd ~/.local/bin'
alias uls='cd ~/.local/share'
alias vdo='cd ~/Media/Video'
