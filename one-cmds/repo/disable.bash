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
	for path in "$ONE_DIR/enabled/repos/${@: -1}"*; do
		if [[ -d $path ]]; then
			echo "${path##*/}"
		fi
	done
}

main() {
	local name filepath

	for name in "$@"; do
		filepath="$ONE_DIR/enabled/repos/$name"

		if [[ -L $filepath ]]; then
			unlink "$filepath"
			print_success "Disabled repo: $name"
		else
			print_err "No matched repo: $name"
		fi
	done
}
