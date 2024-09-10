usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one sub help <NAME>
Desc:  Print the usage of sub command
Arguments:
  <NAME>            Sub name
EOF
	# editorconfig-checker-enable
}

completion() {
	local path name
	if (($# > 1)); then return 0; fi

	shopt -s nullglob
	for path in "${ONE_DIR}"/enabled/repo/*/sub/"${@: -1}"*; do
		name=${path##*/}
		echo "${name%.opt.bash}"
	done
}

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
	if (($# == 0)); then
		usage_info
		return 0
	fi

	# shellcheck source=../../one-cmds/mod.bash
	. "$ONE_DIR/one-cmds/mod.bash"

	shopt -s nullglob

	local name path
	for name in "${args[@]}"; do
		for path in "${ONE_DIR}"/enabled/repo/*/sub/"$name"{,.bash,.sh}; do
			print_help "$name" "$path"
		done
	done
}
