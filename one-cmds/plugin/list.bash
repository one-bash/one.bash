usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one $t list [<OPTIONS>]
Desc: List enabled $t
Options:
  -a, --all           List all available $t in each repo
  --only-name         Only list module names
	--compact           List $t in compact format
  -r <repo>           List $t in the repo. Only works with "--all" or "--compact"
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
		for repo in "${ONE_DIR}/enabled/repo"/*; do
			echo "${repo##*/}"
		done
		return
	fi

	printf -- '--all\n-r\n--only-name\n--help\n'
}

declare -A opts_def=(
	['-a --all']='bool'
	['--only-name']=bool
	['--compact']=bool
)

list_mods() {
	local path name priority link

	printf '%b%s%b ' "$BLUE" "[$repo_name]" "$RESET_ALL"

	for path in "$repo/$t"/*; do
		name="${path##*/}"

		if [[ $name == *.opt.bash ]]; then
			name=${name%.opt.bash}
			priority=$(get_priority_from_mod "$path" "$t")
		else
			name=${name%.bash}
			priority=$(get_priority "$path" "$t")
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
	local repo filepath

	. "$ONE_DIR/one-cmds/mod.bash"

	shopt -s nullglob

	if [[ ${opts[a]} == true ]]; then
		# list all available mods
		printf 'Prio Type %-6s %-18s %-18s %s\n' "Enabled" "Name" "Repo" "About"
		if [[ -z $repo_name ]]; then
			# shellcheck disable=2153
			for filepath in "${ONE_DIR}"/enabled/repo/*/"$t"/*; do
				print_mod_props "$filepath"
			done
		else
			for filepath in "${ONE_DIR}/enabled/repo/$repo_name/$t"/*; do
				print_mod_props "$filepath"
			done
		fi
	elif [[ ${opts['only-name']} == true ]]; then
		# list only mod names
		list_enabled "$t" | tr '\n' ' '
		printf '\n'
	elif [[ ${opts['compact']} == true ]]; then
		if [[ -z $repo_name ]]; then
			# shellcheck disable=2153
			for repo in "${ONE_DIR}"/enabled/repo/*; do
				# shellcheck disable=2154
				if [[ ! -d "$repo/$t" ]]; then continue; fi
				repo_name="${repo##*/}"
				list_mods
			done
		else
			repo="${ONE_DIR}/enabled/repo/$repo_name"
			if [[ ! -d "$repo/$t" ]]; then return 0; fi
			list_mods
		fi
	else
		# list all enabled mods
		printf 'Prio Type %-18s %-18s %s\n' "Name" "Repo" "About"
		for filepath in "$ONE_DIR/enabled/"*---*"@$t.bash"; do
			print_enabled_mod_props "$filepath" "$repo_name"
		done | sort
	fi
}
