[[ $- != *i* ]] && return

if [[ -z $SSH_CLIENT ]]
then
	export PS1="\[$(tput bold)\]\[$(tput setaf 8)\][\[$(tput setaf 2)\]\u\[$(tput setaf 8)\]@\[$(tput setaf 6)\]\h \[$(tput setaf 1)\]\W\[$(tput setaf 8)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"
else
	export PS1="\[$(tput bold)\]\[$(tput setaf 8)\][\[$(tput setaf 2)\]\u\[$(tput setaf 8)\]@\[$(tput setaf 2)\]\h \[$(tput setaf 1)\]\W\[$(tput setaf 8)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"
fi


export EDITOR='vim'
export BROWSER='qutebrowser'
export PDF_VIEWER='zathura'
export AUDIO_PLAYER='ffmpeg'
export VIDEO_PLAYER='ffmpeg'


# For manage dot files via git. Explicitly placed outside .bashrc.d/res/aliases
# alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Disable ctrl-s and ctrl-q.
stty -ixon

# Unknown command defaults to cd
shopt -s autocd 

# Infinite history.
HISTSIZE= HISTFILESIZE= 

# Vi bindings
set -o vi

PATH=$PATH:$HOME/.bin:$HOME/.cargo/bin:/tmp/bin:$HOME/.yarn/bin

# Sources tab delimited aliases
source <(cat ~/.bashrc.d/res/aliases | sed -E "/^#/d; /^$/d; s/([^ \t]+)[ \t]+(.*)/alias \1='\2'/g")

# Can this be done async? `. ~/.bashrc` takes .5 seconds at most.
source <(cat ~/.bashrc.d/* /usr/share/bash-completion/*/* 2> /dev/null) 2> /dev/null


function cb2png {
	cb -t image/png -o > $1.png
}

# Clones suckless repos: `suck st dwm`
function suck {
	url='https://git.suckless.org'
	for repo in $@; do
		git clone "$url/$repo"
	done
}


into_mp3() {
	o=$(echo "$1" | sed -E 's/(.*)\..*/\1/')
	ffmpeg -i $1 "$o.mp3"
	rm $1
}

# if root, or if SUID bit is set, run loadkeys, else run as sudo
if [[ -x /bin/loadkeys && ($UID -eq 0 || -u /bin/loadkeys) ]]; then
	loadkeys ~/.bashrc.d/res/ttymaps.kmap
else
	sudo groupadd -f loadkeys
	sudo gpasswd loadkeys -a $USER
	sudo chgrp loadkeys /bin/loadkeys
	sudo chmod 4750 /bin/loadkeys
	sudo loadkeys ~/.bashrc.d/res/ttymaps.kmap
fi
