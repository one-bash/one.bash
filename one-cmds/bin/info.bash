usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one $t info [<OPTIONS>] <NAME>
Desc:  Show the information of matched $t files
Arguments:
  <NAME>              ${t^} name
Options:
  -r <repo>           List $t files in the repo
EOF
	# editorconfig-checker-enable
}

# TODO FIX the bin file should be executable. [[ -x $path ]]
. "$ONE_DIR/one-cmds/plugin/action-completion.bash"

declare -A opts=()
declare -a args=()

print_info() {
	local name=$1 path
	# for path in "${ONE_DIR}"/enabled/repo/*/"$t/$name"{,.bash,.sh}; do
	for path in "$ONE_DIR"/enabled/repo/*/"$t/$name"{,.bash,.sh,.opt.bash}; do
		print_info_item Name "$name"
		print_info_item Repo "$(get_enabled_repo_name "$path")"
		print_info_item Path "$path"

		if [[ $path == *.opt.bash ]]; then
			(
				# shellcheck disable=1090
				source "$path"
				print_info_item About "${ABOUT:-}"
				print_info_item URL "${URL:-}"
			)
		else
			print_info_item About "$(metafor about-plugin <"$path")"
		fi
	done
}

declare -A opts=()
declare -a args=()

main() {
	if ((${#args[*]} == 0)); then
		usage
		return "$ONE_EX_OK"
	fi

	# shellcheck source=../../one-cmds/mod.bash
	. "$ONE_DIR/one-cmds/mod.bash"

	shopt -s nullglob

	# shellcheck disable=2034
	PRINT_INFO_KEY_WIDTH=6

	local name
	for name in "${args[@]}"; do
		print_info "$name"
	done
}
