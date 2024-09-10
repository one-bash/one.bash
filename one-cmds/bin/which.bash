usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one $t which <NAME>
Desc:  Show realpath of $t file
Arguments:
  <NAME>                ${t^} name
EOF
	# editorconfig-checker-enable
}

# TODO FIX the bin file should be executable. [[ -x $path ]]
. "$ONE_DIR/one-cmds/plugin/action-completion.bash"

declare -A opts=()
declare -a args=()

main() {
	if ((${#args[*]} == 0)); then
		usage
		return "$ONE_EX_OK"
	fi

	local name=${args[0]}
	local path

	shopt -s nullglob
	for path in "$ONE_DIR"/enabled/repo/*/"$t/$name"; do
		if [[ -x $path ]]; then
			echo "$path"
		fi
	done
}
