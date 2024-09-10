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
		print_err "Not found executable sub file '$name'"
		return "$ONE_EX_DATAERR"
	fi
}

declare -A opts=()
declare -a args=()
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

	if [[ ${opts[a]} == true ]]; then
		for path in "${ONE_DIR}"/enabled/repo/*/sub/*; do
			name=${path##*/}
			name=${name%.bash}
			name="${name%.sh}"
			enable "$path" "$name" || true
		done
	else
		local repo_name filepaths

		for name in "${args[@]}"; do
			{
				filepaths=()

				for path in "${ONE_DIR}"/enabled/repo/*/sub/"$name"{,.bash,.sh}; do
					filepaths+=("$path")
				done

				case ${#filepaths[@]} in
					1)
						enable "${filepaths[0]}" "$name"
						;;

					0)
						print_err "No matched $t '$name'"
						return "$ONE_EX_DATAERR"
						;;

					*)
						print_err "Matched multi $t for '$name'. You should use '-r' option for specified repo:"
						local repo filepath
						for filepath in "${filepaths[@]}"; do
							repo=$(get_enabled_repo_name "$filepath")
							echo "   one $t enable $name -r $repo" >&2
						done
						return "$ONE_EX_USAGE"
						;;
				esac
			} || true
		done
	fi
}
