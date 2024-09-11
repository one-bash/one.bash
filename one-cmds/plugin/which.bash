usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one $t which [OPTIONS] <NAME>
Desc:  Show realpath of $t
Arguments:
  <NAME>                $t name
Options:
  -r <repo>             Show the matched $t in the repo
EOF
	# editorconfig-checker-enable
}

. "$ONE_DIR/one-cmds/plugin/action-completion.bash"

declare -A opts=()
declare -a args=()

main() {
	if ((${#args[*]} == 0)); then
		usage
		return "$ONE_EX_OK"
	fi

	. "$ONE_DIR/one-cmds/mod.bash"

	local -a filepaths=()
	local repo="${opts[r]:-}"
	search_mod "${args[0]}" "$repo" filepaths
	printf '%s\n' "${filepaths[@]}"
}
