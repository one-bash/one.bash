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
	for path in "$ONE_DIR/data/repos/${@: -1}"*; do
		if [[ -d $path ]] && [[ -f $path/one.repo.bash ]]; then
			# shellcheck disable=1091
			. "$path/one.repo.bash"
			echo "${name:-}"
		fi
	done
}

main() {
	local name

	for name in "$@"; do
		if [[ ! -d "$ONE_DIR/data/repos/$name" ]]; then
			print_err "No matched repo '$name'"
			continue
		fi

		if [[ ! -e "$ONE_DIR/enabled/repos/$name" ]]; then
			ln -s "$ONE_DIR/data/repos/$name" "$ONE_DIR/enabled/repos/$name"
			print_success "Enabled repo: $name"
		fi
	done
}
