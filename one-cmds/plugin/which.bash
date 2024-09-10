usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one $t which [OPTIONS] <NAME>
Desc:  Show realpath of $t
Arguments:
  <NAME>									$t name
Options:
  -r <repo>               Show the matched $t in the repo
EOF
	# editorconfig-checker-enable
}

. "$ONE_DIR/one-cmds/plugin/action-completion.bash"

search() {
	local -a filepaths=()
	local repo="${opts[r]:-}"
	search_mod "$1" "$repo" filepaths
	printf '%s\n' "${filepaths[@]}"
}

declare -A opts=()
declare -a args=()

main() {
	. "$ONE_DIR/one-cmds/mod.bash"
	if (($# == 0)); then usage; else search "${args[0]}"; fi
}
