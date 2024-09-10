usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one bin enable [OPTIONS] <NAME>...
Desc:  Enable matched bin files
Arguments:
  <NAME>              bin name
Options:
  -a, --all           Enable all bin files
	-r <repo>           Enable bin files in the repo
EOF
	# editorconfig-checker-enable
}

# TODO FIX [[ -x $path ]]
# completion() {
# 	shopt -s nullglob
# 	local path filename

# 	for path in "${ONE_DIR}"/enabled/repo/*/bin/"${@: -1}"*; do
# 		if [[ -x $path ]]; then
# 			filename=${path##*/}
# 			basename "${filename%.opt.bash}"
# 		fi
# 	done
# }
. "$ONE_DIR/one-cmds/plugin/action-completion.bash"

create_symlink() {
	local name=$1
	local target=$2
	ln -fs "$target" "$ONE_DIR/enabled/bin/$name"
	printf "Enabled: %b%s%b -> %s\n" "$GREEN" "$name" "$RESET_ALL" "$target"
}

set_exports() {
	if [[ ! -v EXPORTS ]]; then
		return
	fi

	local name=$1

	local file
	for file in "${EXPORTS[@]}"; do
		if [[ -f "$ONE_DIR/data/bin/${name}/$file" ]]; then
			chmod +x "$ONE_DIR/data/bin/${name}/$file"
		else
			print_err "Not found file \"$file\" to export"
		fi
	done
}

enable() {
	local path=$1
	local name=$2

	if [[ -x $path ]]; then
		create_symlink "$name" "$path"
	elif [[ $path == *.opt.bash ]]; then
		check_opt_mod_dep_cmds "$path"
		# Disable first, prevent duplicated module enabled with different priority
		disable_mod "$name"
		download_mod_data "$name" "$path"

		local url bin_name

		# shellcheck disable=1090
		url=$(. "$path" && echo "${URL:-}")
		if [[ -n $url ]]; then
			chmod +x "$ONE_DIR/data/bin/$name/script.bash"

			# shellcheck disable=1090
			while read -r bin_name; do
				create_symlink "$bin_name" "$ONE_DIR/data/bin/$name/script.bash"
			done < <(. "$path" && echo "${EXPORTS[@]}")
		else
			(
				# shellcheck disable=1090
				. "$path"
				set_exports "$name"
				# shellcheck disable=1090
				while read -r bin_name; do
					create_symlink "$bin_name" "$ONE_DIR/data/bin/$name/$bin_name"
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
	local name path filepaths

	# shellcheck source=../../one-cmds/mod.bash
	. "$ONE_DIR/one-cmds/mod.bash"

	local repo=${opts[r]:-}

	shopt -s nullglob

	if [[ ${opts[a]} == true ]]; then
		if [[ -z $repo ]]; then
			for path in "${ONE_DIR}"/enabled/repo/*/bin/*; do
				name=${path##*/}
				name=${name%.opt.bash}
				enable "$path" "$name" || true
			done
		else
			for path in "${ONE_DIR}/enabled/repo/$repo/bin/"*; do
				name=${path##*/}
				name=${name%.opt.bash}
				enable "$path" "$name" || true
			done
		fi
	else
		for name in "${args[@]}"; do
			{
				filepaths=()

				if [[ -z $repo ]]; then
					for path in "${ONE_DIR}"/enabled/repo/*/bin/"$name"{,.opt.bash}; do
						filepaths+=("$path")
					done
				else
					for path in "${ONE_DIR}/enabled/repo/$repo/bin/$name"{,.opt.bash}; do
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
			} || true
		done
	fi
}
