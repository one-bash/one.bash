usage() {
	cat <<EOF
Usage: one dep status [<DEP>]
Desc:  Show status of each dep. If <DEP> is omit, show all deps' status.
Arguments:
  <DEP>    dependency name
EOF
}

completion() {
	words=(composure dotbot)
	printf '%s\n' "${words[@]}"
}

git_status() {
	local dir=$1 status
	shift

	status="$(git -C "$dir" describe --tags --abbrev=8 2>/dev/null |
		sed -E 's/-([0-9]+)-g(.*)/ (commit \2, \1 commits ahead)/' 2>/dev/null || true)"

	if [[ -z $status ]]; then
		status="$(git rev-parse --short=8 HEAD)"
	fi

	printf '%b%-12s%b %s\n' "$GREEN" "[$(basename "$dir")]" \
		"$RESET_ALL" "$status"
}

main() {
	if (($# == 0)); then
		git_status "$ONE_DIR/deps/dotbot"
		git_status "$ONE_DIR/deps/composure"
	else
		git_status "$ONE_DIR/deps/$1"
	fi
}
