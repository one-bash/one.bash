usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one repo exec [-r <REPO>] <CMD>
Desc:  Execute command in each enabled repo
Argument:
  <CMD>                    Any command line
Options:
  -r <REPO>                Only execute command in the repo
EOF
	# editorconfig-checker-enable
}

exec_cmd_in_repo() {
	cd "$repo_path" || return 23
	printf '%b[%s] %b%s%b\n' "$BLUE" "${repo_path}" "$WHITE" "$*" "$RESET_ALL"
	"$@" || printf '%b[exit code: %s]%b\n' "$RED" "$?" "$RESET_ALL"
	printf '\n'
}

main() {
	local repo_name=''
	local repo_path

	if [[ $1 == -r ]]; then
		repo_name=$2
		shift 2

		local repo_path="$ONE_DIR/enabled/repo/$repo_name"

		if [[ ! -d ${repo_path} ]]; then
			print_err "No matched repo '$repo_name'"
			return "${ONE_EX_USAGE}"
		fi

		exec_cmd_in_repo "$@"
	else
		shopt -s nullglob
		for repo_path in "$ONE_DIR"/enabled/repo/*; do
			exec_cmd_in_repo "$@"
		done
	fi
}
