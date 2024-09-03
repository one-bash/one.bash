usage() {
	cat <<EOF
Usage: one sub enable [-a|--all] <NAME>...
Desc:  Enable matched sub commands
Arguments:
  <NAME>      Sub name
Options:
  -a, --all   Enable all sub commands
EOF
}

completion() {
	shopt -s nullglob
	local path

	for path in "${ONE_DIR}"/data/repos/*/sub/"${@: -1}"*; do
		basename "$path" .opt.bash
	done
}

enable() {
	local path=$1
	local name=$2
	local target="$ONE_DIR/enabled/sub/$name"

	if [[ -x $path ]]; then
		if [[ -e $target ]]; then
			local answer
			printf 'Found existed enabled file: %s -> %s\n' "$name" "$(readlink "$target")"
			answer=$(one_l.ask "Do you want to override it?")
			if [[ $answer != YES ]]; then return; fi
		fi
		ln -fs "$path" "$target"
		printf "Enabled: %b%s%b -> %s\n" "$GREEN" "$name" "$RESET_ALL" "$path"
	else
		echo "Not found executable sub file '$name'." >&2
		return 3
	fi
}

main() {
	shopt -s nullglob
	local name path

	# shellcheck source=../../one-cmds/mod.bash
	. "$ONE_DIR/one-cmds/mod.bash"
	# shellcheck source=../../deps/lobash.bash
	. "$ONE_DIR/deps/lobash.bash"

	if [[ ${1:-} == --all ]] || [[ ${1:-} == -a ]]; then
		for path in "${ONE_DIR}"/enabled/repos/*/sub/*; do
			name=$(basename "$path" .bash)
			name="${name%.sh}"
			enable "$path" "$name" || true
		done
	else
		local repo_name paths

		for name in "$@"; do
			{
				paths=()

				for path in "${ONE_DIR}"/enabled/repos/*/sub/"$name"{,.bash,.sh}; do
					paths+=("$path")
				done

				case ${#paths[@]} in
					1)
						enable "${paths[0]}" "$name"
						;;

					0)
						print_err "No matched file '$name'"
						;;

					*)
						print_err "Matched multi files for '$name':"
						printf '  %s\n' "${paths[@]}" >&2
						;;
				esac
			} || true
		done
	fi
}
