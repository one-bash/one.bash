usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one sub enable [-a|--all] <NAME>...
Desc:  Enable matched sub commands
Arguments:
  <NAME>             Sub name
Options:
  -a, --all          Enable all sub commands
EOF
	# editorconfig-checker-enable
}

completion() {
	shopt -s nullglob
	local path name

	for path in "${ONE_DIR}"/enabled/repo/*/sub/"${@: -1}"*; do
		name=${path##*/}
		echo "${name%.opt.bash}"
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

declare -A opts_def=(
	['-a --all']='bool'
)

main() {
	shopt -s nullglob
	local name path

	# shellcheck source=../../one-cmds/mod.bash
	. "$ONE_DIR/one-cmds/mod.bash"
	# shellcheck source=../../deps/lobash.bash
	. "$ONE_DIR/deps/lobash.bash"

	# shellcheck disable=2154
	if [[ ${opts[a]} == true ]]; then
		for path in "${ONE_DIR}"/enabled/repo/*/sub/*; do
			name=${path##*/}
			name=${name%.bash}
			name="${name%.sh}"
			enable "$path" "$name" || true
		done
	else
		local repo_name paths

		for name in "${args[@]}"; do
			{
				paths=()

				for path in "${ONE_DIR}"/enabled/repo/*/sub/"$name"{,.bash,.sh}; do
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
