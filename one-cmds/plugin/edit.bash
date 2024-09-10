usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one $t edit [OPTIONS] <NAME>
Desc:  Edit matched $t
Arguments:
  <NAME>									$t name
Options:
  -r <repo>								Edit the matched $t in the repo
EOF
	# editorconfig-checker-enable
}

. "$ONE_DIR/one-cmds/plugin/action-completion.bash"

edit_mod() {
	local name=$1
	local -a filepaths=()

	search_mod "$name" "${opts[r]:-}" filepaths

	case ${#filepaths[@]} in
		1)
			${EDITOR:-vi} "${filepaths[0]}"
			;;
		0)
			print_err "No matched $t '$name'"
			return 10
			;;
		*)
			print_err "Matched multi $t for '$name':"
			printf '  %s\n' "${filepaths[@]}" >&2
			return 11
			;;
	esac
}

main() {
	. "$ONE_DIR/one-cmds/mod.bash"

	if (($# == 0)); then
		usage
		return
	fi

	if ((${#args[*]} > 1)); then
		print_err "Only accept one $t name. But received ${#args[*]}."
		return "$ONE_EX_USAGE"
	fi

	edit_mod "${args[0]}"
}
