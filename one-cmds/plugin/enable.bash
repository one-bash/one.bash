usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one $t enable [OPTIONS] <NAME> [<NAME>...]
Desc:  Enable matched $ts
Arguments:
  <name>  $t name
Options:
  -r, --repo <repo>       repo name
EOF
	# editorconfig-checker-enable
}

completion() {
	declare -a plugin_dirs=()
	local word dir repo i v repo_idx=0

	if ((COMP_CWORD == 1)); then
		printf '%s\n' '-r'
		for repo in "${ONE_DIR}/enabled/repos"/*; do
			if [[ -d "$repo/$ts" ]]; then
				plugin_dirs+=("$repo/$ts")
			fi
		done

		for dir in "${plugin_dirs[@]}"; do
			find -L "$dir" -maxdepth 1 -type f -name "*.bash" -exec basename {} ".bash" \; | sed -E 's/\.opt$//'
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
		for repo in "${ONE_DIR}/enabled/repos"/*; do
			basename "$repo"
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
		for repo in "${ONE_DIR}/enabled/repos"/*; do
			if [[ -d "$repo/$ts" ]]; then
				plugin_dirs+=("$repo/$ts")
			fi
		done
	else
		# user pass -r repo
		if [[ -d "${ONE_DIR}/enabled/repos/$repo/$ts" ]]; then
			plugin_dirs+=("${ONE_DIR}/enabled/repos/$repo/$ts")
		fi
	fi

	for dir in "${plugin_dirs[@]}"; do
		find -L "$dir" -maxdepth 1 -type f -name "*.bash" -exec basename {} ".bash" \; | sed -E 's/\.opt$//'
	done
}

main() {
	. "$ONE_DIR/one-cmds/mod.bash"
	if (($# == 0)); then usage; else enable_it "$@"; fi
}
