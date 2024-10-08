usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one repo enable <NAME>...

Desc: Enable repo

Arguments:
  <NAME>      Repo name
EOF
	# editorconfig-checker-enable
}

completion() {
	shopt -s nullglob
	local path
	for path in "$ONE_DIR/data/repo/${@: -1}"*; do
		if [[ -d $path ]]; then
			echo "${path##*/}"
		fi
	done
}

main() {
	local name

	for name in "$@"; do
		if [[ ! -d "$ONE_DIR/data/repo/$name" ]]; then
			print_err "No matched repo '$name'"
			continue
		fi

		ln -f -s "../../data/repo/$name" "$ONE_DIR/enabled/repo/$name"
		print_success "Enabled repo: $name"
	done
}
