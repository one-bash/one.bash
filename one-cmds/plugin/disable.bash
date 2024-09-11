usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one $t disable [OPTIONS] <NAME>...
Desc:  Disable matched $t
Arguments:
  <name>                  $t name
Options:
  -a, --all               Disable all $t
EOF
	# editorconfig-checker-enable
}

completion() {
	printf -- '--all\n-r\n'

	# shellcheck disable=2154
	find "$ENABLED_DIR" -maxdepth 1 -name "*---*@$t.bash" -print0 |
		sed -E "s/^[[:digit:]]{3}---([^@]+)@[^@]+@$t\.bash$/\1/" || true
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
	. "$ONE_DIR/one-cmds/mod.bash"

	local name
	local found

	if [[ ${opts[a]} == true ]]; then
		for name in $(list_enabled "$t"); do
			disable_mod "$name" found || print_err "Failed to disable '$name'."
			if [[ $found == false ]]; then
				print_err "No matched enabled $t '$name'."
			fi
		done
	else
		for name in "${args[@]}"; do
			disable_mod "$name" found || print_err "Failed to disable '$name'."
			if [[ $found == false ]]; then
				print_err "No matched enabled $t '$name'."
			fi
		done
	fi
}
