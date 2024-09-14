completion() {
	shopt -s nullglob
	local path
	for path in "$ONE_DIR/enabled/repo/${@: -1}"*; do
		if [[ -d $path ]]; then
			echo "${path##*/}"
		fi
	done
}

main() {
	local name=$1
	local repo_dir=$ONE_DIR/enabled/repo/$name

	if [[ ! -d "$repo_dir/.git" ]]; then
		print_err "The repo is not a git project"
		return "${ONE_EX_DATAERR}"
	fi

	(
		cd "$repo_dir" || return 23
		# shellcheck disable=1091
		if [[ -f "$repo_dir/one.repo.bash" ]]; then source "$repo_dir/one.repo.bash"; fi
		if type -t repo_update_pre &>/dev/null; then repo_update_pre; fi
	)

	print_verb "[TODO] git -C $repo_dir pull"
	git -C "$repo_dir" pull

	(
		cd "$repo_dir" || return 23
		# shellcheck disable=1091
		if [[ -f "$repo_dir/one.repo.bash" ]]; then source "$repo_dir/one.repo.bash"; fi
		if type -t repo_update_post &>/dev/null; then repo_update_post; fi
	)

	print_success "Updated repo: $name"
}
