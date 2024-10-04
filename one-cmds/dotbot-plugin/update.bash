completion() {
	shopt -s nullglob
	local path
	for path in "$ONE_DIR/enabled/dotbot-plugin/${@: -1}"*; do
		if [[ -d $path ]]; then
			echo "${path##*/}"
		fi
	done
}

main() {
	local name=$1
	local plugin_dir=$ONE_DIR/enabled/dotbot-plugin/$name

	if [[ ! -d "$plugin_dir/.git" ]]; then
		print_err "The dotbot-plugin is not a git project"
		return "${ONE_EX_DATAERR}"
	fi

	print_verb "[TODO] git -C $plugin_dir pull"
	git -C "$plugin_dir" pull

	print_success "Updated dotbot-plugin: $name"
}
