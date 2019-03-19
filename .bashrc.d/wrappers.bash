cd_wrapper() {
	if [[ ! -d $1 ]]; then
		local capped=${1^}
		if [[ -d $capped ]]; then
			command cd $capped
			return 0
		fi
	fi
	command cd "$@"
	echo `pwd` > /tmp/cd_func
}

rm_wrapper() {
	local path="$HOME/.trash/$(date +%F)"
	# make dir titled wiht date
	[[ -e $path ]] || mkdir -p $path
	# Let mv handle duplicate names

	# Bash evaluates spaces in filenames as seperate array elements
	# First try escaping the spaces
	trial=$(echo "$@" | sed  's/ /\ /')
	VERSION_CONTROL="numbered"  mv --backup "$trial" "$path" 2> /dev/null && return 0

	for file in "$@"
	do
		VERSION_CONTROL="numbered" mv --backup $file "$path"
	done
}
