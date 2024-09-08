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

# 	for path in "${ONE_DIR}"/enabled/repos/*/bins/"${@: -1}"*; do
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
		if [[ -f "$ONE_DIR/data/bins/${name}/$file" ]]; then
			chmod +x "$ONE_DIR/data/bins/${name}/$file"
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
			chmod +x "$ONE_DIR/data/bins/$name/script.bash"

			# shellcheck disable=1090
			while read -r bin_name; do
				create_symlink "$bin_name" "$ONE_DIR/data/bins/$name/script.bash"
			done < <(. "$path" && echo "${EXPORTS[@]}")
		else
			(
				# shellcheck disable=1090
				. "$path"
				set_exports "$name"
				# shellcheck disable=1090
				while read -r bin_name; do
					create_symlink "$bin_name" "$ONE_DIR/data/bins/$name/$bin_name"
				done < <(. "$path" && echo "${EXPORTS[@]}")
			)
		fi
	else
		echo "The file is not executable: $path" >&2
		return "$ONE_EX_DATAERR"
	fi
}

# shellcheck disable=2034
declare -A opts_def=(
	['-a --all']='bool'
)

main() {
	local name path paths

	# shellcheck source=../../one-cmds/mod.bash
	. "$ONE_DIR/one-cmds/mod.bash"

	local repo=${opts[r]:-}

	shopt -s nullglob

	if [[ ${opts[a]} == true ]]; then
		if [[ -z $repo ]]; then
			for path in "${ONE_DIR}"/enabled/repos/*/bins/*; do
				name=$(basename "$path" .opt.bash)
				enable "$path" "$name" || true
			done
		else
			for path in "${ONE_DIR}/enabled/repos/$repo/bins/"*; do
				name=$(basename "$path" .opt.bash)
				enable "$path" "$name" || true
			done
		fi
	else
		for name in "${args[@]}"; do
			{
				paths=()

				if [[ -z $repo ]]; then
					for path in "${ONE_DIR}"/enabled/repos/*/bins/"$name"{,.opt.bash}; do
						paths+=("$path")
					done
				else
					for path in "${ONE_DIR}/enabled/repos/$repo/bins/$name"{,.opt.bash}; do
						paths+=("$path")
					done
				fi

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
