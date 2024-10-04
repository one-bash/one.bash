usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one $t list [<OPTIONS>]
Desc:  List available $t files in each repo
Options:
  -r <repo>           List $t files in the repo
EOF
	# editorconfig-checker-enable
}

list() {
	local path repo

	# shellcheck disable=2153
	for path in "${ONE_DIR}/enabled/$t"/*; do
		printf '%b%20s%b -> %b%s\n' \
			"$GREEN" "${path##*/}" "$GREY" \
			"$WHITE" "$(readlink "$path")"
	done
}

declare -A opts=()
declare -a args=()

main() {
	shopt -s nullglob
	local path repo name link repo_name

	for repo in "${ONE_DIR}"/enabled/repo/*; do
		repo_name="${repo##*/}"
		printf '%b[%s]%b ' "$BLUE" "$repo_name" "$RESET_ALL"

		for path in "$repo/$t"/*; do
			name=${path##*/}
			name=${name%.opt.bash}
			name=${name%.bash}
			name=${name%.sh}
			link=${ONE_DIR}/enabled/$t/$name

			if [[ -L $link ]] && [[ $(realpath "$link") == $(realpath "$path") ]]; then
				printf '%b%s%b ' "$BOLD_GREEN" "$name" "$RESET_ALL"
			else
				printf '%s ' "$name"
			fi
		done
		printf '\n'
	done

	printf "\n### The %bGREEN%b items are enabled. The WHITE items are available. ###\n" "$BOLD_GREEN" "$RESET_ALL"
}
