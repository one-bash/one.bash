usage() {
	cat <<EOF
Usage: one sub help <cmd>
Desc:  Print the usage of sub command
EOF
}

completion() {
	local path name
	shopt -s nullglob
	for path in "${ONE_DIR}"/data/repo/*/sub/"${@: -1}"*; do
		name=${path##*/}
		echo "${name%.opt.bash}"
	done
}

print_help() {
	local cmd=$1 file=$2 label arg

	if [[ -z ${file:-} ]]; then
		printf '%bNot found ONE_SUB command "%s".%b\n' "$YELLOW" "$cmd" "$RESET_ALL" >&2
		return "$ONE_EX_USAGE"
	fi

	if [[ ! -x ${file} ]]; then
		printf '%bNot found ONE_SUB command "%s". File is not executable or not existed: %s%b\n' "$YELLOW" "$cmd" "$file" "$RESET_ALL" >&2
		return "$ONE_EX_USAGE"
	fi

	label=$(grep -i '^# one.bash:usage' "$file" 2>/dev/null || true)

	if [[ -z $label ]]; then
		printf '%bThe command "%s" has not usage document.%b\n' "$YELLOW" "$cmd" "$RESET_ALL" >&2
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

main() {
	if (($# == 0)); then
		usage_info
		return 0
	fi

	# shellcheck source=../../one-cmds/mod.bash
	. "$ONE_DIR/one-cmds/mod.bash"

	shopt -s nullglob

	local name path
	for name in "$@"; do
		for path in "${ONE_DIR}"/enabled/repo/*/sub/"$name"{,.bash,.sh}; do
			print_help "$name" "$path"
		done
	done
}
