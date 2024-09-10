completion() {
	declare -a plugin_dirs=()
	local name path word dir repo i v repo_idx=0

	shopt -s nullglob

	if ((COMP_CWORD == 1)); then
		printf '%s\n' '-r'
		for dir in "${ONE_DIR}/enabled/repo"/*/"$t"; do
			if [[ -d "$dir" ]]; then
				plugin_dirs+=("$dir")
			fi
		done

		for dir in "${plugin_dirs[@]}"; do
			for path in "$dir"/*; do
				name=${path##*/}
				case $name in
					*.opt.bash) name="${name%.opt.bash}" ;;
					*.bash) name="${name%.bash}" ;;
					*.sh) name="${name%.sh}" ;;
				esac
				echo "$name"
			done
		done

		return
	fi

	word="${*:$((COMP_CWORD)):1}"
	if [[ $word == -r ]]; then
		echo ' '
		return
	fi

	word="${*:$((COMP_CWORD - 1)):1}"
	if [[ $word == -r ]]; then
		for repo in "${ONE_DIR}/enabled/repo"/*; do
			echo "${repo##*/}"
		done
		return
	fi

	for ((i = 0; i < $#; i++)); do
		v=${!i}
		if [[ $v == -r ]]; then
			repo_idx=$((i + 1))
			repo=${!repo_idx}
			break
		fi
	done

	if [[ -z ${repo:-} ]]; then
		# user not pass -r
		for repo in "${ONE_DIR}/enabled/repo"/*; do
			if [[ -d "$repo/$t" ]]; then
				plugin_dirs+=("$repo/$t")
			fi
		done
	else
		# user pass -r repo
		if [[ -d "${ONE_DIR}/enabled/repo/$repo/$t" ]]; then
			plugin_dirs+=("${ONE_DIR}/enabled/repo/$repo/$t")
		fi
	fi

	for dir in "${plugin_dirs[@]}"; do
		for path in "$dir"/*; do
			name=${path##*/}
			case $name in
				*.opt.bash) name="${name%.opt.bash}" ;;
				*.bash) name="${name%.bash}" ;;
				*.sh) name="${name%.sh}" ;;
			esac
			echo "$name"
		done
	done
}
