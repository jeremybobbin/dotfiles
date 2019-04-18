# pgrep processes into top
pgtop() {
	local top_args=$(pgrep "$@"  | awk '{ print "-p " $1 }' || exit 1)
	if [[ $top_args ]] ; then
		top $top_args
	else
		echo "No matches" >&2
	fi
}

# universal open
open() {
	if [[ -z $1 ]]; then
		echo "Can't open null" >&2
		return 1
	fi

	# if it's a directory just cd.
	if [[ -d $1 ]]; then
		cd $1
		clear && ls
		return 0
	fi

	local ext=${1##*.}

	local cmd

	# if $ext = $1 then there is no extension. Let's assume it's text.
	if [[ $ext == $1 ]]; then
		cmd=$EDITOR
	else
		eval cmd=\$$(grep $ext $HOME/.bashrc.d/res/openers | tr '\t' ' ' | cut -d' ' -f1)
	fi
	if [[ -z $cmd ]]; then
		echo "Protocol not found for '$1'." >&2
		return 1
	fi
	eval $cmd $@
}

jump() {
	cd $(command jump $@)
}

playtime() {
	lang=${1-'rust'}
	name="${lang}_playtime"
	path="/tmp/$name"
	to_edit=''
	cd $HOME
	rm $path
	case "$lang" in
		'rust' | '' )
			mkdir -p $path
			cargo init $path
			to_edit='src/main.rs'
			;;
		'bash' )
			mkdir -p $path
			echo -e "#!/bin/bash\n" > "$path/script"
			chmod +x "$path/script"
			to_edit="$path/script"
			;;
		'node' )
			mkdir -p $path
			echo -e "#!/bin/env node\n" > "$path/index.js"
			chmod +x "$path/index.js"
			to_edit="$path/index.js"
			;;

		'c' )
			mkdir -p $path
			echo -e "#include <string.h>\n#include <stdio.h>\n#include <unistd.h>" > "$path/main.c"
			to_edit="$path/main.c"
			;;
		* )
			echo "Could not find protocol for '$1'." >&2
			return 0
			;;
	esac
	cd $path

	$EDITOR $to_edit
}

recurse() {
	echo $@ | xargs -I{} find {} -type d -not -path '*/\.*' | tr '\n' ':' | sed -e 's/:$//'
}


to_last() {
	command cd $(cat /tmp/cd_func)
}


# Helper functions
ife() {
	[ -f $1 ] && echo $1 && return 0 || return 1
}

# 'Detached' previously. Doesn't hang terminal.
d() {
	nohup $@ &> /dev/null & disown
}


_have() {
    PATH=$PATH:/usr/sbin:/sbin:/usr/local/sbin type $1 &>/dev/null
}

have() {
    unset -v have
    _have $1 && have=yes
}
