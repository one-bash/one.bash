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
	for path in "$ONE_DIR/data/repos/${@: -1}"*; do
		if [[ -d $path ]] && [[ -f $path/one.repo.bash ]]; then
			# shellcheck disable=1091
			. "$path/one.repo.bash"
			echo "${name:-}"
		fi
	done
}

main() {
	local name=$1
	local path="$ONE_DIR/data/repos/$name"
	if [[ ! -d $path ]]; then return; fi

	local answer
	answer=$(one_l.ask "Do you want to remove repo '$name'?")
	if [[ $answer != YES ]]; then return; fi

	if [[ -f $path/one.repo.bash ]]; then
		# shellcheck disable=1091
		name=$(. "$path/one.repo.bash" && echo "${name:-}")
		if [[ -n ${name} ]] && [[ -e $ONE_DIR/enabled/repos/$name ]]; then
			unlink "$ONE_DIR/enabled/repos/$name"
		fi
	fi

	rm -rf "$path"
	print_success "Removed repo: $name"
}
