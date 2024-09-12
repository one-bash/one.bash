usage() {
	cat <<EOF
Usage: one repo info <NAME>
Desc:  Show the informations of repo
EOF
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

declare -A opts=()
declare -a args=()

main() {
	if ((${#args[@]} == 0)); then
		usage
		return "$ONE_EX_OK"
	fi

	local repo_name=${args[0]}
	local repo_path=$ONE_DIR/data/repo/$repo_name

	if [[ ! -d $repo_path ]]; then
		print_warn "No matched repo '$repo_name'"
		return "$ONE_EX_OK"
	fi

	print_info_item name "$repo_name"
	print_info_item path "$repo_path"

	local repo_file=$repo_path/one.repo.bash
	if [[ -f $repo_file ]]; then
		(
			# shellcheck disable=1090
			. "$repo_file"

			print_info_item about "${ABOUT:-}"
			printf '\n'
			declare -f repo_add_post || true
			declare -f repo_update || true
			declare -f repo_onload || true
		)
	fi
}
