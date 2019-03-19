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

# Recursively evaluates directories with colon delimiter
jump() {
	if [[ -z $1 ]]; then
		echo "Jump requires an argument." >&2 
		return 1
	fi

	# Redirect find output to while loop's stdin. This is the way to redirect find output to an array of directories
	local dirs=()
	while IFS=  read -r -d $'\0'; do
	    dirs+=("$REPLY")
	done < <(ls --color=none -d $HOME/* | xargs -I{} find {} -type d -maxdepth 4 -iname "*$@*" 2> /dev/null -print0)

	local count="${#dirs[@]}"

	if [[ $count -eq 0 ]]; then
		echo "Could not find $1" >&2
		return 1
	elif [[ $count -eq 1 ]]; then
		cd $dirs
		return 0
	fi

	echo "Mutliple Directories found:" >&2
	for (( i=0; i<${count}; i++ ));
	do
		echo "$((i + 1)): ${dirs[i]}"
	done
	read input
	if [[ $input -gt $(($count + 1)) || $input -lt 0 ]]; then
		echo "Result out of bounds." >&2
		return 1
	fi

	cd "${dirs[$(($in - 1))]}"

}

playtime() {
	#!/bin/bash

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

detached() {
	echo "Launching command: '${@}'"
	nohup "$@" &> /dev/null & disown
	exit
}


