usage() {
	cat <<EOF
Usage: one bin disable [-a|--all] <NAME>...
Desc:  Disable matched bin files
Arguments:
  <name>       bin name
Options:
  -a, --all    Disable all bin files
EOF
}

completion() {
	shopt -s nullglob
	local path

	for path in "$ONE_DIR/enabled/bin/${@: -1}"*; do
		if [[ -L $path ]]; then
			basename "$path"
		fi
	done
}

disable_it() {
	local name=$1
	local path="${2:-$ONE_DIR/enabled/bin/$name}"
	local src

	if [[ -L $path ]]; then
		src=$(readlink "$path")
		unlink "$path"
		printf "Disabled: %b%s%b -> %s\n" "$GREEN" "$name" "$RESET_ALL" "$src"
	else
		print_err "No matched file '$name'"
		return 4
	fi
}

main() {
	local name path

	if [[ ${1:-} == -a ]] || [[ ${1:-} == --all ]]; then
		shopt -s nullglob
		for path in "${ONE_DIR}"/enabled/bin/*; do
			name=$(basename "$path")
			disable_it "$name" "$path" || true
		done
	else
		for name in "$@"; do
			disable_it "$name" || true
		done
	fi
}
