usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one $t enable [OPTIONS] <NAME>...
Desc:  Enable matched $t files
Arguments:
  <NAME>              $t name
Options:
  -a, --all           Enable all $t files
	-r <repo>           Enable $t files in the repo
EOF
	# editorconfig-checker-enable
}

# TODO FIX the bin file should be executable. [[ -x $path ]]
. "$ONE_DIR/one-cmds/plugin/action-completion.bash"

create_symlink() {
	local name=$1 target=$2 answer

	if [[ -L "$ONE_DIR/enabled/$t/$name" ]]; then
		local answer
		printf 'Found existed enabled file: %s -> %s\n' "$name" "$(readlink "$ONE_DIR/enabled/$t/$name")" >&2
		answer=$(l.ask "Do you want to override it?" N)
		if [[ $answer != YES ]]; then return; fi
	fi

	ln -fs "$target" "$ONE_DIR/enabled/$t/$name"
	printf "Enabled: %b%s%b -> %s\n" "$GREEN" "$name" "$RESET_ALL" "$target"
}

set_exports() {
	if [[ ! -v EXPORTS ]]; then
		return
	fi

	local name=$1

	local file
	for file in "${EXPORTS[@]}"; do
		if [[ -f "$ONE_DIR/data/$t/${name}/$file" ]]; then
			chmod +x "$ONE_DIR/data/$t/${name}/$file"
		else
			print_err "Not found file \"$file\" to export"
		fi
	done
}

enable() {
	local path=$1
	local name=$2

	if [[ -x $path ]]; then
		mod_check_dep_cmds "$path"
		create_symlink "$name" "$path"
	elif [[ $path == *.opt.bash ]]; then
		mod_check_dep_cmds "$path"
		# Disable first, prevent duplicated module enabled with different priority
		disable_mod "$name"
		download_mod_data "$name" "$path"

		local SCRIPT bin_name

		# shellcheck disable=1090
		SCRIPT=$(. "$path" && echo "${SCRIPT:-}")
		if [[ -n $SCRIPT ]]; then
			local script_file=$ONE_DIR/data/$t/$name/script.bash
			if [[ ! -f $script_file ]]; then
				print_err "The script file not exist: $script_file"
				return 4
			fi

			chmod +x "$script_file"

			# shellcheck disable=1090
			while read -r bin_name; do
				create_symlink "$bin_name" "$script_file"
			done < <(. "$path" && echo "${EXPORTS[@]}")
		else
			(
				# shellcheck disable=1090
				. "$path"
				set_exports "$name"
				# shellcheck disable=1090
				while read -r bin_name; do
					create_symlink "$bin_name" "$ONE_DIR/data/$t/$name/$bin_name"
				done < <(. "$path" && echo "${EXPORTS[@]}")
			)
		fi
	else
		print_err "The file is not executable: $path"
		return "$ONE_EX_DATAERR"
	fi
}

declare -A opts=()
declare -a args=()
# shellcheck disable=2034
declare -A opts_def=(
	['-a --all']='bool'
)

main() {
	if ((${#args[*]} == 0)); then
		usage
		return "$ONE_EX_OK"
	fi

	shopt -s nullglob
	local name path filepaths

	# shellcheck source=../../one-cmds/mod.bash
	. "$ONE_DIR/one-cmds/mod.bash"

	local repo=${opts[r]:-}

	if [[ ${opts[a]} == true ]]; then
		if [[ -z $repo ]]; then
			for path in "${ONE_DIR}"/enabled/repo/*/"$t"/*; do
				name=${path##*/}
				name=${name%.opt.bash}
				name=${name%.bash}
				name="${name%.sh}"
				enable "$path" "$name"
			done
		else
			for path in "${ONE_DIR}/enabled/repo/$repo/$t/"*; do
				name=${path##*/}
				name=${name%.opt.bash}
				name=${name%.bash}
				name="${name%.sh}"
				enable "$path" "$name"
			done
		fi
	else
		for name in "${args[@]}"; do
			{
				filepaths=()

				if [[ -z $repo ]]; then
					for path in "${ONE_DIR}"/enabled/repo/*/"$t/$name"{,.bash,.sh,.opt.bash}; do
						filepaths+=("$path")
					done
				else
					for path in "${ONE_DIR}/enabled/repo/$repo/$t/$name"{,.bash,.sh,.opt.bash}; do
						filepaths+=("$path")
					done
				fi

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
						local repo
						for filepath in "${filepaths[@]}"; do
							repo=$(get_enabled_repo_name "$filepath")
							echo "   one $t enable $name -r $repo" >&2
						done
						return "$ONE_EX_USAGE"

						;;
				esac
			}
		done
	fi
}
