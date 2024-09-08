usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one bin list [<OPTIONS>]
Desc:  List available bin files
Options:
  -r <repo>           list $ts in the repo
EOF
	# editorconfig-checker-enable
}

list() {
	local path repo

	# shellcheck disable=2153
	for path in "${ONE_DIR}"/enabled/bin/*; do
		printf '%b%20s%b -> %b%s\n' \
			"$GREEN" "${path##*/}" "$GREY" \
			"$WHITE" "$(readlink "$path")"
	done
}

main() {
	shopt -s nullglob
	local path repo name link repo_name

	for repo in "${ONE_DIR}"/enabled/repos/*; do
		repo_name="${repo##*/}"
		printf '%b[%s]%b ' "$BLUE" "$repo_name" "$RESET_ALL"

		for path in "$repo/bins"/*; do
			name=${path##*/}
			name=${name%.opt.bash}
			name=${name%.bash}
			link=${ONE_DIR}/enabled/bin/$name

			if [[ -L $link ]] && [[ $(readlink "$link") == "$path" ]]; then
				printf '%b%s%b ' "$BOLD_GREEN" "$name" "$RESET_ALL"
			else
				printf '%s ' "$name"
			fi
		done
		printf '\n'
	done

	printf "\n### The %bGREEN%b items are enabled. The WHITE items are available. ###\n" "$BOLD_GREEN" "$RESET_ALL"
}
