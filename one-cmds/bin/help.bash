usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one $t help [<OPTIONS>] <NAME>
Desc:  Print the usage of $t file
Arguments:
  <NAME>              ${t^} name
Options:
  -r <repo>           List $t files in the repo
EOF
	# editorconfig-checker-enable
}

# TODO FIX the bin file should be executable. [[ -x $path ]]
. "$ONE_DIR/one-cmds/plugin/action-completion.bash"

print_help() {
	local cmd=$1 file=$2 label arg

	if [[ -z ${file:-} ]]; then
		print_warn 'Not found ONE_SUB command "%s".\n' "$cmd"
		return "$ONE_EX_USAGE"
	fi

	if [[ ! -x ${file} ]]; then
		print_warn 'Not found ONE_SUB command "%s". File is not executable or not existed: %s\n' "$cmd" "$file"
		return "$ONE_EX_USAGE"
	fi

	label=$(grep -i '^# one.bash:usage' "$file" 2>/dev/null || true)

	if [[ -z $label ]]; then
		print_warn 'The command "%s" has not usage document.\n' "$cmd"
		return "$ONE_EX_UNAVAILABLE"
	fi

	arg=$(sed -E 's/^# one.bash:usage(:?.*)/\1/i' <<<"$label" || true)

	if [[ -z ${arg#:} ]]; then
		arg='--help'
	else
		arg=${arg#:}
	fi

	"$file" "$arg"
}

declare -A opts=()
declare -a args=()

main() {
	if ((${#args[*]} == 0)); then
		usage
		return 0
	fi

	# shellcheck source=../../one-cmds/mod.bash
	. "$ONE_DIR/one-cmds/mod.bash"

	shopt -s nullglob

	local name path
	for name in "${args[@]}"; do
		for path in "${ONE_DIR}"/enabled/repo/*/"$t/$name"{,.bash,.sh}; do
			print_help "$name" "$path"
		done
	done
}
