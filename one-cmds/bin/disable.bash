usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one $t disable [OPTIONS] <NAME>...
Desc:  Disable matched $t files
Arguments:
  <NAME>               ${t^} name
Options:
  -a, --all            Disable all $t files
EOF
	# editorconfig-checker-enable
}

completion() {
	shopt -s nullglob
	local path

	for path in "$ONE_DIR/enabled/$t/${@: -1}"*; do
		if [[ -L $path ]]; then
			echo "${path##*/}"
		fi
	done
}

disable_it() {
	local name=$1
	local path="${2:-$ONE_DIR/enabled/$t/$name}"
	local target

	if [[ -L $path ]]; then
		target="$(readlink "$path")"
		unlink "$path"
		printf "Disabled: %b%s%b -> %s\n" "$GREEN" "$name" "$RESET_ALL" "$target"
	else
		print_err "No matched file '$name'"
		return "$ONE_EX_DATAERR"
	fi
}

declare -A opts=()
declare -a args=()
# shellcheck disable=2034
declare -A opts_def=(
	['-a --all']='bool'
)

main() {
	# NOTE: should use $#, not ${#args[@]}
	if (($# == 0)); then
		usage
		return "$ONE_EX_OK"
	fi

	local name path

	if [[ ${opts[a]} == true ]]; then
		shopt -s nullglob
		for path in "${ONE_DIR}/enabled/$t"/*; do
			if [[ -L $path ]]; then
				name="${path##*/}"
				disable_it "$name" "$path" || true
			fi
		done
	else
		for name in "${args[@]}"; do
			disable_it "$name" || true
		done
	fi
}
