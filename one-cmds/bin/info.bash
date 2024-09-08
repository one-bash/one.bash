usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one bin info <NAME>
Desc:  Show the information of matched bin files
Arguments:
  <NAME>            bin name
EOF
	# editorconfig-checker-enable
}

completion() {
	shopt -s nullglob
	local path name

	for path in "${ONE_DIR}"/enabled/repos/*/bins/"${@: -1}"*; do
		name=${path##*/}
		echo "${name%.opt.bash}"
	done
}

main() {
	local name=${1:-} path

	if [[ -z $name ]]; then
		usage_info
		return 0
	fi

	# shellcheck disable=2034
	PRINT_INFO_KEY_WIDTH=-6

	shopt -s nullglob
	for path in "$ONE_DIR"/enabled/repos/*/bins/"$name"{,.opt.bash}; do
		print_info_item Name "$name"

		if [[ $path =~ \/data\/repos\/([^\/]+)\/ ]]; then
			print_info_item Repo "${BASH_REMATCH[1]}"
		fi

		print_info_item Path "$path"

		if [[ $path == *.opt.bash ]]; then
			(
				# shellcheck disable=1090
				source "$path"
				print_info_item "About" "${ABOUT:-}"
				print_info_item "URL" "${URL:-}"
			)
		else
			print_info_item "About" "$(metafor about-plugin <"$path")"
		fi
	done
}
