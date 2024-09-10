usage() {
	cat <<EOF
Usage: one repo list
Desc:  List available repos
EOF
}

main() {
	local repo name repo_status repo_status_color

	printf '%-8s %-20s\t%b%s\n' "Status" "Name" "$RESET_ALL" "Path"

	shopt -s nullglob
	for repo in "$ONE_DIR"/data/repo/*; do
		if [[ ! -d $repo ]]; then continue; fi
		name="${repo##*/}"
		name_str=$(printf '%b%s' "$BLUE" "$name")

		if [[ -e "$ONE_DIR/enabled/repo/$name" ]]; then
			repo_status_color="$GREEN"
			repo_status=Enabled
		else
			repo_status_color="$GREY"
			repo_status=Disabled
		fi

		printf '%b%-8s %-20s\t%b%s\n' "$repo_status_color" "$repo_status" "$name_str" "$RESET_ALL" "$repo"
	done
}
