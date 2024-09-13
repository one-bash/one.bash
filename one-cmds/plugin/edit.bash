usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one $t edit [OPTIONS] <NAME>
Desc:  Edit matched $t file
Arguments:
  <NAME>                  $t name
Options:
  -r <repo>               Edit the matched $t in the repo
EOF
	# editorconfig-checker-enable
}

. "$ONE_DIR/one-cmds/plugin/action-completion.bash"

edit_mod() {
	local name=$1
	local -a filepaths=()

	# shellcheck source=../../one-cmds/mod.bash
	. "$ONE_DIR/one-cmds/mod.bash"

	search_mod "$name" "${opts[r]:-}" filepaths

	case ${#filepaths[@]} in
		1)
			${EDITOR:-vi} "${filepaths[0]}"
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
				echo "   one $t edit $name -r $repo" >&2
			done
			return "$ONE_EX_USAGE"
			;;
	esac
}

declare -A opts=()
declare -a args=()

main() {
	case ${#args[*]} in
		1)
			edit_mod "${args[0]}"
			;;

		0)
			usage
			;;

		*)
			print_err "Only accept one $t name. But received ${#args[*]}."
			return "$ONE_EX_USAGE"
			;;
	esac
}
