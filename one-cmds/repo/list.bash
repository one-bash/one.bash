usage() {
	cat <<EOF
Usage: one repo list
Desc:  List available repos
EOF
}

main() {
	shopt -s nullglob
	local repo name repo_status repo_status_color

	printf '%-8s %-20s\t%b%s\n' "Status" "Name" "$RESET_ALL" "Path"
	for repo in "$ONE_DIR"/data/repos/*; do
		if [[ ! -d $repo ]]; then continue; fi
		name=''

		if [[ -f "$repo/one.repo.bash" ]]; then
			# shellcheck disable=1091
			name=$(. "$repo/one.repo.bash" && echo "${name:-}")
		fi

		if [[ -n $name ]]; then
			name_str=$(printf '%b%s' "$BLUE" "$name")

			if [[ -e "$ONE_DIR/enabled/repos/$name" ]]; then
				repo_status_color="$GREEN"
				repo_status=Enabled
			else
				repo_status_color="$GREY"
				repo_status=Disabled
			fi
		else
			name_str=$(printf '%b%s' "$GREY" "<unknown>")
			repo_status_color="$YELLOW"
			repo_status=Invalid
		fi

		printf '%b%-8s %-20s\t%b%s\n' "$repo_status_color" "$repo_status" "$name_str" "$RESET_ALL" "$repo"
	done
}
