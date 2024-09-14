usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one repo disable <NAME>...

Desc: Disable repo

Arguments:
  <NAME>      Repo name
EOF
	# editorconfig-checker-enable
}

completion() {
	shopt -s nullglob
	local path
	for path in "$ONE_DIR/enabled/repo/${@: -1}"*; do
		if [[ -d $path ]]; then
			echo "${path##*/}"
		fi
	done
}

declare -A opts=()
declare -a args=()

main() {
	if ((${#args[@]} == 0)); then
		usage
		return "$ONE_EX_OK"
	fi

	local name filepath

	for name in "${args[@]}"; do
		filepath="$ONE_DIR/enabled/repo/$name"

		if [[ -L $filepath ]]; then
			unlink "$filepath"
			print_success "Disabled repo: $name"
		else
			print_err "No matched repo: $name"
		fi
	done
}
