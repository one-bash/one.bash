usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one dotbot-plugin remove <NAME>...

Desc: Remove a dotbot plugin

Arguments:
  <NAME>      dotbot-plugin name
EOF
	# editorconfig-checker-enable
}

completion() {
	shopt -s nullglob
	local path
	for path in "$ONE_DIR/data/dotbot-plugin/${@: -1}"*; do
		if [[ -d $path ]]; then
			echo "${path##*/}"
		fi
	done
}

main() {
	local name=$1
	local path="$ONE_DIR/data/dotbot-plugin/$name"
	if [[ ! -d $path ]]; then return 0; fi

	local answer
	answer=$(l.ask "Do you want to remove dotbot-plugin '$name'?")
	if [[ $answer != YES ]]; then return 0; fi

	rm -rf "$path"
	print_success "Removed dotbot-plugin: $name"
}
