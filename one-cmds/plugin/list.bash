usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one $t list [<OPTIONS>]
Desc: List enabled $ts
Options:
  -a, --all           List all available $ts in each repo
  --only-name         Only list module names
  -r <repo>           List $ts in the repo
EOF
	# editorconfig-checker-enable
}

completion() {
	local word repo

	word="${*:$((COMP_CWORD)):1}"
	if [[ $word == -r ]]; then
		echo ' '
		return
	fi

	word="${*:$((COMP_CWORD - 1)):1}"
	if [[ $word == -r ]]; then
		for repo in "${ONE_DIR}/enabled/repos"/*; do
			echo "${repo##*/}"
		done
		return
	fi

	printf -- '--all\n-r\n--only-name\n--help\n'
}

declare -A opts_def=(
	['-a --all']='bool'
	['--only-name']=bool
)

list_mods() {
	local path name priority link

	printf '%b%s%b ' "$BLUE" "[$repo_name]" "$RESET_ALL"

	for path in "$repo/$ts"/*; do
		name="${path##*/}"

		if [[ $name == *.opt.bash ]]; then
			name=${name%.opt.bash}
			priority=$(get_priority_from_mod "$path")
		else
			name=${name%.bash}
			priority=$(get_priority "$path")
		fi

		link="$ONE_DIR/enabled/${priority}---$name@$repo_name@$t.bash"

		if [[ -L $link ]]; then
			printf '%b%s%b ' "$BOLD_GREEN" "$name" "$RESET_ALL"
		else
			printf '%s ' "$name"
		fi
	done

	printf '\n'
}

main() {
	local repo_name=${opts[r]:-}
	local repo

	. "$ONE_DIR/one-cmds/mod.bash"

	shopt -s nullglob

	if [[ ${opts[a]} == true ]]; then
		# list all available mods
		if [[ -z $repo_name ]]; then
			# shellcheck disable=2153
			for repo in "${ONE_DIR}"/enabled/repos/*; do
				# shellcheck disable=2154
				if [[ ! -d "$repo/$ts" ]]; then continue; fi
				repo_name="${repo##*/}"
				list_mods
			done
		else
			repo="${ONE_DIR}/enabled/repos/$repo_name"
			if [[ ! -d "$repo/$ts" ]]; then return; fi
			list_mods
		fi
	else
		# list all enabled mods
		if [[ ${opts['only-name']} == true ]]; then
			# list only mod names
			list_enabled "$t" | tr '\n' ' '
			printf '\n'
		else
			printf 'Prio Type %-18s %-18s %s\n' "Name" "Repo" "About"
			find "$ENABLED_DIR" -maxdepth 1 -name "*---*@$t.bash" | print_list_item "$repo_name" | sort
		fi
	fi
}
