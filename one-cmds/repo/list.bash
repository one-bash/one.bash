usage() {
	cat <<EOF
Usage: one repo list
Desc:  List all downloaded repos
EOF
}

main() {
	local repo_path repo_name repo_status repo_status_color ABOUT=''

	printf '%-8s %-20s\t%b%s\n' "Status" "Name" "$RESET_ALL" "About"

	shopt -s nullglob
	for repo_path in "$ONE_DIR"/data/repo/*; do
		if [[ ! -d $repo_path ]]; then continue; fi
		repo_name="${repo_path##*/}"
		name_str=$(printf '%b%s' "$BLUE" "$repo_name")

		if [[ -e "$ONE_DIR/enabled/repo/$repo_name" ]]; then
			repo_status_color="$GREEN"
			repo_status=Enabled
		else
			repo_status_color="$GREY"
			repo_status=Disabled
		fi

		local repo_file=$repo_path/one.repo.bash
		if [[ -f $repo_file ]]; then
			# shellcheck disable=1090
			ABOUT=$(
				. "$repo_file"
				echo "${ABOUT:-}"
			)
		fi
		printf '%b%-8s %-20s\t%b%s\n' "$repo_status_color" "$repo_status" "$name_str" "$RESET_ALL" "$ABOUT"
	done
}
