usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one repo remove <NAME>...

Desc: Remove a repo

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
	local name=$1
	local path="$ONE_DIR/data/repo/$name"
	if [[ ! -d $path ]]; then return; fi

	local answer
	answer=$(l.ask "Do you want to remove repo '$name'?" N)
	if [[ $answer != YES ]]; then return; fi

	if [[ -L $ONE_DIR/enabled/repo/$name ]]; then
		unlink "$ONE_DIR/enabled/repo/$name"
	fi

	rm -rf "$path"
	print_success "Removed repo: $name"
}
