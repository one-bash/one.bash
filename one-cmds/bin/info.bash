usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one $t info [<OPTIONS>] <NAME>
Desc:  Show the information of matched $t files
Arguments:
  <NAME>              ${t^} name
Options:
  -r <repo>           List $t files in the repo
EOF
	# editorconfig-checker-enable
}

# TODO FIX the bin file should be executable. [[ -x $path ]]
. "$ONE_DIR/one-cmds/plugin/action-completion.bash"

print_info() {
	local path=$1 name=$2

	print_info_item Name "$name"
	print_info_item Repo "$(get_enabled_repo_name "$path")"
	print_info_item Path "$path"

	if [[ $path == *.opt.bash ]]; then
		(
			# shellcheck disable=1090
			source "$path"
			print_info_item About "${ABOUT:-}"
			print_info_item SCRIPT "${SCRIPT:-}"
		)
	else
		print_info_item About "$(metafor about-plugin <"$path")"
	fi
}

declare -A opts=()
declare -a args=()

main() {
	if ((${#args[*]} == 0)); then
		usage
		return "$ONE_EX_OK"
	fi

	shopt -s nullglob
	local name path filepaths

	# shellcheck source=../../one-cmds/mod.bash
	. "$ONE_DIR/one-cmds/mod.bash"

	local repo=${opts[r]:-}

	# shellcheck disable=2034
	PRINT_INFO_KEY_WIDTH=6

	for name in "${args[@]}"; do

		filepaths=()

		if [[ -z $repo ]]; then
			for path in "${ONE_DIR}"/enabled/repo/*/"$t/$name"{,.bash,.sh,.opt.bash}; do
				filepaths+=("$path")
			done
		else
			for path in "${ONE_DIR}/enabled/repo/$repo/$t/$name"{,.bash,.sh,.opt.bash}; do
				filepaths+=("$path")
			done
		fi

		case ${#filepaths[@]} in
			1)
				print_info "${filepaths[0]}" "$name"
				;;

			0)
				print_err "No matched $t '$name'"
				return "$ONE_EX_DATAERR"
				;;

			*)
				print_err "Matched multi $t for '$name'. You should use '-r' option for specified repo:"
				local repo
				for filepath in "${filepaths[@]}"; do
					repo=$(get_enabled_repo_name "$filepath")
					echo "   one $t info $name -r $repo" >&2
				done
				return "$ONE_EX_USAGE"

				;;
		esac

	done

}
